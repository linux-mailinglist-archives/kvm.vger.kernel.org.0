Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370F76E6B0E
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbjDRRaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbjDRR3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:29:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09A5B467;
        Tue, 18 Apr 2023 10:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681838991; x=1713374991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+LQ4KknkPd5it6WKDWxtv2E8zkNti3jsn4E8sdDJHMY=;
  b=SBqgC2LI98rOxaIFEPWVBmZOTNTqAYFxrnKvaVkInINm3jfsvMb3iKcp
   NX1sc0Dcuruj43lpOqHxW7eYx0T6dgwWOqDMkM9TV2p7E6j3u5khUh7Zj
   cT85kJrw+0ySH3ztIdzPAzNxD4OIdtekUqRWYvDEpQdOowjtI9QZ6EUvl
   /074hXgVvpnTER9Tr7d1u3pXHRwAPNId21WVKFIto0yUp5RDurLSUJ5oB
   /N88F/HZg+XQCHKoTxn5I3LpPVg2lU7MzpWQlgqUVVqSO/vOHgEVom0bF
   vC83rT+9uMDrF/ZRkjEA5nEGxg1daflX/Y7KWv4uzbR7S4XHUdSgjwisN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="410466468"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="410466468"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="865503482"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="865503482"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:42 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V3 05/10] vfio/pci: Use xarray for interrupt context storage
Date:   Tue, 18 Apr 2023 10:29:16 -0700
Message-Id: <78182c9cd770885b6d354f114ba157c7024c8b39.1681837892.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1681837892.git.reinette.chatre@intel.com>
References: <cover.1681837892.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interrupt context is statically allocated at the time interrupts
are allocated. Following allocation, the context is managed by
directly accessing the elements of the array using the vector
as index. The storage is released when interrupts are disabled.

It is possible to dynamically allocate a single MSI-X interrupt
after MSI-X is enabled. A dynamic storage for interrupt context
is needed to support this. Replace the interrupt context array with an
xarray (similar to what the core uses as store for MSI descriptors)
that can support the dynamic expansion while maintaining the
custom that uses the vector as index.

With a dynamic storage it is no longer required to pre-allocate
interrupt contexts at the time the interrupts are allocated.
MSI and MSI-X interrupt contexts are only used when interrupts are
enabled. Their allocation can thus be delayed until interrupt enabling.
Only enabled interrupts will have associated interrupt contexts.
Whether an interrupt has been allocated (a Linux irq number exists
for it) becomes the criteria for whether an interrupt can be enabled.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/lkml/20230404122444.59e36a99.alex.williamson@redhat.com/
---
Changes since V2:
- Only allocate contexts as they are used, or "active". (Alex)
- Move vfio_irq_ctx_free() from later patch to prevent open-coding
  the same within vfio_irq_ctx_free_all(). This evolved into
  vfio_irq_ctx_free() used for dynamic context allocation and
  vfio_irq_ctx_free_all() removed because of it. (Alex)
- With vfio_irq_ctx_alloc_num() removed, rename vfio_irq_ctx_alloc_single()
  to vfio_irq_ctx_alloc().

Changes since RFC V1:
- Let vfio_irq_ctx_alloc_single() return pointer to allocated
  context. (Alex)
- Transition INTx allocation to simplified vfio_irq_ctx_alloc_single().
- Improve accuracy of changelog.

 drivers/vfio/pci/vfio_pci_core.c  |  1 +
 drivers/vfio/pci/vfio_pci_intrs.c | 91 ++++++++++++++++---------------
 include/linux/vfio_pci_core.h     |  2 +-
 3 files changed, 48 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a5ab416cf476..ae0e161c7fc9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2102,6 +2102,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
+	xa_init(&vdev->ctx);
 
 	return 0;
 }
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 9e17e59a4d60..117cd384b3ad 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -52,25 +52,33 @@ static
 struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
 					  unsigned long index)
 {
-	if (index >= vdev->num_ctx)
-		return NULL;
-	return &vdev->ctx[index];
+	return xa_load(&vdev->ctx, index);
 }
 
-static void vfio_irq_ctx_free_all(struct vfio_pci_core_device *vdev)
+static void vfio_irq_ctx_free(struct vfio_pci_core_device *vdev,
+			      struct vfio_pci_irq_ctx *ctx, unsigned long index)
 {
-	kfree(vdev->ctx);
+	xa_erase(&vdev->ctx, index);
+	kfree(ctx);
 }
 
-static int vfio_irq_ctx_alloc_num(struct vfio_pci_core_device *vdev,
-				  unsigned long num)
+static struct vfio_pci_irq_ctx *
+vfio_irq_ctx_alloc(struct vfio_pci_core_device *vdev, unsigned long index)
 {
-	vdev->ctx = kcalloc(num, sizeof(struct vfio_pci_irq_ctx),
-			    GFP_KERNEL_ACCOUNT);
-	if (!vdev->ctx)
-		return -ENOMEM;
+	struct vfio_pci_irq_ctx *ctx;
+	int ret;
 
-	return 0;
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx)
+		return NULL;
+
+	ret = xa_insert(&vdev->ctx, index, ctx, GFP_KERNEL_ACCOUNT);
+	if (ret) {
+		kfree(ctx);
+		return NULL;
+	}
+
+	return ctx;
 }
 
 /*
@@ -218,7 +226,6 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_pci_irq_ctx *ctx;
-	int ret;
 
 	if (!is_irq_none(vdev))
 		return -EINVAL;
@@ -226,15 +233,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	if (!vdev->pdev->irq)
 		return -ENODEV;
 
-	ret = vfio_irq_ctx_alloc_num(vdev, 1);
-	if (ret)
-		return ret;
-
-	ctx = vfio_irq_ctx_get(vdev, 0);
-	if (!ctx) {
-		vfio_irq_ctx_free_all(vdev);
-		return -EINVAL;
-	}
+	ctx = vfio_irq_ctx_alloc(vdev, 0);
+	if (!ctx)
+		return -ENOMEM;
 
 	vdev->num_ctx = 1;
 
@@ -325,7 +326,7 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 	vfio_intx_set_signal(vdev, -1);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
-	vfio_irq_ctx_free_all(vdev);
+	vfio_irq_ctx_free(vdev, ctx, 0);
 }
 
 /*
@@ -349,10 +350,6 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
-	ret = vfio_irq_ctx_alloc_num(vdev, nvec);
-	if (ret)
-		return ret;
-
 	/* return the number of supported vectors if we can't get all: */
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	ret = pci_alloc_irq_vectors(pdev, 1, nvec, flag);
@@ -360,7 +357,6 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 		if (ret > 0)
 			pci_free_irq_vectors(pdev);
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
-		vfio_irq_ctx_free_all(vdev);
 		return ret;
 	}
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
@@ -392,12 +388,13 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (vector >= vdev->num_ctx)
 		return -EINVAL;
 
-	ctx = vfio_irq_ctx_get(vdev, vector);
-	if (!ctx)
-		return -EINVAL;
 	irq = pci_irq_vector(pdev, vector);
+	if (irq < 0)
+		return -EINVAL;
 
-	if (ctx->trigger) {
+	ctx = vfio_irq_ctx_get(vdev, vector);
+
+	if (ctx) {
 		irq_bypass_unregister_producer(&ctx->producer);
 
 		cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -405,16 +402,22 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
 		kfree(ctx->name);
 		eventfd_ctx_put(ctx->trigger);
-		ctx->trigger = NULL;
+		vfio_irq_ctx_free(vdev, ctx, vector);
 	}
 
 	if (fd < 0)
 		return 0;
 
+	ctx = vfio_irq_ctx_alloc(vdev, vector);
+	if (!ctx)
+		return -ENOMEM;
+
 	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
 			      msix ? "x" : "", vector, pci_name(pdev));
-	if (!ctx->name)
-		return -ENOMEM;
+	if (!ctx->name) {
+		ret = -ENOMEM;
+		goto out_free_ctx;
+	}
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
@@ -460,6 +463,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	eventfd_ctx_put(trigger);
 out_free_name:
 	kfree(ctx->name);
+out_free_ctx:
+	vfio_irq_ctx_free(vdev, ctx, vector);
 	return ret;
 }
 
@@ -489,16 +494,13 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
-	unsigned int i;
+	unsigned long i;
 	u16 cmd;
 
-	for (i = 0; i < vdev->num_ctx; i++) {
-		ctx = vfio_irq_ctx_get(vdev, i);
-		if (ctx) {
-			vfio_virqfd_disable(&ctx->unmask);
-			vfio_virqfd_disable(&ctx->mask);
-			vfio_msi_set_vector_signal(vdev, i, -1, msix);
-		}
+	xa_for_each(&vdev->ctx, i, ctx) {
+		vfio_virqfd_disable(&ctx->unmask);
+		vfio_virqfd_disable(&ctx->mask);
+		vfio_msi_set_vector_signal(vdev, i, -1, msix);
 	}
 
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -514,7 +516,6 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
-	vfio_irq_ctx_free_all(vdev);
 }
 
 /*
@@ -654,7 +655,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 
 	for (i = start; i < start + count; i++) {
 		ctx = vfio_irq_ctx_get(vdev, i);
-		if (!ctx || !ctx->trigger)
+		if (!ctx)
 			continue;
 		if (flags & VFIO_IRQ_SET_DATA_NONE) {
 			eventfd_signal(ctx->trigger, 1);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 367fd79226a3..61d7873a3973 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -59,7 +59,7 @@ struct vfio_pci_core_device {
 	struct perm_bits	*msi_perm;
 	spinlock_t		irqlock;
 	struct mutex		igate;
-	struct vfio_pci_irq_ctx	*ctx;
+	struct xarray		ctx;
 	int			num_ctx;
 	int			irq_type;
 	int			num_regions;
-- 
2.34.1

