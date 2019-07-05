Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91AC6105A
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfGFLTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbfGFLTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355017"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:14 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 09/18] intel_iommu: process pasid cache invalidation
Date:   Fri,  5 Jul 2019 19:01:42 +0800
Message-Id: <1562324511-2910-10-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds PASID cache flush emulation framework. Per Intel VT-d 3.0
spec, PASID cache invalidation under caching-mode provides a mechanism
software Intel VT-d(vIOMMU) implementations to track guest PASID bind/unbind
operations. This is a key part of vIOMMU support for guest SVA. And this
patch only adds the frame of it. The detailed implementation relies on
PASID records management implementation in vIOMMU, which will be covered
in later patch of this series.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 40 +++++++++++++++++++++++++++++++++++-----
 hw/i386/intel_iommu_internal.h | 12 ++++++++++++
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 3cf250d..ef13662 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2331,6 +2331,37 @@ static bool vtd_process_iotlb_desc(IntelIOMMUState *s, VTDInvDesc *inv_desc)
     return true;
 }
 
+static bool vtd_process_pasid_desc(IntelIOMMUState *s,
+                                   VTDInvDesc *inv_desc)
+{
+    if ((inv_desc->val[0] & VTD_INV_DESC_PASIDC_RSVD_VAL0) ||
+        (inv_desc->val[1] & VTD_INV_DESC_PASIDC_RSVD_VAL1) ||
+        (inv_desc->val[2] & VTD_INV_DESC_PASIDC_RSVD_VAL2) ||
+        (inv_desc->val[3] & VTD_INV_DESC_PASIDC_RSVD_VAL3)) {
+        trace_vtd_inv_desc("non-zero-field-in-pc_inv_desc",
+                            inv_desc->val[1], inv_desc->val[0]);
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
+        trace_vtd_inv_desc("invalid-inv-granu-in-pc_inv_desc",
+                            inv_desc->val[1], inv_desc->val[0]);
+        return false;
+    }
+
+    return true;
+}
+
 static bool vtd_process_inv_iec_desc(IntelIOMMUState *s,
                                      VTDInvDesc *inv_desc)
 {
@@ -2437,12 +2468,11 @@ static bool vtd_process_inv_desc(IntelIOMMUState *s)
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
index f5a2f0d..e335800 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -436,6 +436,18 @@ typedef union VTDInvDesc VTDInvDesc;
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
-- 
2.7.4

