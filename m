Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 356C8168D64
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgBVICA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:02:00 -0500
Received: from mga05.intel.com ([192.55.52.43]:63018 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgBVICA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:02:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547674"
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
Subject: [RFC v3.1 08/22] vfio/common: add pasid_alloc/free support
Date:   Sat, 22 Feb 2020 00:07:09 -0800
Message-Id: <1582358843-51931-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds VFIO pasid alloc/free support to allow host intercept
in PASID allocation for VM by adding VFIO implementation of HostIOMMUOps.
pasid_alloc/free callbacks.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/common.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index f9be68d..8f30a52 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1179,8 +1179,53 @@ static int vfio_get_iommu_type(VFIOContainer *container,
     return -EINVAL;
 }
 
+static int vfio_host_icx_pasid_alloc(HostIOMMUContext *host_icx,
+                                  uint32_t min, uint32_t max, uint32_t *pasid)
+{
+    VFIOContainer *container = container_of(host_icx, VFIOContainer, host_icx);
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+    int ret;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flags = VFIO_IOMMU_PASID_ALLOC;
+    req.alloc_pasid.min = min;
+    req.alloc_pasid.max = max;
+
+    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
+        ret = -errno;
+        error_report("%s: %d, alloc failed", __func__, ret);
+        return ret;
+    }
+    *pasid = req.alloc_pasid.result;
+    return 0;
+}
+
+static int vfio_host_icx_pasid_free(HostIOMMUContext *host_icx,
+                                    uint32_t pasid)
+{
+    VFIOContainer *container = container_of(host_icx, VFIOContainer, host_icx);
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+    int ret;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flags = VFIO_IOMMU_PASID_FREE;
+    req.free_pasid = pasid;
+
+    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
+        ret = -errno;
+        error_report("%s: %d, free failed", __func__, ret);
+        return ret;
+    }
+    return 0;
+}
+
 static struct HostIOMMUOps vfio_host_icx_ops = {
-/* To be added later */
+    .pasid_alloc = vfio_host_icx_pasid_alloc,
+    .pasid_free = vfio_host_icx_pasid_free,
 };
 
 /**
-- 
2.7.4

