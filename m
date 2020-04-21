Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEFD1B3340
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgDUXeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:34:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:35979 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgDUXeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:34:13 -0400
IronPort-SDR: q2b4Th76ee9wY0QAa3NwC4KU9b4PA+vGVwqMqBJ2ZZUlPKgO/ZC/3fShqYN/6qCPRXyzpyIIew
 qPgtB2ZA5tPw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:34:13 -0700
IronPort-SDR: PQBV/gzbJQ/w8O+RLeKfbPQdNhHVGd1il12nwqmpVqW+q2dT7TaiYAYDJhaZEv5sGpig9gT3Xb
 mQh/QnTXQjsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="245816413"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga007.fm.intel.com with ESMTP; 21 Apr 2020 16:34:11 -0700
Subject: [PATCH RFC 04/15] drivers/base: Add support for a new IMS irq domain
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Apr 2020 16:34:11 -0700
Message-ID: <158751205175.36773.1874642824360728883.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

Add support for the creation of a new IMS irq domain. It creates a new
irq chip associated with the IMS domain and adds the necessary domain
operations to it.

Also, add a new config option MSI_IMS which must be enabled by any driver
who would want to use the IMS infrastructure.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h    |    7 +++
 drivers/base/Kconfig             |    9 +++
 drivers/base/Makefile            |    1 
 drivers/base/ims-msi.c           |  100 ++++++++++++++++++++++++++++++++++++++
 drivers/base/platform-msi.c      |    6 +-
 drivers/vfio/mdev/mdev_core.c    |    6 ++
 drivers/vfio/mdev/mdev_private.h |    1 
 include/linux/mdev.h             |    3 +
 include/linux/msi.h              |    2 +
 9 files changed, 131 insertions(+), 4 deletions(-)
 create mode 100644 drivers/base/ims-msi.c

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 4154bc5f6a4e..2e355aa6ba50 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -62,6 +62,7 @@ enum irq_alloc_type {
 	X86_IRQ_ALLOC_TYPE_MSIX,
 	X86_IRQ_ALLOC_TYPE_DMAR,
 	X86_IRQ_ALLOC_TYPE_UV,
+	X86_IRQ_ALLOC_TYPE_IMS,
 };
 
 struct irq_alloc_info {
@@ -83,6 +84,12 @@ struct irq_alloc_info {
 			irq_hw_number_t	msi_hwirq;
 		};
 #endif
+#ifdef	CONFIG_MSI_IMS
+		struct {
+			struct device	*dev;
+			irq_hw_number_t	ims_hwirq;
+		};
+#endif
 #ifdef	CONFIG_X86_IO_APIC
 		struct {
 			int		ioapic_id;
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 5f0bc74d2409..877e0fdee013 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -209,4 +209,13 @@ config GENERIC_ARCH_TOPOLOGY
 	  appropriate scaling, sysfs interface for reading capacity values at
 	  runtime.
 
+config MSI_IMS
+	bool "Device Specific Interrupt Message Storage (IMS)"
+	depends on X86
+	select GENERIC_MSI_IRQ_DOMAIN
+	select IRQ_REMAP
+	help
+	  This allows device drivers to enable device specific
+	  interrupt message storage (IMS) besides standard MSI-X interrupts.
+
 endmenu
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 157452080f3d..659b9b0c0b8a 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_SOC_BUS) += soc.o
 obj-$(CONFIG_PINCTRL) += pinctrl.o
 obj-$(CONFIG_DEV_COREDUMP) += devcoredump.o
 obj-$(CONFIG_GENERIC_MSI_IRQ_DOMAIN) += platform-msi.o
+obj-$(CONFIG_MSI_IMS) += ims-msi.o
 obj-$(CONFIG_GENERIC_ARCH_TOPOLOGY) += arch_topology.o
 
 obj-y			+= test/
diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
new file mode 100644
index 000000000000..738f6d153155
--- /dev/null
+++ b/drivers/base/ims-msi.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Support for Device Specific IMS interrupts.
+ *
+ * Copyright © 2019 Intel Corporation.
+ *
+ * Author: Megha Dey <megha.dey@intel.com>
+ */
+
+#include <linux/dmar.h>
+#include <linux/irq.h>
+#include <linux/mdev.h>
+#include <linux/pci.h>
+
+/*
+ * Determine if a dev is mdev or not. Return NULL if not mdev device.
+ * Return mdev's parent dev if success.
+ */
+static inline struct device *mdev_to_parent(struct device *dev)
+{
+	struct device *ret = NULL;
+	struct device *(*fn)(struct device *dev);
+	struct bus_type *bus = symbol_get(mdev_bus_type);
+
+	if (bus && dev->bus == bus) {
+		fn = symbol_get(mdev_dev_to_parent_dev);
+		ret = fn(dev);
+		symbol_put(mdev_dev_to_parent_dev);
+		symbol_put(mdev_bus_type);
+	}
+
+	return ret;
+}
+
+static irq_hw_number_t dev_ims_get_hwirq(struct msi_domain_info *info,
+					 msi_alloc_info_t *arg)
+{
+	return arg->ims_hwirq;
+}
+
+static int dev_ims_prepare(struct irq_domain *domain, struct device *dev,
+			   int nvec, msi_alloc_info_t *arg)
+{
+	if (dev_is_mdev(dev))
+		dev = mdev_to_parent(dev);
+
+	init_irq_alloc_info(arg, NULL);
+	arg->dev = dev;
+	arg->type = X86_IRQ_ALLOC_TYPE_IMS;
+
+	return 0;
+}
+
+static void dev_ims_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
+{
+	arg->ims_hwirq = platform_msi_calc_hwirq(desc);
+}
+
+static struct msi_domain_ops dev_ims_domain_ops = {
+	.get_hwirq	= dev_ims_get_hwirq,
+	.msi_prepare	= dev_ims_prepare,
+	.set_desc	= dev_ims_set_desc,
+};
+
+static struct irq_chip dev_ims_ir_controller = {
+	.name			= "IR-DEV-IMS",
+	.irq_ack		= irq_chip_ack_parent,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_set_vcpu_affinity	= irq_chip_set_vcpu_affinity_parent,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.irq_write_msi_msg	= platform_msi_write_msg,
+};
+
+static struct msi_domain_info ims_ir_domain_info = {
+	.flags		= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS,
+	.ops		= &dev_ims_domain_ops,
+	.chip		= &dev_ims_ir_controller,
+	.handler	= handle_edge_irq,
+	.handler_name	= "edge",
+};
+
+struct irq_domain *arch_create_ims_irq_domain(struct irq_domain *parent,
+					      const char *name)
+{
+	struct fwnode_handle *fn;
+	struct irq_domain *domain;
+
+	fn = irq_domain_alloc_named_fwnode(name);
+	if (!fn)
+		return NULL;
+
+	domain = msi_create_irq_domain(fn, &ims_ir_domain_info, parent);
+	if (!domain)
+		return NULL;
+
+	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
+	irq_domain_free_fwnode(fn);
+
+	return domain;
+}
diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 2696aa75983b..59160e8cbfb1 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -31,12 +31,11 @@ struct platform_msi_priv_data {
 /* The devid allocator */
 static DEFINE_IDA(platform_msi_devid_ida);
 
-#ifdef GENERIC_MSI_DOMAIN_OPS
 /*
  * Convert an msi_desc to a globaly unique identifier (per-device
  * devid + msi_desc position in the msi_list).
  */
-static irq_hw_number_t platform_msi_calc_hwirq(struct msi_desc *desc)
+irq_hw_number_t platform_msi_calc_hwirq(struct msi_desc *desc)
 {
 	u32 devid;
 
@@ -45,6 +44,7 @@ static irq_hw_number_t platform_msi_calc_hwirq(struct msi_desc *desc)
 	return (devid << (32 - DEV_ID_SHIFT)) | desc->platform.msi_index;
 }
 
+#ifdef GENERIC_MSI_DOMAIN_OPS
 static void platform_msi_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
 {
 	arg->desc = desc;
@@ -76,7 +76,7 @@ static void platform_msi_update_dom_ops(struct msi_domain_info *info)
 		ops->set_desc = platform_msi_set_desc;
 }
 
-static void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
+void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	struct msi_desc *desc = irq_data_get_msi_desc(data);
 	struct platform_msi_priv_data *priv_data;
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b558d4cfd082..cecc6a6bdbef 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -33,6 +33,12 @@ struct device *mdev_parent_dev(struct mdev_device *mdev)
 }
 EXPORT_SYMBOL(mdev_parent_dev);
 
+struct device *mdev_dev_to_parent_dev(struct device *dev)
+{
+	return to_mdev_device(dev)->parent->dev;
+}
+EXPORT_SYMBOL(mdev_dev_to_parent_dev);
+
 void *mdev_get_drvdata(struct mdev_device *mdev)
 {
 	return mdev->driver_data;
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 7d922950caaf..c21f1305a76b 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -36,7 +36,6 @@ struct mdev_device {
 };
 
 #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
-#define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
 
 struct mdev_type {
 	struct kobject kobj;
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0ce30ca78db0..fa2344e239ef 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -144,5 +144,8 @@ void mdev_unregister_driver(struct mdev_driver *drv);
 struct device *mdev_parent_dev(struct mdev_device *mdev);
 struct device *mdev_dev(struct mdev_device *mdev);
 struct mdev_device *mdev_from_dev(struct device *dev);
+struct device *mdev_dev_to_parent_dev(struct device *dev);
+
+#define dev_is_mdev(dev) ((dev)->bus == symbol_get(mdev_bus_type))
 
 #endif /* MDEV_H */
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 3890b143b04d..80386468a7bc 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -418,6 +418,8 @@ int platform_msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
 void platform_msi_domain_free(struct irq_domain *domain, unsigned int virq,
 			      unsigned int nvec);
 void *platform_msi_get_host_data(struct irq_domain *domain);
+irq_hw_number_t platform_msi_calc_hwirq(struct msi_desc *desc);
+void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg);
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN

