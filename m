Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D8922847F
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgGUQCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:02:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:17457 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbgGUQCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:02:36 -0400
IronPort-SDR: V6IFSudYNmCLSXEcZ/jYk7RzdhsJYEJLenDRqrBO+J8Sbv/WYUzzNuATja3h10Rp1BrrOTksvz
 LBqNlx9jnrQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="151498642"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="151498642"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:02:30 -0700
IronPort-SDR: 4k8m5pBgp08yDsi4xMHaA6oG98O0aTlsV3haxLcdE7QZf9FErdMZXolXxI+MPte1CBcmU5Jo8P
 /Shn8Fgt7K5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="287967356"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006.jf.intel.com with ESMTP; 21 Jul 2020 09:02:28 -0700
Subject: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq
 domain
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, jgg@mellanox.com,
        rafael@kernel.org, dave.hansen@intel.com, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Jul 2020 09:02:28 -0700
Message-ID: <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Megha Dey <megha.dey@intel.com>

Add support for the creation of a new DEV_MSI irq domain. It creates a
new irq chip associated with the DEV_MSI domain and adds the necessary
domain operations to it.

Add a new config option DEV_MSI which must be enabled by any
driver that wants to support device-specific message-signaled-interrupts
outside of PCI-MSI(-X).

Lastly, add device specific mask/unmask callbacks in addition to a write
function to the platform_msi_ops.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/include/asm/hw_irq.h |    5 ++
 drivers/base/Kconfig          |    7 +++
 drivers/base/Makefile         |    1 
 drivers/base/dev-msi.c        |   95 +++++++++++++++++++++++++++++++++++++++++
 drivers/base/platform-msi.c   |   45 +++++++++++++------
 drivers/base/platform-msi.h   |   23 ++++++++++
 include/linux/msi.h           |    8 +++
 7 files changed, 168 insertions(+), 16 deletions(-)
 create mode 100644 drivers/base/dev-msi.c
 create mode 100644 drivers/base/platform-msi.h

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 74c12437401e..8ecd7570589d 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -61,6 +61,11 @@ struct irq_alloc_info {
 			irq_hw_number_t	msi_hwirq;
 		};
 #endif
+#ifdef CONFIG_DEV_MSI
+		struct {
+			irq_hw_number_t hwirq;
+		};
+#endif
 #ifdef	CONFIG_X86_IO_APIC
 		struct {
 			int		ioapic_id;
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 8d7001712062..f00901bac056 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -210,4 +210,11 @@ config GENERIC_ARCH_TOPOLOGY
 	  appropriate scaling, sysfs interface for reading capacity values at
 	  runtime.
 
+config DEV_MSI
+	bool "Device Specific Interrupt Messages"
+	select IRQ_DOMAIN_HIERARCHY
+	select GENERIC_MSI_IRQ_DOMAIN
+	help
+	  Allow device drivers to generate device-specific interrupt messages
+	  for devices independent of PCI MSI/-X.
 endmenu
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 157452080f3d..ca1e4d39164e 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_REGMAP)	+= regmap/
 obj-$(CONFIG_SOC_BUS) += soc.o
 obj-$(CONFIG_PINCTRL) += pinctrl.o
 obj-$(CONFIG_DEV_COREDUMP) += devcoredump.o
+obj-$(CONFIG_DEV_MSI) += dev-msi.o
 obj-$(CONFIG_GENERIC_MSI_IRQ_DOMAIN) += platform-msi.o
 obj-$(CONFIG_GENERIC_ARCH_TOPOLOGY) += arch_topology.o
 
diff --git a/drivers/base/dev-msi.c b/drivers/base/dev-msi.c
new file mode 100644
index 000000000000..240ccc353933
--- /dev/null
+++ b/drivers/base/dev-msi.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2020 Intel Corporation.
+ *
+ * Author: Megha Dey <megha.dey@intel.com>
+ */
+
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
+#include "platform-msi.h"
+
+struct irq_domain *dev_msi_default_domain;
+
+static irq_hw_number_t dev_msi_get_hwirq(struct msi_domain_info *info,
+					 msi_alloc_info_t *arg)
+{
+	return arg->hwirq;
+}
+
+static irq_hw_number_t dev_msi_calc_hwirq(struct msi_desc *desc)
+{
+	u32 devid;
+
+	devid = desc->platform.msi_priv_data->devid;
+
+	return (devid << (32 - DEV_ID_SHIFT)) | desc->platform.msi_index;
+}
+
+static void dev_msi_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
+{
+	arg->hwirq = dev_msi_calc_hwirq(desc);
+}
+
+static int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
+			   int nvec, msi_alloc_info_t *arg)
+{
+	memset(arg, 0, sizeof(*arg));
+
+	return 0;
+}
+
+static struct msi_domain_ops dev_msi_domain_ops = {
+	.get_hwirq      = dev_msi_get_hwirq,
+	.set_desc       = dev_msi_set_desc,
+	.msi_prepare	= dev_msi_prepare,
+};
+
+static struct irq_chip dev_msi_controller = {
+	.name                   = "DEV-MSI",
+	.irq_unmask             = platform_msi_unmask_irq,
+	.irq_mask               = platform_msi_mask_irq,
+	.irq_write_msi_msg      = platform_msi_write_msg,
+	.irq_ack                = irq_chip_ack_parent,
+	.irq_retrigger          = irq_chip_retrigger_hierarchy,
+	.flags                  = IRQCHIP_SKIP_SET_WAKE,
+};
+
+static struct msi_domain_info dev_msi_domain_info = {
+	.flags          = MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS,
+	.ops            = &dev_msi_domain_ops,
+	.chip           = &dev_msi_controller,
+	.handler        = handle_edge_irq,
+	.handler_name   = "edge",
+};
+
+static int __init create_dev_msi_domain(void)
+{
+	struct irq_domain *parent = NULL;
+	struct fwnode_handle *fn;
+
+	/*
+	 * Modern code should never have to use irq_get_default_host. But since
+	 * dev-msi is invisible to DT/ACPI, this is an exception case.
+	 */
+	parent = irq_get_default_host();
+	if (!parent)
+		return -ENXIO;
+
+	fn = irq_domain_alloc_named_fwnode("DEV_MSI");
+	if (!fn)
+		return -ENXIO;
+
+	dev_msi_default_domain = msi_create_irq_domain(fn, &dev_msi_domain_info, parent);
+	if (!dev_msi_default_domain) {
+		pr_warn("failed to initialize irqdomain for DEV-MSI.\n");
+		return -ENXIO;
+	}
+
+	irq_domain_update_bus_token(dev_msi_default_domain, DOMAIN_BUS_PLATFORM_MSI);
+	irq_domain_free_fwnode(fn);
+
+	return 0;
+}
+device_initcall(create_dev_msi_domain);
diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 9d94cd699468..5e1f210d65ee 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -12,21 +12,7 @@
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
 #include <linux/slab.h>
-
-#define DEV_ID_SHIFT	21
-#define MAX_DEV_MSIS	(1 << (32 - DEV_ID_SHIFT))
-
-/*
- * Internal data structure containing a (made up, but unique) devid
- * and the platform-msi ops
- */
-struct platform_msi_priv_data {
-	struct device			*dev;
-	void				*host_data;
-	msi_alloc_info_t		arg;
-	const struct platform_msi_ops	*ops;
-	int				devid;
-};
+#include "platform-msi.h"
 
 /* The devid allocator */
 static DEFINE_IDA(platform_msi_devid_ida);
@@ -76,7 +62,7 @@ static void platform_msi_update_dom_ops(struct msi_domain_info *info)
 		ops->set_desc = platform_msi_set_desc;
 }
 
-static void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
+void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	struct msi_desc *desc = irq_data_get_msi_desc(data);
 	struct platform_msi_priv_data *priv_data;
@@ -86,6 +72,33 @@ static void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 	priv_data->ops->write_msg(desc, msg);
 }
 
+static void __platform_msi_desc_mask_unmask_irq(struct msi_desc *desc, u32 mask)
+{
+	const struct platform_msi_ops *ops;
+
+	ops = desc->platform.msi_priv_data->ops;
+	if (!ops)
+		return;
+
+	if (mask) {
+		if (ops->irq_mask)
+			ops->irq_mask(desc);
+	} else {
+		if (ops->irq_unmask)
+			ops->irq_unmask(desc);
+	}
+}
+
+void platform_msi_mask_irq(struct irq_data *data)
+{
+	__platform_msi_desc_mask_unmask_irq(irq_data_get_msi_desc(data), 1);
+}
+
+void platform_msi_unmask_irq(struct irq_data *data)
+{
+	__platform_msi_desc_mask_unmask_irq(irq_data_get_msi_desc(data), 0);
+}
+
 static void platform_msi_update_chip_ops(struct msi_domain_info *info)
 {
 	struct irq_chip *chip = info->chip;
diff --git a/drivers/base/platform-msi.h b/drivers/base/platform-msi.h
new file mode 100644
index 000000000000..1de8c2874218
--- /dev/null
+++ b/drivers/base/platform-msi.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright © 2020 Intel Corporation.
+ *
+ * Author: Megha Dey <megha.dey@intel.com>
+ */
+
+#include <linux/msi.h>
+
+#define DEV_ID_SHIFT    21
+#define MAX_DEV_MSIS	(1 << (32 - DEV_ID_SHIFT))
+
+/*
+ * Data structure containing a (made up, but unique) devid
+ * and the platform-msi ops.
+ */
+struct platform_msi_priv_data {
+	struct device			*dev;
+	void				*host_data;
+	msi_alloc_info_t		arg;
+	const struct platform_msi_ops	*ops;
+	int				devid;
+};
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 7f6a8eb51aca..1da97f905720 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -323,9 +323,13 @@ enum {
 
 /*
  * platform_msi_ops - Callbacks for platform MSI ops
+ * @irq_mask:   mask an interrupt source
+ * @irq_unmask: unmask an interrupt source
  * @write_msg:	write message content
  */
 struct platform_msi_ops {
+	unsigned int            (*irq_mask)(struct msi_desc *desc);
+	unsigned int            (*irq_unmask)(struct msi_desc *desc);
 	irq_write_msi_msg_t	write_msg;
 };
 
@@ -370,6 +374,10 @@ int platform_msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
 void platform_msi_domain_free(struct irq_domain *domain, unsigned int virq,
 			      unsigned int nvec);
 void *platform_msi_get_host_data(struct irq_domain *domain);
+
+void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg);
+void platform_msi_unmask_irq(struct irq_data *data);
+void platform_msi_mask_irq(struct irq_data *data);
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN

