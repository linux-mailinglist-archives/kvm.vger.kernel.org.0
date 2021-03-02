Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A161B32A73E
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839140AbhCBQFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:05:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:51850 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243566AbhCBMpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:45:01 -0500
IronPort-SDR: olrGH1IPwQkKsShlnOYYjcX6RTg8TPg3vR9VqYKNw92Zw2it+Sz6MRcIDxuQehAgT2raCcmLYE
 r7KD+OCjXD0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="250841365"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="250841365"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:40:43 -0800
IronPort-SDR: e9oayeS8me02jaknIuo/+Jgr5LFf0gWaxiL2QqfyJiGbS4GD0Wlhfco3vfFmXgmXMJM6Yekikw
 u5OWYO1AGJTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427473029"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:40:39 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Lingshan.Zhu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v11 16/25] intel_iommu: process PASID cache invalidation
Date:   Wed,  3 Mar 2021 04:38:18 +0800
Message-Id: <20210302203827.437645-17-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
rfcv4 (v1) -> rfcv5 (v2):
*) remove vtd_pasid_cache_gsi(), vtd_pasid_cache_psi()
   and vtd_pasid_cache_dsi()
---
 hw/i386/intel_iommu.c          | 40 +++++++++++++++++++++++++++++-----
 hw/i386/intel_iommu_internal.h | 12 ++++++++++
 hw/i386/trace-events           |  3 +++
 3 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 7786f97ed6..c4b0db15cb 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2421,6 +2421,37 @@ static bool vtd_process_iotlb_desc(IntelIOMMUState *s, VTDInvDesc *inv_desc)
     return true;
 }
 
+static bool vtd_process_pasid_desc(IntelIOMMUState *s,
+                                   VTDInvDesc *inv_desc)
+{
+    if ((inv_desc->val[0] & VTD_INV_DESC_PASIDC_RSVD_VAL0) ||
+        (inv_desc->val[1] & VTD_INV_DESC_PASIDC_RSVD_VAL1) ||
+        (inv_desc->val[2] & VTD_INV_DESC_PASIDC_RSVD_VAL2) ||
+        (inv_desc->val[3] & VTD_INV_DESC_PASIDC_RSVD_VAL3)) {
+        error_report_once("non-zero-field-in-pc_inv_desc hi: 0x%" PRIx64
+                  " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
+        return false;
+    }
+
+    switch (inv_desc->val[0] & VTD_INV_DESC_PASIDC_G) {
+    case VTD_INV_DESC_PASIDC_DSI:
+        break;
+
+    case VTD_INV_DESC_PASIDC_PASID_SI:
+        break;
+
+    case VTD_INV_DESC_PASIDC_GLOBAL:
+        break;
+
+    default:
+        error_report_once("invalid-inv-granu-in-pc_inv_desc hi: 0x%" PRIx64
+                  " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
+        return false;
+    }
+
+    return true;
+}
+
 static bool vtd_process_inv_iec_desc(IntelIOMMUState *s,
                                      VTDInvDesc *inv_desc)
 {
@@ -2528,12 +2559,11 @@ static bool vtd_process_inv_desc(IntelIOMMUState *s)
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
index 6abb4836a1..3c8853ab88 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -463,6 +463,18 @@ typedef union VTDInvDesc VTDInvDesc;
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
index 71536a7c20..f7cd4e5656 100644
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
2.25.1

