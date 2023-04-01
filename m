Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51796D323B
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 17:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjDAPTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 11:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjDAPSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 11:18:46 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBF421A95;
        Sat,  1 Apr 2023 08:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680362324; x=1711898324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l6GAZxH9ilEoIOsYSsTBZ0K+NVpQqN2Ka1sb2xlz99E=;
  b=cwCWuOYA2t8kP1Kj5ldYOVKqnaGEw0iFrrG0w3RG5c/CukzlkjI6efLd
   VpujGlA0SOYmB4USh4AUS2YeOMmPAnCs+LOPM9W7r2fObWmy1VaRj3kUT
   5VjamnMnR5s900IIP5xYGpBWtYk4KtgNizzxZ/pz5W+5M9Ku4F160EZdz
   S39O+tLrBCd9/zJjtkJAxE5MohH3O+UMqMy+uctB3W1skI0iGTCKxzLRx
   /VUo16RScfFI9BvokWn9glqi3LdAkOtQWRrR61MaN5okdSwYTigEb7xew
   V909bgjrzwIKQFxWmtcRYh1KpaLjBOtd+4AicdfN+VTsLhcG/Hy+nwyW4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="404411297"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404411297"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 08:18:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="678937202"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="678937202"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2023 08:18:42 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: [PATCH v9 13/25] vfio-iommufd: Split bind/attach into two steps
Date:   Sat,  1 Apr 2023 08:18:21 -0700
Message-Id: <20230401151833.124749-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401151833.124749-1-yi.l.liu@intel.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

to align with the coming vfio device cdev support.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c   | 18 ++++++++++++++----
 drivers/vfio/iommufd.c | 33 ++++++++++++++-------------------
 drivers/vfio/vfio.h    |  9 +++++++++
 3 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 6178ac5d0b10..de9f09c7cf00 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -203,9 +203,14 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 	}
 
 	ret = vfio_device_open(df);
-	if (ret) {
-		df->iommufd = NULL;
+	if (ret)
 		goto out_put_kvm;
+
+	if (df->iommufd) {
+		ret = vfio_iommufd_attach_compat_ioas(device,
+						      df->iommufd);
+		if (ret)
+			goto out_close_device;
 	}
 
 	/*
@@ -214,12 +219,17 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 	 */
 	smp_store_release(&df->access_granted, true);
 
+	mutex_unlock(&device->dev_set->lock);
+	mutex_unlock(&device->group->group_lock);
+	return 0;
+
+out_close_device:
+	vfio_device_close(df);
 out_put_kvm:
+	df->iommufd = NULL;
 	if (device->open_count == 0)
 		vfio_device_put_kvm(device);
-
 	mutex_unlock(&device->dev_set->lock);
-
 out_unlock:
 	mutex_unlock(&device->group->group_lock);
 	return ret;
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 11f5148b446e..20fd250c247c 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -30,33 +30,28 @@ int vfio_iommufd_enable_noiommu_compat(struct vfio_device *device,
 
 int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 {
-	u32 ioas_id;
 	u32 device_id;
-	int ret;
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
-	if (ret)
-		return ret;
+	/* The legacy path has no way to return the device id */
+	return vdev->ops->bind_iommufd(vdev, ictx, &device_id);
+}
+
+int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
+				    struct iommufd_ctx *ictx)
+{
+	u32 ioas_id;
+	int ret;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
 
 	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
 	if (ret)
-		goto err_unbind;
-	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
-	if (ret)
-		goto err_unbind;
-
-	/*
-	 * The legacy path has no way to return the device id or the selected
-	 * pt_id
-	 */
-	return 0;
+		return ret;
 
-err_unbind:
-	if (vdev->ops->unbind_iommufd)
-		vdev->ops->unbind_iommufd(vdev);
-	return ret;
+	/* The legacy path has no way to return the selected pt_id */
+	return vdev->ops->attach_ioas(vdev, &ioas_id);
 }
 
 void vfio_iommufd_unbind(struct vfio_device *vdev)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 136137b8618d..abfaf85cc266 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -238,6 +238,8 @@ static inline void vfio_container_cleanup(void)
 #if IS_ENABLED(CONFIG_IOMMUFD)
 int vfio_iommufd_enable_noiommu_compat(struct vfio_device *device,
 				       struct iommufd_ctx *ictx);
+int vfio_iommufd_attach_compat_ioas(struct vfio_device *device,
+				    struct iommufd_ctx *ictx);
 int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
 void vfio_iommufd_unbind(struct vfio_device *device);
 #else
@@ -248,6 +250,13 @@ vfio_iommufd_enable_noiommu_compat(struct vfio_device *device,
 	return -EOPNOTSUPP;
 }
 
+static inline int
+vfio_iommufd_attach_compat_ioas(struct vfio_device *device,
+				struct iommufd_ctx *ictx)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int vfio_iommufd_bind(struct vfio_device *device,
 				    struct iommufd_ctx *ictx)
 {
-- 
2.34.1

