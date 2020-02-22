Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAEA9168D5F
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgBVICE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:02:04 -0500
Received: from mga04.intel.com ([192.55.52.120]:65092 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbgBVICD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:02:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547711"
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
Subject: [RFC v3.1 20/22] intel_iommu: propagate PASID-based iotlb invalidation to host
Date:   Sat, 22 Feb 2020 00:07:21 -0800
Message-Id: <1582358843-51931-21-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
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
 hw/i386/intel_iommu.c          | 131 +++++++++++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |   7 +++
 2 files changed, 138 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index b712eae..e6326ef 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3157,15 +3157,146 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
     return (ret == 0) ? true : false;
 }
 
+static void vtd_invalidate_piotlb(IntelIOMMUState *s,
+                                  VTDBus *vtd_bus,
+                                  int devfn,
+                                  DualIOMMUStage1Cache *stage1_cache)
+{
+    PCIDevice *dev;
+    HostIOMMUContext *host_icx;
+    dev = vtd_bus->bus->devices[devfn];
+
+    host_icx = pci_device_host_iommu_context(dev);
+    if (!host_icx) {
+        return;
+    }
+    if (host_iommu_ctx_flush_stage1_cache(host_icx, stage1_cache)) {
+        error_report("Cache flush failed");
+    }
+}
+
+static inline bool vtd_pasid_cache_valid(
+                          VTDPASIDAddressSpace *vtd_pasid_as)
+{
+    return vtd_pasid_as->iommu_state &&
+           (vtd_pasid_as->iommu_state->pasid_cache_gen
+             == vtd_pasid_as->pasid_cache_entry.pasid_cache_gen);
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
+    uint16_t did;
+
+    /*
+     * Needs to check whether the pasid entry cache stored in
+     * vtd_pasid_as is valid or not. "invalid" means the pasid
+     * cache has been flushed, thus host should have done piotlb
+     * invalidation together with a pasid cache invalidation, so
+     * no need to pass down piotlb invalidation to host for better
+     * performance. Only when pasid entry cache is "valid", should
+     * a piotlb invalidation be propagated to host since it means
+     * guest just modified a mapping in its page table.
+     */
+    if (!vtd_pasid_cache_valid(vtd_pasid_as)) {
+        return;
+    }
+
+    did = vtd_pe_get_domain_id(
+                &(vtd_pasid_as->pasid_cache_entry.pasid_entry));
+
+    if ((piotlb_info->domain_id == did) &&
+        (piotlb_info->pasid == vtd_pasid_as->pasid)) {
+        vtd_invalidate_piotlb(vtd_pasid_as->iommu_state,
+                              vtd_pasid_as->vtd_bus,
+                              vtd_pasid_as->devfn,
+                              piotlb_info->stage1_cache);
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
+    DualIOMMUStage1Cache *stage1_cache;
+    struct iommu_cache_invalidate_info *cache_info;
+
+    stage1_cache = g_malloc0(sizeof(*stage1_cache));
+    stage1_cache->pasid = pasid;
+
+    cache_info = &stage1_cache->cache_info;
+    cache_info->version = IOMMU_UAPI_VERSION;
+    cache_info->cache = IOMMU_CACHE_INV_TYPE_IOTLB;
+    cache_info->granularity = IOMMU_INV_GRANU_PASID;
+    cache_info->pasid_info.pasid = pasid;
+    cache_info->pasid_info.flags = IOMMU_INV_PASID_FLAGS_PASID;
+
+    piotlb_info.domain_id = domain_id;
+    piotlb_info.pasid = pasid;
+    piotlb_info.stage1_cache = stage1_cache;
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
+    g_free(stage1_cache);
 }
 
 static void vtd_piotlb_page_invalidate(IntelIOMMUState *s, uint16_t domain_id,
                              uint32_t pasid, hwaddr addr, uint8_t am, bool ih)
 {
+    VTDPIOTLBInvInfo piotlb_info;
+    DualIOMMUStage1Cache *stage1_cache;
+    struct iommu_cache_invalidate_info *cache_info;
+
+    stage1_cache = g_malloc0(sizeof(*stage1_cache));
+    stage1_cache->pasid = pasid;
+
+    cache_info = &stage1_cache->cache_info;
+    cache_info->version = IOMMU_UAPI_VERSION;
+    cache_info->cache = IOMMU_CACHE_INV_TYPE_IOTLB;
+    cache_info->granularity = IOMMU_INV_GRANU_ADDR;
+    cache_info->addr_info.flags = IOMMU_INV_ADDR_FLAGS_PASID;
+    cache_info->addr_info.flags |= ih ? IOMMU_INV_ADDR_FLAGS_LEAF : 0;
+    cache_info->addr_info.pasid = pasid;
+    cache_info->addr_info.addr = addr;
+    cache_info->addr_info.granule_size = 1 << (12 + am);
+    cache_info->addr_info.nb_granules = 1;
+
+    piotlb_info.domain_id = domain_id;
+    piotlb_info.pasid = pasid;
+    piotlb_info.stage1_cache = stage1_cache;
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
+    g_free(stage1_cache);
 }
 
 static bool vtd_process_piotlb_desc(IntelIOMMUState *s,
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 17c6e84..bd241cb 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -526,6 +526,13 @@ struct VTDPASIDCacheInfo {
                                       VTD_PASID_CACHE_DEVSI)
 typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
 
+struct VTDPIOTLBInvInfo {
+    uint16_t domain_id;
+    uint32_t pasid;
+    DualIOMMUStage1Cache *stage1_cache;
+};
+typedef struct VTDPIOTLBInvInfo VTDPIOTLBInvInfo;
+
 /* Masks for struct VTDRootEntry */
 #define VTD_ROOT_ENTRY_P            1ULL
 #define VTD_ROOT_ENTRY_CTP          (~0xfffULL)
-- 
2.7.4

