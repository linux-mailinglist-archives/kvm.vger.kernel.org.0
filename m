Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486026837F8
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjAaUy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjAaUy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:54:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A81126FC
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aL3KZs/pC+fqWfEumq8Atcv219x2+K64zAY++am9sWA=;
        b=dVDiX3GXiSDXbQCQ05FAYvq77Q+qdrna2NefKkVGELzj/ZXY3+1AXQBhV4qgkXIJSUMkD3
        WwoIi4WIES8IC/6N9ow6neFjqCEajHph2ZUnGP393L8vowujbT28XdnQTyyFF5d/YG+Bq9
        pI41uuhq4ixaiDsEvJ5URJ3cwo7/c4M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-MjJLiH1YPOC3jkBu1cs8CQ-1; Tue, 31 Jan 2023 15:53:42 -0500
X-MC-Unique: MjJLiH1YPOC3jkBu1cs8CQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA79A80C8C2;
        Tue, 31 Jan 2023 20:53:41 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 284C040C2064;
        Tue, 31 Jan 2023 20:53:35 +0000 (UTC)
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
Subject: [RFC v3 04/18] vfio/common: Introduce vfio_container_add|del_section_window()
Date:   Tue, 31 Jan 2023 21:52:51 +0100
Message-Id: <20230131205305.2726330-5-eric.auger@redhat.com>
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

Introduce helper functions that isolate the code used for
VFIO_SPAPR_TCE_v2_IOMMU. This code relies is IOMMU backend
specific whereas the rest of the code in the callers, ie.
vfio_listener_region_add|del is not.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/common.c | 156 +++++++++++++++++++++++++++--------------------
 1 file changed, 89 insertions(+), 67 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index f9ae28d5b9..f976a1b662 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -590,6 +590,92 @@ static bool vfio_known_safe_misalignment(MemoryRegionSection *section)
     return true;
 }
 
+static int vfio_container_add_section_window(VFIOContainer *container,
+                                             MemoryRegionSection *section,
+                                             Error **errp)
+{
+    VFIOHostDMAWindow *hostwin;
+    hwaddr pgsize = 0;
+    int ret;
+
+    if (container->iommu_type != VFIO_SPAPR_TCE_v2_IOMMU) {
+        return 0;
+    }
+
+    /* For now intersections are not allowed, we may relax this later */
+    QLIST_FOREACH(hostwin, &container->hostwin_list, hostwin_next) {
+        if (ranges_overlap(hostwin->min_iova,
+                           hostwin->max_iova - hostwin->min_iova + 1,
+                           section->offset_within_address_space,
+                           int128_get64(section->size))) {
+            error_setg(errp,
+                "region [0x%"PRIx64",0x%"PRIx64"] overlaps with existing"
+                "host DMA window [0x%"PRIx64",0x%"PRIx64"]",
+                section->offset_within_address_space,
+                section->offset_within_address_space +
+                    int128_get64(section->size) - 1,
+                hostwin->min_iova, hostwin->max_iova);
+            return -EINVAL;
+        }
+    }
+
+    ret = vfio_spapr_create_window(container, section, &pgsize);
+    if (ret) {
+        error_setg_errno(errp, -ret, "Failed to create SPAPR window");
+        return ret;
+    }
+
+    vfio_host_win_add(container, section->offset_within_address_space,
+                      section->offset_within_address_space +
+                      int128_get64(section->size) - 1, pgsize);
+#ifdef CONFIG_KVM
+    if (kvm_enabled()) {
+        VFIOGroup *group;
+        IOMMUMemoryRegion *iommu_mr = IOMMU_MEMORY_REGION(section->mr);
+        struct kvm_vfio_spapr_tce param;
+        struct kvm_device_attr attr = {
+            .group = KVM_DEV_VFIO_GROUP,
+            .attr = KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE,
+            .addr = (uint64_t)(unsigned long)&param,
+        };
+
+        if (!memory_region_iommu_get_attr(iommu_mr, IOMMU_ATTR_SPAPR_TCE_FD,
+                                          &param.tablefd)) {
+            QLIST_FOREACH(group, &container->group_list, container_next) {
+                param.groupfd = group->fd;
+                if (ioctl(vfio_kvm_device_fd, KVM_SET_DEVICE_ATTR, &attr)) {
+                    error_report("vfio: failed to setup fd %d "
+                                 "for a group with fd %d: %s",
+                                 param.tablefd, param.groupfd,
+                                 strerror(errno));
+                    return 0;
+                }
+                trace_vfio_spapr_group_attach(param.groupfd, param.tablefd);
+            }
+        }
+    }
+#endif
+    return 0;
+}
+
+static void vfio_container_del_section_window(VFIOContainer *container,
+                                              MemoryRegionSection *section)
+{
+    if (container->iommu_type != VFIO_SPAPR_TCE_v2_IOMMU) {
+        return;
+    }
+
+    vfio_spapr_remove_window(container,
+                             section->offset_within_address_space);
+    if (vfio_host_win_del(container,
+                          section->offset_within_address_space,
+                          section->offset_within_address_space +
+                          int128_get64(section->size) - 1) < 0) {
+        hw_error("%s: Cannot delete missing window at %"HWADDR_PRIx,
+                 __func__, section->offset_within_address_space);
+    }
+}
+
 static void vfio_listener_region_add(MemoryListener *listener,
                                      MemoryRegionSection *section)
 {
@@ -642,62 +728,8 @@ static void vfio_listener_region_add(MemoryListener *listener,
     }
     end = int128_get64(int128_sub(llend, int128_one()));
 
-    if (container->iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
-        hwaddr pgsize = 0;
-
-        /* For now intersections are not allowed, we may relax this later */
-        QLIST_FOREACH(hostwin, &container->hostwin_list, hostwin_next) {
-            if (ranges_overlap(hostwin->min_iova,
-                               hostwin->max_iova - hostwin->min_iova + 1,
-                               section->offset_within_address_space,
-                               int128_get64(section->size))) {
-                error_setg(&err,
-                    "region [0x%"PRIx64",0x%"PRIx64"] overlaps with existing"
-                    "host DMA window [0x%"PRIx64",0x%"PRIx64"]",
-                    section->offset_within_address_space,
-                    section->offset_within_address_space +
-                        int128_get64(section->size) - 1,
-                    hostwin->min_iova, hostwin->max_iova);
-                goto fail;
-            }
-        }
-
-        ret = vfio_spapr_create_window(container, section, &pgsize);
-        if (ret) {
-            error_setg_errno(&err, -ret, "Failed to create SPAPR window");
-            goto fail;
-        }
-
-        vfio_host_win_add(container, section->offset_within_address_space,
-                          section->offset_within_address_space +
-                          int128_get64(section->size) - 1, pgsize);
-#ifdef CONFIG_KVM
-        if (kvm_enabled()) {
-            VFIOGroup *group;
-            IOMMUMemoryRegion *iommu_mr = IOMMU_MEMORY_REGION(section->mr);
-            struct kvm_vfio_spapr_tce param;
-            struct kvm_device_attr attr = {
-                .group = KVM_DEV_VFIO_GROUP,
-                .attr = KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE,
-                .addr = (uint64_t)(unsigned long)&param,
-            };
-
-            if (!memory_region_iommu_get_attr(iommu_mr, IOMMU_ATTR_SPAPR_TCE_FD,
-                                              &param.tablefd)) {
-                QLIST_FOREACH(group, &container->group_list, container_next) {
-                    param.groupfd = group->fd;
-                    if (ioctl(vfio_kvm_device_fd, KVM_SET_DEVICE_ATTR, &attr)) {
-                        error_report("vfio: failed to setup fd %d "
-                                     "for a group with fd %d: %s",
-                                     param.tablefd, param.groupfd,
-                                     strerror(errno));
-                        return;
-                    }
-                    trace_vfio_spapr_group_attach(param.groupfd, param.tablefd);
-                }
-            }
-        }
-#endif
+    if (vfio_container_add_section_window(container, section, &err)) {
+        goto fail;
     }
 
     hostwin_found = false;
@@ -949,17 +981,7 @@ static void vfio_listener_region_del(MemoryListener *listener,
 
     memory_region_unref(section->mr);
 
-    if (container->iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
-        vfio_spapr_remove_window(container,
-                                 section->offset_within_address_space);
-        if (vfio_host_win_del(container,
-                              section->offset_within_address_space,
-                              section->offset_within_address_space +
-                              int128_get64(section->size) - 1) < 0) {
-            hw_error("%s: Cannot delete missing window at %"HWADDR_PRIx,
-                     __func__, section->offset_within_address_space);
-        }
-    }
+    vfio_container_del_section_window(container, section);
 }
 
 static void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start)
-- 
2.37.3

