Return-Path: <kvm+bounces-46916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED896ABA634
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D770D175A5A
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42A827FD47;
	Fri, 16 May 2025 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qeM2KjK1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E09928134F
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436866; cv=none; b=Y+1lB1y/mjP6asv4XnwPFdkYfhrc/Q5BSsHSzbg6QQGf4iq6ccgzCtVD4xrjA7wXicpPGvnyMRh9Rju/rMMcbNlS/pxb1sklPxllN2556A2loqaFG3hS7VGFrVJc+wUaJsul6GHpk+Ls07Bi8x52f6r455edyYY+G8HFRvC3giU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436866; c=relaxed/simple;
	bh=3tOfy0wPMzmmtgf16NbWP4Jo1oouiVgnLtYKdu2JdA8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i7Q/nxm0j5qeAXEGyHkfeqzwnPahOI4nRgIDaaj51AaCxlJikQwQl2JorIU0ZX8IvTPDSSC50YXkDyv8cW2DS+jKEoEJmjb0qRG0/9Ck7FsPkRGedJiqY5Y2pgIf1O5KilsrGeF+hs2cpFWA//Jj0MuOJ5koKkPfL3MDACzxGm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qeM2KjK1; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742951722b3so2152261b3a.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747436863; x=1748041663; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8ro5pucdXOXxQU01a4cvnDr2WLudpDkRjBvhYSrYOz0=;
        b=qeM2KjK1AGeOG36OoO3gmjhu7u6xb6qFo5F6OoNB27v58xzgwBfmxCetFDR4BM07SS
         ASTVaCJl0xXcg9frD4OPrSbna8W7BeKPB135ZtjFksl3hKoROFgQM/GZ9zV/Mp6x907A
         4JDYzawIv+I3fdnJ/7iPdVluWbRkbti+ynqXuMcgD4P73z3CrBBGhE3aXkntnz2I/m6X
         FTopR2jbvjEEwfZiXVWNINsVpk0UvjI6MMGHo3xTCkvbGyc4P6lsawYAUTwRtgJsox2Z
         UC+rzlUaasl5PJob62xax8bm1X34CNNRp51F7CiUgDUYtCRvBK6M2C7XdYS8AJGg/Hdi
         uSEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436863; x=1748041663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ro5pucdXOXxQU01a4cvnDr2WLudpDkRjBvhYSrYOz0=;
        b=kXeHvZZFOJPcweDtTeXyRDwIgQlOz9N/U2JpiyxlZZ6M6TIhYMp3hI37coiRzyBxcD
         anXn4uZawyamQbvOLlWlnrFi4SFuIBjLNT3ch8mBMAn7lCExqZW+NHjaCyQFC9OLQhwj
         BZVhK4I24VjvJrNlsGmL4ubJiIy2vO0nIxugGSEpG8s3Fu4qtp9JNq50MPNLGKZgTBUz
         /K4hdj5/Y2JnneHeyp/VbZIrq+twifKB9a3vqnX1MvRo/+cATEp0iOO4tSwd3NwOsiK1
         vg/0b2t+hs0+H0l2N5CJZ/7Jm+dbBDBmwp4rG3I6yv2DxronSMgvCOOTth6KOz7ov4ME
         JmMw==
X-Gm-Message-State: AOJu0Yx/vUbIVQRU1ZsIr4KqlcVnUXP/Xmx+foXu2aBbi6auGfDdHLFp
	2AowljAMb3cyNab2IIIPT9G3GokmXWjhtuHH0CUJ9gzL8xF90hYWN1XLiJJZ2x7iJRPCY0Sm+dt
	qry1Tqg==
X-Google-Smtp-Source: AGHT+IHuBd6leiNTcn0nzvJq72WI9YGScV8jwRnPwk8riDF4/dQUj4oqlwemFkXW+9J9DbTmCWfYlt852cA=
X-Received: from pfbkm11.prod.google.com ([2002:a05:6a00:3c4b:b0:740:813:f7bb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b56:b0:740:a52f:a126
 with SMTP id d2e1a72fcca58-742accc52cbmr5169945b3a.9.1747436862766; Fri, 16
 May 2025 16:07:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 16:07:29 -0700
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516230734.2564775-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516230734.2564775-4-seanjc@google.com>
Subject: [PATCH v2 3/8] irqbypass: Take ownership of producer/consumer token tracking
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

Move ownership of IRQ bypass token tracking into irqbypass.ko, and
explicitly require callers to pass an eventfd_ctx structure instead of a
completely opaque token.  Relying on producers and consumers to set the
token appropriately is error prone, and hiding the fact that the token must
be an eventfd_ctx pointer (for all intents and purposes) unnecessarily
obfuscates the code and makes it more brittle.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c                |  4 +--
 drivers/vfio/pci/vfio_pci_intrs.c |  9 +++----
 drivers/vhost/vdpa.c              |  8 +++---
 include/linux/irqbypass.h         | 35 +++++++++++++-----------
 virt/kvm/eventfd.c                |  7 +++--
 virt/lib/irqbypass.c              | 44 ++++++++++++++++++++-----------
 6 files changed, 58 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f9f798f286ce..c219aab2187f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13667,8 +13667,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
 					   prod->irq, irqfd->gsi, 0);
 	if (ret)
-		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
-		       " fails: %d\n", irqfd->consumer.token, ret);
+		printk(KERN_INFO "irq bypass consumer (eventfd %p) unregistration"
+		       " fails: %d\n", irqfd->consumer.eventfd, ret);
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 565966351dfa..d87fe116762a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -505,15 +505,12 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (ret)
 		goto out_put_eventfd_ctx;
 
-	ctx->producer.token = trigger;
 	ctx->producer.irq = irq;
-	ret = irq_bypass_register_producer(&ctx->producer);
+	ret = irq_bypass_register_producer(&ctx->producer, trigger);
 	if (unlikely(ret)) {
 		dev_info(&pdev->dev,
-		"irq bypass producer (token %p) registration fails: %d\n",
-		ctx->producer.token, ret);
-
-		ctx->producer.token = NULL;
+		"irq bypass producer (eventfd %p) registration fails: %d\n",
+		trigger, ret);
 	}
 	ctx->trigger = trigger;
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 5a49b5a6d496..7b265ffda697 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -213,10 +213,10 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 		return;
 
 	vq->call_ctx.producer.irq = irq;
-	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
+	ret = irq_bypass_register_producer(&vq->call_ctx.producer, vq->call_ctx.ctx);
 	if (unlikely(ret))
-		dev_info(&v->dev, "vq %u, irq bypass producer (token %p) registration fails, ret =  %d\n",
-			 qid, vq->call_ctx.producer.token, ret);
+		dev_info(&v->dev, "vq %u, irq bypass producer (eventfd %p) registration fails, ret =  %d\n",
+			 qid, vq->call_ctx.ctx, ret);
 }
 
 static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
@@ -712,7 +712,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			if (ops->get_status(vdpa) &
 			    VIRTIO_CONFIG_S_DRIVER_OK)
 				vhost_vdpa_unsetup_vq_irq(v, idx);
-			vq->call_ctx.producer.token = NULL;
 		}
 		break;
 	}
@@ -753,7 +752,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			cb.callback = vhost_vdpa_virtqueue_cb;
 			cb.private = vq;
 			cb.trigger = vq->call_ctx.ctx;
-			vq->call_ctx.producer.token = vq->call_ctx.ctx;
 			if (ops->get_status(vdpa) &
 			    VIRTIO_CONFIG_S_DRIVER_OK)
 				vhost_vdpa_setup_vq_irq(v, idx);
diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index 9bdb2a781841..1b57d15ac4cf 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -10,6 +10,7 @@
 
 #include <linux/list.h>
 
+struct eventfd_ctx;
 struct irq_bypass_consumer;
 
 /*
@@ -18,20 +19,20 @@ struct irq_bypass_consumer;
  * The IRQ bypass manager is a simple set of lists and callbacks that allows
  * IRQ producers (ex. physical interrupt sources) to be matched to IRQ
  * consumers (ex. virtualization hardware that allows IRQ bypass or offload)
- * via a shared token (ex. eventfd_ctx).  Producers and consumers register
- * independently.  When a token match is found, the optional @stop callback
- * will be called for each participant.  The pair will then be connected via
- * the @add_* callbacks, and finally the optional @start callback will allow
- * any final coordination.  When either participant is unregistered, the
- * process is repeated using the @del_* callbacks in place of the @add_*
- * callbacks.  Match tokens must be unique per producer/consumer, 1:N pairings
- * are not supported.
+ * via a shared eventfd_ctx.  Producers and consumers register independently.
+ * When a producer and consumer are paired, i.e. an eventfd match is found, the
+ * optional @stop callback will be called for each participant.  The pair will
+ * then be connected via the @add_* callbacks, and finally the optional @start
+ * callback will allow any final coordination.  When either participant is
+ * unregistered, the process is repeated using the @del_* callbacks in place of
+ * the @add_* callbacks.  eventfds must be unique per producer/consumer, 1:N
+ * pairings are not supported.
  */
 
 /**
  * struct irq_bypass_producer - IRQ bypass producer definition
  * @node: IRQ bypass manager private list management
- * @token: opaque token to match between producer and consumer (non-NULL)
+ * @eventfd: eventfd context used to match producers and consumers
  * @irq: Linux IRQ number for the producer device
  * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
  * @del_consumer: Disconnect the IRQ producer from an IRQ consumer (optional)
@@ -44,7 +45,7 @@ struct irq_bypass_consumer;
  */
 struct irq_bypass_producer {
 	struct list_head node;
-	void *token;
+	struct eventfd_ctx *eventfd;
 	int irq;
 	int (*add_consumer)(struct irq_bypass_producer *,
 			    struct irq_bypass_consumer *);
@@ -57,7 +58,7 @@ struct irq_bypass_producer {
 /**
  * struct irq_bypass_consumer - IRQ bypass consumer definition
  * @node: IRQ bypass manager private list management
- * @token: opaque token to match between producer and consumer (non-NULL)
+ * @eventfd: eventfd context used to match producers and consumers
  * @add_producer: Connect the IRQ consumer to an IRQ producer
  * @del_producer: Disconnect the IRQ consumer from an IRQ producer
  * @stop: Perform any quiesce operations necessary prior to add/del (optional)
@@ -70,7 +71,7 @@ struct irq_bypass_producer {
  */
 struct irq_bypass_consumer {
 	struct list_head node;
-	void *token;
+	struct eventfd_ctx *eventfd;
 	int (*add_producer)(struct irq_bypass_consumer *,
 			    struct irq_bypass_producer *);
 	void (*del_producer)(struct irq_bypass_consumer *,
@@ -79,9 +80,11 @@ struct irq_bypass_consumer {
 	void (*start)(struct irq_bypass_consumer *);
 };
 
-int irq_bypass_register_producer(struct irq_bypass_producer *);
-void irq_bypass_unregister_producer(struct irq_bypass_producer *);
-int irq_bypass_register_consumer(struct irq_bypass_consumer *);
-void irq_bypass_unregister_consumer(struct irq_bypass_consumer *);
+int irq_bypass_register_producer(struct irq_bypass_producer *producer,
+				 struct eventfd_ctx *eventfd);
+void irq_bypass_unregister_producer(struct irq_bypass_producer *producer);
+int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
+				 struct eventfd_ctx *eventfd);
+void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer);
 
 #endif /* IRQBYPASS_H */
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 11e5d1e3f12e..5bc6abe30748 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -426,15 +426,14 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 	if (kvm_arch_has_irq_bypass()) {
-		irqfd->consumer.token = (void *)irqfd->eventfd;
 		irqfd->consumer.add_producer = kvm_arch_irq_bypass_add_producer;
 		irqfd->consumer.del_producer = kvm_arch_irq_bypass_del_producer;
 		irqfd->consumer.stop = kvm_arch_irq_bypass_stop;
 		irqfd->consumer.start = kvm_arch_irq_bypass_start;
-		ret = irq_bypass_register_consumer(&irqfd->consumer);
+		ret = irq_bypass_register_consumer(&irqfd->consumer, irqfd->eventfd);
 		if (ret)
-			pr_info("irq bypass consumer (token %p) registration fails: %d\n",
-				irqfd->consumer.token, ret);
+			pr_info("irq bypass consumer (eventfd %p) registration fails: %d\n",
+				irqfd->eventfd, ret);
 	}
 #endif
 
diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 28a4d933569a..e8d7c420db52 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -77,30 +77,32 @@ static void __disconnect(struct irq_bypass_producer *prod,
 /**
  * irq_bypass_register_producer - register IRQ bypass producer
  * @producer: pointer to producer structure
+ * @eventfd: pointer to the eventfd context associated with the producer
  *
  * Add the provided IRQ producer to the list of producers and connect
- * with any matching token found on the IRQ consumers list.
+ * with any matching eventfd found on the IRQ consumers list.
  */
-int irq_bypass_register_producer(struct irq_bypass_producer *producer)
+int irq_bypass_register_producer(struct irq_bypass_producer *producer,
+				 struct eventfd_ctx *eventfd)
 {
 	struct irq_bypass_producer *tmp;
 	struct irq_bypass_consumer *consumer;
 	int ret;
 
-	if (!producer->token)
+	if (WARN_ON_ONCE(producer->eventfd))
 		return -EINVAL;
 
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token == producer->token) {
+		if (tmp->eventfd == eventfd) {
 			ret = -EBUSY;
 			goto out_err;
 		}
 	}
 
 	list_for_each_entry(consumer, &consumers, node) {
-		if (consumer->token == producer->token) {
+		if (consumer->eventfd == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
 				goto out_err;
@@ -108,6 +110,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 		}
 	}
 
+	producer->eventfd = eventfd;
 	list_add(&producer->node, &producers);
 
 	mutex_unlock(&lock);
@@ -131,26 +134,28 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	struct irq_bypass_producer *tmp;
 	struct irq_bypass_consumer *consumer;
 
-	if (!producer->token)
+	if (!producer->eventfd)
 		return;
 
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token != producer->token)
+		if (tmp->eventfd != producer->eventfd)
 			continue;
 
 		list_for_each_entry(consumer, &consumers, node) {
-			if (consumer->token == producer->token) {
+			if (consumer->eventfd == producer->eventfd) {
 				__disconnect(producer, consumer);
 				break;
 			}
 		}
 
+		producer->eventfd = NULL;
 		list_del(&producer->node);
 		break;
 	}
 
+	WARN_ON_ONCE(producer->eventfd);
 	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
@@ -158,31 +163,35 @@ EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
 /**
  * irq_bypass_register_consumer - register IRQ bypass consumer
  * @consumer: pointer to consumer structure
+ * @eventfd: pointer to the eventfd context associated with the consumer
  *
  * Add the provided IRQ consumer to the list of consumers and connect
- * with any matching token found on the IRQ producer list.
+ * with any matching eventfd found on the IRQ producer list.
  */
-int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
+int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
+				 struct eventfd_ctx *eventfd)
 {
 	struct irq_bypass_consumer *tmp;
 	struct irq_bypass_producer *producer;
 	int ret;
 
-	if (!consumer->token ||
-	    !consumer->add_producer || !consumer->del_producer)
+	if (WARN_ON_ONCE(consumer->eventfd))
+		return -EINVAL;
+
+	if (!consumer->add_producer || !consumer->del_producer)
 		return -EINVAL;
 
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp->token == consumer->token || tmp == consumer) {
+		if (tmp->eventfd == eventfd) {
 			ret = -EBUSY;
 			goto out_err;
 		}
 	}
 
 	list_for_each_entry(producer, &producers, node) {
-		if (producer->token == consumer->token) {
+		if (producer->eventfd == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
 				goto out_err;
@@ -190,6 +199,7 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 		}
 	}
 
+	consumer->eventfd = eventfd;
 	list_add(&consumer->node, &consumers);
 
 	mutex_unlock(&lock);
@@ -213,7 +223,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 	struct irq_bypass_consumer *tmp;
 	struct irq_bypass_producer *producer;
 
-	if (!consumer->token)
+	if (!consumer->eventfd)
 		return;
 
 	mutex_lock(&lock);
@@ -223,16 +233,18 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 			continue;
 
 		list_for_each_entry(producer, &producers, node) {
-			if (producer->token == consumer->token) {
+			if (producer->eventfd == consumer->eventfd) {
 				__disconnect(producer, consumer);
 				break;
 			}
 		}
 
+		consumer->eventfd = NULL;
 		list_del(&consumer->node);
 		break;
 	}
 
+	WARN_ON_ONCE(consumer->eventfd);
 	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
-- 
2.49.0.1112.g889b7c5bd8-goog


