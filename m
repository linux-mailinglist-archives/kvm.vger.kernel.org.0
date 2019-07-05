Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1B66105C
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfGFLTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbfGFLTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355028"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:20 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 11/18] intel_iommu: create VTDAddressSpace per BDF+PASID
Date:   Fri,  5 Jul 2019 19:01:44 +0800
Message-Id: <1562324511-2910-12-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch allocates PASID tagged VTDAddressSpace instances per
BDF+PASID. New PASID tagged VTDAddressSpace instances is allocated
when captured guest pasid selective pasid cache invalidation.

For pasid selective pasid cache invalidation from guest under Intel
VT-d caching-mode, it could be one of the below cases:

*) a non-present pasid entry moved to present
*) a present pasid entry moved to non-present
*) permission modifications, downgrade or upgrade

To check the cases, vIOMMU needs to fetch the latest guest pasid
entry and compare it with the previous stored pasid entry in PASID
tagged VTDAddressSpace instance.

TODO: vIOMMU needs to replay the pasid bindings by walking
guest pasid table for global and domain selective pasid cache
invalidation since guest OS may flush the pasid cache with
wrong granularity. e.g. has a svm_bind() but flush the pasid
cache with global or domain selective instead of pasid
selective. Actually, per spec, a global or domain selective
pasid cache invalidation should cover what a pasid selective
flush can do. In native, only concern is performance deduction
regards to a "wider" cache flush. But in virtualization, it
would be a disaster if no proper handling. So, to be safe, vIOMMU
emulator needs to do replay for the two invalidation granularity
to reflect the latest pasid bindings in guest pasid table.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 210 ++++++++++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h |   2 +
 2 files changed, 207 insertions(+), 5 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 3b8e614..cfe5dbf 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -70,6 +70,18 @@ static void vtd_pasid_cache_reset(IntelIOMMUState *s);
 static int vtd_pasid_cache_psi(IntelIOMMUState *s,
                                uint16_t domain_id,
                                uint32_t pasid);
+static VTDContextCacheEntry *vtd_find_context_cache(IntelIOMMUState *s,
+                                                    PCIBus *bus, int devfn);
+static void vtd_invalidate_pe_cache(IntelIOMMUState *s,
+                                    PCIBus *bus,
+                                    int devfn,
+                                    uint32_t pasid,
+                                    uint16_t domain_id);
+static VTDAddressSpace *vtd_add_find_pasid_as(IntelIOMMUState *s,
+                                              PCIBus *bus,
+                                              int devfn,
+                                              uint32_t pasid,
+                                              bool allocate);
 
 static void vtd_define_quad(IntelIOMMUState *s, hwaddr addr, uint64_t val,
                             uint64_t wmask, uint64_t w1cmask)
@@ -691,6 +703,11 @@ static inline uint16_t vtd_pe_get_domain_id(VTDPASIDEntry *pe)
     return VTD_SM_PASID_ENTRY_DID((pe)->val[1]);
 }
 
+static inline bool vtd_pe_present(VTDPASIDEntry *pe)
+{
+    return pe->val[0] & VTD_PASID_ENTRY_P;
+}
+
 static int vtd_get_pasid_dire(dma_addr_t pasid_dir_base,
                               uint32_t pasid,
                               VTDPASIDDirEntry *pdire)
@@ -758,6 +775,26 @@ static int vtd_get_pasid_entry_from_pasid(IntelIOMMUState *s,
     return ret;
 }
 
+static inline int vtd_ce_get_pe_from_pasid(IntelIOMMUState *s,
+                                         VTDContextEntry *ce,
+                                         uint32_t pasid,
+                                         VTDPASIDEntry *pe)
+{
+    dma_addr_t pasid_dir_base;
+    int ret;
+
+    assert(s->root_scalable);
+
+    pasid_dir_base = VTD_CE_GET_PASID_DIR_TABLE(ce);
+    ret = vtd_get_pasid_entry_from_pasid(s,
+                                  pasid_dir_base, pasid, pe);
+    if (!vtd_pe_present(pe)) {
+        return -VTD_FR_PASID_ENTRY_P;
+    }
+
+    return ret;
+}
+
 static int vtd_ce_get_rid2pasid_entry(IntelIOMMUState *s,
                                       VTDContextEntry *ce,
                                       VTDPASIDEntry *pe)
@@ -2347,6 +2384,32 @@ static bool vtd_process_iotlb_desc(IntelIOMMUState *s, VTDInvDesc *inv_desc)
     return true;
 }
 
+VTDContextCacheEntry *vtd_find_context_cache(IntelIOMMUState *s,
+                                          PCIBus *bus, int devfn)
+{
+    uintptr_t key = (uintptr_t)bus;
+    VTDBus *vtd_bus = g_hash_table_lookup(s->vtd_as_by_busptr, &key);
+    VTDAddressSpace *vtd_dev_as;
+    VTDContextCacheEntry *cc_entry;
+
+    if (!vtd_bus) {
+        return NULL;
+    }
+
+    vtd_dev_as = vtd_bus->dev_as[devfn];
+    if (!vtd_dev_as) {
+        return NULL;
+    }
+
+    cc_entry = &vtd_dev_as->context_cache_entry;
+    if (s->context_cache_gen &&
+        cc_entry->context_cache_gen == s->context_cache_gen) {
+        return cc_entry;
+    } else {
+        return NULL;
+    }
+}
+
 static bool vtd_process_pasid_desc(IntelIOMMUState *s,
                                    VTDInvDesc *inv_desc)
 {
@@ -3622,15 +3685,152 @@ static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
     return 0;
 }
 
+static void vtd_release_pasid_as(IntelIOMMUState *s,
+                                 PCIBus *bus,
+                                 int devfn,
+                                 uint32_t pasid)
+{
+    char key[32];
+    uint16_t sid;
+
+    sid = vtd_make_source_id(pci_bus_num(bus), devfn);
+    vtd_get_pasid_key(&key[0], 32, pasid, sid);
+    g_hash_table_remove(s->vtd_pasid_as, &key[0]);
+}
+
+static void vtd_invalidate_pe_cache(IntelIOMMUState *s,
+                                    PCIBus *bus,
+                                    int devfn,
+                                    uint32_t pasid,
+                                    uint16_t domain_id)
+{
+    VTDAddressSpace *vtd_pasid_as = NULL;
+    VTDPASIDCacheInfo pc_info;
+
+    pc_info.flags = VTD_PASID_CACHE_DOMSI;
+    pc_info.domain_id = domain_id;
+    pc_info.flags |= VTD_PASID_CACHE_PASIDSI;
+    pc_info.pasid = pasid;
+
+    vtd_pasid_as = vtd_add_find_pasid_as(s, bus, devfn, pasid, false);
+
+    vtd_flush_pasid(NULL, vtd_pasid_as, &pc_info);
+    vtd_release_pasid_as(s, bus, devfn, pasid);
+}
+
+/**
+ * This function finds or adds a VTDAddressSpace for a device when
+ * it is bound to a pasid
+ */
+static VTDAddressSpace *vtd_add_find_pasid_as(IntelIOMMUState *s,
+                                              PCIBus *bus,
+                                              int devfn,
+                                              uint32_t pasid,
+                                              bool allocate)
+{
+    char key[32];
+    char *new_key;
+    VTDAddressSpace *vtd_pasid_as;
+    uint16_t sid;
+
+    sid = vtd_make_source_id(pci_bus_num(bus), devfn);
+    vtd_get_pasid_key(&key[0], 32, pasid, sid);
+    vtd_pasid_as = g_hash_table_lookup(s->vtd_pasid_as, &key[0]);
+
+    if (!vtd_pasid_as && allocate) {
+        new_key = g_malloc(32);
+        vtd_get_pasid_key(&new_key[0], 32, pasid, sid);
+        /*
+         * Initiate the vtd_pasid_as structure.
+         *
+         * This structure here is used to track the guest pasid
+         * binding and also serves as pasid-cache mangement entry.
+         *
+         * TODO: in future, if wants to support the SVA-aware DMA
+         *       emulation, the vtd_pasid_as should be fully initialized.
+         *       e.g. the address_space and memory region fields.
+         */
+        vtd_pasid_as = g_malloc0(sizeof(VTDAddressSpace));
+        vtd_pasid_as->iommu_state = s;
+        vtd_pasid_as->bus = bus;
+        vtd_pasid_as->devfn = devfn;
+        vtd_pasid_as->context_cache_entry.context_cache_gen = 0;
+        vtd_pasid_as->pasid = pasid;
+        vtd_pasid_as->pasid_allocated = true;
+        vtd_pasid_as->pasid_cache_entry.pasid_cache_gen = 0;
+        g_hash_table_insert(s->vtd_pasid_as, new_key, vtd_pasid_as);
+    }
+    return vtd_pasid_as;
+}
+
 static int vtd_pasid_cache_psi(IntelIOMMUState *s,
                                uint16_t domain_id,
                                uint32_t pasid)
 {
-    /*
-     * Empty in this patch, will add in next patch
-     * vtd_pasid_as instance will be created in this
-     * function
-     */
+    VTDAddressSpace *vtd_pasid_as;
+    VTDContextEntry ce;
+    VTDPASIDEntry pe;
+    PCIBus *bus;
+    int bus_n, devfn;
+    VTDContextCacheEntry *cc_entry = NULL;
+    VTDPASIDCacheEntry *pc_entry = NULL;
+
+    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
+        bus = vtd_find_pci_bus_from_bus_num(s, bus_n);
+        if (!bus) {
+            continue;
+        }
+        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
+            /* Step 1: fetch guest context entry */
+            if (vtd_dev_to_context_entry(s, bus_n, devfn, &ce)) {
+                /* guest context entry does not exist, flush cache */
+                cc_entry = vtd_find_context_cache(s, bus, devfn);
+                if (cc_entry) {
+                    cc_entry->context_cache_gen = 0;
+                    vtd_invalidate_pe_cache(s, bus,
+                                          devfn, pasid, domain_id);
+                }
+                /*
+                 * neither guest context entry exists nor context cache
+                 * exists, this pasid flush has nothing to do with this
+                 * devfn in this loop, just go to next devfn
+                 */
+                continue;
+            }
+
+            /* Step 2: fetch guest pasid entry */
+            if (vtd_ce_get_pe_from_pasid(s, &ce, pasid, &pe)) {
+                /* guest PASID entry does not exist, flush cache */
+                vtd_invalidate_pe_cache(s, bus,
+                                       devfn, pasid, domain_id);
+                continue;
+            }
+
+            /*
+             * Step 3: pasid entry exists, check if domain Id suits
+             *
+             * Here no need to check domain ID since guest pasid entry
+             * exists. What needs to do are:
+             *   - create a new vtd_pasid_as or fetch an existed one
+             *   - update the pc_entry in the vtd_pasid_as
+             *   - set proper pc_entry.pasid_cache_gen
+             *   - passdown the latest guest pasid entry config to host
+             * with the above operations, vIOMMU could ensure the pasid
+             * cache in vIOMMU device model reflects the latest guest
+             * pasid entry config, and also the host also uses the
+             * latest guest pasid entry config.
+             */
+            vtd_pasid_as = vtd_add_find_pasid_as(s, bus,
+                                             devfn, pasid, true);
+            if (!vtd_pasid_as) {
+                printf("%s, fatal error happened!\n", __func__);
+                continue;
+            }
+            pc_entry = &vtd_pasid_as->pasid_cache_entry;
+            pc_entry->pasid_entry = pe; /* update pasid cache */
+            pc_entry->pasid_cache_gen = s->pasid_cache_gen;
+        }
+    }
     return 0;
 }
 
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index bbe176f..afeb6aa 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -310,6 +310,7 @@ typedef enum VTDFaultReason {
     VTD_FR_IR_SID_ERR = 0x26,   /* Invalid Source-ID */
 
     VTD_FR_PASID_TABLE_INV = 0x58,  /*Invalid PASID table entry */
+    VTD_FR_PASID_ENTRY_P = 0x59, /* The Present(P) field of pasidt-entry is 0 */
 
     /* This is not a normal fault reason. We use this to indicate some faults
      * that are not referenced by the VT-d specification.
@@ -529,6 +530,7 @@ typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 #define VTD_PASID_ENTRY_FPD           (1ULL << 1) /* Fault Processing Disable */
 
 /* PASID Granular Translation Type Mask */
+#define VTD_PASID_ENTRY_P              1ULL
 #define VTD_SM_PASID_ENTRY_PGTT        (7ULL << 6)
 #define VTD_SM_PASID_ENTRY_FLT         (1ULL << 6)
 #define VTD_SM_PASID_ENTRY_SLT         (2ULL << 6)
-- 
2.7.4

