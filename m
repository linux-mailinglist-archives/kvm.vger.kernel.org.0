Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174AC228488
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgGUQCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:02:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:14231 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730139AbgGUQCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:02:48 -0400
IronPort-SDR: MaW+NAXVH5JP4iDk8R9v6n6yHU6eduCJvZfv/kC0DiJajCq81fhs8ofSFg1uApEJC9gEFOrr7s
 X2paKqT64Y7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="130239369"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="130239369"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:02:37 -0700
IronPort-SDR: zAO5KWIqCygedZ3OIT58lFgYN7+LChU1kvZ5X+6TvCo3X48M/w5pIteqyX4F9vMRGP1xUTEvMc
 oFAqy0Qc5TOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="319951866"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002.fm.intel.com with ESMTP; 21 Jul 2020 09:02:35 -0700
Subject: [PATCH RFC v2 03/18] irq/dev-msi: Create IR-DEV-MSI irq domain
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
Date:   Tue, 21 Jul 2020 09:02:35 -0700
Message-ID: <159534735519.28840.10435935598386192252.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Megha Dey <megha.dey@intel.com>

When DEV_MSI is enabled, the dev_msi_default_domain is updated to the
base DEV-MSI irq  domain. If interrupt remapping is enabled, we create
a new IR-DEV-MSI irq domain and update the dev_msi_default domain to
the same.

For X86, introduce a new irq_alloc_type which will be used by the
interrupt remapping driver.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/include/asm/hw_irq.h       |    1 +
 arch/x86/kernel/apic/msi.c          |   12 ++++++
 drivers/base/dev-msi.c              |   66 +++++++++++++++++++++++++++++++----
 drivers/iommu/intel/irq_remapping.c |   11 +++++-
 include/linux/intel-iommu.h         |    1 +
 include/linux/irqdomain.h           |   11 ++++++
 include/linux/msi.h                 |    3 ++
 7 files changed, 96 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 8ecd7570589d..bdddd63add41 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -40,6 +40,7 @@ enum irq_alloc_type {
 	X86_IRQ_ALLOC_TYPE_MSIX,
 	X86_IRQ_ALLOC_TYPE_DMAR,
 	X86_IRQ_ALLOC_TYPE_UV,
+	X86_IRQ_ALLOC_TYPE_DEV_MSI,
 };
 
 struct irq_alloc_info {
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 5cbaca58af95..8b25cadbae09 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -507,3 +507,15 @@ int hpet_assign_irq(struct irq_domain *domain, struct hpet_channel *hc,
 	return irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, &info);
 }
 #endif
+
+#ifdef CONFIG_DEV_MSI
+int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
+			   int nvec, msi_alloc_info_t *arg)
+{
+	memset(arg, 0, sizeof(*arg));
+
+	arg->type = X86_IRQ_ALLOC_TYPE_DEV_MSI;
+
+	return 0;
+}
+#endif
diff --git a/drivers/base/dev-msi.c b/drivers/base/dev-msi.c
index 240ccc353933..43d6ed3ba10f 100644
--- a/drivers/base/dev-msi.c
+++ b/drivers/base/dev-msi.c
@@ -5,6 +5,7 @@
  * Author: Megha Dey <megha.dey@intel.com>
  */
 
+#include <linux/device.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
@@ -32,7 +33,7 @@ static void dev_msi_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
 	arg->hwirq = dev_msi_calc_hwirq(desc);
 }
 
-static int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
+int __weak dev_msi_prepare(struct irq_domain *domain, struct device *dev,
 			   int nvec, msi_alloc_info_t *arg)
 {
 	memset(arg, 0, sizeof(*arg));
@@ -81,15 +82,66 @@ static int __init create_dev_msi_domain(void)
 	if (!fn)
 		return -ENXIO;
 
-	dev_msi_default_domain = msi_create_irq_domain(fn, &dev_msi_domain_info, parent);
+	/*
+	 * This initcall may come after remap code is initialized. Ensure that
+	 * dev_msi_default domain is updated correctly.
+	 */
 	if (!dev_msi_default_domain) {
-		pr_warn("failed to initialize irqdomain for DEV-MSI.\n");
-		return -ENXIO;
+		dev_msi_default_domain = msi_create_irq_domain(fn, &dev_msi_domain_info, parent);
+		if (!dev_msi_default_domain) {
+			pr_warn("failed to initialize irqdomain for DEV-MSI.\n");
+			return -ENXIO;
+		}
+
+		irq_domain_update_bus_token(dev_msi_default_domain, DOMAIN_BUS_PLATFORM_MSI);
+		irq_domain_free_fwnode(fn);
 	}
 
-	irq_domain_update_bus_token(dev_msi_default_domain, DOMAIN_BUS_PLATFORM_MSI);
-	irq_domain_free_fwnode(fn);
-
 	return 0;
 }
 device_initcall(create_dev_msi_domain);
+
+#ifdef CONFIG_IRQ_REMAP
+static struct irq_chip dev_msi_ir_controller = {
+	.name			= "IR-DEV-MSI",
+	.irq_unmask		= platform_msi_unmask_irq,
+	.irq_mask		= platform_msi_mask_irq,
+	.irq_write_msi_msg	= platform_msi_write_msg,
+	.irq_ack		= irq_chip_ack_parent,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_set_vcpu_affinity	= irq_chip_set_vcpu_affinity_parent,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+static struct msi_domain_info dev_msi_ir_domain_info = {
+	.flags		= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS,
+	.ops		= &dev_msi_domain_ops,
+	.chip		= &dev_msi_ir_controller,
+	.handler	= handle_edge_irq,
+	.handler_name	= "edge",
+};
+
+struct irq_domain *create_remap_dev_msi_irq_domain(struct irq_domain *parent,
+						   const char *name)
+{
+	struct fwnode_handle *fn;
+	struct irq_domain *domain;
+
+	fn = irq_domain_alloc_named_fwnode(name);
+	if (!fn)
+		return NULL;
+
+	domain = msi_create_irq_domain(fn, &dev_msi_ir_domain_info, parent);
+	if (!domain) {
+		pr_warn("failed to initialize irqdomain for IR-DEV-MSI.\n");
+		return ERR_PTR(-ENXIO);
+	}
+
+	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
+
+	if (!dev_msi_default_domain)
+		dev_msi_default_domain = domain;
+
+	return domain;
+}
+#endif
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 7f8769800815..51872aabe5f8 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -573,6 +573,10 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 						 "INTEL-IR-MSI",
 						 iommu->seq_id);
 
+	iommu->ir_dev_msi_domain =
+		create_remap_dev_msi_irq_domain(iommu->ir_domain,
+						"INTEL-IR-DEV-MSI");
+
 	ir_table->base = page_address(pages);
 	ir_table->bitmap = bitmap;
 	iommu->ir_table = ir_table;
@@ -1299,9 +1303,10 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 	case X86_IRQ_ALLOC_TYPE_HPET:
 	case X86_IRQ_ALLOC_TYPE_MSI:
 	case X86_IRQ_ALLOC_TYPE_MSIX:
+	case X86_IRQ_ALLOC_TYPE_DEV_MSI:
 		if (info->type == X86_IRQ_ALLOC_TYPE_HPET)
 			set_hpet_sid(irte, info->hpet_id);
-		else
+		else if (info->type != X86_IRQ_ALLOC_TYPE_DEV_MSI)
 			set_msi_sid(irte, info->msi_dev);
 
 		msg->address_hi = MSI_ADDR_BASE_HI;
@@ -1353,8 +1358,10 @@ static int intel_irq_remapping_alloc(struct irq_domain *domain,
 
 	if (!info || !iommu)
 		return -EINVAL;
+
 	if (nr_irqs > 1 && info->type != X86_IRQ_ALLOC_TYPE_MSI &&
-	    info->type != X86_IRQ_ALLOC_TYPE_MSIX)
+	    info->type != X86_IRQ_ALLOC_TYPE_MSIX &&
+	    info->type != X86_IRQ_ALLOC_TYPE_DEV_MSI)
 		return -EINVAL;
 
 	/*
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index d129baf7e0b8..3b868d1c43df 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -596,6 +596,7 @@ struct intel_iommu {
 	struct ir_table *ir_table;	/* Interrupt remapping info */
 	struct irq_domain *ir_domain;
 	struct irq_domain *ir_msi_domain;
+	struct irq_domain *ir_dev_msi_domain;
 #endif
 	struct iommu_device iommu;  /* IOMMU core code handle */
 	int		node;
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index b37350c4fe37..e537d7b50cee 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -589,6 +589,17 @@ irq_domain_hierarchical_is_msi_remap(struct irq_domain *domain)
 }
 #endif	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
 
+#if defined(CONFIG_DEV_MSI) && defined(CONFIG_IRQ_REMAP)
+extern struct irq_domain *create_remap_dev_msi_irq_domain(struct irq_domain *parent,
+							  const char *name);
+#else
+static inline struct irq_domain *create_remap_dev_msi_irq_domain(struct irq_domain *parent,
+								 const char *name)
+{
+	return NULL;
+}
+#endif
+
 #else /* CONFIG_IRQ_DOMAIN */
 static inline void irq_dispose_mapping(unsigned int virq) { }
 static inline struct irq_domain *irq_find_matching_fwnode(
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 1da97f905720..7098ba566bcd 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -378,6 +378,9 @@ void *platform_msi_get_host_data(struct irq_domain *domain);
 void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg);
 void platform_msi_unmask_irq(struct irq_data *data);
 void platform_msi_mask_irq(struct irq_data *data);
+
+int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
+                           int nvec, msi_alloc_info_t *arg);
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN

