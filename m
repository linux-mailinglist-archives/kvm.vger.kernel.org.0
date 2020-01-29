Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B79F14CA76
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgA2MLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:11:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:15955 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgA2MLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:11:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:11:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="314071178"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 04:11:51 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com
Cc:     mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3 17/25] vfio: add bind stage-1 page table support
Date:   Wed, 29 Jan 2020 04:16:48 -0800
Message-Id: <1580300216-86172-18-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

This patch adds bind_stage1_pgtbl() definition in DualStageIOMMUOops,
also adds corresponding implementation in VFIO. This is to expose a
way for vIOMMU to setup dual stage DMA translation for passthru devices
on hardware.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/iommu/dual_stage_iommu.c         | 26 ++++++++++++++++++++
 hw/vfio/common.c                    | 48 +++++++++++++++++++++++++++++++++++++
 include/hw/iommu/dual_stage_iommu.h | 22 +++++++++++++++++
 3 files changed, 96 insertions(+)

diff --git a/hw/iommu/dual_stage_iommu.c b/hw/iommu/dual_stage_iommu.c
index d5a7168..9d99e9e 100644
--- a/hw/iommu/dual_stage_iommu.c
+++ b/hw/iommu/dual_stage_iommu.c
@@ -47,6 +47,32 @@ int ds_iommu_pasid_free(DualStageIOMMUObject *dsi_obj, uint32_t pasid)
     return -ENOENT;
 }
 
+int ds_iommu_bind_stage1_pgtbl(DualStageIOMMUObject *dsi_obj,
+                               DualIOMMUStage1BindData *data)
+{
+    if (!dsi_obj) {
+        return -ENOENT;
+    }
+
+    if (dsi_obj->ops && dsi_obj->ops->bind_stage1_pgtbl) {
+        return dsi_obj->ops->bind_stage1_pgtbl(dsi_obj, data);
+    }
+    return -ENOENT;
+}
+
+int ds_iommu_unbind_stage1_pgtbl(DualStageIOMMUObject *dsi_obj,
+                                 DualIOMMUStage1BindData *data)
+{
+    if (!dsi_obj) {
+        return -ENOENT;
+    }
+
+    if (dsi_obj->ops && dsi_obj->ops->unbind_stage1_pgtbl) {
+        return dsi_obj->ops->unbind_stage1_pgtbl(dsi_obj, data);
+    }
+    return -ENOENT;
+}
+
 void ds_iommu_object_init(DualStageIOMMUObject *dsi_obj,
                           DualStageIOMMUOps *ops,
                           DualStageIOMMUInfo *uinfo)
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 014f4e7..d84bdc9 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1219,9 +1219,57 @@ static int vfio_ds_iommu_pasid_free(DualStageIOMMUObject *dsi_obj,
     return 0;
 }
 
+static int vfio_ds_iommu_bind_stage1_pgtbl(DualStageIOMMUObject *dsi_obj,
+                                           DualIOMMUStage1BindData *bind_data)
+{
+    VFIOContainer *container = container_of(dsi_obj, VFIOContainer, dsi_obj);
+    struct vfio_iommu_type1_bind *bind;
+    unsigned long argsz;
+    int ret = 0;
+
+    argsz = sizeof(*bind) + sizeof(bind_data->bind_data);
+    bind = g_malloc0(argsz);
+    bind->argsz = argsz;
+    bind->flags = VFIO_IOMMU_BIND_GUEST_PGTBL;
+    memcpy(&bind->data, &bind_data->bind_data, sizeof(bind_data->bind_data));
+
+    if (ioctl(container->fd, VFIO_IOMMU_BIND, bind)) {
+        error_report("%s: pasid (%u) bind failed: %d",
+                      __func__, bind_data->pasid, -errno);
+        ret = -errno;
+    }
+    g_free(bind);
+    return ret;
+}
+
+static int vfio_ds_iommu_unbind_stage1_pgtbl(DualStageIOMMUObject *dsi_obj,
+                                        DualIOMMUStage1BindData *bind_data)
+{
+    VFIOContainer *container = container_of(dsi_obj, VFIOContainer, dsi_obj);
+    struct vfio_iommu_type1_bind *bind;
+    unsigned long argsz;
+    int ret = 0;
+
+    argsz = sizeof(*bind) + sizeof(bind_data->bind_data);
+    bind = g_malloc0(argsz);
+    bind->argsz = argsz;
+    bind->flags = VFIO_IOMMU_UNBIND_GUEST_PGTBL;
+    memcpy(&bind->data, &bind_data->bind_data, sizeof(bind_data->bind_data));
+
+    if (ioctl(container->fd, VFIO_IOMMU_BIND, bind)) {
+        error_report("%s: pasid (%u) unbind failed: %d",
+                      __func__, bind_data->pasid, -errno);
+        ret = -errno;
+    }
+    g_free(bind);
+    return ret;
+}
+
 static struct DualStageIOMMUOps vfio_ds_iommu_ops = {
     .pasid_alloc = vfio_ds_iommu_pasid_alloc,
     .pasid_free = vfio_ds_iommu_pasid_free,
+    .bind_stage1_pgtbl = vfio_ds_iommu_bind_stage1_pgtbl,
+    .unbind_stage1_pgtbl = vfio_ds_iommu_unbind_stage1_pgtbl,
 };
 
 static int vfio_get_iommu_info(VFIOContainer *container,
diff --git a/include/hw/iommu/dual_stage_iommu.h b/include/hw/iommu/dual_stage_iommu.h
index c6100b4..0eb983c 100644
--- a/include/hw/iommu/dual_stage_iommu.h
+++ b/include/hw/iommu/dual_stage_iommu.h
@@ -31,6 +31,7 @@
 typedef struct DualStageIOMMUObject DualStageIOMMUObject;
 typedef struct DualStageIOMMUOps DualStageIOMMUOps;
 typedef struct DualStageIOMMUInfo DualStageIOMMUInfo;
+typedef struct DualIOMMUStage1BindData DualIOMMUStage1BindData;
 
 struct DualStageIOMMUOps {
     /* Allocate pasid from DualStageIOMMU (a.k.a. host IOMMU) */
@@ -41,6 +42,16 @@ struct DualStageIOMMUOps {
     /* Reclaim a pasid from DualStageIOMMU (a.k.a. host IOMMU) */
     int (*pasid_free)(DualStageIOMMUObject *dsi_obj,
                       uint32_t pasid);
+    /*
+     * Bind stage-1 page table to a DualStageIOMMU (a.k.a. host
+     * IOMMU which has dual stage DMA translation capability.
+     * @bind_data specifies the bind configurations.
+     */
+    int (*bind_stage1_pgtbl)(DualStageIOMMUObject *dsi_obj,
+                            DualIOMMUStage1BindData *bind_data);
+    /* Undo a previous bind. @bind_data specifies the unbind info. */
+    int (*unbind_stage1_pgtbl)(DualStageIOMMUObject *dsi_obj,
+                              DualIOMMUStage1BindData *bind_data);
 };
 
 struct DualStageIOMMUInfo {
@@ -55,9 +66,20 @@ struct DualStageIOMMUObject {
     DualStageIOMMUInfo uinfo;
 };
 
+struct DualIOMMUStage1BindData {
+    uint32_t pasid;
+    union {
+        struct iommu_gpasid_bind_data gpasid_bind;
+    } bind_data;
+};
+
 int ds_iommu_pasid_alloc(DualStageIOMMUObject *dsi_obj, uint32_t min,
                          uint32_t max, uint32_t *pasid);
 int ds_iommu_pasid_free(DualStageIOMMUObject *dsi_obj, uint32_t pasid);
+int ds_iommu_bind_stage1_pgtbl(DualStageIOMMUObject *dsi_obj,
+                               DualIOMMUStage1BindData *bind_data);
+int ds_iommu_unbind_stage1_pgtbl(DualStageIOMMUObject *dsi_obj,
+                                 DualIOMMUStage1BindData *bind_data);
 
 void ds_iommu_object_init(DualStageIOMMUObject *dsi_obj,
                           DualStageIOMMUOps *ops,
-- 
2.7.4

