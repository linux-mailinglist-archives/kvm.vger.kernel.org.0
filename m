Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE592302CF
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgG1G1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:27:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:37269 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgG1G1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:46 -0400
IronPort-SDR: +ZoRFxT6bSA1qGrbuQHUWohmNrLmxfBESVAyqin67lEPBqHi4v8Rch8GltIoMJA/beIYfnOihp
 xSxK3FGUNAnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="152412023"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="152412023"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:36 -0700
IronPort-SDR: gjiCFW7yS1WHS4TgbI/iVZNh8UNwneCKfXy6nGYMmpwpFVATz/Oy9i9dqz4+k+yuiseWErmGI8
 Oe5AmSEsCs1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394232840"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:35 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v9 06/25] vfio: pass nesting requirement into vfio_get_group()
Date:   Mon, 27 Jul 2020 23:33:59 -0700
Message-Id: <1595918058-33392-7-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
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
index b9330a8..2101a1c 100644
--- a/hw/vfio/ap.c
+++ b/hw/vfio/ap.c
@@ -82,7 +82,7 @@ static VFIOGroup *vfio_ap_get_group(VFIOAPDevice *vapdev, Error **errp)
 
     g_free(group_path);
 
-    return vfio_get_group(groupid, &address_space_memory, errp);
+    return vfio_get_group(groupid, &address_space_memory, false, errp);
 }
 
 static void vfio_ap_realize(DeviceState *dev, Error **errp)
diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
index ff7f369..30d00a7 100644
--- a/hw/vfio/ccw.c
+++ b/hw/vfio/ccw.c
@@ -621,7 +621,7 @@ static VFIOGroup *vfio_ccw_get_group(S390CCWDevice *cdev, Error **errp)
         return NULL;
     }
 
-    return vfio_get_group(groupid, &address_space_memory, errp);
+    return vfio_get_group(groupid, &address_space_memory, false, errp);
 }
 
 static void vfio_ccw_realize(DeviceState *dev, Error **errp)
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 3335714..80d7a00 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1457,7 +1457,8 @@ static void vfio_disconnect_container(VFIOGroup *group)
     }
 }
 
-VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
+VFIOGroup *vfio_get_group(int groupid, AddressSpace *as,
+                          bool want_nested, Error **errp)
 {
     VFIOGroup *group;
     char path[32];
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 2e561c0..8cd1e72 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2714,6 +2714,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     int groupid;
     int i, ret;
     bool is_mdev;
+    bool want_nested;
 
     if (!vdev->vbasedev.sysfsdev) {
         if (!(~vdev->host.domain || ~vdev->host.bus ||
@@ -2771,7 +2772,13 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
 
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
index ac2cefc..7ad7702 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -580,7 +580,7 @@ static int vfio_base_device_init(VFIODevice *vbasedev, Error **errp)
 
     trace_vfio_platform_base_device_init(vbasedev->name, groupid);
 
-    group = vfio_get_group(groupid, &address_space_memory, errp);
+    group = vfio_get_group(groupid, &address_space_memory, false, errp);
     if (!group) {
         return -ENOENT;
     }
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index c78f3ff..bdb09f4 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -174,7 +174,8 @@ void vfio_region_mmaps_set_enabled(VFIORegion *region, bool enabled);
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
2.7.4

