Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81DA500B75
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242477AbiDNKt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242468AbiDNKto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:49:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C877DE1D
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933239; x=1681469239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fzVg/TulejTLRtdp0hUfLMrxdcudhtYLzHSl9O78E70=;
  b=LHr3jK2XHDoOQ5Vm6+RDxEL0f9R1BxGPJxMKA2By0yc5yXcwRMP+p5fi
   fr8NKBJD94NnzrFQEoQSbqSEa+0lCI8Zr0TQQcY7q+zejHo2HPuq7dyQH
   oGqxtVIoCI3o0EJFhHkl3BRw3oymEG1/LmXWgp/P73SYxv3rHWi5CPyv+
   ASDYioQSHoptjDZOiKE537X7lyQpk1+PxFgbFnTBKH63RSv5TviCpyI46
   tM+/7mHoupx6CpXWfp+mUH29PpmBEvTDr3BK8r+CKM0dAvRFqOBYb+VAk
   uRleO4Fagr+C2BkeorqksoAXnLijrr4G28jx3Zz8D01n5ErA2OvqJRKik
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808680"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808680"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091214"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:16 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com
Subject: [RFC 08/18] vfio/container: Introduce vfio_[attach/detach]_device
Date:   Thu, 14 Apr 2022 03:47:00 -0700
Message-Id: <20220414104710.28534-9-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220414104710.28534-1-yi.l.liu@intel.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

We want the VFIO devices to be able to use two different
IOMMU callbacks, the legacy VFIO one and the new iommufd one.

Introduce vfio_[attach/detach]_device which aim at hiding the
underlying IOMMU backend (IOCTLs, datatypes, ...).

Once vfio_attach_device completes, the device is attached
to a security context and its fd can be used. Conversely
When vfio_detach_device completes, the device has been
detached to the security context.

In this patch, only the vfio-pci device gets converted to use
the new API. Subsequent patches will handle other devices.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/container.c           | 65 +++++++++++++++++++++++++++++++++++
 hw/vfio/pci.c                 | 50 +++------------------------
 include/hw/vfio/vfio-common.h |  2 ++
 3 files changed, 72 insertions(+), 45 deletions(-)

diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index 79972064d3..c74a3cd4ae 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -1214,6 +1214,71 @@ int vfio_eeh_as_op(AddressSpace *as, uint32_t op)
     return vfio_eeh_container_op(container, op);
 }
 
+static int vfio_device_groupid(VFIODevice *vbasedev, Error **errp)
+{
+    char *tmp, group_path[PATH_MAX], *group_name;
+    int ret, groupid;
+    ssize_t len;
+
+    tmp = g_strdup_printf("%s/iommu_group", vbasedev->sysfsdev);
+    len = readlink(tmp, group_path, sizeof(group_path));
+    g_free(tmp);
+
+    if (len <= 0 || len >= sizeof(group_path)) {
+        ret = len < 0 ? -errno : -ENAMETOOLONG;
+        error_setg_errno(errp, -ret, "no iommu_group found");
+        return ret;
+    }
+
+    group_path[len] = 0;
+
+    group_name = basename(group_path);
+    if (sscanf(group_name, "%d", &groupid) != 1) {
+        error_setg_errno(errp, errno, "failed to read %s", group_path);
+        return -errno;
+    }
+    return groupid;
+}
+
+int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
+{
+    int groupid = vfio_device_groupid(vbasedev, errp);
+    VFIODevice *vbasedev_iter;
+    VFIOGroup *group;
+    int ret;
+
+    if (groupid < 0) {
+        return groupid;
+    }
+
+    trace_vfio_realize(vbasedev->name, groupid);
+    group = vfio_get_group(groupid, as, errp);
+    if (!group) {
+        return -1;
+    }
+
+    QLIST_FOREACH(vbasedev_iter, &group->device_list, next) {
+        if (strcmp(vbasedev_iter->name, vbasedev->name) == 0) {
+            error_setg(errp, "device is already attached");
+            vfio_put_group(group);
+            return -1;
+        }
+    }
+    ret = vfio_get_device(group, vbasedev->name, vbasedev, errp);
+    if (ret) {
+        vfio_put_group(group);
+        return -1;
+    }
+
+    return 0;
+}
+
+void vfio_detach_device(VFIODevice *vbasedev)
+{
+    vfio_put_base_device(vbasedev);
+    vfio_put_group(vbasedev->group);
+}
+
 static void vfio_legacy_container_class_init(ObjectClass *klass,
                                              void *data)
 {
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index a00a485e46..0363f81017 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2654,10 +2654,9 @@ static void vfio_populate_device(VFIOPCIDevice *vdev, Error **errp)
 
 static void vfio_put_device(VFIOPCIDevice *vdev)
 {
-    g_free(vdev->vbasedev.name);
     g_free(vdev->msix);
 
-    vfio_put_base_device(&vdev->vbasedev);
+    vfio_detach_device(&vdev->vbasedev);
 }
 
 static void vfio_err_notifier_handler(void *opaque)
@@ -2804,13 +2803,9 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
 {
     VFIOPCIDevice *vdev = VFIO_PCI(pdev);
     VFIODevice *vbasedev = &vdev->vbasedev;
-    VFIODevice *vbasedev_iter;
-    VFIOGroup *group;
-    char *tmp, *subsys, group_path[PATH_MAX], *group_name;
+    char *tmp, *subsys;
     Error *err = NULL;
-    ssize_t len;
     struct stat st;
-    int groupid;
     int i, ret;
     bool is_mdev;
 
@@ -2839,39 +2834,6 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     vbasedev->type = VFIO_DEVICE_TYPE_PCI;
     vbasedev->dev = DEVICE(vdev);
 
-    tmp = g_strdup_printf("%s/iommu_group", vbasedev->sysfsdev);
-    len = readlink(tmp, group_path, sizeof(group_path));
-    g_free(tmp);
-
-    if (len <= 0 || len >= sizeof(group_path)) {
-        error_setg_errno(errp, len < 0 ? errno : ENAMETOOLONG,
-                         "no iommu_group found");
-        goto error;
-    }
-
-    group_path[len] = 0;
-
-    group_name = basename(group_path);
-    if (sscanf(group_name, "%d", &groupid) != 1) {
-        error_setg_errno(errp, errno, "failed to read %s", group_path);
-        goto error;
-    }
-
-    trace_vfio_realize(vbasedev->name, groupid);
-
-    group = vfio_get_group(groupid, pci_device_iommu_address_space(pdev), errp);
-    if (!group) {
-        goto error;
-    }
-
-    QLIST_FOREACH(vbasedev_iter, &group->device_list, next) {
-        if (strcmp(vbasedev_iter->name, vbasedev->name) == 0) {
-            error_setg(errp, "device is already attached");
-            vfio_put_group(group);
-            goto error;
-        }
-    }
-
     /*
      * Mediated devices *might* operate compatibly with discarding of RAM, but
      * we cannot know for certain, it depends on whether the mdev vendor driver
@@ -2889,13 +2851,12 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     if (vbasedev->ram_block_discard_allowed && !is_mdev) {
         error_setg(errp, "x-balloon-allowed only potentially compatible "
                    "with mdev devices");
-        vfio_put_group(group);
         goto error;
     }
 
-    ret = vfio_get_device(group, vbasedev->name, vbasedev, errp);
+    ret = vfio_attach_device(vbasedev,
+                             pci_device_iommu_address_space(pdev), errp);
     if (ret) {
-        vfio_put_group(group);
         goto error;
     }
 
@@ -3124,12 +3085,12 @@ out_teardown:
     vfio_bars_exit(vdev);
 error:
     error_prepend(errp, VFIO_MSG_PREFIX, vbasedev->name);
+    vfio_detach_device(vbasedev);
 }
 
 static void vfio_instance_finalize(Object *obj)
 {
     VFIOPCIDevice *vdev = VFIO_PCI(obj);
-    VFIOGroup *group = vdev->vbasedev.group;
 
     vfio_display_finalize(vdev);
     vfio_bars_finalize(vdev);
@@ -3143,7 +3104,6 @@ static void vfio_instance_finalize(Object *obj)
      * g_free(vdev->igd_opregion);
      */
     vfio_put_device(vdev);
-    vfio_put_group(group);
 }
 
 static void vfio_exitfn(PCIDevice *pdev)
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 02a6f36a9e..978b2c2f6e 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -180,6 +180,8 @@ VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp);
 void vfio_put_group(VFIOGroup *group);
 int vfio_get_device(VFIOGroup *group, const char *name,
                     VFIODevice *vbasedev, Error **errp);
+int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp);
+void vfio_detach_device(VFIODevice *vbasedev);
 
 extern const MemoryRegionOps vfio_region_ops;
 typedef QLIST_HEAD(VFIOGroupList, VFIOGroup) VFIOGroupList;
-- 
2.27.0

