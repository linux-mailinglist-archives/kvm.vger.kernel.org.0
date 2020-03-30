Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69465197310
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 06:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgC3ETj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 00:19:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:46067 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbgC3ETS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 00:19:18 -0400
IronPort-SDR: 1ZLt3Rwgglz1N6ZCVUCRxqmtL5AauS8/C+viFeqQiCVhMqkZXYxu25CZd9Otn5MxFYDBeDMykl
 Bsx71BAi9bVw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2020 21:19:16 -0700
IronPort-SDR: OybUe+OIIaTxJ5/AJtn153r7J+TcgAogiJdZ/VmBy0gdRVWIMoukEGfzJFDloOTy8XixGh0oiC
 AmlbtIUve/Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,322,1580803200"; 
   d="scan'208";a="327632029"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2020 21:19:15 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH v2 07/22] intel_iommu: add set/unset_iommu_context callback
Date:   Sun, 29 Mar 2020 21:24:46 -0700
Message-Id: <1585542301-84087-8-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds set/unset_iommu_context() impelementation in Intel
vIOMMU. For Intel platform, pass-through modules (e.g. VFIO) could
set HostIOMMUContext to Intel vIOMMU emulator.

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
index 4b22910..fd349c6 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3354,23 +3354,33 @@ static const MemoryRegionOps vtd_mem_ir_ops = {
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
@@ -3436,6 +3446,55 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
     return vtd_dev_as;
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
@@ -3731,6 +3790,8 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
 
 static PCIIOMMUOps vtd_iommu_ops = {
     .get_address_space = vtd_host_dma_iommu,
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

