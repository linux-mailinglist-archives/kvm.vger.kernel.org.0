Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8720C32A734
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839058AbhCBQFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:05:20 -0500
Received: from mga07.intel.com ([134.134.136.100]:51850 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1446947AbhCBMlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:41:36 -0500
IronPort-SDR: 5u7AxKoRq2RFaJNTAfwBlurd+8wpk4x3aFQSZM85rQX4fK/bAG49kFSLs5Dj1Yt4Wpe0d10Q59
 WK02d6bZJiTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="250841322"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="250841322"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:40:29 -0800
IronPort-SDR: 2rBwXi9CGAqzBAfgjGa2/z9Z7RLcfK9+aaBOHTgVIBWhWDpMD0yV419aGiITwQLR0Jexxae9Nv
 r47dGVFbNZGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472958"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:40:25 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Lingshan.Zhu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v11 13/25] vfio: init HostIOMMUContext per-container
Date:   Wed,  3 Mar 2021 04:38:15 +0800
Message-Id: <20210302203827.437645-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In this patch, QEMU firstly gets iommu info from kernel to check the
supported capabilities by a VFIO_IOMMU_TYPE1_NESTING iommu. And inits
HostIOMMUContet instance.

For vfio-pci devices, it could use pci_device_set/unset_iommu() to
expose host iommu context to vIOMMU emulators. vIOMMU emulators
could make use of the methods provided by host iommu context. e.g.
propagate requests to host iommu.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/common.c              | 135 +++++++++++++++++++++++++---------
 hw/vfio/pci.c                 |  17 +++++
 include/hw/vfio/vfio-common.h |   1 +
 3 files changed, 118 insertions(+), 35 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 433938c245..a12708bcb7 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1623,41 +1623,11 @@ static int vfio_host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
     return ret;
 }
 
-static int vfio_init_container(VFIOContainer *container, int group_fd,
-                               bool want_nested, Error **errp)
-{
-    int iommu_type, ret;
-
-    iommu_type = vfio_get_iommu_type(container, want_nested, errp);
-    if (iommu_type < 0) {
-        return iommu_type;
-    }
-
-    ret = ioctl(group_fd, VFIO_GROUP_SET_CONTAINER, &container->fd);
-    if (ret) {
-        error_setg_errno(errp, errno, "Failed to set group container");
-        return -errno;
-    }
-
-    while (ioctl(container->fd, VFIO_SET_IOMMU, iommu_type)) {
-        if (iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
-            /*
-             * On sPAPR, despite the IOMMU subdriver always advertises v1 and
-             * v2, the running platform may not support v2 and there is no
-             * way to guess it until an IOMMU group gets added to the container.
-             * So in case it fails with v2, try v1 as a fallback.
-             */
-            iommu_type = VFIO_SPAPR_TCE_IOMMU;
-            continue;
-        }
-        error_setg_errno(errp, errno, "Failed to set iommu for container");
-        return -errno;
-    }
-
-    container->iommu_type = iommu_type;
-    return 0;
-}
-
+/**
+ * Get iommu info from host. Caller of this funcion should free
+ * the memory pointed by the returned pointer stored in @info
+ * after a successful calling when finished its usage.
+ */
 static int vfio_get_iommu_info(VFIOContainer *container,
                                struct vfio_iommu_type1_info **info)
 {
@@ -1702,6 +1672,101 @@ vfio_get_iommu_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
     return NULL;
 }
 
+static int vfio_get_nesting_iommu_cap(VFIOContainer *container,
+                   struct vfio_iommu_type1_info_cap_nesting **cap_nesting)
+{
+    struct vfio_iommu_type1_info *info;
+    struct vfio_info_cap_header *hdr;
+    struct vfio_iommu_type1_info_cap_nesting *cap;
+    struct iommu_nesting_info *nest_info;
+    int ret;
+    uint32_t minsz, cap_size;
+
+    ret = vfio_get_iommu_info(container, &info);
+    if (ret) {
+        return ret;
+    }
+
+    hdr = vfio_get_iommu_info_cap(info,
+                        VFIO_IOMMU_TYPE1_INFO_CAP_NESTING);
+    if (!hdr) {
+        g_free(info);
+        return -EINVAL;
+    }
+
+    cap = container_of(hdr,
+                struct vfio_iommu_type1_info_cap_nesting, header);
+
+    nest_info = &cap->info;
+    minsz = offsetof(struct iommu_nesting_info, vendor);
+    if (nest_info->argsz < minsz) {
+        g_free(info);
+        return -EINVAL;
+    }
+
+    cap_size = offsetof(struct vfio_iommu_type1_info_cap_nesting, info) +
+               nest_info->argsz;
+    *cap_nesting = g_malloc0(cap_size);
+    memcpy(*cap_nesting, cap, cap_size);
+
+    g_free(info);
+    return 0;
+}
+
+static int vfio_init_container(VFIOContainer *container, int group_fd,
+                               bool want_nested, Error **errp)
+{
+    int iommu_type, ret;
+
+    iommu_type = vfio_get_iommu_type(container, want_nested, errp);
+    if (iommu_type < 0) {
+        return iommu_type;
+    }
+
+    ret = ioctl(group_fd, VFIO_GROUP_SET_CONTAINER, &container->fd);
+    if (ret) {
+        error_setg_errno(errp, errno, "Failed to set group container");
+        return -errno;
+    }
+
+    while (ioctl(container->fd, VFIO_SET_IOMMU, iommu_type)) {
+        if (iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
+            /*
+             * On sPAPR, despite the IOMMU subdriver always advertises v1 and
+             * v2, the running platform may not support v2 and there is no
+             * way to guess it until an IOMMU group gets added to the container.
+             * So in case it fails with v2, try v1 as a fallback.
+             */
+            iommu_type = VFIO_SPAPR_TCE_IOMMU;
+            continue;
+        }
+        error_setg_errno(errp, errno, "Failed to set iommu for container");
+        return -errno;
+    }
+
+    if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
+        struct vfio_iommu_type1_info_cap_nesting *nesting = NULL;
+        struct iommu_nesting_info *nest_info;
+
+        ret = vfio_get_nesting_iommu_cap(container, &nesting);
+        if (ret) {
+            error_setg_errno(errp, -ret,
+                             "Failed to get nesting iommu cap");
+            return ret;
+        }
+
+        nest_info = (struct iommu_nesting_info *) &nesting->info;
+        host_iommu_ctx_init(&container->iommu_ctx,
+                            sizeof(container->iommu_ctx),
+                            TYPE_VFIO_HOST_IOMMU_CONTEXT,
+                            nest_info);
+        g_free(nesting);
+    }
+
+    container->iommu_type = iommu_type;
+    return 0;
+}
+
 static void vfio_get_iommu_info_migration(VFIOContainer *container,
                                          struct vfio_iommu_type1_info *info)
 {
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 437f51338e..f5363589b6 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2764,6 +2764,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     VFIOPCIDevice *vdev = VFIO_PCI(pdev);
     VFIODevice *vbasedev_iter;
     VFIOGroup *group;
+    VFIOContainer *container;
     char *tmp, *subsys, group_path[PATH_MAX], *group_name;
     Error *err = NULL;
     ssize_t len;
@@ -2829,6 +2830,15 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
         goto error;
     }
 
+    container = group->container;
+    if (container->iommu_ctx.initialized &&
+        pci_device_set_iommu_context(pdev, &container->iommu_ctx)) {
+        error_setg(errp, "device attachment is denied by vIOMMU, "
+                   "please check host IOMMU nesting capability");
+        vfio_put_group(group);
+        goto error;
+    }
+
     QLIST_FOREACH(vbasedev_iter, &group->device_list, next) {
         if (strcmp(vbasedev_iter->name, vdev->vbasedev.name) == 0) {
             error_setg(errp, "device is already attached");
@@ -3112,9 +3122,16 @@ static void vfio_instance_finalize(Object *obj)
 static void vfio_exitfn(PCIDevice *pdev)
 {
     VFIOPCIDevice *vdev = VFIO_PCI(pdev);
+    VFIOContainer *container;
 
     vfio_unregister_req_notifier(vdev);
     vfio_unregister_err_notifier(vdev);
+
+    container = vdev->vbasedev.group->container;
+    if (container->iommu_ctx.initialized) {
+        pci_device_unset_iommu_context(pdev);
+    }
+
     pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
     if (vdev->irqchip_change_notifier.notify) {
         kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 55241ee270..5a9f2b6325 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -85,6 +85,7 @@ typedef struct VFIOContainer {
     MemoryListener listener;
     MemoryListener prereg_listener;
     unsigned iommu_type;
+    HostIOMMUContext iommu_ctx;
     Error *error;
     bool initialized;
     bool dirty_pages_supported;
-- 
2.25.1

