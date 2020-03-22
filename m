Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F40218E8D3
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgCVMat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:30:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:58572 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbgCVMal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:30:41 -0400
IronPort-SDR: rb1OZ3RJi/4QJxJkjttigk4eZyRbRXX06uwUxonRpe1pjCEBMmEbzjTORA4ccNtyD7GGa4YUl+
 v5aqqHG9Bmqw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:30:39 -0700
IronPort-SDR: 9JFGenLxezvZArebX0ilx4WPN6XHUk9n6XDRyPOdH2VNlKSvn00iKYx84XGJmj6z2kEkrGFTX9
 MXsCQX+N7/pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="239664405"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2020 05:30:38 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [PATCH v1 18/22] vfio: add support for flush iommu stage-1 cache
Date:   Sun, 22 Mar 2020 05:36:15 -0700
Message-Id: <1584880579-12178-19-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds flush_stage1_cache() definition in HostIOMUContextClass.
And adds corresponding implementation in VFIO. This is to expose a way
for vIOMMU to flush stage-1 cache in host side since guest owns stage-1
translation structures in dual stage DMA translation configuration.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/iommu/host_iommu_context.c         | 19 +++++++++++++++++++
 hw/vfio/common.c                      | 24 ++++++++++++++++++++++++
 include/hw/iommu/host_iommu_context.h | 14 ++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
index 8a53376..4bff1a1 100644
--- a/hw/iommu/host_iommu_context.c
+++ b/hw/iommu/host_iommu_context.c
@@ -113,6 +113,25 @@ int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *host_icx,
     return hicxc->unbind_stage1_pgtbl(host_icx, data);
 }
 
+int host_iommu_ctx_flush_stage1_cache(HostIOMMUContext *host_icx,
+                                      DualIOMMUStage1Cache *cache)
+{
+    HostIOMMUContextClass *hicxc;
+
+    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(host_icx);
+
+    if (!hicxc) {
+        return -EINVAL;
+    }
+
+    if (!(host_icx->flags & HOST_IOMMU_NESTING) ||
+        !hicxc->flush_stage1_cache) {
+        return -EINVAL;
+    }
+
+    return hicxc->flush_stage1_cache(host_icx, cache);
+}
+
 void host_iommu_ctx_init(void *_host_icx, size_t instance_size,
                          const char *mrtypename,
                          uint64_t flags, uint32_t formats)
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 770a785..e69fe94 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1269,6 +1269,29 @@ static int vfio_host_icx_unbind_stage1_pgtbl(HostIOMMUContext *host_icx,
     return ret;
 }
 
+static int vfio_host_icx_flush_stage1_cache(HostIOMMUContext *host_icx,
+                                            DualIOMMUStage1Cache *cache)
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
 /**
  * Get iommu info from host. Caller of this funcion should free
  * the memory pointed by the returned pointer stored in @info
@@ -1996,6 +2019,7 @@ static void vfio_host_iommu_context_class_init(ObjectClass *klass,
     hicxc->pasid_free = vfio_host_icx_pasid_free;
     hicxc->bind_stage1_pgtbl = vfio_host_icx_bind_stage1_pgtbl;
     hicxc->unbind_stage1_pgtbl = vfio_host_icx_unbind_stage1_pgtbl;
+    hicxc->flush_stage1_cache = vfio_host_icx_flush_stage1_cache;
 }
 
 static const TypeInfo vfio_host_iommu_context_info = {
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
index 97c9473..6230daa 100644
--- a/include/hw/iommu/host_iommu_context.h
+++ b/include/hw/iommu/host_iommu_context.h
@@ -42,6 +42,7 @@
 
 typedef struct HostIOMMUContext HostIOMMUContext;
 typedef struct DualIOMMUStage1BindData DualIOMMUStage1BindData;
+typedef struct DualIOMMUStage1Cache DualIOMMUStage1Cache;
 
 typedef struct HostIOMMUContextClass {
     /* private */
@@ -65,6 +66,12 @@ typedef struct HostIOMMUContextClass {
     /* Undo a previous bind. @bind_data specifies the unbind info. */
     int (*unbind_stage1_pgtbl)(HostIOMMUContext *dsi_obj,
                                DualIOMMUStage1BindData *bind_data);
+    /*
+     * Propagate stage-1 cache flush to host IOMMU, cache
+     * info specifid in @cache
+     */
+    int (*flush_stage1_cache)(HostIOMMUContext *host_icx,
+                              DualIOMMUStage1Cache *cache);
 } HostIOMMUContextClass;
 
 /*
@@ -86,6 +93,11 @@ struct DualIOMMUStage1BindData {
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
@@ -93,6 +105,8 @@ int host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *host_icx,
                                      DualIOMMUStage1BindData *data);
 int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *host_icx,
                                        DualIOMMUStage1BindData *data);
+int host_iommu_ctx_flush_stage1_cache(HostIOMMUContext *host_icx,
+                                      DualIOMMUStage1Cache *cache);
 
 void host_iommu_ctx_init(void *_host_icx, size_t instance_size,
                          const char *mrtypename,
-- 
2.7.4

