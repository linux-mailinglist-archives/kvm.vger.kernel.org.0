Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42CE36105E
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGFLT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbfGFLT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355039"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:25 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 13/18] intel_iommu: flush pasid cache after a DSI context cache flush
Date:   Fri,  5 Jul 2019 19:01:46 +0800
Message-Id: <1562324511-2910-14-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch flushes pasid cache after a device selective context cache
flush. This is a behavior to ensure safety. Actually, programmer should
issue a pasid cache flush following a device selective context cache
invalidation.

TODO: global and domain selective context cache flush should also be
followed with a proper pasid cache flush. Also needs to consider pasid
bind replay.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 22 ++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |  2 ++
 hw/i386/trace-events           |  1 +
 3 files changed, 25 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index d897a52..3b213a4 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -70,6 +70,8 @@ static void vtd_pasid_cache_reset(IntelIOMMUState *s);
 static int vtd_pasid_cache_psi(IntelIOMMUState *s,
                                uint16_t domain_id,
                                uint32_t pasid);
+static void vtd_pasid_cache_devsi(IntelIOMMUState *s,
+                                  uint16_t devfn);
 static VTDContextCacheEntry *vtd_find_context_cache(IntelIOMMUState *s,
                                                     PCIBus *bus, int devfn);
 static void vtd_invalidate_pe_cache(IntelIOMMUState *s,
@@ -1955,6 +1957,7 @@ static void vtd_context_device_invalidate(IntelIOMMUState *s,
                  *    check if the device has been bound to any pasid
                  *    invoke pasid_unbind regards to each bound pasid
                  */
+                 vtd_pasid_cache_devsi(s, devfn_it);
             }
         }
     }
@@ -3686,6 +3689,11 @@ static inline bool vtd_pc_is_pasid_si(struct VTDPASIDCacheInfo *pc_info)
     return pc_info->flags & VTD_PASID_CACHE_PASIDSI;
 }
 
+static inline bool vtd_pc_is_dev_si(struct VTDPASIDCacheInfo *pc_info)
+{
+    return pc_info->flags & VTD_PASID_CACHE_DEVSI;
+}
+
 /**
  * This function is used to clear pasid_cache_gen of cached pasid
  * entry in vtd_pasid_as instance. Caller of this function should
@@ -3709,6 +3717,7 @@ static gboolean vtd_flush_pasid(gpointer key, gpointer value,
     pasid = vtd_pasid_as->pasid;
     devfn = vtd_pasid_as->devfn;
     if (vtd_pasid_as->pasid_cache_entry.pasid_cache_gen &&
+        (vtd_pc_is_dev_si(pc_info) ? (pc_info->devfn == devfn) : 1) &&
         (vtd_pc_is_dom_si(pc_info) ? (pc_info->domain_id == did) : 1) &&
         (vtd_pc_is_pasid_si(pc_info) ? (pc_info->pasid == pasid) : 1)) {
         /*
@@ -3917,6 +3926,19 @@ static int vtd_pasid_cache_psi(IntelIOMMUState *s,
     return 0;
 }
 
+static void vtd_pasid_cache_devsi(IntelIOMMUState *s,
+                                  uint16_t devfn)
+{
+    VTDPASIDCacheInfo pc_info;
+
+    trace_vtd_pasid_cache_devsi(devfn);
+
+    pc_info.flags = VTD_PASID_CACHE_DEVSI;
+    pc_info.devfn = devfn;
+
+    g_hash_table_foreach_remove(s->vtd_pasid_as, vtd_flush_pasid, &pc_info);
+}
+
 /**
  * Caller of this function should hold iommu_lock
  */
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index f9a4ac6..021d358 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -485,9 +485,11 @@ typedef enum VTDPASIDOp VTDPASIDOp;
 struct VTDPASIDCacheInfo {
 #define VTD_PASID_CACHE_DOMSI   (1ULL << 0);
 #define VTD_PASID_CACHE_PASIDSI (1ULL << 1);
+#define VTD_PASID_CACHE_DEVSI   (1ULL << 2);
     uint32_t flags;
     uint16_t domain_id;
     uint32_t pasid;
+    uint16_t devfn;
 };
 typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index 7912ae1..25bd6a4 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -26,6 +26,7 @@ vtd_pasid_cache_reset(void) ""
 vtd_pasid_cache_gsi(void) ""
 vtd_pasid_cache_dsi(uint16_t domain) "Domian slective PC invalidation domain 0x%"PRIx16
 vtd_pasid_cache_psi(uint16_t domain, uint32_t pasid) "PASID slective PC invalidation domain 0x%"PRIx16" pasid 0x%"PRIx32
+vtd_pasid_cache_devsi(uint16_t devfn) "Dev slective PC invalidation dev: 0x%"PRIx16
 vtd_re_not_present(uint8_t bus) "Root entry bus %"PRIu8" not present"
 vtd_ce_not_present(uint8_t bus, uint8_t devfn) "Context entry bus %"PRIu8" devfn %"PRIu8" not present"
 vtd_iotlb_page_hit(uint16_t sid, uint64_t addr, uint64_t slpte, uint16_t domain) "IOTLB page hit sid 0x%"PRIx16" iova 0x%"PRIx64" slpte 0x%"PRIx64" domain 0x%"PRIx16
-- 
2.7.4

