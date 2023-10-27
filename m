Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988AE7D9E79
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346349AbjJ0RBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346130AbjJ0RBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BFF1AC;
        Fri, 27 Oct 2023 10:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426092; x=1729962092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+BceffSdjfzhxDzKvutJR5FzA2WFYIt4Jk5nR/uMrQI=;
  b=iWlMdvqNYZ9TJOAmzeC6OoBowPReL2o8MZMdozBagxOaMjrHzydJNtUO
   8MJFalrjtdWaVjR5BV+goE5SOMqN8T0yYVo7ddpB4Q5kc0qoyrmDUGBup
   6bq9EBliwiCmwR0bCxuniHB1QmRbA0QyqnTDjlfriqIz+ns1UZEZ77Jy5
   IXyiPtzH/HV8/uVEdvLd3leeyF693MZ6HeoD8SKgP3ZHDz0duU2ZmJHES
   mXjP7MmSK6m9OvK8dTzhCSjv5pl74/wtmellir7Jr7A+kGWIi9ofiPRIh
   Wxv2NlMuEIsBMtkM7J/jOKRn9H8gcEAcQpmQJr7it1QnlKzyv4gUHqHIW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611911"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611911"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988182"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988182"
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
Subject: [RFC PATCH V3 10/26] vfio/pci: Move IRQ type to generic interrupt context
Date:   Fri, 27 Oct 2023 10:00:42 -0700
Message-Id: <9ad61f26e4bc76a007780475919cbb58d550da88.1698422237.git.reinette.chatre@intel.com>
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

The type of interrupts within the guest is not unique to
PCI devices and needed for other virtual devices supporting
interrupts.

Move interrupt type to the generic interrupt context struct
vfio_pci_intr_ctx.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Question for maintainers:
irq_type is accessed in ioctl() flow as well as other
flows. It is not clear to me how it is protected against
concurrent access. Should accesses outside of ioctl() flow
take the mutex?

No changes since RFC V2.

 drivers/vfio/pci/vfio_pci_config.c |  2 +-
 drivers/vfio/pci/vfio_pci_core.c   |  5 ++---
 drivers/vfio/pci/vfio_pci_intrs.c  | 21 +++++++++++----------
 include/linux/vfio_pci_core.h      |  3 ++-
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 7e2e62ab0869..2535bdbc016d 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1168,7 +1168,7 @@ static int vfio_msi_config_write(struct vfio_pci_core_device *vdev, int pos,
 		flags = le16_to_cpu(*pflags);
 
 		/* MSI is enabled via ioctl */
-		if  (vdev->irq_type != VFIO_PCI_MSI_IRQ_INDEX)
+		if  (vdev->intr_ctx.irq_type != VFIO_PCI_MSI_IRQ_INDEX)
 			flags &= ~PCI_MSI_FLAGS_ENABLE;
 
 		/* Check queue size */
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index cf303a9555f0..34109ed38454 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -427,7 +427,7 @@ static int vfio_pci_core_runtime_suspend(struct device *dev)
 	 * vfio_pci_intx_mask() will return false and in that case, INTx
 	 * should not be unmasked in the runtime resume.
 	 */
-	vdev->pm_intx_masked = ((vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX) &&
+	vdev->pm_intx_masked = ((vdev->intr_ctx.irq_type == VFIO_PCI_INTX_IRQ_INDEX) &&
 				vfio_pci_intx_mask(vdev));
 
 	return 0;
@@ -596,7 +596,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 
 	vfio_pci_set_irqs_ioctl(&vdev->intr_ctx, VFIO_IRQ_SET_DATA_NONE |
 				VFIO_IRQ_SET_ACTION_TRIGGER,
-				vdev->irq_type, 0, 0, NULL);
+				vdev->intr_ctx.irq_type, 0, 0, NULL);
 
 	/* Device closed, don't need mutex here */
 	list_for_each_entry_safe(ioeventfd, ioeventfd_tmp,
@@ -2153,7 +2153,6 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
-	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3cfd7fdec87b..858795ba50fe 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -33,19 +33,19 @@ struct vfio_pci_irq_ctx {
 
 static bool irq_is(struct vfio_pci_core_device *vdev, int type)
 {
-	return vdev->irq_type == type;
+	return vdev->intr_ctx.irq_type == type;
 }
 
 static bool is_intx(struct vfio_pci_core_device *vdev)
 {
-	return vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX;
+	return vdev->intr_ctx.irq_type == VFIO_PCI_INTX_IRQ_INDEX;
 }
 
 static bool is_irq_none(struct vfio_pci_core_device *vdev)
 {
-	return !(vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX ||
-		 vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX ||
-		 vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
+	return !(vdev->intr_ctx.irq_type == VFIO_PCI_INTX_IRQ_INDEX ||
+		 vdev->intr_ctx.irq_type == VFIO_PCI_MSI_IRQ_INDEX ||
+		 vdev->intr_ctx.irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
 }
 
 static
@@ -255,7 +255,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	if (vdev->pci_2_3)
 		pci_intx(vdev->pdev, !ctx->masked);
 
-	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
+	vdev->intr_ctx.irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
 	return 0;
 }
@@ -331,7 +331,7 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 		vfio_virqfd_disable(&ctx->mask);
 	}
 	vfio_intx_set_signal(vdev, -1);
-	vdev->irq_type = VFIO_PCI_NUM_IRQS;
+	vdev->intr_ctx.irq_type = VFIO_PCI_NUM_IRQS;
 	vfio_irq_ctx_free(vdev, ctx, 0);
 }
 
@@ -367,7 +367,7 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	}
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
-	vdev->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
+	vdev->intr_ctx.irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
 				VFIO_PCI_MSI_IRQ_INDEX;
 
 	if (!msix) {
@@ -547,7 +547,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	if (vdev->nointx)
 		pci_intx(pdev, 0);
 
-	vdev->irq_type = VFIO_PCI_NUM_IRQS;
+	vdev->intr_ctx.irq_type = VFIO_PCI_NUM_IRQS;
 }
 
 /*
@@ -677,7 +677,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 		int32_t *fds = data;
 		int ret;
 
-		if (vdev->irq_type == index)
+		if (vdev->intr_ctx.irq_type == index)
 			return vfio_msi_set_block(vdev, start, count,
 						  fds, msix);
 
@@ -807,6 +807,7 @@ static struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 			    struct vfio_pci_intr_ctx *intr_ctx)
 {
+	intr_ctx->irq_type = VFIO_PCI_NUM_IRQS;
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
 	mutex_init(&intr_ctx->igate);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 0f9df87aedd9..e666c19da223 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -57,6 +57,7 @@ struct vfio_pci_region {
  * @err_trigger:	Eventfd associated with error reporting IRQ
  * @req_trigger:	Eventfd associated with device request notification
  * @ctx:		Per-interrupt context indexed by vector
+ * @irq_type:		Type of interrupt from guest perspective
  */
 struct vfio_pci_intr_ctx {
 	const struct vfio_pci_intr_ops	*ops;
@@ -65,6 +66,7 @@ struct vfio_pci_intr_ctx {
 	struct eventfd_ctx		*err_trigger;
 	struct eventfd_ctx		*req_trigger;
 	struct xarray			ctx;
+	int				irq_type;
 };
 
 struct vfio_pci_intr_ops {
@@ -100,7 +102,6 @@ struct vfio_pci_core_device {
 	u8			*vconfig;
 	struct perm_bits	*msi_perm;
 	spinlock_t		irqlock;
-	int			irq_type;
 	int			num_regions;
 	struct vfio_pci_region	*region;
 	u8			msi_qmax;
-- 
2.34.1

