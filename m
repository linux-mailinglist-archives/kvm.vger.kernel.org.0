Return-Path: <kvm+bounces-42762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD19A7C571
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 23:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB1E017C734
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7872236F3;
	Fri,  4 Apr 2025 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pUgg2ASs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D804F222569
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 21:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743801318; cv=none; b=iIo3lDwSqnW8na5vxOmLuIJ6ayaim5wJ7tF2gEItakdSmHab7JfvqEXGAF/E9DJaZ/wHxLgNeiwcEVVGpda3mvneANoBU8fVOpglzYCIMZGPUs28SxE0oWWD09WYD+hlI9V1uHY0uYM0a/wrKaMTo88Ro0xTLwI87Bh5s3ASylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743801318; c=relaxed/simple;
	bh=55FJ1JjxJzEfvUCR32CEmuDHX8lAqsLw2GiyIQNI/6o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ujmJ19UmC/x1JRPebW2S0sj+J/PE0mxOxShrk3cLqLnYWkpSgBktEcrJssESMyeziAo5iAc1Ly1DOj11HlWeovM8EE26N3GxfEJQS1ffa1RJMg2+Zr12ANcGlRsFTa9XKmP06CpsIAkkIPOxdimQOu7qvaDvts5K5ZDz5EfweCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pUgg2ASs; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7395d07a3dcso1954104b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 14:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743801316; x=1744406116; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rEQ6YbC3KUJ/CgEiqQT3YCqcj84Bba/mdzyHX1dIlKQ=;
        b=pUgg2ASs+PFlkWR65Uy9K10Xx7g0Ejg/VlahFor9bYWRMBxbrdzhq56PqySiMY27sf
         oTvNc//FQB72zkuNn7okhP5ZJSjlissTqt4BB9kAM9yrh0QIMWZpvxpmMbV8qHOJ+tm9
         ol2kCaLR+2adiE+Ilutjlx6UcCpdx4kIguHg7B0RmZHY1E1du6vtrZq9QitNHom2kLDz
         Ve7QLGx/QSwnQQ07eSKTkqqPwyWNkH2fIqunCfN6r9CHCz4jdeWp8dr3twFCYYy2WGBK
         ywOxGKhhoYpTEGRfrC8DahsCZU270LHUmicOjeyoEKuDE16/APpmJ5gJmEEstxszUAJO
         l4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743801316; x=1744406116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rEQ6YbC3KUJ/CgEiqQT3YCqcj84Bba/mdzyHX1dIlKQ=;
        b=kWthxyOVwvJk+VRJQigSWPwhVG9HNk6cw8ctjoh5b7mtyHBc6BUII4iUzN5lT96IZv
         uLK5vUfB5zfirxywaAoUN0slhAb+aXAii7RUomy7rS8g6g5DqcXw3SdSn0UrZQEpXYyf
         b6G2233CQlaT9CLjKtgOh2DrbE/cP9vDvXs0tQYCZq6/38x7VJ/JX3GD/LA7My4n0GXi
         CWiasZ3jJoNdnHQK1cQhzcXAmU6pUUvNVImSEsFi50lPckPYuf8HLhJXtp0LI5DzE1Ar
         JeFiMgkJ77WB/QMq96nZVT08xqi0ktpOD8sFhi20Tp2n0SAXsV7sHxvWFG1yt9pnfzt4
         ljKQ==
X-Gm-Message-State: AOJu0YyGN0Uc5NL8hpiRFvOTTVUSZd1cFy3qwRUWfy9DjnlKHTE2mAEn
	O6k97nK1QQPVWy0v1WeMtSp296eTj+YG9dluZXcLZ/WHrh0k0zkB8SVHFiBkLhgFf+uuirjeRAK
	lDg==
X-Google-Smtp-Source: AGHT+IGUhjY+14rjdTSJuxJSMCqc7vFux5KSB5bEGhNoAp0wfj/KsmOLIl+ozqTri6qlvIxKd+yGGWBdPPo=
X-Received: from pgbfe28.prod.google.com ([2002:a05:6a02:289c:b0:af7:3f89:85dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:ce43:b0:1f5:a3e8:64c1
 with SMTP id adf61e73a8af0-20107c3bbadmr6045725637.0.1743801315957; Fri, 04
 Apr 2025 14:15:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 14:14:49 -0700
In-Reply-To: <20250404211449.1443336-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404211449.1443336-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404211449.1443336-8-seanjc@google.com>
Subject: [PATCH 7/7] irqbypass: Use xarray to track producers and consumers
From: Sean Christopherson <seanjc@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Track IRQ bypass produsers and consumers using an xarray to avoid the O(2n)
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
Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217379
Link: https://lore.kernel.org/all/20230801115646.33990-1-likexu@tencent.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/irqbypass.h |  2 --
 virt/lib/irqbypass.c      | 68 +++++++++++++++++++--------------------
 2 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index 6d4e4882843c..e9d9485eaf99 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -46,7 +46,6 @@ struct irq_bypass_consumer;
  * for a physical device assigned to a VM.
  */
 struct irq_bypass_producer {
-	struct list_head node;
 	void *token;
 	struct irq_bypass_consumer *consumer;
 	int irq;
@@ -73,7 +72,6 @@ struct irq_bypass_producer {
  * portions of the interrupt handling to the VM.
  */
 struct irq_bypass_consumer {
-	struct list_head node;
 	void *token;
 	struct irq_bypass_producer *producer;
 
diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 261ef77f6364..3f7734e63d0f 100644
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
- * with any matching token found on the IRQ consumers list.
+ * Add the provided IRQ producer to the set of producers and connect with the
+ * consumer with a matching token, if one exists.
  */
 int irq_bypass_register_producer(struct irq_bypass_producer *producer,
 				 struct eventfd_ctx *eventfd)
 {
-	struct irq_bypass_producer *tmp;
+	unsigned long token = (unsigned long)eventfd;
 	struct irq_bypass_consumer *consumer;
 	int ret;
 
@@ -101,22 +101,20 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer,
 
 	guard(mutex)(&lock);
 
-	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token == eventfd)
-			return -EBUSY;
-	}
+	ret = xa_insert(&producers, token, producer, GFP_KERNEL);
+	if (ret)
+		return ret;
 
-	list_for_each_entry(consumer, &consumers, node) {
-		if (consumer->token == eventfd) {
-			ret = __connect(producer, consumer);
-			if (ret)
-				return ret;
-			break;
+	consumer = xa_load(&consumers, token);
+	if (consumer) {
+		ret = __connect(producer, consumer);
+		if (ret) {
+			WARN_ON_ONCE(xa_erase(&producers, token) != producer);
+			return ret;
 		}
 	}
 
 	producer->token = eventfd;
-	list_add(&producer->node, &producers);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
@@ -125,8 +123,9 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
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
@@ -138,8 +137,8 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	if (producer->consumer)
 		__disconnect(producer, producer->consumer);
 
+	WARN_ON_ONCE(xa_erase(&producers, (unsigned long)producer->token) != producer);
 	producer->token = NULL;
-	list_del(&producer->node);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
 
@@ -148,11 +147,13 @@ EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
  * @consumer: pointer to consumer structure
  * @eventfd: pointer to the eventfd context associated with the consumer
  *
+ * Add the provided IRQ consumer to the set of consumer and connect with the
+ * producer with a matching token, if one exists.
  */
 int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
 				 struct eventfd_ctx *eventfd)
 {
-	struct irq_bypass_consumer *tmp;
+	unsigned long token = (unsigned long)eventfd;
 	struct irq_bypass_producer *producer;
 	int ret;
 
@@ -164,22 +165,20 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
 
 	guard(mutex)(&lock);
 
-	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp->token == eventfd || tmp == consumer)
-			return -EBUSY;
-	}
+	ret = xa_insert(&consumers, token, consumer, GFP_KERNEL);
+	if (ret)
+		return ret;
 
-	list_for_each_entry(producer, &producers, node) {
-		if (producer->token == eventfd) {
-			ret = __connect(producer, consumer);
-			if (ret)
-				return ret;
-			break;
+	producer = xa_load(&producers, token);
+	if (producer) {
+		ret = __connect(producer, consumer);
+		if (ret) {
+			WARN_ON_ONCE(xa_erase(&consumers, token) != consumer);
+			return ret;
 		}
 	}
 
 	consumer->token = eventfd;
-	list_add(&consumer->node, &consumers);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
@@ -188,8 +187,9 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
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
@@ -201,7 +201,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 	if (consumer->producer)
 		__disconnect(consumer->producer, consumer);
 
+	WARN_ON_ONCE(xa_erase(&consumers, (unsigned long)consumer->token) != consumer);
 	consumer->token = NULL;
-	list_del(&consumer->node);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
-- 
2.49.0.504.g3bcea36a83-goog


