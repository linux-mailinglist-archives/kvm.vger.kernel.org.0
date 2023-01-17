Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16AE966DF5C
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjAQNuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjAQNuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:50:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71B03BD8F
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963396; x=1705499396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0brp71RRn7FOg/UwHpM47C6iY/eRONq/BgCLQUmWljI=;
  b=Tv4yA5fTL9ZKD5fKPiao4l1z9YdJI4DxL4WENqqsYdnPpqChruQYB69U
   rL+jNaw6+Lkp7z21UZ54qluZWOLo99lqWdhDN1QFsDGRp5snZsrVQHfiq
   bA/m1yvKrwqIx4AoCKxfboAt7u5HroUS11pRUBW4Hd20tdFgDniRh+HHl
   yHQxF20+hS0nF3dZScdRnsdO49z2pYouUhdr+5AreT0UPqqN3oEorSH9X
   l3o5+rakVGe6UoJNGsYYG3eHDdkCMTxTTaWPy4IjOh+KRzWaOJAkI51th
   puexkLn5G8XW4hbQ7hTXieLWs7UqgmErezjobRaPg+meLR+N//buxKSSB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766450"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766450"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:49:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551072"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551072"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:56 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: [PATCH 09/13] vfio: Add infrastructure for bind_iommufd and attach
Date:   Tue, 17 Jan 2023 05:49:38 -0800
Message-Id: <20230117134942.101112-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117134942.101112-1-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This prepares to add ioctls for device cdev fd. This infrastructure includes:
    - add vfio_iommufd_attach() to support iommufd pgtable attach after
      bind_iommufd. A NULL pt_id indicates detach.
    - let vfio_iommufd_bind() to accept pt_id, e.g. the comapt_ioas_id in the
      legacy group path, and also return back dev_id if caller requires it.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 12 +++++-
 drivers/vfio/iommufd.c   | 79 ++++++++++++++++++++++++++++++----------
 drivers/vfio/vfio.h      | 15 ++++++--
 drivers/vfio/vfio_main.c | 10 +++--
 4 files changed, 88 insertions(+), 28 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 7200304663e5..9484bb1c54a9 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -157,6 +157,8 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 static int vfio_device_group_open(struct vfio_device_file *df)
 {
 	struct vfio_device *device = df->device;
+	u32 ioas_id;
+	u32 *pt_id = NULL;
 	int ret;
 
 	mutex_lock(&device->group->group_lock);
@@ -165,6 +167,14 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 		goto err_unlock_group;
 	}
 
+	if (device->group->iommufd) {
+		ret = iommufd_vfio_compat_ioas_id(device->group->iommufd,
+						  &ioas_id);
+		if (ret)
+			goto err_unlock_group;
+		pt_id = &ioas_id;
+	}
+
 	mutex_lock(&device->dev_set->lock);
 	/*
 	 * Here we pass the KVM pointer with the group under the lock.  If the
@@ -174,7 +184,7 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 	df->kvm = device->group->kvm;
 	df->iommufd = device->group->iommufd;
 
-	ret = vfio_device_open(df);
+	ret = vfio_device_open(df, NULL, pt_id);
 	if (ret)
 		goto err_unlock_device;
 	mutex_unlock(&device->dev_set->lock);
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 4f82a6fa7c6c..412644fdbf16 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -10,9 +10,17 @@
 MODULE_IMPORT_NS(IOMMUFD);
 MODULE_IMPORT_NS(IOMMUFD_VFIO);
 
-int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
+/* @pt_id == NULL implies detach */
+int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	return vdev->ops->attach_ioas(vdev, pt_id);
+}
+
+int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx,
+		      u32 *dev_id, u32 *pt_id)
 {
-	u32 ioas_id;
 	u32 device_id;
 	int ret;
 
@@ -29,17 +37,14 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 	if (ret)
 		return ret;
 
-	ret = iommufd_vfio_compat_ioas_id(ictx, &ioas_id);
-	if (ret)
-		goto err_unbind;
-	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
-	if (ret)
-		goto err_unbind;
+	if (pt_id) {
+		ret = vfio_iommufd_attach(vdev, pt_id);
+		if (ret)
+			goto err_unbind;
+	}
 
-	/*
-	 * The legacy path has no way to return the device id or the selected
-	 * pt_id
-	 */
+	if (dev_id)
+		*dev_id = device_id;
 	return 0;
 
 err_unbind:
@@ -74,14 +79,18 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_physical_bind);
 
+static void __vfio_iommufd_detach(struct vfio_device *vdev)
+{
+	iommufd_device_detach(vdev->iommufd_device);
+	vdev->iommufd_attached = false;
+}
+
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vdev->iommufd_attached) {
-		iommufd_device_detach(vdev->iommufd_device);
-		vdev->iommufd_attached = false;
-	}
+	if (vdev->iommufd_attached)
+		__vfio_iommufd_detach(vdev);
 	iommufd_device_unbind(vdev->iommufd_device);
 	vdev->iommufd_device = NULL;
 }
@@ -91,6 +100,20 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 {
 	int rc;
 
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (!vdev->iommufd_device)
+		return -EINVAL;
+
+	if (!pt_id) {
+		if (vdev->iommufd_attached)
+			__vfio_iommufd_detach(vdev);
+		return 0;
+	}
+
+	if (vdev->iommufd_attached)
+		return -EBUSY;
+
 	rc = iommufd_device_attach(vdev->iommufd_device, pt_id);
 	if (rc)
 		return rc;
@@ -129,14 +152,18 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_bind);
 
+static void __vfio_iommufd_access_destroy(struct vfio_device *vdev)
+{
+	iommufd_access_destroy(vdev->iommufd_access);
+	vdev->iommufd_access = NULL;
+}
+
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vdev->iommufd_access) {
-		iommufd_access_destroy(vdev->iommufd_access);
-		vdev->iommufd_access = NULL;
-	}
+	if (vdev->iommufd_access)
+		__vfio_iommufd_access_destroy(vdev);
 	iommufd_ctx_put(vdev->iommufd_ictx);
 	vdev->iommufd_ictx = NULL;
 }
@@ -148,6 +175,18 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	if (!vdev->iommufd_ictx)
+		return -EINVAL;
+
+	if (!pt_id) {
+		if (vdev->iommufd_access)
+			__vfio_iommufd_access_destroy(vdev);
+		return 0;
+	}
+
+	if (vdev->iommufd_access)
+		return -EBUSY;
+
 	user = iommufd_access_create(vdev->iommufd_ictx, *pt_id, &vfio_user_ops,
 				     vdev);
 	if (IS_ERR(user))
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index c69a9902ea84..fe0fcfa78710 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -25,7 +25,8 @@ struct vfio_device_file {
 
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
-int vfio_device_open(struct vfio_device_file *df);
+int vfio_device_open(struct vfio_device_file *df,
+		     u32 *dev_id, u32 *pt_id);
 void vfio_device_close(struct vfio_device_file *device);
 
 struct vfio_device_file *
@@ -230,11 +231,14 @@ static inline void vfio_container_cleanup(void)
 #endif
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
-int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
+int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx,
+		      u32 *dev_id, u32 *pt_id);
 void vfio_iommufd_unbind(struct vfio_device *device);
+int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id);
 #else
 static inline int vfio_iommufd_bind(struct vfio_device *device,
-				    struct iommufd_ctx *ictx)
+				    struct iommufd_ctx *ictx,
+				    u32 *dev_id, u32 *pt_id)
 {
 	return -EOPNOTSUPP;
 }
@@ -242,6 +246,11 @@ static inline int vfio_iommufd_bind(struct vfio_device *device,
 static inline void vfio_iommufd_unbind(struct vfio_device *device)
 {
 }
+
+static inline int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index d442ebaa4b21..90174a9015c4 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -358,7 +358,8 @@ vfio_allocate_device_file(struct vfio_device *device)
 	return df;
 }
 
-static int vfio_device_first_open(struct vfio_device_file *df)
+static int vfio_device_first_open(struct vfio_device_file *df,
+				  u32 *dev_id, u32 *pt_id)
 {
 	struct vfio_device *device = df->device;
 	struct iommufd_ctx *iommufd = df->iommufd;
@@ -371,7 +372,7 @@ static int vfio_device_first_open(struct vfio_device_file *df)
 		return -ENODEV;
 
 	if (iommufd)
-		ret = vfio_iommufd_bind(device, iommufd);
+		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
 	else
 		ret = vfio_device_group_use_iommu(device);
 	if (ret)
@@ -413,7 +414,8 @@ static void vfio_device_last_close(struct vfio_device_file *df)
 	module_put(device->dev->driver->owner);
 }
 
-int vfio_device_open(struct vfio_device_file *df)
+int vfio_device_open(struct vfio_device_file *df,
+		     u32 *dev_id, u32 *pt_id)
 {
 	struct vfio_device *device = df->device;
 
@@ -423,7 +425,7 @@ int vfio_device_open(struct vfio_device_file *df)
 	if (device->open_count == 1) {
 		int ret;
 
-		ret = vfio_device_first_open(df);
+		ret = vfio_device_first_open(df, dev_id, pt_id);
 		if (ret) {
 			device->open_count--;
 			return ret;
-- 
2.34.1

