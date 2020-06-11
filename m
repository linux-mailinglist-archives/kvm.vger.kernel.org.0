Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EFA1F6828
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgFKMsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:48:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:58113 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgFKMsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:48:09 -0400
IronPort-SDR: DGlUK2DZdvZfOumc8F7jN5DlaOPYbqv4UezWWyearUleyfJZ+QxU3oXzkZOBFDHJF7ePosoI/Z
 9Rfcg9I93Gpg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:48:00 -0700
IronPort-SDR: LrkUj5zxWACLAa6d7b26e2EZw0qePw9ukvffdLIC5Fm/c9xrXd5sNzKnFM9Se1hs0XTVaTGP85
 7CcTUS0JSrLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="447911251"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2020 05:48:00 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v6 12/25] vfio: init HostIOMMUContext per-container
Date:   Thu, 11 Jun 2020 05:54:11 -0700
Message-Id: <1591880064-30638-13-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591880064-30638-1-git-send-email-yi.l.liu@intel.com>
References: <1591880064-30638-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In this patch, QEMU firstly gets iommu info from kernel to check the
supported capabilities by a VFIO_IOMMU_TYPE1_NESTING iommu. And inits
HostIOMMUContet instance.

For vfio-pci devices, it could use pci_device_set/unset_iommu() to
expose host iommu context to vIOMMU emulators. vIOMMU emulators
could make use the methods provided by host iommu context. e.g.
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
 hw/vfio/common.c | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 hw/vfio/pci.c    |  17 +++++++++
 2 files changed, 128 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index f650ad1..6f94d19 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1228,10 +1228,100 @@ static int vfio_host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx,
     return ret;
 }
 
+/**
+ * Get iommu info from host. Caller of this funcion should free
+ * the memory pointed by the returned pointer stored in @info
+ * after a successful calling when finished its usage.
+ */
+static int vfio_get_iommu_info(VFIOContainer *container,
+                         struct vfio_iommu_type1_info **info)
+{
+
+    size_t argsz = sizeof(struct vfio_iommu_type1_info);
+
+    *info = g_malloc0(argsz);
+
+retry:
+    (*info)->argsz = argsz;
+
+    if (ioctl(container->fd, VFIO_IOMMU_GET_INFO, *info)) {
+        g_free(*info);
+        *info = NULL;
+        return -errno;
+    }
+
+    if (((*info)->argsz > argsz)) {
+        argsz = (*info)->argsz;
+        *info = g_realloc(*info, argsz);
+        goto retry;
+    }
+
+    return 0;
+}
+
+static struct vfio_info_cap_header *
+vfio_get_iommu_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
+{
+    struct vfio_info_cap_header *hdr;
+    void *ptr = info;
+
+    if (!(info->flags & VFIO_IOMMU_INFO_CAPS)) {
+        return NULL;
+    }
+
+    for (hdr = ptr + info->cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
+        if (hdr->id == id) {
+            return hdr;
+        }
+    }
+
+    return NULL;
+}
+
+static int vfio_get_nesting_iommu_cap(VFIOContainer *container,
+                   struct vfio_iommu_type1_info_cap_nesting **cap_nesting)
+{
+    struct vfio_iommu_type1_info *info;
+    struct vfio_info_cap_header *hdr;
+    struct vfio_iommu_type1_info_cap_nesting *cap;
+    struct iommu_nesting_info *nest_info;
+    int ret;
+    uint32_t minsz1, minsz2;
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
+    nest_info = (struct iommu_nesting_info *) &cap->info;
+    minsz1 = endof(struct iommu_nesting_info, flags);
+    if (nest_info->size < minsz1) {
+        g_free(info);
+        return -EINVAL;
+    }
+    minsz2 = endof(struct vfio_iommu_type1_info_cap_nesting, flags);
+    *cap_nesting = g_malloc0(minsz2 + nest_info->size);
+    memcpy(*cap_nesting, cap, minsz2 + nest_info->size);
+
+    g_free(info);
+    return 0;
+}
+
 static int vfio_init_container(VFIOContainer *container, int group_fd,
                                bool want_nested, Error **errp)
 {
     int iommu_type, ret;
+    uint64_t flags = 0;
 
     iommu_type = vfio_get_iommu_type(container, want_nested, errp);
     if (iommu_type < 0) {
@@ -1259,6 +1349,27 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
         return -errno;
     }
 
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
+        flags |= (nest_info->features & IOMMU_NESTING_FEAT_SYSWIDE_PASID) ?
+                 HOST_IOMMU_PASID_REQUEST : 0;
+        host_iommu_ctx_init(&container->iommu_ctx,
+                            sizeof(container->iommu_ctx),
+                            TYPE_VFIO_HOST_IOMMU_CONTEXT,
+                            flags);
+        g_free(nesting);
+    }
+
     container->iommu_type = iommu_type;
     return 0;
 }
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index d758d7f..ea299f5 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2717,6 +2717,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
     VFIODevice *vbasedev_iter;
     VFIOGroup *group;
+    VFIOContainer *container;
     char *tmp, *subsys, group_path[PATH_MAX], *group_name;
     Error *err = NULL;
     ssize_t len;
@@ -2794,6 +2795,15 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
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
@@ -3079,9 +3089,16 @@ static void vfio_instance_finalize(Object *obj)
 static void vfio_exitfn(PCIDevice *pdev)
 {
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
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
-- 
2.7.4

