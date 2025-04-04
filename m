Return-Path: <kvm+bounces-42758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B55A7C55F
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 23:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FA543BC798
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3478221DAA;
	Fri,  4 Apr 2025 21:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jOsLhL8b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F1B22157B
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 21:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743801312; cv=none; b=TEtynt+IhIQDWA4kFV85fAkhB/uUEr3TKAHwV3HfGq2FIRYAbDwFxfPj+J4Ovleluo0bfyCJsy9LO5nLBUG/mwHLh7JavpC574jMcEFZUx5/4q9IRuobBw5xqbpwAppz82iujeN09GdcsZkrzcDDjoYMT7Qux6IEht7wkfCUCvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743801312; c=relaxed/simple;
	bh=8YRrcSuqZ2X6elO3mJMg4SsPMd3wcuYxZDV9OuSa3es=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QEfXQYGceMYKn86EvxZY1O0ltgfTbR/dt32yvgRjcc1wa0zuAE8B456Rq12E3i9+FXq353AUZaegboc5Kuai45cQVpEBSK8yNPeQ1HVQQaa+8jcdlaUplMRIumjbqz9mFxVKkyCnrhvzJ0RYRyZeYX6n7d3ceAfiM5pyAZ6ktPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jOsLhL8b; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3032f4ea8cfso2643833a91.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 14:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743801309; x=1744406109; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9QlPfYoNUHN0npkNqAREwoXYlnO6YkPNvJYmSOd9TNs=;
        b=jOsLhL8b/9t3v1EmL9arzdQZwBPyrhvzElSxUQkQZ4gt22qTZc8R7st1njULiKSkeU
         auxG/e79guVNomsLDQ2+nlf9Gc5IFu4k/ZVLwPED+Ok39TKjdzW+YPn63yLCtXhT+pHH
         zau8dS/Ri/EoEPBnjRT3Q7/su/IWnF/ScL2u5aBNo3xV2AbePT2a3849JYi84noKwGVx
         x5M9mjOtlqVoggRoVCC9Az1DBg9ap9gmnO23P1Qv1njUENYHOe0DEc+wBRJejlrYdGNB
         nmYW92OVnTIKcHjz94yNUDdUhRI54QvRHb6jBHw6VGH1DxspP++uSx3562kVhF81D7Mc
         KJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743801309; x=1744406109;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9QlPfYoNUHN0npkNqAREwoXYlnO6YkPNvJYmSOd9TNs=;
        b=hp7BllW4fRvXr561iMajr/uEBa67Q0Tar4YWulJ/Ia4XCgFlfm7F/YbF//kn85W+2i
         EKsczo5nn5S/Dlx9jXQjZ5tSKTWNeeQeNI92uwnnMPAUyjCm9Ex/e8MfdePLNIHjc3ka
         NyZewI6f2CYUP2pgR0ecU4qEzRHLzcSa0M2qaC1oDBV7gZmHGo/zsoCvdtV1eyWNzDoe
         cbaWLZxisRqHjHwRRwJDIhjkMKzHTCKZiVS2IsVltXZ5Yk1/PNb6yHtrKHaUqnfo6klb
         ib4L9blRbn0NsbwzsefQPrFQdBTdu1xcKXKCikR7PHSLzxA4rForYI2YuW799cb0dR6F
         k/KQ==
X-Gm-Message-State: AOJu0YzJ8WNPDmSlgS0zUJPx2GdImg0k1fKxQqhkbHrcXOEEMmFEiXFe
	dfRIj8/gd20sYKwwK4eY3QwqeDO1HiboGwKfp7z+UkxewzvoXS7m9fXhHtxnr04EZvyv/1iEh4A
	q5Q==
X-Google-Smtp-Source: AGHT+IFG/HHiS7U1SE6A/tzvJJ9amzcONWj17eofMzEa4fVAsgAjCRMKGaMbI4EF0SCoGNkBCkXglKNNX8c=
X-Received: from pjbov5.prod.google.com ([2002:a17:90b:2585:b0:301:2679:9aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51cd:b0:2ee:f80c:6889
 with SMTP id 98e67ed59e1d1-306a492209bmr7867881a91.33.1743801309333; Fri, 04
 Apr 2025 14:15:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 14:14:45 -0700
In-Reply-To: <20250404211449.1443336-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404211449.1443336-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404211449.1443336-4-seanjc@google.com>
Subject: [PATCH 3/7] irqbypass: Take ownership of producer/consumer token tracking
From: Sean Christopherson <seanjc@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Move ownership of IRQ bypass token tracking into irqbypass.ko, and
explicitly require callers to pass an eventfd_ctx structure instead of a
completely opaque token.  Relying on producers and consumers to set the
token appropriately is error prone, and hiding the fact that the token must
be an eventfd_ctx pointer (for all intents and purposes) unnecessarily
obfuscates the code and makes it more brittle.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c |  5 +----
 drivers/vhost/vdpa.c              |  4 +---
 include/linux/irqbypass.h         | 31 +++++++++++++++++--------------
 virt/kvm/eventfd.c                |  3 +--
 virt/lib/irqbypass.c              | 30 +++++++++++++++++++++---------
 5 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8382c5834335..c852643d8359 100644
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
 		"irq bypass producer (token %p) registration fails: %d\n",
 		ctx->producer.token, ret);
-
-		ctx->producer.token = NULL;
 	}
 	ctx->trigger = trigger;
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 5a49b5a6d496..2749290f892d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -213,7 +213,7 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 		return;
 
 	vq->call_ctx.producer.irq = irq;
-	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
+	ret = irq_bypass_register_producer(&vq->call_ctx.producer, vq->call_ctx.ctx);
 	if (unlikely(ret))
 		dev_info(&v->dev, "vq %u, irq bypass producer (token %p) registration fails, ret =  %d\n",
 			 qid, vq->call_ctx.producer.token, ret);
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
index 9bdb2a781841..379725b9a003 100644
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
+ * via a shared eventfd_ctx).  Producers and consumers register independently.
+ * When a producer and consumer are paired, i.e. a token match is found, the
+ * optional @stop callback will be called for each participant.  The pair will
+ * then be connected via the @add_* callbacks, and finally the optional @start
+ * callback will allow any final coordination.  When either participant is
+ * unregistered, the process is repeated using the @del_* callbacks in place of
+ * the @add_* callbacks.  Match tokens must be unique per producer/consumer,
+ * 1:N pairings are not supported.
  */
 
 /**
  * struct irq_bypass_producer - IRQ bypass producer definition
  * @node: IRQ bypass manager private list management
- * @token: opaque token to match between producer and consumer (non-NULL)
+ * @token: IRQ bypass manage private token to match producers and consumers
  * @irq: Linux IRQ number for the producer device
  * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
  * @del_consumer: Disconnect the IRQ producer from an IRQ consumer (optional)
@@ -57,7 +58,7 @@ struct irq_bypass_producer {
 /**
  * struct irq_bypass_consumer - IRQ bypass consumer definition
  * @node: IRQ bypass manager private list management
- * @token: opaque token to match between producer and consumer (non-NULL)
+ * @token: IRQ bypass manage private token to match producers and consumers
  * @add_producer: Connect the IRQ consumer to an IRQ producer
  * @del_producer: Disconnect the IRQ consumer from an IRQ producer
  * @stop: Perform any quiesce operations necessary prior to add/del (optional)
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
index 249ba5b72e9b..afdbac0d0b9f 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -426,12 +426,11 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
 	if (kvm_arch_has_irq_bypass()) {
-		irqfd->consumer.token = (void *)irqfd->eventfd;
 		irqfd->consumer.add_producer = kvm_arch_irq_bypass_add_producer;
 		irqfd->consumer.del_producer = kvm_arch_irq_bypass_del_producer;
 		irqfd->consumer.stop = kvm_arch_irq_bypass_stop;
 		irqfd->consumer.start = kvm_arch_irq_bypass_start;
-		ret = irq_bypass_register_consumer(&irqfd->consumer);
+		ret = irq_bypass_register_consumer(&irqfd->consumer, irqfd->eventfd);
 		if (ret)
 			pr_info("irq bypass consumer (token %p) registration fails: %d\n",
 				irqfd->consumer.token, ret);
diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 28a4d933569a..98bf76d03078 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -77,30 +77,32 @@ static void __disconnect(struct irq_bypass_producer *prod,
 /**
  * irq_bypass_register_producer - register IRQ bypass producer
  * @producer: pointer to producer structure
+ * @eventfd: pointer to the eventfd context associated with the producer
  *
  * Add the provided IRQ producer to the list of producers and connect
  * with any matching token found on the IRQ consumers list.
  */
-int irq_bypass_register_producer(struct irq_bypass_producer *producer)
+int irq_bypass_register_producer(struct irq_bypass_producer *producer,
+				 struct eventfd_ctx *eventfd)
 {
 	struct irq_bypass_producer *tmp;
 	struct irq_bypass_consumer *consumer;
 	int ret;
 
-	if (!producer->token)
+	if (WARN_ON_ONCE(producer->token))
 		return -EINVAL;
 
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token == producer->token) {
+		if (tmp->token == eventfd) {
 			ret = -EBUSY;
 			goto out_err;
 		}
 	}
 
 	list_for_each_entry(consumer, &consumers, node) {
-		if (consumer->token == producer->token) {
+		if (consumer->token == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
 				goto out_err;
@@ -108,6 +110,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 		}
 	}
 
+	producer->token = eventfd;
 	list_add(&producer->node, &producers);
 
 	mutex_unlock(&lock);
@@ -147,10 +150,12 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 			}
 		}
 
+		producer->token = NULL;
 		list_del(&producer->node);
 		break;
 	}
 
+	WARN_ON_ONCE(producer->token);
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
  * with any matching token found on the IRQ producer list.
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
+	if (WARN_ON_ONCE(consumer->token))
+		return -EINVAL;
+
+	if (!consumer->add_producer || !consumer->del_producer)
 		return -EINVAL;
 
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp->token == consumer->token || tmp == consumer) {
+		if (tmp->token == eventfd || tmp == consumer) {
 			ret = -EBUSY;
 			goto out_err;
 		}
 	}
 
 	list_for_each_entry(producer, &producers, node) {
-		if (producer->token == consumer->token) {
+		if (producer->token == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
 				goto out_err;
@@ -190,6 +199,7 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 		}
 	}
 
+	consumer->token = eventfd;
 	list_add(&consumer->node, &consumers);
 
 	mutex_unlock(&lock);
@@ -229,10 +239,12 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 			}
 		}
 
+		consumer->token = NULL;
 		list_del(&consumer->node);
 		break;
 	}
 
+	WARN_ON_ONCE(consumer->token);
 	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
-- 
2.49.0.504.g3bcea36a83-goog


