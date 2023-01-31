Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1256837FE
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjAaUzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjAaUzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:55:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB81C421B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9hRj1fG+tXuaPLduopV1j5NStGm+LrXWVBjDDfaHLdg=;
        b=ZAHB8ab90SavhySHlqmp8SmZfRid0l6xbUnzQQuDXDM8RAzwXPn6gNEu9ncl832jWnB62u
        RBrZfZBdk0sC6LtEbBBeQc+tTAfs51kOR8DH3GT6aUGyaSn75I0r5PahJTfEjo+a5KpXql
        c/hu9QZ/Ps8xZbznKMEPmM2F+SDwv6A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-wpCfb2WxPCOL4l7gV3oCRg-1; Tue, 31 Jan 2023 15:54:29 -0500
X-MC-Unique: wpCfb2WxPCOL4l7gV3oCRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEF28857A81;
        Tue, 31 Jan 2023 20:54:28 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 543DB40C2064;
        Tue, 31 Jan 2023 20:54:22 +0000 (UTC)
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
Subject: [RFC v3 11/18] vfio/ccw: Use vfio_[attach/detach]_device
Date:   Tue, 31 Jan 2023 21:52:58 +0100
Message-Id: <20230131205305.2726330-12-eric.auger@redhat.com>
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

Let the vfio-ccw device use vfio_attach_device() and
vfio_detach_device(), hence hiding the details of the used
IOMMU backend.

Also now all the devices have been migrated to use the new
vfio_attach_device/vfio_detach_device API, let's turn the
legacy functions into static functions, local to container.c.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 include/hw/vfio/vfio-common.h |   4 --
 hw/vfio/ccw.c                 | 118 ++++++++--------------------------
 hw/vfio/container.c           |   8 +--
 3 files changed, 32 insertions(+), 98 deletions(-)

diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 9465c4b021..1580f9617c 100644
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
 
-    if (vfio_get_device(group, vcdev->cdev.mdevid, &vcdev->vdev, errp)) {
-        goto out_err;
-    }
+    vbasedev->ram_block_discard_allowed = true;
 
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
-
-    tmp = g_strdup_printf("/sys/bus/css/devices/%x.%x.%04x/%s/iommu_group",
-                          cdev->hostid.cssid, cdev->hostid.ssid,
-                          cdev->hostid.devid, cdev->mdevid);
-    len = readlink(tmp, group_path, sizeof(group_path));
-    g_free(tmp);
-
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
index 6e466ef037..b9ee56067c 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -993,7 +993,7 @@ static void vfio_disconnect_container(VFIOGroup *group)
     }
 }
 
-VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
+static VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
 {
     VFIOGroup *group;
     VFIOContainer *bcontainer;
@@ -1062,7 +1062,7 @@ free_group_exit:
     return NULL;
 }
 
-void vfio_put_group(VFIOGroup *group)
+static void vfio_put_group(VFIOGroup *group)
 {
     if (!group || !QLIST_EMPTY(&group->device_list)) {
         return;
@@ -1083,8 +1083,8 @@ void vfio_put_group(VFIOGroup *group)
     }
 }
 
-int vfio_get_device(VFIOGroup *group, const char *name,
-                    VFIODevice *vbasedev, Error **errp)
+static int vfio_get_device(VFIOGroup *group, const char *name,
+                           VFIODevice *vbasedev, Error **errp)
 {
     struct vfio_device_info dev_info = { .argsz = sizeof(dev_info) };
     int ret, fd;
-- 
2.37.3

