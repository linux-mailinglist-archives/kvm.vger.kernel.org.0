Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39F56105B
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfGFLTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbfGFLTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355021"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:17 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 10/18] intel_iommu: tag VTDAddressSpace instance with PASID
Date:   Fri,  5 Jul 2019 19:01:43 +0800
Message-Id: <1562324511-2910-11-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces new fields in VTDAddressSpace for further PASID support
in Intel vIOMMU. In old time, each device has a VTDAddressSpace instance to
stand for its guest IOVA address space when vIOMMU is enabled. However, when
PASID is exposed to guest, device will have multiple address spaces which
are tagged with PASID. To suit this change, VTDAddressSpace should be tagged
with PASIDs in Intel vIOMMU.

To record PASID tagged VTDAddressSpaces, a hash table is introduced. The
data in the hash table can be used for future sanity check and retrieve
previous PASID configs of guest and also future emulated SVA DMA support
for emulated SVA capable devices. The lookup key is a string and its format
is as below:

"rsv%04dpasid%010dsid%06d" -- totally 32 bytes

Example: device 00:02.0 is bound to pasid 5, then its key to index
hash table is:
"rsv0000pasid0000000005sid000016"

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 166 ++++++++++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h |   9 +++
 hw/i386/trace-events           |   4 +
 include/hw/i386/intel_iommu.h  |  15 ++++
 4 files changed, 193 insertions(+), 1 deletion(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index ef13662..3b8e614 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -61,6 +61,16 @@
 static void vtd_address_space_refresh_all(IntelIOMMUState *s);
 static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n);
 
+static void hash_pasid_as_free(void *ptr);
+static inline int vtd_get_pasid_key(char *key, int key_size,
+                                   uint32_t pasid, uint16_t sid);
+static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id);
+static int vtd_pasid_cache_gsi(IntelIOMMUState *s);
+static void vtd_pasid_cache_reset(IntelIOMMUState *s);
+static int vtd_pasid_cache_psi(IntelIOMMUState *s,
+                               uint16_t domain_id,
+                               uint32_t pasid);
+
 static void vtd_define_quad(IntelIOMMUState *s, hwaddr addr, uint64_t val,
                             uint64_t wmask, uint64_t w1cmask)
 {
@@ -265,6 +275,7 @@ static void vtd_reset_caches(IntelIOMMUState *s)
     vtd_iommu_lock(s);
     vtd_reset_iotlb_locked(s);
     vtd_reset_context_cache_locked(s);
+    vtd_pasid_cache_reset(s);
     vtd_iommu_unlock(s);
 }
 
@@ -675,6 +686,11 @@ static inline bool vtd_pe_type_check(X86IOMMUState *x86_iommu,
     return true;
 }
 
+static inline uint16_t vtd_pe_get_domain_id(VTDPASIDEntry *pe)
+{
+    return VTD_SM_PASID_ENTRY_DID((pe)->val[1]);
+}
+
 static int vtd_get_pasid_dire(dma_addr_t pasid_dir_base,
                               uint32_t pasid,
                               VTDPASIDDirEntry *pdire)
@@ -2334,6 +2350,10 @@ static bool vtd_process_iotlb_desc(IntelIOMMUState *s, VTDInvDesc *inv_desc)
 static bool vtd_process_pasid_desc(IntelIOMMUState *s,
                                    VTDInvDesc *inv_desc)
 {
+    uint16_t domain_id;
+    uint32_t pasid;
+    int ret = 0;
+
     if ((inv_desc->val[0] & VTD_INV_DESC_PASIDC_RSVD_VAL0) ||
         (inv_desc->val[1] & VTD_INV_DESC_PASIDC_RSVD_VAL1) ||
         (inv_desc->val[2] & VTD_INV_DESC_PASIDC_RSVD_VAL2) ||
@@ -2343,14 +2363,20 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
         return false;
     }
 
+    domain_id = VTD_INV_DESC_PASIDC_DID(inv_desc->val[0]);
+    pasid = VTD_INV_DESC_PASIDC_PASID(inv_desc->val[0]);
+
     switch (inv_desc->val[0] & VTD_INV_DESC_PASIDC_G) {
     case VTD_INV_DESC_PASIDC_DSI:
+        ret = vtd_pasid_cache_dsi(s, domain_id);
         break;
 
     case VTD_INV_DESC_PASIDC_PASID_SI:
+        ret = vtd_pasid_cache_psi(s, domain_id, pasid);
         break;
 
     case VTD_INV_DESC_PASIDC_GLOBAL:
+        ret = vtd_pasid_cache_gsi(s);
         break;
 
     default:
@@ -2359,7 +2385,7 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
         return false;
     }
 
-    return true;
+    return (ret == 0) ? true : false;
 }
 
 static bool vtd_process_inv_iec_desc(IntelIOMMUState *s,
@@ -3523,6 +3549,142 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
     return vtd_dev_as;
 }
 
+#define VTD_PASID_CACHE_GEN_MAX       0xffffffffUL
+
+static inline bool vtd_pc_is_dom_si(struct VTDPASIDCacheInfo *pc_info)
+{
+    return pc_info->flags & VTD_PASID_CACHE_DOMSI;
+}
+
+static inline bool vtd_pc_is_pasid_si(struct VTDPASIDCacheInfo *pc_info)
+{
+    return pc_info->flags & VTD_PASID_CACHE_PASIDSI;
+}
+
+/**
+ * This function is used to clear pasid_cache_gen of cached pasid
+ * entry in vtd_pasid_as instance. Caller of this function should
+ * do explicit vtd_pasid_as instance release. e.g. call this function
+ * with g_hash_table_foreach_remove() or follow this function with
+ * a function to release vtd_pasid_as instance.
+ */
+static gboolean vtd_flush_pasid(gpointer key, gpointer value,
+                                gpointer user_data)
+{
+    VTDPASIDCacheInfo *pc_info = user_data;
+    VTDAddressSpace *vtd_pasid_as = value;
+    uint16_t did;
+    uint32_t pasid;
+
+    if (!vtd_pasid_as || !vtd_pasid_as->pasid_allocated) {
+        return false;
+    }
+
+    did = vtd_pe_get_domain_id(&(vtd_pasid_as->pasid_cache_entry.pasid_entry));
+    pasid = vtd_pasid_as->pasid;
+    if (vtd_pasid_as->pasid_cache_entry.pasid_cache_gen &&
+        (vtd_pc_is_dom_si(pc_info) ? (pc_info->domain_id == did) : 1) &&
+        (vtd_pc_is_pasid_si(pc_info) ? (pc_info->pasid == pasid) : 1)) {
+        /*
+         * Modify pasid_cache_gen to be 0, the cached pasid entry in
+         * vtd_pasid_as instance is invalid. And vtd_pasid_as instance
+         * would be treated as invalid in QEMU scope until the pasid
+         * cache gen is updated in a new pasid binding.
+         */
+        vtd_pasid_as->pasid_cache_entry.pasid_cache_gen = 0;
+        return true;
+    }
+
+    return false;
+}
+
+static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
+{
+    VTDPASIDCacheInfo pc_info;
+
+    trace_vtd_pasid_cache_dsi(domain_id);
+
+    pc_info.flags = VTD_PASID_CACHE_DOMSI;
+    pc_info.domain_id = domain_id;
+
+    /*
+     * use g_hash_table_foreach_remove(), which will free the
+     * vtd_pasid_as instances.
+     */
+    g_hash_table_foreach_remove(s->vtd_pasid_as, vtd_flush_pasid, &pc_info);
+    /*
+     * TODO: Domain selective PASID cache invalidation
+     * may be issued wrongly by programmer, to be safe,
+     * after invalidating the pasid caches, emulator
+     * needs to replay the pasid bindings by walking guest
+     * pasid dir and pasid table.
+     */
+    return 0;
+}
+
+static int vtd_pasid_cache_psi(IntelIOMMUState *s,
+                               uint16_t domain_id,
+                               uint32_t pasid)
+{
+    /*
+     * Empty in this patch, will add in next patch
+     * vtd_pasid_as instance will be created in this
+     * function
+     */
+    return 0;
+}
+
+/**
+ * Caller of this function should hold iommu_lock
+ */
+static void vtd_pasid_cache_reset(IntelIOMMUState *s)
+{
+    VTDPASIDCacheInfo pc_info;
+
+    trace_vtd_pasid_cache_reset();
+
+    pc_info.flags = 0;
+
+    /*
+     * Reset pasid cache is a big hammer, so use g_hash_table_foreach_remove
+     * which will free the vtd_pasid_as instances.
+     */
+    g_hash_table_foreach_remove(s->vtd_pasid_as, vtd_flush_pasid, &pc_info);
+    s->pasid_cache_gen = 1;
+}
+
+static int vtd_pasid_cache_gsi(IntelIOMMUState *s)
+{
+    trace_vtd_pasid_cache_gsi();
+    vtd_iommu_lock(s);
+    s->pasid_cache_gen++;
+    if (s->pasid_cache_gen == VTD_PASID_CACHE_GEN_MAX) {
+        vtd_pasid_cache_reset(s);
+    }
+    vtd_iommu_unlock(s);
+    /*
+     * TODO: Global PASID cache invalidation may be
+     * issued wrongly by programmer, to be safe, after
+     * invalidating the pasid caches, emulator needs
+     * to replay the pasid bindings by walking guest
+     * pasid dir and pasid table.
+     */
+    return 0;
+}
+
+static inline int vtd_get_pasid_key(char *key, int key_size,
+                                    uint32_t pasid, uint16_t sid)
+{
+    return snprintf(key, key_size, "rsv%04dpasid%010dsid%06d", 0, pasid, sid);
+}
+
+static void hash_pasid_as_free(void *ptr)
+{
+    VTDAddressSpace *vtd_pasid_as = (VTDAddressSpace *) ptr;
+
+    g_free(vtd_pasid_as);
+}
+
 /* Unmap the whole range in the notifier's scope. */
 static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n)
 {
@@ -3914,6 +4076,8 @@ static void vtd_realize(DeviceState *dev, Error **errp)
                                      g_free, g_free);
     s->vtd_as_by_busptr = g_hash_table_new_full(vtd_uint64_hash, vtd_uint64_equal,
                                               g_free, g_free);
+    s->vtd_pasid_as = g_hash_table_new_full(&g_str_hash, &g_str_equal,
+                                     g_free, hash_pasid_as_free);
     vtd_init(s);
     sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, Q35_HOST_BRIDGE_IOMMU_ADDR);
     pci_setup_iommu(bus, vtd_host_dma_iommu, dev);
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index e335800..bbe176f 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -473,6 +473,15 @@ struct VTDRootEntry {
 };
 typedef struct VTDRootEntry VTDRootEntry;
 
+struct VTDPASIDCacheInfo {
+#define VTD_PASID_CACHE_DOMSI   (1ULL << 0);
+#define VTD_PASID_CACHE_PASIDSI (1ULL << 1);
+    uint32_t flags;
+    uint16_t domain_id;
+    uint32_t pasid;
+};
+typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
+
 /* Masks for struct VTDRootEntry */
 #define VTD_ROOT_ENTRY_P            1ULL
 #define VTD_ROOT_ENTRY_CTP          (~0xfffULL)
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index 43c0314..7912ae1 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -22,6 +22,10 @@ vtd_inv_qi_head(uint16_t head) "read head %d"
 vtd_inv_qi_tail(uint16_t head) "write tail %d"
 vtd_inv_qi_fetch(void) ""
 vtd_context_cache_reset(void) ""
+vtd_pasid_cache_reset(void) ""
+vtd_pasid_cache_gsi(void) ""
+vtd_pasid_cache_dsi(uint16_t domain) "Domian slective PC invalidation domain 0x%"PRIx16
+vtd_pasid_cache_psi(uint16_t domain, uint32_t pasid) "PASID slective PC invalidation domain 0x%"PRIx16" pasid 0x%"PRIx32
 vtd_re_not_present(uint8_t bus) "Root entry bus %"PRIu8" not present"
 vtd_ce_not_present(uint8_t bus, uint8_t devfn) "Context entry bus %"PRIu8" devfn %"PRIu8" not present"
 vtd_iotlb_page_hit(uint16_t sid, uint64_t addr, uint64_t slpte, uint16_t domain) "IOTLB page hit sid 0x%"PRIx16" iova 0x%"PRIx64" slpte 0x%"PRIx64" domain 0x%"PRIx16
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 4b74f3d..24c8678 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -68,6 +68,7 @@ typedef union VTD_IR_TableEntry VTD_IR_TableEntry;
 typedef union VTD_IR_MSIAddress VTD_IR_MSIAddress;
 typedef struct VTDPASIDDirEntry VTDPASIDDirEntry;
 typedef struct VTDPASIDEntry VTDPASIDEntry;
+typedef struct VTDPASIDCacheEntry VTDPASIDCacheEntry;
 
 /* Context-Entry */
 struct VTDContextEntry {
@@ -100,7 +101,18 @@ struct VTDPASIDEntry {
     uint64_t val[8];
 };
 
+struct VTDPASIDCacheEntry {
+    /*
+     * The cache entry is obsolete if
+     * pasid_cache_gen!=IntelIOMMUState.pasid_cache_gen
+     */
+    uint32_t pasid_cache_gen;
+    struct VTDPASIDEntry pasid_entry;
+};
+
 struct VTDAddressSpace {
+    bool pasid_allocated;
+    uint32_t pasid;
     PCIBus *bus;
     uint8_t devfn;
     AddressSpace as;
@@ -114,6 +126,7 @@ struct VTDAddressSpace {
     /* Superset of notifier flags that this address space has */
     IOMMUNotifierFlag notifier_flags;
     IOVATree *iova_tree;          /* Traces mapped IOVA ranges */
+    VTDPASIDCacheEntry pasid_cache_entry;
 };
 
 struct VTDBus {
@@ -258,6 +271,8 @@ struct IntelIOMMUState {
 
     GHashTable *vtd_as_by_busptr;   /* VTDBus objects indexed by PCIBus* reference */
     VTDBus *vtd_as_by_bus_num[VTD_PCI_BUS_MAX]; /* VTDBus objects indexed by bus number */
+    GHashTable *vtd_pasid_as;   /* VTDAddressSpace objects indexed by pasid */
+    uint32_t pasid_cache_gen;   /* Should be in [1,MAX] */
     /* list of registered notifiers */
     QLIST_HEAD(, VTDAddressSpace) vtd_as_with_notifiers;
 
-- 
2.7.4

