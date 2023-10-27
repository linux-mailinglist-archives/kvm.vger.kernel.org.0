Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BAE7D9E8D
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346331AbjJ0RCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346161AbjJ0RBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3611BB;
        Fri, 27 Oct 2023 10:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426094; x=1729962094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YH4+58g19CrkXBQvJccNHa3tURxWh5a0OYq+Xc60VMo=;
  b=mzcJAwlcFjq4uu8Id3gQd8fh0nYL8P/TAwtjqvuJpdpCcW5TVFKf7nFV
   zKjTjDDzWCqiKKJA14E8xjR/NFL2MW8PORbIj9yScxOIbC/J9X39QQHtA
   uzJazBfGRbw20KFegilchyW79EQHeOhsCnhqT9+rooZQLKXpaG+TSC8rI
   IpK30c0l2h6uhRTHhWPPXmGfg0jDHGF5+MLrhqJT/KhCkLJgOYkgCSY2u
   kcEMFJFi6DLgqA2G3jJdVn/iRWeVPnF8/KgF0ep0UhLdVT2e3WqNkevwI
   FgncTWegOrnLdWFOczyGibvwyYf3LZYYJEgo+cdorsvNNLfaAp8Nwbd04
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611942"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611942"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988190"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988190"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:16 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 12/26] vfio/pci: Provide interrupt context to generic ops
Date:   Fri, 27 Oct 2023 10:00:44 -0700
Message-Id: <982ab998895e918a8920e5d5d927bb653f2cd7cf.1698422237.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1698422237.git.reinette.chatre@intel.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The functions operating on the per-interrupt context were originally
created to support management of PCI device interrupts where the
interrupt context was maintained within the virtual PCI device's
struct vfio_pci_core_device. Now that the per-interrupt context
has been moved to a more generic struct vfio_pci_intr_ctx these utilities
can be changed to expect the generic structure instead. This enables
these utilities to be used in other interrupt management backends.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
No changes since RFC V2.

 drivers/vfio/pci/vfio_pci_intrs.c | 41 ++++++++++++++++---------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 9aff5c38f198..cdb6f875271f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -49,21 +49,21 @@ static bool is_irq_none(struct vfio_pci_intr_ctx *intr_ctx)
 }
 
 static
-struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
+struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_intr_ctx *intr_ctx,
 					  unsigned long index)
 {
-	return xa_load(&vdev->intr_ctx.ctx, index);
+	return xa_load(&intr_ctx->ctx, index);
 }
 
-static void vfio_irq_ctx_free(struct vfio_pci_core_device *vdev,
+static void vfio_irq_ctx_free(struct vfio_pci_intr_ctx *intr_ctx,
 			      struct vfio_pci_irq_ctx *ctx, unsigned long index)
 {
-	xa_erase(&vdev->intr_ctx.ctx, index);
+	xa_erase(&intr_ctx->ctx, index);
 	kfree(ctx);
 }
 
 static struct vfio_pci_irq_ctx *
-vfio_irq_ctx_alloc(struct vfio_pci_core_device *vdev, unsigned long index)
+vfio_irq_ctx_alloc(struct vfio_pci_intr_ctx *intr_ctx, unsigned long index)
 {
 	struct vfio_pci_irq_ctx *ctx;
 	int ret;
@@ -72,7 +72,7 @@ vfio_irq_ctx_alloc(struct vfio_pci_core_device *vdev, unsigned long index)
 	if (!ctx)
 		return NULL;
 
-	ret = xa_insert(&vdev->intr_ctx.ctx, index, ctx, GFP_KERNEL_ACCOUNT);
+	ret = xa_insert(&intr_ctx->ctx, index, ctx, GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		kfree(ctx);
 		return NULL;
@@ -91,7 +91,7 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 	if (likely(is_intx(vdev) && !vdev->virq_disabled)) {
 		struct vfio_pci_irq_ctx *ctx;
 
-		ctx = vfio_irq_ctx_get(vdev, 0);
+		ctx = vfio_irq_ctx_get(&vdev->intr_ctx, 0);
 		if (WARN_ON_ONCE(!ctx))
 			return;
 		eventfd_signal(ctx->trigger, 1);
@@ -120,7 +120,7 @@ bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 		goto out_unlock;
 	}
 
-	ctx = vfio_irq_ctx_get(vdev, 0);
+	ctx = vfio_irq_ctx_get(&vdev->intr_ctx, 0);
 	if (WARN_ON_ONCE(!ctx))
 		goto out_unlock;
 
@@ -169,7 +169,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 		goto out_unlock;
 	}
 
-	ctx = vfio_irq_ctx_get(vdev, 0);
+	ctx = vfio_irq_ctx_get(&vdev->intr_ctx, 0);
 	if (WARN_ON_ONCE(!ctx))
 		goto out_unlock;
 
@@ -207,7 +207,7 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 	unsigned long flags;
 	int ret = IRQ_NONE;
 
-	ctx = vfio_irq_ctx_get(vdev, 0);
+	ctx = vfio_irq_ctx_get(&vdev->intr_ctx, 0);
 	if (WARN_ON_ONCE(!ctx))
 		return ret;
 
@@ -241,7 +241,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	if (!vdev->pdev->irq)
 		return -ENODEV;
 
-	ctx = vfio_irq_ctx_alloc(vdev, 0);
+	ctx = vfio_irq_ctx_alloc(&vdev->intr_ctx, 0);
 	if (!ctx)
 		return -ENOMEM;
 
@@ -269,7 +269,7 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 	unsigned long flags;
 	int ret;
 
-	ctx = vfio_irq_ctx_get(vdev, 0);
+	ctx = vfio_irq_ctx_get(&vdev->intr_ctx, 0);
 	if (WARN_ON_ONCE(!ctx))
 		return -EINVAL;
 
@@ -324,7 +324,7 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_pci_irq_ctx *ctx;
 
-	ctx = vfio_irq_ctx_get(vdev, 0);
+	ctx = vfio_irq_ctx_get(&vdev->intr_ctx, 0);
 	WARN_ON_ONCE(!ctx);
 	if (ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
@@ -332,7 +332,7 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 	}
 	vfio_intx_set_signal(vdev, -1);
 	vdev->intr_ctx.irq_type = VFIO_PCI_NUM_IRQS;
-	vfio_irq_ctx_free(vdev, ctx, 0);
+	vfio_irq_ctx_free(&vdev->intr_ctx, ctx, 0);
 }
 
 /*
@@ -421,7 +421,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	int irq = -EINVAL, ret;
 	u16 cmd;
 
-	ctx = vfio_irq_ctx_get(vdev, vector);
+	ctx = vfio_irq_ctx_get(&vdev->intr_ctx, vector);
 
 	if (ctx) {
 		irq_bypass_unregister_producer(&ctx->producer);
@@ -432,7 +432,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 		/* Interrupt stays allocated, will be freed at MSI-X disable. */
 		kfree(ctx->name);
 		eventfd_ctx_put(ctx->trigger);
-		vfio_irq_ctx_free(vdev, ctx, vector);
+		vfio_irq_ctx_free(&vdev->intr_ctx, ctx, vector);
 	}
 
 	if (fd < 0)
@@ -445,7 +445,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 			return irq;
 	}
 
-	ctx = vfio_irq_ctx_alloc(vdev, vector);
+	ctx = vfio_irq_ctx_alloc(&vdev->intr_ctx, vector);
 	if (!ctx)
 		return -ENOMEM;
 
@@ -499,7 +499,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 out_free_name:
 	kfree(ctx->name);
 out_free_ctx:
-	vfio_irq_ctx_free(vdev, ctx, vector);
+	vfio_irq_ctx_free(&vdev->intr_ctx, ctx, vector);
 	return ret;
 }
 
@@ -570,7 +570,8 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_intr_ctx *intr_ctx,
 		if (unmask)
 			vfio_pci_intx_unmask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
-		struct vfio_pci_irq_ctx *ctx = vfio_irq_ctx_get(vdev, 0);
+		struct vfio_pci_irq_ctx *ctx = vfio_irq_ctx_get(&vdev->intr_ctx,
+								0);
 		int32_t fd = *(int32_t *)data;
 
 		if (WARN_ON_ONCE(!ctx))
@@ -696,7 +697,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 		return -EINVAL;
 
 	for (i = start; i < start + count; i++) {
-		ctx = vfio_irq_ctx_get(vdev, i);
+		ctx = vfio_irq_ctx_get(&vdev->intr_ctx, i);
 		if (!ctx)
 			continue;
 		if (flags & VFIO_IRQ_SET_DATA_NONE) {
-- 
2.34.1

