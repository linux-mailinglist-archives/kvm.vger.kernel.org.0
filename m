Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2896A6563
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 03:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCACSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 21:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCACSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 21:18:43 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260BB38657;
        Tue, 28 Feb 2023 18:18:36 -0800 (PST)
Received: from kwepemi100025.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PRHs63h4XznWLj;
        Wed,  1 Mar 2023 10:15:54 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 kwepemi100025.china.huawei.com (7.221.188.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 10:18:32 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <pbonzini@redhat.com>, <alex.williamson@redhat.com>,
        <mst@redhat.com>, <jasowang@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <eperezma@redhat.com>, <arei.gonglei@huawei.com>,
        <yechuan@huawei.com>, Longpeng <longpeng2@huawei.com>
Subject: [PATCH] irqbypass: convert producers/consumers single linked list to hlist
Date:   Wed, 1 Mar 2023 10:18:30 +0800
Message-ID: <20230301021830.880-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi100025.china.huawei.com (7.221.188.158)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

There are no functional changes, but this converts the producers/consumers
single linked list to a hash list. This can speed up the lookup if the VM
has many irqfds.

This can save about 15ms when assigning all IRQFS to a QEMU/KVM VM with 1K
irqfds. The overhead would be higher if there were much more irqfds in the
HOST.

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 include/linux/irqbypass.h |   8 +--
 virt/lib/irqbypass.c      | 131 ++++++++++++++++++++++++--------------
 2 files changed, 86 insertions(+), 53 deletions(-)

diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index 9bdb2a781841..9039b5f6218d 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -30,7 +30,7 @@ struct irq_bypass_consumer;
 
 /**
  * struct irq_bypass_producer - IRQ bypass producer definition
- * @node: IRQ bypass manager private list management
+ * @node: IRQ bypass manager private hash list management
  * @token: opaque token to match between producer and consumer (non-NULL)
  * @irq: Linux IRQ number for the producer device
  * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
@@ -43,7 +43,7 @@ struct irq_bypass_consumer;
  * for a physical device assigned to a VM.
  */
 struct irq_bypass_producer {
-	struct list_head node;
+	struct hlist_node node;
 	void *token;
 	int irq;
 	int (*add_consumer)(struct irq_bypass_producer *,
@@ -56,7 +56,7 @@ struct irq_bypass_producer {
 
 /**
  * struct irq_bypass_consumer - IRQ bypass consumer definition
- * @node: IRQ bypass manager private list management
+ * @node: IRQ bypass manager private hash list management
  * @token: opaque token to match between producer and consumer (non-NULL)
  * @add_producer: Connect the IRQ consumer to an IRQ producer
  * @del_producer: Disconnect the IRQ consumer from an IRQ producer
@@ -69,7 +69,7 @@ struct irq_bypass_producer {
  * portions of the interrupt handling to the VM.
  */
 struct irq_bypass_consumer {
-	struct list_head node;
+	struct hlist_node node;
 	void *token;
 	int (*add_producer)(struct irq_bypass_consumer *,
 			    struct irq_bypass_producer *);
diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 28fda42e471b..8096d2daab01 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -18,14 +18,59 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/hashtable.h>
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("IRQ bypass manager utility module");
 
-static LIST_HEAD(producers);
-static LIST_HEAD(consumers);
+/*
+ * hash table for produces/consumers. This improve the performace to find
+ * an existing producer/consumer.
+ */
+#define PRODUCERS_HASH_BITS	9
+#define CONSUMERS_HASH_BITS	9
+static DEFINE_HASHTABLE(producers, PRODUCERS_HASH_BITS);
+static DEFINE_HASHTABLE(consumers, CONSUMERS_HASH_BITS);
 static DEFINE_MUTEX(lock);
 
+
+/* @lock must be held */
+static struct irq_bypass_producer *find_producer_by_token(void *token)
+{
+	struct irq_bypass_producer *producer;
+
+	hash_for_each_possible(producers, producer, node, (uint64_t)token)
+		if (producer->token == token)
+			return producer;
+
+	return NULL;
+}
+
+/* @lock must be held */
+static struct irq_bypass_consumer *find_consumer_by_token(void *token)
+{
+	struct irq_bypass_consumer *consumer;
+
+	hash_for_each_possible(producers, consumer, node, (uint64_t)token)
+		if (consumer->token == token)
+			return consumer;
+
+	return NULL;
+}
+
+/* @lock must be held */
+static bool has_consumer(struct irq_bypass_consumer *consumer)
+{
+	struct irq_bypass_consumer *tmp;
+	int bkt;
+
+	hash_for_each(consumers, bkt, tmp, node)
+		if (tmp == consumer)
+			return true;
+
+	return false;
+}
+
 /* @lock must be held when calling connect */
 static int __connect(struct irq_bypass_producer *prod,
 		     struct irq_bypass_consumer *cons)
@@ -97,23 +142,20 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 
 	mutex_lock(&lock);
 
-	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token == producer->token) {
-			ret = -EBUSY;
-			goto out_err;
-		}
+	tmp = find_producer_by_token(producer->token);
+	if (tmp) {
+		ret = -EBUSY;
+		goto out_err;
 	}
 
-	list_for_each_entry(consumer, &consumers, node) {
-		if (consumer->token == producer->token) {
-			ret = __connect(producer, consumer);
-			if (ret)
-				goto out_err;
-			break;
-		}
+	consumer = find_consumer_by_token(producer->token);
+	if (consumer) {
+		ret = __connect(producer, consumer);
+		if (ret)
+			goto out_err;
 	}
 
-	list_add(&producer->node, &producers);
+	hash_add(producers, &producer->node, (uint64_t)producer->token);
 
 	mutex_unlock(&lock);
 
@@ -147,22 +189,18 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 
 	mutex_lock(&lock);
 
-	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token != producer->token)
-			continue;
+	tmp = find_producer_by_token(producer->token);
+	if (!tmp)
+		goto out;
 
-		list_for_each_entry(consumer, &consumers, node) {
-			if (consumer->token == producer->token) {
-				__disconnect(producer, consumer);
-				break;
-			}
-		}
+	consumer = find_consumer_by_token(producer->token);
+	if (consumer)
+		__disconnect(producer, consumer);
 
-		list_del(&producer->node);
-		module_put(THIS_MODULE);
-		break;
-	}
+	hash_del(&producer->node);
+	module_put(THIS_MODULE);
 
+out:
 	mutex_unlock(&lock);
 
 	module_put(THIS_MODULE);
@@ -193,23 +231,20 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 
 	mutex_lock(&lock);
 
-	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp->token == consumer->token || tmp == consumer) {
-			ret = -EBUSY;
-			goto out_err;
-		}
+	tmp = find_consumer_by_token(consumer->token);
+	if (tmp || has_consumer(consumer)) {
+		ret = -EBUSY;
+		goto out_err;
 	}
 
-	list_for_each_entry(producer, &producers, node) {
-		if (producer->token == consumer->token) {
-			ret = __connect(producer, consumer);
-			if (ret)
-				goto out_err;
-			break;
-		}
+	producer = find_producer_by_token(consumer->token);
+	if (producer) {
+		ret = __connect(producer, consumer);
+		if (ret)
+			goto out_err;
 	}
 
-	list_add(&consumer->node, &consumers);
+	hash_add(consumers, &consumer->node, (uint64_t)consumer->token);
 
 	mutex_unlock(&lock);
 
@@ -232,6 +267,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 {
 	struct irq_bypass_consumer *tmp;
 	struct irq_bypass_producer *producer;
+	int bkt;
 
 	if (!consumer->token)
 		return;
@@ -243,18 +279,15 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 
 	mutex_lock(&lock);
 
-	list_for_each_entry(tmp, &consumers, node) {
+	hash_for_each(consumers, bkt, tmp, node) {
 		if (tmp != consumer)
 			continue;
 
-		list_for_each_entry(producer, &producers, node) {
-			if (producer->token == consumer->token) {
-				__disconnect(producer, consumer);
-				break;
-			}
-		}
+		producer = find_producer_by_token(consumer->token);
+		if (producer)
+			__disconnect(producer, consumer);
 
-		list_del(&consumer->node);
+		hash_del(&consumer->node);
 		module_put(THIS_MODULE);
 		break;
 	}
-- 
2.23.0

