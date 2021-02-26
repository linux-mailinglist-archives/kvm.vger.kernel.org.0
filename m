Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C0A32684D
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 21:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhBZUNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 15:13:50 -0500
Received: from mga17.intel.com ([192.55.52.151]:35662 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230024AbhBZUM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 15:12:29 -0500
IronPort-SDR: GX8V3bE+rN2o6VCZI71iKbPWngd0DfU5jBYGYyzOS/P7P0uzglbLq2A6NOkRpd451g505DY6bl
 5dtHS9rJd9DA==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="165846885"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="165846885"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 12:11:11 -0800
IronPort-SDR: IyZ2IpXRfbmEHcV4hiAMmMvrpklHRgTe7EdusvO1084PNG83I0fduqXETi5E4sUMFXg4iEUdbn
 akD/3E8MYV3A==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="405109420"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Feb 2021 12:11:11 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [Patch V2 02/13] x86/msi: Rename and rework pci_msi_prepare() to cover non-PCI MSI
Date:   Fri, 26 Feb 2021 12:11:06 -0800
Message-Id: <1614370277-23235-3-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Rename it to x86_msi_prepare() and handle the allocation type setup
depending on the device type.

Add a new arch_msi_prepare define which will be utilized by the upcoming
device MSI support. Define it to NULL if not provided by an architecture
in the generic MSI header.

One arch specific function for MSI support is truly enough.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 arch/x86/include/asm/msi.h          |  4 +++-
 arch/x86/kernel/apic/msi.c          | 27 ++++++++++++++++++++-------
 drivers/pci/controller/pci-hyperv.c |  2 +-
 include/linux/msi.h                 |  4 ++++
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/msi.h b/arch/x86/include/asm/msi.h
index b85147d..9bd214e 100644
--- a/arch/x86/include/asm/msi.h
+++ b/arch/x86/include/asm/msi.h
@@ -6,9 +6,11 @@
 
 typedef struct irq_alloc_info msi_alloc_info_t;
 
-int pci_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
+int x86_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
 		    msi_alloc_info_t *arg);
 
+#define arch_msi_prepare		x86_msi_prepare
+
 /* Structs and defines for the X86 specific MSI message format */
 
 typedef struct x86_msi_data {
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 44ebe25..84b16c7 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -153,26 +153,39 @@ static struct irq_chip pci_msi_controller = {
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
-int pci_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
-		    msi_alloc_info_t *arg)
+static void pci_msi_prepare(struct device *dev, msi_alloc_info_t *arg)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct msi_desc *desc = first_pci_msi_entry(pdev);
+	struct msi_desc *desc = first_msi_entry(dev);
 
-	init_irq_alloc_info(arg, NULL);
 	if (desc->msi_attrib.is_msix) {
 		arg->type = X86_IRQ_ALLOC_TYPE_PCI_MSIX;
 	} else {
 		arg->type = X86_IRQ_ALLOC_TYPE_PCI_MSI;
 		arg->flags |= X86_IRQ_ALLOC_CONTIGUOUS_VECTORS;
 	}
+}
+
+static void dev_msi_prepare(struct device *dev, msi_alloc_info_t *arg)
+{
+	arg->type = X86_IRQ_ALLOC_TYPE_DEV_MSI;
+}
+
+int x86_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
+		    msi_alloc_info_t *arg)
+{
+	init_irq_alloc_info(arg, NULL);
+
+	if (dev_is_pci(dev))
+		pci_msi_prepare(dev, arg);
+	else
+		dev_msi_prepare(dev, arg);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(pci_msi_prepare);
+EXPORT_SYMBOL_GPL(x86_msi_prepare);
 
 static struct msi_domain_ops pci_msi_domain_ops = {
-	.msi_prepare	= pci_msi_prepare,
+	.msi_prepare	= x86_msi_prepare,
 };
 
 static struct msi_domain_info pci_msi_domain_info = {
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 27a17a1..ac4fe8b7 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1546,7 +1546,7 @@ static struct irq_chip hv_msi_irq_chip = {
 };
 
 static struct msi_domain_ops hv_msi_ops = {
-	.msi_prepare	= pci_msi_prepare,
+	.msi_prepare	= arch_msi_prepare,
 	.msi_free	= hv_msi_free,
 };
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index aef35fd..f3e54d2 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -473,4 +473,8 @@ static inline struct irq_domain *pci_msi_get_device_domain(struct pci_dev *pdev)
 }
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
 
+#ifndef arch_msi_prepare
+# define arch_msi_prepare	NULL
+#endif
+
 #endif /* LINUX_MSI_H */
-- 
2.7.4

