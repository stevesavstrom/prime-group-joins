-- Tasks

-- 1. Get all customers and their addresses.
SELECT *
FROM "customers"
JOIN "addresses" ON "addresses".id = "customers".id;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT "orders".id, "orders".order_date, "line_items".quantity, "products".description  
FROM "orders"
JOIN "line_items" ON "orders".id = "line_items".order_id
JOIN "products" ON "line_items".product_id = "products".id;

-- 3. Which warehouses have cheetos?
SELECT "products".description, "warehouse".warehouse
FROM "products"
JOIN "warehouse_product" ON "products".id = "warehouse_product".product_id
JOIN "warehouse" ON "warehouse_product".warehouse_id = "warehouse".id
WHERE "products".description = 'cheetos';

-- 4. Which warehouses have diet pepsi?
SELECT "products".description, "warehouse".warehouse
FROM "products"
JOIN "warehouse_product" ON "products".id = "warehouse_product".product_id
JOIN "warehouse" ON "warehouse_product".warehouse_id = "warehouse".id
WHERE "products".description = 'diet pepsi';

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT count(*), "customers".first_name, "customers".last_name
FROM "orders"
JOIN "addresses" ON "orders".address_id = "addresses".id
JOIN "customers" ON "customers".id = "addresses".customer_id
GROUP BY "customers".id;

-- Duy's approach
SELECT count(*), CONCAT("customers".first_name, ' ', "customers".last_name) AS "customers_order"
FROM "customers"
JOIN "addresses" ON "customers".id = "addresses".customer_id
JOIN "orders" ON "orders".address_id = "addresses".id
GROUP BY "customers_order";

-- 6. How many customers do we have?
SELECT COUNT(*)
FROM "customer"

-- 7. How many products do we carry?
SELECT COUNT(*)
FROM "products";

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT SUM("warehouse_product".on_hand), "products".description
FROM "warehouse_product"
JOIN "products" ON "products".id = "warehouse_product".product_id
WHERE "products".description = 'diet pepsi'
GROUP BY "products".description;

-- ## Stretch
-- 9. How much was the total cost for each order?
SELECT SUM("line_items".quantity * "products".unit_price), "orders".id
FROM "orders"
JOIN "line_items" ON "orders".id = "line_items".order_id
JOIN "products" ON "line_items".product_id = "products".id
GROUP BY "orders".id;

-- 10. How much has each customer spent in total?
SELECT SUM(products.unit_price*line_items.quantity) AS total_cost, customers.last_name, customers.first_name
FROM line_items
JOIN products ON "products".id = "line_items".product_id
JOIN orders ON "orders".id = "line_items".order_id
JOIN addresses ON "addresses".id = "orders".address_id
JOIN customers ON "customers".id = "addresses".customer_id
GROUP BY "customers".last_name, "customers".first_name;

-- Another way
SELECT SUM(products.unit_price*line_items.quantity) AS total_cost, customers.last_name, customers.first_name
FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON products.id = line_items.product_id
JOIN addresses ON addresses.id = orders.address_id
JOIN customers ON customers.id = addresses.customer_id
GROUP BY customers.last_name, customers.first_name;

-- starting from customers -- linear progression through flow chart
SELECT SUM(products.unit_price*line_items.quantity) AS total_cost, customers.last_name, customers.first_name
FROM customers
JOIN addresses ON addresses.customer_id = customers.id
JOIN orders ON addresses.id = orders.address_id
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON products.id = line_items.product_id
GROUP BY customers.last_name, customers.first_name;

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).