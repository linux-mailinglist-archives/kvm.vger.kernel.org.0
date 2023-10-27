Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC447D9E82
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346493AbjJ0RCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346312AbjJ0RBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240E61AA;
        Fri, 27 Oct 2023 10:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426100; x=1729962100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pWW9/chnawglktdCwIKFGbmE0Wc5Bu/x/Utfmgc3Jg4=;
  b=WOTsayEboxcCB+Q20ZwsRVUqPaHDim67Jsx+9+o0ueXQXSmLaoA1Ytjt
   EYF7rY+d/rLFBqJHZNKRVefigtUwct+biY7x7/Ta+1YjMQE0cOJHqnj8K
   FqaLeFofYnjtzgJ8KsVN7vLktCWPXV3JDanlxvZsLu3v5qrdQrbxDlJ2i
   MvP69p0uEgDGbAL9HZOdQ59+RpNAXQJ8fhlawOzaiviSSb0cdouWlTGCh
   shazwQ4K8PBmmNAOSsVQoUNg7TH5Uv1qUihjMsFbN96HkmJKN2n4SVZLF
   rjMoxZ2MKihYWuOVpRDa5ZdoP63+jaffXZrv1wgGSqrAUSkFjxpPwNLG9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612139"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612139"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988238"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988238"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:20 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 24/26] vfio/pci: Add core IMS support
Date:   Fri, 27 Oct 2023 10:00:56 -0700
Message-Id: <e2029ef0084683170fe90ae526a5cf1c676cd1a3.1698422237.git.reinette.chatre@intel.com>
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

Add a new interrupt management backend enabling a guest MSI-X
interrupt to be backed by an IMS interrupt on the host.

An IMS interrupt is allocated via pci_ims_alloc_irq() and requires
an implementation specific cookie that is opaque to the IMS backend.
This can be a PASID, queue ID, pointer etc. During initialization
the IMS backend learns which PCI device to operate on (and thus which
interrupt domain to allocate from) and what the default cookie should
be for any new interrupt allocation.

A virtual device driver starts by initializing the backend
using new vfio_pci_ims_init_intr_ctx(), cleanup using new
vfio_pci_ims_release_intr_ctx(). Once initialized the virtual
device driver can call vfio_pci_set_irqs_ioctl() to handle the
VFIO_DEVICE_SET_IRQS ioctl() after it has validated the parameters
to be appropriate for the particular device.

To support the IMS backend the core utilities need to be aware
which interrupt context it interacts with. New ims_backed_irq
enables this and is false for the PCI passthrough backend and
true for the IMS backend.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- Improve changelog.
- Refactored implementation to use new callbacks for interrupt
  enable/disable and allocate/free to eliminate code duplication. (Kevin)
- Make vfio_pci_ims_intr_ops static.

 drivers/vfio/pci/vfio_pci_intrs.c | 178 ++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h     |   7 ++
 2 files changed, 185 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6e34b8d8c216..b318a3f671e8 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -22,6 +22,21 @@
 
 #include "vfio_pci_priv.h"
 
+/*
+ * Interrupt Message Store (IMS) private interrupt context data
+ * @vdev:		Virtual device. Used for name of device in
+ *			request_irq().
+ * @pdev:		PCI device owning the IMS domain from where
+ *			interrupts are allocated.
+ * @default_cookie:	Default cookie used for IMS interrupts without unique
+ *			cookie.
+ */
+struct vfio_pci_ims {
+	struct vfio_device		*vdev;
+	struct pci_dev			*pdev;
+	union msi_instance_cookie	default_cookie;
+};
+
 struct vfio_pci_irq_ctx {
 	bool			emulated:1;
 	struct eventfd_ctx	*trigger;
@@ -31,6 +46,8 @@ struct vfio_pci_irq_ctx {
 	bool			masked;
 	struct irq_bypass_producer	producer;
 	int			virq;
+	int			ims_id;
+	union msi_instance_cookie	icookie;
 };
 
 static bool irq_is(struct vfio_pci_intr_ctx *intr_ctx, int type)
@@ -899,6 +916,7 @@ void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 	_vfio_pci_init_intr_ctx(intr_ctx);
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
+	intr_ctx->ims_backed_irq = false;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
 
@@ -985,6 +1003,166 @@ int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_set_emulated);
 
+/* Guest MSI-X interrupts backed by IMS host interrupts */
+
+/*
+ * Free the IMS interrupt associated with @ctx.
+ *
+ * For an IMS interrupt the interrupt is freed from the underlying
+ * PCI device's IMS domain.
+ */
+static void vfio_pci_ims_irq_free(struct vfio_pci_intr_ctx *intr_ctx,
+				  struct vfio_pci_irq_ctx *ctx)
+{
+	struct vfio_pci_ims *ims = intr_ctx->priv;
+	struct msi_map irq_map = {};
+
+	irq_map.index = ctx->ims_id;
+	irq_map.virq = ctx->virq;
+	pci_ims_free_irq(ims->pdev, irq_map);
+	ctx->ims_id = -EINVAL;
+	ctx->virq = 0;
+}
+
+/*
+ * Allocate a host IMS interrupt for @ctx.
+ *
+ * For an IMS interrupt the interrupt is allocated from the underlying
+ * PCI device's IMS domain.
+ */
+static int vfio_pci_ims_irq_alloc(struct vfio_pci_intr_ctx *intr_ctx,
+				  struct vfio_pci_irq_ctx *ctx)
+{
+	struct vfio_pci_ims *ims = intr_ctx->priv;
+	struct msi_map irq_map = {};
+
+	irq_map = pci_ims_alloc_irq(ims->pdev, &ctx->icookie, NULL);
+	if (irq_map.index < 0)
+		return irq_map.index;
+
+	ctx->ims_id = irq_map.index;
+	ctx->virq = irq_map.virq;
+
+	return 0;
+}
+
+static void vfio_ims_free_interrupt(struct vfio_pci_intr_ctx *intr_ctx,
+				    struct vfio_pci_irq_ctx *ctx,
+				    unsigned int vector)
+{
+	free_irq(ctx->virq, ctx->trigger);
+	vfio_pci_ims_irq_free(intr_ctx, ctx);
+}
+
+static int vfio_ims_request_interrupt(struct vfio_pci_intr_ctx *intr_ctx,
+				      struct vfio_pci_irq_ctx *ctx,
+				      unsigned int vector,
+				      unsigned int index)
+{
+	int ret;
+
+	ret = vfio_pci_ims_irq_alloc(intr_ctx, ctx);
+	if (ret < 0)
+		return ret;
+
+	ret = request_irq(ctx->virq, vfio_msihandler, 0, ctx->name,
+			  ctx->trigger);
+	if (ret < 0) {
+		vfio_pci_ims_irq_free(intr_ctx, ctx);
+		return ret;
+	}
+
+	return 0;
+}
+
+static char *vfio_ims_device_name(struct vfio_pci_intr_ctx *intr_ctx,
+				  unsigned int vector,
+				  unsigned int index)
+{
+	struct vfio_pci_ims *ims = intr_ctx->priv;
+	struct device *dev = &ims->vdev->device;
+
+	return kasprintf(GFP_KERNEL, "vfio-ims[%d](%s)", vector, dev_name(dev));
+}
+
+static void vfio_ims_disable(struct vfio_pci_intr_ctx *intr_ctx,
+			     unsigned int index)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned long i;
+
+	xa_for_each(&intr_ctx->ctx, i, ctx)
+		vfio_msi_set_vector_signal(intr_ctx, i, -1, index);
+}
+
+/*
+ * The virtual device driver is responsible for enabling IMS by creating
+ * the IMS domaim from where interrupts will be allocated dynamically.
+ * IMS thus has to be enabled by the time an ioctl() arrives.
+ */
+static int vfio_ims_enable(struct vfio_pci_intr_ctx *intr_ctx, int nvec,
+			   unsigned int index)
+{
+	return -EINVAL;
+}
+
+static int vfio_ims_init_irq_ctx(struct vfio_pci_intr_ctx *intr_ctx,
+				 struct vfio_pci_irq_ctx *ctx)
+{
+	struct vfio_pci_ims *ims = intr_ctx->priv;
+
+	ctx->icookie = ims->default_cookie;
+
+	return 0;
+}
+
+static struct vfio_pci_intr_ops vfio_pci_ims_intr_ops = {
+	.set_msix_trigger = vfio_pci_set_msi_trigger,
+	.set_req_trigger = vfio_pci_set_req_trigger,
+	.msi_enable = vfio_ims_enable,
+	.msi_disable = vfio_ims_disable,
+	.msi_request_interrupt = vfio_ims_request_interrupt,
+	.msi_free_interrupt = vfio_ims_free_interrupt,
+	.msi_device_name = vfio_ims_device_name,
+	.init_irq_ctx = vfio_ims_init_irq_ctx,
+};
+
+int vfio_pci_ims_init_intr_ctx(struct vfio_device *vdev,
+			       struct vfio_pci_intr_ctx *intr_ctx,
+			       struct pci_dev *pdev,
+			       union msi_instance_cookie *default_cookie)
+{
+	struct vfio_pci_ims *ims;
+
+	ims = kzalloc(sizeof(*ims), GFP_KERNEL_ACCOUNT);
+	if (!ims)
+		return -ENOMEM;
+
+	ims->pdev = pdev;
+	ims->default_cookie = *default_cookie;
+	ims->vdev = vdev;
+
+	_vfio_pci_init_intr_ctx(intr_ctx);
+
+	intr_ctx->ops = &vfio_pci_ims_intr_ops;
+	intr_ctx->priv = ims;
+	intr_ctx->ims_backed_irq = true;
+	intr_ctx->irq_type = VFIO_PCI_MSIX_IRQ_INDEX;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_init_intr_ctx);
+
+void vfio_pci_ims_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
+{
+	struct vfio_pci_ims *ims = intr_ctx->priv;
+
+	_vfio_pci_release_intr_ctx(intr_ctx);
+	kfree(ims);
+	intr_ctx->irq_type = VFIO_PCI_NUM_IRQS;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_release_intr_ctx);
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 4fe0df25162f..a3161af791f8 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -58,6 +58,7 @@ struct vfio_pci_region {
  * @req_trigger:	Eventfd associated with device request notification
  * @ctx:		Per-interrupt context indexed by vector
  * @irq_type:		Type of interrupt from guest perspective
+ * @ims_backed_irq:	Interrupts managed by IMS backend
  */
 struct vfio_pci_intr_ctx {
 	const struct vfio_pci_intr_ops	*ops;
@@ -67,6 +68,7 @@ struct vfio_pci_intr_ctx {
 	struct eventfd_ctx		*req_trigger;
 	struct xarray			ctx;
 	int				irq_type;
+	bool				ims_backed_irq:1;
 };
 
 struct vfio_pci_irq_ctx;
@@ -181,6 +183,11 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 void vfio_pci_send_signal(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
 int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
 			  unsigned int start, unsigned int count);
+int vfio_pci_ims_init_intr_ctx(struct vfio_device *vdev,
+			       struct vfio_pci_intr_ctx *intr_ctx,
+			       struct pci_dev *pdev,
+			       union msi_instance_cookie *default_cookie);
+void vfio_pci_ims_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
-- 
2.34.1

