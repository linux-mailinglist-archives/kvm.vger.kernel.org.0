Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AF932A74E
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839247AbhCBQGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:06:19 -0500
Received: from mga04.intel.com ([192.55.52.120]:29670 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447296AbhCBMwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:52:02 -0500
IronPort-SDR: zFpR6yJM+kZhNdrzgMRAR0gka753gdNJk4XYPzkU6hW+9nqxQNQI206jgIiBqXk96w3iUTv6n9
 hRm2kOzgWgoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="184363211"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="184363211"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:39:58 -0800
IronPort-SDR: QxOfBtNesXg2GdUovxlHAc9hXsrF6WtjSx3c+FbAonpEB7AZxBiZeH4mb5QcXTPRl7B82EKx3+
 LRl8eMnKfqJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472756"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:39:54 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Lingshan.Zhu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v11 07/25] vfio: pass nesting requirement into vfio_get_group()
Date:   Wed,  3 Mar 2021 04:38:09 +0800
Message-Id: <20210302203827.437645-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch passes the nesting requirement into vfio_get_group() to
indicate whether VFIO_TYPE1_NESTING_IOMMU is required.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/ap.c                  | 2 +-
 hw/vfio/ccw.c                 | 2 +-
 hw/vfio/common.c              | 3 ++-
 hw/vfio/pci.c                 | 9 ++++++++-
 hw/vfio/platform.c            | 2 +-
 include/hw/vfio/vfio-common.h | 3 ++-
 6 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/hw/vfio/ap.c b/hw/vfio/ap.c
index 9571c2f91f..06cefac7a1 100644
--- a/hw/vfio/ap.c
+++ b/hw/vfio/ap.c
@@ -83,7 +83,7 @@ static VFIOGroup *vfio_ap_get_group(VFIOAPDevice *vapdev, Error **errp)
 
     g_free(group_path);
 
-    return vfio_get_group(groupid, &address_space_memory, errp);
+    return vfio_get_group(groupid, &address_space_memory, false, errp);
 }
 
 static void vfio_ap_realize(DeviceState *dev, Error **errp)
diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
index bc78a0ad76..4a9ca9414a 100644
--- a/hw/vfio/ccw.c
+++ b/hw/vfio/ccw.c
@@ -647,7 +647,7 @@ static VFIOGroup *vfio_ccw_get_group(S390CCWDevice *cdev, Error **errp)
         return NULL;
     }
 
-    return vfio_get_group(groupid, &address_space_memory, errp);
+    return vfio_get_group(groupid, &address_space_memory, false, errp);
 }
 
 static void vfio_ccw_realize(DeviceState *dev, Error **errp)
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 6ff1daa763..44097875e2 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1923,7 +1923,8 @@ static void vfio_disconnect_container(VFIOGroup *group)
     }
 }
 
-VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
+VFIOGroup *vfio_get_group(int groupid, AddressSpace *as,
+                          bool want_nested, Error **errp)
 {
     VFIOGroup *group;
     char path[32];
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index f74be78209..437f51338e 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2771,6 +2771,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     int groupid;
     int i, ret;
     bool is_mdev;
+    bool want_nested;
 
     if (!vdev->vbasedev.sysfsdev) {
         if (!(~vdev->host.domain || ~vdev->host.bus ||
@@ -2817,7 +2818,13 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
 
     trace_vfio_realize(vdev->vbasedev.name, groupid);
 
-    group = vfio_get_group(groupid, pci_device_iommu_address_space(pdev), errp);
+    if (pci_device_get_iommu_attr(pdev,
+                         IOMMU_WANT_NESTING, &want_nested)) {
+        want_nested = false;
+    }
+
+    group = vfio_get_group(groupid, pci_device_iommu_address_space(pdev),
+                           want_nested, errp);
     if (!group) {
         goto error;
     }
diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index cc3f66f7e4..42c6ae7689 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -577,7 +577,7 @@ static int vfio_base_device_init(VFIODevice *vbasedev, Error **errp)
 
     trace_vfio_platform_base_device_init(vbasedev->name, groupid);
 
-    group = vfio_get_group(groupid, &address_space_memory, errp);
+    group = vfio_get_group(groupid, &address_space_memory, false, errp);
     if (!group) {
         return -ENOENT;
     }
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 6141162d7a..293d3785f3 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -196,7 +196,8 @@ void vfio_region_unmap(VFIORegion *region);
 void vfio_region_exit(VFIORegion *region);
 void vfio_region_finalize(VFIORegion *region);
 void vfio_reset_handler(void *opaque);
-VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp);
+VFIOGroup *vfio_get_group(int groupid, AddressSpace *as,
+                          bool want_nested, Error **errp);
 void vfio_put_group(VFIOGroup *group);
 int vfio_get_device(VFIOGroup *group, const char *name,
                     VFIODevice *vbasedev, Error **errp);
-- 
2.25.1

