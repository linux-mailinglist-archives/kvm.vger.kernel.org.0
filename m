Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06267E334C
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502296AbfJXNBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:5208 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502314AbfJXNBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156288"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:45 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 13/22] intel_iommu: add PASID cache management infrastructure
Date:   Thu, 24 Oct 2019 08:34:34 -0400
Message-Id: <1571920483-3382-14-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a PASID cache management infrastructure based on
new added structure VTDPASIDAddressSpace, which is used to track
the PASID usage and future PASID tagged DMA address translation
support in vIOMMU.

    struct VTDPASIDAddressSpace {
        VTDBus *vtd_bus;
        uint8_t devfn;
        AddressSpace as;
        uint32_t pasid;
        IntelIOMMUState *iommu_state;
        VTDContextCacheEntry context_cache_entry;
        QLIST_ENTRY(VTDPASIDAddressSpace) next;
        VTDPASIDCacheEntry pasid_cache_entry;
    };

Ideally, a VTDPASIDAddressSpace instance is created when a PASID
is bound with a DMA AddressSpace. Intel VT-d spec requires guest
software to issue pasid cache invalidation when bind or unbind a
pasid with an address space under caching-mode. However, as
VTDPASIDAddressSpace instances also act as pasid cache in this
implementation, its creation also happens during vIOMMU PASID
tagged DMA translation. The creation in this path will not be
added in this patch since no PASID-capable emulated devices for
now.

The implementation in this patch manages VTDPASIDAddressSpace
instances per PASID+BDF (lookup and insert will use PASID and
BDF) since Intel VT-d spec allows per-BDF PASID Table. When a
guest bind a PASID with an AddressSpace, QEMU will capture the
guest pasid selective pasid cache invalidation, and allocate
remove a VTDPASIDAddressSpace instance per the invalidation
reasons:

    *) a present pasid entry moved to non-present
    *) a present pasid entry to be a present entry
    *) a non-present pasid entry moved to present

vIOMMU emulator could figure out the reason by fetching latest
guest pasid entry.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 356 +++++++++++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |  10 ++
 hw/i386/trace-events           |   1 +
 include/hw/i386/intel_iommu.h  |  36 ++++-
 4 files changed, 402 insertions(+), 1 deletion(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 90b8f6c..d8827c9 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -40,6 +40,7 @@
 #include "kvm_i386.h"
 #include "migration/vmstate.h"
 #include "trace.h"
+#include "qemu/jhash.h"
 
 /* context entry operations */
 #define VTD_CE_GET_RID2PASID(ce) \
@@ -65,6 +66,8 @@
 static void vtd_address_space_refresh_all(IntelIOMMUState *s);
 static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n);
 
+static void vtd_pasid_cache_reset(IntelIOMMUState *s);
+
 static void vtd_panic_require_caching_mode(void)
 {
     error_report("We need to set caching-mode=on for intel-iommu to enable "
@@ -276,6 +279,7 @@ static void vtd_reset_caches(IntelIOMMUState *s)
     vtd_iommu_lock(s);
     vtd_reset_iotlb_locked(s);
     vtd_reset_context_cache_locked(s);
+    vtd_pasid_cache_reset(s);
     vtd_iommu_unlock(s);
 }
 
@@ -686,6 +690,11 @@ static inline bool vtd_pe_type_check(X86IOMMUState *x86_iommu,
     return true;
 }
 
+static inline uint16_t vtd_pe_get_domain_id(VTDPASIDEntry *pe)
+{
+    return VTD_SM_PASID_ENTRY_DID((pe)->val[1]);
+}
+
 static inline bool vtd_pdire_present(VTDPASIDDirEntry *pdire)
 {
     return pdire->val & 1;
@@ -2389,19 +2398,361 @@ static bool vtd_process_iotlb_desc(IntelIOMMUState *s, VTDInvDesc *inv_desc)
     return true;
 }
 
+static inline struct pasid_key *vtd_get_pasid_key(uint32_t pasid,
+                                                  uint16_t sid)
+{
+    struct pasid_key *key = g_malloc0(sizeof(*key));
+    key->pasid = pasid;
+    key->sid = sid;
+    return key;
+}
+
+static guint vtd_pasid_as_key_hash(gconstpointer v)
+{
+    struct pasid_key *key = (struct pasid_key *)v;
+    uint32_t a, b, c;
+
+    /* Jenkins hash */
+    a = b = c = JHASH_INITVAL + sizeof(*key);
+    a += key->sid;
+    b += extract32(key->pasid, 0, 16);
+    c += extract32(key->pasid, 16, 16);
+
+    __jhash_mix(a, b, c);
+    __jhash_final(a, b, c);
+
+    return c;
+}
+
+static gboolean vtd_pasid_as_key_equal(gconstpointer v1, gconstpointer v2)
+{
+    const struct pasid_key *k1 = v1;
+    const struct pasid_key *k2 = v2;
+
+    return (k1->pasid == k2->pasid) && (k1->sid == k2->sid);
+}
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
+static inline int vtd_dev_get_pe_from_pasid(IntelIOMMUState *s,
+                                            uint8_t bus_num,
+                                            uint8_t devfn,
+                                            uint32_t pasid,
+                                            VTDPASIDEntry *pe)
+{
+    VTDContextEntry ce;
+    int ret;
+    dma_addr_t pasid_dir_base;
+
+    if (!s->root_scalable) {
+        return -VTD_FR_PASID_TABLE_INV;
+    }
+
+    ret = vtd_dev_to_context_entry(s, bus_num, devfn, &ce);
+    if (ret) {
+        return ret;
+    }
+
+    pasid_dir_base = VTD_CE_GET_PASID_DIR_TABLE(&ce);
+    ret = vtd_get_pe_from_pasid_table(s,
+                                  pasid_dir_base, pasid, pe);
+
+    return ret;
+}
+
+static bool vtd_pasid_entry_compare(VTDPASIDEntry *p1, VTDPASIDEntry *p2)
+{
+    int i = 0;
+    while (i < sizeof(*p1) / sizeof(p1->val)) {
+        if (p1->val[i] != p2->val[i]) {
+            return false;
+        }
+        i++;
+    }
+    return true;
+}
+
+/**
+ * This function is used to clear pasid_cache_gen of cached pasid
+ * entry in vtd_pasid_as instances. Caller of this function should
+ * hold iommu_lock.
+ */
+static gboolean vtd_flush_pasid(gpointer key, gpointer value,
+                                gpointer user_data)
+{
+    VTDPASIDCacheInfo *pc_info = user_data;
+    VTDPASIDAddressSpace *vtd_pasid_as = value;
+    IntelIOMMUState *s = vtd_pasid_as->iommu_state;
+    VTDPASIDCacheEntry *pc_entry = &vtd_pasid_as->pasid_cache_entry;
+    VTDBus *vtd_bus = vtd_pasid_as->vtd_bus;
+    VTDPASIDEntry pe;
+    uint16_t did;
+    uint32_t pasid;
+    uint16_t devfn;
+    gboolean remove = false;
+
+    did = vtd_pe_get_domain_id(&pc_entry->pasid_entry);
+    pasid = vtd_pasid_as->pasid;
+    devfn = vtd_pasid_as->devfn;
+
+    if (pc_entry->pasid_cache_gen &&
+        (vtd_pc_is_dom_si(pc_info) ? (pc_info->domain_id == did) : 1) &&
+        (vtd_pc_is_pasid_si(pc_info) ? (pc_info->pasid == pasid) : 1)) {
+        /*
+         * Modify pasid_cache_gen to be 0, the cached pasid entry in
+         * vtd_pasid_as instance is invalid. And vtd_pasid_as instance
+         * would be treated as invalid in QEMU scope until the pasid
+         * cache gen is updated in a new pasid binding or updated in
+         * below logic if found guest pasid entry exists.
+         */
+        remove = true;
+        pc_entry->pasid_cache_gen = 0;
+        if (vtd_bus->dev_ic[devfn]) {
+            if (!vtd_dev_get_pe_from_pasid(s,
+                      pci_bus_num(vtd_bus->bus), devfn, pasid, &pe)) {
+                /*
+                 * pasid entry exists, so keep the vtd_pasid_as, and needs
+                 * update the pasid entry cached in vtd_pasid_as. Also, if
+                 * the guest pasid entry doesn't equal to cached pasid entry
+                 * needs to issue a pasid bind to host for passthru devies.
+                 */
+                remove = false;
+                pc_entry->pasid_cache_gen = s->pasid_cache_gen;
+                if (!vtd_pasid_entry_compare(&pe, &pc_entry->pasid_entry)) {
+                    pc_entry->pasid_entry = pe;
+                    /*
+                     * TODO: when pasid-base-iotlb(piotlb) infrastructure is
+                     * ready, should invalidate QEMU piotlb togehter with this
+                     * change.
+                     */
+                }
+            }
+        }
+    }
+
+    return remove;
+}
+
 static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
 {
+    VTDPASIDCacheInfo pc_info;
+
+    trace_vtd_pasid_cache_dsi(domain_id);
+
+    pc_info.flags = VTD_PASID_CACHE_DOMSI;
+    pc_info.domain_id = domain_id;
+
+    /*
+     * Loop all existing pasid caches and update them.
+     */
+    vtd_iommu_lock(s);
+    g_hash_table_foreach_remove(s->vtd_pasid_as, vtd_flush_pasid, &pc_info);
+    vtd_iommu_unlock(s);
+
+    /*
+     * TODO: Domain selective PASID cache invalidation
+     * may be issued wrongly by programmer, to be safe,
+     * after invalidating the pasid caches, emulator
+     * needs to replay the pasid bindings by walking guest
+     * pasid dir and pasid table.
+     */
     return 0;
 }
 
+/**
+ * This function finds or adds a VTDPASIDAddressSpace for a device
+ * when it is bound to a pasid. Caller of this function should hold
+ * iommu_lock.
+ */
+static VTDPASIDAddressSpace *vtd_add_find_pasid_as(IntelIOMMUState *s,
+                                                   VTDBus *vtd_bus,
+                                                   int devfn,
+                                                   uint32_t pasid,
+                                                   bool allocate)
+{
+    struct pasid_key *key;
+    struct pasid_key *new_key;
+    VTDPASIDAddressSpace *vtd_pasid_as;
+    uint16_t sid;
+
+    sid = vtd_make_source_id(pci_bus_num(vtd_bus->bus), devfn);
+    key = vtd_get_pasid_key(pasid, sid);
+    vtd_pasid_as = g_hash_table_lookup(s->vtd_pasid_as, key);
+
+    if (!vtd_pasid_as && allocate) {
+        new_key = vtd_get_pasid_key(pasid, sid);
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
+        vtd_pasid_as = g_malloc0(sizeof(VTDPASIDAddressSpace));
+        vtd_pasid_as->iommu_state = s;
+        vtd_pasid_as->vtd_bus = vtd_bus;
+        vtd_pasid_as->devfn = devfn;
+        vtd_pasid_as->context_cache_entry.context_cache_gen = 0;
+        vtd_pasid_as->pasid = pasid;
+        vtd_pasid_as->pasid_cache_entry.pasid_cache_gen = 0;
+        g_hash_table_insert(s->vtd_pasid_as, new_key, vtd_pasid_as);
+    }
+    return vtd_pasid_as;
+}
+
+ /**
+  * This function updates the pasid entry cached in &vtd_pasid_as.
+  * Caller of this function should hold iommu_lock.
+  */
+static inline void vtd_fill_in_pe_cache(
+              VTDPASIDAddressSpace *vtd_pasid_as, VTDPASIDEntry *pe)
+{
+    IntelIOMMUState *s = vtd_pasid_as->iommu_state;
+    VTDPASIDCacheEntry *pc_entry = &vtd_pasid_as->pasid_cache_entry;
+
+    pc_entry->pasid_entry = *pe;
+    pc_entry->pasid_cache_gen = s->pasid_cache_gen;
+}
+
 static int vtd_pasid_cache_psi(IntelIOMMUState *s,
                                uint16_t domain_id, uint32_t pasid)
 {
+    VTDPASIDCacheInfo pc_info;
+    VTDPASIDEntry pe;
+    VTDBus *vtd_bus;
+    int bus_n, devfn;
+    VTDPASIDAddressSpace *vtd_pasid_as;
+    VTDIOMMUContext *vtd_ic;
+
+    pc_info.flags = VTD_PASID_CACHE_DOMSI;
+    pc_info.domain_id = domain_id;
+    pc_info.flags |= VTD_PASID_CACHE_PASIDSI;
+    pc_info.pasid = pasid;
+
+    /*
+     * Regards to a pasid selective pasid cache invalidation (PSI), it
+     * could be either cases of below:
+     * a) a present pasid entry moved to non-present
+     * b) a present pasid entry to be a present entry
+     * c) a non-present pasid entry moved to present
+     *
+     * Here the handling of a PSI is:
+     * 1) loop all the exisitng vtd_pasid_as instances to update them
+     *    according to the latest guest pasid entry in pasid table.
+     *    this will make sure affected existing vtd_pasid_as instances
+     *    cached the latest pasid entries. Also, during the loop, the
+     *    host should be notified if needed. e.g. pasid unbind or pasid
+     *    update. Should be able to cover case a) and case b).
+     *
+     * 2) loop all devices to cover case c)
+     *    However, it is not good to always loop all devices. In this
+     *    implementation. We do it in this ways:
+     *    - For devices which have VTDIOMMUContext instances, we loop
+     *      them and check if guest pasid entry exists. If yes, it is
+     *      case c), we update the pasid cache and also notify host.
+     *    - For devices which have no VTDIOMMUContext instances, it is
+     *      not necessary to create pasid cache at this phase since it
+     *      could be created when vIOMMU do DMA address translation.
+     *      This is not implemented yet since no PASID-capable emulated
+     *      devices today. If we have it in future, the pasid cache shall
+     *      be created there.
+     */
+
+    vtd_iommu_lock(s);
+    g_hash_table_foreach_remove(s->vtd_pasid_as, vtd_flush_pasid, &pc_info);
+    vtd_iommu_unlock(s);
+
+    vtd_iommu_lock(s);
+    QLIST_FOREACH(vtd_ic, &s->vtd_dev_ic_list, next) {
+        vtd_bus = vtd_ic->vtd_bus;
+        devfn = vtd_ic->devfn;
+        bus_n = pci_bus_num(vtd_bus->bus);
+
+        /* Step 1: fetch vtd_pasid_as and check if it is valid */
+        vtd_pasid_as = vtd_add_find_pasid_as(s, vtd_bus,
+                                        devfn, pasid, true);
+        if (vtd_pasid_as &&
+            (s->pasid_cache_gen ==
+             vtd_pasid_as->pasid_cache_entry.pasid_cache_gen)) {
+            /*
+             * pasid_cache_gen equals to s->pasid_cache_gen means
+             * vtd_pasid_as is valid after the above s->vtd_pasid_as
+             * updates. Thus no need for the below steps.
+             */
+            continue;
+        }
+
+        /*
+         * Step 2: vtd_pasid_as is not valid, it's potentailly a
+         * new pasid bind. Fetch guest pasid entry.
+         */
+        if (vtd_dev_get_pe_from_pasid(s, bus_n, devfn, pasid, &pe)) {
+            continue;
+        }
+
+        /*
+         * Step 3: pasid entry exists, update pasid cache
+         *
+         * Here need to check domain ID since guest pasid entry
+         * exists. What needs to do are:
+         *   - update the pc_entry in the vtd_pasid_as
+         *   - set proper pc_entry.pasid_cache_gen
+         *   - passdown the latest guest pasid entry config to host
+         *     (will be added in later patch)
+         */
+        if (domain_id == vtd_pe_get_domain_id(&pe)) {
+            vtd_fill_in_pe_cache(vtd_pasid_as, &pe);
+        }
+    }
+    vtd_iommu_unlock(s);
     return 0;
 }
 
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
 static int vtd_pasid_cache_gsi(IntelIOMMUState *s)
 {
+    trace_vtd_pasid_cache_gsi();
+
+    vtd_iommu_lock(s);
+    vtd_pasid_cache_reset(s);
+    vtd_iommu_unlock(s);
+
+    /*
+     * TODO: Global PASID cache invalidation may be
+     * issued wrongly by programmer, to be safe, after
+     * invalidating the pasid caches, emulator needs
+     * to replay the pasid bindings by walking guest
+     * pasid dir and pasid table.
+     */
     return 0;
 }
 
@@ -3660,7 +4011,9 @@ VTDIOMMUContext *vtd_find_add_ic(IntelIOMMUState *s,
         vtd_dev_ic->devfn = (uint8_t)devfn;
         vtd_dev_ic->iommu_state = s;
         iommu_context_init(&vtd_dev_ic->iommu_context);
+        QLIST_INSERT_HEAD(&s->vtd_dev_ic_list, vtd_dev_ic, next);
     }
+
     return vtd_dev_ic;
 }
 
@@ -4074,6 +4427,7 @@ static void vtd_realize(DeviceState *dev, Error **errp)
     }
 
     QLIST_INIT(&s->vtd_as_with_notifiers);
+    QLIST_INIT(&s->vtd_dev_ic_list);
     qemu_mutex_init(&s->iommu_lock);
     memset(s->vtd_as_by_bus_num, 0, sizeof(s->vtd_as_by_bus_num));
     memory_region_init_io(&s->csrmem, OBJECT(s), &vtd_mem_ops, s,
@@ -4099,6 +4453,8 @@ static void vtd_realize(DeviceState *dev, Error **errp)
                                      g_free, g_free);
     s->vtd_as_by_busptr = g_hash_table_new_full(vtd_uint64_hash, vtd_uint64_equal,
                                               g_free, g_free);
+    s->vtd_pasid_as = g_hash_table_new_full(vtd_pasid_as_key_hash,
+                                   vtd_pasid_as_key_equal, g_free, g_free);
     vtd_init(s);
     sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, Q35_HOST_BRIDGE_IOMMU_ADDR);
     pci_setup_iommu(bus, &vtd_iommu_ops, dev);
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 879211e..12873e1 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -311,6 +311,7 @@ typedef enum VTDFaultReason {
     VTD_FR_IR_SID_ERR = 0x26,   /* Invalid Source-ID */
 
     VTD_FR_PASID_TABLE_INV = 0x58,  /*Invalid PASID table entry */
+    VTD_FR_PASID_ENTRY_P = 0x59, /* The Present(P) field of pasidt-entry is 0 */
 
     /* This is not a normal fault reason. We use this to indicate some faults
      * that are not referenced by the VT-d specification.
@@ -482,6 +483,15 @@ struct VTDRootEntry {
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
index 6da8bd2..7912ae1 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -22,6 +22,7 @@ vtd_inv_qi_head(uint16_t head) "read head %d"
 vtd_inv_qi_tail(uint16_t head) "write tail %d"
 vtd_inv_qi_fetch(void) ""
 vtd_context_cache_reset(void) ""
+vtd_pasid_cache_reset(void) ""
 vtd_pasid_cache_gsi(void) ""
 vtd_pasid_cache_dsi(uint16_t domain) "Domian slective PC invalidation domain 0x%"PRIx16
 vtd_pasid_cache_psi(uint16_t domain, uint32_t pasid) "PASID slective PC invalidation domain 0x%"PRIx16" pasid 0x%"PRIx32
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 0d49480..d693f71 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -69,6 +69,8 @@ typedef union VTD_IR_MSIAddress VTD_IR_MSIAddress;
 typedef struct VTDPASIDDirEntry VTDPASIDDirEntry;
 typedef struct VTDPASIDEntry VTDPASIDEntry;
 typedef struct VTDIOMMUContext VTDIOMMUContext;
+typedef struct VTDPASIDCacheEntry VTDPASIDCacheEntry;
+typedef struct VTDPASIDAddressSpace VTDPASIDAddressSpace;
 
 /* Context-Entry */
 struct VTDContextEntry {
@@ -101,6 +103,31 @@ struct VTDPASIDEntry {
     uint64_t val[8];
 };
 
+struct pasid_key {
+    uint32_t pasid;
+    uint16_t sid;
+};
+
+struct VTDPASIDCacheEntry {
+    /*
+     * The cache entry is obsolete if
+     * pasid_cache_gen!=IntelIOMMUState.pasid_cache_gen
+     */
+    uint32_t pasid_cache_gen;
+    struct VTDPASIDEntry pasid_entry;
+};
+
+struct VTDPASIDAddressSpace {
+    VTDBus *vtd_bus;
+    uint8_t devfn;
+    AddressSpace as;
+    uint32_t pasid;
+    IntelIOMMUState *iommu_state;
+    VTDContextCacheEntry context_cache_entry;
+    QLIST_ENTRY(VTDPASIDAddressSpace) next;
+    VTDPASIDCacheEntry pasid_cache_entry;
+};
+
 struct VTDAddressSpace {
     PCIBus *bus;
     uint8_t devfn;
@@ -121,6 +148,7 @@ struct VTDIOMMUContext {
     VTDBus *vtd_bus;
     uint8_t devfn;
     IOMMUContext iommu_context;
+    QLIST_ENTRY(VTDIOMMUContext) next;
     IntelIOMMUState *iommu_state;
 };
 
@@ -269,9 +297,14 @@ struct IntelIOMMUState {
 
     GHashTable *vtd_as_by_busptr;   /* VTDBus objects indexed by PCIBus* reference */
     VTDBus *vtd_as_by_bus_num[VTD_PCI_BUS_MAX]; /* VTDBus objects indexed by bus number */
+    GHashTable *vtd_pasid_as;   /* VTDPASIDAddressSpace objects */
+    uint32_t pasid_cache_gen;   /* Should be in [1,MAX] */
     /* list of registered notifiers */
     QLIST_HEAD(, VTDAddressSpace) vtd_as_with_notifiers;
 
+    /* list of registered notifiers */
+    QLIST_HEAD(, VTDIOMMUContext) vtd_dev_ic_list;
+
     /* interrupt remapping */
     bool intr_enabled;              /* Whether guest enabled IR */
     dma_addr_t intr_root;           /* Interrupt remapping table pointer */
@@ -288,7 +321,8 @@ struct IntelIOMMUState {
 
     /*
      * Protects IOMMU states in general.  Currently it protects the
-     * per-IOMMU IOTLB cache, and context entry cache in VTDAddressSpace.
+     * per-IOMMU IOTLB cache, and context entry cache in VTDAddressSpace,
+     * and pasid cache in VTDPASIDAddressSpace.
      */
     QemuMutex iommu_lock;
 };
-- 
2.7.4

