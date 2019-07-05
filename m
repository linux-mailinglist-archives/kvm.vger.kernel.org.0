Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E34D61062
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfGFLTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfGFLTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355073"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:36 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 17/18] intel_iommu: propagate PASID-based iotlb flush to host
Date:   Fri,  5 Jul 2019 19:01:50 +0800
Message-Id: <1562324511-2910-18-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel VT-d 3.0 supports nested translation in PASID granularity. For guest
SVA support, nested translation is enabled for specific PASID. In such case,
guest owns the GVA->GPA translation which is configured as first level page
table in host side for a specific pasid, and host owns GPA->HPA translation.
As guest owns first level translation table, guest's PASID-based IOTLB(piotlb)
flush should be propagated to host since host IOMMU will cache first level
page table related mappings during DMA address translation.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/i386/intel_iommu.c          | 68 ++++++++++++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |  7 +++++
 2 files changed, 75 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 7a778d8..e4286e5 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2516,15 +2516,83 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
     return (ret == 0) ? true : false;
 }
 
+static inline bool vtd_pasid_cache_valid(VTDAddressSpace *vtd_pasid_as)
+{
+    return (vtd_pasid_as->iommu_state->pasid_cache_gen &&
+            (vtd_pasid_as->iommu_state->pasid_cache_gen
+             == vtd_pasid_as->pasid_cache_entry.pasid_cache_gen));
+}
+
+static void vtd_flush_pasid_iotlb(gpointer key, gpointer value,
+                                  gpointer user_data)
+{
+    VTDPIOTLBInvInfo *piotlb_info = user_data;
+    VTDAddressSpace *vtd_pasid_as = value;
+    uint16_t did;
+
+    /*
+     * Actually, needs to check whether the pasid entry cache stored in
+     * vtd_pasid_as is valid or not. "invalid" means the pasid cache
+     * has been flushed, thus host should have done such piotlb flush,
+     * no need to pass down piotlb flush to host. Only when pasid entry
+     * cache is "valid", should a piotlb flush pass down to host. Because
+     * In such case, it is due to mapping changes in guest, a piotlb flush
+     * in host is required.
+     */
+    if (!vtd_pasid_as || !vtd_pasid_cache_valid(vtd_pasid_as)) {
+        return;
+    }
+
+    did = vtd_pe_get_domain_id(
+                &(vtd_pasid_as->pasid_cache_entry.pasid_entry));
+    /*
+     * vtd_pasid_as should be non-NULL and the pasid_cache_gen
+     * should be non-zero. If vtd_pasid_as management is clean,
+     * the vtd_pasid_as is non-NULL is enough.
+     */
+    if ((piotlb_info->domain_id == did) &&
+        (piotlb_info->pasid == vtd_pasid_as->pasid)) {
+        pci_device_flush_pasid_iotlb(vtd_pasid_as->bus,
+                            vtd_pasid_as->devfn, &piotlb_info->tlb_info);
+    }
+}
+
 static void vtd_piotlb_pasid_invalidate(IntelIOMMUState *s,
                                         uint16_t domain_id,
                                         uint32_t pasid)
 {
+    VTDPIOTLBInvInfo piotlb_info;
+    struct iommu_cache_invalidate_info *inv_info = &piotlb_info.tlb_info;
+
+    piotlb_info.domain_id = domain_id;
+    piotlb_info.pasid = pasid;
+    inv_info->version = IOMMU_CACHE_INVALIDATE_INFO_VERSION_1;
+    inv_info->cache = IOMMU_CACHE_INV_TYPE_IOTLB;
+    inv_info->granularity = IOMMU_INV_GRANU_PASID;
+    inv_info->pasid_info.pasid = pasid;
+    inv_info->pasid_info.flags = IOMMU_INV_PASID_FLAGS_PASID;
+    g_hash_table_foreach(s->vtd_pasid_as, vtd_flush_pasid_iotlb, &piotlb_info);
 }
 
 static void vtd_piotlb_page_invalidate(IntelIOMMUState *s, uint16_t domain_id,
                              uint32_t pasid, hwaddr addr, uint8_t am, bool ih)
 {
+    VTDPIOTLBInvInfo piotlb_info;
+    struct iommu_cache_invalidate_info *inv_info = &piotlb_info.tlb_info;
+
+    piotlb_info.domain_id = domain_id;
+    piotlb_info.pasid = pasid;
+    inv_info->version = IOMMU_CACHE_INVALIDATE_INFO_VERSION_1;
+    inv_info->cache = IOMMU_CACHE_INV_TYPE_IOTLB;
+    inv_info->granularity = IOMMU_INV_GRANU_ADDR;
+    inv_info->addr_info.flags = IOMMU_INV_ADDR_FLAGS_PASID;
+    inv_info->addr_info.flags |= ih ? IOMMU_INV_ADDR_FLAGS_LEAF : 0;
+    inv_info->addr_info.pasid = pasid;
+    inv_info->addr_info.addr = addr;
+    inv_info->addr_info.granule_size = 1 << (12 + am);
+    inv_info->addr_info.nb_granules = 1;
+
+    g_hash_table_foreach(s->vtd_pasid_as, vtd_flush_pasid_iotlb, &piotlb_info);
 }
 
 static bool vtd_process_piotlb_desc(IntelIOMMUState *s,
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 69cd879..556ea8d 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -506,6 +506,13 @@ struct VTDPASIDCacheInfo {
 };
 typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 
+struct VTDPIOTLBInvInfo {
+    uint16_t domain_id;
+    uint32_t pasid;
+    struct iommu_cache_invalidate_info tlb_info;
+};
+typedef struct VTDPIOTLBInvInfo VTDPIOTLBInvInfo;
+
 /* Masks for struct VTDRootEntry */
 #define VTD_ROOT_ENTRY_P            1ULL
 #define VTD_ROOT_ENTRY_CTP          (~0xfffULL)
-- 
2.7.4

