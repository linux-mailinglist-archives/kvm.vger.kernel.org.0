Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404842302D8
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgG1G2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:28:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:41268 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbgG1G2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:28:01 -0400
IronPort-SDR: DQJYQEdTDODDrfJfG39eWn+p+mjafMBIwyBrTr4xDX/phiQktn5u7jeNSVR56z6DXch7RD4nKR
 o/k/WqLHAZVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="149021054"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="149021054"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:48 -0700
IronPort-SDR: Lmn930Xp/S71xQwKlSJuEDyatSv4SsBRHasIw+YV5rmJfyRGy4nEOWYHixw+4SxohUapVcGyUF
 lI8ZKoB8Npkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394232971"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:46 -0700
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
Subject: [RFC v9 15/25] intel_iommu: add PASID cache management infrastructure
Date:   Mon, 27 Jul 2020 23:34:08 -0700
Message-Id: <1595918058-33392-16-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
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
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
rfcv4 (v1) -> rfcv5 (v2):
*) merged this patch with former replay binding patch, makes
   PSI/DSI/GSI use the unified function to do cache invalidation
   and pasid binding replay.
*) dropped pasid_cache_gen in both iommu_state and vtd_pasid_as
   as it is not necessary so far, we may want it when one day
   initroduce emulated SVA-capable device.
---
 hw/i386/intel_iommu.c          | 464 +++++++++++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |  21 ++
 hw/i386/trace-events           |   1 +
 include/hw/i386/intel_iommu.h  |  24 +++
 4 files changed, 510 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 7efa98c..9b35092 100644
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
 
@@ -686,6 +690,16 @@ static inline bool vtd_pe_type_check(X86IOMMUState *x86_iommu,
     return true;
 }
 
+static inline uint16_t vtd_pe_get_domain_id(VTDPASIDEntry *pe)
+{
+    return VTD_SM_PASID_ENTRY_DID((pe)->val[1]);
+}
+
+static inline uint32_t vtd_sm_ce_get_pdt_entry_num(VTDContextEntry *ce)
+{
+    return 1U << (VTD_SM_CONTEXT_ENTRY_PDTS(ce->val[0]) + 7);
+}
+
 static inline bool vtd_pdire_present(VTDPASIDDirEntry *pdire)
 {
     return pdire->val & 1;
@@ -2395,9 +2409,443 @@ static bool vtd_process_iotlb_desc(IntelIOMMUState *s, VTDInvDesc *inv_desc)
     return true;
 }
 
+static inline void vtd_init_pasid_key(uint32_t pasid,
+                                     uint16_t sid,
+                                     struct pasid_key *key)
+{
+    key->pasid = pasid;
+    key->sid = sid;
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
+    return !memcmp(p1, p2, sizeof(*p1));
+}
+
+/**
+ * This function fills in the pasid entry in &vtd_pasid_as. Caller
+ * of this function should hold iommu_lock.
+ */
+static void vtd_fill_pe_in_cache(IntelIOMMUState *s,
+                                 VTDPASIDAddressSpace *vtd_pasid_as,
+                                 VTDPASIDEntry *pe)
+{
+    VTDPASIDCacheEntry *pc_entry = &vtd_pasid_as->pasid_cache_entry;
+
+    if (vtd_pasid_entry_compare(pe, &pc_entry->pasid_entry)) {
+        /* No need to go further as cached pasid entry is latest */
+        return;
+    }
+
+    pc_entry->pasid_entry = *pe;
+    /*
+     * TODO:
+     * - send pasid bind to host for passthru devices
+     */
+}
+
+/**
+ * This function is used to clear cached pasid entry in vtd_pasid_as
+ * instances. Caller of this function should hold iommu_lock.
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
+    int ret;
+
+    did = vtd_pe_get_domain_id(&pc_entry->pasid_entry);
+    pasid = vtd_pasid_as->pasid;
+    devfn = vtd_pasid_as->devfn;
+
+    switch (pc_info->type) {
+    case VTD_PASID_CACHE_FORCE_RESET:
+        goto remove;
+    case VTD_PASID_CACHE_PASIDSI:
+        if (pc_info->pasid != pasid) {
+            return false;
+        }
+        /* Fall through */
+    case VTD_PASID_CACHE_DOMSI:
+        if (pc_info->domain_id != did) {
+            return false;
+        }
+        /* Fall through */
+    case VTD_PASID_CACHE_GLOBAL_INV:
+        break;
+    default:
+        error_report("invalid pc_info->type");
+        abort();
+    }
+
+    /*
+     * pasid cache invalidation may indicate a present pasid
+     * entry to present pasid entry modification. To cover such
+     * case, vIOMMU emulator needs to fetch latest guest pasid
+     * entry and check cached pasid entry, then update pasid
+     * cache and send pasid bind/unbind to host properly.
+     */
+    ret = vtd_dev_get_pe_from_pasid(s, pci_bus_num(vtd_bus->bus),
+                                    devfn, pasid, &pe);
+    if (ret) {
+        /*
+         * No valid pasid entry in guest memory. e.g. pasid entry
+         * was modified to be either all-zero or non-present. Either
+         * case means existing pasid cache should be removed.
+         */
+        goto remove;
+    }
+
+    vtd_fill_pe_in_cache(s, vtd_pasid_as, &pe);
+    /*
+     * TODO:
+     * - when pasid-base-iotlb(piotlb) infrastructure is ready,
+     *   should invalidate QEMU piotlb togehter with this change.
+     */
+    return false;
+remove:
+    /*
+     * TODO:
+     * - send pasid bind to host for passthru devices
+     * - when pasid-base-iotlb(piotlb) infrastructure is ready,
+     *   should invalidate QEMU piotlb togehter with this change.
+     */
+    return true;
+}
+
+/**
+ * This function finds or adds a VTDPASIDAddressSpace for a device
+ * when it is bound to a pasid. Caller of this function should hold
+ * iommu_lock.
+ */
+static VTDPASIDAddressSpace *vtd_add_find_pasid_as(IntelIOMMUState *s,
+                                                   VTDBus *vtd_bus,
+                                                   int devfn,
+                                                   uint32_t pasid)
+{
+    struct pasid_key key;
+    struct pasid_key *new_key;
+    VTDPASIDAddressSpace *vtd_pasid_as;
+    uint16_t sid;
+
+    sid = vtd_make_source_id(pci_bus_num(vtd_bus->bus), devfn);
+    vtd_init_pasid_key(pasid, sid, &key);
+    vtd_pasid_as = g_hash_table_lookup(s->vtd_pasid_as, &key);
+
+    if (!vtd_pasid_as) {
+        new_key = g_malloc0(sizeof(*new_key));
+        vtd_init_pasid_key(pasid, sid, new_key);
+        /*
+         * Initiate the vtd_pasid_as structure.
+         *
+         * This structure here is used to track the guest pasid
+         * binding and also serves as pasid-cache mangement entry.
+         *
+         * TODO: in future, if wants to support the SVA-aware DMA
+         *       emulation, the vtd_pasid_as should have include
+         *       AddressSpace to support DMA emulation.
+         */
+        vtd_pasid_as = g_malloc0(sizeof(VTDPASIDAddressSpace));
+        vtd_pasid_as->iommu_state = s;
+        vtd_pasid_as->vtd_bus = vtd_bus;
+        vtd_pasid_as->devfn = devfn;
+        vtd_pasid_as->pasid = pasid;
+        g_hash_table_insert(s->vtd_pasid_as, new_key, vtd_pasid_as);
+    }
+    return vtd_pasid_as;
+}
+
+/**
+ * Caller of this function should hold iommu_lock.
+ */
+static void vtd_sm_pasid_table_walk_one(IntelIOMMUState *s,
+                                        dma_addr_t pt_base,
+                                        int start,
+                                        int end,
+                                        VTDPASIDCacheInfo *info)
+{
+    VTDPASIDEntry pe;
+    int pasid = start;
+    int pasid_next;
+    VTDPASIDAddressSpace *vtd_pasid_as;
+
+    while (pasid < end) {
+        pasid_next = pasid + 1;
+
+        if (!vtd_get_pe_in_pasid_leaf_table(s, pasid, pt_base, &pe)
+            && vtd_pe_present(&pe)) {
+            vtd_pasid_as = vtd_add_find_pasid_as(s,
+                                       info->vtd_bus, info->devfn, pasid);
+            if ((info->type == VTD_PASID_CACHE_DOMSI ||
+                 info->type == VTD_PASID_CACHE_PASIDSI) &&
+                !(info->domain_id == vtd_pe_get_domain_id(&pe))) {
+                /*
+                 * VTD_PASID_CACHE_DOMSI and VTD_PASID_CACHE_PASIDSI
+                 * requires domain ID check. If domain Id check fail,
+                 * go to next pasid.
+                 */
+                pasid = pasid_next;
+                continue;
+            }
+            vtd_fill_pe_in_cache(s, vtd_pasid_as, &pe);
+        }
+        pasid = pasid_next;
+    }
+}
+
+/*
+ * Currently, VT-d scalable mode pasid table is a two level table,
+ * this function aims to loop a range of PASIDs in a given pasid
+ * table to identify the pasid config in guest.
+ * Caller of this function should hold iommu_lock.
+ */
+static void vtd_sm_pasid_table_walk(IntelIOMMUState *s,
+                                    dma_addr_t pdt_base,
+                                    int start,
+                                    int end,
+                                    VTDPASIDCacheInfo *info)
+{
+    VTDPASIDDirEntry pdire;
+    int pasid = start;
+    int pasid_next;
+    dma_addr_t pt_base;
+
+    while (pasid < end) {
+        pasid_next = ((end - pasid) > VTD_PASID_TBL_ENTRY_NUM) ?
+                      (pasid + VTD_PASID_TBL_ENTRY_NUM) : end;
+        if (!vtd_get_pdire_from_pdir_table(pdt_base, pasid, &pdire)
+            && vtd_pdire_present(&pdire)) {
+            pt_base = pdire.val & VTD_PASID_TABLE_BASE_ADDR_MASK;
+            vtd_sm_pasid_table_walk_one(s, pt_base, pasid, pasid_next, info);
+        }
+        pasid = pasid_next;
+    }
+}
+
+static void vtd_replay_pasid_bind_for_dev(IntelIOMMUState *s,
+                                          int start, int end,
+                                          VTDPASIDCacheInfo *info)
+{
+    VTDContextEntry ce;
+    int bus_n, devfn;
+
+    bus_n = pci_bus_num(info->vtd_bus->bus);
+    devfn = info->devfn;
+
+    if (!vtd_dev_to_context_entry(s, bus_n, devfn, &ce)) {
+        uint32_t max_pasid;
+
+        max_pasid = vtd_sm_ce_get_pdt_entry_num(&ce) * VTD_PASID_TBL_ENTRY_NUM;
+        if (end > max_pasid) {
+            end = max_pasid;
+        }
+        vtd_sm_pasid_table_walk(s,
+                                VTD_CE_GET_PASID_DIR_TABLE(&ce),
+                                start,
+                                end,
+                                info);
+    }
+}
+
+/**
+ * This function replay the guest pasid bindings to hots by
+ * walking the guest PASID table. This ensures host will have
+ * latest guest pasid bindings. Caller should hold iommu_lock.
+ */
+static void vtd_replay_guest_pasid_bindings(IntelIOMMUState *s,
+                                            VTDPASIDCacheInfo *pc_info)
+{
+    VTDHostIOMMUContext *vtd_dev_icx;
+    int start = 0, end = VTD_HPASID_MAX;
+    VTDPASIDCacheInfo walk_info;
+
+    switch (pc_info->type) {
+    case VTD_PASID_CACHE_PASIDSI:
+        start = pc_info->pasid;
+        end = pc_info->pasid + 1;
+        /*
+         * PASID selective invalidation is within domain,
+         * thus fall through.
+         */
+    case VTD_PASID_CACHE_DOMSI:
+    case VTD_PASID_CACHE_GLOBAL_INV:
+        /* loop all assigned devices */
+        break;
+    case VTD_PASID_CACHE_FORCE_RESET:
+        /* For force reset, no need to go further replay */
+        return;
+    default:
+        error_report("invalid pc_info->type for replay");
+        abort();
+    }
+
+    /*
+     * In this replay, only needs to care about the devices which
+     * are backed by host IOMMU. For such devices, their vtd_dev_icx
+     * instances are in the s->vtd_dev_icx_list. For devices which
+     * are not backed byhost IOMMU, it is not necessary to replay
+     * the bindings since their cache could be re-created in the future
+     * DMA address transaltion.
+     */
+    walk_info = *pc_info;
+    QLIST_FOREACH(vtd_dev_icx, &s->vtd_dev_icx_list, next) {
+        /* vtd_bus|devfn fields are not identical with pc_info */
+        walk_info.vtd_bus = vtd_dev_icx->vtd_bus;
+        walk_info.devfn = vtd_dev_icx->devfn;
+        vtd_replay_pasid_bind_for_dev(s, start, end, &walk_info);
+    }
+}
+
+/**
+ * This function syncs the pasid bindings between guest and host.
+ * It includes updating the pasid cache in vIOMMU and updating the
+ * pasid bindings per guest's latest pasid entry presence.
+ */
+static void vtd_pasid_cache_sync(IntelIOMMUState *s,
+                                 VTDPASIDCacheInfo *pc_info)
+{
+    /*
+     * Regards to a pasid cache invalidation, e.g. a PSI.
+     * it could be either cases of below:
+     * a) a present pasid entry moved to non-present
+     * b) a present pasid entry to be a present entry
+     * c) a non-present pasid entry moved to present
+     *
+     * Different invalidation granularity may affect different device
+     * scope and pasid scope. But for each invalidation granularity,
+     * it needs to do two steps to sync host and guest pasid binding.
+     *
+     * Here is the handling of a PSI:
+     * 1) loop all the existing vtd_pasid_as instances to update them
+     *    according to the latest guest pasid entry in pasid table.
+     *    this will make sure affected existing vtd_pasid_as instances
+     *    cached the latest pasid entries. Also, during the loop, the
+     *    host should be notified if needed. e.g. pasid unbind or pasid
+     *    update. Should be able to cover case a) and case b).
+     *
+     * 2) loop all devices to cover case c)
+     *    - For devices which have HostIOMMUContext instances,
+     *      we loop them and check if guest pasid entry exists. If yes,
+     *      it is case c), we update the pasid cache and also notify
+     *      host.
+     *    - For devices which have no HostIOMMUContext, it is not
+     *      necessary to create pasid cache at this phase since it
+     *      could be created when vIOMMU does DMA address translation.
+     *      This is not yet implemented since there is no emulated
+     *      pasid-capable devices today. If we have such devices in
+     *      future, the pasid cache shall be created there.
+     * Other granularity follow the same steps, just with different scope
+     *
+     */
+
+    vtd_iommu_lock(s);
+    /* Step 1: loop all the exisitng vtd_pasid_as instances */
+    g_hash_table_foreach_remove(s->vtd_pasid_as,
+                                vtd_flush_pasid, pc_info);
+
+    /*
+     * Step 2: loop all the exisitng vtd_dev_icx instances.
+     * Ideally, needs to loop all devices to find if there is any new
+     * PASID binding regards to the PASID cache invalidation request.
+     * But it is enough to loop the devices which are backed by host
+     * IOMMU. For devices backed by vIOMMU (a.k.a emulated devices),
+     * if new PASID happened on them, their vtd_pasid_as instance could
+     * be created during future vIOMMU DMA translation.
+     */
+    vtd_replay_guest_pasid_bindings(s, pc_info);
+    vtd_iommu_unlock(s);
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
+    pc_info.type = VTD_PASID_CACHE_FORCE_RESET;
+
+    /*
+     * Reset pasid cache is a big hammer, so use
+     * g_hash_table_foreach_remove which will free
+     * the vtd_pasid_as instances. Also, as a big
+     * hammer, use VTD_PASID_CACHE_FORCE_RESET to
+     * ensure all the vtd_pasid_as instances are
+     * dropped, meanwhile the change will be pass
+     * to host if HostIOMMUContext is available.
+     */
+    g_hash_table_foreach_remove(s->vtd_pasid_as,
+                                vtd_flush_pasid, &pc_info);
+}
+
 static bool vtd_process_pasid_desc(IntelIOMMUState *s,
                                    VTDInvDesc *inv_desc)
 {
+    uint16_t domain_id;
+    uint32_t pasid;
+    VTDPASIDCacheInfo pc_info;
+
     if ((inv_desc->val[0] & VTD_INV_DESC_PASIDC_RSVD_VAL0) ||
         (inv_desc->val[1] & VTD_INV_DESC_PASIDC_RSVD_VAL1) ||
         (inv_desc->val[2] & VTD_INV_DESC_PASIDC_RSVD_VAL2) ||
@@ -2407,14 +2855,26 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
         return false;
     }
 
+    domain_id = VTD_INV_DESC_PASIDC_DID(inv_desc->val[0]);
+    pasid = VTD_INV_DESC_PASIDC_PASID(inv_desc->val[0]);
+
     switch (inv_desc->val[0] & VTD_INV_DESC_PASIDC_G) {
     case VTD_INV_DESC_PASIDC_DSI:
+        trace_vtd_pasid_cache_dsi(domain_id);
+        pc_info.type = VTD_PASID_CACHE_DOMSI;
+        pc_info.domain_id = domain_id;
         break;
 
     case VTD_INV_DESC_PASIDC_PASID_SI:
+        /* PASID selective implies a DID selective */
+        pc_info.type = VTD_PASID_CACHE_PASIDSI;
+        pc_info.domain_id = domain_id;
+        pc_info.pasid = pasid;
         break;
 
     case VTD_INV_DESC_PASIDC_GLOBAL:
+        trace_vtd_pasid_cache_gsi();
+        pc_info.type = VTD_PASID_CACHE_GLOBAL_INV;
         break;
 
     default:
@@ -2423,6 +2883,7 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
         return false;
     }
 
+    vtd_pasid_cache_sync(s, &pc_info);
     return true;
 }
 
@@ -4113,6 +4574,9 @@ static void vtd_realize(DeviceState *dev, Error **errp)
                                      g_free, g_free);
     s->vtd_as_by_busptr = g_hash_table_new_full(vtd_uint64_hash, vtd_uint64_equal,
                                               g_free, g_free);
+    s->vtd_pasid_as = g_hash_table_new_full(vtd_pasid_as_key_hash,
+                                            vtd_pasid_as_key_equal,
+                                            g_free, g_free);
     vtd_init(s);
     sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, Q35_HOST_BRIDGE_IOMMU_ADDR);
     pci_setup_iommu(bus, &vtd_iommu_ops, dev);
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 22d0bc5..1829f3a 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -308,6 +308,7 @@ typedef enum VTDFaultReason {
     VTD_FR_IR_SID_ERR = 0x26,   /* Invalid Source-ID */
 
     VTD_FR_PASID_TABLE_INV = 0x58,  /*Invalid PASID table entry */
+    VTD_FR_PASID_ENTRY_P = 0x59, /* The Present(P) field of pasidt-entry is 0 */
 
     /* This is not a normal fault reason. We use this to indicate some faults
      * that are not referenced by the VT-d specification.
@@ -512,10 +513,29 @@ typedef struct VTDRootEntry VTDRootEntry;
 #define VTD_CTX_ENTRY_LEGACY_SIZE     16
 #define VTD_CTX_ENTRY_SCALABLE_SIZE   32
 
+#define VTD_SM_CONTEXT_ENTRY_PDTS(val)      (((val) >> 9) & 0x3)
 #define VTD_SM_CONTEXT_ENTRY_RID2PASID_MASK 0xfffff
 #define VTD_SM_CONTEXT_ENTRY_RSVD_VAL0(aw)  (0x1e0ULL | ~VTD_HAW_MASK(aw))
 #define VTD_SM_CONTEXT_ENTRY_RSVD_VAL1      0xffffffffffe00000ULL
 
+typedef enum VTDPCInvType {
+    /* force reset all */
+    VTD_PASID_CACHE_FORCE_RESET = 0,
+    /* pasid cache invalidation rely on guest PASID entry */
+    VTD_PASID_CACHE_GLOBAL_INV,
+    VTD_PASID_CACHE_DOMSI,
+    VTD_PASID_CACHE_PASIDSI,
+} VTDPCInvType;
+
+struct VTDPASIDCacheInfo {
+    VTDPCInvType type;
+    uint16_t domain_id;
+    uint32_t pasid;
+    VTDBus *vtd_bus;
+    uint16_t devfn;
+};
+typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
+
 /* PASID Table Related Definitions */
 #define VTD_PASID_DIR_BASE_ADDR_MASK  (~0xfffULL)
 #define VTD_PASID_TABLE_BASE_ADDR_MASK (~0xfffULL)
@@ -527,6 +547,7 @@ typedef struct VTDRootEntry VTDRootEntry;
 #define VTD_PASID_TABLE_BITS_MASK     (0x3fULL)
 #define VTD_PASID_TABLE_INDEX(pasid)  ((pasid) & VTD_PASID_TABLE_BITS_MASK)
 #define VTD_PASID_ENTRY_FPD           (1ULL << 1) /* Fault Processing Disable */
+#define VTD_PASID_TBL_ENTRY_NUM       (1ULL << 6)
 
 /* PASID Granular Translation Type Mask */
 #define VTD_PASID_ENTRY_P              1ULL
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index f7cd4e5..60d20c1 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -23,6 +23,7 @@ vtd_inv_qi_tail(uint16_t head) "write tail %d"
 vtd_inv_qi_fetch(void) ""
 vtd_context_cache_reset(void) ""
 vtd_pasid_cache_gsi(void) ""
+vtd_pasid_cache_reset(void) ""
 vtd_pasid_cache_dsi(uint16_t domain) "Domian slective PC invalidation domain 0x%"PRIx16
 vtd_pasid_cache_psi(uint16_t domain, uint32_t pasid) "PASID slective PC invalidation domain 0x%"PRIx16" pasid 0x%"PRIx32
 vtd_re_not_present(uint8_t bus) "Root entry bus %"PRIu8" not present"
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 42a58d6..626c1cd 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -65,6 +65,8 @@ typedef union VTD_IR_MSIAddress VTD_IR_MSIAddress;
 typedef struct VTDPASIDDirEntry VTDPASIDDirEntry;
 typedef struct VTDPASIDEntry VTDPASIDEntry;
 typedef struct VTDHostIOMMUContext VTDHostIOMMUContext;
+typedef struct VTDPASIDCacheEntry VTDPASIDCacheEntry;
+typedef struct VTDPASIDAddressSpace VTDPASIDAddressSpace;
 
 /* Context-Entry */
 struct VTDContextEntry {
@@ -97,6 +99,26 @@ struct VTDPASIDEntry {
     uint64_t val[8];
 };
 
+struct pasid_key {
+    uint32_t pasid;
+    uint16_t sid;
+};
+
+struct VTDPASIDCacheEntry {
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
@@ -267,6 +289,7 @@ struct IntelIOMMUState {
 
     GHashTable *vtd_as_by_busptr;   /* VTDBus objects indexed by PCIBus* reference */
     VTDBus *vtd_as_by_bus_num[VTD_PCI_BUS_MAX]; /* VTDBus objects indexed by bus number */
+    GHashTable *vtd_pasid_as;       /* VTDPASIDAddressSpace instances */
     /* list of registered notifiers */
     QLIST_HEAD(, VTDAddressSpace) vtd_as_with_notifiers;
 
@@ -292,6 +315,7 @@ struct IntelIOMMUState {
      * - per-IOMMU IOTLB caches
      * - context entry cache in VTDAddressSpace
      * - HostIOMMUContext pointer cached in vIOMMU
+     * - PASID cache in VTDPASIDAddressSpace
      */
     QemuMutex iommu_lock;
 };
-- 
2.7.4

