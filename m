Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE66C6B092E
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjCHNdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjCHNce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:32:34 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30A8B5A99;
        Wed,  8 Mar 2023 05:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282264; x=1709818264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VuqafYByKK/jWkKRq463YXQFQwOvpfEb1z0GI9PVpxY=;
  b=ZZxxi2Rv4kkOQO4IXMvf6oDdq96KXwz3FLtl/Vz+7c8EhR51F2lh6Ylf
   PN9I9tqbglcjm6KCNB8OItFl8cGXJKoW8cnQTlWvYSWaiFlNYsRi7jQUk
   xvXC0BAFl+zl3ssSPePg8GbKEqIoUSnvspOhuk6Ie64l4Hc1xlsuIrppy
   fqwfpRV/bJ4FdgrBc1irzqlwptPmkwDIoq0+X8k2hEmR/jWpNa8BBx6i8
   pvSrTaez8/mgqoKGLcQqHY9dt709GuTc3w2dIj6C8RTR2A14f376RnBUS
   4OYBACVvzLxRnOBMEKIHjJb/Tm7OppWqK+Zr+dkamp2WH9s+t6/2D6UcM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165287"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165287"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789423"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789423"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:35 -0800
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
Subject: [PATCH v6 17/24] vfio-iommufd: Make vfio_iommufd_bind() selectively return devid
Date:   Wed,  8 Mar 2023 05:28:56 -0800
Message-Id: <20230308132903.465159-18-yi.l.liu@intel.com>
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

bind_iommufd() will generate an ID to represent this bond, it is needed
by userspace for further usage. devid is stored in vfio_device_file to
avoid passing devid pointer in multiple places.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c   | 13 ++++++++++---
 drivers/vfio/vfio.h      |  6 ++++--
 drivers/vfio/vfio_main.c |  8 +++++---
 include/linux/iommufd.h  |  2 ++
 4 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 8c518f8bd39a..b2cdb6b2b37f 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -28,7 +28,8 @@ static int vfio_iommufd_device_probe_comapt_noiommu(struct vfio_device *vdev,
 	return 0;
 }
 
-int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
+int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx,
+		      u32 *devid)
 {
 	u32 device_id;
 	int ret;
@@ -44,8 +45,14 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 	if (WARN_ON(!vdev->ops->bind_iommufd))
 		return -ENODEV;
 
-	/* The legacy path has no way to return the device id */
-	return vdev->ops->bind_iommufd(vdev, ictx, &device_id);
+	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
+	if (ret)
+		return ret;
+
+	if (devid)
+		*devid = device_id;
+
+	return 0;
 }
 
 int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 615ffd58562b..98cee2f765e9 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -24,6 +24,7 @@ struct vfio_device_file {
 	spinlock_t kvm_ref_lock; /* protect kvm field */
 	struct kvm *kvm;
 	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
+	u32 devid; /* only valid when iommufd is valid */
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
@@ -236,13 +237,14 @@ static inline void vfio_container_cleanup(void)
 #endif
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
-int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
+int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx,
+		      u32 *devid);
 void vfio_iommufd_unbind(struct vfio_device *device);
 int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
 				    struct iommufd_ctx *ictx);
 #else
 static inline int vfio_iommufd_bind(struct vfio_device *device,
-				    struct iommufd_ctx *ictx)
+				    struct iommufd_ctx *ictx, u32 *devid)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 8c73df1a400e..a66ca138059b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -444,7 +444,7 @@ static int vfio_device_first_open(struct vfio_device_file *df)
 	 * to be done here just go ahead to open device.
 	 */
 	if (iommufd)
-		ret = vfio_iommufd_bind(device, iommufd);
+		ret = vfio_iommufd_bind(device, iommufd, &df->devid);
 	else if (vfio_device_group_uses_container(df))
 		ret = vfio_device_group_use_iommu(device);
 	if (ret)
@@ -476,10 +476,12 @@ static void vfio_device_last_close(struct vfio_device_file *df)
 
 	if (device->ops->close_device)
 		device->ops->close_device(device);
-	if (iommufd)
+	if (iommufd) {
 		vfio_iommufd_unbind(device);
-	else if (vfio_device_group_uses_container(df))
+		df->devid = IOMMUFD_INVALID_ID;
+	} else if (vfio_device_group_uses_container(df)) {
 		vfio_device_group_unuse_iommu(device);
+	}
 	module_put(device->dev->driver->owner);
 }
 
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 7a0d7f2c4237..48b9bfab9891 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -10,6 +10,8 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 
+#define IOMMUFD_INVALID_ID 0
+
 struct device;
 struct iommufd_device;
 struct page;
-- 
2.34.1

