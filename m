Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC05218E8D7
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgCVMav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:30:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:58574 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgCVMal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:30:41 -0400
IronPort-SDR: LcRzOWx4AaFpB52xMMAx9dS81e8md/whPvSVckSZIUC79wOluzfd704/mrcejdTZP4x0yES6Wu
 UrursrGlaJzA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:30:39 -0700
IronPort-SDR: 1DrJEvFmLOUcp5Ps0uHn86gzLlpL+bJdRsJ26xeTLP+MrzZiB38bQjF8QXbJV1pZGNppzr8EHh
 JgP381s0YN2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="239664395"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2020 05:30:38 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>
Subject: [PATCH v1 15/22] intel_iommu: replay guest pasid bindings to host
Date:   Sun, 22 Mar 2020 05:36:12 -0700
Message-Id: <1584880579-12178-16-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 128 ++++++++++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h |   1 +
 2 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 0423c83..8ec638f 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2717,6 +2717,130 @@ static VTDPASIDAddressSpace *vtd_add_find_pasid_as(IntelIOMMUState *s,
     return vtd_pasid_as;
 }
 
+/**
+ * Constant information used during pasid table walk
+   @vtd_bus, @devfn: device info
+ * @flags: indicates if it is domain selective walk
+ * @did: domain ID of the pasid table walk
+ */
+typedef struct {
+    VTDBus *vtd_bus;
+    uint16_t devfn;
+#define VTD_PASID_TABLE_DID_SEL_WALK   (1ULL << 0);
+    uint32_t flags;
+    uint16_t did;
+} vtd_pasid_table_walk_info;
+
+/**
+ * Caller of this function should hold iommu_lock.
+ */
+static bool vtd_sm_pasid_table_walk_one(IntelIOMMUState *s,
+                                        dma_addr_t pt_base,
+                                        int start,
+                                        int end,
+                                        vtd_pasid_table_walk_info *info)
+{
+    VTDPASIDEntry pe;
+    int pasid = start;
+    int pasid_next;
+    VTDPASIDAddressSpace *vtd_pasid_as;
+    VTDPASIDCacheEntry *pc_entry;
+
+    while (pasid < end) {
+        pasid_next = pasid + 1;
+
+        if (!vtd_get_pe_in_pasid_leaf_table(s, pasid, pt_base, &pe)
+            && vtd_pe_present(&pe)) {
+            vtd_pasid_as = vtd_add_find_pasid_as(s,
+                                       info->vtd_bus, info->devfn, pasid);
+            pc_entry = &vtd_pasid_as->pasid_cache_entry;
+            if (s->pasid_cache_gen == pc_entry->pasid_cache_gen) {
+                vtd_update_pe_in_cache(s, vtd_pasid_as, &pe);
+            } else {
+                vtd_fill_in_pe_in_cache(s, vtd_pasid_as, &pe);
+            }
+        }
+        pasid = pasid_next;
+    }
+    return true;
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
+                                    vtd_pasid_table_walk_info *info)
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
+                                            uint16_t *did,
+                                            bool is_dsi)
+{
+    VTDContextEntry ce;
+    VTDHostIOMMUContext *vtd_dev_icx;
+    int bus_n, devfn;
+    vtd_pasid_table_walk_info info;
+
+    if (is_dsi) {
+        info.flags = VTD_PASID_TABLE_DID_SEL_WALK;
+        info.did = *did;
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
+    vtd_iommu_lock(s);
+    QLIST_FOREACH(vtd_dev_icx, &s->vtd_dev_icx_list, next) {
+        bus_n = pci_bus_num(vtd_dev_icx->vtd_bus->bus);
+        devfn = vtd_dev_icx->devfn;
+
+        if (!vtd_dev_to_context_entry(s, bus_n, devfn, &ce)) {
+            info.vtd_bus = vtd_dev_icx->vtd_bus;
+            info.devfn = devfn;
+            vtd_sm_pasid_table_walk(s,
+                                    VTD_CE_GET_PASID_DIR_TABLE(&ce),
+                                    0,
+                                    VTD_MAX_HPASID,
+                                    &info);
+        }
+    }
+    vtd_iommu_unlock(s);
+}
+
 static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
 {
     VTDPASIDCacheInfo pc_info;
@@ -2735,7 +2859,6 @@ static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
     vtd_iommu_unlock(s);
 
     /*
-     * TODO:
      * Domain selective PASID cache invalidation flushes
      * all the pasid caches within a domain. To be safe,
      * after invalidating the pasid caches, emulator needs
@@ -2743,6 +2866,7 @@ static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
      * dir and pasid table. e.g. When the guest setup a new
      * PASID entry then send a PASID DSI.
      */
+    vtd_replay_guest_pasid_bindings(s, &domain_id, true);
     return 0;
 }
 
@@ -2881,13 +3005,13 @@ static int vtd_pasid_cache_gsi(IntelIOMMUState *s)
     vtd_iommu_unlock(s);
 
     /*
-     * TODO:
      * Global PASID cache invalidation flushes all
      * the pasid caches. To be safe, after invalidating
      * the pasid caches, emulator needs to replay the
      * pasid bindings by walking guest pasid dir and
      * pasid table.
      */
+    vtd_replay_guest_pasid_bindings(s, NULL, false);
     return 0;
 }
 
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 4451acf..b0a324c 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -554,6 +554,7 @@ typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 #define VTD_PASID_TABLE_BITS_MASK     (0x3fULL)
 #define VTD_PASID_TABLE_INDEX(pasid)  ((pasid) & VTD_PASID_TABLE_BITS_MASK)
 #define VTD_PASID_ENTRY_FPD           (1ULL << 1) /* Fault Processing Disable */
+#define VTD_PASID_TBL_ENTRY_NUM       (1ULL << 6)
 
 /* PASID Granular Translation Type Mask */
 #define VTD_PASID_ENTRY_P              1ULL
-- 
2.7.4

