Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B2B6B0925
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjCHNca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjCHNcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:32:09 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795213B875;
        Wed,  8 Mar 2023 05:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282219; x=1709818219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2NxJ2YuHrmW/4nZRdgi+pj1OdZn9UVNaWl2X9mKXSHs=;
  b=BiKdnTeZcKKq3WY3neLy3U4bRCvcHGGpBlrXnn1XaY85/5eW2iComGSX
   1CqcGGklaZFpwIADTa1hjwOlDCE4Qf3S4RzUErb5lWx/BAZiPNl9ndIGr
   WzzDQMfE+VopfwJWqae3pbCzqOSIg4kofbl036s36IdBERXjhoAqCrFM4
   BtiKVKGSsTTaaVglHmnnOgp4JZ2uE4yJ8rIc19lylIBdexBRkkMeJSj3K
   J1OwzL1w0QO4arFV0GS/lGaBzd43V+tSfoe1FtDBe61s1jPweUwZrSVGC
   8/biNq11qd4KK1oc2/fF/lpFcyo0In/WbZAI89LuNa+/dDGoB/bO6W0Pq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165233"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165233"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789391"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789391"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:28 -0800
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
Subject: [PATCH v6 13/24] vfio/iommufd: Split the compat_ioas attach out from vfio_iommufd_bind()
Date:   Wed,  8 Mar 2023 05:28:52 -0800
Message-Id: <20230308132903.465159-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308132903.465159-1-yi.l.liu@intel.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the group code call .bind_iommufd and .attach_ioas in two steps
instead of in a single step. This prepares the bind_iommufd and attach_ioas
support in the coming cdev path.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c   | 26 ++++++++++-----
 drivers/vfio/iommufd.c | 75 ++++++++++++++++++++++++++----------------
 drivers/vfio/vfio.h    |  8 +++++
 3 files changed, 73 insertions(+), 36 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 6280368eb0bd..555d68aefa71 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -177,7 +177,7 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 	mutex_lock(&device->group->group_lock);
 	if (!vfio_group_has_iommu(device->group)) {
 		ret = -EINVAL;
-		goto out_unlock;
+		goto err_unlock;
 	}
 
 	mutex_lock(&device->dev_set->lock);
@@ -194,9 +194,14 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 	df->iommufd = device->group->iommufd;
 
 	ret = vfio_device_open(df);
-	if (ret) {
-		df->iommufd = NULL;
-		goto out_put_kvm;
+	if (ret)
+		goto err_put_kvm;
+
+	if (device->group->iommufd) {
+		ret = vfio_iommufd_attach_compat_ioas(device,
+						      device->group->iommufd);
+		if (ret)
+			goto err_close_device;
 	}
 
 	/*
@@ -205,13 +210,18 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 	 */
 	smp_store_release(&df->access_granted, true);
 
-out_put_kvm:
+	mutex_unlock(&device->dev_set->lock);
+	mutex_unlock(&device->group->group_lock);
+	return 0;
+
+err_close_device:
+	vfio_device_close(df);
+err_put_kvm:
+	df->iommufd = NULL;
 	if (device->open_count == 0)
 		vfio_device_put_kvm(device);
-
 	mutex_unlock(&device->dev_set->lock);
-
-out_unlock:
+err_unlock:
 	mutex_unlock(&device->group->group_lock);
 	return ret;
 }
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 30c0da2e11f9..8c518f8bd39a 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -10,52 +10,71 @@
 MODULE_IMPORT_NS(IOMMUFD);
 MODULE_IMPORT_NS(IOMMUFD_VFIO);
 
-int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
+static int vfio_iommufd_device_probe_comapt_noiommu(struct vfio_device *vdev,
+						    struct iommufd_ctx *ictx)
 {
 	u32 ioas_id;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	/*
+	 * Require no compat ioas to be assigned to proceed.  The basic
+	 * statement is that the user cannot have done something that
+	 * implies they expected translation to exist
+	 */
+	if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
+		return -EPERM;
+	return 0;
+}
+
+int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
+{
 	u32 device_id;
 	int ret;
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
 	if (vfio_device_is_noiommu(vdev)) {
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-
-		/*
-		 * Require no compat ioas to be assigned to proceed. The basic
-		 * statement is that the user cannot have done something that
-		 * implies they expected translation to exist
-		 */
-		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
-			return -EPERM;
-		return 0;
+		ret = vfio_iommufd_device_probe_comapt_noiommu(vdev, ictx);
+		if (ret)
+			return ret;
 	}
 
 	if (WARN_ON(!vdev->ops->bind_iommufd))
 		return -ENODEV;
 
-	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
-	if (ret)
-		return ret;
+	/* The legacy path has no way to return the device id */
+	return vdev->ops->bind_iommufd(vdev, ictx, &device_id);
+}
 
-	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
-	if (ret)
-		goto err_unbind;
-	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
-	if (ret)
-		goto err_unbind;
+int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
+				    struct iommufd_ctx *ictx)
+{
+	u32 ioas_id;
+	int ret;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
 
 	/*
-	 * The legacy path has no way to return the device id or the selected
-	 * pt_id
+	 * If the driver doesn't provide this op then it means the device does
+	 * not do DMA at all. So nothing to do.
 	 */
-	return 0;
+	if (WARN_ON(!vdev->ops->bind_iommufd))
+		return -ENODEV;
 
-err_unbind:
-	if (vdev->ops->unbind_iommufd)
-		vdev->ops->unbind_iommufd(vdev);
-	return ret;
+	if (vfio_device_is_noiommu(vdev)) {
+		if (WARN_ON(vfio_iommufd_device_probe_comapt_noiommu(vdev, ictx)))
+			return -EINVAL;
+		return 0;
+	}
+
+	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
+	if (ret)
+		return ret;
+
+	/* The legacy path has no way to return the selected pt_id */
+	return vdev->ops->attach_ioas(vdev, &ioas_id);
 }
 
 void vfio_iommufd_unbind(struct vfio_device *vdev)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 464263288d16..3356321805e9 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -232,6 +232,8 @@ static inline void vfio_container_cleanup(void)
 #if IS_ENABLED(CONFIG_IOMMUFD)
 int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
 void vfio_iommufd_unbind(struct vfio_device *device);
+int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
+				    struct iommufd_ctx *ictx);
 #else
 static inline int vfio_iommufd_bind(struct vfio_device *device,
 				    struct iommufd_ctx *ictx)
@@ -242,6 +244,12 @@ static inline int vfio_iommufd_bind(struct vfio_device *device,
 static inline void vfio_iommufd_unbind(struct vfio_device *device)
 {
 }
+
+static inline int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
+						  struct iommufd_ctx *ictx)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
-- 
2.34.1

