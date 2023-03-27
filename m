Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C336CA043
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjC0JlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbjC0JlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:41:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A832B5262;
        Mon, 27 Mar 2023 02:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679910062; x=1711446062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dxSvK97s0fUoDU1pNT+PUZzXHqIewU0G4N/1Zs9nnUk=;
  b=lTQRRZ4QPCKR68BTjXg/TJ2tiXTyNECScQEPZHoSaHdRZhu8OIl40H7X
   SN1KgLN+RKmwGZT1Mgl+zD1uYho2C0PPLfEFfHPMCG3IFe+RRNgkCjmHs
   4ftRbTQA9O0nIOxVLW5rFtUjvENwy7NHMtG2yjFGfnMFRIQlh/pMIPCQn
   Q4ZBBcVUiGJuRvY8Nr/NLQlHVNHQ2FAsbXoRz8sACph6AzvKx/YzIO0ts
   uaaxxP5xFGQeSZ+ikgRFSmR7u3iL1AhkGry7tMyDyomUAx+b7AaYYKcCp
   Ua8bwANW9wAErkgu/GUHmbc4Q8qU0dodDj8FKlFN1LqRcg+Biksr4HzB9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="426485388"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="426485388"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:41:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="660775804"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="660775804"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 27 Mar 2023 02:41:01 -0700
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
Subject: [PATCH v8 14/24] vfio: Record devid in vfio_device_file
Date:   Mon, 27 Mar 2023 02:40:37 -0700
Message-Id: <20230327094047.47215-15-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327094047.47215-1-yi.l.liu@intel.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
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

.bind_iommufd() will generate an ID to represent this bond, which is
needed by userspace for further usage. Store devid in vfio_device_file
to avoid passing the pointer in multiple places.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c   | 12 +++++++-----
 drivers/vfio/vfio.h      | 10 +++++-----
 drivers/vfio/vfio_main.c |  6 +++---
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index b32e757bdac5..cd3cc56f6c08 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -28,14 +28,14 @@ int vfio_iommufd_enable_noiommu_compat(struct vfio_device *device,
 	return 0;
 }
 
-int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
+int vfio_iommufd_bind(struct vfio_device_file *df)
 {
-	u32 device_id;
+	struct vfio_device *vdev = df->device;
+	struct iommufd_ctx *ictx = df->iommufd;
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	/* The legacy path has no way to return the device id */
-	return vdev->ops->bind_iommufd(vdev, ictx, &device_id);
+	return vdev->ops->bind_iommufd(vdev, ictx, &df->devid);
 }
 
 int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
@@ -54,8 +54,10 @@ int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
 	return vdev->ops->attach_ioas(vdev, &ioas_id);
 }
 
-void vfio_iommufd_unbind(struct vfio_device *vdev)
+void vfio_iommufd_unbind(struct vfio_device_file *df)
 {
+	struct vfio_device *vdev = df->device;
+
 	lockdep_assert_held(&vdev->dev_set->lock);
 
 	if (vdev->ops->unbind_iommufd)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index abfaf85cc266..b47b186573ac 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -24,6 +24,7 @@ struct vfio_device_file {
 	spinlock_t kvm_ref_lock; /* protect kvm field */
 	struct kvm *kvm;
 	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
+	u32 devid; /* only valid when iommufd is valid */
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
@@ -240,8 +241,8 @@ int vfio_iommufd_enable_noiommu_compat(struct vfio_device *device,
 				       struct iommufd_ctx *ictx);
 int vfio_iommufd_attach_compat_ioas(struct vfio_device *device,
 				    struct iommufd_ctx *ictx);
-int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
-void vfio_iommufd_unbind(struct vfio_device *device);
+int vfio_iommufd_bind(struct vfio_device_file *df);
+void vfio_iommufd_unbind(struct vfio_device_file *df);
 #else
 static inline int
 vfio_iommufd_enable_noiommu_compat(struct vfio_device *device,
@@ -257,13 +258,12 @@ vfio_iommufd_attach_compat_ioas(struct vfio_device *device,
 	return -EOPNOTSUPP;
 }
 
-static inline int vfio_iommufd_bind(struct vfio_device *device,
-				    struct iommufd_ctx *ictx)
+static inline int vfio_iommufd_bind(struct vfio_device_file *df)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void vfio_iommufd_unbind(struct vfio_device *device)
+static inline void vfio_iommufd_unbind(struct vfio_device_file *df)
 {
 }
 #endif
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6739203873a6..d54c03248794 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -435,7 +435,7 @@ static int vfio_device_first_open(struct vfio_device_file *df)
 	 * noiommu mode then just go ahead to open it.
 	 */
 	if (iommufd)
-		ret = vfio_iommufd_bind(device, iommufd);
+		ret = vfio_iommufd_bind(df);
 	else if (vfio_device_group_uses_container(df))
 		ret = vfio_device_group_use_iommu(device);
 	if (ret)
@@ -450,7 +450,7 @@ static int vfio_device_first_open(struct vfio_device_file *df)
 
 err_unuse_iommu:
 	if (iommufd)
-		vfio_iommufd_unbind(device);
+		vfio_iommufd_unbind(df);
 	else if (vfio_device_group_uses_container(df))
 		vfio_device_group_unuse_iommu(device);
 err_module_put:
@@ -468,7 +468,7 @@ static void vfio_device_last_close(struct vfio_device_file *df)
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	if (iommufd)
-		vfio_iommufd_unbind(device);
+		vfio_iommufd_unbind(df);
 	else if (vfio_device_group_uses_container(df))
 		vfio_device_group_unuse_iommu(device);
 	module_put(device->dev->driver->owner);
-- 
2.34.1

