Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933FF78750B
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 18:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242440AbjHXQRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 12:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242483AbjHXQQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 12:16:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE1619A8;
        Thu, 24 Aug 2023 09:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692893816; x=1724429816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fub4Cbvnc9WQB/QkNAsKgO5x3g0w5Bkg5YV6LQ0SQx8=;
  b=bQn0ZT7CAYH2UMHm3DtavGvM/FOg6OHkA8ftDvaKcwn64ljtXdMzoKxg
   YKJGZxL8rHbekbK8h/3RCffr3n2tcca93shsYyQUGOwP0ApsWj1Ywm18P
   CSj3vlMeCm8UVKHGxrt6kl0XBjT0hY5CtcZyyIanBRfBAR67+adSn1iJq
   Hrz9qXASDKoo4raNPYJladBpt8+BaKfazfer0LquXKlKkQCHWIKRIDvbQ
   3vZtf0cIDnFvUaKahLPLMugBU4UISAt5DqWUqMZP3Fz4w6tXj0QWbP/7f
   hTADsbBKKyo4av6TtVPkWNeIIJZG8SM1QvD2pDRC3ql4OtHamTqUWJP+s
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="364679242"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="364679242"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 09:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="686970906"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="686970906"
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
Subject: [RFC PATCH 1/3] vfio/pci: Introduce library allocating from Interrupt Message Store (IMS)
Date:   Thu, 24 Aug 2023 09:15:20 -0700
Message-Id: <cc9967616ad6b5d014ccf150c9984339c5eb2543.1692892275.git.reinette.chatre@intel.com>
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

With Interrupt Message Store (IMS) support introduced in
commit 0194425af0c8 ("PCI/MSI: Provide IMS (Interrupt Message Store)
support") a device can create a secondary interrupt domain that works
side by side with MSI-X on the same device. IMS allows for
implementation-specific interrupt storage that is managed by the
implementation specific interrupt chip associated with the IMS domain
at the time it (the IMS domain) is created for the device via
pci_create_ims_domain().

An example usage of IMS is for devices that can have their resources
assigned to guests with varying granularity. For example, an
accelerator device may support many workqueues and a single workqueue
can be composed into a virtual device for use by a guest. Using
IMS interrupts for the guest preserves MSI-X for host usage while
allowing a significantly larger number of interrupt vectors than
allowed by MSI-X. All while enabling usage of the same device driver
in the host and guest.

VFIO PCI IMS is a library that supports virtual devices with
MSI-X interrupts that are backed by IMS interrupts on the host.

Introduce core functionality of VFIO PCI IMS consisting of IMS interrupt
allocation and free, and ability to associate domain specific
information with each interrupt. With the generic term of "cookie"
(the same name used in the IMS core) this value is opaque to VFIO
PCI IMS but important to the virtual device, for example a PASID.

The core VFIO PCI IMS API is:

vfio_pci_ims_init(): Initialize the IMS interrupt context. VFIO PCI
    IMS needs to allocate from a device specific IMS domain. The
    PCI device owning the IMS domain as well as the default cookie are
    provided using vfio_pci_ims_init(). vfio_pci_ims_init() is intended
    to be called from the virtual device's vfio_device_ops->open_device().

vfio_pci_ims_free(): Free the IMS interrupt context. vfio_pci_ims_free()
    is intended to be called from the virtual device's
    vfio_device_ops->close_device() after the index as a whole has been
    disabled via vfio_pci_set_ims_trigger().

vfio_pci_ims_set_cookie(): Set a unique cookie for a particular vector.
    Must be called after vfio_pci_ims_init(). For example, the virtual
    device driver may intercept the guest's MMIO write that configures
    a new PASID. Calling vfio_pci_ims_set_cookie() with the new PASID
    value enables subsequent interrupts to be allocated with accurate
    data.

vfio_pci_set_ims_trigger(): Runtime helper intended to be called
    via the VFIO_DEVICE_SET_IRQS ioctl() and more directly on device
    close to disable the index as whole. vfio_pci_set_ims_trigger()
    allocates and frees IMS interrupts on the host as MSI-X interrupts
    in the guest change state. Interrupts are always dynamically
    allocated, enabling a user of this helper to clear the
    VFIO_IRQ_INFO_NORESIZE flag in response to user space's request
    for interrupt information.

While interrupts are dynamically allocated and freed the interrupt
contexts are maintained from initial allocation to virtual device
shutdown. This is done to maintain the vector specific cookies.

The interrupt context can be modified via separate flows. For example,
vfio_pci_set_ims_trigger() can modify the context while handling an
ioctl(), while vfio_pci_ims_set_cookie() can modify the interrupt
context as part of handling an intercepted MMIO write. Concurrent
changes to the interrupt context are protected by a mutex (ctx_mutex).

VFIO PCI IMS manages IMS interrupts of a PCI device. This prompts
it to be located in drivers/vfio/pci, enabled with a new config option
CONFIG_VFIO_PCI_IMS. The library does not depend on the PCI
VFIO bus driver so there is not a dependency on CONFIG_VFIO_PCI.

Originally-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/Kconfig        |  12 +
 drivers/vfio/pci/Makefile       |   2 +
 drivers/vfio/pci/vfio_pci_ims.c | 389 ++++++++++++++++++++++++++++++++
 include/linux/vfio.h            |  60 +++++
 4 files changed, 463 insertions(+)
 create mode 100644 drivers/vfio/pci/vfio_pci_ims.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 86bb7835cf3c..cf9e4ee14574 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -24,6 +24,18 @@ config VFIO_PCI
 
 	  If you don't know what to do here, say N.
 
+config VFIO_PCI_IMS
+	tristate "VFIO library supporting Interrupt Message Store (IMS)"
+	depends on PCI_MSI
+	select EVENTFD
+	select IRQ_BYPASS_MANAGER
+	default n
+	help
+	  VFIO library used by virtual devices with MSI-X interrupts
+	  that are backed by IMS interrupts on the host.
+
+	  If you don't know what to do here, say N.
+
 if VFIO_PCI
 config VFIO_PCI_VGA
 	bool "Generic VFIO PCI support for VGA devices"
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 24c524224da5..860e1ff5ef60 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -8,6 +8,8 @@ vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
+obj-$(CONFIG_VFIO_PCI_IMS) += vfio_pci_ims.o
+
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
diff --git a/drivers/vfio/pci/vfio_pci_ims.c b/drivers/vfio/pci/vfio_pci_ims.c
new file mode 100644
index 000000000000..0926eb921351
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_ims.c
@@ -0,0 +1,389 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Interrupt Message Store (IMS) library
+ *
+ * Copyright (C) 2023 Intel Corporation
+ */
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/interrupt.h>
+#include <linux/irqbypass.h>
+#include <linux/irqreturn.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include <linux/xarray.h>
+
+/*
+ * IMS interrupt context.
+ * @name:	Name of device associated with interrupt.
+ *		Provided to request_irq().
+ * @trigger:	eventfd associated with interrupt.
+ * @producer:	Interrupt's registered IRQ bypass producer.
+ * @ims_id:	Interrupt index associated with IMS interrupt.
+ * @virq:	Linux IRQ number associated with IMS interrupt.
+ * @icookie:	Cookie used by irqchip driver.
+ */
+struct vfio_pci_ims_ctx {
+	char				*name;
+	struct eventfd_ctx		*trigger;
+	struct irq_bypass_producer	producer;
+	int				ims_id;
+	int				virq;
+	union msi_instance_cookie	icookie;
+};
+
+static irqreturn_t vfio_pci_ims_irq_handler(int irq, void *arg)
+{
+	struct eventfd_ctx *trigger = arg;
+
+	eventfd_signal(trigger, 1);
+	return IRQ_HANDLED;
+}
+
+/*
+ * Free the interrupt associated with @ctx.
+ *
+ * Free interrupt from the underlying PCI device's IMS domain.
+ */
+static void vfio_pci_ims_irq_free(struct vfio_pci_ims *ims,
+				  struct vfio_pci_ims_ctx *ctx)
+{
+	struct msi_map irq_map = {};
+
+	lockdep_assert_held(&ims->ctx_mutex);
+
+	irq_map.index = ctx->ims_id;
+	irq_map.virq = ctx->virq;
+	pci_ims_free_irq(ims->pdev, irq_map);
+	ctx->ims_id = -EINVAL;
+	ctx->virq = 0;
+}
+
+/*
+ * Allocate an interrupt for @ctx.
+ *
+ * Allocate interrupt from the underlying PCI device's IMS domain.
+ */
+static int vfio_pci_ims_irq_alloc(struct vfio_pci_ims *ims,
+				  struct vfio_pci_ims_ctx *ctx)
+{
+	struct msi_map irq_map = {};
+
+	lockdep_assert_held(&ims->ctx_mutex);
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
+/*
+ * Return interrupt context for @vector.
+ *
+ * Interrupt contexts are not freed until shutdown so first
+ * check if there is a context associated with @vector that
+ * should be returned before allocating new context.
+ *
+ * Return: pointer to interrupt context, NULL on failure.
+ */
+static struct vfio_pci_ims_ctx *
+vfio_pci_ims_ctx_get(struct vfio_pci_ims *ims, unsigned int vector)
+{
+	struct vfio_pci_ims_ctx *ctx;
+	int ret;
+
+	lockdep_assert_held(&ims->ctx_mutex);
+
+	ctx = xa_load(&ims->ctx, vector);
+	if (ctx)
+		return ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx)
+		return NULL;
+
+	ctx->icookie = ims->default_cookie;
+	ret = xa_insert(&ims->ctx, vector, ctx, GFP_KERNEL_ACCOUNT);
+	if (ret) {
+		kfree(ctx);
+		return NULL;
+	}
+
+	return ctx;
+}
+
+static int vfio_pci_ims_set_vector_signal(struct vfio_device *vdev,
+					  unsigned int vector, int fd)
+{
+	struct vfio_pci_ims *ims = &vdev->ims;
+	struct device *dev = &vdev->device;
+	struct vfio_pci_ims_ctx *ctx;
+	struct eventfd_ctx *trigger;
+	int ret;
+
+	lockdep_assert_held(&ims->ctx_mutex);
+
+	ctx = xa_load(&ims->ctx, vector);
+
+	if (ctx && ctx->trigger) {
+		irq_bypass_unregister_producer(&ctx->producer);
+		free_irq(ctx->virq, ctx->trigger);
+		vfio_pci_ims_irq_free(ims, ctx);
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
+	ctx = vfio_pci_ims_ctx_get(ims, vector);
+	if (!ctx)
+		return -EINVAL;
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
+	ret = vfio_pci_ims_irq_alloc(ims, ctx);
+	if (ret < 0)
+		goto out_put_eventfd_ctx;
+
+	ret = request_irq(ctx->virq, vfio_pci_ims_irq_handler, 0, ctx->name,
+			  ctx->trigger);
+	if (ret < 0)
+		goto out_free_irq;
+
+	ctx->producer.token = ctx->trigger;
+	ctx->producer.irq = ctx->virq;
+	ret = irq_bypass_register_producer(&ctx->producer);
+	if (unlikely(ret)) {
+		dev_info(&vdev->device,
+			 "irq bypass producer (token %p) registration fails: %d\n",
+			 &ctx->producer.token, ret);
+		ctx->producer.token = NULL;
+	}
+
+	return 0;
+
+out_free_irq:
+	vfio_pci_ims_irq_free(ims, ctx);
+out_put_eventfd_ctx:
+	eventfd_ctx_put(ctx->trigger);
+	ctx->trigger = NULL;
+out_free_name:
+	kfree(ctx->name);
+	ctx->name = NULL;
+	return ret;
+}
+
+static int vfio_pci_ims_set_block(struct vfio_device *vdev, unsigned int start,
+				  unsigned int count, int *fds)
+{
+	struct vfio_pci_ims *ims = &vdev->ims;
+	unsigned int i, j;
+	int ret = 0;
+
+	lockdep_assert_held(&ims->ctx_mutex);
+
+	for (i = 0, j = start; i < count && !ret; i++, j++) {
+		int fd = fds ? fds[i] : -1;
+
+		ret = vfio_pci_ims_set_vector_signal(vdev, j, fd);
+	}
+
+	if (ret) {
+		for (i = start; i < j; i++)
+			vfio_pci_ims_set_vector_signal(vdev, i, -1);
+	}
+
+	return ret;
+}
+
+/*
+ * Manage Interrupt Message Store (IMS) interrupts on the host that are
+ * backing guest MSI-X vectors.
+ *
+ * @vdev:	 VFIO device
+ * @index:	 Type of guest vectors to set up.  Must be
+ *		 VFIO_PCI_MSIX_IRQ_INDEX.
+ * @start:	 First vector index.
+ * @count:	 Number of vectors.
+ * @flags:	 Type of data provided in @data.
+ * @data:	 Data as specified by @flags.
+ *
+ * Caller is required to validate provided range for @vdev.
+ *
+ * Context: Interrupt context must be initialized via vfio_pci_ims_init()
+ *	    before any interrupts can be allocated.
+ *	    Can be called from vfio_device_ops->ioctl() or during shutdown via
+ *	    vfio_device_ops->close_device().
+ *
+ * Return: Error code on failure or 0 on success.
+ */
+int vfio_pci_set_ims_trigger(struct vfio_device *vdev, unsigned int index,
+			     unsigned int start, unsigned int count, u32 flags,
+			     void *data)
+{
+	struct vfio_pci_ims *ims = &vdev->ims;
+	struct vfio_pci_ims_ctx *ctx;
+	unsigned long i;
+	int ret;
+
+	if (index != VFIO_PCI_MSIX_IRQ_INDEX)
+		return -EINVAL;
+
+	mutex_lock(&ims->ctx_mutex);
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
+		xa_for_each(&ims->ctx, i, ctx)
+			vfio_pci_ims_set_vector_signal(vdev, i, -1);
+		ret = 0;
+		goto out_unlock;
+	}
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		ret = vfio_pci_ims_set_block(vdev, start, count, (int *)data);
+		goto out_unlock;
+	}
+
+	for (i = start; i < start + count; i++) {
+		ctx = xa_load(&ims->ctx, i);
+		if (!ctx || !ctx->trigger)
+			continue;
+		if (flags & VFIO_IRQ_SET_DATA_NONE) {
+			eventfd_signal(ctx->trigger, 1);
+		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+			u8 *bools = data;
+
+			if (bools[i - start])
+				eventfd_signal(ctx->trigger, 1);
+		}
+	}
+
+	ret = 0;
+
+out_unlock:
+	mutex_unlock(&ims->ctx_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_set_ims_trigger);
+
+/*
+ * Initialize the IMS context associated with virtual device.
+ *
+ * @vdev: VFIO device
+ * @pdev: PCI device that owns the IMS domain from where IMS
+ *	  interrupts will be allocated.
+ * @default_cookie: The default cookie for new IMS instances that do
+ *		    not have an instance-specific cookie.
+ *
+ * Context: Must be called during vfio_device_ops->open_device().
+ */
+void vfio_pci_ims_init(struct vfio_device *vdev, struct pci_dev *pdev,
+		       union msi_instance_cookie *default_cookie)
+{
+	struct vfio_pci_ims *ims = &vdev->ims;
+
+	xa_init(&ims->ctx);
+	mutex_init(&ims->ctx_mutex);
+	ims->pdev = pdev;
+	ims->default_cookie = *default_cookie;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_init);
+
+/*
+ * Free the IMS context associated with virtual device.
+ *
+ * @vdev: VFIO device
+ *
+ * Virtual device has to free all allocated interrupts before freeing the
+ * IMS context. This is done by triggering a call to disable the index as
+ * a whole by triggering vfio_pci_set_ims_trigger() with
+ * flags = (DATA_NONE|ACTION_TRIGGER), count = 0.
+ *
+ * Context: Must be called during vfio_device_ops->close_device() after
+ *	    index as a whole has been disabled.
+ */
+void vfio_pci_ims_free(struct vfio_device *vdev)
+{
+	struct vfio_pci_ims *ims = &vdev->ims;
+	struct vfio_pci_ims_ctx *ctx;
+	unsigned long i;
+
+	/*
+	 * All interrupts should be freed (including free of name and
+	 * trigger) before context cleanup.
+	 */
+	mutex_lock(&ims->ctx_mutex);
+	xa_for_each(&ims->ctx, i, ctx) {
+		WARN_ON_ONCE(ctx->trigger);
+		WARN_ON_ONCE(ctx->name);
+		xa_erase(&ims->ctx, i);
+		kfree(ctx);
+	}
+	mutex_unlock(&ims->ctx_mutex);
+	ims->pdev = NULL;
+	ims->default_cookie = (union msi_instance_cookie) { .value = 0 };
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_free);
+
+/*
+ * Set unique cookie for vector.
+ *
+ * Context: Must be called after vfio_pci_ims_init()
+ */
+int vfio_pci_ims_set_cookie(struct vfio_device *vdev, unsigned int vector,
+			    union msi_instance_cookie *icookie)
+{
+	struct vfio_pci_ims *ims = &vdev->ims;
+	struct vfio_pci_ims_ctx *ctx;
+	int ret = 0;
+
+	mutex_lock(&ims->ctx_mutex);
+	ctx = xa_load(&ims->ctx, vector);
+	if (ctx) {
+		ctx->icookie = *icookie;
+		goto out_unlock;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	ctx->icookie = *icookie;
+	ret = xa_insert(&ims->ctx, vector, ctx, GFP_KERNEL_ACCOUNT);
+	if (ret) {
+		kfree(ctx);
+		goto out_unlock;
+	}
+
+	ret = 0;
+
+out_unlock:
+	mutex_unlock(&ims->ctx_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_set_cookie);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Intel Corporation");
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 2c137ea94a3e..aa54239bff4d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -12,6 +12,7 @@
 #include <linux/iommu.h>
 #include <linux/mm.h>
 #include <linux/workqueue.h>
+#include <linux/pci.h>
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 #include <linux/iova_bitmap.h>
@@ -33,6 +34,24 @@ struct vfio_device_set {
 	unsigned int device_count;
 };
 
+#if IS_ENABLED(CONFIG_VFIO_PCI_IMS)
+/*
+ * Interrupt Message Store (IMS) data
+ * @ctx:		IMS interrupt context storage.
+ * @ctx_mutex:		Protects the interrupt context storage.
+ * @pdev:		PCI device owning the IMS domain from where
+ *			interrupts are allocated.
+ * @default_cookie:	Default cookie used for IMS interrupts without unique
+ *			cookie.
+ */
+struct vfio_pci_ims {
+	struct xarray			ctx;
+	struct mutex			ctx_mutex;
+	struct pci_dev			*pdev;
+	union msi_instance_cookie	default_cookie;
+};
+#endif
+
 struct vfio_device {
 	struct device *dev;
 	const struct vfio_device_ops *ops;
@@ -62,6 +81,9 @@ struct vfio_device {
 	struct iommufd_device *iommufd_device;
 	bool iommufd_attached;
 #endif
+#if IS_ENABLED(CONFIG_VFIO_PCI_IMS)
+	struct vfio_pci_ims ims;
+#endif
 };
 
 /**
@@ -302,4 +324,42 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 		       struct virqfd **pvirqfd, int fd);
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+/*
+ * Interrupt Message Store (IMS)
+ */
+#if IS_ENABLED(CONFIG_VFIO_PCI_IMS)
+int vfio_pci_set_ims_trigger(struct vfio_device *vdev, unsigned int index,
+			     unsigned int start, unsigned int count, u32 flags,
+			     void *data);
+void vfio_pci_ims_init(struct vfio_device *vdev, struct pci_dev *pdev,
+		       union msi_instance_cookie *default_cookie);
+void vfio_pci_ims_free(struct vfio_device *vdev);
+int vfio_pci_ims_set_cookie(struct vfio_device *vdev, unsigned int vector,
+			    union msi_instance_cookie *icookie);
+#else
+static inline int vfio_pci_set_ims_trigger(struct vfio_device *vdev,
+					   unsigned int index,
+					   unsigned int start,
+					   unsigned int count, u32 flags,
+					   void *data)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_pci_ims_init(struct vfio_device *vdev,
+				     struct pci_dev *pdev,
+				     union msi_instance_cookie *default_cookie)
+{}
+
+static inline void vfio_pci_ims_free(struct vfio_device *vdev) {}
+
+static inline int vfio_pci_ims_set_cookie(struct vfio_device *vdev,
+					  unsigned int vector,
+					  union msi_instance_cookie *icookie)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* CONFIG_VFIO_PCI_IMS */
+
 #endif /* VFIO_H */
-- 
2.34.1

