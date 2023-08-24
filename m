Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB4978750D
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 18:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242448AbjHXQRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 12:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242486AbjHXQRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 12:17:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFAF1BCF;
        Thu, 24 Aug 2023 09:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692893819; x=1724429819;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mq2aRmAcfbrdSdt5gW/2BzOzfXmRF4LemvYI13FsMVA=;
  b=oBilCOy0pUvtxy52ZIN55n1a7xZ5e6e8FOoTCmdBSR2PyK0YxivJdCQC
   gfJNKUT5ibIkEt/XMbLllvGG4HqVMFFHwUst3BLZrectai8/twu0RUUIu
   jGMNUUWCywn/t/YNe+ZQROs6LqgYw7ZLoalhR46VDDHVG1SR4DhFrXfhY
   WpHN1Be+W9jcuO4lyPEzBVboMxECxdu1dUX6nMco893GZvFH1o5uAVwK6
   muyGQhprsf6MoLoYTo8bNFF3+Q46cmJRsrikUcNo8yUvl1mn3Pb7egmFc
   26RHHOFwlw+MVGvMQTEXgtTVQ8be80kDJ/uoZW6d6zOcCgS8wozZSyCoB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="364679247"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="364679247"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 09:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="686970909"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="686970909"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 09:15:38 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] vfio/ims: Support emulated interrupts
Date:   Thu, 24 Aug 2023 09:15:21 -0700
Message-Id: <7a08c41e1825095814f8c35854d3938c084b2368.1692892275.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1692892275.git.reinette.chatre@intel.com>
References: <cover.1692892275.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Access from a guest to a virtual device may be either 'direct-path',
where the guest interacts directly with the underlying hardware,
or 'intercepted path' where the virtual device emulates operations.

Support emulated interrupts that can be used to handle 'intercepted
path' operations. For example, a virtual device may use 'intercepted
path' for configuration. Doing so, configuration requests intercepted
by the virtual device driver are handled within the virtual device
driver with completion signaled to the guest without interacting with
the underlying hardware.

Add vfio_pci_ims_set_emulated() and vfio_pci_ims_send_signal() to
the VFIO PCI IMS API. vfio_pci_ims_set_emulated() configures a
range of interrupts that are emulated. Any range of interrupts
can be configured as emulated as long as no IMS interrupt has
previously been allocated at that vector. The virtual device
uses vfio_pci_ims_send_signal() to trigger interrupts in the guest.

Originally-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_ims.c | 117 ++++++++++++++++++++++++++++----
 include/linux/vfio.h            |  14 ++++
 2 files changed, 117 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_ims.c b/drivers/vfio/pci/vfio_pci_ims.c
index 0926eb921351..fe5b3484ad34 100644
--- a/drivers/vfio/pci/vfio_pci_ims.c
+++ b/drivers/vfio/pci/vfio_pci_ims.c
@@ -17,16 +17,18 @@
 #include <linux/xarray.h>
 
 /*
- * IMS interrupt context.
- * @name:	Name of device associated with interrupt.
+ * Interrupt context. Used for emulated as well as IMS interrupts.
+ * @emulated:	(IMS and emulated) true if context belongs to emulated interrupt.
+ * @name:	(IMS and emulated) Name of device associated with interrupt.
  *		Provided to request_irq().
- * @trigger:	eventfd associated with interrupt.
- * @producer:	Interrupt's registered IRQ bypass producer.
- * @ims_id:	Interrupt index associated with IMS interrupt.
- * @virq:	Linux IRQ number associated with IMS interrupt.
- * @icookie:	Cookie used by irqchip driver.
+ * @trigger:	(IMS and emulated) eventfd associated with interrupt.
+ * @producer:	(IMS only) Interrupt's registered IRQ bypass producer.
+ * @ims_id:	(IMS only) Interrupt index associated with IMS interrupt.
+ * @virq:	(IMS only) Linux IRQ number associated with IMS interrupt.
+ * @icookie:	(IMS only) Cookie used by irqchip driver.
  */
 struct vfio_pci_ims_ctx {
+	bool				emulated;
 	char				*name;
 	struct eventfd_ctx		*trigger;
 	struct irq_bypass_producer	producer;
@@ -35,6 +37,31 @@ struct vfio_pci_ims_ctx {
 	union msi_instance_cookie	icookie;
 };
 
+/*
+ * Send signal to the eventfd.
+ * @vdev:	VFIO device
+ * @vector:	MSI-X vector of @vdev for which interrupt will be signaled
+ *
+ * Intended for use to send signal for emulated interrupts.
+ */
+void vfio_pci_ims_send_signal(struct vfio_device *vdev, unsigned int vector)
+{
+	struct vfio_pci_ims *ims = &vdev->ims;
+	struct vfio_pci_ims_ctx *ctx;
+
+	mutex_lock(&ims->ctx_mutex);
+	ctx = xa_load(&ims->ctx, vector);
+
+	if (WARN_ON_ONCE(!ctx || !ctx->emulated || !ctx->trigger)) {
+		mutex_unlock(&ims->ctx_mutex);
+		return;
+	}
+
+	eventfd_signal(ctx->trigger, 1);
+	mutex_unlock(&ims->ctx_mutex);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_send_signal);
+
 static irqreturn_t vfio_pci_ims_irq_handler(int irq, void *arg)
 {
 	struct eventfd_ctx *trigger = arg;
@@ -46,7 +73,8 @@ static irqreturn_t vfio_pci_ims_irq_handler(int irq, void *arg)
 /*
  * Free the interrupt associated with @ctx.
  *
- * Free interrupt from the underlying PCI device's IMS domain.
+ * For an emulated interrupt there is nothing to do. For an IMS interrupt
+ * the interrupt is freed from the underlying PCI device's IMS domain.
  */
 static void vfio_pci_ims_irq_free(struct vfio_pci_ims *ims,
 				  struct vfio_pci_ims_ctx *ctx)
@@ -55,6 +83,9 @@ static void vfio_pci_ims_irq_free(struct vfio_pci_ims *ims,
 
 	lockdep_assert_held(&ims->ctx_mutex);
 
+	if (ctx->emulated)
+		return;
+
 	irq_map.index = ctx->ims_id;
 	irq_map.virq = ctx->virq;
 	pci_ims_free_irq(ims->pdev, irq_map);
@@ -65,7 +96,8 @@ static void vfio_pci_ims_irq_free(struct vfio_pci_ims *ims,
 /*
  * Allocate an interrupt for @ctx.
  *
- * Allocate interrupt from the underlying PCI device's IMS domain.
+ * For an emulated interrupt there is nothing to do. For an IMS interrupt
+ * the interrupt is allocated from the underlying PCI device's IMS domain.
  */
 static int vfio_pci_ims_irq_alloc(struct vfio_pci_ims *ims,
 				  struct vfio_pci_ims_ctx *ctx)
@@ -74,6 +106,9 @@ static int vfio_pci_ims_irq_alloc(struct vfio_pci_ims *ims,
 
 	lockdep_assert_held(&ims->ctx_mutex);
 
+	if (ctx->emulated)
+		return -EINVAL;
+
 	irq_map = pci_ims_alloc_irq(ims->pdev, &ctx->icookie, NULL);
 	if (irq_map.index < 0)
 		return irq_map.index;
@@ -133,9 +168,11 @@ static int vfio_pci_ims_set_vector_signal(struct vfio_device *vdev,
 	ctx = xa_load(&ims->ctx, vector);
 
 	if (ctx && ctx->trigger) {
-		irq_bypass_unregister_producer(&ctx->producer);
-		free_irq(ctx->virq, ctx->trigger);
-		vfio_pci_ims_irq_free(ims, ctx);
+		if (!ctx->emulated) {
+			irq_bypass_unregister_producer(&ctx->producer);
+			free_irq(ctx->virq, ctx->trigger);
+			vfio_pci_ims_irq_free(ims, ctx);
+		}
 		kfree(ctx->name);
 		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
@@ -163,6 +200,9 @@ static int vfio_pci_ims_set_vector_signal(struct vfio_device *vdev,
 
 	ctx->trigger = trigger;
 
+	if (ctx->emulated)
+		return 0;
+
 	ret = vfio_pci_ims_irq_alloc(ims, ctx);
 	if (ret < 0)
 		goto out_put_eventfd_ctx;
@@ -219,8 +259,8 @@ static int vfio_pci_ims_set_block(struct vfio_device *vdev, unsigned int start,
 }
 
 /*
- * Manage Interrupt Message Store (IMS) interrupts on the host that are
- * backing guest MSI-X vectors.
+ * Manage Interrupt Message Store (IMS) or emulated interrupts on the
+ * host that are backing guest MSI-X vectors.
  *
  * @vdev:	 VFIO device
  * @index:	 Type of guest vectors to set up.  Must be
@@ -360,6 +400,10 @@ int vfio_pci_ims_set_cookie(struct vfio_device *vdev, unsigned int vector,
 	mutex_lock(&ims->ctx_mutex);
 	ctx = xa_load(&ims->ctx, vector);
 	if (ctx) {
+		if (WARN_ON_ONCE(ctx->emulated)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
 		ctx->icookie = *icookie;
 		goto out_unlock;
 	}
@@ -385,5 +429,50 @@ int vfio_pci_ims_set_cookie(struct vfio_device *vdev, unsigned int vector,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_ims_set_cookie);
 
+/*
+ * Set range of interrupts that will be emulated instead of backed by IMS.
+ *
+ * Return: error code on failure (-EBUSY if the vector is not available,
+ * -ENOMEM on allocation failure), 0 on success
+ */
+int vfio_pci_ims_set_emulated(struct vfio_device *vdev, unsigned int start,
+			      unsigned int count)
+{
+	struct vfio_pci_ims *ims = &vdev->ims;
+	struct vfio_pci_ims_ctx *ctx;
+	unsigned long i, j;
+	int ret = 0;
+
+	mutex_lock(&ims->ctx_mutex);
+
+	for (i = start; i < start + count; i++) {
+		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+		if (!ctx) {
+			ret = -ENOMEM;
+			goto out_err;
+		}
+		ctx->emulated = true;
+		ret = xa_insert(&ims->ctx, i, ctx, GFP_KERNEL_ACCOUNT);
+		if (ret) {
+			kfree(ctx);
+			goto out_err;
+		}
+	}
+
+	mutex_unlock(&ims->ctx_mutex);
+	return 0;
+
+out_err:
+	for (j = start; j < i; j++) {
+		ctx = xa_load(&ims->ctx, j);
+		xa_erase(&ims->ctx, j);
+		kfree(ctx);
+	}
+	mutex_unlock(&ims->ctx_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_set_emulated);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Intel Corporation");
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index aa54239bff4d..906220002ff4 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -334,6 +334,9 @@ int vfio_pci_set_ims_trigger(struct vfio_device *vdev, unsigned int index,
 void vfio_pci_ims_init(struct vfio_device *vdev, struct pci_dev *pdev,
 		       union msi_instance_cookie *default_cookie);
 void vfio_pci_ims_free(struct vfio_device *vdev);
+int vfio_pci_ims_set_emulated(struct vfio_device *vdev, unsigned int start,
+			      unsigned int count);
+void vfio_pci_ims_send_signal(struct vfio_device *vdev, unsigned int vector);
 int vfio_pci_ims_set_cookie(struct vfio_device *vdev, unsigned int vector,
 			    union msi_instance_cookie *icookie);
 #else
@@ -353,6 +356,17 @@ static inline void vfio_pci_ims_init(struct vfio_device *vdev,
 
 static inline void vfio_pci_ims_free(struct vfio_device *vdev) {}
 
+static inline int vfio_pci_ims_set_emulated(struct vfio_device *vdev,
+					    unsigned int start,
+					    unsigned int count)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_pci_ims_send_signal(struct vfio_device *vdev,
+					    unsigned int vector)
+{}
+
 static inline int vfio_pci_ims_set_cookie(struct vfio_device *vdev,
 					  unsigned int vector,
 					  union msi_instance_cookie *icookie)
-- 
2.34.1

