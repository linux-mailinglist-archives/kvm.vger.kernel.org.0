Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9F261061
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfGFLTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfGFLTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355063"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:34 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 16/18] intel_iommu: add PASID-based iotlb invalidation support
Date:   Fri,  5 Jul 2019 19:01:49 +0800
Message-Id: <1562324511-2910-17-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PASID-based IOTLB (piotlb) is used during walking Intel VT-d first-level
page table. This patch adds frame of processing for PASID-based IOTLB flush.
Detailed processing is in next patch of this patchset.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 61 ++++++++++++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h | 13 +++++++++
 hw/i386/trace-events           |  1 +
 3 files changed, 75 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 3b213a4..7a778d8 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2516,6 +2516,63 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
     return (ret == 0) ? true : false;
 }
 
+static void vtd_piotlb_pasid_invalidate(IntelIOMMUState *s,
+                                        uint16_t domain_id,
+                                        uint32_t pasid)
+{
+}
+
+static void vtd_piotlb_page_invalidate(IntelIOMMUState *s, uint16_t domain_id,
+                             uint32_t pasid, hwaddr addr, uint8_t am, bool ih)
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
+        trace_vtd_piotlb_inv("Non-zreo reserved field",
+                          inv_desc->val[1], inv_desc->val[0]);
+        return false;
+    }
+
+    domain_id = VTD_INV_DESC_PIOTLB_DID(inv_desc->val[0]);
+    pasid = VTD_INV_DESC_PIOTLB_PASID(inv_desc->val[0]);
+    switch (inv_desc->val[0] & VTD_INV_DESC_IOTLB_G) {
+    case VTD_INV_DESC_PIOTLB_ALL_IN_PASID:
+        trace_vtd_piotlb_inv("PASID selectived piotlb flush",
+                          inv_desc->val[1], inv_desc->val[0]);
+        vtd_piotlb_pasid_invalidate(s, domain_id, pasid);
+        break;
+
+    case VTD_INV_DESC_PIOTLB_PSI_IN_PASID:
+        am = VTD_INV_DESC_PIOTLB_AM(inv_desc->val[1]);
+        addr = (hwaddr) VTD_INV_DESC_PIOTLB_ADDR(inv_desc->val[1]);
+        trace_vtd_piotlb_inv("Page selective piotlb flush within a PASID",
+                          inv_desc->val[1], inv_desc->val[0]);
+        if (am > VTD_MAMV) {
+            trace_vtd_piotlb_inv("Invalid am, > max am value",
+                          inv_desc->val[1], inv_desc->val[0]);
+            return false;
+        }
+        vtd_piotlb_page_invalidate(s, domain_id, pasid,
+             addr, am, VTD_INV_DESC_PIOTLB_IH(inv_desc->val[1]));
+        break;
+
+    default:
+        trace_vtd_piotlb_inv("Invalid granularity in P-IOTLB desc",
+                          inv_desc->val[1], inv_desc->val[0]);
+        return false;
+    }
+    return true;
+}
+
 static bool vtd_process_inv_iec_desc(IntelIOMMUState *s,
                                      VTDInvDesc *inv_desc)
 {
@@ -2630,6 +2687,10 @@ static bool vtd_process_inv_desc(IntelIOMMUState *s)
         break;
 
     case VTD_INV_DESC_PIOTLB:
+        trace_vtd_inv_desc("p-iotlb", inv_desc.val[1], inv_desc.val[0]);
+        if (!vtd_process_piotlb_desc(s, &inv_desc)) {
+            return false;
+        }
         break;
 
     case VTD_INV_DESC_WAIT:
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 021d358..69cd879 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -449,6 +449,19 @@ typedef union VTDInvDesc VTDInvDesc;
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
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index 25bd6a4..2338be7 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -16,6 +16,7 @@ vtd_inv_desc_wait_sw(uint64_t addr, uint32_t data) "wait invalidate status write
 vtd_inv_desc_wait_irq(const char *msg) "%s"
 vtd_inv_desc_wait_write_fail(uint64_t hi, uint64_t lo) "write fail for wait desc hi 0x%"PRIx64" lo 0x%"PRIx64
 vtd_inv_desc_iec(uint32_t granularity, uint32_t index, uint32_t mask) "granularity 0x%"PRIx32" index 0x%"PRIx32" mask 0x%"PRIx32
+vtd_piotlb_inv(const char *type, uint64_t hi, uint64_t lo) "invalidate desc type %s high 0x%"PRIx64" low 0x%"PRIx64
 vtd_inv_qi_enable(bool enable) "enabled %d"
 vtd_inv_qi_setup(uint64_t addr, int size) "addr 0x%"PRIx64" size %d"
 vtd_inv_qi_head(uint16_t head) "read head %d"
-- 
2.7.4

