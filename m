Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F08168B831
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 10:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjBFJHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 04:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjBFJG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 04:06:59 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3308C1EBFA;
        Mon,  6 Feb 2023 01:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675674393; x=1707210393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nK9khFuMQE7DsDuNuxLdNViJzBagLJCW1qbO9pxWibg=;
  b=c5aqCyXWRb3Xoych1JCD8NvN0pn5cCoipeg3olvgJuk1oM1chIwqwPf+
   ASQS35Ephydk7/NYIhMUvVsIrAhlwpz76xhQB1gfG0Bn/UbRe2H4EAcJq
   L8ARnv7rCROK3gZDMPhsdXYP1xBHEFuQoeduKbg+eQginaoewOGIYxy5T
   AageSomrdZpeVfRCHbVelVVA5X1THv7xBJRcf3iXWCoJbfoPw6cQcVJdU
   3wQA9U3xKsOf45g1lZnlEMxygg9cqwnLCBSkaHGfoY+PWMGD09FxpKbbb
   1DnSvanVjJQlNiPA/pARe/lNDNrfjhhcmha7mGJc4l3dgGNJ0AgESLdMd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="309495878"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="309495878"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 01:06:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="911862838"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="911862838"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 06 Feb 2023 01:05:59 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v2 10/14] vfio-iommufd: Add detach_ioas for emulated VFIO devices
Date:   Mon,  6 Feb 2023 01:05:28 -0800
Message-Id: <20230206090532.95598-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206090532.95598-1-yi.l.liu@intel.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
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
---
 drivers/gpu/drm/i915/gvt/kvmgt.c  |  1 +
 drivers/s390/cio/vfio_ccw_ops.c   |  1 +
 drivers/s390/crypto/vfio_ap_ops.c |  1 +
 drivers/vfio/iommufd.c            | 29 +++++++++++++++++++++++++----
 include/linux/vfio.h              |  3 +++
 5 files changed, 31 insertions(+), 4 deletions(-)

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
index 90df1f30b7fd..026f81a87dd7 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -149,14 +149,18 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_bind);
 
+static void __vfio_iommufd_access_destroy(struct vfio_device *vdev)
+{
+	iommufd_access_destroy(vdev->iommufd_access);
+	vdev->iommufd_access = NULL;
+}
+
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vdev->iommufd_access) {
-		iommufd_access_destroy(vdev->iommufd_access);
-		vdev->iommufd_access = NULL;
-	}
+	if (vdev->iommufd_access)
+		__vfio_iommufd_access_destroy(vdev);
 	iommufd_ctx_put(vdev->iommufd_ictx);
 	vdev->iommufd_ictx = NULL;
 }
@@ -168,6 +172,12 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 
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
@@ -176,3 +186,14 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
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
+	__vfio_iommufd_access_destroy(vdev);
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_detach_ioas);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 99a6a07e915c..70380d4955e1 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -125,6 +125,7 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
 int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
+void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev);
 #else
 #define vfio_iommufd_physical_bind                                      \
 	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
@@ -142,6 +143,8 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 	((void (*)(struct vfio_device *vdev)) NULL)
 #define vfio_iommufd_emulated_attach_ioas \
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
+#define vfio_iommufd_emulated_detach_ioas \
+	((void (*)(struct vfio_device *vdev)) NULL)
 #endif
 
 /**
-- 
2.34.1

