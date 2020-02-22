Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEEC1168D61
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgBVICP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:02:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:63022 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgBVICC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:02:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547692"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2020 00:01:57 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v3.1 14/22] intel_iommu: bind/unbind guest page table to host
Date:   Sat, 22 Feb 2020 00:07:15 -0800
Message-Id: <1582358843-51931-15-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch captures the guest PASID table entry modifications and
propagates the changes to host to setup dual stage DMA translation.
The guest page table is configured as 1st level page table (GVA->GPA)
whose translation result would further go through host VT-d 2nd
level page table(GPA->HPA) under nested translation mode. This is
a key part of vSVA support, and also a key to support IOVA over 1st
level page table for Intel VT-d in virtualization environment.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 93 ++++++++++++++++++++++++++++++++++++++++--
 hw/i386/intel_iommu_internal.h | 26 ++++++++++++
 2 files changed, 115 insertions(+), 4 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index b032a7c..8bd27b1 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -41,6 +41,7 @@
 #include "migration/vmstate.h"
 #include "trace.h"
 #include "qemu/jhash.h"
+#include <linux/iommu.h>
 
 /* context entry operations */
 #define VTD_CE_GET_RID2PASID(ce) \
@@ -695,6 +696,16 @@ static inline uint16_t vtd_pe_get_domain_id(VTDPASIDEntry *pe)
     return VTD_SM_PASID_ENTRY_DID((pe)->val[1]);
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
 static inline bool vtd_pdire_present(VTDPASIDDirEntry *pdire)
 {
     return pdire->val & 1;
@@ -1854,6 +1865,73 @@ static void vtd_context_global_invalidate(IntelIOMMUState *s)
     vtd_iommu_replay_all(s);
 }
 
+static int vtd_bind_guest_pasid(IntelIOMMUState *s, VTDBus *vtd_bus,
+                                int devfn, int pasid, VTDPASIDEntry *pe,
+                                VTDPASIDOp op)
+{
+    HostIOMMUContext *host_icx;
+    DualIOMMUStage1BindData *bind_data;
+    struct iommu_gpasid_bind_data *g_bind_data;
+    PCIDevice *dev;
+    int ret = -1;
+
+    dev = vtd_bus->bus->devices[devfn];
+    host_icx = pci_device_host_iommu_context(dev);
+    if (!host_icx) {
+        return ret;
+    }
+
+    if (host_icx->uinfo.stage1_format
+             != IOMMU_PASID_FORMAT_INTEL_VTD)
+    {
+        error_report_once("IOMMU Stage 1 format is not compatible!\n");
+    }
+
+    bind_data = g_malloc0(sizeof(*bind_data));
+    bind_data->pasid = pasid;
+    g_bind_data = &bind_data->bind_data.gpasid_bind;
+
+    g_bind_data->flags = 0;
+    g_bind_data->vtd.flags = 0;
+    switch (op) {
+    case VTD_PASID_BIND:
+    case VTD_PASID_UPDATE:
+        g_bind_data->version = IOMMU_UAPI_VERSION;
+        g_bind_data->format = IOMMU_PASID_FORMAT_INTEL_VTD;
+        g_bind_data->gpgd = vtd_pe_get_flpt_base(pe);
+        g_bind_data->addr_width = vtd_pe_get_fl_aw(pe);
+        g_bind_data->hpasid = pasid;
+        g_bind_data->gpasid = pasid;
+        g_bind_data->flags |= IOMMU_SVA_GPASID_VAL;
+        g_bind_data->vtd.flags =
+                             (VTD_SM_PASID_ENTRY_SRE_BIT(pe->val[2]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_EAFE_BIT(pe->val[2]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_PCD_BIT(pe->val[1]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_PWT_BIT(pe->val[1]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_EMTE_BIT(pe->val[1]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_CD_BIT(pe->val[1]) ? 1 : 0);
+        g_bind_data->vtd.pat = VTD_SM_PASID_ENTRY_PAT(pe->val[1]);
+        g_bind_data->vtd.emt = VTD_SM_PASID_ENTRY_EMT(pe->val[1]);
+        ret = host_iommu_ctx_bind_stage1_pgtbl(host_icx, bind_data);
+        break;
+    case VTD_PASID_UNBIND:
+        g_bind_data->version = IOMMU_UAPI_VERSION;
+        g_bind_data->format = IOMMU_PASID_FORMAT_INTEL_VTD;
+        g_bind_data->gpgd = 0;
+        g_bind_data->addr_width = 0;
+        g_bind_data->hpasid = pasid;
+        g_bind_data->gpasid = pasid;
+        g_bind_data->flags |= IOMMU_SVA_GPASID_VAL;
+        ret = host_iommu_ctx_unbind_stage1_pgtbl(host_icx, bind_data);
+        break;
+    default:
+        error_report_once("Unknown VTDPASIDOp!!\n");
+        break;
+    }
+    g_free(bind_data);
+    return ret;
+}
+
 /* Do a context-cache device-selective invalidation.
  * @func_mask: FM field after shifting
  */
@@ -2533,18 +2611,20 @@ static gboolean vtd_flush_pasid(gpointer key, gpointer value,
         /* pasid entry was updated, thus update the pasid cache */
         pc_entry->pasid_entry = pe;
         pc_entry->pasid_cache_gen = s->pasid_cache_gen;
+        vtd_bind_guest_pasid(s, vtd_bus, devfn,
+                             pasid, &pe, VTD_PASID_UPDATE);
         /*
          * TODO:
-         * - send pasid bind to host for passthru devices
          * - when pasid-base-iotlb(piotlb) infrastructure is ready,
          *   should invalidate QEMU piotlb togehter with this change.
          */
     }
     return false;
 remove:
+    vtd_bind_guest_pasid(s, vtd_bus, devfn,
+                         pasid, NULL, VTD_PASID_UNBIND);
     /*
      * TODO:
-     * - send pasid unbind to host for passthru devices
      * - when pasid-base-iotlb(piotlb) infrastructure is ready,
      *   should invalidate QEMU piotlb togehter with this change.
      */
@@ -2624,8 +2704,9 @@ static VTDPASIDAddressSpace *vtd_add_find_pasid_as(IntelIOMMUState *s,
 }
 
  /**
-  * This function cached the pasid entry in &vtd_pasid_as.
-  * Caller of this function should hold iommu_lock.
+  * This function cached the pasid entry in &vtd_pasid_as. Also
+  * notifies host about the new pasid binding. Caller of this
+  * function should hold iommu_lock.
   */
 static inline void vtd_fill_in_pe_cache(
               VTDPASIDAddressSpace *vtd_pasid_as, VTDPASIDEntry *pe)
@@ -2635,6 +2716,10 @@ static inline void vtd_fill_in_pe_cache(
 
     pc_entry->pasid_entry = *pe;
     pc_entry->pasid_cache_gen = s->pasid_cache_gen;
+    vtd_bind_guest_pasid(s, vtd_pasid_as->vtd_bus,
+                         vtd_pasid_as->devfn,
+                         vtd_pasid_as->pasid,
+                         pe, VTD_PASID_BIND);
 }
 
 /**
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 2684769..9ee5856 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -482,6 +482,20 @@ struct VTDRootEntry {
 };
 typedef struct VTDRootEntry VTDRootEntry;
 
+enum VTD_DUAL_STAGE_UAPI {
+    UAPI_BIND_GPASID,
+    UAPI_NUM
+};
+typedef enum VTD_DUAL_STAGE_UAPI VTD_DUAL_STAGE_UAPI;
+
+enum VTDPASIDOp {
+    VTD_PASID_BIND,
+    VTD_PASID_UNBIND,
+    VTD_PASID_UPDATE,
+    VTD_OP_NUM
+};
+typedef enum VTDPASIDOp VTDPASIDOp;
+
 struct VTDPASIDCacheInfo {
 #define VTD_PASID_CACHE_GLOBAL   (1ULL << 0)
 #define VTD_PASID_CACHE_DOMSI    (1ULL << 1)
@@ -552,6 +566,18 @@ typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 #define VTD_SM_PASID_ENTRY_AW          7ULL /* Adjusted guest-address-width */
 #define VTD_SM_PASID_ENTRY_DID(val)    ((val) & VTD_DOMAIN_ID_MASK)
 
+/* Adjusted guest-address-width */
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
2.7.4

