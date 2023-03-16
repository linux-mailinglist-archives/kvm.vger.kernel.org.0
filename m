Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B2F6BD03E
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjCPM4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCPMz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:55:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C69D234D7;
        Thu, 16 Mar 2023 05:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678971357; x=1710507357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oDDHD3Ae7NG5GC4LKURBgpBaOzuTUSDgeTMIrOuq0hA=;
  b=BOOxgzGo8fZ3p9r2f+TdXGAmHyOaB8Lr6SXi5Qsecg+Uge+3oiqXqgXb
   qekXofsKgIugVz7jRRJK97wi17/B5P9/GnP/19nERprv5BEAK8MZgQav+
   tdArTjsa+l5cwxkRFdaeEbcNbKnqrUYQvKcPPmtMo52WzsA4zAPqX0pJ0
   uNJJH480rnkdNmZXkOAs9XTHIoJbPI9pmwdXUkEj+acSVEEfxQwAqeO4B
   liM0KXsYL2UkaVTGoFXaWhpDrzy1bJ5kKYWEwyOFXp/o3gTuv/lMW1UGy
   MlIQVFiJVIbUHRu/ANAVqmeByEvxsUiAABokEOYOKrp8kbFBBqKcrQwLs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336668140"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336668140"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:55:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="790277845"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="790277845"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 05:55:56 -0700
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
Subject: [PATCH v7 13/22] vfio-iommufd: Split bind/attach into two steps
Date:   Thu, 16 Mar 2023 05:55:25 -0700
Message-Id: <20230316125534.17216-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316125534.17216-1-yi.l.liu@intel.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
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

to align with the coming vfio device cdev support.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c   | 18 ++++++++++++++----
 drivers/vfio/iommufd.c | 33 ++++++++++++++-------------------
 drivers/vfio/vfio.h    |  9 +++++++++
 3 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 1ad8df9b295f..70bdecff4785 100644
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
index 7334b67dbb8a..2daef60fe439 100644
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

