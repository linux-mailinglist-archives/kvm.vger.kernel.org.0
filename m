Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBE3732C4F
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344709AbjFPJlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344622AbjFPJkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:40:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8FC2117;
        Fri, 16 Jun 2023 02:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686908422; x=1718444422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HoW5JuakFU3XlbgLXcZ+0bXHVg/gHrEE3rw+6XuzoYI=;
  b=AOFt7jV4EB1dc5KT4/giXxFiGuePyp3QfAjPQsJmslzQv3eS+YZPMFLy
   Jedl/I5DJgxaJPYYO2tDfNIxAI8vPyJ5N2eN8OrKbBXdL+/AYorlI/mcl
   qGpg/egwuGPVKbqFogErj85dsHTeBkoQ9N3atIrGA9qpwfcwfIoBedzxF
   BWBJ0LajHaynE9O08rgNRjim8KoEJPKCwyAJYGWFFvpb9rKgb2Xbt2CWJ
   P1b/IGJUPbgVyw1Pib3qA+51P3beIudSl2Lyxg54osswZR62xPPJfFiTP
   lvJx3gb5gpWmPIzWAUta6xIjifIQKV3RCSIDZROtWykkvfxsTLm+T/vBz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="361700383"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="361700383"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 02:40:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715951208"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="715951208"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2023 02:40:20 -0700
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
Subject: [PATCH v13 15/22] vfio-iommufd: Add detach_ioas support for emulated VFIO devices
Date:   Fri, 16 Jun 2023 02:39:39 -0700
Message-Id: <20230616093946.68711-16-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616093946.68711-1-yi.l.liu@intel.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This prepares for adding DETACH ioctl for emulated VFIO devices.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c  |  1 +
 drivers/s390/cio/vfio_ccw_ops.c   |  1 +
 drivers/s390/crypto/vfio_ap_ops.c |  1 +
 drivers/vfio/iommufd.c            | 13 +++++++++++++
 include/linux/vfio.h              |  3 +++
 samples/vfio-mdev/mbochs.c        |  1 +
 samples/vfio-mdev/mdpy.c          |  1 +
 samples/vfio-mdev/mtty.c          |  1 +
 8 files changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index de675d799c7d..9cd9e9da60dd 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1474,6 +1474,7 @@ static const struct vfio_device_ops intel_vgpu_dev_ops = {
 	.bind_iommufd	= vfio_iommufd_emulated_bind,
 	.unbind_iommufd = vfio_iommufd_emulated_unbind,
 	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
+	.detach_ioas	= vfio_iommufd_emulated_detach_ioas,
 };
 
 static int intel_vgpu_probe(struct mdev_device *mdev)
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 5b53b94f13c7..cba4971618ff 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -632,6 +632,7 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
 	.bind_iommufd = vfio_iommufd_emulated_bind,
 	.unbind_iommufd = vfio_iommufd_emulated_unbind,
 	.attach_ioas = vfio_iommufd_emulated_attach_ioas,
+	.detach_ioas = vfio_iommufd_emulated_detach_ioas,
 };
 
 struct mdev_driver vfio_ccw_mdev_driver = {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index cfbcb864ab63..50d0293eeef3 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1844,6 +1844,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
 	.bind_iommufd = vfio_iommufd_emulated_bind,
 	.unbind_iommufd = vfio_iommufd_emulated_unbind,
 	.attach_ioas = vfio_iommufd_emulated_attach_ioas,
+	.detach_ioas = vfio_iommufd_emulated_detach_ioas,
 };
 
 static struct mdev_driver vfio_ap_matrix_driver = {
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 86df5415759a..4d84904fd927 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -231,3 +231,16 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_attach_ioas);
+
+void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (WARN_ON(!vdev->iommufd_access) ||
+	    !vdev->iommufd_attached)
+		return;
+
+	iommufd_access_detach(vdev->iommufd_access);
+	vdev->iommufd_attached = false;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_detach_ioas);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f2f02273ece1..24091a7c7bdb 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -128,6 +128,7 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
 int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
+void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev);
 #else
 static inline struct iommufd_ctx *
 vfio_iommufd_device_ictx(struct vfio_device *vdev)
@@ -157,6 +158,8 @@ vfio_iommufd_get_dev_id(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 	((void (*)(struct vfio_device *vdev)) NULL)
 #define vfio_iommufd_emulated_attach_ioas \
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
+#define vfio_iommufd_emulated_detach_ioas \
+	((void (*)(struct vfio_device *vdev)) NULL)
 #endif
 
 static inline bool vfio_device_cdev_opened(struct vfio_device *device)
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index c6c6b5d26670..3764d1911b51 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1377,6 +1377,7 @@ static const struct vfio_device_ops mbochs_dev_ops = {
 	.bind_iommufd	= vfio_iommufd_emulated_bind,
 	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
 	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
+	.detach_ioas	= vfio_iommufd_emulated_detach_ioas,
 };
 
 static struct mdev_driver mbochs_driver = {
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index a62ea11e20ec..064e1c0a7aa8 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -666,6 +666,7 @@ static const struct vfio_device_ops mdpy_dev_ops = {
 	.bind_iommufd	= vfio_iommufd_emulated_bind,
 	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
 	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
+	.detach_ioas	= vfio_iommufd_emulated_detach_ioas,
 };
 
 static struct mdev_driver mdpy_driver = {
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index a60801fb8660..5af00387c519 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1272,6 +1272,7 @@ static const struct vfio_device_ops mtty_dev_ops = {
 	.bind_iommufd	= vfio_iommufd_emulated_bind,
 	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
 	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
+	.detach_ioas	= vfio_iommufd_emulated_detach_ioas,
 };
 
 static struct mdev_driver mtty_driver = {
-- 
2.34.1

