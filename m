Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267D2168D5B
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgBVICC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:02:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:63018 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgBVICB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:02:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547704"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2020 00:01:57 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3.1 18/22] vfio/common: add support for flush iommu stage-1 cache
Date:   Sat, 22 Feb 2020 00:07:19 -0800
Message-Id: <1582358843-51931-19-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds flush_stage1_cache() definition in HostIOMMUOps. And
adds corresponding implementation in VFIO. This is to expose a way for
vIOMMU to flush stage-1 cache in host side since guest owns stage-1
translation structures in dual stage DMA translation.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/iommu/host_iommu_context.c         | 10 ++++++++++
 hw/vfio/common.c                      | 24 ++++++++++++++++++++++++
 include/hw/iommu/host_iommu_context.h | 14 ++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
index 5f7eb92..90be684 100644
--- a/hw/iommu/host_iommu_context.c
+++ b/hw/iommu/host_iommu_context.c
@@ -61,6 +61,16 @@ int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *host_icx,
     return -ENOENT;
 }
 
+int host_iommu_ctx_flush_stage1_cache(HostIOMMUContext *host_icx,
+                                DualIOMMUStage1Cache *cache)
+{
+    if (host_icx && (host_icx->flags & HOST_IOMMU_NESTING) &&
+        host_icx && host_icx->ops && host_icx->ops->flush_stage1_cache) {
+        return host_icx->ops->flush_stage1_cache(host_icx, cache);
+    }
+    return -ENOENT;
+}
+
 void host_iommu_ctx_init(HostIOMMUContext *host_icx,
                          uint64_t flags, HostIOMMUOps *ops,
                          HostIOMMUInfo *uinfo)
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index b560fdb..305796b 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1269,11 +1269,35 @@ static int vfio_host_icx_unbind_stage1_pgtbl(HostIOMMUContext *host_icx,
     return ret;
 }
 
+static int vfio_host_iommu_ctx_flush_stage1_cache(HostIOMMUContext *host_icx,
+                                                  DualIOMMUStage1Cache *cache)
+{
+    VFIOContainer *container = container_of(host_icx, VFIOContainer, host_icx);
+    struct vfio_iommu_type1_cache_invalidate *cache_inv;
+    unsigned long argsz;
+    int ret = 0;
+
+    argsz = sizeof(*cache_inv) + sizeof(cache->cache_info);
+    cache_inv = g_malloc0(argsz);
+    cache_inv->argsz = argsz;
+    cache_inv->flags = 0;
+    memcpy(&cache_inv->cache_info, &cache->cache_info,
+           sizeof(cache->cache_info));
+
+    if (ioctl(container->fd, VFIO_IOMMU_CACHE_INVALIDATE, cache_inv)) {
+        error_report("%s: iommu cache flush failed: %d", __func__, -errno);
+        ret = -errno;
+    }
+    g_free(cache_inv);
+    return ret;
+}
+
 static struct HostIOMMUOps vfio_host_icx_ops = {
     .pasid_alloc = vfio_host_icx_pasid_alloc,
     .pasid_free = vfio_host_icx_pasid_free,
     .bind_stage1_pgtbl = vfio_host_icx_bind_stage1_pgtbl,
     .unbind_stage1_pgtbl = vfio_host_icx_unbind_stage1_pgtbl,
+    .flush_stage1_cache = vfio_host_iommu_ctx_flush_stage1_cache,
 };
 
 /**
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
index 660fab8..a55d49a 100644
--- a/include/hw/iommu/host_iommu_context.h
+++ b/include/hw/iommu/host_iommu_context.h
@@ -32,6 +32,7 @@ typedef struct HostIOMMUContext HostIOMMUContext;
 typedef struct HostIOMMUOps HostIOMMUOps;
 typedef struct HostIOMMUInfo HostIOMMUInfo;
 typedef struct DualIOMMUStage1BindData DualIOMMUStage1BindData;
+typedef struct DualIOMMUStage1Cache DualIOMMUStage1Cache;
 
 struct HostIOMMUOps {
     /* Allocate pasid from HostIOMMUContext (a.k.a. host software) */
@@ -52,6 +53,12 @@ struct HostIOMMUOps {
     /* Undo a previous bind. @bind_data specifies the unbind info. */
     int (*unbind_stage1_pgtbl)(HostIOMMUContext *dsi_obj,
                                DualIOMMUStage1BindData *bind_data);
+    /*
+     * Propagate stage-1 cache flush to host IOMMU, cache
+     * info specifid in @cache
+     */
+    int (*flush_stage1_cache)(HostIOMMUContext *host_icx,
+                              DualIOMMUStage1Cache *cache);
 };
 
 struct HostIOMMUInfo {
@@ -76,6 +83,11 @@ struct DualIOMMUStage1BindData {
     } bind_data;
 };
 
+struct DualIOMMUStage1Cache {
+    uint32_t pasid;
+    struct iommu_cache_invalidate_info cache_info;
+};
+
 int host_iommu_ctx_pasid_alloc(HostIOMMUContext *host_icx, uint32_t min,
                                uint32_t max, uint32_t *pasid);
 int host_iommu_ctx_pasid_free(HostIOMMUContext *host_icx, uint32_t pasid);
@@ -83,6 +95,8 @@ int host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *host_icx,
                                      DualIOMMUStage1BindData *data);
 int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *host_icx,
                                        DualIOMMUStage1BindData *data);
+int host_iommu_ctx_flush_stage1_cache(HostIOMMUContext *host_icx,
+                                      DualIOMMUStage1Cache *cache);
 
 void host_iommu_ctx_init(HostIOMMUContext *host_icx,
                          uint64_t flags, HostIOMMUOps *ops,
-- 
2.7.4

