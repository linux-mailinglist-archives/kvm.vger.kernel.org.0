Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC1C683807
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjAaUze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjAaUz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:55:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EDDCC15
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bwIpAqcX+KnGrnnAkFDnrt9OFoUGPx1pO+F4THaPIKA=;
        b=Ivul+8Oh9C4Ml2YoJC7UxlTpRxsNBuW1wMwKbRMqIWQmUU3ZNsJW5mSzdpQgqwNbojwoY9
        H4nI5pRK53TXBJFv2l7/dVs5rd9hQbm/ZnjqczaDo62tbd45KeJEakdQhFjabPBDqDUPBC
        sUA/CKyAgMgG89O0k/9jrnfYr5AEzHU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-KCVD7BVlOhWNQgDhwdbZIw-1; Tue, 31 Jan 2023 15:54:36 -0500
X-MC-Unique: KCVD7BVlOhWNQgDhwdbZIw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF619811E6E;
        Tue, 31 Jan 2023 20:54:34 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2184040C2064;
        Tue, 31 Jan 2023 20:54:28 +0000 (UTC)
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
Subject: [RFC v3 12/18] vfio/container-base: Introduce [attach/detach]_device container callbacks
Date:   Tue, 31 Jan 2023 21:52:59 +0100
Message-Id: <20230131205305.2726330-13-eric.auger@redhat.com>
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

Let's turn attach/detach_device as container callbacks. That way,
their implementation can be easily customized for a given backend.

For the time being, only the legacy container is supported.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 include/hw/vfio/vfio-common.h         |  1 +
 include/hw/vfio/vfio-container-base.h |  2 ++
 hw/vfio/as.c                          | 21 +++++++++++++++++++++
 hw/vfio/container.c                   |  9 +++++++--
 hw/vfio/pci.c                         |  2 +-
 5 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 1580f9617c..4f89657ac1 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -86,6 +86,7 @@ typedef struct VFIODeviceOps VFIODeviceOps;
 typedef struct VFIODevice {
     QLIST_ENTRY(VFIODevice) next;
     struct VFIOGroup *group;
+    VFIOContainer *container;
     char *sysfsdev;
     char *name;
     DeviceState *dev;
diff --git a/include/hw/vfio/vfio-container-base.h b/include/hw/vfio/vfio-container-base.h
index 6080a588bf..5e47faf293 100644
--- a/include/hw/vfio/vfio-container-base.h
+++ b/include/hw/vfio/vfio-container-base.h
@@ -133,6 +133,8 @@ struct VFIOIOMMUBackendOpsClass {
     int (*dma_unmap)(VFIOContainer *container,
                      hwaddr iova, ram_addr_t size,
                      IOMMUTLBEntry *iotlb);
+    int (*attach_device)(VFIODevice *vbasedev, AddressSpace *as, Error **errp);
+    void (*detach_device)(VFIODevice *vbasedev);
     /* migration feature */
     bool (*devices_all_dirty_tracking)(VFIOContainer *container);
     void (*set_dirty_page_tracking)(VFIOContainer *container, bool start);
diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index 6a5f3f80b5..d212974b9b 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -851,6 +851,27 @@ void vfio_put_address_space(VFIOAddressSpace *space)
     }
 }
 
+int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
+{
+    const VFIOIOMMUBackendOpsClass *ops;
+
+    ops = VFIO_IOMMU_BACKEND_OPS_CLASS(
+                  object_class_by_name(TYPE_VFIO_IOMMU_BACKEND_LEGACY_OPS));
+    if (!ops) {
+        error_setg(errp, "VFIO IOMMU Backend not found!");
+        return -ENODEV;
+    }
+    return ops->attach_device(vbasedev, as, errp);
+}
+
+void vfio_detach_device(VFIODevice *vbasedev)
+{
+    if (!vbasedev->container) {
+        return;
+    }
+    vbasedev->container->ops->detach_device(vbasedev);
+}
+
 static const TypeInfo vfio_iommu_backend_ops_type_info = {
     .name = TYPE_VFIO_IOMMU_BACKEND_OPS,
     .parent = TYPE_OBJECT,
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index b9ee56067c..e99d12f4d8 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -1278,7 +1278,8 @@ static int vfio_device_groupid(VFIODevice *vbasedev, Error **errp)
     return groupid;
 }
 
-int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
+static int
+vfio_legacy_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
 {
     int groupid = vfio_device_groupid(vbasedev, errp);
     VFIODevice *vbasedev_iter;
@@ -1307,14 +1308,16 @@ int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
         vfio_put_group(group);
         return -1;
     }
+    vbasedev->container = &group->container->bcontainer;
 
     return 0;
 }
 
-void vfio_detach_device(VFIODevice *vbasedev)
+static void vfio_legacy_detach_device(VFIODevice *vbasedev)
 {
     vfio_put_base_device(vbasedev);
     vfio_put_group(vbasedev->group);
+    vbasedev->container = NULL;
 }
 
 static void vfio_iommu_backend_legacy_ops_class_init(ObjectClass *oc,
@@ -1329,6 +1332,8 @@ static void vfio_iommu_backend_legacy_ops_class_init(ObjectClass *oc,
     ops->add_window = vfio_legacy_container_add_section_window;
     ops->del_window = vfio_legacy_container_del_section_window;
     ops->check_extension = vfio_legacy_container_check_extension;
+    ops->attach_device = vfio_legacy_attach_device;
+    ops->detach_device = vfio_legacy_detach_device;
 }
 
 static const TypeInfo vfio_iommu_backend_legacy_ops_type = {
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 9856d81819..07361a6fcd 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -3106,7 +3106,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     }
 
     if (!pdev->failover_pair_id &&
-        vfio_container_check_extension(&vbasedev->group->container->bcontainer,
+        vfio_container_check_extension(vbasedev->container,
                                        VFIO_FEAT_LIVE_MIGRATION)) {
         ret = vfio_migration_probe(vbasedev, errp);
         if (ret) {
-- 
2.37.3

