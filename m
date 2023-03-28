Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59EA6CCC5A
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 23:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjC1Vyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 17:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjC1Vy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 17:54:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F932721;
        Tue, 28 Mar 2023 14:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680040454; x=1711576454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=clXlp6AznSWgVdTSj2E/3+K57ayIvVDYVuY4v/JSdjI=;
  b=chjTS6xIUQIO2WPKqI961QDPTTq4F1XiZQkq8Vu7eGP3B+ShYVkjFalw
   uR9uvT9gR0zHh0nnMrldUH+h5Qxa3Hid6BJEN+Kwz5dB6mOfESw5rtY1I
   fNoOhOwh5AB41wPNx0vpLEElxpQ7ZZP2qlxLQW3T/ArxNadhsETDAC9Gu
   plpFdphFuLYOE2Ua4soAcUgug2n/KHoDXXBlg2KMOScRjVpLPE0JoxdXE
   RK4a4xS+sqREe+OcCVXmKpyVVK18wqkKgZWBGbOE0AYurVyynR3FI5HO/
   NuwKnswJ+5AUMxuioZ07pDgAe3XNF6i1VbuZgZZLvyc78qSpQ2NgDHjy9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403316937"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403316937"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="748543776"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="748543776"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:50 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V2 4/8] vfio/pci: Use xarray for interrupt context storage
Date:   Tue, 28 Mar 2023 14:53:31 -0700
Message-Id: <8e9aaee36eac32c4b22f6a2c334721ca84132d61.1680038771.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1680038771.git.reinette.chatre@intel.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interrupt context is statically allocated at the time interrupts
are allocated. Following allocation, the context is managed by
directly accessing the elements of the array using the vector
as index. The storage is released when interrupts are disabled.

It is possible to dynamically allocate a single MSI-X index
after MSI-X has been enabled. A dynamic storage for interrupt context
is needed to support this. Replace the interrupt context array with an
xarray (similar to what the core uses as store for MSI descriptors)
that can support the dynamic expansion while maintaining the
custom that uses the vector as index.

Use the new data storage to allocate all elements once and free all
elements together. Dynamic usage follows.

Create helpers with understanding that it is only possible
to (after initial MSI-X enabling) allocate a single MSI-X index at
a time. The only time multiple MSI-X are allocated is during initial
MSI-X enabling where failure results in no allocations.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V1:
- Let vfio_irq_ctx_alloc_single() return pointer to allocated
  context. (Alex)
- Transition INTx allocation to simplified vfio_irq_ctx_alloc_single().
- Improve accuracy of changelog.

 drivers/vfio/pci/vfio_pci_core.c  |  1 +
 drivers/vfio/pci/vfio_pci_intrs.c | 77 ++++++++++++++++++++-----------
 include/linux/vfio_pci_core.h     |  2 +-
 3 files changed, 53 insertions(+), 27 deletions(-)

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
index ece371ebea00..00119641aa19 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -52,25 +52,60 @@ static
 struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
 					  unsigned long index)
 {
-	if (index >= vdev->num_ctx)
-		return NULL;
-	return &vdev->ctx[index];
+	return xa_load(&vdev->ctx, index);
 }
 
 static void vfio_irq_ctx_free_all(struct vfio_pci_core_device *vdev)
 {
-	kfree(vdev->ctx);
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned long index;
+
+	xa_for_each(&vdev->ctx, index, ctx) {
+		xa_erase(&vdev->ctx, index);
+		kfree(ctx);
+	}
+}
+
+static struct vfio_pci_irq_ctx *
+vfio_irq_ctx_alloc_single(struct vfio_pci_core_device *vdev,
+			  unsigned long index)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	int ret;
+
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
 
+/* Only called during initial interrupt enabling. Never after.  */
 static int vfio_irq_ctx_alloc_num(struct vfio_pci_core_device *vdev,
 				  unsigned long num)
 {
-	vdev->ctx = kcalloc(num, sizeof(struct vfio_pci_irq_ctx),
-			    GFP_KERNEL_ACCOUNT);
-	if (!vdev->ctx)
-		return -ENOMEM;
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned long index;
+
+	WARN_ON(!xa_empty(&vdev->ctx));
+
+	for (index = 0; index < num; index++) {
+		ctx = vfio_irq_ctx_alloc_single(vdev, index);
+		if (!ctx)
+			goto err;
+	}
 
 	return 0;
+
+err:
+	vfio_irq_ctx_free_all(vdev);
+	return -ENOMEM;
 }
 
 /*
@@ -218,7 +253,6 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_pci_irq_ctx *ctx;
-	int ret;
 
 	if (!is_irq_none(vdev))
 		return -EINVAL;
@@ -226,15 +260,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
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
+	ctx = vfio_irq_ctx_alloc_single(vdev, 0);
+	if (!ctx)
+		return -ENOMEM;
 
 	vdev->num_ctx = 1;
 
@@ -486,16 +514,13 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
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

