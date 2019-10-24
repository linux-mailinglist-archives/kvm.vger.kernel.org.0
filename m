Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A7E334A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502303AbfJXNBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:5203 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502284AbfJXNBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156218"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:30 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 08/22] intel_iommu: provide get_iommu_context() callback
Date:   Thu, 24 Oct 2019 08:34:29 -0400
Message-Id: <1571920483-3382-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds get_iommu_context() callback to return an iommu_context
Intel VT-d platform.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c         | 57 ++++++++++++++++++++++++++++++++++++++-----
 include/hw/i386/intel_iommu.h | 14 ++++++++++-
 2 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 67a7836..e9f8692 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3288,22 +3288,33 @@ static const MemoryRegionOps vtd_mem_ir_ops = {
     },
 };
 
-VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
+static VTDBus *vtd_find_add_bus(IntelIOMMUState *s, PCIBus *bus)
 {
     uintptr_t key = (uintptr_t)bus;
-    VTDBus *vtd_bus = g_hash_table_lookup(s->vtd_as_by_busptr, &key);
-    VTDAddressSpace *vtd_dev_as;
-    char name[128];
+    VTDBus *vtd_bus;
 
+    vtd_iommu_lock(s);
+    vtd_bus = g_hash_table_lookup(s->vtd_as_by_busptr, &key);
     if (!vtd_bus) {
         uintptr_t *new_key = g_malloc(sizeof(*new_key));
         *new_key = (uintptr_t)bus;
         /* No corresponding free() */
-        vtd_bus = g_malloc0(sizeof(VTDBus) + sizeof(VTDAddressSpace *) * \
-                            PCI_DEVFN_MAX);
+        vtd_bus = g_malloc0(sizeof(VTDBus) + PCI_DEVFN_MAX * \
+                    (sizeof(VTDAddressSpace *) + sizeof(VTDIOMMUContext *)));
         vtd_bus->bus = bus;
         g_hash_table_insert(s->vtd_as_by_busptr, new_key, vtd_bus);
     }
+    vtd_iommu_unlock(s);
+    return vtd_bus;
+}
+
+VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
+{
+    VTDBus *vtd_bus;
+    VTDAddressSpace *vtd_dev_as;
+    char name[128];
+
+    vtd_bus = vtd_find_add_bus(s, bus);
 
     vtd_dev_as = vtd_bus->dev_as[devfn];
 
@@ -3370,6 +3381,27 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
     return vtd_dev_as;
 }
 
+VTDIOMMUContext *vtd_find_add_ic(IntelIOMMUState *s,
+                                 PCIBus *bus, int devfn)
+{
+    VTDBus *vtd_bus;
+    VTDIOMMUContext *vtd_dev_ic;
+
+    vtd_bus = vtd_find_add_bus(s, bus);
+
+    vtd_dev_ic = vtd_bus->dev_ic[devfn];
+
+    if (!vtd_dev_ic) {
+        vtd_bus->dev_ic[devfn] = vtd_dev_ic =
+                    g_malloc0(sizeof(VTDIOMMUContext));
+        vtd_dev_ic->vtd_bus = vtd_bus;
+        vtd_dev_ic->devfn = (uint8_t)devfn;
+        vtd_dev_ic->iommu_state = s;
+        iommu_context_init(&vtd_dev_ic->iommu_context);
+    }
+    return vtd_dev_ic;
+}
+
 static uint64_t get_naturally_aligned_size(uint64_t start,
                                            uint64_t size, int gaw)
 {
@@ -3666,8 +3698,21 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     return &vtd_as->as;
 }
 
+static IOMMUContext *vtd_dev_iommu_context(PCIBus *bus,
+                                           void *opaque, int devfn)
+{
+    IntelIOMMUState *s = opaque;
+    VTDIOMMUContext *vtd_ic;
+
+    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
+
+    vtd_ic = vtd_find_add_ic(s, bus, devfn);
+    return &vtd_ic->iommu_context;
+}
+
 static PCIIOMMUOps vtd_iommu_ops = {
     .get_address_space = vtd_host_dma_iommu,
+    .get_iommu_context = vtd_dev_iommu_context,
 };
 
 static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 6062588..1c580c1 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -68,6 +68,7 @@ typedef union VTD_IR_TableEntry VTD_IR_TableEntry;
 typedef union VTD_IR_MSIAddress VTD_IR_MSIAddress;
 typedef struct VTDPASIDDirEntry VTDPASIDDirEntry;
 typedef struct VTDPASIDEntry VTDPASIDEntry;
+typedef struct VTDIOMMUContext VTDIOMMUContext;
 
 /* Context-Entry */
 struct VTDContextEntry {
@@ -116,9 +117,19 @@ struct VTDAddressSpace {
     IOVATree *iova_tree;          /* Traces mapped IOVA ranges */
 };
 
+struct VTDIOMMUContext {
+    VTDBus *vtd_bus;
+    uint8_t devfn;
+    IOMMUContext iommu_context;
+    IntelIOMMUState *iommu_state;
+};
+
 struct VTDBus {
     PCIBus* bus;		/* A reference to the bus to provide translation for */
-    VTDAddressSpace *dev_as[0];	/* A table of VTDAddressSpace objects indexed by devfn */
+    /* A table of VTDAddressSpace objects indexed by devfn */
+    VTDAddressSpace *dev_as[PCI_DEVFN_MAX];
+    /* A table of VTDIOMMUContext objects indexed by devfn */
+    VTDIOMMUContext *dev_ic[PCI_DEVFN_MAX];
 };
 
 struct VTDIOTLBEntry {
@@ -282,5 +293,6 @@ struct IntelIOMMUState {
  * create a new one if none exists
  */
 VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn);
+VTDIOMMUContext *vtd_find_add_ic(IntelIOMMUState *s, PCIBus *bus, int devfn);
 
 #endif
-- 
2.7.4

