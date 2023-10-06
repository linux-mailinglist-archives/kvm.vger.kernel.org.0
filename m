Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB1B7BBCF9
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbjJFQln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbjJFQlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DF6BF;
        Fri,  6 Oct 2023 09:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610489; x=1728146489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GrDkvFpLO+JPsGNBjwpaq6g93EzryzswXCI/VbdbsYc=;
  b=YAQSlo3KaTLH82/fDqkvIADwnYk4CBWJK7FEH6sUKX1WRefIZtqSZBnt
   l78LH7RFW+h+jLLz/WUIwNbF+lwaOUN6etQbsjHZqHDGUtCfaEWHNVcxm
   Lfk50FUm/l0Z2vtI+CkioWocIF//OsyPkzP73eT41oZ3NmbpKZuSlluE7
   zpYh6s6wQjm885W4j1+8tkQmspgq+Q/4mABRjEXg1FZGiqYKYx08XXCVv
   KqW3z4XW3gh/bg4/Ie3F4LuI//BSLiEXwvicp99QwseaJzkvgxza4ySJe
   RQgf7QhCeaRiTngAnm0SzdP1PU4SLSLFeXW8UNObG1zmgLVCJwthlzrMS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063196"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063196"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892865"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892865"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:25 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 09/18] vfio/pci: Move interrupt contexts to generic interrupt struct
Date:   Fri,  6 Oct 2023 09:41:04 -0700
Message-Id: <daf21396fe1f2157e44ec28ad95aa7f780ca227d.1696609476.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1696609476.git.reinette.chatre@intel.com>
References: <cover.1696609476.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO PCI interrupt management maintains per-interrupt
context within an xarray using the interrupt vector as index.

Move the per-interrupt context to the generic interrupt
context in struct vfio_pci_intr_ctx to enable this context to
be managed by a different backend.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 1 -
 drivers/vfio/pci/vfio_pci_intrs.c | 9 +++++----
 include/linux/vfio_pci_core.h     | 3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index bf4de137ad2f..cf303a9555f0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2162,7 +2162,6 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
-	xa_init(&vdev->ctx);
 	vfio_pci_init_intr_ctx(vdev, &vdev->intr_ctx);
 
 	return 0;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 9fc0a568d392..3c8fed88208c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -52,13 +52,13 @@ static
 struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
 					  unsigned long index)
 {
-	return xa_load(&vdev->ctx, index);
+	return xa_load(&vdev->intr_ctx.ctx, index);
 }
 
 static void vfio_irq_ctx_free(struct vfio_pci_core_device *vdev,
 			      struct vfio_pci_irq_ctx *ctx, unsigned long index)
 {
-	xa_erase(&vdev->ctx, index);
+	xa_erase(&vdev->intr_ctx.ctx, index);
 	kfree(ctx);
 }
 
@@ -72,7 +72,7 @@ vfio_irq_ctx_alloc(struct vfio_pci_core_device *vdev, unsigned long index)
 	if (!ctx)
 		return NULL;
 
-	ret = xa_insert(&vdev->ctx, index, ctx, GFP_KERNEL_ACCOUNT);
+	ret = xa_insert(&vdev->intr_ctx.ctx, index, ctx, GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		kfree(ctx);
 		return NULL;
@@ -529,7 +529,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	unsigned long i;
 	u16 cmd;
 
-	xa_for_each(&vdev->ctx, i, ctx) {
+	xa_for_each(&vdev->intr_ctx.ctx, i, ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 		vfio_msi_set_vector_signal(vdev, i, -1, msix);
@@ -809,6 +809,7 @@ void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
 	mutex_init(&intr_ctx->igate);
+	xa_init(&intr_ctx->ctx);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index b1c299188bf5..46521dd82a6b 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -56,6 +56,7 @@ struct vfio_pci_region {
  * @igate:		Protects members of struct vfio_pci_intr_ctx
  * @err_trigger:	Eventfd associated with error reporting IRQ
  * @req_trigger:	Eventfd associated with device request notification
+ * @ctx:		Per-interrupt context indexed by vector
  */
 struct vfio_pci_intr_ctx {
 	const struct vfio_pci_intr_ops	*ops;
@@ -63,6 +64,7 @@ struct vfio_pci_intr_ctx {
 	struct mutex			igate;
 	struct eventfd_ctx		*err_trigger;
 	struct eventfd_ctx		*req_trigger;
+	struct xarray			ctx;
 };
 
 struct vfio_pci_intr_ops {
@@ -98,7 +100,6 @@ struct vfio_pci_core_device {
 	u8			*vconfig;
 	struct perm_bits	*msi_perm;
 	spinlock_t		irqlock;
-	struct xarray		ctx;
 	int			irq_type;
 	int			num_regions;
 	struct vfio_pci_region	*region;
-- 
2.34.1

