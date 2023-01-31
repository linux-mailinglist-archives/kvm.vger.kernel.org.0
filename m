Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99573683808
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjAaUzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjAaUzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:55:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BA993FF
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tT440oPsmvWe/E/zglkAuS0Ga4poZPOBe1uTUysR0cY=;
        b=HoqJXTvsS9cXWeZVz1ktq+scUwsARztALH8C9n3gBJTjMZvFqSV3l2mdO22HffBG6H6boH
        cTfv4Ffg3JcE7HUNU+NtPo3GtNAiPCk13AjLu/nraNJeei/yIOvjOTVazshGol8EU60Gw0
        SSRNoosukhuok1x4gFvJGelYrA2/SWM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-cTHNZsW8PLWB80HhygJ1MQ-1; Tue, 31 Jan 2023 15:54:42 -0500
X-MC-Unique: cTHNZsW8PLWB80HhygJ1MQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 937AA2804823;
        Tue, 31 Jan 2023 20:54:41 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E49840C2064;
        Tue, 31 Jan 2023 20:54:35 +0000 (UTC)
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
Subject: [RFC v3 13/18] vfio/container-base: Introduce VFIOContainer reset callback
Date:   Tue, 31 Jan 2023 21:53:00 +0100
Message-Id: <20230131205305.2726330-14-eric.auger@redhat.com>
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

Reset implementation depends on the container backend. Let's
introduce a VFIOContainer class function and register a generic
reset handler that will be able to call the right reset function
depending on the container type. Also, let's move the
registration/unregistration to a place that is not backend-specific
(first vfio address space created instead of the first group).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 include/hw/vfio/vfio-container-base.h |  2 ++
 hw/vfio/as.c                          | 18 ++++++++++++++++++
 hw/vfio/container-base.c              |  9 +++++++++
 hw/vfio/container.c                   | 27 +++++++++++++++------------
 4 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/include/hw/vfio/vfio-container-base.h b/include/hw/vfio/vfio-container-base.h
index 5e47faf293..8ffd94f8ae 100644
--- a/include/hw/vfio/vfio-container-base.h
+++ b/include/hw/vfio/vfio-container-base.h
@@ -97,6 +97,7 @@ int vfio_container_dma_map(VFIOContainer *container,
 int vfio_container_dma_unmap(VFIOContainer *container,
                              hwaddr iova, ram_addr_t size,
                              IOMMUTLBEntry *iotlb);
+int vfio_container_reset(VFIOContainer *container);
 bool vfio_container_devices_all_dirty_tracking(VFIOContainer *container);
 void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
                                             bool start);
@@ -135,6 +136,7 @@ struct VFIOIOMMUBackendOpsClass {
                      IOMMUTLBEntry *iotlb);
     int (*attach_device)(VFIODevice *vbasedev, AddressSpace *as, Error **errp);
     void (*detach_device)(VFIODevice *vbasedev);
+    int (*reset)(VFIOContainer *container);
     /* migration feature */
     bool (*devices_all_dirty_tracking)(VFIOContainer *container);
     void (*set_dirty_page_tracking)(VFIOContainer *container, bool start);
diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index d212974b9b..f186d0b789 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -823,6 +823,18 @@ const MemoryListener vfio_memory_listener = {
     .log_sync = vfio_listener_log_sync,
 };
 
+void vfio_reset_handler(void *opaque)
+{
+    VFIOAddressSpace *space;
+    VFIOContainer *bcontainer;
+
+    QLIST_FOREACH(space, &vfio_address_spaces, list) {
+         QLIST_FOREACH(bcontainer, &space->containers, next) {
+             vfio_container_reset(bcontainer);
+         }
+    }
+}
+
 VFIOAddressSpace *vfio_get_address_space(AddressSpace *as)
 {
     VFIOAddressSpace *space;
@@ -838,6 +850,9 @@ VFIOAddressSpace *vfio_get_address_space(AddressSpace *as)
     space->as = as;
     QLIST_INIT(&space->containers);
 
+    if (QLIST_EMPTY(&vfio_address_spaces)) {
+        qemu_register_reset(vfio_reset_handler, NULL);
+    }
     QLIST_INSERT_HEAD(&vfio_address_spaces, space, list);
 
     return space;
@@ -849,6 +864,9 @@ void vfio_put_address_space(VFIOAddressSpace *space)
         QLIST_REMOVE(space, list);
         g_free(space);
     }
+    if (QLIST_EMPTY(&vfio_address_spaces)) {
+        qemu_unregister_reset(vfio_reset_handler, NULL);
+    }
 }
 
 int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
index b4ce0cd89a..3ae939c6c9 100644
--- a/hw/vfio/container-base.c
+++ b/hw/vfio/container-base.c
@@ -58,6 +58,15 @@ int vfio_container_dma_unmap(VFIOContainer *container,
     return container->ops->dma_unmap(container, iova, size, iotlb);
 }
 
+int vfio_container_reset(VFIOContainer *container)
+{
+    if (!container->ops->reset) {
+        return -ENOENT;
+    }
+
+    return container->ops->reset(container);
+}
+
 void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
                                             bool start)
 {
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index e99d12f4d8..61caf388c2 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -520,12 +520,16 @@ bool vfio_get_info_dma_avail(struct vfio_iommu_type1_info *info,
     return true;
 }
 
-void vfio_reset_handler(void *opaque)
+static int vfio_legacy_container_reset(VFIOContainer *bcontainer)
 {
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer,
+                                                  bcontainer);
     VFIOGroup *group;
     VFIODevice *vbasedev;
+    int ret, final_ret = 0;
 
-    QLIST_FOREACH(group, &vfio_group_list, next) {
+    QLIST_FOREACH(group, &container->group_list, container_next) {
         QLIST_FOREACH(vbasedev, &group->device_list, next) {
             if (vbasedev->dev->realized) {
                 vbasedev->ops->vfio_compute_needs_reset(vbasedev);
@@ -533,13 +537,19 @@ void vfio_reset_handler(void *opaque)
         }
     }
 
-    QLIST_FOREACH(group, &vfio_group_list, next) {
+    QLIST_FOREACH(group, &container->group_list, next) {
         QLIST_FOREACH(vbasedev, &group->device_list, next) {
             if (vbasedev->dev->realized && vbasedev->needs_reset) {
-                vbasedev->ops->vfio_hot_reset_multi(vbasedev);
+                ret = vbasedev->ops->vfio_hot_reset_multi(vbasedev);
+                if (ret) {
+                    error_report("failed to reset %s (%d)",
+                                 vbasedev->name, ret);
+                    final_ret = ret;
+                }
             }
         }
     }
+    return final_ret;
 }
 
 static void vfio_kvm_device_add_group(VFIOGroup *group)
@@ -1045,10 +1055,6 @@ static VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
         goto close_fd_exit;
     }
 
-    if (QLIST_EMPTY(&vfio_group_list)) {
-        qemu_register_reset(vfio_reset_handler, NULL);
-    }
-
     QLIST_INSERT_HEAD(&vfio_group_list, group, next);
 
     return group;
@@ -1077,10 +1083,6 @@ static void vfio_put_group(VFIOGroup *group)
     trace_vfio_put_group(group->fd);
     close(group->fd);
     g_free(group);
-
-    if (QLIST_EMPTY(&vfio_group_list)) {
-        qemu_unregister_reset(vfio_reset_handler, NULL);
-    }
 }
 
 static int vfio_get_device(VFIOGroup *group, const char *name,
@@ -1334,6 +1336,7 @@ static void vfio_iommu_backend_legacy_ops_class_init(ObjectClass *oc,
     ops->check_extension = vfio_legacy_container_check_extension;
     ops->attach_device = vfio_legacy_attach_device;
     ops->detach_device = vfio_legacy_detach_device;
+    ops->reset = vfio_legacy_container_reset;
 }
 
 static const TypeInfo vfio_iommu_backend_legacy_ops_type = {
-- 
2.37.3

