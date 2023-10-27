Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811017D9E73
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjJ0RBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346054AbjJ0RBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562BF11B;
        Fri, 27 Oct 2023 10:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426090; x=1729962090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/8K/5xjT+sSTW3WaO0jnJx8Y9erwUUEZ5J56SycKU4A=;
  b=K+hO8B7nq2S3zlU43GPBIT5rC7vZjmIOasAf+Eam97aRDJS9VrPJeihy
   Uwkuuvn4Gy+G1v0CqkdY8iavRvahRQnGcMk1EBQ5ruOa6pt6r2rS8aea/
   lbCr7E+60knymR2xjcc8lw+Hql/W3fDfWPgIttlHJ64UUUNvf/eybrijN
   DstnSQf38DA2bPPycIR6ZpEJvChejid1MYtqb99l1v2GKUqB8GlBlW3xo
   zOnBsvMG7xq91PiWv1Wx/3qyETURjNe4fecQIGs/oAyp5sQVip4wqw0A7
   62msY7sosAE0VMfAg+S7/Pl0jCJsEXuFCkY9273NEk2/IPQNsBzFRaYqU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611862"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611862"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988161"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988161"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:14 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 05/26] vfio/pci: Split PCI interrupt management into front and backend
Date:   Fri, 27 Oct 2023 10:00:37 -0700
Message-Id: <8362e7bf5af9ac0e6a075750a08e93cbdc08036f.1698422237.git.reinette.chatre@intel.com>
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

VFIO PCI interrupt management supports passthrough PCI devices with an
interrupt in the guest backed by the same type of interrupt on the PCI
device.

Interrupt management can be more flexible. An interrupt in the guest
may be backed by a different type of interrupt on the host, for example
MSI-X in guest can be backed by IMS on the host, or not backed by a
device interrupt at all when the interrupt is emulated by the virtual
device driver.

The main entry to guest interrupt management is via the
VFIO_DEVICE_SET_IRQS ioctl(). By default the work is passed to interrupt
management for PCI devices with the PCI specific functions called
directly.

Make the ioctl() configurable to support different interrupt management
backends. This is accomplished by introducing interrupt context specific
callbacks that are initialized by the virtual device driver and then
triggered via the ioctl().

The introduction of virtual device driver specific callbacks require its
initialization. Create a dedicated interrupt context initialization
function to avoid mixing more interrupt context initialization with
general virtual device driver initialization.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- Improve changelog and comments.
- Make vfio_pci_intr_ops static.

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
index af1053873eaa..96587acfebf0 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -796,6 +796,23 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 					       count, flags, data);
 }
 
+static struct vfio_pci_intr_ops vfio_pci_intr_ops = {
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
@@ -808,13 +825,16 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
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
@@ -826,21 +846,24 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
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
index 38355a4817fd..d3fa0e49a1a8 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -51,12 +51,35 @@ struct vfio_pci_region {
 
 /*
  * Interrupt context of virtual PCI device
+ * @ops:		Interrupt management backend functions
  * @priv:		Private data of interrupt management backend
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

