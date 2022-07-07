Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BAF56A4AB
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbiGGN40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbiGGN4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:56:19 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D92F419C1E;
        Thu,  7 Jul 2022 06:56:16 -0700 (PDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id AEA7A804E7;
        Thu,  7 Jul 2022 09:56:05 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Robin Murphy <robin.murphy@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joerg Roedel <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Oliver O'Halloran" <oohall@gmail.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH kernel] powerpc/iommu: Add iommu_ops to report capabilities and allow blocking domains
Date:   Thu,  7 Jul 2022 23:55:52 +1000
Message-Id: <20220707135552.3688927-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Historically PPC64 managed to avoid using iommu_ops. The VFIO driver
uses a SPAPR TCE sub-driver and all iommu_ops uses were kept in
the Type1 VFIO driver. Recent development though has added a coherency
capability check to the generic part of VFIO and essentially disabled
VFIO on PPC64; the similar story about iommu_group_dma_owner_claimed().

This adds an iommu_ops stub which reports support for cache
coherency. Because bus_set_iommu() triggers IOMMU probing of PCI devices,
this provides minimum code for the probing to not crash.

Because now we have to set iommu_ops to the system (bus_set_iommu() or
iommu_device_register()), this requires the POWERNV PCI setup to happen
after bus_register(&pci_bus_type) which is postcore_initcall
TODO: check if it still works, read sha1, for more details:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5537fcb319d016ce387

Because setting the ops triggers probing, this does not work well with
iommu_group_add_device(), hence the move to iommu_probe_device().

Because iommu_probe_device() does not take the group (which is why
we had the helper in the first place), this adds
pci_controller_ops::device_group.

So, basically there is one iommu_device per PHB and devices are added to
groups indirectly via series of calls inside the IOMMU code.

pSeries is out of scope here (a minor fix needed for barely supported
platform in regard to VFIO).

The previous discussion is here:
https://patchwork.ozlabs.org/project/kvm-ppc/patch/20220701061751.1955857-1-aik@ozlabs.ru/

Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
Cc: Oliver O'Halloran <oohall@gmail.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Daniel Henrique Barboza <danielhb413@gmail.com>
Cc: Fabiano Rosas <farosas@linux.ibm.com>
Cc: Murilo Opsfelder Araujo <muriloo@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---


does it make sense to have this many callbacks, or
the generic IOMMU code can safely operate without some
(given I add some more checks for !NULL)? thanks,


---
 arch/powerpc/include/asm/iommu.h          |   2 +
 arch/powerpc/include/asm/pci-bridge.h     |   7 ++
 arch/powerpc/kernel/iommu.c               | 106 +++++++++++++++++++++-
 arch/powerpc/kernel/pci-common.c          |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c |  40 ++++++++
 5 files changed, 155 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 7e29c73e3dd4..4bdae0ee29d0 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -215,6 +215,8 @@ extern long iommu_tce_xchg_no_kill(struct mm_struct *mm,
 		enum dma_data_direction *direction);
 extern void iommu_tce_kill(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages);
+
+extern const struct iommu_ops spapr_tce_iommu_ops;
 #else
 static inline void iommu_register_group(struct iommu_table_group *table_group,
 					int pci_domain_number,
diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index c85f901227c9..338a45b410b4 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -8,6 +8,7 @@
 #include <linux/list.h>
 #include <linux/ioport.h>
 #include <linux/numa.h>
+#include <linux/iommu.h>
 
 struct device_node;
 
@@ -44,6 +45,9 @@ struct pci_controller_ops {
 #endif
 
 	void		(*shutdown)(struct pci_controller *hose);
+
+	struct iommu_group *(*device_group)(struct pci_controller *hose,
+					    struct pci_dev *pdev);
 };
 
 /*
@@ -131,6 +135,9 @@ struct pci_controller {
 	struct irq_domain	*dev_domain;
 	struct irq_domain	*msi_domain;
 	struct fwnode_handle	*fwnode;
+
+	/* iommu_ops support */
+	struct iommu_device	iommu;
 };
 
 /* These are used for config access before all the PCI probing
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 7e56ddb3e0b9..c4c7eb596fef 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1138,6 +1138,8 @@ EXPORT_SYMBOL_GPL(iommu_release_ownership);
 
 int iommu_add_device(struct iommu_table_group *table_group, struct device *dev)
 {
+	int ret;
+
 	/*
 	 * The sysfs entries should be populated before
 	 * binding IOMMU group. If sysfs entries isn't
@@ -1156,7 +1158,10 @@ int iommu_add_device(struct iommu_table_group *table_group, struct device *dev)
 	pr_debug("%s: Adding %s to iommu group %d\n",
 		 __func__, dev_name(dev),  iommu_group_id(table_group->group));
 
-	return iommu_group_add_device(table_group->group, dev);
+	ret = iommu_probe_device(dev);
+	dev_info(dev, "probed with %d\n", ret);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_add_device);
 
@@ -1176,4 +1181,103 @@ void iommu_del_device(struct device *dev)
 	iommu_group_remove_device(dev);
 }
 EXPORT_SYMBOL_GPL(iommu_del_device);
+
+/*
+ * A simple iommu_ops to allow less cruft in generic VFIO code.
+ */
+static bool spapr_tce_iommu_capable(enum iommu_cap cap)
+{
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
+static struct iommu_domain *spapr_tce_iommu_domain_alloc(unsigned int type)
+{
+	struct iommu_domain *domain;
+
+	if (type != IOMMU_DOMAIN_BLOCKED)
+		return NULL;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return NULL;
+
+	domain->geometry.aperture_start = 0;
+	domain->geometry.aperture_end = ~0ULL;
+	domain->geometry.force_aperture = true;
+
+	return domain;
+}
+
+static struct iommu_device *spapr_tce_iommu_probe_device(struct device *dev)
+{
+	struct pci_dev *pdev;
+	struct pci_controller *hose;
+
+	/* Weirdly iommu_device_register() assigns the same ops to all buses */
+	if (!dev_is_pci(dev))
+		return ERR_PTR(-EPERM);
+
+	pdev = to_pci_dev(dev);
+	hose = pdev->bus->sysdata;
+	return &hose->iommu;
+}
+
+static void spapr_tce_iommu_release_device(struct device *dev)
+{
+}
+
+static bool spapr_tce_iommu_is_attach_deferred(struct device *dev)
+{
+	return false;
+}
+
+static struct iommu_group *spapr_tce_iommu_device_group(struct device *dev)
+{
+	struct pci_controller *hose;
+	struct pci_dev *pdev;
+
+	/* Weirdly iommu_device_register() assigns the same ops to all buses */
+	if (!dev_is_pci(dev))
+		return ERR_PTR(-EPERM);
+
+	pdev = to_pci_dev(dev);
+	hose = pdev->bus->sysdata;
+
+	if (!hose->controller_ops.device_group)
+		return ERR_PTR(-ENOENT);
+
+	return hose->controller_ops.device_group(hose, pdev);
+}
+
+static int spapr_tce_iommu_attach_dev(struct iommu_domain *dom,
+				      struct device *dev)
+{
+	return 0;
+}
+
+static void spapr_tce_iommu_detach_dev(struct iommu_domain *dom,
+				       struct device *dev)
+{
+}
+
+const struct iommu_ops spapr_tce_iommu_ops = {
+	.capable = spapr_tce_iommu_capable,
+	.domain_alloc = spapr_tce_iommu_domain_alloc,
+	.probe_device = spapr_tce_iommu_probe_device,
+	.release_device = spapr_tce_iommu_release_device,
+	.device_group = spapr_tce_iommu_device_group,
+	.is_attach_deferred = spapr_tce_iommu_is_attach_deferred,
+	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.attach_dev = spapr_tce_iommu_attach_dev,
+		.detach_dev = spapr_tce_iommu_detach_dev,
+	}
+};
+
 #endif /* CONFIG_IOMMU_API */
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 068410cd54a3..72ca5afba0c0 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1714,4 +1714,4 @@ static int __init discover_phbs(void)
 
 	return 0;
 }
-core_initcall(discover_phbs);
+postcore_initcall_sync(discover_phbs);
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 5e65d983e257..d5139d003794 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2912,6 +2912,25 @@ static void pnv_pci_ioda_dma_bus_setup(struct pci_bus *bus)
 	}
 }
 
+static struct iommu_group *pnv_pci_device_group(struct pci_controller *hose,
+						struct pci_dev *pdev)
+{
+	struct pnv_phb *phb = hose->private_data;
+	struct pnv_ioda_pe *pe;
+
+	if (WARN_ON(!phb))
+		return ERR_PTR(-ENODEV);
+
+	pe = pnv_pci_bdfn_to_pe(phb, pdev->devfn | (pdev->bus->number << 8));
+	if (!pe)
+		return ERR_PTR(-ENODEV);
+
+	if (!pe->table_group.group)
+		return ERR_PTR(-ENODEV);
+
+	return pe->table_group.group;
+}
+
 static const struct pci_controller_ops pnv_pci_ioda_controller_ops = {
 	.dma_dev_setup		= pnv_pci_ioda_dma_dev_setup,
 	.dma_bus_setup		= pnv_pci_ioda_dma_bus_setup,
@@ -2922,6 +2941,7 @@ static const struct pci_controller_ops pnv_pci_ioda_controller_ops = {
 	.setup_bridge		= pnv_pci_fixup_bridge_resources,
 	.reset_secondary_bus	= pnv_pci_reset_secondary_bus,
 	.shutdown		= pnv_pci_ioda_shutdown,
+	.device_group		= pnv_pci_device_group,
 };
 
 static const struct pci_controller_ops pnv_npu_ocapi_ioda_controller_ops = {
@@ -2932,6 +2952,20 @@ static const struct pci_controller_ops pnv_npu_ocapi_ioda_controller_ops = {
 	.shutdown		= pnv_pci_ioda_shutdown,
 };
 
+static struct attribute *spapr_tce_iommu_attrs[] = {
+	NULL,
+};
+
+static struct attribute_group spapr_tce_iommu_group = {
+	.name = "spapr-tce-iommu",
+	.attrs = spapr_tce_iommu_attrs,
+};
+
+static const struct attribute_group *spapr_tce_iommu_groups[] = {
+	&spapr_tce_iommu_group,
+	NULL,
+};
+
 static void __init pnv_pci_init_ioda_phb(struct device_node *np,
 					 u64 hub_id, int ioda_type)
 {
@@ -3199,6 +3233,12 @@ static void __init pnv_pci_init_ioda_phb(struct device_node *np,
 
 	/* create pci_dn's for DT nodes under this PHB */
 	pci_devs_phb_init_dynamic(hose);
+
+	iommu_device_sysfs_add(&hose->iommu, hose->parent,
+			       spapr_tce_iommu_groups, "iommu%lld", phb_id);
+	rc = iommu_device_register(&hose->iommu, &spapr_tce_iommu_ops, hose->parent);
+	if (rc)
+		pr_warn("iommu_device_register returned %ld\n", rc);
 }
 
 void __init pnv_pci_init_ioda2_phb(struct device_node *np)
-- 
2.30.2

