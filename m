Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB62A6BBE4F
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 21:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbjCOU75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 16:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjCOU7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 16:59:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDDF9DE22;
        Wed, 15 Mar 2023 13:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678913981; x=1710449981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7dXez5k4GaMgDvxV5RxbsMB39Tz+QawY3iHxSZvUebU=;
  b=WyI/uzgXDZScG3ZMTUx/HD5VLUcpb+PM/eTAwji/GRP4ANeUfNEm44WZ
   A8ypQuQGIRj/SFp2gpFTxioqB4a6y+C3qVo2Z8+fEAqILAxBgmyqikhzW
   tNpSeqSuqPt5UOcHwXKjJRfjunUSts/wqZjI9VbFBXEHejPsgDsVtRpP0
   c6WCriR1LQHbt8Mf+s7Ox9zc3ohSBr2gFHHLkNj5vhhXYv3bK+/ehIYZA
   /DK2J2ZmslXHzdMy6B/w5IRLGhDf6ZX7qJ89pqfIcQlJk2A/zLiGWs/u3
   GWRagScrPgO/vw3LYJBrXl6PsDYB/bmTPM4w4b+mS1KiPGTeJmQdfa59H
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="326176519"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326176519"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853747221"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853747221"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/8] vfio/pci: Use xarray for interrupt context storage
Date:   Wed, 15 Mar 2023 13:59:24 -0700
Message-Id: <dfe1b6526bef18e4966d1e0314252a7bd96a99be.1678911529.git.reinette.chatre@intel.com>
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

Interrupt context is statically allocated at the time interrupts
are enabled. Following allocation, the context is managed by
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
 drivers/vfio/pci/vfio_pci_core.c  |  1 +
 drivers/vfio/pci/vfio_pci_intrs.c | 63 +++++++++++++++++++++++--------
 include/linux/vfio_pci_core.h     |  2 +-
 3 files changed, 49 insertions(+), 17 deletions(-)

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
index ece371ebea00..bfcf5cb6b435 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -52,25 +52,59 @@ static
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
 }
 
+static int vfio_irq_ctx_alloc_single(struct vfio_pci_core_device *vdev,
+				     unsigned long index)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	int ret;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx)
+		return -ENOMEM;
+
+	ret = xa_insert(&vdev->ctx, index, ctx, GFP_KERNEL_ACCOUNT);
+	if (ret) {
+		kfree(ctx);
+		return ret;
+	}
+
+	return 0;
+}
+
+/* Only called during initial interrupt enabling. Never after.  */
 static int vfio_irq_ctx_alloc_num(struct vfio_pci_core_device *vdev,
 				  unsigned long num)
 {
-	vdev->ctx = kcalloc(num, sizeof(struct vfio_pci_irq_ctx),
-			    GFP_KERNEL_ACCOUNT);
-	if (!vdev->ctx)
-		return -ENOMEM;
+	unsigned long index;
+	int ret;
+
+	WARN_ON(!xa_empty(&vdev->ctx));
+
+	for (index = 0; index < num; index++) {
+		ret = vfio_irq_ctx_alloc_single(vdev, index);
+		if (ret)
+			goto err;
+	}
 
 	return 0;
+
+err:
+	vfio_irq_ctx_free_all(vdev);
+	return ret;
 }
 
 /*
@@ -486,16 +520,13 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
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

