Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922EE32A759
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379978AbhCBQJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:09:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:51835 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346973AbhCBMzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:55:35 -0500
IronPort-SDR: TXIvT+nVbDGXMliRq8unGhkLE9SUiS0zxEr/ByHf1oLkHbIvIdomnjrhZUeo59DYYkXcTZBf6m
 mijJmLFe8DjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="250841386"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="250841386"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:40:53 -0800
IronPort-SDR: NOz9yPACrKdCsl/gGhPEL35jFAlBQ57KONWKubiEuZy3+F1AilLc0vxKxEiCBhCh7Z2sXDtK4t
 7PIKDqBrH/jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427473057"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:40:49 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Lingshan.Zhu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>
Subject: [RFC v11 18/25] intel_iommu: bind/unbind guest page table to host
Date:   Wed,  3 Mar 2021 04:38:20 +0800
Message-Id: <20210302203827.437645-19-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch captures the guest PASID table entry modifications and
propagates the changes to host to setup dual stage DMA translation.
The guest page table is configured as 1st level page table (GVA->GPA)
whose translation result would further go through host VT-d 2nd
level page table(GPA->HPA) under nested translation mode. This is the
key part of vSVA support, and also a key to support IOVA over 1st-
level page table for Intel VT-d in virtualization environment.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
rfcv10 -> rfcv11:
*) Add @error_happened in struct VTDPASIDCacheInfo to track the
   bind/unbind failure, and return to guest.
---
 hw/i386/intel_iommu.c          | 138 +++++++++++++++++++++++++++++----
 hw/i386/intel_iommu_internal.h |  19 +++++
 2 files changed, 143 insertions(+), 14 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index a8f895807a..0fdc2c6e82 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -43,6 +43,7 @@
 #include <linux/ioasid.h>
 #include <sys/ioctl.h>
 #include "qemu/jhash.h"
+#include <linux/iommu.h>
 
 int ioasid_fd = -1;
 uint32_t ioasid_bits;
@@ -705,6 +706,24 @@ static inline uint32_t vtd_sm_ce_get_pdt_entry_num(VTDContextEntry *ce)
     return 1U << (VTD_SM_CONTEXT_ENTRY_PDTS(ce->val[0]) + 7);
 }
 
+static inline uint32_t vtd_pe_get_fl_aw(VTDPASIDEntry *pe)
+{
+    return 48 + ((pe->val[2] >> 2) & VTD_SM_PASID_ENTRY_FLPM) * 9;
+}
+
+static inline dma_addr_t vtd_pe_get_flpt_base(VTDPASIDEntry *pe)
+{
+    return pe->val[2] & VTD_SM_PASID_ENTRY_FLPTPTR;
+}
+
+static inline void pasid_cache_info_set_error(VTDPASIDCacheInfo *pc_info)
+{
+    if (pc_info->error_happened) {
+        return;
+    }
+    pc_info->error_happened = true;
+}
+
 static inline bool vtd_pdire_present(VTDPASIDDirEntry *pdire)
 {
     return pdire->val & 1;
@@ -1875,6 +1894,85 @@ static void vtd_context_global_invalidate(IntelIOMMUState *s)
     vtd_iommu_replay_all(s);
 }
 
+/**
+ * Caller should hold iommu_lock.
+ */
+static int vtd_bind_guest_pasid(IntelIOMMUState *s, VTDBus *vtd_bus,
+                                int devfn, int pasid, VTDPASIDEntry *pe,
+                                VTDPASIDOp op)
+{
+    VTDHostIOMMUContext *vtd_dev_icx;
+    HostIOMMUContext *iommu_ctx;
+    int ret = -1;
+
+    vtd_dev_icx = vtd_bus->dev_icx[devfn];
+    if (!vtd_dev_icx) {
+        /* means no need to go further, e.g. for emulated devices */
+        return 0;
+    }
+
+    iommu_ctx = vtd_dev_icx->iommu_ctx;
+    if (!iommu_ctx) {
+        return -EINVAL;
+    }
+
+    switch (op) {
+    case VTD_PASID_BIND:
+    {
+        struct iommu_gpasid_bind_data *g_bind_data;
+
+        g_bind_data = g_malloc0(sizeof(*g_bind_data));
+
+        g_bind_data->argsz = sizeof(*g_bind_data);
+        g_bind_data->version = IOMMU_GPASID_BIND_VERSION_1;
+        g_bind_data->format = IOMMU_PASID_FORMAT_INTEL_VTD;
+        g_bind_data->gpgd = vtd_pe_get_flpt_base(pe);
+        g_bind_data->addr_width = vtd_pe_get_fl_aw(pe);
+        g_bind_data->hpasid = pasid;
+        g_bind_data->gpasid = pasid;
+        g_bind_data->flags |= IOMMU_SVA_GPASID_VAL;
+        g_bind_data->vendor.vtd.flags =
+                             (VTD_SM_PASID_ENTRY_SRE_BIT(pe->val[2]) ?
+                                            IOMMU_SVA_VTD_GPASID_SRE : 0)
+                           | (VTD_SM_PASID_ENTRY_EAFE_BIT(pe->val[2]) ?
+                                            IOMMU_SVA_VTD_GPASID_EAFE : 0)
+                           | (VTD_SM_PASID_ENTRY_PCD_BIT(pe->val[1]) ?
+                                            IOMMU_SVA_VTD_GPASID_PCD : 0)
+                           | (VTD_SM_PASID_ENTRY_PWT_BIT(pe->val[1]) ?
+                                            IOMMU_SVA_VTD_GPASID_PWT : 0)
+                           | (VTD_SM_PASID_ENTRY_EMTE_BIT(pe->val[1]) ?
+                                            IOMMU_SVA_VTD_GPASID_EMTE : 0)
+                           | (VTD_SM_PASID_ENTRY_CD_BIT(pe->val[1]) ?
+                                            IOMMU_SVA_VTD_GPASID_CD : 0);
+        g_bind_data->vendor.vtd.pat = VTD_SM_PASID_ENTRY_PAT(pe->val[1]);
+        g_bind_data->vendor.vtd.emt = VTD_SM_PASID_ENTRY_EMT(pe->val[1]);
+        ret = host_iommu_ctx_bind_stage1_pgtbl(iommu_ctx, g_bind_data);
+        g_free(g_bind_data);
+        break;
+    }
+    case VTD_PASID_UNBIND:
+    {
+        struct iommu_gpasid_bind_data *g_unbind_data;
+
+        g_unbind_data = g_malloc0(sizeof(*g_unbind_data));
+
+        g_unbind_data->argsz = sizeof(*g_unbind_data);
+        g_unbind_data->version = IOMMU_GPASID_BIND_VERSION_1;
+        g_unbind_data->format = IOMMU_PASID_FORMAT_INTEL_VTD;
+        g_unbind_data->hpasid = pasid;
+        ret = host_iommu_ctx_unbind_stage1_pgtbl(iommu_ctx, g_unbind_data);
+        g_free(g_unbind_data);
+        break;
+    }
+    default:
+        error_report_once("Unknown VTDPASIDOp!!!\n");
+        break;
+    }
+
+
+    return ret;
+}
+
 /* Do a context-cache device-selective invalidation.
  * @func_mask: FM field after shifting
  */
@@ -2503,22 +2601,22 @@ static bool vtd_pasid_entry_compare(VTDPASIDEntry *p1, VTDPASIDEntry *p2)
  * This function fills in the pasid entry in &vtd_pasid_as. Caller
  * of this function should hold iommu_lock.
  */
-static void vtd_fill_pe_in_cache(IntelIOMMUState *s,
-                                 VTDPASIDAddressSpace *vtd_pasid_as,
-                                 VTDPASIDEntry *pe)
+static int vtd_fill_pe_in_cache(IntelIOMMUState *s,
+                                VTDPASIDAddressSpace *vtd_pasid_as,
+                                VTDPASIDEntry *pe)
 {
     VTDPASIDCacheEntry *pc_entry = &vtd_pasid_as->pasid_cache_entry;
 
     if (vtd_pasid_entry_compare(pe, &pc_entry->pasid_entry)) {
         /* No need to go further as cached pasid entry is latest */
-        return;
+        return 0;
     }
 
     pc_entry->pasid_entry = *pe;
-    /*
-     * TODO:
-     * - send pasid bind to host for passthru devices
-     */
+    return vtd_bind_guest_pasid(s, vtd_pasid_as->vtd_bus,
+                                vtd_pasid_as->devfn,
+                                vtd_pasid_as->pasid,
+                                pe, VTD_PASID_BIND);
 }
 
 /**
@@ -2581,7 +2679,10 @@ static gboolean vtd_flush_pasid(gpointer key, gpointer value,
         goto remove;
     }
 
-    vtd_fill_pe_in_cache(s, vtd_pasid_as, &pe);
+    if (vtd_fill_pe_in_cache(s, vtd_pasid_as, &pe)) {
+        pasid_cache_info_set_error(pc_info);
+    }
+
     /*
      * TODO:
      * - when pasid-base-iotlb(piotlb) infrastructure is ready,
@@ -2591,10 +2692,14 @@ static gboolean vtd_flush_pasid(gpointer key, gpointer value,
 remove:
     /*
      * TODO:
-     * - send pasid bind to host for passthru devices
      * - when pasid-base-iotlb(piotlb) infrastructure is ready,
      *   should invalidate QEMU piotlb togehter with this change.
      */
+    if (vtd_bind_guest_pasid(s, vtd_bus, devfn,
+                         pasid, NULL, VTD_PASID_UNBIND)) {
+        pasid_cache_info_set_error(pc_info);
+    }
+
     return true;
 }
 
@@ -2672,7 +2777,9 @@ static void vtd_sm_pasid_table_walk_one(IntelIOMMUState *s,
                 pasid = pasid_next;
                 continue;
             }
-            vtd_fill_pe_in_cache(s, vtd_pasid_as, &pe);
+            if (vtd_fill_pe_in_cache(s, vtd_pasid_as, &pe)) {
+                pasid_cache_info_set_error(info);
+            }
         }
         pasid = pasid_next;
     }
@@ -2779,6 +2886,9 @@ static void vtd_replay_guest_pasid_bindings(IntelIOMMUState *s,
         walk_info.devfn = vtd_dev_icx->devfn;
         vtd_replay_pasid_bind_for_dev(s, start, end, &walk_info);
     }
+    if (walk_info.error_happened) {
+        pasid_cache_info_set_error(pc_info);
+    }
 }
 
 /**
@@ -2846,7 +2956,7 @@ static void vtd_pasid_cache_sync(IntelIOMMUState *s,
  */
 static void vtd_pasid_cache_reset(IntelIOMMUState *s)
 {
-    VTDPASIDCacheInfo pc_info;
+    VTDPASIDCacheInfo pc_info = { .error_happened = false, };
 
     trace_vtd_pasid_cache_reset();
 
@@ -2868,9 +2978,9 @@ static void vtd_pasid_cache_reset(IntelIOMMUState *s)
 static bool vtd_process_pasid_desc(IntelIOMMUState *s,
                                    VTDInvDesc *inv_desc)
 {
+    VTDPASIDCacheInfo pc_info = { .error_happened = false, };
     uint16_t domain_id;
     uint32_t pasid;
-    VTDPASIDCacheInfo pc_info;
 
     if ((inv_desc->val[0] & VTD_INV_DESC_PASIDC_RSVD_VAL0) ||
         (inv_desc->val[1] & VTD_INV_DESC_PASIDC_RSVD_VAL1) ||
@@ -2910,7 +3020,7 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
     }
 
     vtd_pasid_cache_sync(s, &pc_info);
-    return true;
+    return !pc_info.error_happened ? true : false;
 }
 
 static bool vtd_process_inv_iec_desc(IntelIOMMUState *s,
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index a5d81e623b..e4c7b23455 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -536,6 +536,13 @@ typedef struct VTDRootEntry VTDRootEntry;
 #define VTD_SM_CONTEXT_ENTRY_RSVD_VAL0(aw)  (0x1e0ULL | ~VTD_HAW_MASK(aw))
 #define VTD_SM_CONTEXT_ENTRY_RSVD_VAL1      0xffffffffffe00000ULL
 
+enum VTDPASIDOp {
+    VTD_PASID_BIND,
+    VTD_PASID_UNBIND,
+    VTD_OP_NUM
+};
+typedef enum VTDPASIDOp VTDPASIDOp;
+
 typedef enum VTDPCInvType {
     /* force reset all */
     VTD_PASID_CACHE_FORCE_RESET = 0,
@@ -551,6 +558,7 @@ struct VTDPASIDCacheInfo {
     uint32_t pasid;
     VTDBus *vtd_bus;
     uint16_t devfn;
+    bool error_happened;
 };
 typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 
@@ -578,6 +586,17 @@ typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 #define VTD_SM_PASID_ENTRY_AW          7ULL /* Adjusted guest-address-width */
 #define VTD_SM_PASID_ENTRY_DID(val)    ((val) & VTD_DOMAIN_ID_MASK)
 
+#define VTD_SM_PASID_ENTRY_FLPM          3ULL
+#define VTD_SM_PASID_ENTRY_FLPTPTR       (~0xfffULL)
+#define VTD_SM_PASID_ENTRY_SRE_BIT(val)  (!!((val) & 1ULL))
+#define VTD_SM_PASID_ENTRY_EAFE_BIT(val) (!!(((val) >> 7) & 1ULL))
+#define VTD_SM_PASID_ENTRY_PCD_BIT(val)  (!!(((val) >> 31) & 1ULL))
+#define VTD_SM_PASID_ENTRY_PWT_BIT(val)  (!!(((val) >> 30) & 1ULL))
+#define VTD_SM_PASID_ENTRY_EMTE_BIT(val) (!!(((val) >> 26) & 1ULL))
+#define VTD_SM_PASID_ENTRY_CD_BIT(val)   (!!(((val) >> 25) & 1ULL))
+#define VTD_SM_PASID_ENTRY_PAT(val)      (((val) >> 32) & 0xFFFFFFFFULL)
+#define VTD_SM_PASID_ENTRY_EMT(val)      (((val) >> 27) & 0x7ULL)
+
 /* Second Level Page Translation Pointer*/
 #define VTD_SM_PASID_ENTRY_SLPTPTR     (~0xfffULL)
 
-- 
2.25.1

