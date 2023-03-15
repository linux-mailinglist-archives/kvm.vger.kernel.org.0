Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022026BBE4D
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 21:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjCOU7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 16:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbjCOU7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 16:59:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4161E9DE09;
        Wed, 15 Mar 2023 13:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678913981; x=1710449981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A+4ZcIQsKSo9aRxa5BQ1AU5NMqG5zxOH2Y36C6NWVys=;
  b=EPK7nRnmib3Smukwtv5IHyJ6JhVRtEEi7GP0XTjsMGwcsro8vGu7269h
   njTWd72FxmmkM1Y7qQ4nnx5a1+KelrndF12JMxqEzLiXZavhs1Myd+LkJ
   LKDkFj4fAfq6Zd0iIY0wUVjIcK7MBzOUrhSm9aihnfG+n2/qspeYWuvpy
   kUN5PL15anqt//iMx7jE7jYqw7zTKyjJqbK93SL1t0WQ2U6rvbmeO2goa
   uQpGu7Ijj1FvdP6MPN7Na/MlB+mV7VrT9N3HM1BeM6g7ICvKznFWeBbjb
   7pBXaGJwWDKGwzCzXOWMrYP3/mSm+DQq8HwLh7wdgNj2S7D17gbBqw/JK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="326176513"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326176513"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853747217"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853747217"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:38 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/8] vfio/pci: Prepare for dynamic interrupt context storage
Date:   Wed, 15 Mar 2023 13:59:23 -0700
Message-Id: <a82b0a6ab32dfcdf0bd835f9b269389ae56bf26d.1678911529.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678911529.git.reinette.chatre@intel.com>
References: <cover.1678911529.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interrupt context storage is statically allocated at the time
interrupts are enabled. Following allocation, the interrupt
context is managed by directly accessing the elements of the
array using the vector as index.

It is possible to allocate additional MSI-X vectors after
MSI-X has been enabled. Dynamic storage of interrupt context
is needed to support adding new MSI-X vectors after initial
enabling.

Replace direct access of array elements with pointers to the
array elements. Doing so reduces impact of moving to a new data
structure.  Move interactions with the array to helpers to
mostly contain changes needed to transition to a dynamic
data structure.

No functional change intended.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 206 ++++++++++++++++++++----------
 1 file changed, 140 insertions(+), 66 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3f64ccdce69f..ece371ebea00 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -48,6 +48,31 @@ static bool is_irq_none(struct vfio_pci_core_device *vdev)
 		 vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
 }
 
+static
+struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
+					  unsigned long index)
+{
+	if (index >= vdev->num_ctx)
+		return NULL;
+	return &vdev->ctx[index];
+}
+
+static void vfio_irq_ctx_free_all(struct vfio_pci_core_device *vdev)
+{
+	kfree(vdev->ctx);
+}
+
+static int vfio_irq_ctx_alloc_num(struct vfio_pci_core_device *vdev,
+				  unsigned long num)
+{
+	vdev->ctx = kcalloc(num, sizeof(struct vfio_pci_irq_ctx),
+			    GFP_KERNEL_ACCOUNT);
+	if (!vdev->ctx)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * INTx
  */
@@ -55,17 +80,28 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 {
 	struct vfio_pci_core_device *vdev = opaque;
 
-	if (likely(is_intx(vdev) && !vdev->virq_disabled))
-		eventfd_signal(vdev->ctx[0].trigger, 1);
+	if (likely(is_intx(vdev) && !vdev->virq_disabled)) {
+		struct vfio_pci_irq_ctx *ctx;
+
+		ctx = vfio_irq_ctx_get(vdev, 0);
+		if (!ctx)
+			return;
+		eventfd_signal(ctx->trigger, 1);
+	}
 }
 
 /* Returns true if the INTx vfio_pci_irq_ctx.masked value is changed. */
 bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_irq_ctx *ctx;
 	unsigned long flags;
 	bool masked_changed = false;
 
+	ctx = vfio_irq_ctx_get(vdev, 0);
+	if (!ctx)
+		return masked_changed;
+
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
 	/*
@@ -77,7 +113,7 @@ bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 	if (unlikely(!is_intx(vdev))) {
 		if (vdev->pci_2_3)
 			pci_intx(pdev, 0);
-	} else if (!vdev->ctx[0].masked) {
+	} else if (!ctx->masked) {
 		/*
 		 * Can't use check_and_mask here because we always want to
 		 * mask, not just when something is pending.
@@ -87,7 +123,7 @@ bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 		else
 			disable_irq_nosync(pdev->irq);
 
-		vdev->ctx[0].masked = true;
+		ctx->masked = true;
 		masked_changed = true;
 	}
 
@@ -105,9 +141,14 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 {
 	struct vfio_pci_core_device *vdev = opaque;
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_irq_ctx *ctx;
 	unsigned long flags;
 	int ret = 0;
 
+	ctx = vfio_irq_ctx_get(vdev, 0);
+	if (!ctx)
+		return ret;
+
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
 	/*
@@ -117,7 +158,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 	if (unlikely(!is_intx(vdev))) {
 		if (vdev->pci_2_3)
 			pci_intx(pdev, 1);
-	} else if (vdev->ctx[0].masked && !vdev->virq_disabled) {
+	} else if (ctx->masked && !vdev->virq_disabled) {
 		/*
 		 * A pending interrupt here would immediately trigger,
 		 * but we can avoid that overhead by just re-sending
@@ -129,7 +170,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 		} else
 			enable_irq(pdev->irq);
 
-		vdev->ctx[0].masked = (ret > 0);
+		ctx->masked = (ret > 0);
 	}
 
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
@@ -146,18 +187,23 @@ void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
 static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 {
 	struct vfio_pci_core_device *vdev = dev_id;
+	struct vfio_pci_irq_ctx *ctx;
 	unsigned long flags;
 	int ret = IRQ_NONE;
 
+	ctx = vfio_irq_ctx_get(vdev, 0);
+	if (!ctx)
+		return ret;
+
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
 	if (!vdev->pci_2_3) {
 		disable_irq_nosync(vdev->pdev->irq);
-		vdev->ctx[0].masked = true;
+		ctx->masked = true;
 		ret = IRQ_HANDLED;
-	} else if (!vdev->ctx[0].masked &&  /* may be shared */
+	} else if (!ctx->masked &&  /* may be shared */
 		   pci_check_and_mask_intx(vdev->pdev)) {
-		vdev->ctx[0].masked = true;
+		ctx->masked = true;
 		ret = IRQ_HANDLED;
 	}
 
@@ -171,15 +217,24 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 
 static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 {
+	struct vfio_pci_irq_ctx *ctx;
+	int ret;
+
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
 	if (!vdev->pdev->irq)
 		return -ENODEV;
 
-	vdev->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL_ACCOUNT);
-	if (!vdev->ctx)
-		return -ENOMEM;
+	ret = vfio_irq_ctx_alloc_num(vdev, 1);
+	if (ret)
+		return ret;
+
+	ctx = vfio_irq_ctx_get(vdev, 0);
+	if (!ctx) {
+		vfio_irq_ctx_free_all(vdev);
+		return -EINVAL;
+	}
 
 	vdev->num_ctx = 1;
 
@@ -189,9 +244,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	 * here, non-PCI-2.3 devices will have to wait until the
 	 * interrupt is enabled.
 	 */
-	vdev->ctx[0].masked = vdev->virq_disabled;
+	ctx->masked = vdev->virq_disabled;
 	if (vdev->pci_2_3)
-		pci_intx(vdev->pdev, !vdev->ctx[0].masked);
+		pci_intx(vdev->pdev, !ctx->masked);
 
 	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
@@ -202,41 +257,46 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long irqflags = IRQF_SHARED;
+	struct vfio_pci_irq_ctx *ctx;
 	struct eventfd_ctx *trigger;
 	unsigned long flags;
 	int ret;
 
-	if (vdev->ctx[0].trigger) {
+	ctx = vfio_irq_ctx_get(vdev, 0);
+	if (!ctx)
+		return -EINVAL;
+
+	if (ctx->trigger) {
 		free_irq(pdev->irq, vdev);
-		kfree(vdev->ctx[0].name);
-		eventfd_ctx_put(vdev->ctx[0].trigger);
-		vdev->ctx[0].trigger = NULL;
+		kfree(ctx->name);
+		eventfd_ctx_put(ctx->trigger);
+		ctx->trigger = NULL;
 	}
 
 	if (fd < 0) /* Disable only */
 		return 0;
 
-	vdev->ctx[0].name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)",
-				      pci_name(pdev));
-	if (!vdev->ctx[0].name)
+	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)",
+			      pci_name(pdev));
+	if (!ctx->name)
 		return -ENOMEM;
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
-		kfree(vdev->ctx[0].name);
+		kfree(ctx->name);
 		return PTR_ERR(trigger);
 	}
 
-	vdev->ctx[0].trigger = trigger;
+	ctx->trigger = trigger;
 
 	if (!vdev->pci_2_3)
 		irqflags = 0;
 
 	ret = request_irq(pdev->irq, vfio_intx_handler,
-			  irqflags, vdev->ctx[0].name, vdev);
+			  irqflags, ctx->name, vdev);
 	if (ret) {
-		vdev->ctx[0].trigger = NULL;
-		kfree(vdev->ctx[0].name);
+		ctx->trigger = NULL;
+		kfree(ctx->name);
 		eventfd_ctx_put(trigger);
 		return ret;
 	}
@@ -246,7 +306,7 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 	 * disable_irq won't.
 	 */
 	spin_lock_irqsave(&vdev->irqlock, flags);
-	if (!vdev->pci_2_3 && vdev->ctx[0].masked)
+	if (!vdev->pci_2_3 && ctx->masked)
 		disable_irq_nosync(pdev->irq);
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 
@@ -255,12 +315,17 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 
 static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 {
-	vfio_virqfd_disable(&vdev->ctx[0].unmask);
-	vfio_virqfd_disable(&vdev->ctx[0].mask);
+	struct vfio_pci_irq_ctx *ctx;
+
+	ctx = vfio_irq_ctx_get(vdev, 0);
+	if (ctx) {
+		vfio_virqfd_disable(&ctx->unmask);
+		vfio_virqfd_disable(&ctx->mask);
+	}
 	vfio_intx_set_signal(vdev, -1);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
-	kfree(vdev->ctx);
+	vfio_irq_ctx_free_all(vdev);
 }
 
 /*
@@ -284,10 +349,9 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
-	vdev->ctx = kcalloc(nvec, sizeof(struct vfio_pci_irq_ctx),
-			    GFP_KERNEL_ACCOUNT);
-	if (!vdev->ctx)
-		return -ENOMEM;
+	ret = vfio_irq_ctx_alloc_num(vdev, nvec);
+	if (ret)
+		return ret;
 
 	/* return the number of supported vectors if we can't get all: */
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -296,7 +360,7 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 		if (ret > 0)
 			pci_free_irq_vectors(pdev);
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
-		kfree(vdev->ctx);
+		vfio_irq_ctx_free_all(vdev);
 		return ret;
 	}
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
@@ -320,6 +384,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      unsigned int vector, int fd, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_irq_ctx *ctx;
 	struct eventfd_ctx *trigger;
 	int irq, ret;
 	u16 cmd;
@@ -327,33 +392,33 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (vector >= vdev->num_ctx)
 		return -EINVAL;
 
+	ctx = vfio_irq_ctx_get(vdev, vector);
+	if (!ctx)
+		return -EINVAL;
 	irq = pci_irq_vector(pdev, vector);
 
-	if (vdev->ctx[vector].trigger) {
-		irq_bypass_unregister_producer(&vdev->ctx[vector].producer);
+	if (ctx->trigger) {
+		irq_bypass_unregister_producer(&ctx->producer);
 
 		cmd = vfio_pci_memory_lock_and_enable(vdev);
-		free_irq(irq, vdev->ctx[vector].trigger);
+		free_irq(irq, ctx->trigger);
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
-
-		kfree(vdev->ctx[vector].name);
-		eventfd_ctx_put(vdev->ctx[vector].trigger);
-		vdev->ctx[vector].trigger = NULL;
+		kfree(ctx->name);
+		eventfd_ctx_put(ctx->trigger);
+		ctx->trigger = NULL;
 	}
 
 	if (fd < 0)
 		return 0;
 
-	vdev->ctx[vector].name = kasprintf(GFP_KERNEL_ACCOUNT,
-					   "vfio-msi%s[%d](%s)",
-					   msix ? "x" : "", vector,
-					   pci_name(pdev));
-	if (!vdev->ctx[vector].name)
+	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
+			      msix ? "x" : "", vector, pci_name(pdev));
+	if (!ctx->name)
 		return -ENOMEM;
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
-		kfree(vdev->ctx[vector].name);
+		kfree(ctx->name);
 		return PTR_ERR(trigger);
 	}
 
@@ -372,26 +437,25 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 		pci_write_msi_msg(irq, &msg);
 	}
 
-	ret = request_irq(irq, vfio_msihandler, 0,
-			  vdev->ctx[vector].name, trigger);
+	ret = request_irq(irq, vfio_msihandler, 0, ctx->name, trigger);
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 	if (ret) {
-		kfree(vdev->ctx[vector].name);
+		kfree(ctx->name);
 		eventfd_ctx_put(trigger);
 		return ret;
 	}
 
-	vdev->ctx[vector].producer.token = trigger;
-	vdev->ctx[vector].producer.irq = irq;
-	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
+	ctx->producer.token = trigger;
+	ctx->producer.irq = irq;
+	ret = irq_bypass_register_producer(&ctx->producer);
 	if (unlikely(ret)) {
 		dev_info(&pdev->dev,
 		"irq bypass producer (token %p) registration fails: %d\n",
-		vdev->ctx[vector].producer.token, ret);
+		ctx->producer.token, ret);
 
-		vdev->ctx[vector].producer.token = NULL;
+		ctx->producer.token = NULL;
 	}
-	vdev->ctx[vector].trigger = trigger;
+	ctx->trigger = trigger;
 
 	return 0;
 }
@@ -421,13 +485,17 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
 	u16 cmd;
 
 	for (i = 0; i < vdev->num_ctx; i++) {
-		vfio_virqfd_disable(&vdev->ctx[i].unmask);
-		vfio_virqfd_disable(&vdev->ctx[i].mask);
-		vfio_msi_set_vector_signal(vdev, i, -1, msix);
+		ctx = vfio_irq_ctx_get(vdev, i);
+		if (ctx) {
+			vfio_virqfd_disable(&ctx->unmask);
+			vfio_virqfd_disable(&ctx->mask);
+			vfio_msi_set_vector_signal(vdev, i, -1, msix);
+		}
 	}
 
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -443,7 +511,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
-	kfree(vdev->ctx);
+	vfio_irq_ctx_free_all(vdev);
 }
 
 /*
@@ -463,14 +531,18 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 		if (unmask)
 			vfio_pci_intx_unmask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		struct vfio_pci_irq_ctx *ctx = vfio_irq_ctx_get(vdev, 0);
 		int32_t fd = *(int32_t *)data;
+
+		if (!ctx)
+			return -EINVAL;
 		if (fd >= 0)
 			return vfio_virqfd_enable((void *) vdev,
 						  vfio_pci_intx_unmask_handler,
 						  vfio_send_intx_eventfd, NULL,
-						  &vdev->ctx[0].unmask, fd);
+						  &ctx->unmask, fd);
 
-		vfio_virqfd_disable(&vdev->ctx[0].unmask);
+		vfio_virqfd_disable(&ctx->unmask);
 	}
 
 	return 0;
@@ -543,6 +615,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
+	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
 
@@ -577,14 +650,15 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 
 	for (i = start; i < start + count; i++) {
-		if (!vdev->ctx[i].trigger)
+		ctx = vfio_irq_ctx_get(vdev, i);
+		if (!ctx || !ctx->trigger)
 			continue;
 		if (flags & VFIO_IRQ_SET_DATA_NONE) {
-			eventfd_signal(vdev->ctx[i].trigger, 1);
+			eventfd_signal(ctx->trigger, 1);
 		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 			uint8_t *bools = data;
 			if (bools[i - start])
-				eventfd_signal(vdev->ctx[i].trigger, 1);
+				eventfd_signal(ctx->trigger, 1);
 		}
 	}
 	return 0;
-- 
2.34.1

