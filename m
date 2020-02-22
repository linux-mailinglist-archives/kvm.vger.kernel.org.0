Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCED168D68
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgBVICX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:02:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:63022 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgBVICA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:02:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547683"
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
Subject: [RFC v3.1 11/22] intel_iommu: process pasid cache invalidation
Date:   Sat, 22 Feb 2020 00:07:12 -0800
Message-Id: <1582358843-51931-12-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
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
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 66 ++++++++++++++++++++++++++++++++++++++----
 hw/i386/intel_iommu_internal.h | 12 ++++++++
 hw/i386/trace-events           |  3 ++
 3 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index fcb80cd..462449c 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2393,6 +2393,63 @@ static bool vtd_process_iotlb_desc(IntelIOMMUState *s, VTDInvDesc *inv_desc)
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
@@ -2499,12 +2556,11 @@ static bool vtd_process_inv_desc(IntelIOMMUState *s)
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
index 1d997a1..0ca5f0b 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -444,6 +444,18 @@ typedef union VTDInvDesc VTDInvDesc;
         (0x3ffff800ULL | ~(VTD_HAW_MASK(aw) | VTD_SL_IGN_COM | VTD_SL_TM)) : \
         (0x3ffff800ULL | ~(VTD_HAW_MASK(aw) | VTD_SL_IGN_COM))
 
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
index 71536a7..f7cd4e5 100644
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

