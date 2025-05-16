Return-Path: <kvm+bounces-46921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64592ABA645
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:11:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 491B63ABD2C
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB832857E4;
	Fri, 16 May 2025 23:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LSp7R1T9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07E72853FA
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436877; cv=none; b=miG/hdd9SIfiiCFHXqeBKy0tDrcpH1UvUHp+dl40awaVEEe9LjG9TgSgJDz81NwD/2efSMSWGj9jSQD88SZ8wQ4cVlt9QNm1pG9YahokSCjO7IWOrUyKfkUyaRBE6bwNDFl3d0cnN4+DYWzwc1hqad0oN1ZYom2XqOJl0MjJAB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436877; c=relaxed/simple;
	bh=I3DHw0mSL3jtxx94vxk532QfN1TMtQ4UDQPBThuFuwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OyH5Yosqm2Q7KC7NSuJOy8DjxCDgUyEe3gywCuzjoawQF/ti5uv6Arrn2Pz/9Df8/EBuXtLgdLEmK2vrHKJnud35L9J3XjrBSmHP+wNrzpJsjIw5wT4ZpJaX+ATUFOHwlADLKaJoxnEcX8bi4wQMJV9EPe/CpJswurnpoFaPG9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LSp7R1T9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e5c14b49cso1523830a91.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747436875; x=1748041675; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FAMbaUPPerspb7HApxfCN10SlBrRCAmzWKwokYGPr+8=;
        b=LSp7R1T9EbTgE9VggHC9Dh7dzgiG5ePNFmWgbF4q8+l/smBzPOIKpnwjIrmDFU2+v/
         l/xWawYx43BJVvbmDO3RukXVBNC0RKGCLF/kDwR969OLrPpBweCmpMSWJ8vmEMcuHArH
         ORSSvUExEWKN99PXzyJiupgKFTdjVPW6bPP1wF5xFhREk6/TeWBCl1NAHjClGr7P62/S
         WKY2PdVtZ9oC0UpPKKBb+CdvkLkmzDFRsZ3AtwRrOmb2//AUTpsnpBQwX8mCcVJH0LV5
         sELUbEmziWCfkDHck+d//iXwbo35YhyY9tfH3U04/JD8sMZuJYqiqUC5khj8jUtU60Sf
         Vy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436875; x=1748041675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FAMbaUPPerspb7HApxfCN10SlBrRCAmzWKwokYGPr+8=;
        b=brNwYTQxMKZRPxjztukD+xxT1MuQayJFmHgSnSvz1Wq8bNEzKROzEYmkx3GIdCXQsX
         bsteJjq7XdTWGeSY1t6WaZwfTUQYgT89Sy1nDZPrjohVyxM/6vN01BHW9gXkZzgyQxvl
         UW68Pm5/7TUqBjiOmD8s5E+LrYLcEbvoHPnTrjDzpDjY55zuHxCrQGehEiQWicN5WuKX
         Hc3YDzPOPXHkP8ELeSCL8sCAXI2q3RFC6dbtI8S2XMBkjfOsm4wclS8DyzRfti39Dmjo
         3f0L/Cfcz6tbCDMYAeu2O0mmM2MXEvV3dEajiCXaWwcuQO8+STPLxiszINEaXOUx2K/E
         dHYA==
X-Gm-Message-State: AOJu0YyKtXcXOOMAtX8AOaMBpfxJ2n/TqoCELL2NZAVMCin5S7Tl9FYI
	pDjEyGCJ4JAdcQ0xMVOkMaehdLj6d4Ntc5w9dBITz6I9zwKy7AdC6U223pVaRQ7/XEkXYCFUNPo
	mlJWNoQ==
X-Google-Smtp-Source: AGHT+IG0uMk9h30PFjbqxBOtiNTGzFAvu6anTRo/cSbV54uv+opaF4OQfdpyqDmtiu2fEcy4O6POnGBsS/I=
X-Received: from pjwx4.prod.google.com ([2002:a17:90a:c2c4:b0:2fa:1fac:2695])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33c2:b0:2ee:5c9b:35c0
 with SMTP id 98e67ed59e1d1-30e7de63cdcmr6199653a91.9.1747436875261; Fri, 16
 May 2025 16:07:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 16:07:34 -0700
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516230734.2564775-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516230734.2564775-9-seanjc@google.com>
Subject: [PATCH v2 8/8] irqbypass: Require producers to pass in Linux IRQ
 number during registration
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

Pass in the Linux IRQ associated with an IRQ bypass producer instead of
relying on the caller to set the field prior to registration, as there's
no benefit to relying on callers to do the right thing.

Take care to set producer->irq before __connect(), as KVM expects the IRQ
to be valid as soon as a connection is possible.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 3 +--
 drivers/vhost/vdpa.c              | 4 ++--
 include/linux/irqbypass.h         | 2 +-
 virt/lib/irqbypass.c              | 5 ++++-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index d87fe116762a..123298a4dc8f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -505,8 +505,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (ret)
 		goto out_put_eventfd_ctx;
 
-	ctx->producer.irq = irq;
-	ret = irq_bypass_register_producer(&ctx->producer, trigger);
+	ret = irq_bypass_register_producer(&ctx->producer, trigger, irq);
 	if (unlikely(ret)) {
 		dev_info(&pdev->dev,
 		"irq bypass producer (eventfd %p) registration fails: %d\n",
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7b265ffda697..af1e1fdfd9ed 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -212,8 +212,8 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	if (!vq->call_ctx.ctx)
 		return;
 
-	vq->call_ctx.producer.irq = irq;
-	ret = irq_bypass_register_producer(&vq->call_ctx.producer, vq->call_ctx.ctx);
+	ret = irq_bypass_register_producer(&vq->call_ctx.producer,
+					   vq->call_ctx.ctx, irq);
 	if (unlikely(ret))
 		dev_info(&v->dev, "vq %u, irq bypass producer (eventfd %p) registration fails, ret =  %d\n",
 			 qid, vq->call_ctx.ctx, ret);
diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index cd64fcaa88fe..ede1fa938152 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -84,7 +84,7 @@ struct irq_bypass_consumer {
 };
 
 int irq_bypass_register_producer(struct irq_bypass_producer *producer,
-				 struct eventfd_ctx *eventfd);
+				 struct eventfd_ctx *eventfd, int irq);
 void irq_bypass_unregister_producer(struct irq_bypass_producer *producer);
 int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
 				 struct eventfd_ctx *eventfd);
diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index ea888b9203d2..62c160200be9 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -85,12 +85,13 @@ static void __disconnect(struct irq_bypass_producer *prod,
  * irq_bypass_register_producer - register IRQ bypass producer
  * @producer: pointer to producer structure
  * @eventfd: pointer to the eventfd context associated with the producer
+ * @irq: Linux IRQ number of the underlying producer device
  *
  * Add the provided IRQ producer to the set of producers and connect with the
  * consumer with a matching eventfd, if one exists.
  */
 int irq_bypass_register_producer(struct irq_bypass_producer *producer,
-				 struct eventfd_ctx *eventfd)
+				 struct eventfd_ctx *eventfd, int irq)
 {
 	unsigned long index = (unsigned long)eventfd;
 	struct irq_bypass_consumer *consumer;
@@ -99,6 +100,8 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer,
 	if (WARN_ON_ONCE(producer->eventfd))
 		return -EINVAL;
 
+	producer->irq = irq;
+
 	guard(mutex)(&lock);
 
 	ret = xa_insert(&producers, index, producer, GFP_KERNEL);
-- 
2.49.0.1112.g889b7c5bd8-goog


