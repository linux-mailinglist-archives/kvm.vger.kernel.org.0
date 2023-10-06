Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7577BBCF5
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjJFQla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjJFQl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76449BF;
        Fri,  6 Oct 2023 09:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610486; x=1728146486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UrZaf9/sFCZSVDnrmskYei92u/SNvt1MrCiAFvLj6EI=;
  b=bEYWJrUtof2MJPyM2f75aBjkFcd5Zu618LR9Y8LBsalW+g7Untg8X2u5
   gIi8OHLhF/uokUR7jqHybrfRRPJqGhhp585JarwX9lwRLnvDOBAzGWfPs
   UtG1A973FdZm1no/9b9Z9YXUdliG3MAmywt5/OK+JKDLa75lJ8WMzYtz0
   MGa69d2K7jNvqVCf4h1Mj9jI63SfKcRIWFqkav+KfMt6TALWc17SLndGM
   a+lmG0VQd4awlCDMp8DKJnFUXrovTWS2D/C0Bv820bObs7C1V1eSB5G3J
   6DpAlRSvh0R3bW8HYMFRvUQD4lUvFo27nxCQb7AwXFCjELbKVQPkMkCTH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063167"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063167"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892848"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892848"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 04/18] vfio/pci: Make core interrupt callbacks accessible to all virtual devices
Date:   Fri,  6 Oct 2023 09:40:59 -0700
Message-Id: <42e2d8fdf80b6022bdc844ee3a18b5c7988fcf0f.1696609476.git.reinette.chatre@intel.com>
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

The functions handling actions on interrupts for a virtual PCI device
triggered by VFIO_DEVICE_SET_IRQS ioctl() expect to act on a passthrough
PCI device represented by a struct vfio_pci_core_device.

A virtual device can support MSI-X while not being a passthrough PCI
device and thus not be represented by a struct vfio_pci_core_device.

To support MSI-X in all virtual devices it needs to be possible for
their drivers to interact with the MSI-X interrupt management and
thus the interrupt management should not require struct
vfio_pci_core_device.

Introduce struct vfio_pci_intr_ctx that will contain the interrupt
context of a virtual device that can be managed by different backends.
The first supported backend is the existing PCI interrupt management.
The core VFIO PCI interrupt management functions are modified to expect
this structure. As a backend managing interrupts of passthrough PCI
devices the existing VFIO PCI functions do still require to operate on
an actual PCI device represented by struct vfio_pci_core_device that
is provided via a private pointer.

More members are added to struct vfio_pci_intr_ctx in later patches
as members unique to interrupt context are transitioned from struct
vfio_pci_core_device.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c  |  7 ++++---
 drivers/vfio/pci/vfio_pci_intrs.c | 29 ++++++++++++++++++++---------
 drivers/vfio/pci/vfio_pci_priv.h  |  2 +-
 include/linux/vfio_pci_core.h     |  9 +++++++++
 4 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1929103ee59a..bb8181444c41 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -594,7 +594,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
 
-	vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
+	vfio_pci_set_irqs_ioctl(&vdev->intr_ctx, VFIO_IRQ_SET_DATA_NONE |
 				VFIO_IRQ_SET_ACTION_TRIGGER,
 				vdev->irq_type, 0, 0, NULL);
 
@@ -1216,8 +1216,8 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 
 	mutex_lock(&vdev->igate);
 
-	ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index, hdr.start,
-				      hdr.count, data);
+	ret = vfio_pci_set_irqs_ioctl(&vdev->intr_ctx, hdr.flags, hdr.index,
+				      hdr.start, hdr.count, data);
 
 	mutex_unlock(&vdev->igate);
 	kfree(data);
@@ -2166,6 +2166,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
+	vdev->intr_ctx.priv = vdev;
 
 	return 0;
 }
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index c49588c8f4a3..6d09a82def87 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -552,11 +552,13 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 /*
  * IOCTL support
  */
-static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_intx_unmask(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
 
@@ -584,10 +586,12 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_intx_mask(struct vfio_pci_intr_ctx *intr_ctx,
 				  unsigned int index, unsigned int start,
 				  unsigned int count, uint32_t flags, void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
 
@@ -604,11 +608,13 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_intx_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				     unsigned int index, unsigned int start,
 				     unsigned int count, uint32_t flags,
 				     void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_intx_disable(vdev);
 		return 0;
@@ -648,11 +654,12 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
@@ -757,11 +764,13 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 	return -EINVAL;
 }
 
-static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_err_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (!pci_is_pcie(vdev->pdev))
 		return -ENOTTY;
 
@@ -772,11 +781,13 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 					       count, flags, data);
 }
 
-static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_req_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
@@ -784,11 +795,11 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 					       count, flags, data);
 }
 
-int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
 {
-	int (*func)(struct vfio_pci_core_device *vdev, unsigned int index,
+	int (*func)(struct vfio_pci_intr_ctx *intr_ctx, unsigned int index,
 		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
 
@@ -837,5 +848,5 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 	if (!func)
 		return -ENOTTY;
 
-	return func(vdev, index, start, count, flags, data);
+	return func(intr_ctx, index, start, count, flags, data);
 }
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5e4fa69aee16..6dddcfe7ab19 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -26,7 +26,7 @@ struct vfio_pci_ioeventfd {
 bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
-int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..66bde5a60be7 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -49,6 +49,14 @@ struct vfio_pci_region {
 	u32				flags;
 };
 
+/*
+ * Interrupt context of virtual PCI device
+ * @priv:		Private data
+ */
+struct vfio_pci_intr_ctx {
+	void				*priv;
+};
+
 struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
@@ -96,6 +104,7 @@ struct vfio_pci_core_device {
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
+	struct vfio_pci_intr_ctx	intr_ctx;
 };
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.34.1

