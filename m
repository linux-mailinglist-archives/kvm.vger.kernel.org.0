Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8E1B3347
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgDUXe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:34:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:10128 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgDUXe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:34:26 -0400
IronPort-SDR: IaBF5dqT1TOrZzibrxbz5zeoww6iFNj8voSIdt+DCQ9qIcyVYK0mIAmSj56LIIQsnO0mfHIgDt
 dVeNmTJGmt8w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:34:25 -0700
IronPort-SDR: AwaYRlSuxOFxY46ppb2H+gAM1iWEA3fYWpl3hjCwgCOSgdSf8b2fA6i7FeamUksBxwR62OuXfv
 M86Ol0mkLVng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="365505910"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2020 16:34:24 -0700
Subject: [PATCH RFC 06/15] ims-msi: Enable IMS interrupts
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
Date:   Tue, 21 Apr 2020 16:34:24 -0700
Message-ID: <158751206394.36773.12409950149228811741.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

To enable IMS interrupts,

1. create an IMS irqdomain (arch_create_ims_irq_domain()) associated
with the interrupt remapping unit.

2. Add 'IMS' to the enum platform_msi_type to differentiate between
specific actions required for different types of platform-msi, currently
generic platform-msi and IMS

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |    6 ++++
 drivers/base/ims-msi.c               |   15 ++++++++++
 drivers/base/platform-msi.c          |   51 +++++++++++++++++++++++++---------
 drivers/iommu/intel-iommu.c          |    2 +
 drivers/iommu/intel_irq_remapping.c  |   31 +++++++++++++++++++--
 include/linux/intel-iommu.h          |    3 ++
 include/linux/msi.h                  |    9 ++++++
 7 files changed, 100 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 4bc985f1e2e4..575e48c31b78 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -53,6 +53,12 @@ irq_remapping_get_irq_domain(struct irq_alloc_info *info);
 extern struct irq_domain *
 arch_create_remap_msi_irq_domain(struct irq_domain *par, const char *n, int id);
 
+/* Create IMS irqdomain, use @parent as the parent irqdomain. */
+#ifdef CONFIG_MSI_IMS
+extern struct irq_domain *arch_create_ims_irq_domain(struct irq_domain *parent,
+						     const char *name);
+#endif
+
 /* Get parent irqdomain for interrupt remapping irqdomain */
 static inline struct irq_domain *arch_get_ir_parent_domain(void)
 {
diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
index 896a5a1b2252..ac21088bcb83 100644
--- a/drivers/base/ims-msi.c
+++ b/drivers/base/ims-msi.c
@@ -14,6 +14,7 @@
 #include <linux/mdev.h>
 #include <linux/msi.h>
 #include <linux/pci.h>
+#include <asm/irq_remapping.h>
 
 static u32 __dev_ims_desc_mask_irq(struct msi_desc *desc, u32 flag)
 {
@@ -101,6 +102,20 @@ static void dev_ims_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
 	arg->ims_hwirq = platform_msi_calc_hwirq(desc);
 }
 
+struct irq_domain *dev_get_ims_domain(struct device *dev)
+{
+	struct irq_alloc_info info;
+
+	if (dev_is_mdev(dev))
+		dev = mdev_to_parent(dev);
+
+	init_irq_alloc_info(&info, NULL);
+	info.type = X86_IRQ_ALLOC_TYPE_IMS;
+	info.dev = dev;
+
+	return irq_remapping_get_irq_domain(&info);
+}
+
 static struct msi_domain_ops dev_ims_domain_ops = {
 	.get_hwirq	= dev_ims_get_hwirq,
 	.msi_prepare	= dev_ims_prepare,
diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 6d8840db4a85..204ce8041c17 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -118,6 +118,8 @@ static void platform_msi_free_descs(struct device *dev, int base, int nvec,
 			kfree(platform_msi_group);
 		}
 	}
+
+	dev->platform_msi_type = 0;
 }
 
 static int platform_msi_alloc_descs_with_irq(struct device *dev, int virq,
@@ -205,18 +207,22 @@ platform_msi_alloc_priv_data(struct device *dev, unsigned int nvec,
 	 * accordingly (which would impact the max number of MSI
 	 * capable devices).
 	 */
-	if (!dev->msi_domain || !platform_ops->write_msg || !nvec ||
-	    nvec > MAX_DEV_MSIS)
+	if (!platform_ops->write_msg || !nvec || nvec > MAX_DEV_MSIS)
 		return ERR_PTR(-EINVAL);
 
-	if (dev->msi_domain->bus_token != DOMAIN_BUS_PLATFORM_MSI) {
-		dev_err(dev, "Incompatible msi_domain, giving up\n");
-		return ERR_PTR(-EINVAL);
-	}
+	if (dev->platform_msi_type == GEN_PLAT_MSI) {
+		if (!dev->msi_domain)
+			return ERR_PTR(-EINVAL);
+
+		if (dev->msi_domain->bus_token != DOMAIN_BUS_PLATFORM_MSI) {
+			dev_err(dev, "Incompatible msi_domain, giving up\n");
+			return ERR_PTR(-EINVAL);
+		}
 
-	/* Already had a helping of MSI? Greed... */
-	if (!list_empty(platform_msi_current_group_entry_list(dev)))
-		return ERR_PTR(-EBUSY);
+		/* Already had a helping of MSI? Greed... */
+		if (!list_empty(platform_msi_current_group_entry_list(dev)))
+			return ERR_PTR(-EBUSY);
+	}
 
 	datap = kzalloc(sizeof(*datap), GFP_KERNEL);
 	if (!datap)
@@ -254,6 +260,7 @@ static void platform_msi_free_priv_data(struct platform_msi_priv_data *data)
 int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
 				   const struct platform_msi_ops *platform_ops)
 {
+	dev->platform_msi_type = GEN_PLAT_MSI;
 	return platform_msi_domain_alloc_irqs_group(dev, nvec, platform_ops,
 									NULL);
 }
@@ -265,12 +272,18 @@ int platform_msi_domain_alloc_irqs_group(struct device *dev, unsigned int nvec,
 {
 	struct platform_msi_group_entry *platform_msi_group;
 	struct platform_msi_priv_data *priv_data;
+	struct irq_domain *domain;
 	int err;
 
-	dev->platform_msi_type = GEN_PLAT_MSI;
-
-	if (group_id)
+	if (!dev->platform_msi_type) {
 		*group_id = ++dev->group_id;
+		dev->platform_msi_type = IMS;
+		domain = dev_get_ims_domain(dev);
+		if (!domain)
+			return -ENOSYS;
+	} else {
+		domain = dev->msi_domain;
+	}
 
 	platform_msi_group = kzalloc(sizeof(*platform_msi_group), GFP_KERNEL);
 	if (!platform_msi_group) {
@@ -292,10 +305,11 @@ int platform_msi_domain_alloc_irqs_group(struct device *dev, unsigned int nvec,
 	if (err)
 		goto out_free_priv_data;
 
-	err = msi_domain_alloc_irqs(dev->msi_domain, dev, nvec);
+	err = msi_domain_alloc_irqs(domain, dev, nvec);
 	if (err)
 		goto out_free_desc;
 
+	dev->platform_msi_type = 0;
 	return 0;
 
 out_free_desc:
@@ -314,6 +328,7 @@ EXPORT_SYMBOL_GPL(platform_msi_domain_alloc_irqs_group);
  */
 void platform_msi_domain_free_irqs(struct device *dev)
 {
+	dev->platform_msi_type = GEN_PLAT_MSI;
 	platform_msi_domain_free_irqs_group(dev, 0);
 }
 EXPORT_SYMBOL_GPL(platform_msi_domain_free_irqs);
@@ -321,6 +336,14 @@ EXPORT_SYMBOL_GPL(platform_msi_domain_free_irqs);
 void platform_msi_domain_free_irqs_group(struct device *dev, unsigned int group)
 {
 	struct platform_msi_group_entry *platform_msi_group;
+	struct irq_domain *domain;
+
+	if (!dev->platform_msi_type) {
+		dev->platform_msi_type = IMS;
+		domain = dev_get_ims_domain(dev);
+	} else {
+		domain = dev->msi_domain;
+	}
 
 	list_for_each_entry(platform_msi_group,
 			    dev_to_platform_msi_group_list((dev)), group_list) {
@@ -334,7 +357,7 @@ void platform_msi_domain_free_irqs_group(struct device *dev, unsigned int group)
 			}
 		}
 	}
-	msi_domain_free_irqs_group(dev->msi_domain, dev, group);
+	msi_domain_free_irqs_group(domain, dev, group);
 	platform_msi_free_descs(dev, 0, MAX_DEV_MSIS, group);
 }
 EXPORT_SYMBOL_GPL(platform_msi_domain_free_irqs_group);
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index ef0a5246700e..99bb238caea6 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -794,7 +794,7 @@ is_downstream_to_pci_bridge(struct device *dev, struct device *bridge)
 	return false;
 }
 
-static struct intel_iommu *device_to_iommu(struct device *dev, u8 *bus, u8 *devfn)
+struct intel_iommu *device_to_iommu(struct device *dev, u8 *bus, u8 *devfn)
 {
 	struct dmar_drhd_unit *drhd = NULL;
 	struct intel_iommu *iommu;
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 81e43c1df7ec..1e470c9c3e7d 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -234,6 +234,18 @@ static struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
 	return drhd->iommu;
 }
 
+static struct intel_iommu *map_gen_dev_to_ir(struct device *dev)
+{
+	struct intel_iommu *iommu;
+	u8 bus, devfn;
+
+	iommu = device_to_iommu(dev, &bus, &devfn);
+	if (!iommu)
+		return NULL;
+
+	return iommu;
+}
+
 static int clear_entries(struct irq_2_iommu *irq_iommu)
 {
 	struct irte *start, *entry, *end;
@@ -572,6 +584,10 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 		arch_create_remap_msi_irq_domain(iommu->ir_domain,
 						 "INTEL-IR-MSI",
 						 iommu->seq_id);
+#if IS_ENABLED(CONFIG_MSI_IMS)
+	iommu->ir_ims_domain = arch_create_ims_irq_domain(iommu->ir_domain,
+							  "INTEL-IR-IMS");
+#endif
 
 	ir_table->base = page_address(pages);
 	ir_table->bitmap = bitmap;
@@ -637,6 +653,10 @@ static void intel_teardown_irq_remapping(struct intel_iommu *iommu)
 			irq_domain_remove(iommu->ir_domain);
 			iommu->ir_domain = NULL;
 		}
+		if (iommu->ir_ims_domain) {
+			irq_domain_remove(iommu->ir_ims_domain);
+			iommu->ir_ims_domain = NULL;
+		}
 		free_pages((unsigned long)iommu->ir_table->base,
 			   INTR_REMAP_PAGE_ORDER);
 		bitmap_free(iommu->ir_table->bitmap);
@@ -1132,6 +1152,11 @@ static struct irq_domain *intel_get_irq_domain(struct irq_alloc_info *info)
 		if (iommu)
 			return iommu->ir_msi_domain;
 		break;
+	case X86_IRQ_ALLOC_TYPE_IMS:
+		iommu = map_gen_dev_to_ir(info->dev);
+		if (iommu)
+			return iommu->ir_ims_domain;
+		break;
 	default:
 		break;
 	}
@@ -1299,9 +1324,10 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 	case X86_IRQ_ALLOC_TYPE_HPET:
 	case X86_IRQ_ALLOC_TYPE_MSI:
 	case X86_IRQ_ALLOC_TYPE_MSIX:
+	case X86_IRQ_ALLOC_TYPE_IMS:
 		if (info->type == X86_IRQ_ALLOC_TYPE_HPET)
 			set_hpet_sid(irte, info->hpet_id);
-		else
+		else if (info->type != X86_IRQ_ALLOC_TYPE_IMS)
 			set_msi_sid(irte, info->msi_dev);
 
 		msg->address_hi = MSI_ADDR_BASE_HI;
@@ -1354,7 +1380,8 @@ static int intel_irq_remapping_alloc(struct irq_domain *domain,
 	if (!info || !iommu)
 		return -EINVAL;
 	if (nr_irqs > 1 && info->type != X86_IRQ_ALLOC_TYPE_MSI &&
-	    info->type != X86_IRQ_ALLOC_TYPE_MSIX)
+	    info->type != X86_IRQ_ALLOC_TYPE_MSIX &&
+	    info->type != X86_IRQ_ALLOC_TYPE_IMS)
 		return -EINVAL;
 
 	/*
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 980234ae0312..cdaab83001da 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -557,6 +557,7 @@ struct intel_iommu {
 	struct ir_table *ir_table;	/* Interrupt remapping info */
 	struct irq_domain *ir_domain;
 	struct irq_domain *ir_msi_domain;
+	struct irq_domain *ir_ims_domain;
 #endif
 	struct iommu_device iommu;  /* IOMMU core code handle */
 	int		node;
@@ -701,6 +702,8 @@ extern struct intel_iommu *intel_svm_device_to_iommu(struct device *dev);
 static inline void intel_svm_check(struct intel_iommu *iommu) {}
 #endif
 
+extern struct intel_iommu *device_to_iommu(struct device *dev,
+					   u8 *bus, u8 *devfn);
 #ifdef CONFIG_INTEL_IOMMU_DEBUGFS
 void intel_iommu_debugfs_init(void);
 #else
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8b5f24bf3c47..2f8fa1391333 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -135,6 +135,7 @@ struct msi_desc {
 enum platform_msi_type {
 	NOT_PLAT_MSI = 0,
 	GEN_PLAT_MSI = 1,
+	IMS =	2,
 };
 
 struct platform_msi_group_entry {
@@ -454,4 +455,12 @@ static inline struct irq_domain *pci_msi_get_device_domain(struct pci_dev *pdev)
 }
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
 
+#ifdef CONFIG_MSI_IMS
+struct irq_domain *dev_get_ims_domain(struct device *dev);
+#else
+static inline struct irq_domain *dev_get_ims_domain(struct device *dev)
+{
+	return NULL;
+}
+#endif
 #endif /* LINUX_MSI_H */

