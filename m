Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA6B32A747
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839206AbhCBQGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:06:06 -0500
Received: from mga07.intel.com ([134.134.136.100]:51767 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350791AbhCBMub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:50:31 -0500
IronPort-SDR: MvQxM/3+mXVTKhc80duBtxZf6H8pLvaa+gXh84x0i/2XtjpmMEODCgOcP8u5t9qlY0/JMtiSrf
 kiy1zL8hcang==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="250841468"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="250841468"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:41:12 -0800
IronPort-SDR: mrfL1o7bgIg81x7iND/b/W5NLqXKxtQYDhF8QG+9sUwhr96Sq9kYXVniPkDUzQApM3U2mFI+cX
 StwnrH+aJFEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427473147"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:41:07 -0800
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
Subject: [RFC v11 22/25] intel_iommu: process PASID-based iotlb invalidation
Date:   Wed,  3 Mar 2021 04:38:24 +0800
Message-Id: <20210302203827.437645-23-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds the basic PASID-based iotlb (piotlb) invalidation
support. piotlb is used during walking Intel VT-d 1st level page
table. This patch only adds the basic processing. Detailed handling
will be added in next patch.

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
 hw/i386/intel_iommu.c          | 53 ++++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h | 13 +++++++++
 2 files changed, 66 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 740dc63090..b709440b15 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3083,6 +3083,55 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
     return !pc_info.error_happened ? true : false;
 }
 
+static void vtd_piotlb_pasid_invalidate(IntelIOMMUState *s,
+                                        uint16_t domain_id,
+                                        uint32_t pasid)
+{
+}
+
+static void vtd_piotlb_page_invalidate(IntelIOMMUState *s, uint16_t domain_id,
+                                       uint32_t pasid, hwaddr addr, uint8_t am,
+                                       bool ih)
+{
+}
+
+static bool vtd_process_piotlb_desc(IntelIOMMUState *s,
+                                    VTDInvDesc *inv_desc)
+{
+    uint16_t domain_id;
+    uint32_t pasid;
+    uint8_t am;
+    hwaddr addr;
+
+    if ((inv_desc->val[0] & VTD_INV_DESC_PIOTLB_RSVD_VAL0) ||
+        (inv_desc->val[1] & VTD_INV_DESC_PIOTLB_RSVD_VAL1)) {
+        error_report_once("non-zero-field-in-piotlb_inv_desc hi: 0x%" PRIx64
+                  " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
+        return false;
+    }
+
+    domain_id = VTD_INV_DESC_PIOTLB_DID(inv_desc->val[0]);
+    pasid = VTD_INV_DESC_PIOTLB_PASID(inv_desc->val[0]);
+    switch (inv_desc->val[0] & VTD_INV_DESC_IOTLB_G) {
+    case VTD_INV_DESC_PIOTLB_ALL_IN_PASID:
+        vtd_piotlb_pasid_invalidate(s, domain_id, pasid);
+        break;
+
+    case VTD_INV_DESC_PIOTLB_PSI_IN_PASID:
+        am = VTD_INV_DESC_PIOTLB_AM(inv_desc->val[1]);
+        addr = (hwaddr) VTD_INV_DESC_PIOTLB_ADDR(inv_desc->val[1]);
+        vtd_piotlb_page_invalidate(s, domain_id, pasid, addr, am,
+                                   VTD_INV_DESC_PIOTLB_IH(inv_desc->val[1]));
+        break;
+
+    default:
+        error_report_once("Invalid granularity in P-IOTLB desc hi: 0x%" PRIx64
+                  " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
+        return false;
+    }
+    return true;
+}
+
 static bool vtd_process_inv_iec_desc(IntelIOMMUState *s,
                                      VTDInvDesc *inv_desc)
 {
@@ -3198,6 +3247,10 @@ static bool vtd_process_inv_desc(IntelIOMMUState *s)
         break;
 
     case VTD_INV_DESC_PIOTLB:
+        trace_vtd_inv_desc("p-iotlb", inv_desc.val[1], inv_desc.val[0]);
+        if (!vtd_process_piotlb_desc(s, &inv_desc)) {
+            return false;
+        }
         break;
 
     case VTD_INV_DESC_WAIT:
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index eae57f457c..24b5f934c3 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -476,6 +476,19 @@ typedef union VTDInvDesc VTDInvDesc;
 #define VTD_INV_DESC_PASIDC_PASID_SI   (1ULL << 4)
 #define VTD_INV_DESC_PASIDC_GLOBAL     (3ULL << 4)
 
+#define VTD_INV_DESC_PIOTLB_ALL_IN_PASID  (2ULL << 4)
+#define VTD_INV_DESC_PIOTLB_PSI_IN_PASID  (3ULL << 4)
+
+#define VTD_INV_DESC_PIOTLB_RSVD_VAL0     0xfff000000000ffc0ULL
+#define VTD_INV_DESC_PIOTLB_RSVD_VAL1     0xf80ULL
+
+#define VTD_INV_DESC_PIOTLB_PASID(val)    (((val) >> 32) & 0xfffffULL)
+#define VTD_INV_DESC_PIOTLB_DID(val)      (((val) >> 16) & \
+                                             VTD_DOMAIN_ID_MASK)
+#define VTD_INV_DESC_PIOTLB_ADDR(val)     ((val) & ~0xfffULL)
+#define VTD_INV_DESC_PIOTLB_AM(val)       ((val) & 0x3fULL)
+#define VTD_INV_DESC_PIOTLB_IH(val)       (((val) >> 6) & 0x1)
+
 /* Information about page-selective IOTLB invalidate */
 struct VTDIOTLBPageInvInfo {
     uint16_t domain_id;
-- 
2.25.1

