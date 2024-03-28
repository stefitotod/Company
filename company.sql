DROP DATABASE company;
CREATE DATABASE company;
USE company;

CREATE TABLE company(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE products(
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    type ENUM('автокаско', 'гражданска отговорност', 'злополука', 'имущество', 'живот') NOT NULL,
    company_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (company_id) REFERENCES company(id)
);

CREATE TABLE employees(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(255) NOT NULL
);

CREATE TABLE salary_payment(
    id INT AUTO_INCREMENT PRIMARY KEY,
    amount DOUBLE NOT NULL,
    bonus DOUBLE,
    date_time DATETIME NOT NULL,
    employee_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE clients( 
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL, 
    egn VARCHAR(255) UNIQUE NOT NULL,
    phone varchar(13) UNIQUE NOT NULL
);

CREATE TABLE policy(
    id INT AUTO_INCREMENT PRIMARY KEY,
    sum DOUBLE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    client_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (client_id) REFERENCES clients(id),
    product_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (product_id) REFERENCES products(id),
    employee_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (employee_id) REFERENCES employees(id)
);

INSERT INTO company (name) VALUES ('Company A'), ('Company B'), ('Company C');

INSERT INTO employees (name, position) VALUES 
('John Doe', 'Manager'),
('Jane Smith', 'Sales Representative'),
('Michael Johnson', 'Accountant');

INSERT INTO clients (name, email, egn, phone) VALUES 
('Client 1', 'client1@example.com', '1234567890', '1234567890'),
('Client 2', 'client2@example.com', '0987654321', '0987654321');

INSERT INTO products (description, type, company_id) VALUES 
('Product 1 Description', 'автокаско', 1),
('Product 2 Description', 'гражданска отговорност', 2),
('Product 3 Description', 'злополука', 3);

INSERT INTO policy (sum, start_date, end_date, client_id, product_id, employee_id) VALUES 
(1000.00, '2024-01-01', '2024-12-31', 1, 1, 1),
(2000.00, '2024-02-01', '2024-12-31', 2, 2, 2);

INSERT INTO salary_payment (amount, bonus, date_time, employee_id) VALUES 
(2000.00, NULL, '2024-02-15 09:00:00', 1),
(2500.00, 150.00, '2024-02-15 09:00:00', 2);

CREATE VIEW client_info AS
SELECT clients.name AS client_name, products.type AS product_type, company.name AS company_name, employees.id AS employee_id
FROM clients 
JOIN policy ON clients.id = policy.client_id
JOIN products ON policy.product_id = products.id
JOIN company ON products.company_id = company.id
JOIN employees ON policy.employee_id = employees.id
WHERE products.type = 'автокаско'
ORDER BY policy.id DESC -- ASC
LIMIT 100;

SELECT employees.name, salary_payment.bonus
FROM employees
LEFT JOIN salary_payment ON employees.id = salary_payment.employee_id
WHERE month(salary_payment.date_time) = 2 AND year(salary_payment.date_time) = 2024
ORDER BY employees.name;

SELECT SUM(policy.sum) as all_sum, employees.name
FROM employees
JOIN policy ON employees.id = policy.employee_id
JOIN products ON policy.product_id = products.id
WHERE products.type = 'гражданска отговорност'
GROUP BY employees.name, employees.id
HAVING (all_sum) > (
    SELECT AVG(sum)
    FROM policy
    JOIN employees ON policy.employee_id = policy.id
);

