Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E112A0DE2
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgJ3SxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:53:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:65477 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbgJ3SxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:53:00 -0400
IronPort-SDR: AXD8hg3gcAa468sDxByC0AX/0b3l+NaLWHHz6rZiXFYunomrDE8r7rs/EAY0nrz6HhYwoe/jL5
 p0rLDGDdDrbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="230287761"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="230287761"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:50:56 -0700
IronPort-SDR: P/EszHGZMS3LYCtTJeIVgFGLl03yO2IZ+VGXlypcKQUAJNJmboelDzpeQyf2D7wTrVKdPF3TOC
 YCDdP23muVzw==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="527209865"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:50:55 -0700
Subject: [PATCH v4 01/17] irqchip: Add IMS (Interrupt Message Store) driver
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
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 30 Oct 2020 11:50:54 -0700
Message-ID: <160408385476.912050.16205225207591080075.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Generic IMS(Interrupt Message Store) irq chips and irq domain
implementations for IMS based devices which store the interrupt
messages in an array in device memory.

Allocation and freeing of interrupts happens via the generic
msi_domain_alloc/free_irqs() interface. No special purpose IMS magic
required as long as the interrupt domain is stored in the underlying
device struct.

Provide storage and a setter for an Address Space Identifier. The
identifier is stored in the top level irq_data and it only can be
modified when the interrupt is not active. Add the necessary storage
and helper functions and validate that interrupts which require an
ASID have one assigned.

[Megha : Fixed compile time errors
         Added necessary dependencies to IMS_MSI_ARRAY config
         Fixed polarity of IMS_VECTOR_CTRL
         Added reads after writes to flush writes to device
         Tested the IMS infrastructure with the IDXD driver]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/irqchip/Kconfig             |   14 ++
 drivers/irqchip/Makefile            |    1 
 drivers/irqchip/irq-ims-msi.c       |  204 +++++++++++++++++++++++++++++++++++
 include/linux/interrupt.h           |    2 
 include/linux/irq.h                 |    4 +
 include/linux/irqchip/irq-ims-msi.h |   68 ++++++++++++
 kernel/irq/manage.c                 |   32 +++++
 7 files changed, 325 insertions(+)
 create mode 100644 drivers/irqchip/irq-ims-msi.c
 create mode 100644 include/linux/irqchip/irq-ims-msi.h

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index c6098eee0c7c..862ea81a69a0 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -597,4 +597,18 @@ config MST_IRQ
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
index 94c2885882ee..a7d54605060a 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -114,3 +114,4 @@ obj-$(CONFIG_LOONGSON_PCH_PIC)		+= irq-loongson-pch-pic.o
 obj-$(CONFIG_LOONGSON_PCH_MSI)		+= irq-loongson-pch-msi.o
 obj-$(CONFIG_MST_IRQ)			+= irq-mst-intc.o
 obj-$(CONFIG_SL28CPLD_INTC)		+= irq-sl28cpld.o
+obj-$(CONFIG_IMS_MSI)			+= irq-ims-msi.o
diff --git a/drivers/irqchip/irq-ims-msi.c b/drivers/irqchip/irq-ims-msi.c
new file mode 100644
index 000000000000..d54a54f5fdcc
--- /dev/null
+++ b/drivers/irqchip/irq-ims-msi.c
@@ -0,0 +1,204 @@
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
+	iowrite32_and_flush(val | (u32) auxval, ctrl);
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
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index ee8299eb1f52..43a8d1e9647e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -487,6 +487,8 @@ extern int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 extern int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 				 bool state);
 
+int irq_set_auxdata(unsigned int irq, unsigned int which, u64 val);
+
 #ifdef CONFIG_IRQ_FORCED_THREADING
 # ifdef CONFIG_PREEMPT_RT
 #  define force_irqthreads	(true)
diff --git a/include/linux/irq.h b/include/linux/irq.h
index c54365309e97..fd162aea0c3f 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -491,6 +491,8 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				irq_request_resources
  * @irq_compose_msi_msg:	optional to compose message content for MSI
  * @irq_write_msi_msg:	optional to write message content for MSI
+ * @irq_set_auxdata:	Optional function to update auxiliary data e.g. in
+ *			shared registers
  * @irq_get_irqchip_state:	return the internal state of an interrupt
  * @irq_set_irqchip_state:	set the internal state of a interrupt
  * @irq_set_vcpu_affinity:	optional to target a vCPU in a virtual machine
@@ -538,6 +540,8 @@ struct irq_chip {
 	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 
+	int		(*irq_set_auxdata)(struct irq_data *data, unsigned int which, u64 auxval);
+
 	int		(*irq_get_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool *state);
 	int		(*irq_set_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool state);
 
diff --git a/include/linux/irqchip/irq-ims-msi.h b/include/linux/irqchip/irq-ims-msi.h
new file mode 100644
index 000000000000..a9e43e1f7890
--- /dev/null
+++ b/include/linux/irqchip/irq-ims-msi.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* (C) Copyright 2020 Thomas Gleixner <tglx@linutronix.de> */
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
+/* Bit to mask the interrupt in ims_hw_slot::ctrl */
+#define IMS_CTRL_VECTOR_MASKBIT		BIT(0)
+
+/* Auxiliary control word data related defines */
+enum {
+	IMS_AUXDATA_CONTROL_WORD,
+};
+
+#define IMS_CTRL_PASID_ENABLE		BIT(3)
+#define IMS_CTRL_PASID_SHIFT		12
+
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
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index dc65d90108db..d7bf2ae67170 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2752,3 +2752,35 @@ int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 	return err;
 }
 EXPORT_SYMBOL_GPL(irq_set_irqchip_state);
+
+/**
+ * irq_set_auxdata - Set auxiliary data
+ * @irq:	Interrupt to update
+ * @which:	Selector which data to update
+ * @auxval:	Auxiliary data value
+ *
+ * Function to update auxiliary data for an interrupt, e.g. to update data
+ * which is stored in a shared register or data storage (e.g. IMS).
+ */
+int irq_set_auxdata(unsigned int irq, unsigned int which, u64 val)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	unsigned long flags;
+	int res = -ENODEV;
+
+	desc = irq_get_desc_buslock(irq, &flags, 0);
+	if (!desc)
+		return -EINVAL;
+
+	for (data = &desc->irq_data; data; data = irqd_get_parent_data(data)) {
+		if (data->chip->irq_set_auxdata) {
+			res = data->chip->irq_set_auxdata(data, which, val);
+			break;
+		}
+	}
+
+	irq_put_desc_busunlock(desc, flags);
+	return res;
+}
+EXPORT_SYMBOL_GPL(irq_set_auxdata);


