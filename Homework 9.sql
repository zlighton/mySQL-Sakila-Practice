-- 1a --
SELECT first_name, last_name 
FROM sakila.actor;

-- 1b --
SELECT CONCAT(first_name, ' ', last_name) 
AS actor_name 
FROM sakila.actor;

-- 2a --
SELECT actor_id, first_name, last_name 
FROM sakila.actor
WHERE first_name LIKE "Joe";

-- 2b --
SELECT * 
FROM sakila.actor
WHERE last_name LIKE "%GEN%";

-- 2c --
SELECT last_name, first_name 
FROM sakila.actor
WHERE last_name LIKE "%LI%";

-- 2d --
SELECT country_id, country 
FROM sakila.country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a --
ALTER TABLE actor
ADD COLUMN description BLOB NOT NULL;

-- 3b --
ALTER TABLE actor
DROP COLUMN description;

-- 4a --
SELECT last_name,
COUNT(*) FROM sakila.actor
GROUP BY last_name;

-- 4b --
SELECT last_name, COUNT(*)
FROM sakila.actor
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 4c --
UPDATE sakila.actor 
SET first_name = "HARPO" 
WHERE first_name = "GROUCHO"
AND last_name = "WILLIAMS";

-- 4d* Error 1175 - safe update mode --
-- fixed by finding value of primary key then changing using that --
SELECT * FROM sakila.actor WHERE first_name = "HARPO";
UPDATE sakila.actor
SET first_name = "GROUCHO"
WHERE actor_id = 172;

-- 5a --
DESCRIBE sakila.address;

-- 6a --
SELECT first_name, last_name, address
FROM sakila.actor
JOIN sakila.address ON actor.actor_id = address.address_id;

-- 6b --
SELECT first_name, last_name, payment_date 
FROM sakila.staff
JOIN sakila.payment ON staff.staff_id = payment.staff_id
WHERE payment_date LIKE "2005%";

-- 6c --
SELECT title, count(*)
FROM sakila.film
INNER JOIN sakila.film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

-- 6d --
SELECT title, count(*)
FROM sakila.film
JOIN sakila.inventory ON film.film_id = inventory.film_id
WHERE title = "HUNCHBACK IMPOSSIBLE";

-- 6e --
SELECT CONCAT(first_name, ' ', last_name) 
AS name, SUM(amount)
FROM sakila.payment
JOIN sakila.customer ON payment.customer_id = customer.customer_id
GROUP BY name;

-- 7a --
SELECT title
FROM sakila.film
WHERE (title LIKE 'K%' OR title LIKE 'Q%') 
AND language_id=(SELECT language_id FROM sakila.language WHERE name='English');

-- 7b --
SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id
	IN (SELECT actor_id 
    FROM film_actor 
    WHERE film_id 
		IN (SELECT film_id 
        FROM film 
        WHERE title='ALONE TRIP'));

-- 7c --
SELECT first_name, last_name, email 
FROM sakila.customer cus
JOIN sakila.address adr ON (cus.address_id = adr.address_id)
JOIN sakila.city cit ON (adr.city_id=cit.city_id)
JOIN sakila.country ctr ON (ctr.country_id=ctr.country_id);

-- 7d --
SELECT title 
FROM sakila.film fil
JOIN sakila.film_category fca on (fil.film_id=fca.film_id)
JOIN sakila.category cat on (fca.category_id=cat.category_id);

-- 7e --
SELECT title, COUNT(fil.film_id)
FROM sakila.film fil
JOIN sakila.inventory inv ON (fil.film_id= inv.film_id)
JOIN sakila.rental ren ON (inv.inventory_id=ren.inventory_id)
GROUP BY title ORDER BY COUNT(fil.film_id) DESC;

-- 7f --
SELECT stf.store_id, SUM(pay.amount) 
FROM sakila.payment pay
JOIN sakila.staff stf ON (pay.staff_id=stf.staff_id)
GROUP BY store_id;

-- 7g --
SELECT store_id, city, country 
FROM sakila.store str
JOIN sakila.address adr ON (str.address_id=adr.address_id)
JOIN sakila.city cit ON (adr.city_id=cit.city_id)
JOIN sakila.country ctr ON (cit.country_id=ctr.country_id);

-- 7h --
SELECT cat.name, SUM(pay.amount) 
FROM category cat
JOIN sakila.film_category fca ON (cat.category_id=fca.category_id)
JOIN sakila.inventory inv ON (fca.film_id=inv.film_id)
JOIN sakila.rental ren ON (inv.inventory_id=ren.inventory_id)
JOIN sakila.payment pay ON (ren.rental_id=pay.rental_id)
GROUP BY cat.name ORDER BY SUM(pay.amount) LIMIT 5;

-- 8a --
CREATE VIEW topFiveGrossingGenres AS
SELECT cat.name, SUM(pay.amount) 
FROM category cat
JOIN sakila.film_category fca ON (cat.category_id=fca.category_id)
JOIN sakila.inventory inv ON (fca.film_id=inv.film_id)
JOIN sakila.rental ren ON (inv.inventory_id=ren.inventory_id)
JOIN sakila.payment pay ON (ren.rental_id=pay.rental_id)
GROUP BY cat.name ORDER BY SUM(pay.amount) LIMIT 5;

-- 8b --
SELECT * FROM topFiveGrossingGenres;

-- 8c --
DROP VIEW topFiveGrossingGenres;
