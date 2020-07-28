Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83CA2302D0
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgG1G1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:27:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:41268 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgG1G1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:47 -0400
IronPort-SDR: n4q+6drSXm0qENjcnP9crWMy0TWLm/VvKDwlXHxaK86yhSen25OYzsM/5Tx2ctpJUFzU5TzP2I
 l213SET8ADZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="149021042"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="149021042"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:40 -0700
IronPort-SDR: W5TGVapuQnG5O9nWo9hOMQL7iMTEoGV4pfvhi1jijMfY4eMRe+rfAkD6UXCNUoIy5dIM0RA+jE
 x8kz4uAP/DTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394232888"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:39 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v9 10/25] intel_iommu: add set/unset_iommu_context callback
Date:   Mon, 27 Jul 2020 23:34:03 -0700
Message-Id: <1595918058-33392-11-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds set/unset_iommu_context() impelementation in Intel
vIOMMU. PCIe devices (VFIO case) sets HostIOMMUContext to vIOMMU as
an ack of vIOMMU's "want_nested" attribute. Thus vIOMMU could build
DMA protection based on nested paging of host IOMMU.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c         | 71 ++++++++++++++++++++++++++++++++++++++++---
 include/hw/i386/intel_iommu.h | 21 ++++++++++---
 2 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 9ad7242..4550cb9 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3359,23 +3359,33 @@ static const MemoryRegionOps vtd_mem_ir_ops = {
     },
 };
 
-VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
+/**
+ * Fetch a VTDBus instance for given PCIBus. If no existing instance,
+ * allocate one.
+ */
+static VTDBus *vtd_find_add_bus(IntelIOMMUState *s, PCIBus *bus)
 {
     uintptr_t key = (uintptr_t)bus;
     VTDBus *vtd_bus = g_hash_table_lookup(s->vtd_as_by_busptr, &key);
-    VTDAddressSpace *vtd_dev_as;
-    char name[128];
 
     if (!vtd_bus) {
         uintptr_t *new_key = g_malloc(sizeof(*new_key));
         *new_key = (uintptr_t)bus;
         /* No corresponding free() */
-        vtd_bus = g_malloc0(sizeof(VTDBus) + sizeof(VTDAddressSpace *) * \
-                            PCI_DEVFN_MAX);
+        vtd_bus = g_malloc0(sizeof(VTDBus));
         vtd_bus->bus = bus;
         g_hash_table_insert(s->vtd_as_by_busptr, new_key, vtd_bus);
     }
+    return vtd_bus;
+}
 
+VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
+{
+    VTDBus *vtd_bus;
+    VTDAddressSpace *vtd_dev_as;
+    char name[128];
+
+    vtd_bus = vtd_find_add_bus(s, bus);
     vtd_dev_as = vtd_bus->dev_as[devfn];
 
     if (!vtd_dev_as) {
@@ -3463,6 +3473,55 @@ static int vtd_dev_get_iommu_attr(PCIBus *bus, void *opaque, int32_t devfn,
     return ret;
 }
 
+static int vtd_dev_set_iommu_context(PCIBus *bus, void *opaque,
+                                     int devfn,
+                                     HostIOMMUContext *iommu_ctx)
+{
+    IntelIOMMUState *s = opaque;
+    VTDBus *vtd_bus;
+    VTDHostIOMMUContext *vtd_dev_icx;
+
+    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
+
+    vtd_bus = vtd_find_add_bus(s, bus);
+
+    vtd_iommu_lock(s);
+
+    vtd_dev_icx = vtd_bus->dev_icx[devfn];
+
+    assert(!vtd_dev_icx);
+
+    vtd_bus->dev_icx[devfn] = vtd_dev_icx =
+                    g_malloc0(sizeof(VTDHostIOMMUContext));
+    vtd_dev_icx->vtd_bus = vtd_bus;
+    vtd_dev_icx->devfn = (uint8_t)devfn;
+    vtd_dev_icx->iommu_state = s;
+    vtd_dev_icx->iommu_ctx = iommu_ctx;
+
+    vtd_iommu_unlock(s);
+
+    return 0;
+}
+
+static void vtd_dev_unset_iommu_context(PCIBus *bus, void *opaque, int devfn)
+{
+    IntelIOMMUState *s = opaque;
+    VTDBus *vtd_bus;
+    VTDHostIOMMUContext *vtd_dev_icx;
+
+    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
+
+    vtd_bus = vtd_find_add_bus(s, bus);
+
+    vtd_iommu_lock(s);
+
+    vtd_dev_icx = vtd_bus->dev_icx[devfn];
+    g_free(vtd_dev_icx);
+    vtd_bus->dev_icx[devfn] = NULL;
+
+    vtd_iommu_unlock(s);
+}
+
 static uint64_t get_naturally_aligned_size(uint64_t start,
                                            uint64_t size, int gaw)
 {
@@ -3759,6 +3818,8 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
 static PCIIOMMUOps vtd_iommu_ops = {
     .get_address_space = vtd_host_dma_iommu,
     .get_iommu_attr = vtd_dev_get_iommu_attr,
+    .set_iommu_context = vtd_dev_set_iommu_context,
+    .unset_iommu_context = vtd_dev_unset_iommu_context,
 };
 
 static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 3870052..b5fefb9 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -64,6 +64,7 @@ typedef union VTD_IR_TableEntry VTD_IR_TableEntry;
 typedef union VTD_IR_MSIAddress VTD_IR_MSIAddress;
 typedef struct VTDPASIDDirEntry VTDPASIDDirEntry;
 typedef struct VTDPASIDEntry VTDPASIDEntry;
+typedef struct VTDHostIOMMUContext VTDHostIOMMUContext;
 
 /* Context-Entry */
 struct VTDContextEntry {
@@ -112,10 +113,20 @@ struct VTDAddressSpace {
     IOVATree *iova_tree;          /* Traces mapped IOVA ranges */
 };
 
+struct VTDHostIOMMUContext {
+    VTDBus *vtd_bus;
+    uint8_t devfn;
+    HostIOMMUContext *iommu_ctx;
+    IntelIOMMUState *iommu_state;
+};
+
 struct VTDBus {
-    PCIBus* bus;		/* A reference to the bus to provide translation for */
+    /* A reference to the bus to provide translation for */
+    PCIBus *bus;
     /* A table of VTDAddressSpace objects indexed by devfn */
-    VTDAddressSpace *dev_as[];
+    VTDAddressSpace *dev_as[PCI_DEVFN_MAX];
+    /* A table of VTDHostIOMMUContext objects indexed by devfn */
+    VTDHostIOMMUContext *dev_icx[PCI_DEVFN_MAX];
 };
 
 struct VTDIOTLBEntry {
@@ -269,8 +280,10 @@ struct IntelIOMMUState {
     bool dma_drain;                 /* Whether DMA r/w draining enabled */
 
     /*
-     * Protects IOMMU states in general.  Currently it protects the
-     * per-IOMMU IOTLB cache, and context entry cache in VTDAddressSpace.
+     * iommu_lock protects below:
+     * - per-IOMMU IOTLB caches
+     * - context entry cache in VTDAddressSpace
+     * - HostIOMMUContext pointer cached in vIOMMU
      */
     QemuMutex iommu_lock;
 };
-- 
2.7.4

