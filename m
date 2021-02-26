Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3856232685E
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 21:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhBZUPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 15:15:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:35662 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhBZUNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 15:13:02 -0500
IronPort-SDR: CPiudjATl23/Fax4HTjqdTyYi1Riy0/sMigLbl5epwleCBfSGb3OOFjr30arL2nN/Az/8dPspk
 KdyC1K2US1nQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="165846896"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="165846896"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 12:11:13 -0800
IronPort-SDR: 2O8Bb0nl9sJ8koTH0I8Pftu3UbS4RCIhJBkkw7Eheb1P/ldui9Khm3YVSEW/cT8K8rEgkdiV+6
 XwmX7rteDhWw==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="405109439"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Feb 2021 12:11:12 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [Patch V2 06/13] platform-msi: Add device MSI infrastructure
Date:   Fri, 26 Feb 2021 12:11:10 -0800
Message-Id: <1614370277-23235-7-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Add device specific MSI domain infrastructure for devices which have their
own resource management and interrupt chip. These devices are not related
to PCI and contrary to platform MSI they do not share a common resource and
interrupt chip. They provide their own domain specific resource management
and interrupt chip.

This utilizes the new alloc/free override in a non evil way which avoids
having yet another set of specialized alloc/free functions. Just using
msi_domain_alloc/free_irqs() is sufficient

While initially it was suggested and tried to piggyback device MSI on
platform MSI, the better variant is to reimplement platform MSI on top of
device MSI.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 drivers/base/platform-msi.c | 131 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/irqdomain.h   |   1 +
 include/linux/msi.h         |  24 ++++++++
 kernel/irq/Kconfig          |   4 ++
 4 files changed, 160 insertions(+)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 9d9ccfc..6127b3b 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -419,3 +419,134 @@ int platform_msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
 
 	return err;
 }
+
+#ifdef CONFIG_DEVICE_MSI
+/*
+ * Device specific MSI domain infrastructure for devices which have their
+ * own resource management and interrupt chip. These devices are not
+ * related to PCI and contrary to platform MSI they do not share a common
+ * resource and interrupt chip. They provide their own domain specific
+ * resource management and interrupt chip.
+ */
+
+static void device_msi_free_msi_entries(struct device *dev)
+{
+	struct list_head *msi_list = dev_to_msi_list(dev);
+	struct msi_desc *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, msi_list, list) {
+		list_del(&entry->list);
+		free_msi_entry(entry);
+	}
+}
+
+/**
+ * device_msi_free_irqs - Free MSI interrupts assigned to  a device
+ * @dev:	Pointer to the device
+ *
+ * Frees the interrupt and the MSI descriptors.
+ */
+static void device_msi_free_irqs(struct irq_domain *domain, struct device *dev)
+{
+	__msi_domain_free_irqs(domain, dev);
+	device_msi_free_msi_entries(dev);
+}
+
+/**
+ * device_msi_alloc_irqs - Allocate MSI interrupts for a device
+ * @dev:	Pointer to the device
+ * @nvec:	Number of vectors
+ *
+ * Allocates the required number of MSI descriptors and the corresponding
+ * interrupt descriptors.
+ */
+static int device_msi_alloc_irqs(struct irq_domain *domain, struct device *dev, int nvec)
+{
+	int i, ret = -ENOMEM;
+
+	for (i = 0; i < nvec; i++) {
+		struct msi_desc *entry = alloc_msi_entry(dev, 1, NULL);
+
+		if (!entry)
+			goto fail;
+		list_add_tail(&entry->list, dev_to_msi_list(dev));
+	}
+
+	ret = __msi_domain_alloc_irqs(domain, dev, nvec);
+	if (!ret)
+		return 0;
+fail:
+	device_msi_free_msi_entries(dev);
+	return ret;
+}
+
+static void device_msi_update_dom_ops(struct msi_domain_info *info)
+{
+	if (!info->ops->domain_alloc_irqs)
+		info->ops->domain_alloc_irqs = device_msi_alloc_irqs;
+	if (!info->ops->domain_free_irqs)
+		info->ops->domain_free_irqs = device_msi_free_irqs;
+	if (!info->ops->msi_prepare)
+		info->ops->msi_prepare = arch_msi_prepare;
+}
+
+/**
+ * device_msi_create_msi_irq_domain - Create an irq domain for devices
+ * @fwnode:	Firmware node of the interrupt controller
+ * @info:	MSI domain info to configure the new domain
+ * @parent:	Parent domain
+ */
+struct irq_domain *device_msi_create_irq_domain(struct fwnode_handle *fn,
+						struct msi_domain_info *info,
+						struct irq_domain *parent)
+{
+	struct irq_domain *domain;
+
+	if (info->flags & MSI_FLAG_USE_DEF_CHIP_OPS)
+		platform_msi_update_chip_ops(info);
+
+	if (info->flags & MSI_FLAG_USE_DEF_DOM_OPS)
+		device_msi_update_dom_ops(info);
+
+	msi_domain_set_default_info_flags(info);
+
+	domain = msi_create_irq_domain(fn, info, parent);
+	if (domain)
+		irq_domain_update_bus_token(domain, DOMAIN_BUS_DEVICE_MSI);
+	return domain;
+}
+
+#ifdef CONFIG_PCI
+#include <linux/pci.h>
+
+/**
+ * pci_subdevice_msi_create_irq_domain - Create an irq domain for subdevices
+ * @pdev:	Pointer to PCI device for which the subdevice domain is created
+ * @info:	MSI domain info to configure the new domain
+ */
+struct irq_domain *pci_subdevice_msi_create_irq_domain(struct pci_dev *pdev,
+						       struct msi_domain_info *info)
+{
+	struct irq_domain *domain, *pdev_msi;
+	struct fwnode_handle *fn;
+
+	/*
+	 * Retrieve the MSI domain of the underlying PCI device's MSI
+	 * domain. The PCI device domain's parent domain is also the parent
+	 * domain of the new subdevice domain.
+	 */
+	pdev_msi = dev_get_msi_domain(&pdev->dev);
+	if (!pdev_msi)
+		return NULL;
+
+	fn = irq_domain_alloc_named_fwnode(dev_name(&pdev->dev));
+	if (!fn)
+		return NULL;
+	domain = device_msi_create_irq_domain(fn, info, pdev_msi->parent);
+	if (!domain)
+		irq_domain_free_fwnode(fn);
+	return domain;
+}
+EXPORT_SYMBOL_GPL(pci_subdevice_msi_create_irq_domain);
+#endif /* CONFIG_PCI */
+#endif /* CONFIG_DEVICE_MSI */
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 42d1968..06c88ba 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -85,6 +85,7 @@ enum irq_domain_bus_token {
 	DOMAIN_BUS_TI_SCI_INTA_MSI,
 	DOMAIN_BUS_WAKEUP,
 	DOMAIN_BUS_VMD_MSI,
+	DOMAIN_BUS_DEVICE_MSI,
 };
 
 /**
diff --git a/include/linux/msi.h b/include/linux/msi.h
index f6e52de..46e879c 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -95,6 +95,18 @@ struct ti_sci_inta_msi_desc {
 };
 
 /**
+ * device_msi_desc - Device MSI specific MSI descriptor data
+ * @priv:		Pointer to device specific private data
+ * @priv_iomem:		Pointer to device specific private io memory
+ * @hwirq:		The hardware irq number in the device domain
+ */
+struct device_msi_desc {
+	void		*priv;
+	void __iomem	*priv_iomem;
+	u16		hwirq;
+};
+
+/**
  * struct msi_desc - Descriptor structure for MSI based interrupts
  * @list:	List head for management
  * @irq:	The base interrupt number
@@ -166,6 +178,7 @@ struct msi_desc {
 		struct platform_msi_desc platform;
 		struct fsl_mc_msi_desc fsl_mc;
 		struct ti_sci_inta_msi_desc inta;
+		struct device_msi_desc device_msi;
 	};
 };
 
@@ -457,6 +470,17 @@ void *platform_msi_get_host_data(struct irq_domain *domain);
 void msi_domain_set_default_info_flags(struct msi_domain_info *info);
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
 
+#ifdef CONFIG_DEVICE_MSI
+struct irq_domain *device_msi_create_irq_domain(struct fwnode_handle *fn,
+						struct msi_domain_info *info,
+						struct irq_domain *parent);
+
+# ifdef CONFIG_PCI
+struct irq_domain *pci_subdevice_msi_create_irq_domain(struct pci_dev *pdev,
+						       struct msi_domain_info *info);
+# endif
+#endif /* CONFIG_DEVICE_MSI */
+
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
 void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
 struct irq_domain *pci_msi_create_irq_domain(struct fwnode_handle *fwnode,
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index d79ef24..7223327 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -89,6 +89,10 @@ config GENERIC_MSI_IRQ_DOMAIN
 	select IRQ_DOMAIN_HIERARCHY
 	select GENERIC_MSI_IRQ
 
+config DEVICE_MSI
+	bool
+	select GENERIC_MSI_IRQ_DOMAIN
+
 config IRQ_MSI_IOMMU
 	bool
 
-- 
2.7.4

