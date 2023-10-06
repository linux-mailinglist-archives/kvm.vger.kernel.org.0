Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06087BBCF6
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbjJFQle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbjJFQl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7656AC6;
        Fri,  6 Oct 2023 09:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610486; x=1728146486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ou+SRXms9LisTejR3mJn+2Rozp3+dLcRKxolISFyWJI=;
  b=AM6X805OU2YbhW5fG19shSorxyt0tPMPZlxU5rOG7HPrFZaI0dJhRWjV
   443pmeVXsLeejYrbcOPVHS9rdZrsU+bFNtLOleMV9MV6PkoX2F+i+Aeag
   TxvNu9Z4oxBwOczeEa5DQrK0mdb9kuyic/wmkEodCtVitLLim3zET7j0B
   bGnTril8o/YJQmGjnuDttiVR9Biqv5FwVpWIzNd24PD3cwtTKfi8U1Kuw
   CG5ND9epepvRaREibF0/W5UwRRlCSXPzMk9G/R5Yhz9rMDHbp00MbBBk1
   7ajsNx5N9XGCe125Rn+6dIFjrSruN6sG3mt5/JsdQnu+bBf51zWfm2bYl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063173"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063173"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892852"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892852"
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
Subject: [RFC PATCH V2 05/18] vfio/pci: Split PCI interrupt management into front and backend
Date:   Fri,  6 Oct 2023 09:41:00 -0700
Message-Id: <69914e48265761e053d898f800fc737a4ef654f3.1696609476.git.reinette.chatre@intel.com>
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

VFIO PCI interrupt management supports passthrough PCI devices
with an interrupt in the guest backed by the same type of
interrupt on the actual PCI device.

PCI interrupt management can be more flexible. An interrupt in
the guest may be backed by a different type of interrupt on the
host, for example MSI-X in guest can be backed by IMS on the host,
or not backed by a device at all when it needs to be emulated in
the virtual device driver.

The main entry to guest interrupt management is via the
VFIO_DEVICE_SET_IRQS ioctl(). By default the work is
passed to interrupt management for PCI devices with the
PCI specific functions called directly.

Make the ioctl() handling configurable to support different
interrupt management backends. This is accomplished
by introducing interrupt context specific callbacks that
are initialized by the virtual device driver and then
triggered via the ioctl().

The introduction of virtual device driver specific callbacks
require its initialization. Create a dedicated interrupt context
initialization function to avoid mixing more interrupt
context initialization with general virtual device driver
initialization.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c  |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c | 35 +++++++++++++++++++++++++------
 include/linux/vfio_pci_core.h     | 25 ++++++++++++++++++++++
 3 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index bb8181444c41..310259bbacae 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2166,7 +2166,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
-	vdev->intr_ctx.priv = vdev;
+	vfio_pci_init_intr_ctx(vdev, &vdev->intr_ctx);
 
 	return 0;
 }
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6d09a82def87..e2d39b7561b8 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -795,6 +795,23 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 					       count, flags, data);
 }
 
+struct vfio_pci_intr_ops vfio_pci_intr_ops = {
+	.set_intx_mask = vfio_pci_set_intx_mask,
+	.set_intx_unmask = vfio_pci_set_intx_unmask,
+	.set_intx_trigger = vfio_pci_set_intx_trigger,
+	.set_msi_trigger = vfio_pci_set_msi_trigger,
+	.set_err_trigger = vfio_pci_set_err_trigger,
+	.set_req_trigger = vfio_pci_set_req_trigger,
+};
+
+void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
+			    struct vfio_pci_intr_ctx *intr_ctx)
+{
+	intr_ctx->ops = &vfio_pci_intr_ops;
+	intr_ctx->priv = vdev;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
@@ -807,13 +824,16 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 	case VFIO_PCI_INTX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_MASK:
-			func = vfio_pci_set_intx_mask;
+			if (intr_ctx->ops->set_intx_mask)
+				func = intr_ctx->ops->set_intx_mask;
 			break;
 		case VFIO_IRQ_SET_ACTION_UNMASK:
-			func = vfio_pci_set_intx_unmask;
+			if (intr_ctx->ops->set_intx_unmask)
+				func = intr_ctx->ops->set_intx_unmask;
 			break;
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			func = vfio_pci_set_intx_trigger;
+			if (intr_ctx->ops->set_intx_trigger)
+				func = intr_ctx->ops->set_intx_trigger;
 			break;
 		}
 		break;
@@ -825,21 +845,24 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			/* XXX Need masking support exported */
 			break;
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			func = vfio_pci_set_msi_trigger;
+			if (intr_ctx->ops->set_msi_trigger)
+				func = intr_ctx->ops->set_msi_trigger;
 			break;
 		}
 		break;
 	case VFIO_PCI_ERR_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			func = vfio_pci_set_err_trigger;
+			if (intr_ctx->ops->set_err_trigger)
+				func = intr_ctx->ops->set_err_trigger;
 			break;
 		}
 		break;
 	case VFIO_PCI_REQ_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			func = vfio_pci_set_req_trigger;
+			if (intr_ctx->ops->set_req_trigger)
+				func = intr_ctx->ops->set_req_trigger;
 			break;
 		}
 		break;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 66bde5a60be7..aba69669ec25 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -51,12 +51,35 @@ struct vfio_pci_region {
 
 /*
  * Interrupt context of virtual PCI device
+ * @ops:		Callbacks triggered via VFIO_DEVICE_SET_IRQS ioctl()
  * @priv:		Private data
  */
 struct vfio_pci_intr_ctx {
+	const struct vfio_pci_intr_ops	*ops;
 	void				*priv;
 };
 
+struct vfio_pci_intr_ops {
+	int (*set_intx_mask)(struct vfio_pci_intr_ctx *intr_ctx,
+			     unsigned int index, unsigned int start,
+			     unsigned int count, uint32_t flags, void *data);
+	int (*set_intx_unmask)(struct vfio_pci_intr_ctx *intr_ctx,
+			       unsigned int index, unsigned int start,
+			       unsigned int count, uint32_t flags, void *data);
+	int (*set_intx_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
+				unsigned int index, unsigned int start,
+				unsigned int count, uint32_t flags, void *data);
+	int (*set_msi_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
+			       unsigned int index, unsigned int start,
+			       unsigned int count, uint32_t flags, void *data);
+	int (*set_err_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
+			       unsigned int index, unsigned int start,
+			       unsigned int count, uint32_t flags, void *data);
+	int (*set_req_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
+			       unsigned int index, unsigned int start,
+			       unsigned int count, uint32_t flags, void *data);
+};
+
 struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
@@ -124,6 +147,8 @@ int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
 				  int nr_virtfn);
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg);
+void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
+			    struct vfio_pci_intr_ctx *intr_ctx);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
-- 
2.34.1

