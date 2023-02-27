Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACECA6A402E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjB0LLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjB0LLu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:11:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23A81DB9A;
        Mon, 27 Feb 2023 03:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677496308; x=1709032308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v5DbAEvoWqQIHsyE4GEmtXMv65O6AV61xf7I7SUNG48=;
  b=FteFv0lLVfSs8Dqn1U/kdSdjDlXVUyS1u+k9L38vxjfhtFW5jGf4MndH
   7U+FSw1fYRXX1CX4c1RMkf+4QTWE9nb3vu40D223/7pf3TkgytntHYFAW
   FrZOWVX7PHFPOUmoe8rK5KlZB73MMsR+AOoZAX5S/u39ar/7RZ7b60ndY
   KcCj63IpHRFa7YpLeHz+7xFf2u9rbBreYKSBiLxGPVEPv2dh79z6VrVfM
   gfl8XLQIPhEQHcc9PxrKZXeFBDLgdNNOP3ihgLzfbJemT6Di1xdb/mpZY
   PtS2o7TL02TkBTe9zR0Cm8yIb3v89I4w/zahs1OFuc0746OTBZ4IkkqY1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="420097680"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="420097680"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 03:11:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651189529"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651189529"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 03:11:44 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from userspace
Date:   Mon, 27 Feb 2023 03:11:26 -0800
Message-Id: <20230227111135.61728-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230227111135.61728-1-yi.l.liu@intel.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
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

For the device fd opened from cdev, userspace needs to bind it to an
iommufd and attach it to IOAS managed by iommufd. With such operations,
userspace can set up a secure DMA context and hence access device.

This changes the existing vfio_iommufd_bind() to accept a pt_id pointer
as an optional input, and also an dev_id pointer to selectively return
the dev_id to prepare for adding bind_iommufd ioctl, which does the bind
first and then attach IOAS.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/group.c     | 17 ++++++++++++++---
 drivers/vfio/iommufd.c   | 21 +++++++++------------
 drivers/vfio/vfio.h      |  9 ++++++---
 drivers/vfio/vfio_main.c | 10 ++++++----
 4 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index d8771d585cb1..e44232551448 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -169,6 +169,7 @@ static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
 static int vfio_device_group_open(struct vfio_device_file *df)
 {
 	struct vfio_device *device = df->device;
+	u32 ioas_id;
 	int ret;
 
 	mutex_lock(&device->group->group_lock);
@@ -177,6 +178,13 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 		goto out_unlock;
 	}
 
+	if (device->group->iommufd) {
+		ret = iommufd_vfio_compat_ioas_id(device->group->iommufd,
+						  &ioas_id);
+		if (ret)
+			goto out_unlock;
+	}
+
 	mutex_lock(&device->dev_set->lock);
 
 	/*
@@ -188,9 +196,12 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 	if (device->open_count == 0)
 		vfio_device_group_get_kvm_safe(device);
 
-	df->iommufd = device->group->iommufd;
-
-	ret = vfio_device_open(df);
+	if (device->group->iommufd) {
+		df->iommufd = device->group->iommufd;
+		ret = vfio_device_open(df, NULL, &ioas_id);
+	} else {
+		ret = vfio_device_open(df, NULL, NULL);
+	}
 	if (ret)
 		df->iommufd = NULL;
 
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 4f82a6fa7c6c..beef6ca21107 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -10,9 +10,9 @@
 MODULE_IMPORT_NS(IOMMUFD);
 MODULE_IMPORT_NS(IOMMUFD_VFIO);
 
-int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
+int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx,
+		      u32 *dev_id, u32 *pt_id)
 {
-	u32 ioas_id;
 	u32 device_id;
 	int ret;
 
@@ -29,17 +29,14 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 	if (ret)
 		return ret;
 
-	ret = iommufd_vfio_compat_ioas_id(ictx, &ioas_id);
-	if (ret)
-		goto err_unbind;
-	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
-	if (ret)
-		goto err_unbind;
+	if (pt_id) {
+		ret = vdev->ops->attach_ioas(vdev, pt_id);
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
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 64e862a02dad..04d2bd2e314d 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -26,7 +26,8 @@ struct vfio_device_file {
 
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
-int vfio_device_open(struct vfio_device_file *df);
+int vfio_device_open(struct vfio_device_file *df,
+		     u32 *dev_id, u32 *pt_id);
 void vfio_device_close(struct vfio_device_file *df);
 struct vfio_device_file *
 vfio_allocate_device_file(struct vfio_device *device);
@@ -223,7 +224,8 @@ static inline void vfio_container_cleanup(void)
 #endif
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
-int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
+int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx,
+		      u32 *dev_id, u32 *pt_id);
 void vfio_iommufd_unbind(struct vfio_device *device);
 static inline struct iommufd_ctx *
 vfio_device_iommufd(struct vfio_device *device)
@@ -232,7 +234,8 @@ vfio_device_iommufd(struct vfio_device *device)
 }
 #else
 static inline int vfio_iommufd_bind(struct vfio_device *device,
-				    struct iommufd_ctx *ictx)
+				    struct iommufd_ctx *ictx,
+				    u32 *dev_id, u32 *pt_id)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index d16ac573e290..19ea65a87072 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -411,7 +411,8 @@ vfio_allocate_device_file(struct vfio_device *device)
 	return df;
 }
 
-static int vfio_device_first_open(struct vfio_device_file *df)
+static int vfio_device_first_open(struct vfio_device_file *df,
+				  u32 *dev_id, u32 *pt_id)
 {
 	struct vfio_device *device = df->device;
 	struct iommufd_ctx *iommufd = df->iommufd;
@@ -423,7 +424,7 @@ static int vfio_device_first_open(struct vfio_device_file *df)
 		return -ENODEV;
 
 	if (iommufd)
-		ret = vfio_iommufd_bind(device, iommufd);
+		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
 	else
 		ret = vfio_device_group_use_iommu(device);
 	if (ret)
@@ -462,7 +463,8 @@ static void vfio_device_last_close(struct vfio_device_file *df)
 	module_put(device->dev->driver->owner);
 }
 
-int vfio_device_open(struct vfio_device_file *df)
+int vfio_device_open(struct vfio_device_file *df,
+		     u32 *dev_id, u32 *pt_id)
 {
 	struct vfio_device *device = df->device;
 	int ret = 0;
@@ -471,7 +473,7 @@ int vfio_device_open(struct vfio_device_file *df)
 
 	device->open_count++;
 	if (device->open_count == 1) {
-		ret = vfio_device_first_open(df);
+		ret = vfio_device_first_open(df, dev_id, pt_id);
 		if (ret)
 			device->open_count--;
 	}
-- 
2.34.1

