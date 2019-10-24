Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B01E3346
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502282AbfJXNBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:5193 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502278AbfJXNBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156198"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:24 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 06/22] hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps
Date:   Thu, 24 Oct 2019 08:34:27 -0400
Message-Id: <1571920483-3382-7-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch modifies pci_setup_iommu() to set PCIIOMMUOps instead of only
setting PCIIOMMUFunc. PCIIOMMUFunc is previously used to get an address
space for a device in vendor specific way. The PCIIOMMUOps still offers
this functionality. Use PCIIOMMUOps leaves space to add more iommu related
vendor specific operations.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/alpha/typhoon.c       |  6 +++++-
 hw/arm/smmu-common.c     |  6 +++++-
 hw/hppa/dino.c           |  6 +++++-
 hw/i386/amd_iommu.c      |  6 +++++-
 hw/i386/intel_iommu.c    |  6 +++++-
 hw/pci-host/designware.c |  6 +++++-
 hw/pci-host/ppce500.c    |  6 +++++-
 hw/pci-host/prep.c       |  6 +++++-
 hw/pci-host/sabre.c      |  6 +++++-
 hw/pci/pci.c             | 11 ++++++-----
 hw/ppc/ppc440_pcix.c     |  6 +++++-
 hw/ppc/spapr_pci.c       |  6 +++++-
 hw/s390x/s390-pci-bus.c  |  8 ++++++--
 include/hw/pci/pci.h     |  8 ++++++--
 include/hw/pci/pci_bus.h |  2 +-
 15 files changed, 74 insertions(+), 21 deletions(-)

diff --git a/hw/alpha/typhoon.c b/hw/alpha/typhoon.c
index 179e1f7..b890771 100644
--- a/hw/alpha/typhoon.c
+++ b/hw/alpha/typhoon.c
@@ -741,6 +741,10 @@ static AddressSpace *typhoon_pci_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &s->pchip.iommu_as;
 }
 
+static const PCIIOMMUOps typhoon_iommu_ops = {
+    .get_address_space = typhoon_pci_dma_iommu,
+};
+
 static void typhoon_set_irq(void *opaque, int irq, int level)
 {
     TyphoonState *s = opaque;
@@ -901,7 +905,7 @@ PCIBus *typhoon_init(ram_addr_t ram_size, ISABus **isa_bus,
                              "iommu-typhoon", UINT64_MAX);
     address_space_init(&s->pchip.iommu_as, MEMORY_REGION(&s->pchip.iommu),
                        "pchip0-pci");
-    pci_setup_iommu(b, typhoon_pci_dma_iommu, s);
+    pci_setup_iommu(b, &typhoon_iommu_ops, s);
 
     /* Pchip0 PCI special/interrupt acknowledge, 0x801.F800.0000, 64MB.  */
     memory_region_init_io(&s->pchip.reg_iack, OBJECT(s), &alpha_pci_iack_ops,
diff --git a/hw/arm/smmu-common.c b/hw/arm/smmu-common.c
index 245817d..d668514 100644
--- a/hw/arm/smmu-common.c
+++ b/hw/arm/smmu-common.c
@@ -342,6 +342,10 @@ static AddressSpace *smmu_find_add_as(PCIBus *bus, void *opaque, int devfn)
     return &sdev->as;
 }
 
+static const PCIIOMMUOps smmu_ops = {
+    .get_address_space = smmu_find_add_as,
+};
+
 IOMMUMemoryRegion *smmu_iommu_mr(SMMUState *s, uint32_t sid)
 {
     uint8_t bus_n, devfn;
@@ -436,7 +440,7 @@ static void smmu_base_realize(DeviceState *dev, Error **errp)
     s->smmu_pcibus_by_busptr = g_hash_table_new(NULL, NULL);
 
     if (s->primary_bus) {
-        pci_setup_iommu(s->primary_bus, smmu_find_add_as, s);
+        pci_setup_iommu(s->primary_bus, &smmu_ops, s);
     } else {
         error_setg(errp, "SMMU is not attached to any PCI bus!");
     }
diff --git a/hw/hppa/dino.c b/hw/hppa/dino.c
index ab6969b..dbcff03 100644
--- a/hw/hppa/dino.c
+++ b/hw/hppa/dino.c
@@ -389,6 +389,10 @@ static AddressSpace *dino_pcihost_set_iommu(PCIBus *bus, void *opaque,
     return &s->bm_as;
 }
 
+static const PCIIOMMUOps dino_iommu_ops = {
+    .get_address_space = dino_pcihost_set_iommu,
+};
+
 /*
  * Dino interrupts are connected as shown on Page 78, Table 23
  * (Little-endian bit numbers)
@@ -508,7 +512,7 @@ PCIBus *dino_init(MemoryRegion *addr_space,
     memory_region_add_subregion(&s->bm, 0xfff00000,
                                 &s->bm_cpu_alias);
     address_space_init(&s->bm_as, &s->bm, "pci-bm");
-    pci_setup_iommu(b, dino_pcihost_set_iommu, s);
+    pci_setup_iommu(b, &dino_iommu_ops, s);
 
     *p_rtc_irq = qemu_allocate_irq(dino_set_timer_irq, s, 0);
     *p_ser_irq = qemu_allocate_irq(dino_set_serial_irq, s, 0);
diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index d372636..ba6904c 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -1451,6 +1451,10 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &iommu_as[devfn]->as;
 }
 
+static const PCIIOMMUOps amdvi_iommu_ops = {
+    .get_address_space = amdvi_host_dma_iommu,
+};
+
 static const MemoryRegionOps mmio_mem_ops = {
     .read = amdvi_mmio_read,
     .write = amdvi_mmio_write,
@@ -1576,7 +1580,7 @@ static void amdvi_realize(DeviceState *dev, Error **err)
 
     sysbus_init_mmio(SYS_BUS_DEVICE(s), &s->mmio);
     sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, AMDVI_BASE_ADDR);
-    pci_setup_iommu(bus, amdvi_host_dma_iommu, s);
+    pci_setup_iommu(bus, &amdvi_iommu_ops, s);
     s->devid = object_property_get_int(OBJECT(&s->pci), "addr", err);
     msi_init(&s->pci.dev, 0, 1, true, false, err);
     amdvi_init(s);
diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 4a1a07a..67a7836 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3666,6 +3666,10 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &vtd_as->as;
 }
 
+static PCIIOMMUOps vtd_iommu_ops = {
+    .get_address_space = vtd_host_dma_iommu,
+};
+
 static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
 {
     X86IOMMUState *x86_iommu = X86_IOMMU_DEVICE(s);
@@ -3782,7 +3786,7 @@ static void vtd_realize(DeviceState *dev, Error **errp)
                                               g_free, g_free);
     vtd_init(s);
     sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, Q35_HOST_BRIDGE_IOMMU_ADDR);
-    pci_setup_iommu(bus, vtd_host_dma_iommu, dev);
+    pci_setup_iommu(bus, &vtd_iommu_ops, dev);
     /* Pseudo address space under root PCI bus. */
     pcms->ioapic_as = vtd_host_dma_iommu(bus, s, Q35_PSEUDO_DEVFN_IOAPIC);
     qemu_add_machine_init_done_notifier(&vtd_machine_done_notify);
diff --git a/hw/pci-host/designware.c b/hw/pci-host/designware.c
index 71e9b0d..235d6af 100644
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
+    pci_setup_iommu(pci->bus, designware_iommu_ops, s);
 
     qdev_set_parent_bus(DEVICE(&s->root), BUS(pci->bus));
     qdev_init_nofail(DEVICE(&s->root));
diff --git a/hw/pci-host/ppce500.c b/hw/pci-host/ppce500.c
index 8bed8e8..0f907b0 100644
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
index 85d7ba9..f372524 100644
--- a/hw/pci-host/prep.c
+++ b/hw/pci-host/prep.c
@@ -213,6 +213,10 @@ static AddressSpace *raven_pcihost_set_iommu(PCIBus *bus, void *opaque,
     return &s->bm_as;
 }
 
+static const PCIIOMMU raven_iommu_ops = {
+    .get_address_space = raven_pcihost_set_iommu,
+};
+
 static void raven_change_gpio(void *opaque, int n, int level)
 {
     PREPPCIState *s = opaque;
@@ -303,7 +307,7 @@ static void raven_pcihost_initfn(Object *obj)
     memory_region_add_subregion(&s->bm, 0         , &s->bm_pci_memory_alias);
     memory_region_add_subregion(&s->bm, 0x80000000, &s->bm_ram_alias);
     address_space_init(&s->bm_as, &s->bm, "raven-bm");
-    pci_setup_iommu(&s->pci_bus, raven_pcihost_set_iommu, s);
+    pci_setup_iommu(&s->pci_bus, &raven_iommu_ops, s);
 
     h->bus = &s->pci_bus;
 
diff --git a/hw/pci-host/sabre.c b/hw/pci-host/sabre.c
index fae20ee..79b7565 100644
--- a/hw/pci-host/sabre.c
+++ b/hw/pci-host/sabre.c
@@ -112,6 +112,10 @@ static AddressSpace *sabre_pci_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &is->iommu_as;
 }
 
+static const PCIIOMMUOps sabre_iommu_ops = {
+    .get_address_space = sabre_pci_dma_iommu,
+};
+
 static void sabre_config_write(void *opaque, hwaddr addr,
                                uint64_t val, unsigned size)
 {
@@ -402,7 +406,7 @@ static void sabre_realize(DeviceState *dev, Error **errp)
     /* IOMMU */
     memory_region_add_subregion_overlap(&s->sabre_config, 0x200,
                     sysbus_mmio_get_region(SYS_BUS_DEVICE(s->iommu), 0), 1);
-    pci_setup_iommu(phb->bus, sabre_pci_dma_iommu, s->iommu);
+    pci_setup_iommu(phb->bus, &sabre_iommu_ops, s->iommu);
 
     /* APB secondary busses */
     pci_dev = pci_create_multifunction(phb->bus, PCI_DEVFN(1, 0), true,
diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index aa05c2b..b5ce9ca 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2615,18 +2615,19 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
     PCIBus *bus = pci_get_bus(dev);
     PCIBus *iommu_bus = bus;
 
-    while(iommu_bus && !iommu_bus->iommu_fn && iommu_bus->parent_dev) {
+    while (iommu_bus && !iommu_bus->iommu_ops && iommu_bus->parent_dev) {
         iommu_bus = pci_get_bus(iommu_bus->parent_dev);
     }
-    if (iommu_bus && iommu_bus->iommu_fn) {
-        return iommu_bus->iommu_fn(bus, iommu_bus->iommu_opaque, dev->devfn);
+    if (iommu_bus && iommu_bus->iommu_ops) {
+        return iommu_bus->iommu_ops->get_address_space(bus,
+                           iommu_bus->iommu_opaque, dev->devfn);
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
index 2ee2d4f..2c8579c 100644
--- a/hw/ppc/ppc440_pcix.c
+++ b/hw/ppc/ppc440_pcix.c
@@ -442,6 +442,10 @@ static AddressSpace *ppc440_pcix_set_iommu(PCIBus *b, void *opaque, int devfn)
     return &s->bm_as;
 }
 
+static const PCIIOMMUOps ppc440_iommu_ops = {
+    .get_adress_space = ppc440_pcix_set_iommu,
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
index 01ff41d..83cd857 100644
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
@@ -1950,7 +1954,7 @@ static void spapr_phb_realize(DeviceState *dev, Error **errp)
     memory_region_add_subregion(&sphb->iommu_root, SPAPR_PCI_MSI_WINDOW,
                                 &sphb->msiwindow);
 
-    pci_setup_iommu(bus, spapr_pci_dma_iommu, sphb);
+    pci_setup_iommu(bus, &spapr_iommu_ops, sphb);
 
     pci_bus_set_route_irq_fn(bus, spapr_route_intx_pin_to_irq);
 
diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 2d2f4a7..14684a0 100644
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
     uint8_t ind_old, ind_new;
@@ -748,7 +752,7 @@ static void s390_pcihost_realize(DeviceState *dev, Error **errp)
     b = pci_register_root_bus(dev, NULL, s390_pci_set_irq, s390_pci_map_irq,
                               NULL, get_system_memory(), get_system_io(), 0,
                               64, TYPE_PCI_BUS);
-    pci_setup_iommu(b, s390_pci_dma_iommu, s);
+    pci_setup_iommu(b, &s390_iommu_ops, s);
 
     bus = BUS(b);
     qbus_set_hotplug_handler(bus, OBJECT(dev), &local_err);
@@ -919,7 +923,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
 
         pdev = PCI_DEVICE(dev);
         pci_bridge_map_irq(pb, dev->id, s390_pci_map_irq);
-        pci_setup_iommu(&pb->sec_bus, s390_pci_dma_iommu, s);
+        pci_setup_iommu(&pb->sec_bus, &s390_iommu_ops, s);
 
         qbus_set_hotplug_handler(BUS(&pb->sec_bus), OBJECT(s), errp);
 
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index f3f0ffd..d9fed8d 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -480,10 +480,14 @@ void pci_bus_get_w64_range(PCIBus *bus, Range *range);
 
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

