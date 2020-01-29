Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F8214CA80
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgA2MMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:12:12 -0500
Received: from mga04.intel.com ([192.55.52.120]:15956 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbgA2MLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:11:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:11:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="314071249"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 04:11:52 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com
Cc:     mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v3 19/25] intel_iommu: replay guest pasid bindings to host
Date:   Wed, 29 Jan 2020 04:16:50 -0800
Message-Id: <1580300216-86172-20-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

This patch adds guest pasid bindings replay for domain
selective pasid cache invalidation(dsi) and global pasid
cache invalidation by walking guest pasid table.

Reason:
Guest OS may flush the pasid cache with a larger granularity.
e.g. guest does a svm_bind() but flush the pasid cache with
global or domain selective pasid cache invalidation instead
of pasid selective(psi) pasid cache invalidation. Regards to
such case, it works in host. Per spec, a global or domain
selective pasid cache invalidation should be able to cover
what a pasid selective invalidation does. The only concern
is performance deduction since dsi and global cache invalidation
will flush more than psi. To align with native, vIOMMU needs
emulator needs to do replay for the two invalidation granularity
to reflect the latest pasid bindings in guest pasid table.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 156 ++++++++++++++++++++++++++++++++++++++---
 hw/i386/intel_iommu_internal.h |   1 +
 2 files changed, 147 insertions(+), 10 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 319b3df..1665843 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -68,6 +68,8 @@ static void vtd_address_space_refresh_all(IntelIOMMUState *s);
 static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n);
 
 static void vtd_pasid_cache_reset(IntelIOMMUState *s);
+static int vtd_update_pe_cache_for_dev(IntelIOMMUState *s,
+              VTDBus *vtd_bus, int devfn, int pasid, VTDPASIDEntry *pe);
 
 static void vtd_panic_require_caching_mode(void)
 {
@@ -2625,6 +2627,113 @@ remove:
     return true;
 }
 
+/**
+ * Constant information used during pasid table walk
+ * @vtd_icx: VTDIOMMUContext
+ * @flags: indicates if it is domain selective walk
+ * @did: domain ID of the pasid table walk
+ */
+typedef struct {
+    VTDIOMMUContext *vtd_icx;
+#define VTD_PASID_TABLE_DID_SEL_WALK   (1ULL << 0);
+    uint32_t flags;
+    uint16_t did;
+} vtd_pasid_table_walk_info;
+
+static bool vtd_sm_pasid_table_walk_one(IntelIOMMUState *s,
+                                       dma_addr_t pt_base,
+                                       int start,
+                                       int end,
+                                       vtd_pasid_table_walk_info *info)
+{
+    VTDPASIDEntry pe;
+    int pasid = start;
+    int pasid_next;
+    VTDIOMMUContext *vtd_icx = info->vtd_icx;
+
+    while (pasid < end) {
+        pasid_next = pasid + 1;
+
+        if (!vtd_get_pe_in_pasid_leaf_table(s, pasid, pt_base, &pe)
+            && vtd_pe_present(&pe)) {
+            if (vtd_update_pe_cache_for_dev(s, vtd_icx->vtd_bus,
+                                       vtd_icx->devfn, pasid, &pe)) {
+                error_report_once("%s, bus: %d, devfn: %d, pasid: %d",
+                                  __func__,
+                                  pci_bus_num(vtd_icx->vtd_bus->bus),
+                                  vtd_icx->devfn, pasid);
+                return false;
+            }
+        }
+        pasid = pasid_next;
+    }
+    return true;
+}
+
+/*
+ * Currently, VT-d scalable mode pasid table is a two level table, this
+ * function aims to loop a range of PASIDs in a given pasid table to
+ * identify the pasid config in guest.
+ */
+static void vtd_sm_pasid_table_walk(IntelIOMMUState *s, dma_addr_t pdt_base,
+                        int start, int end, vtd_pasid_table_walk_info *info)
+{
+    VTDPASIDDirEntry pdire;
+    int pasid = start;
+    int pasid_next;
+    dma_addr_t pt_base;
+
+    while (pasid < end) {
+        pasid_next = pasid + VTD_PASID_TBL_ENTRY_NUM;
+        if (!vtd_get_pdire_from_pdir_table(pdt_base, pasid, &pdire)
+            && vtd_pdire_present(&pdire)) {
+            pt_base = pdire.val & VTD_PASID_TABLE_BASE_ADDR_MASK;
+            if (!vtd_sm_pasid_table_walk_one(s,
+                              pt_base, pasid, pasid_next, info)) {
+                break;
+            }
+        }
+        pasid = pasid_next;
+    }
+}
+
+/**
+ * This function replay the guest pasid bindings to hots by
+ * walking the guest PASID table. This ensures host will have
+ * latest guest pasid bindings.
+ */
+static void vtd_replay_guest_pasid_bindings(IntelIOMMUState *s,
+                                           uint16_t *did, bool is_dsi)
+{
+    VTDContextEntry ce;
+    vtd_pasid_table_walk_info info;
+    VTDIOMMUContext *vtd_icx;
+
+    if (is_dsi) {
+        info.flags = VTD_PASID_TABLE_DID_SEL_WALK;
+        info.did = *did;
+    }
+
+    /*
+     * In this replay, only needs to care about the devices which
+     * has iommu_context created. For the one not have iommu_context,
+     * it is not necessary to replay the bindings since their cache
+     * could be re-created in the next DMA address transaltion.
+     */
+    QLIST_FOREACH(vtd_icx, &s->vtd_dev_icx_list, next) {
+        if (!vtd_dev_to_context_entry(s,
+                                      pci_bus_num(vtd_icx->vtd_bus->bus),
+                                      vtd_icx->devfn, &ce)) {
+            info.vtd_icx = vtd_icx;
+            vtd_sm_pasid_table_walk(s,
+                                    VTD_CE_GET_PASID_DIR_TABLE(&ce),
+                                    0,
+                                    VTD_MAX_HPASID,
+                                    &info);
+        }
+    }
+}
+
 static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
 {
     VTDPASIDCacheInfo pc_info;
@@ -2642,12 +2751,13 @@ static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
                                  vtd_flush_pasid, &pc_info);
 
     /*
-     * TODO: Domain selective PASID cache invalidation
-     * flushes all the pasid caches within a domain. To
-     * be safe, after invalidating the pasid caches, emulator
-     * needs to replay the pasid bindings by walking guest
-     * pasid dir and pasid table.
+     * Domain selective PASID cache invalidation flushes
+     * all the pasid caches within a domain. To be safe,
+     * after invalidating the pasid caches, emulator needs
+     * to replay the pasid bindings by walking guest pasid
+     * dir and pasid table.
      */
+    vtd_replay_guest_pasid_bindings(s, &domain_id, true);
     vtd_iommu_unlock(s);
     return 0;
 }
@@ -2715,6 +2825,31 @@ static inline void vtd_fill_in_pe_cache(
                          pe, VTD_PASID_BIND);
 }
 
+/**
+ * This function updates the pasid entry cached in &vtd_pasid_as.
+ * Caller of this function should hold iommu_lock.
+ */
+static int vtd_update_pe_cache_for_dev(IntelIOMMUState *s, VTDBus *vtd_bus,
+                               int devfn, int pasid, VTDPASIDEntry *pe)
+{
+    VTDPASIDAddressSpace *vtd_pasid_as;
+
+    vtd_pasid_as = vtd_add_find_pasid_as(s, vtd_bus,
+                                        devfn, pasid, true);
+    if (!vtd_pasid_as) {
+        error_report_once("%s, fatal error happened!\n", __func__);
+        return -1;
+    }
+
+    if (vtd_pasid_as->pasid_cache_entry.pasid_cache_gen ==
+                                               s->pasid_cache_gen) {
+        return 0;
+    }
+
+    vtd_fill_in_pe_cache(vtd_pasid_as, pe);
+    return 0;
+}
+
 static int vtd_pasid_cache_psi(IntelIOMMUState *s,
                                uint16_t domain_id, uint32_t pasid)
 {
@@ -2838,12 +2973,13 @@ static int vtd_pasid_cache_gsi(IntelIOMMUState *s)
     vtd_pasid_cache_reset(s);
 
     /*
-     * TODO: Global PASID cache invalidation may be
-     * flushes all the pasid caches. To be safe, after
-     * invalidating the pasid caches, emulator needs
-     * to replay the pasid bindings by walking guest
-     * pasid dir and pasid table.
+     * Global PASID cache invalidation flushes all
+     * the pasid caches. To be safe, after invalidating
+     * the pasid caches, emulator needs to replay the
+     * pasid bindings by walking guest pasid dir and
+     * pasid table.
      */
+    vtd_replay_guest_pasid_bindings(s, NULL, false);
     vtd_iommu_unlock(s);
     return 0;
 }
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 833c442..cd96b6e 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -558,6 +558,7 @@ typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 #define VTD_PASID_TABLE_BITS_MASK     (0x3fULL)
 #define VTD_PASID_TABLE_INDEX(pasid)  ((pasid) & VTD_PASID_TABLE_BITS_MASK)
 #define VTD_PASID_ENTRY_FPD           (1ULL << 1) /* Fault Processing Disable */
+#define VTD_PASID_TBL_ENTRY_NUM       (1ULL << 6)
 
 /* PASID Granular Translation Type Mask */
 #define VTD_PASID_ENTRY_P              1ULL
-- 
2.7.4

