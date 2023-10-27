Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435C67D9E78
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346345AbjJ0RBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346131AbjJ0RBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D991AA;
        Fri, 27 Oct 2023 10:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426092; x=1729962092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IpPDZ7Ks2iVqUt7LpEzOx+GuVFbnS3TggpdU7AmmhBk=;
  b=RiUiN4DNKnOLy6JXvYztcvMGaQdjMNur3sAw33PSnlFuhsBch5wi7bjk
   IbqBqPNeN1hGyVnNge4ZSOc+sb9HVYvygPKYRWsbzEJBzjoM6ZXR5V2kG
   iJ1jj67z9gEjwZA0pruWreUNvwkoF7gpEfNv7laqcePu1xdULnyqnxhBV
   Fu/de+t9SfGNlrNoT9ohjbwIDmfSHffwnJVZutrW4OYn5eC8d0zvKKWOf
   6HH3z0METsLx9rWqbSLFDnPzVPiw+Jg7My1sQxaW9TAaExVGIObGl87UO
   IBml3QbXvqr08Om0yDB67zmTKV3LejBkHKt699bxD9UY0BT0bI424geBA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611902"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611902"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988178"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988178"
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
Subject: [RFC PATCH V3 09/26] vfio/pci: Move per-interrupt contexts to generic interrupt struct
Date:   Fri, 27 Oct 2023 10:00:41 -0700
Message-Id: <356e143a82f495dd2f474e66eab1effbfbe9a3c7.1698422237.git.reinette.chatre@intel.com>
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

VFIO PCI interrupt management maintains per-interrupt context within an
xarray using the interrupt vector as index.

Move the per-interrupt context to the generic interrupt context in
struct vfio_pci_intr_ctx to enable the per-interrupt context to be
managed by different backends.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- Improve changelog.

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
index 5d600548b5d7..3cfd7fdec87b 100644
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
@@ -530,7 +530,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	unsigned long i;
 	u16 cmd;
 
-	xa_for_each(&vdev->ctx, i, ctx) {
+	xa_for_each(&vdev->intr_ctx.ctx, i, ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 		vfio_msi_set_vector_signal(vdev, i, -1, msix);
@@ -810,6 +810,7 @@ void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
 	mutex_init(&intr_ctx->igate);
+	xa_init(&intr_ctx->ctx);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 1eb5842cff11..0f9df87aedd9 100644
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

