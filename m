Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024596A4033
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjB0LL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjB0LLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:11:54 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268031DB9B;
        Mon, 27 Feb 2023 03:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677496311; x=1709032311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=96w34qZIKqDpPrdn2OGuLtO0ipOZzw24+KiFJdwlZpE=;
  b=Xd29MnLlZpxljVU8VOwA6x4w+im1i+XhWUtSVWFEE4XEzIHMvVrQvpnV
   ojL8Lj3IJ0PeNeWHXY7J7sW0j4ro/Z7SSLU/SSyRzjLLZvRLtUClIYl2D
   q7iSOEqMXzamcK3R7mkrOK4FOqyHos+eNiVA/vtnE6k85c0QpQDCHGlwb
   kIAadbi0/+uc4s599+9NAyfqLefNHwnsPZZ1L3zSPppor/muQN6p/+sv7
   MHu+incWZSB0Vp49Y1CAUpByFP0OyBrcYfzvJ/k1/3w2qssjmPEW96ka4
   lHSm4HITGNCBp1UIjPW5t8iCm2agTsfBo5I3uEDHvdt3JnclillbsnGCe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="420097707"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="420097707"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 03:11:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651189555"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651189555"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 03:11:46 -0800
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
Subject: [PATCH v5 12/19] vfio-iommufd: Add detach_ioas for emulated VFIO devices
Date:   Mon, 27 Feb 2023 03:11:28 -0800
Message-Id: <20230227111135.61728-13-yi.l.liu@intel.com>
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

this prepares for adding DETACH ioctl for emulated VFIO devices.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c  |  1 +
 drivers/s390/cio/vfio_ccw_ops.c   |  1 +
 drivers/s390/crypto/vfio_ap_ops.c |  1 +
 drivers/vfio/iommufd.c            | 18 ++++++++++++++++++
 include/linux/vfio.h              |  3 +++
 5 files changed, 24 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 8ae7039b3683..8a76a84bc3c1 100644
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
index 9c01957e56b3..f99c69d40982 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1802,6 +1802,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
 	.bind_iommufd = vfio_iommufd_emulated_bind,
 	.unbind_iommufd = vfio_iommufd_emulated_unbind,
 	.attach_ioas = vfio_iommufd_emulated_attach_ioas,
+	.detach_ioas = vfio_iommufd_emulated_detach_ioas,
 };
 
 static struct mdev_driver vfio_ap_matrix_driver = {
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index bfaa9876499b..faf2516b0f06 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -165,6 +165,12 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	if (!vdev->iommufd_ictx)
+		return -EINVAL;
+
+	if (vdev->iommufd_access)
+		return -EBUSY;
+
 	user = iommufd_access_create(vdev->iommufd_ictx, *pt_id, &vfio_user_ops,
 				     vdev);
 	if (IS_ERR(user))
@@ -173,3 +179,15 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_attach_ioas);
+
+void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (!vdev->iommufd_ictx || !vdev->iommufd_access)
+		return;
+
+	iommufd_access_destroy(vdev->iommufd_access);
+	vdev->iommufd_access = NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_detach_ioas);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 9815a8c4ac7c..c9b91c57de07 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -126,6 +126,7 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
 int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
+void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev);
 #else
 #define vfio_iommufd_physical_bind                                      \
 	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
@@ -143,6 +144,8 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 	((void (*)(struct vfio_device *vdev)) NULL)
 #define vfio_iommufd_emulated_attach_ioas \
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
+#define vfio_iommufd_emulated_detach_ioas \
+	((void (*)(struct vfio_device *vdev)) NULL)
 #endif
 
 /**
-- 
2.34.1

