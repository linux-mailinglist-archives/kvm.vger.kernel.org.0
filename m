Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82CA500B7A
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242474AbiDNKuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242462AbiDNKt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:49:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270DA8020A
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933245; x=1681469245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KHydA018jKFqdkeNibVMAGbxhdJmQrL0qfYlDKZbHHU=;
  b=TOBu0MWzVWC+vG0younhjUpqWfj3DBQq73ecPtLjvVb3BqHJbNc6+80n
   FVS4z9Wo9suxDykiEGs8H8XkrDVQiCaC/GF5RFvr2Rn+xXy7AiJKSj3MZ
   VBdLdji0iCr98f9rdbRe+z1CaM4Ylo+rjTOG+6mp0vYDqifgcsKR8tsDt
   uO4xt43RVm6vkfYfd23I8rXHdjZP79oTtraQAjaToNlhJ+/VGY8qgVNC2
   2xDAhCYmOEXX2S7yrvuwhvhQzuyphSJczG4SQhlH7PNo6ofEuGGJV5+ZL
   WEh2C1SR2iXEJ1k0aACX3mhcbpS3ajk4AsZHtBDiIQNSj9xWi7zSh5BJT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808690"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808690"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091230"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:19 -0700
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
Subject: [RFC 11/18] vfio/ccw: Use vfio_[attach/detach]_device
Date:   Thu, 14 Apr 2022 03:47:03 -0700
Message-Id: <20220414104710.28534-12-yi.l.liu@intel.com>
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

Let the vfio-ccw device use vfio_attach_device() and
vfio_detach_device(), hence hiding the details of the used
IOMMU backend.

Also now all the devices have been migrated to use the new
vfio_attach_device/vfio_detach_device API, let's turn the
legacy functions into static functions, local to container.c.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/ccw.c                 | 118 ++++++++--------------------------
 hw/vfio/container.c           |   8 +--
 include/hw/vfio/vfio-common.h |   4 --
 3 files changed, 32 insertions(+), 98 deletions(-)

diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
index 0354737666..6fde7849cc 100644
--- a/hw/vfio/ccw.c
+++ b/hw/vfio/ccw.c
@@ -579,27 +579,32 @@ static void vfio_ccw_put_region(VFIOCCWDevice *vcdev)
     g_free(vcdev->io_region);
 }
 
-static void vfio_ccw_put_device(VFIOCCWDevice *vcdev)
-{
-    g_free(vcdev->vdev.name);
-    vfio_put_base_device(&vcdev->vdev);
-}
-
-static void vfio_ccw_get_device(VFIOGroup *group, VFIOCCWDevice *vcdev,
-                                Error **errp)
+static void vfio_ccw_realize(DeviceState *dev, Error **errp)
 {
+    CcwDevice *ccw_dev = DO_UPCAST(CcwDevice, parent_obj, dev);
+    S390CCWDevice *cdev = DO_UPCAST(S390CCWDevice, parent_obj, ccw_dev);
+    VFIOCCWDevice *vcdev = DO_UPCAST(VFIOCCWDevice, cdev, cdev);
+    S390CCWDeviceClass *cdc = S390_CCW_DEVICE_GET_CLASS(cdev);
+    VFIODevice *vbasedev = &vcdev->vdev;
+    Error *err = NULL;
     char *name = g_strdup_printf("%x.%x.%04x", vcdev->cdev.hostid.cssid,
                                  vcdev->cdev.hostid.ssid,
                                  vcdev->cdev.hostid.devid);
-    VFIODevice *vbasedev;
+    int ret;
 
-    QLIST_FOREACH(vbasedev, &group->device_list, next) {
-        if (strcmp(vbasedev->name, name) == 0) {
-            error_setg(errp, "vfio: subchannel %s has already been attached",
-                       name);
-            goto out_err;
+    /* Call the class init function for subchannel. */
+    if (cdc->realize) {
+        cdc->realize(cdev, vcdev->vdev.sysfsdev, &err);
+        if (err) {
+            goto out_err_propagate;
         }
     }
+    vbasedev->sysfsdev = g_strdup_printf("/sys/bus/css/devices/%s/%s",
+                                         name, cdev->mdevid);
+    vbasedev->ops = &vfio_ccw_ops;
+    vbasedev->type = VFIO_DEVICE_TYPE_CCW;
+    vbasedev->name = name;
+    vbasedev->dev = &vcdev->cdev.parent_obj.parent_obj;
 
     /*
      * All vfio-ccw devices are believed to operate in a way compatible with
@@ -609,80 +614,18 @@ static void vfio_ccw_get_device(VFIOGroup *group, VFIOCCWDevice *vcdev,
      * needs to be set before vfio_get_device() for vfio common to handle
      * ram_block_discard_disable().
      */
-    vcdev->vdev.ram_block_discard_allowed = true;
-
-    if (vfio_get_device(group, vcdev->cdev.mdevid, &vcdev->vdev, errp)) {
-        goto out_err;
-    }
-
-    vcdev->vdev.ops = &vfio_ccw_ops;
-    vcdev->vdev.type = VFIO_DEVICE_TYPE_CCW;
-    vcdev->vdev.name = name;
-    vcdev->vdev.dev = &vcdev->cdev.parent_obj.parent_obj;
-
-    return;
-
-out_err:
-    g_free(name);
-}
-
-static VFIOGroup *vfio_ccw_get_group(S390CCWDevice *cdev, Error **errp)
-{
-    char *tmp, group_path[PATH_MAX];
-    ssize_t len;
-    int groupid;
 
-    tmp = g_strdup_printf("/sys/bus/css/devices/%x.%x.%04x/%s/iommu_group",
-                          cdev->hostid.cssid, cdev->hostid.ssid,
-                          cdev->hostid.devid, cdev->mdevid);
-    len = readlink(tmp, group_path, sizeof(group_path));
-    g_free(tmp);
+    vbasedev->ram_block_discard_allowed = true;
 
-    if (len <= 0 || len >= sizeof(group_path)) {
-        error_setg(errp, "vfio: no iommu_group found");
-        return NULL;
-    }
-
-    group_path[len] = 0;
-
-    if (sscanf(basename(group_path), "%d", &groupid) != 1) {
-        error_setg(errp, "vfio: failed to read %s", group_path);
-        return NULL;
-    }
-
-    return vfio_get_group(groupid, &address_space_memory, errp);
-}
-
-static void vfio_ccw_realize(DeviceState *dev, Error **errp)
-{
-    VFIOGroup *group;
-    CcwDevice *ccw_dev = DO_UPCAST(CcwDevice, parent_obj, dev);
-    S390CCWDevice *cdev = DO_UPCAST(S390CCWDevice, parent_obj, ccw_dev);
-    VFIOCCWDevice *vcdev = DO_UPCAST(VFIOCCWDevice, cdev, cdev);
-    S390CCWDeviceClass *cdc = S390_CCW_DEVICE_GET_CLASS(cdev);
-    Error *err = NULL;
-
-    /* Call the class init function for subchannel. */
-    if (cdc->realize) {
-        cdc->realize(cdev, vcdev->vdev.sysfsdev, &err);
-        if (err) {
-            goto out_err_propagate;
-        }
-    }
-
-    group = vfio_ccw_get_group(cdev, &err);
-    if (!group) {
-        goto out_group_err;
-    }
-
-    vfio_ccw_get_device(group, vcdev, &err);
-    if (err) {
-        goto out_device_err;
+    ret = vfio_attach_device(vbasedev, &address_space_memory, errp);
+    if (ret) {
+        g_free(vbasedev->name);
+        g_free(vbasedev->sysfsdev);
     }
 
     vfio_ccw_get_region(vcdev, &err);
     if (err) {
-        goto out_region_err;
+        goto out_get_dev_err;
     }
 
     vfio_ccw_register_irq_notifier(vcdev, VFIO_CCW_IO_IRQ_INDEX, &err);
@@ -714,11 +657,8 @@ out_irq_notifier_err:
     vfio_ccw_unregister_irq_notifier(vcdev, VFIO_CCW_IO_IRQ_INDEX);
 out_io_notifier_err:
     vfio_ccw_put_region(vcdev);
-out_region_err:
-    vfio_ccw_put_device(vcdev);
-out_device_err:
-    vfio_put_group(group);
-out_group_err:
+out_get_dev_err:
+    vfio_detach_device(vbasedev);
     if (cdc->unrealize) {
         cdc->unrealize(cdev);
     }
@@ -732,14 +672,12 @@ static void vfio_ccw_unrealize(DeviceState *dev)
     S390CCWDevice *cdev = DO_UPCAST(S390CCWDevice, parent_obj, ccw_dev);
     VFIOCCWDevice *vcdev = DO_UPCAST(VFIOCCWDevice, cdev, cdev);
     S390CCWDeviceClass *cdc = S390_CCW_DEVICE_GET_CLASS(cdev);
-    VFIOGroup *group = vcdev->vdev.group;
 
     vfio_ccw_unregister_irq_notifier(vcdev, VFIO_CCW_REQ_IRQ_INDEX);
     vfio_ccw_unregister_irq_notifier(vcdev, VFIO_CCW_CRW_IRQ_INDEX);
     vfio_ccw_unregister_irq_notifier(vcdev, VFIO_CCW_IO_IRQ_INDEX);
     vfio_ccw_put_region(vcdev);
-    vfio_ccw_put_device(vcdev);
-    vfio_put_group(group);
+    vfio_detach_device(&vcdev->vdev);
 
     if (cdc->unrealize) {
         cdc->unrealize(cdev);
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index c74a3cd4ae..5d73f8285e 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -954,7 +954,7 @@ static void vfio_disconnect_container(VFIOGroup *group)
     }
 }
 
-VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
+static VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
 {
     VFIOGroup *group;
     VFIOContainer *bcontainer;
@@ -1023,7 +1023,7 @@ free_group_exit:
     return NULL;
 }
 
-void vfio_put_group(VFIOGroup *group)
+static void vfio_put_group(VFIOGroup *group)
 {
     if (!group || !QLIST_EMPTY(&group->device_list)) {
         return;
@@ -1044,8 +1044,8 @@ void vfio_put_group(VFIOGroup *group)
     }
 }
 
-int vfio_get_device(VFIOGroup *group, const char *name,
-                    VFIODevice *vbasedev, Error **errp)
+static int vfio_get_device(VFIOGroup *group, const char *name,
+                           VFIODevice *vbasedev, Error **errp)
 {
     struct vfio_device_info dev_info = { .argsz = sizeof(dev_info) };
     int ret, fd;
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 978b2c2f6e..7d7898717e 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -176,10 +176,6 @@ void vfio_region_unmap(VFIORegion *region);
 void vfio_region_exit(VFIORegion *region);
 void vfio_region_finalize(VFIORegion *region);
 void vfio_reset_handler(void *opaque);
-VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp);
-void vfio_put_group(VFIOGroup *group);
-int vfio_get_device(VFIOGroup *group, const char *name,
-                    VFIODevice *vbasedev, Error **errp);
 int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp);
 void vfio_detach_device(VFIODevice *vbasedev);
 
-- 
2.27.0

