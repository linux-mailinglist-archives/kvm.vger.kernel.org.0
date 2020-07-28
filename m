Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6492302D2
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgG1G1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:27:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:41268 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgG1G1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:47 -0400
IronPort-SDR: GaarDNE5NDAk6qicgbJ1HQYRccGUqqYkKzU3apKH/HEcjnhV9FKzZ9Mw9u+bRL/Vknid6lhV9j
 xUPdxWdm7yvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="149021045"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="149021045"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:43 -0700
IronPort-SDR: 5+GfGKVDR5LtslOLL5rC8q4mxOMKWWo94xUZ7pTU3MDxa8T4G6KANA79n/IWWa6s096EbCxq3B
 VadO1Sw/8seQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394232918"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:41 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v9 12/25] vfio: init HostIOMMUContext per-container
Date:   Mon, 27 Jul 2020 23:34:05 -0700
Message-Id: <1595918058-33392-13-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
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
 hw/vfio/common.c | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 hw/vfio/pci.c    |  17 +++++++++
 2 files changed, 130 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 41aaf41..9d90732 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1227,10 +1227,102 @@ static int vfio_host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx,
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
+    minsz = offsetof(struct iommu_nesting_info, data);
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
 static int vfio_init_container(VFIOContainer *container, int group_fd,
                                bool want_nested, Error **errp)
 {
     int iommu_type, ret;
+    uint64_t flags = 0;
 
     iommu_type = vfio_get_iommu_type(container, want_nested, errp);
     if (iommu_type < 0) {
@@ -1258,6 +1350,27 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
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
index 8cd1e72..f954c28 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2707,6 +2707,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
     VFIODevice *vbasedev_iter;
     VFIOGroup *group;
+    VFIOContainer *container;
     char *tmp, *subsys, group_path[PATH_MAX], *group_name;
     Error *err = NULL;
     ssize_t len;
@@ -2783,6 +2784,15 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
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
@@ -3068,9 +3078,16 @@ static void vfio_instance_finalize(Object *obj)
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

