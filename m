Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E832C6105D
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfGFLT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfGFLT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355033"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:23 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 12/18] intel_iommu: bind/unbind guest page table to host
Date:   Fri,  5 Jul 2019 19:01:45 +0800
Message-Id: <1562324511-2910-13-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch captures the guest PASID table entry modifications and passdown
the changes to host. Thus guest page table is bound to host IOMMU and is
configured as 1st level page table (GVA->GPA) whose translation result
would further go through host VT-d 2nd level page table(GPA->HPA) under
nested translation mode. This is key part of vSVA support in KVM.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 85 +++++++++++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h | 20 ++++++++++
 2 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index cfe5dbf..d897a52 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -703,6 +703,16 @@ static inline uint16_t vtd_pe_get_domain_id(VTDPASIDEntry *pe)
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
 static inline bool vtd_pe_present(VTDPASIDEntry *pe)
 {
     return pe->val[0] & VTD_PASID_ENTRY_P;
@@ -1836,6 +1846,47 @@ static void vtd_context_global_invalidate(IntelIOMMUState *s)
     vtd_iommu_replay_all(s);
 }
 
+static void vtd_bind_guest_pasid(IntelIOMMUState *s, int bus_n,
+            int devfn, int pasid, VTDPASIDEntry *pe, VTDPASIDOp op)
+{
+    PCIBus *bus;
+    struct gpasid_bind_data *g_bind_data;
+    bus = vtd_find_pci_bus_from_bus_num(s, bus_n);
+    g_bind_data = g_malloc0(sizeof(*g_bind_data));
+
+    switch (op) {
+    case VTD_PASID_BIND:
+    case VTD_PASID_UPDATE:
+        g_bind_data->version = IOMMU_GPASID_BIND_VERSION_1;
+        g_bind_data->format = IOMMU_PASID_FORMAT_INTEL_VTD;
+        g_bind_data->gpgd = vtd_pe_get_flpt_base(pe);
+        g_bind_data->addr_width = vtd_pe_get_fl_aw(pe);
+        g_bind_data->hpasid = pasid;
+        g_bind_data->vtd.flags =
+                             (VTD_SM_PASID_ENTRY_SRE_BIT(pe->val[2]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_EAFE_BIT(pe->val[2]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_PCD_BIT(pe->val[1]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_PWT_BIT(pe->val[1]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_EMTE_BIT(pe->val[1]) ? 1 : 0)
+                           | (VTD_SM_PASID_ENTRY_CD_BIT(pe->val[1]) ? 1 : 0);
+        g_bind_data->vtd.pat = VTD_SM_PASID_ENTRY_PAT(pe->val[1]);
+        g_bind_data->vtd.emt = VTD_SM_PASID_ENTRY_EMT(pe->val[1]);
+        pci_device_bind_gpasid(bus, devfn, g_bind_data);
+        break;
+
+    case VTD_PASID_UNBIND:
+        g_bind_data->gpgd = 0;
+        g_bind_data->addr_width = 0;
+        g_bind_data->hpasid = pasid;
+        pci_device_unbind_gpasid(bus, devfn, g_bind_data);
+        break;
+
+    default:
+        printf("Unknown VTDPASIDOp!!\n");
+        break;
+    }
+}
+
 /* Do a context-cache device-selective invalidation.
  * @func_mask: FM field after shifting
  */
@@ -1893,6 +1944,17 @@ static void vtd_context_device_invalidate(IntelIOMMUState *s,
                  * happened.
                  */
                 vtd_sync_shadow_page_table(vtd_as);
+                /*
+                 * Per spec, context flush should also followed with PASID
+                 * cache and iotlb flush. Here, mark it as a TODO.
+                 * Regards to a device selective context cache invalidation:
+                 * if (emaulted_device)
+                 *    modify the pasid cache gen and pasid-based iotlb gen
+                 *    value (will be added in following patches)
+                 * else if (assigned_device)
+                 *    check if the device has been bound to any pasid
+                 *    invoke pasid_unbind regards to each bound pasid
+                 */
             }
         }
     }
@@ -3636,7 +3698,7 @@ static gboolean vtd_flush_pasid(gpointer key, gpointer value,
 {
     VTDPASIDCacheInfo *pc_info = user_data;
     VTDAddressSpace *vtd_pasid_as = value;
-    uint16_t did;
+    uint16_t did, devfn;
     uint32_t pasid;
 
     if (!vtd_pasid_as || !vtd_pasid_as->pasid_allocated) {
@@ -3645,6 +3707,7 @@ static gboolean vtd_flush_pasid(gpointer key, gpointer value,
 
     did = vtd_pe_get_domain_id(&(vtd_pasid_as->pasid_cache_entry.pasid_entry));
     pasid = vtd_pasid_as->pasid;
+    devfn = vtd_pasid_as->devfn;
     if (vtd_pasid_as->pasid_cache_entry.pasid_cache_gen &&
         (vtd_pc_is_dom_si(pc_info) ? (pc_info->domain_id == did) : 1) &&
         (vtd_pc_is_pasid_si(pc_info) ? (pc_info->pasid == pasid) : 1)) {
@@ -3655,6 +3718,19 @@ static gboolean vtd_flush_pasid(gpointer key, gpointer value,
          * cache gen is updated in a new pasid binding.
          */
         vtd_pasid_as->pasid_cache_entry.pasid_cache_gen = 0;
+        /*
+         * To be clean, invalidate the vtd_pasid_as instance is expected.
+         * but it is optional if wants to save memory allocation for
+         * frequent pasid usage on a device. This function will not
+         * release the vtd_pasid_as instance, the caller should do
+         * it explicitly.
+         */
+        vtd_bind_guest_pasid(vtd_pasid_as->iommu_state,
+                             pci_bus_num(vtd_pasid_as->bus),
+                             devfn,
+                             pasid,
+                             NULL,
+                             VTD_PASID_UNBIND);
         return true;
     }
 
@@ -3824,11 +3900,18 @@ static int vtd_pasid_cache_psi(IntelIOMMUState *s,
                                              devfn, pasid, true);
             if (!vtd_pasid_as) {
                 printf("%s, fatal error happened!\n", __func__);
+                /*
+                 * get vtd_pasid_as failed, need to do an unbind
+                 * in case of previous bind
+                 */
+                vtd_bind_guest_pasid(s, bus_n, devfn,
+                                     pasid, NULL, VTD_PASID_UNBIND);
                 continue;
             }
             pc_entry = &vtd_pasid_as->pasid_cache_entry;
             pc_entry->pasid_entry = pe; /* update pasid cache */
             pc_entry->pasid_cache_gen = s->pasid_cache_gen;
+            vtd_bind_guest_pasid(s, bus_n, devfn, pasid, &pe, VTD_PASID_BIND);
         }
     }
     return 0;
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index afeb6aa..f9a4ac6 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -474,6 +474,14 @@ struct VTDRootEntry {
 };
 typedef struct VTDRootEntry VTDRootEntry;
 
+enum VTDPASIDOp {
+    VTD_PASID_BIND,
+    VTD_PASID_UNBIND,
+    VTD_PASID_UPDATE,
+    VTD_OP_NUM
+};
+typedef enum VTDPASIDOp VTDPASIDOp;
+
 struct VTDPASIDCacheInfo {
 #define VTD_PASID_CACHE_DOMSI   (1ULL << 0);
 #define VTD_PASID_CACHE_PASIDSI (1ULL << 1);
@@ -540,6 +548,18 @@ typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
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

