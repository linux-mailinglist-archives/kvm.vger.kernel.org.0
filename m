Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372C0701768
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbjEMNaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238989AbjEMNaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:30:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536EF49E2;
        Sat, 13 May 2023 06:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984583; x=1715520583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8b+sMJ9CtsqavfRZw2uc4X1L8VxMQmoBLRSiSkpXBgo=;
  b=TWo3+Yp8LKlW9q/pGqWXZDk5xTotTHeLzkFQjHs3yziJ5ByaV/C3RP/f
   0f84Lwwezf+UuNOgE8u5QnoVO0ZUWsBwWZfRXw0JrSm9PZLAspLnwYwpP
   vQp5EKZuEDjXWUEhf8bJvbHChQqpkYASnSHTI9M5iqo712y2fAee8gb7H
   avjmiJ9cdP0Kkb4yrYJG0cnl3qnb2cD+ZeA9Wv40LdYiLE8H0+dTCdshC
   eTFoOQBfy/qJOafC3Bv31FHdbH9U9UjTaPyrMQEzPU62Y/PesNs0U1Xv9
   F6io3K556lzRmsU1UcoNkG0tTJOpthU1kljbpLyCvttNVQ6PBghi4200F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="354100847"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="354100847"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:28:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="703459532"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="703459532"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 13 May 2023 06:28:58 -0700
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
Subject: [PATCH v11 21/23] vfio: Determine noiommu device in __vfio_register_dev()
Date:   Sat, 13 May 2023 06:28:25 -0700
Message-Id: <20230513132827.39066-22-yi.l.liu@intel.com>
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

This is to make the cdev path and group path consistent for the noiommu
devices registration. If vfio_noiommu is disabled, such registration
should fail. However, this check is vfio_device_set_group() which is part
of the vfio_group code. If the vfio_group code is compiled out, noiommu
devices would be registered even vfio_noiommu is disabled.

This adds vfio_device_set_noiommu() which can fail and calls it in the
device registration. For now, it never fails as long as
vfio_device_set_group() is successful. But when the vfio_group code is
compiled out, vfio_device_set_noiommu() would fail the noiommu devices
when vfio_noiommu is disabled.

As noiommu devices is checked and there are multiple places which needs
to test noiommu devices, this also adds a flag to mark noiommu devices.
Hence the callers of vfio_device_is_noiommu() can be converted to test
vfio_device->noiommu.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c |  4 ++--
 drivers/vfio/group.c       |  2 +-
 drivers/vfio/iommufd.c     | 10 +++++-----
 drivers/vfio/vfio.h        |  7 ++++---
 drivers/vfio/vfio_main.c   |  6 +++++-
 include/linux/vfio.h       |  1 +
 6 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 3f14edb80a93..6d7f50ee535d 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -111,7 +111,7 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 	if (df->group)
 		return -EINVAL;
 
-	if (vfio_device_is_noiommu(device) && !capable(CAP_SYS_RAWIO))
+	if (device->noiommu && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	ret = vfio_device_block_group(device);
@@ -157,7 +157,7 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 	device->cdev_opened = true;
 	mutex_unlock(&device->dev_set->lock);
 
-	if (vfio_device_is_noiommu(device))
+	if (device->noiommu)
 		dev_warn(device->dev, "noiommu device is bound to iommufd by user "
 			 "(%s:%d)\n", current->comm, task_pid_nr(current));
 	return 0;
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 7aacbd9d08c9..bf4335bce892 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -192,7 +192,7 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 		vfio_device_group_get_kvm_safe(device);
 
 	df->iommufd = device->group->iommufd;
-	if (df->iommufd && vfio_device_is_noiommu(device) && device->open_count == 0) {
+	if (df->iommufd && device->noiommu && device->open_count == 0) {
 		ret = vfio_iommufd_compat_probe_noiommu(device,
 							df->iommufd);
 		if (ret)
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 799ea322a7d4..dfe706f1e952 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -71,7 +71,7 @@ int vfio_iommufd_bind(struct vfio_device_file *df)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev))
+	if (vdev->noiommu)
 		return vfio_iommufd_noiommu_bind(vdev, ictx, &df->devid);
 
 	return vdev->ops->bind_iommufd(vdev, ictx, &df->devid);
@@ -86,7 +86,7 @@ int vfio_iommufd_compat_attach_ioas(struct vfio_device *vdev,
 	lockdep_assert_held(&vdev->dev_set->lock);
 
 	/* compat noiommu does not need to do ioas attach */
-	if (vfio_device_is_noiommu(vdev))
+	if (vdev->noiommu)
 		return 0;
 
 	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
@@ -103,7 +103,7 @@ void vfio_iommufd_unbind(struct vfio_device_file *df)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev)) {
+	if (vdev->noiommu) {
 		vfio_iommufd_noiommu_unbind(vdev);
 		return;
 	}
@@ -116,7 +116,7 @@ int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev))
+	if (vdev->noiommu)
 		return 0;
 
 	return vdev->ops->attach_ioas(vdev, pt_id);
@@ -126,7 +126,7 @@ void vfio_iommufd_detach(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (!vfio_device_is_noiommu(vdev))
+	if (!vdev->noiommu)
 		vdev->ops->detach_ioas(vdev);
 }
 
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50553f67600f..c8579d63b2b9 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -106,10 +106,11 @@ bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
 
-static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
+static inline int vfio_device_set_noiommu(struct vfio_device *device)
 {
-	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
-	       vdev->group->type == VFIO_NO_IOMMU;
+	device->noiommu = IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
+			  device->group->type == VFIO_NO_IOMMU;
+	return 0;
 }
 
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 8c3f26b4929b..8979f320d620 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -289,8 +289,12 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (ret)
 		return ret;
 
+	ret = vfio_device_set_noiommu(device);
+	if (ret)
+		goto err_out;
+
 	ret = dev_set_name(&device->device, "%svfio%d",
-			   vfio_device_is_noiommu(device) ? "noiommu-" : "", device->index);
+			   device->noiommu ? "noiommu-" : "", device->index);
 	if (ret)
 		goto err_out;
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index cf9d082a623c..fa13889e763f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -68,6 +68,7 @@ struct vfio_device {
 	bool iommufd_attached;
 #endif
 	bool cdev_opened:1;
+	bool noiommu:1;
 };
 
 /**
-- 
2.34.1

