Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910F326B49C
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 01:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgIOX16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 19:27:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:50253 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgIOX14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 19:27:56 -0400
IronPort-SDR: n/mwJ0X+YkoNRgUdYzGZYYSAH8EwTI88oRGwRlBIJ4EaKRD9GOReNi2REtVWgLU7nUf+L+xqKP
 O4uBLOOAU/sg==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="147056485"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="147056485"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:27:44 -0700
IronPort-SDR: M81TrARsbFvTOqJY0nQ7ZbdyE0ijG0xYV7QWQvaNTJN7s4eT9zFUhqqEL8JewYztGqVXGlwZVU
 7CLrd7fJ2rRA==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="451619375"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:27:42 -0700
Subject: [PATCH v3 01/18] irqchip: Add IMS (Interrupt Message Storage) driver
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 15 Sep 2020 16:27:42 -0700
Message-ID: <160021246221.67751.16280230469654363209.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Generic IMS irq chips and irq domain implementations for IMS based devices
which store the interrupt messages in an array in device memory.

Allocation and freeing of interrupts happens via the generic
msi_domain_alloc/free_irqs() interface. No special purpose IMS magic
required as long as the interrupt domain is stored in the underlying device
struct.

[Megha : Fixed compile time errors
	 Added necessary dependencies to IMS_MSI_ARRAY config
	 Fixed polarity of IMS_VECTOR_CTRL
	 Added missing read after write in write_msg
	 Tested the IMS infrastructure with the IDXD driver]

Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/irqchip/Kconfig             |   14 +++
 drivers/irqchip/Makefile            |    1 
 drivers/irqchip/irq-ims-msi.c       |  181 +++++++++++++++++++++++++++++++++++
 include/linux/irqchip/irq-ims-msi.h |   45 +++++++++
 4 files changed, 241 insertions(+)
 create mode 100644 drivers/irqchip/irq-ims-msi.c
 create mode 100644 include/linux/irqchip/irq-ims-msi.h

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index bfc9719dbcdc..76479e9b1b4c 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -571,4 +571,18 @@ config LOONGSON_PCH_MSI
 	help
 	  Support for the Loongson PCH MSI Controller.
 
+config IMS_MSI
+	depends on PCI
+	select DEVICE_MSI
+	bool
+
+config IMS_MSI_ARRAY
+	bool "IMS Interrupt Message Storm MSI controller for device memory storage arrays"
+	depends on PCI
+	select IMS_MSI
+	select GENERIC_MSI_IRQ_DOMAIN
+	help
+	  Support for IMS Interrupt Message Storm MSI controller
+	  with IMS slot storage in a slot array in device memory
+
 endmenu
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 133f9c45744a..5ccd8336f8e3 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -111,3 +111,4 @@ obj-$(CONFIG_LOONGSON_HTPIC)		+= irq-loongson-htpic.o
 obj-$(CONFIG_LOONGSON_HTVEC)		+= irq-loongson-htvec.o
 obj-$(CONFIG_LOONGSON_PCH_PIC)		+= irq-loongson-pch-pic.o
 obj-$(CONFIG_LOONGSON_PCH_MSI)		+= irq-loongson-pch-msi.o
+obj-$(CONFIG_IMS_MSI)			+= irq-ims-msi.o
diff --git a/drivers/irqchip/irq-ims-msi.c b/drivers/irqchip/irq-ims-msi.c
new file mode 100644
index 000000000000..581febf2bca0
--- /dev/null
+++ b/drivers/irqchip/irq-ims-msi.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0
+// (C) Copyright 2020 Thomas Gleixner <tglx@linutronix.de>
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
+static void ims_array_mask_irq(struct irq_data *data)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
+	u32 __iomem *ctrl = &slot->ctrl;
+
+	iowrite32(ioread32(ctrl) | IMS_VECTOR_CTRL_MASK, ctrl);
+	ioread32(ctrl); /* Flush write to device */
+}
+
+static void ims_array_unmask_irq(struct irq_data *data)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
+	u32 __iomem *ctrl = &slot->ctrl;
+
+	iowrite32(ioread32(ctrl) & ~IMS_VECTOR_CTRL_MASK, ctrl);
+}
+
+static void ims_array_write_msi_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct ims_slot __iomem *slot = desc->device_msi.priv_iomem;
+
+	iowrite32(msg->address_lo, &slot->address_lo);
+	iowrite32(msg->address_hi, &slot->address_hi);
+	iowrite32(msg->data, &slot->data);
+	ioread32(slot);
+}
+
+static const struct irq_chip ims_array_msi_controller = {
+	.name			= "IMS",
+	.irq_mask		= ims_array_mask_irq,
+	.irq_unmask		= ims_array_unmask_irq,
+	.irq_write_msi_msg	= ims_array_write_msi_msg,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+static void ims_array_reset_slot(struct ims_slot __iomem *slot)
+{
+	iowrite32(0, &slot->address_lo);
+	iowrite32(0, &slot->address_hi);
+	iowrite32(0, &slot->data);
+	iowrite32(0, &slot->ctrl);
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
+static const struct ims_array_domain_template ims_array_domain_template = {
+	.ops = {
+		.msi_alloc_store	= ims_array_alloc_msi_store,
+		.msi_free_store		= ims_array_free_msi_store,
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
index 000000000000..2982ef3c0ed4
--- /dev/null
+++ b/include/linux/irqchip/irq-ims-msi.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* (C) Copyright 2020 Thomas Gleixner <tglx@linutronix.de> */
+
+#ifndef _LINUX_IRQCHIP_IRQ_IMS_MSI_H
+#define _LINUX_IRQCHIP_IRQ_IMS_MSI_H
+
+#include <linux/types.h>
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
+/* Bit to mask the interrupt in ims_hw_slot::ctrl */
+#define IMS_VECTOR_CTRL_MASK	0x01
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

