Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C665432A74F
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839246AbhCBQGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:06:38 -0500
Received: from mga07.intel.com ([134.134.136.100]:51835 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447299AbhCBMwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:52:03 -0500
IronPort-SDR: 4/5YqzU7IXtKHPLZ1YaaaAIpPOIG8Df4XYEffFKuzhHbsecNCTr4HIQi4+O4dWDu1SALV2NGZY
 TZ8qe0qpgiHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="250841488"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="250841488"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:41:17 -0800
IronPort-SDR: ry6vW2O0Hnmty08Um75OoKIWLQePwpN4U1pQ/eFxpwBAX0KEq9FuaIvLtBcgriSsSlt34nTA5q
 2NtzGJnzGFCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427473171"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:41:12 -0800
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
Subject: [RFC v11 23/25] intel_iommu: propagate PASID-based iotlb invalidation to host
Date:   Wed,  3 Mar 2021 04:38:25 +0800
Message-Id: <20210302203827.437645-24-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch propagates PASID-based iotlb invalidation to host.

Intel VT-d 3.0 supports nested translation in PASID granular.
Guest SVA support could be implemented by configuring nested
translation on specific PASID. This is also known as dual stage
DMA translation.

Under such configuration, guest owns the GVA->GPA translation
which is configured as first level page table in host side for
a specific pasid, and host owns GPA->HPA translation. As guest
owns first level translation table, piotlb invalidation should
be propagated to host since host IOMMU will cache first level
page table related mappings during DMA address translation.

This patch traps the guest PASID-based iotlb flush and propagate
it to host.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
rfcv4 (v1) -> rfcv5 (v2):
*) removed the valid check to vtd_pasid_as instance as rfcv5 ensures
   all vtd_pasid_as instances in hash table should be valid.
---
 hw/i386/intel_iommu.c          | 113 +++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |   7 ++
 2 files changed, 120 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index b709440b15..915db7ad1f 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3083,16 +3083,129 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
     return !pc_info.error_happened ? true : false;
 }
 
+/**
+ * Caller of this function should hold iommu_lock.
+ */
+static void vtd_invalidate_piotlb(IntelIOMMUState *s,
+                                  VTDBus *vtd_bus,
+                                  int devfn,
+                                  struct iommu_cache_invalidate_info *cache)
+{
+    VTDHostIOMMUContext *vtd_dev_icx;
+    HostIOMMUContext *iommu_ctx;
+
+    vtd_dev_icx = vtd_bus->dev_icx[devfn];
+    if (!vtd_dev_icx) {
+        goto out;
+    }
+    iommu_ctx = vtd_dev_icx->iommu_ctx;
+    if (!iommu_ctx) {
+        goto out;
+    }
+    if (host_iommu_ctx_flush_stage1_cache(iommu_ctx, cache)) {
+        error_report("Cache flush failed");
+    }
+out:
+    return;
+}
+
+/**
+ * This function is a loop function for the s->vtd_pasid_as
+ * list with VTDPIOTLBInvInfo as execution filter. It propagates
+ * the piotlb invalidation to host. Caller of this function
+ * should hold iommu_lock.
+ */
+static void vtd_flush_pasid_iotlb(gpointer key, gpointer value,
+                                  gpointer user_data)
+{
+    VTDPIOTLBInvInfo *piotlb_info = user_data;
+    VTDPASIDAddressSpace *vtd_pasid_as = value;
+    VTDPASIDCacheEntry *pc_entry = &vtd_pasid_as->pasid_cache_entry;
+    uint16_t did;
+
+    did = vtd_pe_get_domain_id(&pc_entry->pasid_entry);
+
+    if ((piotlb_info->domain_id == did) &&
+        (piotlb_info->pasid == vtd_pasid_as->pasid)) {
+        vtd_invalidate_piotlb(vtd_pasid_as->iommu_state,
+                              vtd_pasid_as->vtd_bus,
+                              vtd_pasid_as->devfn,
+                              piotlb_info->cache_info);
+    }
+
+    /*
+     * TODO: needs to add QEMU piotlb flush when QEMU piotlb
+     * infrastructure is ready. For now, it is enough for passthru
+     * devices.
+     */
+}
+
 static void vtd_piotlb_pasid_invalidate(IntelIOMMUState *s,
                                         uint16_t domain_id,
                                         uint32_t pasid)
 {
+    VTDPIOTLBInvInfo piotlb_info;
+    struct iommu_cache_invalidate_info *cache_info;
+
+    cache_info = g_malloc0(sizeof(*cache_info));
+
+    cache_info->argsz = sizeof(*cache_info);
+    cache_info->version = IOMMU_CACHE_INVALIDATE_INFO_VERSION_1;
+    cache_info->cache = IOMMU_CACHE_INV_TYPE_IOTLB;
+    cache_info->granularity = IOMMU_INV_GRANU_PASID;
+    cache_info->granu.pasid_info.pasid = pasid;
+    cache_info->granu.pasid_info.flags = IOMMU_INV_PASID_FLAGS_PASID;
+
+    piotlb_info.domain_id = domain_id;
+    piotlb_info.pasid = pasid;
+    piotlb_info.cache_info = cache_info;
+
+    vtd_iommu_lock(s);
+    /*
+     * Here loops all the vtd_pasid_as instances in s->vtd_pasid_as
+     * to find out the affected devices since piotlb invalidation
+     * should check pasid cache per architecture point of view.
+     */
+    g_hash_table_foreach(s->vtd_pasid_as,
+                         vtd_flush_pasid_iotlb, &piotlb_info);
+    vtd_iommu_unlock(s);
+    g_free(cache_info);
 }
 
 static void vtd_piotlb_page_invalidate(IntelIOMMUState *s, uint16_t domain_id,
                                        uint32_t pasid, hwaddr addr, uint8_t am,
                                        bool ih)
 {
+    VTDPIOTLBInvInfo piotlb_info;
+    struct iommu_cache_invalidate_info *cache_info;
+
+    cache_info = g_malloc0(sizeof(*cache_info));
+
+    cache_info->argsz = sizeof(*cache_info);
+    cache_info->version = IOMMU_CACHE_INVALIDATE_INFO_VERSION_1;
+    cache_info->cache = IOMMU_CACHE_INV_TYPE_IOTLB;
+    cache_info->granularity = IOMMU_INV_GRANU_ADDR;
+    cache_info->granu.addr_info.flags = IOMMU_INV_ADDR_FLAGS_PASID;
+    cache_info->granu.addr_info.flags |= ih ? IOMMU_INV_ADDR_FLAGS_LEAF : 0;
+    cache_info->granu.addr_info.pasid = pasid;
+    cache_info->granu.addr_info.addr = addr;
+    cache_info->granu.addr_info.granule_size = 1 << (12 + am);
+    cache_info->granu.addr_info.nb_granules = 1;
+
+    piotlb_info.domain_id = domain_id;
+    piotlb_info.pasid = pasid;
+    piotlb_info.cache_info = cache_info;
+
+    vtd_iommu_lock(s);
+    /*
+     * Here loops all the vtd_pasid_as instances in s->vtd_pasid_as
+     * to find out the affected devices since piotlb invalidation
+     * should check pasid cache per architecture point of view.
+     */
+    g_hash_table_foreach(s->vtd_pasid_as,
+                         vtd_flush_pasid_iotlb, &piotlb_info);
+    vtd_iommu_unlock(s);
+    g_free(cache_info);
 }
 
 static bool vtd_process_piotlb_desc(IntelIOMMUState *s,
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 24b5f934c3..7fbdd53b60 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -576,6 +576,13 @@ struct VTDPASIDCacheInfo {
 };
 typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 
+struct VTDPIOTLBInvInfo {
+    uint16_t domain_id;
+    uint32_t pasid;
+    struct iommu_cache_invalidate_info *cache_info;
+};
+typedef struct VTDPIOTLBInvInfo VTDPIOTLBInvInfo;
+
 /* PASID Table Related Definitions */
 #define VTD_PASID_DIR_BASE_ADDR_MASK  (~0xfffULL)
 #define VTD_PASID_TABLE_BASE_ADDR_MASK (~0xfffULL)
-- 
2.25.1

