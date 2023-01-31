Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CE168380E
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjAaU4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjAaU4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:56:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F145A359
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PYcDhe1yo5lIevkbmqmXutLU2anHQrdJg+cpG7WLLfY=;
        b=SG3K+97C69vBVz9mrFmK963pHzSC1D4pUrqo/YVvqnZhFJVdkldW0eotoBjxKjMSNuT/bp
        JbYaNK9UquNol/O5gc378yFIdgqaZ4XE9IZmuo7OUu8Pf1mluZIB5yrXdFQPzhjfcDsxs2
        PYRFQ1vAGgGzE/EPrvoIz5Oe05HrtpM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-HE-DLin-ND-deMx7Vfww9g-1; Tue, 31 Jan 2023 15:55:01 -0500
X-MC-Unique: HE-DLin-ND-deMx7Vfww9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CA651C0418C;
        Tue, 31 Jan 2023 20:55:00 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B81A040C2064;
        Tue, 31 Jan 2023 20:54:54 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, alex.williamson@redhat.com,
        clg@redhat.com, qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, kevin.tian@intel.com, chao.p.peng@intel.com,
        peterx@redhat.com, shameerali.kolothum.thodi@huawei.com,
        zhangfei.gao@linaro.org, berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: [RFC v3 16/18] vfio/iommufd: Implement the iommufd backend
Date:   Tue, 31 Jan 2023 21:53:03 +0100
Message-Id: <20230131205305.2726330-17-eric.auger@redhat.com>
In-Reply-To: <20230131205305.2726330-1-eric.auger@redhat.com>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

Add the iommufd backend. The IOMMUFD container class is implemented
based on the new /dev/iommu user API. This backend obviously depends
on CONFIG_IOMMUFD.

So far, the iommufd backend doesn't support live migration and
cache coherency yet due to missing support in the host kernel meaning
that only a subset of the container class callbacks is implemented.

Co-authored-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
v2 -> v3:
- fixed use after free reported by Alistair
v1 -> v2:
- arbitrarily set bcontainer->pgsizes to 4K to fix interoperability
  with virtio-iommu (Nicolin)
- add tear down in iommufd_attach_device error path
- use cdev open for /dev/vfio/devices/vfioX open
---
 include/hw/vfio/vfio-common.h         |  21 +
 include/hw/vfio/vfio-container-base.h |   1 +
 hw/vfio/as.c                          |   9 +-
 hw/vfio/iommufd.c                     | 535 ++++++++++++++++++++++++++
 hw/vfio/pci.c                         |  10 +
 hw/vfio/meson.build                   |   1 +
 hw/vfio/trace-events                  |  11 +
 7 files changed, 586 insertions(+), 2 deletions(-)
 create mode 100644 hw/vfio/iommufd.c

diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 4f89657ac1..c096778476 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -81,10 +81,29 @@ typedef struct VFIOLegacyContainer {
     QLIST_HEAD(, VFIOGroup) group_list;
 } VFIOLegacyContainer;
 
+typedef struct VFIOIOASHwpt {
+    uint32_t hwpt_id;
+    QLIST_HEAD(, VFIODevice) device_list;
+    QLIST_ENTRY(VFIOIOASHwpt) next;
+} VFIOIOASHwpt;
+
+typedef struct IOMMUFDBackend IOMMUFDBackend;
+
+typedef struct VFIOIOMMUFDContainer {
+    VFIOContainer bcontainer;
+    IOMMUFDBackend *be;
+    uint32_t ioas_id;
+    QLIST_HEAD(, VFIOIOASHwpt) hwpt_list;
+} VFIOIOMMUFDContainer;
+
+typedef QLIST_HEAD(VFIOAddressSpaceList, VFIOAddressSpace) VFIOAddressSpaceList;
+extern VFIOAddressSpaceList vfio_address_spaces;
+
 typedef struct VFIODeviceOps VFIODeviceOps;
 
 typedef struct VFIODevice {
     QLIST_ENTRY(VFIODevice) next;
+    QLIST_ENTRY(VFIODevice) hwpt_next;
     struct VFIOGroup *group;
     VFIOContainer *container;
     char *sysfsdev;
@@ -92,6 +111,7 @@ typedef struct VFIODevice {
     DeviceState *dev;
     int fd;
     int type;
+    int devid;
     bool reset_works;
     bool needs_reset;
     bool no_mmap;
@@ -104,6 +124,7 @@ typedef struct VFIODevice {
     VFIOMigration *migration;
     Error *migration_blocker;
     OnOffAuto pre_copy_dirty_page_tracking;
+    IOMMUFDBackend *iommufd;
 } VFIODevice;
 
 struct VFIODeviceOps {
diff --git a/include/hw/vfio/vfio-container-base.h b/include/hw/vfio/vfio-container-base.h
index 8ffd94f8ae..9907d05531 100644
--- a/include/hw/vfio/vfio-container-base.h
+++ b/include/hw/vfio/vfio-container-base.h
@@ -115,6 +115,7 @@ void vfio_container_init(VFIOContainer *container,
 void vfio_container_destroy(VFIOContainer *container);
 
 #define TYPE_VFIO_IOMMU_BACKEND_LEGACY_OPS "vfio-iommu-backend-legacy-ops"
+#define TYPE_VFIO_IOMMU_BACKEND_IOMMUFD_OPS "vfio-iommu-backend-iommufd-ops"
 #define TYPE_VFIO_IOMMU_BACKEND_OPS "vfio-iommu-backend-ops"
 
 DECLARE_CLASS_CHECKERS(VFIOIOMMUBackendOpsClass,
diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index f186d0b789..ee126a5f03 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -42,7 +42,7 @@
 #include "migration/migration.h"
 #include "sysemu/tpm.h"
 
-static QLIST_HEAD(, VFIOAddressSpace) vfio_address_spaces =
+VFIOAddressSpaceList vfio_address_spaces =
     QLIST_HEAD_INITIALIZER(vfio_address_spaces);
 
 void vfio_host_win_add(VFIOContainer *container, hwaddr min_iova,
@@ -873,8 +873,13 @@ int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
 {
     const VFIOIOMMUBackendOpsClass *ops;
 
-    ops = VFIO_IOMMU_BACKEND_OPS_CLASS(
+    if (vbasedev->iommufd) {
+        ops = VFIO_IOMMU_BACKEND_OPS_CLASS(
+                  object_class_by_name(TYPE_VFIO_IOMMU_BACKEND_IOMMUFD_OPS));
+    } else {
+        ops = VFIO_IOMMU_BACKEND_OPS_CLASS(
                   object_class_by_name(TYPE_VFIO_IOMMU_BACKEND_LEGACY_OPS));
+    }
     if (!ops) {
         error_setg(errp, "VFIO IOMMU Backend not found!");
         return -ENODEV;
diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
new file mode 100644
index 0000000000..18f755bcc0
--- /dev/null
+++ b/hw/vfio/iommufd.c
@@ -0,0 +1,535 @@
+/*
+ * iommufd container backend
+ *
+ * Copyright (C) 2022 Intel Corporation.
+ * Copyright Red Hat, Inc. 2022
+ *
+ * Authors: Yi Liu <yi.l.liu@intel.com>
+ *          Eric Auger <eric.auger@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "qemu/osdep.h"
+#include <sys/ioctl.h>
+#include <linux/vfio.h>
+#include <linux/iommufd.h>
+
+#include "hw/vfio/vfio-common.h"
+#include "qemu/error-report.h"
+#include "trace.h"
+#include "qapi/error.h"
+#include "sysemu/iommufd.h"
+#include "hw/qdev-core.h"
+#include "sysemu/reset.h"
+#include "qemu/cutils.h"
+#include "qemu/char_dev.h"
+
+static bool iommufd_check_extension(VFIOContainer *bcontainer,
+                                    VFIOContainerFeature feat)
+{
+    switch (feat) {
+    default:
+        return false;
+    };
+}
+
+static int iommufd_map(VFIOContainer *bcontainer, hwaddr iova,
+                       ram_addr_t size, void *vaddr, bool readonly)
+{
+    VFIOIOMMUFDContainer *container =
+        container_of(bcontainer, VFIOIOMMUFDContainer, bcontainer);
+
+    return iommufd_backend_map_dma(container->be,
+                                   container->ioas_id,
+                                   iova, size, vaddr, readonly);
+}
+
+static int iommufd_unmap(VFIOContainer *bcontainer,
+                         hwaddr iova, ram_addr_t size,
+                         IOMMUTLBEntry *iotlb)
+{
+    VFIOIOMMUFDContainer *container =
+        container_of(bcontainer, VFIOIOMMUFDContainer, bcontainer);
+
+    /* TODO: Handle dma_unmap_bitmap with iotlb args (migration) */
+    return iommufd_backend_unmap_dma(container->be,
+                                     container->ioas_id, iova, size);
+}
+
+static int vfio_get_devicefd(const char *sysfs_path, Error **errp)
+{
+    long int ret = -ENOTTY;
+    char *path, *vfio_dev_path = NULL, *vfio_path = NULL;
+    DIR *dir;
+    struct dirent *dent;
+    gchar *contents;
+    struct stat st;
+    gsize length;
+    int major, minor;
+    dev_t vfio_devt;
+
+    path = g_strdup_printf("%s/vfio-dev", sysfs_path);
+    if (stat(path, &st) < 0) {
+        error_setg_errno(errp, errno, "no such host device");
+        goto out_free_path;
+    }
+
+    dir = opendir(path);
+    if (!dir) {
+        error_setg_errno(errp, errno, "couldn't open dirrectory %s", path);
+        goto out_free_path;
+    }
+
+    while ((dent = readdir(dir))) {
+        if (!strncmp(dent->d_name, "vfio", 4)) {
+            vfio_dev_path = g_strdup_printf("%s/%s/dev", path, dent->d_name);
+            break;
+        }
+    }
+
+    if (!vfio_dev_path) {
+        error_setg(errp, "failed to find vfio-dev/vfioX/dev");
+        goto out_free_path;
+    }
+
+    if (!g_file_get_contents(vfio_dev_path, &contents, &length, NULL)) {
+        error_setg(errp, "failed to load \"%s\"", vfio_dev_path);
+        goto out_free_dev_path;
+    }
+
+    if (sscanf(contents, "%d:%d", &major, &minor) != 2) {
+        error_setg(errp, "failed to get major:mino for \"%s\"", vfio_dev_path);
+        goto out_free_dev_path;
+    }
+    g_free(contents);
+    vfio_devt = makedev(major, minor);
+
+    vfio_path = g_strdup_printf("/dev/vfio/devices/%s", dent->d_name);
+    ret = open_cdev(vfio_path, vfio_devt);
+    if (ret < 0) {
+        error_setg(errp, "Failed to open %s", vfio_path);
+    }
+
+    trace_vfio_iommufd_get_devicefd(vfio_path, ret);
+    g_free(vfio_path);
+
+out_free_dev_path:
+    g_free(vfio_dev_path);
+out_free_path:
+    if (*errp) {
+        error_prepend(errp, VFIO_MSG_PREFIX, path);
+    }
+    g_free(path);
+
+    return ret;
+}
+
+static VFIOIOASHwpt *vfio_container_get_hwpt(VFIOIOMMUFDContainer *container,
+                                             uint32_t hwpt_id)
+{
+    VFIOIOASHwpt *hwpt;
+
+    QLIST_FOREACH(hwpt, &container->hwpt_list, next) {
+        if (hwpt->hwpt_id == hwpt_id) {
+            return hwpt;
+        }
+    }
+
+    hwpt = g_malloc0(sizeof(*hwpt));
+
+    hwpt->hwpt_id = hwpt_id;
+    QLIST_INIT(&hwpt->device_list);
+    QLIST_INSERT_HEAD(&container->hwpt_list, hwpt, next);
+
+    return hwpt;
+}
+
+static void vfio_container_put_hwpt(VFIOIOASHwpt *hwpt)
+{
+    if (!QLIST_EMPTY(&hwpt->device_list)) {
+        g_assert_not_reached();
+    }
+    QLIST_REMOVE(hwpt, next);
+    g_free(hwpt);
+}
+
+static VFIOIOASHwpt *vfio_find_hwpt_for_dev(VFIOIOMMUFDContainer *container,
+                                            VFIODevice *vbasedev)
+{
+    VFIOIOASHwpt *hwpt;
+    VFIODevice *vbasedev_iter;
+
+    QLIST_FOREACH(hwpt, &container->hwpt_list, next) {
+        QLIST_FOREACH(vbasedev_iter, &hwpt->device_list, hwpt_next) {
+            if (vbasedev_iter == vbasedev) {
+                return hwpt;
+            }
+        }
+    }
+    return NULL;
+}
+
+static void
+__vfio_device_detach_container(VFIODevice *vbasedev,
+                               VFIOIOMMUFDContainer *container, Error **errp)
+{
+    struct vfio_device_attach_iommufd_pt detach_data = {
+        .argsz = sizeof(detach_data),
+        .flags = 0,
+        .pt_id = IOMMUFD_INVALID_ID,
+    };
+
+    if (ioctl(vbasedev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &detach_data)) {
+        error_setg_errno(errp, errno, "detach %s from ioas id=%d failed",
+                         vbasedev->name, container->ioas_id);
+    }
+    trace_vfio_iommufd_detach_device(container->be->fd, vbasedev->name,
+                                     container->ioas_id);
+
+    /* iommufd unbind is done per device fd close */
+}
+
+static void vfio_device_detach_container(VFIODevice *vbasedev,
+                                         VFIOIOMMUFDContainer *container,
+                                         Error **errp)
+{
+    VFIOIOASHwpt *hwpt;
+
+    hwpt = vfio_find_hwpt_for_dev(container, vbasedev);
+    if (hwpt) {
+        QLIST_REMOVE(vbasedev, hwpt_next);
+        if (QLIST_EMPTY(&hwpt->device_list)) {
+            vfio_container_put_hwpt(hwpt);
+        }
+    }
+
+    __vfio_device_detach_container(vbasedev, container, errp);
+}
+
+static int vfio_device_attach_container(VFIODevice *vbasedev,
+                                        VFIOIOMMUFDContainer *container,
+                                        Error **errp)
+{
+    struct vfio_device_bind_iommufd bind = {
+        .argsz = sizeof(bind),
+        .flags = 0,
+        .iommufd = container->be->fd,
+        .dev_cookie = (uint64_t)vbasedev,
+    };
+    struct vfio_device_attach_iommufd_pt attach_data = {
+        .argsz = sizeof(attach_data),
+        .flags = 0,
+        .pt_id = container->ioas_id,
+    };
+    VFIOIOASHwpt *hwpt;
+    int ret;
+
+    /* Bind device to iommufd */
+    ret = ioctl(vbasedev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind);
+    if (ret) {
+        error_setg_errno(errp, errno, "error bind device fd=%d to iommufd=%d",
+                         vbasedev->fd, bind.iommufd);
+        return ret;
+    }
+
+    vbasedev->devid = bind.out_devid;
+    trace_vfio_iommufd_bind_device(bind.iommufd, vbasedev->name,
+                                   vbasedev->fd, vbasedev->devid);
+
+    /* Attach device to an ioas within iommufd */
+    ret = ioctl(vbasedev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data);
+    if (ret) {
+        error_setg_errno(errp, errno,
+                         "[iommufd=%d] error attach %s (%d) to ioasid=%d",
+                         container->be->fd, vbasedev->name, vbasedev->fd,
+                         attach_data.pt_id);
+        return ret;
+
+    }
+    trace_vfio_iommufd_attach_device(bind.iommufd, vbasedev->name,
+                                     vbasedev->fd, container->ioas_id,
+                                     attach_data.pt_id);
+
+    hwpt = vfio_container_get_hwpt(container, attach_data.pt_id);
+
+    QLIST_INSERT_HEAD(&hwpt->device_list, vbasedev, hwpt_next);
+    return 0;
+}
+
+static int vfio_device_reset(VFIODevice *vbasedev)
+{
+    if (vbasedev->dev->realized) {
+        vbasedev->ops->vfio_compute_needs_reset(vbasedev);
+        if (vbasedev->needs_reset) {
+            return vbasedev->ops->vfio_hot_reset_multi(vbasedev);
+        }
+    }
+    return 0;
+}
+
+static int vfio_iommufd_container_reset(VFIOContainer *bcontainer)
+{
+    VFIOIOMMUFDContainer *container;
+    int ret, final_ret = 0;
+    VFIODevice *vbasedev;
+    VFIOIOASHwpt *hwpt;
+
+    container = container_of(bcontainer, VFIOIOMMUFDContainer, bcontainer);
+
+    QLIST_FOREACH(hwpt, &container->hwpt_list, next) {
+        QLIST_FOREACH(vbasedev, &hwpt->device_list, hwpt_next) {
+            ret = vfio_device_reset(vbasedev);
+            if (ret) {
+                error_report("failed to reset %s (%d)", vbasedev->name, ret);
+                final_ret = ret;
+            } else {
+                trace_vfio_iommufd_container_reset(vbasedev->name);
+            }
+        }
+    }
+    return final_ret;
+}
+
+static void vfio_iommufd_container_destroy(VFIOIOMMUFDContainer *container)
+{
+    vfio_container_destroy(&container->bcontainer);
+    g_free(container);
+}
+
+static int vfio_ram_block_discard_disable(bool state)
+{
+    /*
+     * We support coordinated discarding of RAM via the RamDiscardManager.
+     */
+    return ram_block_uncoordinated_discard_disable(state);
+}
+
+static void iommufd_detach_device(VFIODevice *vbasedev);
+
+static int iommufd_attach_device(VFIODevice *vbasedev, AddressSpace *as,
+                                 Error **errp)
+{
+    VFIOIOMMUBackendOpsClass *ops = VFIO_IOMMU_BACKEND_OPS_CLASS(
+        object_class_by_name(TYPE_VFIO_IOMMU_BACKEND_IOMMUFD_OPS));
+    VFIOContainer *bcontainer;
+    VFIOIOMMUFDContainer *container;
+    VFIOAddressSpace *space;
+    struct vfio_device_info dev_info = { .argsz = sizeof(dev_info) };
+    int ret, devfd;
+    uint32_t ioas_id;
+    Error *err = NULL;
+
+    devfd = vfio_get_devicefd(vbasedev->sysfsdev, errp);
+    if (devfd < 0) {
+        return devfd;
+    }
+    vbasedev->fd = devfd;
+
+    space = vfio_get_address_space(as);
+
+    /* try to attach to an existing container in this space */
+    QLIST_FOREACH(bcontainer, &space->containers, next) {
+        if (bcontainer->ops != ops) {
+            continue;
+        }
+        container = container_of(bcontainer, VFIOIOMMUFDContainer, bcontainer);
+        if (vfio_device_attach_container(vbasedev, container, &err)) {
+            const char *msg = error_get_pretty(err);
+
+            trace_vfio_iommufd_fail_attach_existing_container(msg);
+            error_free(err);
+            err = NULL;
+        } else {
+            ret = vfio_ram_block_discard_disable(true);
+            if (ret) {
+                vfio_device_detach_container(vbasedev, container, &err);
+                error_propagate(errp, err);
+                vfio_put_address_space(space);
+                close(vbasedev->fd);
+                error_prepend(errp,
+                              "Cannot set discarding of RAM broken (%d)", ret);
+                return ret;
+            }
+            goto out;
+        }
+    }
+
+    /* Need to allocate a new dedicated container */
+    ret = iommufd_backend_get_ioas(vbasedev->iommufd, &ioas_id);
+    if (ret < 0) {
+        vfio_put_address_space(space);
+        close(vbasedev->fd);
+        error_report("Failed to alloc ioas (%s)", strerror(errno));
+        return ret;
+    }
+
+    trace_vfio_iommufd_alloc_ioas(vbasedev->iommufd->fd, ioas_id);
+
+    container = g_malloc0(sizeof(*container));
+    container->be = vbasedev->iommufd;
+    container->ioas_id = ioas_id;
+    QLIST_INIT(&container->hwpt_list);
+
+    bcontainer = &container->bcontainer;
+    vfio_container_init(bcontainer, space, ops);
+
+    ret = vfio_device_attach_container(vbasedev, container, &err);
+    if (ret) {
+        /* todo check if any other thing to do */
+        error_propagate(errp, err);
+        vfio_iommufd_container_destroy(container);
+        iommufd_backend_put_ioas(vbasedev->iommufd, ioas_id);
+        vfio_put_address_space(space);
+        close(vbasedev->fd);
+        return ret;
+    }
+
+    ret = vfio_ram_block_discard_disable(true);
+    if (ret) {
+        goto error;
+    }
+
+    /*
+     * TODO: for now iommufd BE is on par with vfio iommu type1, so it's
+     * fine to add the whole range as window. For SPAPR, below code
+     * should be updated.
+     */
+    vfio_host_win_add(bcontainer, 0, (hwaddr)-1, 4096);
+    bcontainer->pgsizes = 4096;
+
+    /*
+     * TODO: kvmgroup, unable to do it before the protocol done
+     * between iommufd and kvm.
+     */
+
+    QLIST_INSERT_HEAD(&space->containers, bcontainer, next);
+
+    bcontainer->listener = vfio_memory_listener;
+
+    memory_listener_register(&bcontainer->listener, bcontainer->space->as);
+
+    bcontainer->initialized = true;
+
+out:
+    vbasedev->container = bcontainer;
+
+    /*
+     * TODO: examine RAM_BLOCK_DISCARD stuff, should we do group level
+     * for discarding incompatibility check as well?
+     */
+    if (vbasedev->ram_block_discard_allowed) {
+        vfio_ram_block_discard_disable(false);
+    }
+
+    ret = ioctl(devfd, VFIO_DEVICE_GET_INFO, &dev_info);
+    if (ret) {
+        error_setg_errno(errp, errno, "error getting device info");
+        memory_listener_unregister(&bcontainer->listener);
+        QLIST_SAFE_REMOVE(bcontainer, next);
+        goto error;
+    }
+
+    vbasedev->group = 0;
+    vbasedev->num_irqs = dev_info.num_irqs;
+    vbasedev->num_regions = dev_info.num_regions;
+    vbasedev->flags = dev_info.flags;
+    vbasedev->reset_works = !!(dev_info.flags & VFIO_DEVICE_FLAGS_RESET);
+
+    trace_vfio_iommufd_device_info(vbasedev->name, devfd, vbasedev->num_irqs,
+                                   vbasedev->num_regions, vbasedev->flags);
+    return 0;
+error:
+    vfio_device_detach_container(vbasedev, container, &err);
+    error_propagate(errp, err);
+    vfio_iommufd_container_destroy(container);
+    iommufd_backend_put_ioas(vbasedev->iommufd, ioas_id);
+    vfio_put_address_space(space);
+    close(vbasedev->fd);
+    return ret;
+}
+
+static void iommufd_detach_device(VFIODevice *vbasedev)
+{
+    VFIOContainer *bcontainer = vbasedev->container;
+    VFIOIOMMUFDContainer *container;
+    VFIODevice *vbasedev_iter;
+    VFIOIOASHwpt *hwpt;
+    Error *err = NULL;
+
+    if (!bcontainer) {
+        goto out;
+    }
+
+    if (!vbasedev->ram_block_discard_allowed) {
+        vfio_ram_block_discard_disable(false);
+    }
+
+    container = container_of(bcontainer, VFIOIOMMUFDContainer, bcontainer);
+    QLIST_FOREACH(hwpt, &container->hwpt_list, next) {
+        QLIST_FOREACH(vbasedev_iter, &hwpt->device_list, hwpt_next) {
+            if (vbasedev_iter == vbasedev) {
+                goto found;
+            }
+        }
+    }
+    g_assert_not_reached();
+found:
+    QLIST_REMOVE(vbasedev, hwpt_next);
+    if (QLIST_EMPTY(&hwpt->device_list)) {
+        vfio_container_put_hwpt(hwpt);
+    }
+
+    __vfio_device_detach_container(vbasedev, container, &err);
+    if (err) {
+        error_report_err(err);
+    }
+    if (QLIST_EMPTY(&container->hwpt_list)) {
+        VFIOAddressSpace *space = bcontainer->space;
+
+        iommufd_backend_put_ioas(container->be, container->ioas_id);
+        vfio_iommufd_container_destroy(container);
+        vfio_put_address_space(space);
+    }
+    vbasedev->container = NULL;
+out:
+    close(vbasedev->fd);
+    g_free(vbasedev->name);
+}
+
+static void vfio_iommu_backend_iommufd_ops_class_init(ObjectClass *oc,
+                                                     void *data) {
+    VFIOIOMMUBackendOpsClass *ops = VFIO_IOMMU_BACKEND_OPS_CLASS(oc);
+
+    ops->check_extension = iommufd_check_extension;
+    ops->dma_map = iommufd_map;
+    ops->dma_unmap = iommufd_unmap;
+    ops->attach_device = iommufd_attach_device;
+    ops->detach_device = iommufd_detach_device;
+    ops->reset = vfio_iommufd_container_reset;
+}
+
+static const TypeInfo vfio_iommu_backend_iommufd_ops_type = {
+    .name = TYPE_VFIO_IOMMU_BACKEND_IOMMUFD_OPS,
+
+    .parent = TYPE_VFIO_IOMMU_BACKEND_OPS,
+    .class_init = vfio_iommu_backend_iommufd_ops_class_init,
+    .abstract = true,
+};
+static void vfio_iommu_backend_iommufd_ops_register_types(void)
+{
+    type_register_static(&vfio_iommu_backend_iommufd_ops_type);
+}
+type_init(vfio_iommu_backend_iommufd_ops_register_types);
+
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 07361a6fcd..8689b3053c 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -3191,6 +3191,16 @@ static void vfio_pci_reset(DeviceState *dev)
         goto post_reset;
     }
 
+    /*
+     * This is a temporary check, long term iommufd should
+     * support hot reset as well
+     */
+    if (vdev->vbasedev.iommufd) {
+        error_report("Dangerous: iommufd BE doesn't support hot "
+                     "reset, please stop the VM");
+        goto post_reset;
+    }
+
     /* See if we can do our own bus reset */
     if (!vfio_pci_hot_reset_one(vdev)) {
         goto post_reset;
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index fd0dfd198a..447a825d17 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -7,6 +7,7 @@ vfio_ss.add(files(
   'spapr.c',
   'migration.c',
 ))
+vfio_ss.add(when: 'CONFIG_IOMMUFD', if_true: files( 'iommufd.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'display.c',
   'pci-quirks.c',
diff --git a/hw/vfio/trace-events b/hw/vfio/trace-events
index 73dffe9e00..25e5ede986 100644
--- a/hw/vfio/trace-events
+++ b/hw/vfio/trace-events
@@ -166,3 +166,14 @@ vfio_load_state_device_data(const char *name, uint64_t data_offset, uint64_t dat
 vfio_load_cleanup(const char *name) " (%s)"
 vfio_get_dirty_bitmap(int fd, uint64_t iova, uint64_t size, uint64_t bitmap_size, uint64_t start) "container fd=%d, iova=0x%"PRIx64" size= 0x%"PRIx64" bitmap_size=0x%"PRIx64" start=0x%"PRIx64
 vfio_iommu_map_dirty_notify(uint64_t iova_start, uint64_t iova_end) "iommu dirty @ 0x%"PRIx64" - 0x%"PRIx64
+
+#iommufd.c
+
+vfio_iommufd_get_devicefd(const char *dev, int devfd) " %s (fd=%d)"
+vfio_iommufd_bind_device(int iommufd, const char *name, int devfd, int devid) " [iommufd=%d] Succesfully bound device %s (fd=%d): output devid=%d"
+vfio_iommufd_attach_device(int iommufd, const char *name, int devfd, int ioasid, int hwptid) " [iommufd=%d] Succesfully attached device %s (%d) to ioasid=%d: output hwptd=%d"
+vfio_iommufd_detach_device(int iommufd, const char *name, int ioasid) " [iommufd=%d] Detached %s from ioasid=%d"
+vfio_iommufd_alloc_ioas(int iommufd, int ioas_id) " [iommufd=%d] new IOMMUFD container with ioasid=%d"
+vfio_iommufd_device_info(char *name, int devfd, int num_irqs, int num_regions, int flags) " %s (%d) num_irqs=%d num_regions=%d flags=%d"
+vfio_iommufd_fail_attach_existing_container(const char *msg) " %s"
+vfio_iommufd_container_reset(char *name) " Successfully reset %s"
-- 
2.37.3

