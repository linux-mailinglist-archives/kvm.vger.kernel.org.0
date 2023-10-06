Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F90A7BBD0A
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbjJFQl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjJFQll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5434A100;
        Fri,  6 Oct 2023 09:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610494; x=1728146494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WHkI6nA9PJ9BGMbmD/FyvSZEI7T8GVVcLsrHyiOf3Nk=;
  b=msNkAujAZ1ExZbvaMlxKYQsm2GdusDtwaQ593HJxsyyeiK2Zc3PHnN8W
   yJ7v0zZiVBRhZFqOO9UyEPLkl2JWJpmuapx0Oa/3ZwdMO+6ADQdBNwQLS
   tTYn4crMekoZuK7YMfGU3UqQESXIqiqvZDAuViXqLuJiA7kTFU0M/1UcN
   3cYmNbonyDr/g+WUF02uXKpl/WI/AK/S18EBRqvC0Iq5lpzjRABbyKPOx
   IvFylmiMUwiz2+J71flKKbopcF46Yv0GU3H4dAi/orOcx8L/+un0Dkp9Y
   D9+udoceEYoyS8xgSzJVbQ8j6oHEUuVvWShxndHP6VQicXVbJVzOnwzGn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063227"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063227"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892885"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892885"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:27 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 14/18] vfio/pci: Add core IMS support
Date:   Fri,  6 Oct 2023 09:41:09 -0700
Message-Id: <0f8fb7122814c5c5083799e935d5bd3d27d38aef.1696609476.git.reinette.chatre@intel.com>
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

Add a new interrupt management backend enabling a guest MSI-X
interrupt to be backed by an IMS interrupt on the host.

An IMS interrupt is allocated via pci_ims_alloc_irq() and requires
an implementation specific cookie that is opaque to the IMS backend.
This can be a PASID, queue ID, pointer etc. During initialization
the IMS backend learns which PCI device to operate on (and thus which
interrupt domain to allocate from) and what the default cookie should
be for any new interrupt allocation.
IMS can associate a unique cookie with each vector (more support in
later patches) and to maintain this association the backend maintains
interrupt contexts for the virtual device's lifetime.

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
 drivers/vfio/pci/vfio_pci_intrs.c | 275 ++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h     |   6 +
 2 files changed, 281 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index d04a4477c201..7880fd4077a6 100644
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
 	struct eventfd_ctx	*trigger;
 	struct virqfd		*unmask;
@@ -29,6 +44,9 @@ struct vfio_pci_irq_ctx {
 	char			*name;
 	bool			masked;
 	struct irq_bypass_producer	producer;
+	int			ims_id;
+	int			virq;
+	union msi_instance_cookie	icookie;
 };
 
 static bool irq_is(struct vfio_pci_core_device *vdev, int type)
@@ -72,6 +90,12 @@ vfio_irq_ctx_alloc(struct vfio_pci_intr_ctx *intr_ctx, unsigned long index)
 	if (!ctx)
 		return NULL;
 
+	if (intr_ctx->ims_backed_irq)  {
+		struct vfio_pci_ims *ims = intr_ctx->priv;
+
+		ctx->icookie = ims->default_cookie;
+	}
+
 	ret = xa_insert(&intr_ctx->ctx, index, ctx, GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		kfree(ctx);
@@ -822,6 +846,7 @@ void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 	_vfio_pci_init_intr_ctx(intr_ctx);
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
+	intr_ctx->ims_backed_irq = false;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
 
@@ -831,6 +856,256 @@ void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_release_intr_ctx);
 
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
+static int vfio_pci_ims_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
+					  unsigned int vector, int fd)
+{
+	struct vfio_pci_ims *ims = intr_ctx->priv;
+	struct device *dev = &ims->vdev->device;
+	struct vfio_pci_irq_ctx *ctx;
+	struct eventfd_ctx *trigger;
+	int ret;
+
+	ctx = vfio_irq_ctx_get(intr_ctx, vector);
+
+	if (ctx && ctx->trigger) {
+		irq_bypass_unregister_producer(&ctx->producer);
+		free_irq(ctx->virq, ctx->trigger);
+		vfio_pci_ims_irq_free(intr_ctx, ctx);
+		kfree(ctx->name);
+		ctx->name = NULL;
+		eventfd_ctx_put(ctx->trigger);
+		ctx->trigger = NULL;
+	}
+
+	if (fd < 0)
+		return 0;
+
+	/* Interrupt contexts remain allocated until shutdown. */
+	if (!ctx) {
+		ctx = vfio_irq_ctx_alloc(intr_ctx, vector);
+		if (!ctx)
+			return -ENOMEM;
+	}
+
+	ctx->name = kasprintf(GFP_KERNEL, "vfio-ims[%d](%s)", vector,
+			      dev_name(dev));
+	if (!ctx->name)
+		return -ENOMEM;
+
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		ret = PTR_ERR(trigger);
+		goto out_free_name;
+	}
+
+	ctx->trigger = trigger;
+
+	ret = vfio_pci_ims_irq_alloc(intr_ctx, ctx);
+	if (ret < 0)
+		goto out_put_eventfd_ctx;
+
+	ret = request_irq(ctx->virq, vfio_msihandler, 0, ctx->name,
+			  ctx->trigger);
+	if (ret < 0)
+		goto out_free_irq;
+
+	ctx->producer.token = ctx->trigger;
+	ctx->producer.irq = ctx->virq;
+	ret = irq_bypass_register_producer(&ctx->producer);
+	if (unlikely(ret)) {
+		dev_info(&ims->vdev->device,
+			 "irq bypass producer (token %p) registration fails: %d\n",
+			 &ctx->producer.token, ret);
+		ctx->producer.token = NULL;
+	}
+
+	return 0;
+
+out_free_irq:
+	vfio_pci_ims_irq_free(intr_ctx, ctx);
+out_put_eventfd_ctx:
+	eventfd_ctx_put(ctx->trigger);
+	ctx->trigger = NULL;
+out_free_name:
+	kfree(ctx->name);
+	ctx->name = NULL;
+	return ret;
+}
+
+static int vfio_pci_ims_set_block(struct vfio_pci_intr_ctx *intr_ctx,
+				  unsigned int start, unsigned int count,
+				  int *fds)
+{
+	unsigned int i, j;
+	int ret = 0;
+
+	for (i = 0, j = start; i < count && !ret; i++, j++) {
+		int fd = fds ? fds[i] : -1;
+
+		ret = vfio_pci_ims_set_vector_signal(intr_ctx, j, fd);
+	}
+
+	if (ret) {
+		for (i = start; i < j; i++)
+			vfio_pci_ims_set_vector_signal(intr_ctx, i, -1);
+	}
+
+	return ret;
+}
+
+/*
+ * Manage Interrupt Message Store (IMS) or emulated interrupts on the
+ * host that are backing guest MSI-X vectors.
+ *
+ * @intr_ctx:	 Interrupt context
+ * @index:	 Type of guest vectors to set up.  Must be
+ *		 VFIO_PCI_MSIX_IRQ_INDEX.
+ * @start:	 First vector index.
+ * @count:	 Number of vectors.
+ * @flags:	 Type of data provided in @data.
+ * @data:	 Data as specified by @flags.
+ *
+ * Caller is required to validate provided range for @vdev.
+ *
+ * Context: Interrupt context must be initialized via
+ *	    vfio_pci_ims_init_intr_ctx()  before any interrupts can be allocated.
+ *
+ * Return: Error code on failure or 0 on success.
+ */
+static int vfio_pci_set_ims_trigger(struct vfio_pci_intr_ctx *intr_ctx,
+				    unsigned int index, unsigned int start,
+				    unsigned int count, u32 flags,
+				    void *data)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned long i;
+
+	if (index != VFIO_PCI_MSIX_IRQ_INDEX)
+		return -EINVAL;
+
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
+		xa_for_each(&intr_ctx->ctx, i, ctx)
+			vfio_pci_ims_set_vector_signal(intr_ctx, i, -1);
+		return 0;
+	}
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
+		return vfio_pci_ims_set_block(intr_ctx, start, count, (int *)data);
+
+	for (i = start; i < start + count; i++) {
+		ctx = vfio_irq_ctx_get(intr_ctx, i);
+		if (!ctx || !ctx->trigger)
+			continue;
+		if (flags & VFIO_IRQ_SET_DATA_NONE) {
+			eventfd_signal(ctx->trigger, 1);
+		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+			uint8_t *bools = data;
+
+			if (bools[i - start])
+				eventfd_signal(ctx->trigger, 1);
+		}
+	}
+
+	return 0;
+}
+
+struct vfio_pci_intr_ops vfio_pci_ims_intr_ops = {
+	.set_msix_trigger = vfio_pci_set_ims_trigger,
+	.set_req_trigger = vfio_pci_set_req_trigger,
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
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_init_intr_ctx);
+
+void vfio_pci_ims_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
+{
+	struct vfio_pci_ims *ims = intr_ctx->priv;
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned long i;
+
+	/*
+	 * IMS backed MSI-X keeps interrupt context allocated after
+	 * interrupt is freed. Interrupt contexts need to be freed
+	 * separately.
+	 */
+	mutex_lock(&intr_ctx->igate);
+	xa_for_each(&intr_ctx->ctx, i, ctx) {
+		WARN_ON_ONCE(ctx->trigger);
+		WARN_ON_ONCE(ctx->name);
+		xa_erase(&intr_ctx->ctx, i);
+		kfree(ctx);
+	}
+	mutex_unlock(&intr_ctx->igate);
+	kfree(ims);
+	_vfio_pci_release_intr_ctx(intr_ctx);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_release_intr_ctx);
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 1dd55d98dce9..13b807848286 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -67,6 +67,7 @@ struct vfio_pci_intr_ctx {
 	struct eventfd_ctx		*req_trigger;
 	struct xarray			ctx;
 	int				irq_type;
+	bool				ims_backed_irq:1;
 };
 
 struct vfio_pci_intr_ops {
@@ -161,6 +162,11 @@ void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx);
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data);
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

