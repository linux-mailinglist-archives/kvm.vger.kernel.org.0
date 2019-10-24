Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0C8E334B
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502291AbfJXNBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:5208 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502296AbfJXNBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156277"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:42 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 12/22] intel_iommu: add present bit check for pasid table entries
Date:   Thu, 24 Oct 2019 08:34:33 -0400
Message-Id: <1571920483-3382-13-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The present bit check for pasid entry (pe) and pasid directory
entry (pdire) were missed in previous commits as fpd bit check
doesn't require present bit as "Set". This patch adds the present
bit check for callers which wants to get a valid pe/pdire.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 92 +++++++++++++++++++++++++++++++++---------
 hw/i386/intel_iommu_internal.h |  1 +
 2 files changed, 74 insertions(+), 19 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 84ff6f0..90b8f6c 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -686,9 +686,18 @@ static inline bool vtd_pe_type_check(X86IOMMUState *x86_iommu,
     return true;
 }
 
-static int vtd_get_pasid_dire(dma_addr_t pasid_dir_base,
-                              uint32_t pasid,
-                              VTDPASIDDirEntry *pdire)
+static inline bool vtd_pdire_present(VTDPASIDDirEntry *pdire)
+{
+    return pdire->val & 1;
+}
+
+/**
+ * Caller of this function should check present bit if wants
+ * to use pdir entry for futher usage except for fpd bit check.
+ */
+static int vtd_get_pdire_from_pdir_table(dma_addr_t pasid_dir_base,
+                                         uint32_t pasid,
+                                         VTDPASIDDirEntry *pdire)
 {
     uint32_t index;
     dma_addr_t addr, entry_size;
@@ -703,18 +712,22 @@ static int vtd_get_pasid_dire(dma_addr_t pasid_dir_base,
     return 0;
 }
 
-static int vtd_get_pasid_entry(IntelIOMMUState *s,
-                               uint32_t pasid,
-                               VTDPASIDDirEntry *pdire,
-                               VTDPASIDEntry *pe)
+static inline bool vtd_pe_present(VTDPASIDEntry *pe)
+{
+    return pe->val[0] & VTD_PASID_ENTRY_P;
+}
+
+static int vtd_get_pe_in_pasid_leaf_table(IntelIOMMUState *s,
+                                          uint32_t pasid,
+                                          dma_addr_t addr,
+                                          VTDPASIDEntry *pe)
 {
     uint32_t index;
-    dma_addr_t addr, entry_size;
+    dma_addr_t entry_size;
     X86IOMMUState *x86_iommu = X86_IOMMU_DEVICE(s);
 
     index = VTD_PASID_TABLE_INDEX(pasid);
     entry_size = VTD_PASID_ENTRY_SIZE;
-    addr = pdire->val & VTD_PASID_TABLE_BASE_ADDR_MASK;
     addr = addr + index * entry_size;
     if (dma_memory_read(&address_space_memory, addr, pe, entry_size)) {
         return -VTD_FR_PASID_TABLE_INV;
@@ -732,25 +745,54 @@ static int vtd_get_pasid_entry(IntelIOMMUState *s,
     return 0;
 }
 
-static int vtd_get_pasid_entry_from_pasid(IntelIOMMUState *s,
-                                          dma_addr_t pasid_dir_base,
-                                          uint32_t pasid,
-                                          VTDPASIDEntry *pe)
+/**
+ * Caller of this function should check present bit if wants
+ * to use pasid entry for futher usage except for fpd bit check.
+ */
+static int vtd_get_pe_from_pdire(IntelIOMMUState *s,
+                                 uint32_t pasid,
+                                 VTDPASIDDirEntry *pdire,
+                                 VTDPASIDEntry *pe)
+{
+    dma_addr_t addr = pdire->val & VTD_PASID_TABLE_BASE_ADDR_MASK;
+
+    return vtd_get_pe_in_pasid_leaf_table(s, pasid, addr, pe);
+}
+
+/**
+ * This function gets a pasid entry from a specified pasid
+ * table (includes dir and leaf table) with a specified pasid.
+ * Sanity check should be done to ensure return a present
+ * pasid entry to caller.
+ */
+static int vtd_get_pe_from_pasid_table(IntelIOMMUState *s,
+                                       dma_addr_t pasid_dir_base,
+                                       uint32_t pasid,
+                                       VTDPASIDEntry *pe)
 {
     int ret;
     VTDPASIDDirEntry pdire;
 
-    ret = vtd_get_pasid_dire(pasid_dir_base, pasid, &pdire);
+    ret = vtd_get_pdire_from_pdir_table(pasid_dir_base,
+                                        pasid, &pdire);
     if (ret) {
         return ret;
     }
 
-    ret = vtd_get_pasid_entry(s, pasid, &pdire, pe);
+    if (!vtd_pdire_present(&pdire)) {
+        return -VTD_FR_PASID_TABLE_INV;
+    }
+
+    ret = vtd_get_pe_from_pdire(s, pasid, &pdire, pe);
     if (ret) {
         return ret;
     }
 
-    return ret;
+    if (!vtd_pe_present(pe)) {
+        return -VTD_FR_PASID_TABLE_INV;
+    }
+
+    return 0;
 }
 
 static int vtd_ce_get_rid2pasid_entry(IntelIOMMUState *s,
@@ -763,7 +805,7 @@ static int vtd_ce_get_rid2pasid_entry(IntelIOMMUState *s,
 
     pasid = VTD_CE_GET_RID2PASID(ce);
     pasid_dir_base = VTD_CE_GET_PASID_DIR_TABLE(ce);
-    ret = vtd_get_pasid_entry_from_pasid(s, pasid_dir_base, pasid, pe);
+    ret = vtd_get_pe_from_pasid_table(s, pasid_dir_base, pasid, pe);
 
     return ret;
 }
@@ -781,7 +823,11 @@ static int vtd_ce_get_pasid_fpd(IntelIOMMUState *s,
     pasid = VTD_CE_GET_RID2PASID(ce);
     pasid_dir_base = VTD_CE_GET_PASID_DIR_TABLE(ce);
 
-    ret = vtd_get_pasid_dire(pasid_dir_base, pasid, &pdire);
+    /*
+     * No present bit check since fpd is meaningful even
+     * if the present bit is clear.
+     */
+    ret = vtd_get_pdire_from_pdir_table(pasid_dir_base, pasid, &pdire);
     if (ret) {
         return ret;
     }
@@ -791,7 +837,15 @@ static int vtd_ce_get_pasid_fpd(IntelIOMMUState *s,
         return 0;
     }
 
-    ret = vtd_get_pasid_entry(s, pasid, &pdire, &pe);
+    if (!vtd_pdire_present(&pdire)) {
+        return -VTD_FR_PASID_TABLE_INV;
+    }
+
+    /*
+     * No present bit check since fpd is meaningful even
+     * if the present bit is clear.
+     */
+    ret = vtd_get_pe_from_pdire(s, pasid, &pdire, &pe);
     if (ret) {
         return ret;
     }
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index c6cb28b..879211e 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -529,6 +529,7 @@ typedef struct VTDRootEntry VTDRootEntry;
 #define VTD_PASID_ENTRY_FPD           (1ULL << 1) /* Fault Processing Disable */
 
 /* PASID Granular Translation Type Mask */
+#define VTD_PASID_ENTRY_P              1ULL
 #define VTD_SM_PASID_ENTRY_PGTT        (7ULL << 6)
 #define VTD_SM_PASID_ENTRY_FLT         (1ULL << 6)
 #define VTD_SM_PASID_ENTRY_SLT         (2ULL << 6)
-- 
2.7.4

