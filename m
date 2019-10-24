Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8CA3E334F
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502322AbfJXNB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:5193 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502288AbfJXNBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156267"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:39 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 11/22] intel_iommu: process pasid cache invalidation
Date:   Thu, 24 Oct 2019 08:34:32 -0400
Message-Id: <1571920483-3382-12-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds PASID cache invalidation handling. When guest enabled
PASID usages (e.g. SVA), guest software should issue a proper PASID
cache invalidation when caching-mode is exposed. This patch only adds
the draft handling of pasid cache invalidation. Detailed handling will
be added in subsequent patches.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 66 ++++++++++++++++++++++++++++++++++++++----
 hw/i386/intel_iommu_internal.h | 12 ++++++++
 hw/i386/trace-events           |  3 ++
 3 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 88b843f..84ff6f0 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2335,6 +2335,63 @@ static bool vtd_process_iotlb_desc(IntelIOMMUState *s, VTDInvDesc *inv_desc)
     return true;
 }
 
+static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
+{
+    return 0;
+}
+
+static int vtd_pasid_cache_psi(IntelIOMMUState *s,
+                               uint16_t domain_id, uint32_t pasid)
+{
+    return 0;
+}
+
+static int vtd_pasid_cache_gsi(IntelIOMMUState *s)
+{
+    return 0;
+}
+
+static bool vtd_process_pasid_desc(IntelIOMMUState *s,
+                                   VTDInvDesc *inv_desc)
+{
+    uint16_t domain_id;
+    uint32_t pasid;
+    int ret = 0;
+
+    if ((inv_desc->val[0] & VTD_INV_DESC_PASIDC_RSVD_VAL0) ||
+        (inv_desc->val[1] & VTD_INV_DESC_PASIDC_RSVD_VAL1) ||
+        (inv_desc->val[2] & VTD_INV_DESC_PASIDC_RSVD_VAL2) ||
+        (inv_desc->val[3] & VTD_INV_DESC_PASIDC_RSVD_VAL3)) {
+        error_report_once("non-zero-field-in-pc_inv_desc hi: 0x%" PRIx64
+                  " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
+        return false;
+    }
+
+    domain_id = VTD_INV_DESC_PASIDC_DID(inv_desc->val[0]);
+    pasid = VTD_INV_DESC_PASIDC_PASID(inv_desc->val[0]);
+
+    switch (inv_desc->val[0] & VTD_INV_DESC_PASIDC_G) {
+    case VTD_INV_DESC_PASIDC_DSI:
+        ret = vtd_pasid_cache_dsi(s, domain_id);
+        break;
+
+    case VTD_INV_DESC_PASIDC_PASID_SI:
+        ret = vtd_pasid_cache_psi(s, domain_id, pasid);
+        break;
+
+    case VTD_INV_DESC_PASIDC_GLOBAL:
+        ret = vtd_pasid_cache_gsi(s);
+        break;
+
+    default:
+        error_report_once("invalid-inv-granu-in-pc_inv_desc hi: 0x%" PRIx64
+                  " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
+        return false;
+    }
+
+    return (ret == 0) ? true : false;
+}
+
 static bool vtd_process_inv_iec_desc(IntelIOMMUState *s,
                                      VTDInvDesc *inv_desc)
 {
@@ -2441,12 +2498,11 @@ static bool vtd_process_inv_desc(IntelIOMMUState *s)
         }
         break;
 
-    /*
-     * TODO: the entity of below two cases will be implemented in future series.
-     * To make guest (which integrates scalable mode support patch set in
-     * iommu driver) work, just return true is enough so far.
-     */
     case VTD_INV_DESC_PC:
+        trace_vtd_inv_desc("pasid-cache", inv_desc.val[1], inv_desc.val[0]);
+        if (!vtd_process_pasid_desc(s, &inv_desc)) {
+            return false;
+        }
         break;
 
     case VTD_INV_DESC_PIOTLB:
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 8668771..c6cb28b 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -445,6 +445,18 @@ typedef union VTDInvDesc VTDInvDesc;
 #define VTD_SPTE_LPAGE_L4_RSVD_MASK(aw) \
         (0x880ULL | ~(VTD_HAW_MASK(aw) | VTD_SL_IGN_COM))
 
+#define VTD_INV_DESC_PASIDC_G          (3ULL << 4)
+#define VTD_INV_DESC_PASIDC_PASID(val) (((val) >> 32) & 0xfffffULL)
+#define VTD_INV_DESC_PASIDC_DID(val)   (((val) >> 16) & VTD_DOMAIN_ID_MASK)
+#define VTD_INV_DESC_PASIDC_RSVD_VAL0  0xfff000000000ffc0ULL
+#define VTD_INV_DESC_PASIDC_RSVD_VAL1  0xffffffffffffffffULL
+#define VTD_INV_DESC_PASIDC_RSVD_VAL2  0xffffffffffffffffULL
+#define VTD_INV_DESC_PASIDC_RSVD_VAL3  0xffffffffffffffffULL
+
+#define VTD_INV_DESC_PASIDC_DSI        (0ULL << 4)
+#define VTD_INV_DESC_PASIDC_PASID_SI   (1ULL << 4)
+#define VTD_INV_DESC_PASIDC_GLOBAL     (3ULL << 4)
+
 /* Information about page-selective IOTLB invalidate */
 struct VTDIOTLBPageInvInfo {
     uint16_t domain_id;
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index 43c0314..6da8bd2 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -22,6 +22,9 @@ vtd_inv_qi_head(uint16_t head) "read head %d"
 vtd_inv_qi_tail(uint16_t head) "write tail %d"
 vtd_inv_qi_fetch(void) ""
 vtd_context_cache_reset(void) ""
+vtd_pasid_cache_gsi(void) ""
+vtd_pasid_cache_dsi(uint16_t domain) "Domian slective PC invalidation domain 0x%"PRIx16
+vtd_pasid_cache_psi(uint16_t domain, uint32_t pasid) "PASID slective PC invalidation domain 0x%"PRIx16" pasid 0x%"PRIx32
 vtd_re_not_present(uint8_t bus) "Root entry bus %"PRIu8" not present"
 vtd_ce_not_present(uint8_t bus, uint8_t devfn) "Context entry bus %"PRIu8" devfn %"PRIu8" not present"
 vtd_iotlb_page_hit(uint16_t sid, uint64_t addr, uint64_t slpte, uint16_t domain) "IOTLB page hit sid 0x%"PRIx16" iova 0x%"PRIx64" slpte 0x%"PRIx64" domain 0x%"PRIx16
-- 
2.7.4

