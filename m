Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267092302D5
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgG1G17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:27:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:57967 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbgG1G16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:58 -0400
IronPort-SDR: 6SoD+1k9I0nOhISgmf6BAHWyDz5xicvGmJ4y+oDOJ2CpoyYQWZyz6u79Y5c8IHqPKkq6q8gLFo
 nM7dYKSy/ulw==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130720441"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="130720441"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:57 -0700
IronPort-SDR: YPZeZKvk6KcgIW8TeRpMnvHXschnyvEMUdTYnUtPHsiSJFf8kcuPi9S63ffLuYfQ4eAVOsJkOG
 Yy3NoD1vO+Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394233102"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:56 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v9 23/25] intel_iommu: propagate PASID-based iotlb invalidation to host
Date:   Mon, 27 Jul 2020 23:34:16 -0700
Message-Id: <1595918058-33392-24-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
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
rfcv4 (v1) -> rfcv5 (v2):
*) removed the valid check to vtd_pasid_as instance as rfcv5 ensures
   all vtd_pasid_as instances in hash table should be valid.
---
 hw/i386/intel_iommu.c          | 113 +++++++++++++++++++++++++++++++++++++++++
 hw/i386/intel_iommu_internal.h |   7 +++
 2 files changed, 120 insertions(+)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index de7947c..db4460a 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3038,16 +3038,129 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
     return true;
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
index 118d568..08ff58e 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -575,6 +575,13 @@ struct VTDPASIDCacheInfo {
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
2.7.4

