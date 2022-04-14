Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B18500B79
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242501AbiDNKuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242489AbiDNKt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:49:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277E48119F
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933245; x=1681469245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0YDGzdA0v7DGQjpQ43n6QGUsR6hhCiY+JzhRyO8LL5g=;
  b=h7wWReNVUJEyvBe74yXuPbpDS5RS3vYwhntK4bnapy0rxvzQadMi/4tX
   tHukBsnOZwN8RYScAbGVj709LDNh0mJqAdIHv9n1RDng4ISzqvhPcf8q4
   rUC7qMjOF5tGDK52MLnZiS3IFP6HRT8qOZSotN0QDKWEmDi73r4/ezqQL
   uvVOZ+0kDymrCOlbWL8ETHQmC47jnZ2AtU1XSJ70E9UupXJDV5FXBQ5bv
   T+ivLSnexkbDdIdxSQKUpd9fUo0pkQ2as2EmOl76EY18Q7KFXnmOYYNki
   KpcZthiH2x/7p6gq4YDiBDhI5o87QHt7IPYt6SqIu8KX2lRFKkCHGRYEJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808693"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808693"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091238"
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
Subject: [RFC 12/18] vfio/container-obj: Introduce [attach/detach]_device container callbacks
Date:   Thu, 14 Apr 2022 03:47:04 -0700
Message-Id: <20220414104710.28534-13-yi.l.liu@intel.com>
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

Let's turn attach/detach_device as container callbacks. That way,
their implementation can be easily customized for a given backend.

For the time being, only the legacy container is supported.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/as.c                         | 36 ++++++++++++++++++++++++++++
 hw/vfio/container.c                  | 11 +++++----
 hw/vfio/pci.c                        |  2 +-
 include/hw/vfio/vfio-common.h        |  7 ++++++
 include/hw/vfio/vfio-container-obj.h |  6 +++++
 5 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index 37423d2c89..30e86f6833 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -874,3 +874,39 @@ void vfio_put_address_space(VFIOAddressSpace *space)
         g_free(space);
     }
 }
+
+static VFIOContainerClass *
+vfio_get_container_class(VFIOIOMMUBackendType be)
+{
+    ObjectClass *klass;
+
+    switch (be) {
+    case VFIO_IOMMU_BACKEND_TYPE_LEGACY:
+        klass = object_class_by_name(TYPE_VFIO_LEGACY_CONTAINER);
+        return VFIO_CONTAINER_OBJ_CLASS(klass);
+    default:
+        return NULL;
+    }
+}
+
+int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
+{
+    VFIOContainerClass *vccs;
+
+    vccs = vfio_get_container_class(VFIO_IOMMU_BACKEND_TYPE_LEGACY);
+    if (!vccs) {
+        return -ENOENT;
+    }
+    return vccs->attach_device(vbasedev, as, errp);
+}
+
+void vfio_detach_device(VFIODevice *vbasedev)
+{
+    VFIOContainerClass *vccs;
+
+    if (!vbasedev->container) {
+        return;
+    }
+    vccs = VFIO_CONTAINER_OBJ_GET_CLASS(vbasedev->container);
+    vccs->detach_device(vbasedev);
+}
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index 5d73f8285e..74febc1567 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -50,8 +50,6 @@
 static int vfio_kvm_device_fd = -1;
 #endif
 
-#define TYPE_VFIO_LEGACY_CONTAINER "qemu:vfio-legacy-container"
-
 VFIOGroupList vfio_group_list =
     QLIST_HEAD_INITIALIZER(vfio_group_list);
 
@@ -1240,7 +1238,8 @@ static int vfio_device_groupid(VFIODevice *vbasedev, Error **errp)
     return groupid;
 }
 
-int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
+static int
+legacy_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
 {
     int groupid = vfio_device_groupid(vbasedev, errp);
     VFIODevice *vbasedev_iter;
@@ -1269,14 +1268,16 @@ int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
         vfio_put_group(group);
         return -1;
     }
+    vbasedev->container = &group->container->obj;
 
     return 0;
 }
 
-void vfio_detach_device(VFIODevice *vbasedev)
+static void legacy_detach_device(VFIODevice *vbasedev)
 {
     vfio_put_base_device(vbasedev);
     vfio_put_group(vbasedev->group);
+    vbasedev->container = NULL;
 }
 
 static void vfio_legacy_container_class_init(ObjectClass *klass,
@@ -1292,6 +1293,8 @@ static void vfio_legacy_container_class_init(ObjectClass *klass,
     vccs->add_window = vfio_legacy_container_add_section_window;
     vccs->del_window = vfio_legacy_container_del_section_window;
     vccs->check_extension = vfio_legacy_container_check_extension;
+    vccs->attach_device = legacy_attach_device;
+    vccs->detach_device = legacy_detach_device;
 }
 
 static const TypeInfo vfio_legacy_container_info = {
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 0363f81017..e1ab6d339d 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -3063,7 +3063,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     }
 
     if (!pdev->failover_pair_id &&
-        vfio_container_check_extension(&vbasedev->group->container->obj,
+        vfio_container_check_extension(vbasedev->container,
                                        VFIO_FEAT_LIVE_MIGRATION)) {
         ret = vfio_migration_probe(vbasedev, errp);
         if (ret) {
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 7d7898717e..2040c27cda 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -83,9 +83,15 @@ typedef struct VFIOLegacyContainer {
 
 typedef struct VFIODeviceOps VFIODeviceOps;
 
+typedef enum VFIOIOMMUBackendType {
+    VFIO_IOMMU_BACKEND_TYPE_LEGACY = 0,
+    VFIO_IOMMU_BACKEND_TYPE_IOMMUFD = 1,
+} VFIOIOMMUBackendType;
+
 typedef struct VFIODevice {
     QLIST_ENTRY(VFIODevice) next;
     struct VFIOGroup *group;
+    VFIOContainer *container;
     char *sysfsdev;
     char *name;
     DeviceState *dev;
@@ -97,6 +103,7 @@ typedef struct VFIODevice {
     bool ram_block_discard_allowed;
     bool enable_migration;
     VFIODeviceOps *ops;
+    VFIOIOMMUBackendType be;
     unsigned int num_irqs;
     unsigned int num_regions;
     unsigned int flags;
diff --git a/include/hw/vfio/vfio-container-obj.h b/include/hw/vfio/vfio-container-obj.h
index 7ffbbb299f..ebc1340530 100644
--- a/include/hw/vfio/vfio-container-obj.h
+++ b/include/hw/vfio/vfio-container-obj.h
@@ -42,6 +42,8 @@
         OBJECT_GET_CLASS(VFIOContainerClass, (obj), \
                          TYPE_VFIO_CONTAINER_OBJ)
 
+#define TYPE_VFIO_LEGACY_CONTAINER "qemu:vfio-legacy-container"
+
 typedef enum VFIOContainerFeature {
     VFIO_FEAT_LIVE_MIGRATION,
 } VFIOContainerFeature;
@@ -101,6 +103,8 @@ struct VFIOContainer {
     QLIST_ENTRY(VFIOContainer) next;
 };
 
+typedef struct VFIODevice VFIODevice;
+
 typedef struct VFIOContainerClass {
     /* private */
     ObjectClass parent_class;
@@ -126,6 +130,8 @@ typedef struct VFIOContainerClass {
                       Error **errp);
     void (*del_window)(VFIOContainer *container,
                        MemoryRegionSection *section);
+    int (*attach_device)(VFIODevice *vbasedev, AddressSpace *as, Error **errp);
+    void (*detach_device)(VFIODevice *vbasedev);
 } VFIOContainerClass;
 
 bool vfio_container_check_extension(VFIOContainer *container,
-- 
2.27.0

