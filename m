Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A343F70173D
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbjEMN25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238623AbjEMN2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:28:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED9F40E4;
        Sat, 13 May 2023 06:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984527; x=1715520527;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oWnT+R1cNducLwmKzcoUWpMl2wmEOoG1Sy6rksWaxhY=;
  b=PRIyIy41S5xAO+zMJu0pHZUBcQgbe9jglCb9tLIFMtk0wwRLU/98Kd75
   8PJBj/obmUTj+Bu1IgQz0rfYEaeeL6mbxRt8KA0DL01KFtzmBvLbZ1NUM
   KWO3tj5alo6QhE+C7JDwdSbjitJ+VpuV+rOTJH9Gtg5z7N0INDQQwqT3R
   70J8tPLb17cE1jIwS81pL68B6iiJO0cGppPecop2VCgPe3laJ0DFTvEsk
   zm++jz+/Y76slipEbGspFNfq7qZgmYA+hGvTixi30ZwkeC08uvoZmywdN
   zQpilwNNuFB90zoCNwzw+2ix4l+J8WJrAw1KM9U0P9NBauinl4vLVrjYG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="354100735"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="354100735"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:28:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="703459492"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="703459492"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 13 May 2023 06:28:45 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v11 11/23] vfio-iommufd: Split bind/attach into two steps
Date:   Sat, 13 May 2023 06:28:15 -0700
Message-Id: <20230513132827.39066-12-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230513132827.39066-1-yi.l.liu@intel.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c   | 18 ++++++++++++++----
 drivers/vfio/iommufd.c | 37 ++++++++++++++++++-------------------
 drivers/vfio/vfio.h    |  9 +++++++++
 3 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index cfd0b9254bbc..7aacbd9d08c9 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -200,9 +200,14 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 	}
 
 	ret = vfio_device_open(df);
-	if (ret) {
-		df->iommufd = NULL;
+	if (ret)
 		goto out_put_kvm;
+
+	if (df->iommufd && device->open_count == 1) {
+		ret = vfio_iommufd_compat_attach_ioas(device,
+						      df->iommufd);
+		if (ret)
+			goto out_close_device;
 	}
 
 	/*
@@ -211,12 +216,17 @@ static int vfio_device_group_open(struct vfio_device_file *df)
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
index 7a654a1437f0..acc683a3620b 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -66,36 +66,35 @@ int vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
 
 int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 {
-	u32 ioas_id;
 	u32 device_id;
-	int ret;
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
 	if (vfio_device_is_noiommu(vdev))
 		return vfio_iommufd_noiommu_bind(vdev, ictx, &device_id);
 
-	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
-	if (ret)
-		return ret;
+	/* The legacy path has no way to return the device id */
+	return vdev->ops->bind_iommufd(vdev, ictx, &device_id);
+}
+
+int vfio_iommufd_compat_attach_ioas(struct vfio_device *vdev,
+				    struct iommufd_ctx *ictx)
+{
+	u32 ioas_id;
+	int ret;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	/* compat noiommu does not need to do ioas attach */
+	if (vfio_device_is_noiommu(vdev))
+		return 0;
 
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
index 8884b557fb26..c7431ca19d9e 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -238,6 +238,8 @@ int vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
 				      struct iommufd_ctx *ictx);
 int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
 void vfio_iommufd_unbind(struct vfio_device *device);
+int vfio_iommufd_compat_attach_ioas(struct vfio_device *device,
+				    struct iommufd_ctx *ictx);
 #else
 static inline int
 vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
@@ -255,6 +257,13 @@ static inline int vfio_iommufd_bind(struct vfio_device *device,
 static inline void vfio_iommufd_unbind(struct vfio_device *device)
 {
 }
+
+static inline int
+vfio_iommufd_compat_attach_ioas(struct vfio_device *device,
+				struct iommufd_ctx *ictx)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
-- 
2.34.1

