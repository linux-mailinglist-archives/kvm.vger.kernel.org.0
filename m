Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7DA70175B
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbjEMN30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238862AbjEMN3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:29:24 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFC95241;
        Sat, 13 May 2023 06:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984538; x=1715520538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pXzbJBLBysbJELsePoW3ed+pvbFtxaByVZglmAVGcd4=;
  b=Bb6RWyMq/Dh+DGuEl6W9DJoI9MkHt6fO8BHlhEv5Toqgg+zSJC6uztf5
   wXT59hqQhCFNrn0oaK1COuKJLvmz7tfUWdhkzxVAt2WcqjKQaYsJqOm02
   ivMd4b0EMFQSRaXHHiPNQ27ZK6MPPZ5svBNRXhvEX3YrS5ykb+hy88F+N
   AOs6uZCk6UO4UCpYUTB2GHSk2X3tQzY1Kw/qVIkwjWG9FiHhvHkeX3THh
   W11V0HKJCj4twM0VTurAUBm5C6oV0rttifu8PV+ksjMnP5HGAauoVk6FQ
   NyVf2h7Gy8tvZwMbAz2Qdwas9L/VCZ9gWHMO1M0eDmIw0i9yx5TzObYzi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="354100784"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="354100784"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:28:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="703459508"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="703459508"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 13 May 2023 06:28:51 -0700
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
Subject: [PATCH v11 15/23] vfio-iommufd: Add detach_ioas support for emulated VFIO devices
Date:   Sat, 13 May 2023 06:28:19 -0700
Message-Id: <20230513132827.39066-16-yi.l.liu@intel.com>
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

this prepares for adding DETACH ioctl for emulated VFIO devices.

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
 drivers/vfio/iommufd.c            | 12 ++++++++++++
 include/linux/vfio.h              |  3 +++
 samples/vfio-mdev/mbochs.c        |  1 +
 samples/vfio-mdev/mdpy.c          |  1 +
 samples/vfio-mdev/mtty.c          |  1 +
 8 files changed, 21 insertions(+)

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
index e3953e1617a5..83575b65ea01 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -258,3 +258,15 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_attach_ioas);
+
+void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (WARN_ON(!vdev->iommufd_access) || !vdev->iommufd_attached)
+		return;
+
+	iommufd_access_detach(vdev->iommufd_access);
+	vdev->iommufd_attached = false;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_detach_ioas);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f446f5901e46..26e4a73101eb 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -129,6 +129,7 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
 int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
+void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev);
 #else
 static inline struct iommufd_ctx *
 vfio_iommufd_physical_ictx(struct vfio_device *vdev)
@@ -158,6 +159,8 @@ vfio_iommufd_physical_devid(struct vfio_device *vdev)
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

