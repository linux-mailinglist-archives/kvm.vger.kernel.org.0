Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4759914CA7D
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgA2MLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:11:52 -0500
Received: from mga04.intel.com ([192.55.52.120]:15948 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgA2MLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:11:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:11:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="314071033"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 04:11:48 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com
Cc:     mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3 12/25] vfio/common: add pasid_alloc/free support
Date:   Wed, 29 Jan 2020 04:16:43 -0800
Message-Id: <1580300216-86172-13-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

This patch adds VFIO pasid alloc/free support to allow host intercept
in PASID allocation for VM by adding VFIO implementation of
DualStageIOMMUOps.pasid_alloc/free callbacks.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/common.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index a07824b..014f4e7 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1179,7 +1179,49 @@ static int vfio_get_iommu_type(VFIOContainer *container,
     return -EINVAL;
 }
 
+static int vfio_ds_iommu_pasid_alloc(DualStageIOMMUObject *dsi_obj,
+                         uint32_t min, uint32_t max, uint32_t *pasid)
+{
+    VFIOContainer *container = container_of(dsi_obj, VFIOContainer, dsi_obj);
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flags = VFIO_IOMMU_PASID_ALLOC;
+    req.alloc_pasid.min = min;
+    req.alloc_pasid.max = max;
+
+    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
+        error_report("%s: %d, alloc failed", __func__, -errno);
+        return -errno;
+    }
+    *pasid = req.alloc_pasid.result;
+    return 0;
+}
+
+static int vfio_ds_iommu_pasid_free(DualStageIOMMUObject *dsi_obj,
+                                     uint32_t pasid)
+{
+    VFIOContainer *container = container_of(dsi_obj, VFIOContainer, dsi_obj);
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flags = VFIO_IOMMU_PASID_FREE;
+    req.free_pasid = pasid;
+
+    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
+        error_report("%s: %d, free failed", __func__, -errno);
+        return -errno;
+    }
+    return 0;
+}
+
 static struct DualStageIOMMUOps vfio_ds_iommu_ops = {
+    .pasid_alloc = vfio_ds_iommu_pasid_alloc,
+    .pasid_free = vfio_ds_iommu_pasid_free,
 };
 
 static int vfio_get_iommu_info(VFIOContainer *container,
-- 
2.7.4

