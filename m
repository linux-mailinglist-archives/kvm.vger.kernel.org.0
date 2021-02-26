Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0735532686D
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 21:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhBZURC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 15:17:02 -0500
Received: from mga17.intel.com ([192.55.52.151]:35622 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231145AbhBZUOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 15:14:01 -0500
IronPort-SDR: IF3b4pfcpNQ9jSJsiH8gXlmMC1mjgAPC1tGupmzSB/sYBPMYuFeox6xYMiKuxkxdK/Rn+erfON
 7MrXf+6u33OA==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="165846915"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="165846915"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 12:11:15 -0800
IronPort-SDR: l8rKYvxAd3WhPCjppPB1z+QYNNOCIF1Jf/BzlyVS9i5076WJM/YC9rcYScxQhFw4ErgXPe4sxP
 uKISFwCdieeQ==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="405109460"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Feb 2021 12:11:14 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [Patch V2 12/13] irqchip: Add IMS (Interrupt Message Store) driver
Date:   Fri, 26 Feb 2021 12:11:16 -0800
Message-Id: <1614370277-23235-13-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generic IMS(Interrupt Message Store) irq chips and irq domain
implementations for IMS based devices which store the interrupt messages
in an array in device memory.

Allocation and freeing of interrupts happens via the generic
msi_domain_alloc/free_irqs() interface. No special purpose IMS magic
required as long as the interrupt domain is stored in the underlying
device struct. The irq_set_auxdata() is used to program the pasid into
the IMS entry.

[Megha: Fixed compile time errors
        Added necessary dependencies to IMS_MSI_ARRAY config
        Fixed polarity of IMS_VECTOR_CTRL
        Added reads after writes to flush writes to device
        Added set_desc ops to IMS msi domain ops
        Tested the IMS infrastructure with the IDXD driver]

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 drivers/irqchip/Kconfig             |  14 +++
 drivers/irqchip/Makefile            |   1 +
 drivers/irqchip/irq-ims-msi.c       | 211 ++++++++++++++++++++++++++++++++++++
 include/linux/irqchip/irq-ims-msi.h |  68 ++++++++++++
 4 files changed, 294 insertions(+)
 create mode 100644 drivers/irqchip/irq-ims-msi.c
 create mode 100644 include/linux/irqchip/irq-ims-msi.h

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index e74fa20..2fb0c24 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -586,4 +586,18 @@ config MST_IRQ
 	help
 	  Support MStar Interrupt Controller.
 
+config IMS_MSI
+	depends on PCI
+	select DEVICE_MSI
+	bool
+
+config IMS_MSI_ARRAY
+	bool "IMS Interrupt Message Store MSI controller for device memory storage arrays"
+	depends on PCI
+	select IMS_MSI
+	select GENERIC_MSI_IRQ_DOMAIN
+	help
+	  Support for IMS Interrupt Message Store MSI controller
+	  with IMS slot storage in a slot array in device memory
+
 endmenu
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index c59b95a..e903201 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -113,3 +113,4 @@ obj-$(CONFIG_LOONGSON_PCH_MSI)		+= irq-loongson-pch-msi.o
 obj-$(CONFIG_MST_IRQ)			+= irq-mst-intc.o
 obj-$(CONFIG_SL28CPLD_INTC)		+= irq-sl28cpld.o
 obj-$(CONFIG_MACH_REALTEK_RTL)		+= irq-realtek-rtl.o
+obj-$(CONFIG_IMS_MSI)			+= irq-ims-msi.o
diff --git a/drivers/irqchip/irq-ims-msi.c b/drivers/irqchip/irq-ims-msi.c
new file mode 100644
index 0000000..fa23207
--- /dev/null
+++ b/drivers/irqchip/irq-ims-msi.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0
+// (C) Copyright 2021 Thomas Gleixner <tglx@linutronix.de>
+/*
+ * Shared interrupt chips and irq domains for IMS devices
+ */
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/msi.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+
+#include <linux/irqchip/irq-ims-msi.h>
+
+#ifdef CONFIG_IMS_MSI_ARRAY
+
+struct ims_array_data {
+	struct ims_array_info	info;
+	unsigned long		map[0];
+};
+
+static inline void iowrite32_and_flush(u32 value, void __iomem *addr)
+{
+	iowrite32(value, addr);
+	ioread32(addr);
+}
+
+static void ims_array_mask_irq(struct irq_data *data)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
+	u32 __iomem *ctrl = &slot->ctrl;
+
+	iowrite32_and_flush(ioread32(ctrl) | IMS_CTRL_VECTOR_MASKBIT, ctrl);
+}
+
+static void ims_array_unmask_irq(struct irq_data *data)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
+	u32 __iomem *ctrl = &slot->ctrl;
+
+	iowrite32_and_flush(ioread32(ctrl) & ~IMS_CTRL_VECTOR_MASKBIT, ctrl);
+}
+
+static void ims_array_write_msi_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
+
+	iowrite32(msg->address_lo, &slot->address_lo);
+	iowrite32(msg->address_hi, &slot->address_hi);
+	iowrite32_and_flush(msg->data, &slot->data);
+}
+
+static int ims_array_set_auxdata(struct irq_data *data, unsigned int which,
+				 u64 auxval)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
+	u32 val, __iomem *ctrl = &slot->ctrl;
+
+	if (which != IMS_AUXDATA_CONTROL_WORD)
+		return -EINVAL;
+	if (auxval & ~(u64)IMS_CONTROL_WORD_AUXMASK)
+		return -EINVAL;
+
+	val = ioread32(ctrl) & IMS_CONTROL_WORD_IRQMASK;
+	iowrite32_and_flush(val | (u32)auxval, ctrl);
+	return 0;
+}
+
+static const struct irq_chip ims_array_msi_controller = {
+	.name			= "IMS",
+	.irq_mask		= ims_array_mask_irq,
+	.irq_unmask		= ims_array_unmask_irq,
+	.irq_write_msi_msg	= ims_array_write_msi_msg,
+	.irq_set_auxdata	= ims_array_set_auxdata,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+static void ims_array_reset_slot(struct ims_slot __iomem *slot)
+{
+	iowrite32(0, &slot->address_lo);
+	iowrite32(0, &slot->address_hi);
+	iowrite32(0, &slot->data);
+	iowrite32_and_flush(IMS_CTRL_VECTOR_MASKBIT, &slot->ctrl);
+}
+
+static void ims_array_free_msi_store(struct irq_domain *domain,
+				     struct device *dev)
+{
+	struct msi_domain_info *info = domain->host_data;
+	struct ims_array_data *ims = info->data;
+	struct msi_desc *entry;
+
+	for_each_msi_entry(entry, dev) {
+		if (entry->device_msi.priv_iomem) {
+			clear_bit(entry->device_msi.hwirq, ims->map);
+			ims_array_reset_slot(entry->device_msi.priv_iomem);
+			entry->device_msi.priv_iomem = NULL;
+			entry->device_msi.hwirq = 0;
+		}
+	}
+}
+
+static int ims_array_alloc_msi_store(struct irq_domain *domain,
+				     struct device *dev, int nvec)
+{
+	struct msi_domain_info *info = domain->host_data;
+	struct ims_array_data *ims = info->data;
+	struct msi_desc *entry;
+
+	for_each_msi_entry(entry, dev) {
+		unsigned int idx;
+
+		idx = find_first_zero_bit(ims->map, ims->info.max_slots);
+		if (idx >= ims->info.max_slots)
+			goto fail;
+		set_bit(idx, ims->map);
+		entry->device_msi.priv_iomem = &ims->info.slots[idx];
+		ims_array_reset_slot(entry->device_msi.priv_iomem);
+		entry->device_msi.hwirq = idx;
+	}
+	return 0;
+
+fail:
+	ims_array_free_msi_store(domain, dev);
+	return -ENOSPC;
+}
+
+struct ims_array_domain_template {
+	struct msi_domain_ops	ops;
+	struct msi_domain_info	info;
+};
+
+static void ims_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
+{
+	arg->desc = desc;
+	arg->hwirq = desc->device_msi.hwirq;
+}
+
+static const struct ims_array_domain_template ims_array_domain_template = {
+	.ops = {
+		.msi_alloc_store	= ims_array_alloc_msi_store,
+		.msi_free_store		= ims_array_free_msi_store,
+		.set_desc               = ims_set_desc,
+	},
+	.info = {
+		.flags		= MSI_FLAG_USE_DEF_DOM_OPS |
+				  MSI_FLAG_USE_DEF_CHIP_OPS,
+		.handler	= handle_edge_irq,
+		.handler_name	= "edge",
+	},
+};
+
+struct irq_domain *
+pci_ims_array_create_msi_irq_domain(struct pci_dev *pdev,
+				    struct ims_array_info *ims_info)
+{
+	struct ims_array_domain_template *info;
+	struct ims_array_data *data;
+	struct irq_domain *domain;
+	struct irq_chip *chip;
+	unsigned int size;
+
+	/* Allocate new domain storage */
+	info = kmemdup(&ims_array_domain_template,
+		       sizeof(ims_array_domain_template), GFP_KERNEL);
+	if (!info)
+		return NULL;
+	/* Link the ops */
+	info->info.ops = &info->ops;
+
+	/* Allocate ims_info along with the bitmap */
+	size = sizeof(*data);
+	size += BITS_TO_LONGS(ims_info->max_slots) * sizeof(unsigned long);
+	data = kzalloc(size, GFP_KERNEL);
+	if (!data)
+		goto err_info;
+
+	data->info = *ims_info;
+	info->info.data = data;
+
+	/*
+	 * Allocate an interrupt chip because the core needs to be able to
+	 * update it with default callbacks.
+	 */
+	chip = kmemdup(&ims_array_msi_controller,
+		       sizeof(ims_array_msi_controller), GFP_KERNEL);
+	if (!chip)
+		goto err_data;
+	info->info.chip = chip;
+
+	domain = pci_subdevice_msi_create_irq_domain(pdev, &info->info);
+	if (!domain)
+		goto err_chip;
+
+	return domain;
+
+err_chip:
+	kfree(chip);
+err_data:
+	kfree(data);
+err_info:
+	kfree(info);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(pci_ims_array_create_msi_irq_domain);
+
+#endif /* CONFIG_IMS_MSI_ARRAY */
diff --git a/include/linux/irqchip/irq-ims-msi.h b/include/linux/irqchip/irq-ims-msi.h
new file mode 100644
index 0000000..9ba767f
--- /dev/null
+++ b/include/linux/irqchip/irq-ims-msi.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* (C) Copyright 2021 Thomas Gleixner <tglx@linutronix.de> */
+
+#ifndef _LINUX_IRQCHIP_IRQ_IMS_MSI_H
+#define _LINUX_IRQCHIP_IRQ_IMS_MSI_H
+
+#include <linux/types.h>
+#include <linux/bits.h>
+
+/**
+ * ims_hw_slot - The hardware layout of an IMS based MSI message
+ * @address_lo:	Lower 32bit address
+ * @address_hi:	Upper 32bit address
+ * @data:	Message data
+ * @ctrl:	Control word
+ *
+ * This structure is used by both the device memory array and the queue
+ * memory variants of IMS.
+ */
+struct ims_slot {
+	u32	address_lo;
+	u32	address_hi;
+	u32	data;
+	u32	ctrl;
+} __packed;
+
+/*
+ * The IMS control word utilizes bit 0-2 for interrupt control. The remaining
+ * bits can contain auxiliary data.
+ */
+#define IMS_CONTROL_WORD_IRQMASK	GENMASK(2, 0)
+#define IMS_CONTROL_WORD_AUXMASK	GENMASK(31, 3)
+
+/* Auxiliary control word data related defines */
+enum {
+	IMS_AUXDATA_CONTROL_WORD,
+};
+
+/* Bit to mask the interrupt in ims_hw_slot::ctrl */
+#define IMS_CTRL_VECTOR_MASKBIT		BIT(0)
+#define IMS_CTRL_PASID_ENABLE           BIT(3)
+#define IMS_CTRL_PASID_SHIFT            12
+
+/* Set pasid and enable bit for the IMS entry */
+static inline u32 ims_ctrl_pasid_aux(unsigned int pasid, bool enable)
+{
+	u32 auxval = pasid << IMS_CTRL_PASID_SHIFT;
+
+	return enable ? auxval | IMS_CTRL_PASID_ENABLE : auxval;
+}
+
+/**
+ * struct ims_array_info - Information to create an IMS array domain
+ * @slots:	Pointer to the start of the array
+ * @max_slots:	Maximum number of slots in the array
+ */
+struct ims_array_info {
+	struct ims_slot		__iomem *slots;
+	unsigned int		max_slots;
+};
+
+struct pci_dev;
+struct irq_domain;
+
+struct irq_domain *pci_ims_array_create_msi_irq_domain(struct pci_dev *pdev,
+						       struct ims_array_info *ims_info);
+
+#endif
-- 
2.7.4

