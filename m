Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6702302CE
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgG1G1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:27:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:37264 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgG1G1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:43 -0400
IronPort-SDR: A/CyM0VHc3QAse3wjZHLc7dWI4O9BTfvHxCyVzXEipceb7T7hAW/wnPn2pONLlGbFIVoTpe/4K
 myf5NuW45XSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="152412011"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="152412011"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:33 -0700
IronPort-SDR: 0zjPLrnNKqv9O1JrjRvsvPOO0H28cBbGGQcwLfNPPDnHk8C4wL12dIlXlD0e3s12K3CtpzjPhq
 3GQQZO5BKvRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394232805"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:31 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v9 03/25] hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps
Date:   Mon, 27 Jul 2020 23:33:56 -0700
Message-Id: <1595918058-33392-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch modifies pci_setup_iommu() to set PCIIOMMUOps
instead of setting PCIIOMMUFunc. PCIIOMMUFunc is used to
get an address space for a PCI device in vendor specific
way. The PCIIOMMUOps still offers this functionality. But
using PCIIOMMUOps leaves space to add more iommu related
vendor specific operations.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/alpha/typhoon.c       |  6 +++++-
 hw/arm/smmu-common.c     |  6 +++++-
 hw/hppa/dino.c           |  6 +++++-
 hw/i386/amd_iommu.c      |  6 +++++-
 hw/i386/intel_iommu.c    |  6 +++++-
 hw/pci-host/designware.c |  6 +++++-
 hw/pci-host/pnv_phb3.c   |  6 +++++-
 hw/pci-host/pnv_phb4.c   |  6 +++++-
 hw/pci-host/ppce500.c    |  6 +++++-
 hw/pci-host/prep.c       |  6 +++++-
 hw/pci-host/sabre.c      |  6 +++++-
 hw/pci/pci.c             | 18 +++++++++++++-----
 hw/ppc/ppc440_pcix.c     |  6 +++++-
 hw/ppc/spapr_pci.c       |  6 +++++-
 hw/s390x/s390-pci-bus.c  |  8 ++++++--
 hw/virtio/virtio-iommu.c |  6 +++++-
 include/hw/pci/pci.h     |  8 ++++++--
 include/hw/pci/pci_bus.h |  2 +-
 18 files changed, 96 insertions(+), 24 deletions(-)

diff --git a/hw/alpha/typhoon.c b/hw/alpha/typhoon.c
index 29d44df..c4ac693 100644
--- a/hw/alpha/typhoon.c
+++ b/hw/alpha/typhoon.c
@@ -740,6 +740,10 @@ static AddressSpace *typhoon_pci_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &s->pchip.iommu_as;
 }
 
+static const PCIIOMMUOps typhoon_iommu_ops = {
+    .get_address_space = typhoon_pci_dma_iommu,
+};
+
 static void typhoon_set_irq(void *opaque, int irq, int level)
 {
     TyphoonState *s = opaque;
@@ -897,7 +901,7 @@ PCIBus *typhoon_init(MemoryRegion *ram, ISABus **isa_bus, qemu_irq *p_rtc_irq,
                              "iommu-typhoon", UINT64_MAX);
     address_space_init(&s->pchip.iommu_as, MEMORY_REGION(&s->pchip.iommu),
                        "pchip0-pci");
-    pci_setup_iommu(b, typhoon_pci_dma_iommu, s);
+    pci_setup_iommu(b, &typhoon_iommu_ops, s);
 
     /* Pchip0 PCI special/interrupt acknowledge, 0x801.F800.0000, 64MB.  */
     memory_region_init_io(&s->pchip.reg_iack, OBJECT(s), &alpha_pci_iack_ops,
diff --git a/hw/arm/smmu-common.c b/hw/arm/smmu-common.c
index e13a5f4..447146e 100644
--- a/hw/arm/smmu-common.c
+++ b/hw/arm/smmu-common.c
@@ -343,6 +343,10 @@ static AddressSpace *smmu_find_add_as(PCIBus *bus, void *opaque, int devfn)
     return &sdev->as;
 }
 
+static const PCIIOMMUOps smmu_ops = {
+    .get_address_space = smmu_find_add_as,
+};
+
 IOMMUMemoryRegion *smmu_iommu_mr(SMMUState *s, uint32_t sid)
 {
     uint8_t bus_n, devfn;
@@ -437,7 +441,7 @@ static void smmu_base_realize(DeviceState *dev, Error **errp)
     s->smmu_pcibus_by_busptr = g_hash_table_new(NULL, NULL);
 
     if (s->primary_bus) {
-        pci_setup_iommu(s->primary_bus, smmu_find_add_as, s);
+        pci_setup_iommu(s->primary_bus, &smmu_ops, s);
     } else {
         error_setg(errp, "SMMU is not attached to any PCI bus!");
     }
diff --git a/hw/hppa/dino.c b/hw/hppa/dino.c
index 7f0c622..ca2dea4 100644
--- a/hw/hppa/dino.c
+++ b/hw/hppa/dino.c
@@ -459,6 +459,10 @@ static AddressSpace *dino_pcihost_set_iommu(PCIBus *bus, void *opaque,
     return &s->bm_as;
 }
 
+static const PCIIOMMUOps dino_iommu_ops = {
+    .get_address_space = dino_pcihost_set_iommu,
+};
+
 /*
  * Dino interrupts are connected as shown on Page 78, Table 23
  * (Little-endian bit numbers)
@@ -580,7 +584,7 @@ PCIBus *dino_init(MemoryRegion *addr_space,
     memory_region_add_subregion(&s->bm, 0xfff00000,
                                 &s->bm_cpu_alias);
     address_space_init(&s->bm_as, &s->bm, "pci-bm");
-    pci_setup_iommu(b, dino_pcihost_set_iommu, s);
+    pci_setup_iommu(b, &dino_iommu_ops, s);
 
     *p_rtc_irq = qemu_allocate_irq(dino_set_timer_irq, s, 0);
     *p_ser_irq = qemu_allocate_irq(dino_set_serial_irq, s, 0);
diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index 087f601..77f183d 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -1452,6 +1452,10 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &iommu_as[devfn]->as;
 }
 
+static const PCIIOMMUOps amdvi_iommu_ops = {
+    .get_address_space = amdvi_host_dma_iommu,
+};
+
 static const MemoryRegionOps mmio_mem_ops = {
     .read = amdvi_mmio_read,
     .write = amdvi_mmio_write,
@@ -1579,7 +1583,7 @@ static void amdvi_realize(DeviceState *dev, Error **errp)
 
     sysbus_init_mmio(SYS_BUS_DEVICE(s), &s->mmio);
     sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, AMDVI_BASE_ADDR);
-    pci_setup_iommu(bus, amdvi_host_dma_iommu, s);
+    pci_setup_iommu(bus, &amdvi_iommu_ops, s);
     s->devid = object_property_get_int(OBJECT(&s->pci), "addr", &error_abort);
     msi_init(&s->pci.dev, 0, 1, true, false, errp);
     amdvi_init(s);
diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 5284bb6..76c2f70 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3734,6 +3734,10 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &vtd_as->as;
 }
 
+static PCIIOMMUOps vtd_iommu_ops = {
+    .get_address_space = vtd_host_dma_iommu,
+};
+
 static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
 {
     X86IOMMUState *x86_iommu = X86_IOMMU_DEVICE(s);
@@ -3845,7 +3849,7 @@ static void vtd_realize(DeviceState *dev, Error **errp)
                                               g_free, g_free);
     vtd_init(s);
     sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, Q35_HOST_BRIDGE_IOMMU_ADDR);
-    pci_setup_iommu(bus, vtd_host_dma_iommu, dev);
+    pci_setup_iommu(bus, &vtd_iommu_ops, dev);
     /* Pseudo address space under root PCI bus. */
     x86ms->ioapic_as = vtd_host_dma_iommu(bus, s, Q35_PSEUDO_DEVFN_IOAPIC);
     qemu_add_machine_init_done_notifier(&vtd_machine_done_notify);
diff --git a/hw/pci-host/designware.c b/hw/pci-host/designware.c
index 8492c18..6a1e1ae 100644
--- a/hw/pci-host/designware.c
+++ b/hw/pci-host/designware.c
@@ -645,6 +645,10 @@ static AddressSpace *designware_pcie_host_set_iommu(PCIBus *bus, void *opaque,
     return &s->pci.address_space;
 }
 
+static const PCIIOMMUOps designware_iommu_ops = {
+    .get_address_space = designware_pcie_host_set_iommu,
+};
+
 static void designware_pcie_host_realize(DeviceState *dev, Error **errp)
 {
     PCIHostState *pci = PCI_HOST_BRIDGE(dev);
@@ -686,7 +690,7 @@ static void designware_pcie_host_realize(DeviceState *dev, Error **errp)
     address_space_init(&s->pci.address_space,
                        &s->pci.address_space_root,
                        "pcie-bus-address-space");
-    pci_setup_iommu(pci->bus, designware_pcie_host_set_iommu, s);
+    pci_setup_iommu(pci->bus, &designware_iommu_ops, s);
 
     qdev_realize(DEVICE(&s->root), BUS(pci->bus), &error_fatal);
 }
diff --git a/hw/pci-host/pnv_phb3.c b/hw/pci-host/pnv_phb3.c
index 82132c1..10dc2c8 100644
--- a/hw/pci-host/pnv_phb3.c
+++ b/hw/pci-host/pnv_phb3.c
@@ -961,6 +961,10 @@ static AddressSpace *pnv_phb3_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &ds->dma_as;
 }
 
+static PCIIOMMUOps pnv_phb3_iommu_ops = {
+    .get_address_space = pnv_phb3_dma_iommu,
+};
+
 static void pnv_phb3_instance_init(Object *obj)
 {
     PnvPHB3 *phb = PNV_PHB3(obj);
@@ -1048,7 +1052,7 @@ static void pnv_phb3_realize(DeviceState *dev, Error **errp)
                                      &phb->pci_mmio, &phb->pci_io,
                                      0, 4, TYPE_PNV_PHB3_ROOT_BUS);
 
-    pci_setup_iommu(pci->bus, pnv_phb3_dma_iommu, phb);
+    pci_setup_iommu(pci->bus, &pnv_phb3_iommu_ops, phb);
 
     /* Add a single Root port */
     qdev_prop_set_uint8(DEVICE(&phb->root), "chassis", phb->chip_id);
diff --git a/hw/pci-host/pnv_phb4.c b/hw/pci-host/pnv_phb4.c
index 75ad766..53aac37 100644
--- a/hw/pci-host/pnv_phb4.c
+++ b/hw/pci-host/pnv_phb4.c
@@ -1148,6 +1148,10 @@ static AddressSpace *pnv_phb4_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &ds->dma_as;
 }
 
+static PCIIOMMUOps pnv_phb4_iommu_ops = {
+    .get_address_space = pnv_phb4_dma_iommu,
+};
+
 static void pnv_phb4_instance_init(Object *obj)
 {
     PnvPHB4 *phb = PNV_PHB4(obj);
@@ -1202,7 +1206,7 @@ static void pnv_phb4_realize(DeviceState *dev, Error **errp)
                                      pnv_phb4_set_irq, pnv_phb4_map_irq, phb,
                                      &phb->pci_mmio, &phb->pci_io,
                                      0, 4, TYPE_PNV_PHB4_ROOT_BUS);
-    pci_setup_iommu(pci->bus, pnv_phb4_dma_iommu, phb);
+    pci_setup_iommu(pci->bus, &pnv_phb4_iommu_ops, phb);
 
     /* Add a single Root port */
     qdev_prop_set_uint8(DEVICE(&phb->root), "chassis", phb->chip_id);
diff --git a/hw/pci-host/ppce500.c b/hw/pci-host/ppce500.c
index d710727..5baf5db 100644
--- a/hw/pci-host/ppce500.c
+++ b/hw/pci-host/ppce500.c
@@ -439,6 +439,10 @@ static AddressSpace *e500_pcihost_set_iommu(PCIBus *bus, void *opaque,
     return &s->bm_as;
 }
 
+static const PCIIOMMUOps ppce500_iommu_ops = {
+    .get_address_space = e500_pcihost_set_iommu,
+};
+
 static void e500_pcihost_realize(DeviceState *dev, Error **errp)
 {
     SysBusDevice *sbd = SYS_BUS_DEVICE(dev);
@@ -473,7 +477,7 @@ static void e500_pcihost_realize(DeviceState *dev, Error **errp)
     memory_region_init(&s->bm, OBJECT(s), "bm-e500", UINT64_MAX);
     memory_region_add_subregion(&s->bm, 0x0, &s->busmem);
     address_space_init(&s->bm_as, &s->bm, "pci-bm");
-    pci_setup_iommu(b, e500_pcihost_set_iommu, s);
+    pci_setup_iommu(b, &ppce500_iommu_ops, s);
 
     pci_create_simple(b, 0, "e500-host-bridge");
 
diff --git a/hw/pci-host/prep.c b/hw/pci-host/prep.c
index 4b93fd2..3a74e79 100644
--- a/hw/pci-host/prep.c
+++ b/hw/pci-host/prep.c
@@ -213,6 +213,10 @@ static AddressSpace *raven_pcihost_set_iommu(PCIBus *bus, void *opaque,
     return &s->bm_as;
 }
 
+static const PCIIOMMUOps raven_iommu_ops = {
+    .get_address_space = raven_pcihost_set_iommu,
+};
+
 static void raven_change_gpio(void *opaque, int n, int level)
 {
     PREPPCIState *s = opaque;
@@ -301,7 +305,7 @@ static void raven_pcihost_initfn(Object *obj)
     memory_region_add_subregion(&s->bm, 0         , &s->bm_pci_memory_alias);
     memory_region_add_subregion(&s->bm, 0x80000000, &s->bm_ram_alias);
     address_space_init(&s->bm_as, &s->bm, "raven-bm");
-    pci_setup_iommu(&s->pci_bus, raven_pcihost_set_iommu, s);
+    pci_setup_iommu(&s->pci_bus, &raven_iommu_ops, s);
 
     h->bus = &s->pci_bus;
 
diff --git a/hw/pci-host/sabre.c b/hw/pci-host/sabre.c
index 0cc6858..7170049 100644
--- a/hw/pci-host/sabre.c
+++ b/hw/pci-host/sabre.c
@@ -113,6 +113,10 @@ static AddressSpace *sabre_pci_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &is->iommu_as;
 }
 
+static const PCIIOMMUOps sabre_iommu_ops = {
+    .get_address_space = sabre_pci_dma_iommu,
+};
+
 static void sabre_config_write(void *opaque, hwaddr addr,
                                uint64_t val, unsigned size)
 {
@@ -403,7 +407,7 @@ static void sabre_realize(DeviceState *dev, Error **errp)
     /* IOMMU */
     memory_region_add_subregion_overlap(&s->sabre_config, 0x200,
                     sysbus_mmio_get_region(SYS_BUS_DEVICE(s->iommu), 0), 1);
-    pci_setup_iommu(phb->bus, sabre_pci_dma_iommu, s->iommu);
+    pci_setup_iommu(phb->bus, &sabre_iommu_ops, s->iommu);
 
     /* APB secondary busses */
     pci_dev = pci_new_multifunction(PCI_DEVFN(1, 0), true,
diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index de0fae1..b2a2077 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2665,7 +2665,13 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
     PCIBus *iommu_bus = bus;
     uint8_t devfn = dev->devfn;
 
-    while (iommu_bus && !iommu_bus->iommu_fn && iommu_bus->parent_dev) {
+    /*
+     * get_address_space() callback is mandatory, so needs to ensure its
+     * presence in the iommu_bus search.
+     */
+    while (iommu_bus && (!iommu_bus->iommu_ops ||
+           iommu_bus->iommu_ops->get_address_space) &&
+           iommu_bus->parent_dev) {
         PCIBus *parent_bus = pci_get_bus(iommu_bus->parent_dev);
 
         /*
@@ -2704,15 +2710,17 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
 
         iommu_bus = parent_bus;
     }
-    if (iommu_bus && iommu_bus->iommu_fn) {
-        return iommu_bus->iommu_fn(bus, iommu_bus->iommu_opaque, devfn);
+    if (iommu_bus && iommu_bus->iommu_ops &&
+                     iommu_bus->iommu_ops->get_address_space) {
+        return iommu_bus->iommu_ops->get_address_space(bus,
+                                 iommu_bus->iommu_opaque, devfn);
     }
     return &address_space_memory;
 }
 
-void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque)
+void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *ops, void *opaque)
 {
-    bus->iommu_fn = fn;
+    bus->iommu_ops = ops;
     bus->iommu_opaque = opaque;
 }
 
diff --git a/hw/ppc/ppc440_pcix.c b/hw/ppc/ppc440_pcix.c
index 2ee2d4f..7b17ee5 100644
--- a/hw/ppc/ppc440_pcix.c
+++ b/hw/ppc/ppc440_pcix.c
@@ -442,6 +442,10 @@ static AddressSpace *ppc440_pcix_set_iommu(PCIBus *b, void *opaque, int devfn)
     return &s->bm_as;
 }
 
+static const PCIIOMMUOps ppc440_iommu_ops = {
+    .get_address_space = ppc440_pcix_set_iommu,
+};
+
 /* The default pci_host_data_{read,write} functions in pci/pci_host.c
  * deny access to registers without bit 31 set but our clients want
  * this to work so we have to override these here */
@@ -487,7 +491,7 @@ static void ppc440_pcix_realize(DeviceState *dev, Error **errp)
     memory_region_init(&s->bm, OBJECT(s), "bm-ppc440-pcix", UINT64_MAX);
     memory_region_add_subregion(&s->bm, 0x0, &s->busmem);
     address_space_init(&s->bm_as, &s->bm, "pci-bm");
-    pci_setup_iommu(h->bus, ppc440_pcix_set_iommu, s);
+    pci_setup_iommu(h->bus, &ppc440_iommu_ops, s);
 
     memory_region_init(&s->container, OBJECT(s), "pci-container", PCI_ALL_SIZE);
     memory_region_init_io(&h->conf_mem, OBJECT(s), &pci_host_conf_le_ops,
diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
index 363cdb3..8be0584 100644
--- a/hw/ppc/spapr_pci.c
+++ b/hw/ppc/spapr_pci.c
@@ -771,6 +771,10 @@ static AddressSpace *spapr_pci_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &phb->iommu_as;
 }
 
+static const PCIIOMMUOps spapr_iommu_ops = {
+    .get_address_space = spapr_pci_dma_iommu,
+};
+
 static char *spapr_phb_vfio_get_loc_code(SpaprPhbState *sphb,  PCIDevice *pdev)
 {
     char *path = NULL, *buf = NULL, *host = NULL;
@@ -1956,7 +1960,7 @@ static void spapr_phb_realize(DeviceState *dev, Error **errp)
     memory_region_add_subregion(&sphb->iommu_root, SPAPR_PCI_MSI_WINDOW,
                                 &sphb->msiwindow);
 
-    pci_setup_iommu(bus, spapr_pci_dma_iommu, sphb);
+    pci_setup_iommu(bus, &spapr_iommu_ops, sphb);
 
     pci_bus_set_route_irq_fn(bus, spapr_route_intx_pin_to_irq);
 
diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 92146a2..9634123 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -635,6 +635,10 @@ static AddressSpace *s390_pci_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &iommu->as;
 }
 
+static const PCIIOMMUOps s390_iommu_ops = {
+    .get_address_space = s390_pci_dma_iommu,
+};
+
 static uint8_t set_ind_atomic(uint64_t ind_loc, uint8_t to_be_set)
 {
     uint8_t expected, actual;
@@ -749,7 +753,7 @@ static void s390_pcihost_realize(DeviceState *dev, Error **errp)
     b = pci_register_root_bus(dev, NULL, s390_pci_set_irq, s390_pci_map_irq,
                               NULL, get_system_memory(), get_system_io(), 0,
                               64, TYPE_PCI_BUS);
-    pci_setup_iommu(b, s390_pci_dma_iommu, s);
+    pci_setup_iommu(b, &s390_iommu_ops, s);
 
     bus = BUS(b);
     qbus_set_hotplug_handler(bus, OBJECT(dev));
@@ -909,7 +913,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
 
         pdev = PCI_DEVICE(dev);
         pci_bridge_map_irq(pb, dev->id, s390_pci_map_irq);
-        pci_setup_iommu(&pb->sec_bus, s390_pci_dma_iommu, s);
+        pci_setup_iommu(&pb->sec_bus, &s390_iommu_ops, s);
 
         qbus_set_hotplug_handler(BUS(&pb->sec_bus), OBJECT(s));
 
diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
index 5d56865..377d663 100644
--- a/hw/virtio/virtio-iommu.c
+++ b/hw/virtio/virtio-iommu.c
@@ -236,6 +236,10 @@ static AddressSpace *virtio_iommu_find_add_as(PCIBus *bus, void *opaque,
     return &sdev->as;
 }
 
+static const PCIIOMMUOps virtio_iommu_ops = {
+    .get_address_space = virtio_iommu_find_add_as,
+};
+
 static int virtio_iommu_attach(VirtIOIOMMU *s,
                                struct virtio_iommu_req_attach *req)
 {
@@ -789,7 +793,7 @@ static void virtio_iommu_device_realize(DeviceState *dev, Error **errp)
     s->as_by_busptr = g_hash_table_new_full(NULL, NULL, NULL, g_free);
 
     if (s->primary_bus) {
-        pci_setup_iommu(s->primary_bus, virtio_iommu_find_add_as, s);
+        pci_setup_iommu(s->primary_bus, &virtio_iommu_ops, s);
     } else {
         error_setg(errp, "VIRTIO-IOMMU is not attached to any PCI bus!");
     }
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index c1bf7d5..18cfba5 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -486,10 +486,14 @@ void pci_bus_get_w64_range(PCIBus *bus, Range *range);
 
 void pci_device_deassert_intx(PCIDevice *dev);
 
-typedef AddressSpace *(*PCIIOMMUFunc)(PCIBus *, void *, int);
+typedef struct PCIIOMMUOps PCIIOMMUOps;
+struct PCIIOMMUOps {
+    AddressSpace * (*get_address_space)(PCIBus *bus,
+                                void *opaque, int32_t devfn);
+};
 
 AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
-void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque);
+void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *iommu_ops, void *opaque);
 
 static inline void
 pci_set_byte(uint8_t *config, uint8_t val)
diff --git a/include/hw/pci/pci_bus.h b/include/hw/pci/pci_bus.h
index 0714f57..c281057 100644
--- a/include/hw/pci/pci_bus.h
+++ b/include/hw/pci/pci_bus.h
@@ -29,7 +29,7 @@ enum PCIBusFlags {
 struct PCIBus {
     BusState qbus;
     enum PCIBusFlags flags;
-    PCIIOMMUFunc iommu_fn;
+    const PCIIOMMUOps *iommu_ops;
     void *iommu_opaque;
     uint8_t devfn_min;
     uint32_t slot_reserved_mask;
-- 
2.7.4

