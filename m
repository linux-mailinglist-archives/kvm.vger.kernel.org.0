Return-Path: <kvm+bounces-46920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C6CABA648
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:11:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DC4C5012CD
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA122853F1;
	Fri, 16 May 2025 23:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yk8f/R9/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9097283FE9
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436874; cv=none; b=L7NRHKMz1ki2dm+twb8SMKhw9S5ugwZ1rj49i0n/bPlc8g5mLIKUANg5kxU6n1NqWyzv3jur776xRudfixjq2JY/bJa/rpU9B8KtpUBrGykzXkZsD5xE4kIHcQNTtkyNZ4yeZpBJq6dbudKwYbq/0y6oJoyl6o/GF2v0BIiN3PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436874; c=relaxed/simple;
	bh=o6ojYocRmtbY7VPZ4gtOsMEHBN5PEdZ1+pPexJLlixI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qa0eT/qHvusaruQB3+NonE1q6ybWH2R7Lf+cJkSTx++jMDrUwc6QCDR8FUmIC+Cn5eY3P85nILPkunncA9gY280xY43brBNovIlcsQAcOqw8Ui3TW4kSkqZVApGQfarX7XGF8jiSzlTzFE3LewZO9jB1jgAXRDcHaR386X8u+0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yk8f/R9/; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740adfc7babso2175312b3a.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747436871; x=1748041671; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XqyZ4iRfRvJdneUtU4nKjIsAUcubAtsU20tcnlkHRMg=;
        b=yk8f/R9/10/o+V+mqFPbmDTjcc5F3kH2eRc7ZKQFjCqigsT8m4mYxRKzb5271/Miy6
         PMeSWR1xXnfptt+4/BfFFv6uz6I+mDsOgWW9StLlWEffaJMUMKQpTXcjLTlfTMFFIzQs
         GMNR7mFg50btAaK0QyOTtddhS88Wt7jsJIzRHIMrLLvEBFvGkghIpsyVBDSYps3Vcigr
         EW2kaFYx7pb/h1mu9u05Wdy0To5VuKUSUitQOfreTuqAXLbG1/L8VLHOZhpEtT8b27iX
         1m8eyTyXu30SULxKgct+qVQNZ2JzagmouRAc+v4L9Kuz2r/FEVLEJ0oHVnr0X3iUsjUC
         ryRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436871; x=1748041671;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XqyZ4iRfRvJdneUtU4nKjIsAUcubAtsU20tcnlkHRMg=;
        b=nI2gXguaPmfhsX11rac1se70XfOGXuaRS5VGlt7BySp3q+fTM514zsXNIB5QeqOhzb
         7cZfswjHymSqXEbIpEsgn/MOX6XHFq3ljwL/oIKDsbZ4vs5+qEY4koLwz9Cssok0g7D/
         7h1NzJHEj4na2wq9WkyZkzetU6rQns0E6HckLtM6q5JE6W73/Z9FUvKV3BdZ/Q6BAMrK
         tLx9qIaSUCVjMz4PdhT7wYU70uX9tVnZsEKiyv3KE49bT22J8KrgMgy+cq5xiZbJfIkT
         xaX83BPYvx7ty7pxbGx145kzSVqGF6LeIIwfgvkoOwPHcF7I8s58KP11mrI4hqVR5WiC
         VHjQ==
X-Gm-Message-State: AOJu0YzWydf/RF9cnSgLdkzoNWZ2qd+otRH/Sjpq/e6hfbGuiMzXeNA0
	vcfnfCjaIsRqTSq8xKx6bh5PGWjucMkMJm1qKpk5jhENYknS6fghfmurDuur0OGF2vce2BjoA17
	Saq1+ww==
X-Google-Smtp-Source: AGHT+IEOTe7V8s8lR/GhvzQE3vyIAN+8Rwn8cNp7gsJp1bTOQBIyn/LL0P5IEeP4ehuA+V5KmZJSBIdW6ZM=
X-Received: from pjb7.prod.google.com ([2002:a17:90b:2f07:b0:2ff:5516:6add])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:8cc1:b0:216:1ea0:a516
 with SMTP id adf61e73a8af0-21621a0a546mr8110596637.41.1747436871129; Fri, 16
 May 2025 16:07:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 16:07:33 -0700
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516230734.2564775-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516230734.2564775-8-seanjc@google.com>
Subject: [PATCH v2 7/8] irqbypass: Use xarray to track producers and consumers
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Track IRQ bypass producers and consumers using an xarray to avoid the O(2n)
insertion time associated with walking a list to check for duplicate
entries, and to search for an partner.

At low (tens or few hundreds) total producer/consumer counts, using a list
is faster due to the need to allocate backing storage for xarray.  But as
count creeps into the thousands, xarray wins easily, and can provide
several orders of magnitude better latency at high counts.  E.g. hundreds
of nanoseconds vs. hundreds of milliseconds.

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: David Matlack <dmatlack@google.com>
Cc: Like Xu <like.xu.linux@gmail.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217379
Link: https://lore.kernel.org/all/20230801115646.33990-1-likexu@tencent.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/irqbypass.h |  4 ---
 virt/lib/irqbypass.c      | 74 ++++++++++++++++++++-------------------
 2 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index b28197c87483..cd64fcaa88fe 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -33,7 +33,6 @@ struct irq_bypass_consumer;
 
 /**
  * struct irq_bypass_producer - IRQ bypass producer definition
- * @node: IRQ bypass manager private list management
  * @eventfd: eventfd context used to match producers and consumers
  * @consumer: The connected consumer (NULL if no connection)
  * @irq: Linux IRQ number for the producer device
@@ -47,7 +46,6 @@ struct irq_bypass_consumer;
  * for a physical device assigned to a VM.
  */
 struct irq_bypass_producer {
-	struct list_head node;
 	struct eventfd_ctx *eventfd;
 	struct irq_bypass_consumer *consumer;
 	int irq;
@@ -61,7 +59,6 @@ struct irq_bypass_producer {
 
 /**
  * struct irq_bypass_consumer - IRQ bypass consumer definition
- * @node: IRQ bypass manager private list management
  * @eventfd: eventfd context used to match producers and consumers
  * @producer: The connected producer (NULL if no connection)
  * @add_producer: Connect the IRQ consumer to an IRQ producer
@@ -75,7 +72,6 @@ struct irq_bypass_producer {
  * portions of the interrupt handling to the VM.
  */
 struct irq_bypass_consumer {
-	struct list_head node;
 	struct eventfd_ctx *eventfd;
 	struct irq_bypass_producer *producer;
 
diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 828556c081f5..ea888b9203d2 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -22,8 +22,8 @@
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("IRQ bypass manager utility module");
 
-static LIST_HEAD(producers);
-static LIST_HEAD(consumers);
+static DEFINE_XARRAY(producers);
+static DEFINE_XARRAY(consumers);
 static DEFINE_MUTEX(lock);
 
 /* @lock must be held when calling connect */
@@ -86,13 +86,13 @@ static void __disconnect(struct irq_bypass_producer *prod,
  * @producer: pointer to producer structure
  * @eventfd: pointer to the eventfd context associated with the producer
  *
- * Add the provided IRQ producer to the list of producers and connect
- * with any matching eventfd found on the IRQ consumers list.
+ * Add the provided IRQ producer to the set of producers and connect with the
+ * consumer with a matching eventfd, if one exists.
  */
 int irq_bypass_register_producer(struct irq_bypass_producer *producer,
 				 struct eventfd_ctx *eventfd)
 {
-	struct irq_bypass_producer *tmp;
+	unsigned long index = (unsigned long)eventfd;
 	struct irq_bypass_consumer *consumer;
 	int ret;
 
@@ -101,22 +101,20 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer,
 
 	guard(mutex)(&lock);
 
-	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->eventfd == eventfd)
-			return -EBUSY;
-	}
+	ret = xa_insert(&producers, index, producer, GFP_KERNEL);
+	if (ret)
+		return ret;
 
-	list_for_each_entry(consumer, &consumers, node) {
-		if (consumer->eventfd == eventfd) {
-			ret = __connect(producer, consumer);
-			if (ret)
-				return ret;
-			break;
+	consumer = xa_load(&consumers, index);
+	if (consumer) {
+		ret = __connect(producer, consumer);
+		if (ret) {
+			WARN_ON_ONCE(xa_erase(&producers, index) != producer);
+			return ret;
 		}
 	}
 
 	producer->eventfd = eventfd;
-	list_add(&producer->node, &producers);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
@@ -125,11 +123,14 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
  * irq_bypass_unregister_producer - unregister IRQ bypass producer
  * @producer: pointer to producer structure
  *
- * Remove a previously registered IRQ producer from the list of producers
- * and disconnect it from any connected IRQ consumer.
+ * Remove a previously registered IRQ producer (note, it's safe to call this
+ * even if registration was unsuccessful).  Disconnect from the associated
+ * consumer, if one exists.
  */
 void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 {
+	unsigned long index = (unsigned long)producer->eventfd;
+
 	if (!producer->eventfd)
 		return;
 
@@ -138,8 +139,8 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	if (producer->consumer)
 		__disconnect(producer, producer->consumer);
 
+	WARN_ON_ONCE(xa_erase(&producers, index) != producer);
 	producer->eventfd = NULL;
-	list_del(&producer->node);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
 
@@ -148,13 +149,13 @@ EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
  * @consumer: pointer to consumer structure
  * @eventfd: pointer to the eventfd context associated with the consumer
  *
- * Add the provided IRQ consumer to the list of consumers and connect
- * with any matching eventfd found on the IRQ producer list.
+ * Add the provided IRQ consumer to the set of consumers and connect with the
+ * producer with a matching eventfd, if one exists.
  */
 int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
 				 struct eventfd_ctx *eventfd)
 {
-	struct irq_bypass_consumer *tmp;
+	unsigned long index = (unsigned long)eventfd;
 	struct irq_bypass_producer *producer;
 	int ret;
 
@@ -166,22 +167,20 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
 
 	guard(mutex)(&lock);
 
-	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp->eventfd == eventfd)
-			return -EBUSY;
-	}
+	ret = xa_insert(&consumers, index, consumer, GFP_KERNEL);
+	if (ret)
+		return ret;
 
-	list_for_each_entry(producer, &producers, node) {
-		if (producer->eventfd == eventfd) {
-			ret = __connect(producer, consumer);
-			if (ret)
-				return ret;
-			break;
+	producer = xa_load(&producers, index);
+	if (producer) {
+		ret = __connect(producer, consumer);
+		if (ret) {
+			WARN_ON_ONCE(xa_erase(&consumers, index) != consumer);
+			return ret;
 		}
 	}
 
 	consumer->eventfd = eventfd;
-	list_add(&consumer->node, &consumers);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
@@ -190,11 +189,14 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
  * irq_bypass_unregister_consumer - unregister IRQ bypass consumer
  * @consumer: pointer to consumer structure
  *
- * Remove a previously registered IRQ consumer from the list of consumers
- * and disconnect it from any connected IRQ producer.
+ * Remove a previously registered IRQ consumer (note, it's safe to call this
+ * even if registration was unsuccessful).  Disconnect from the associated
+ * producer, if one exists.
  */
 void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 {
+	unsigned long index = (unsigned long)consumer->eventfd;
+
 	if (!consumer->eventfd)
 		return;
 
@@ -203,7 +205,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 	if (consumer->producer)
 		__disconnect(consumer->producer, consumer);
 
+	WARN_ON_ONCE(xa_erase(&consumers, index) != consumer);
 	consumer->eventfd = NULL;
-	list_del(&consumer->node);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
-- 
2.49.0.1112.g889b7c5bd8-goog


