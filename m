Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34AC6B0885
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjCHNUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbjCHNUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:20:08 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B31B9BE9;
        Wed,  8 Mar 2023 05:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678281386; x=1709817386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HkexrwvnYWejPaT2AWfbM1T8RE/xmR+thl355jPmjRM=;
  b=M36STvq6Cz1eq0pzFL6yObbQW8v5z2I+qt/YCf0NSR7GUJBWiIqmpxvU
   P9ypO3BlSqVY6FvPyZ4F9b2dGy0a1uryWbMngAEkXhY+A/yVd6YtA2tIW
   AtFzCGGMu7F3wYPWZNOXPkaMXCMncLpzKYg+6s1dFckskIP8gq/ZdRAGY
   1kAsWjETNYnSJQb0V/4ZMBSgSjJmnWLnofU1aaY9lAwa0Npc1fCWd+uNd
   JXRd3QBbweee2ht4EVSH1rE4Sy2Svj9eEDeRX3/mdrpJekv3Cldn2J7bU
   9fMTpQlUwk0K2Frml5QWLrGYlmgSpEyeEnBdglxpWTgPmhUYSHzaSXs9I
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338474795"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="338474795"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:13:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="670330946"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="670330946"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 08 Mar 2023 05:13:45 -0800
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
Subject: [PATCH v1 4/5] Samples/mdev: Uses the vfio emulated iommufd ops set in the mdev sample drivers
Date:   Wed,  8 Mar 2023 05:13:39 -0800
Message-Id: <20230308131340.459224-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308131340.459224-1-yi.l.liu@intel.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
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

This harmonizes the no-DMA devices (the vfio-mdev sample drivers) with
the emulated devices (gvt-g, vfio-ap etc.). It makes it easier to add
BIND_IOMMUFD user interface which requires to return an iommufd ID to
represent the device/iommufd bond.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c     | 14 ++++++--------
 samples/vfio-mdev/mbochs.c |  3 +++
 samples/vfio-mdev/mdpy.c   |  3 +++
 samples/vfio-mdev/mtty.c   |  3 +++
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 7a4458a10656..768d353cb6fa 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -32,12 +32,8 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 		return 0;
 	}
 
-	/*
-	 * If the driver doesn't provide this op then it means the device does
-	 * not do DMA at all. So nothing to do.
-	 */
-	if (!vdev->ops->bind_iommufd)
-		return 0;
+	if (WARN_ON(!vdev->ops->bind_iommufd))
+		return -ENODEV;
 
 	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
 	if (ret)
@@ -119,7 +115,8 @@ EXPORT_SYMBOL_GPL(vfio_iommufd_physical_attach_ioas);
 /*
  * The emulated standard ops mean that vfio_device is going to use the
  * "mdev path" and will call vfio_pin_pages()/vfio_dma_rw(). Drivers using this
- * ops set should call vfio_register_emulated_iommu_dev().
+ * ops set should call vfio_register_emulated_iommu_dev(). Drivers that do
+ * not call vfio_pin_pages()/vfio_dma_rw() no need to provide dma_unmap.
  */
 
 static void vfio_emulated_unmap(void *data, unsigned long iova,
@@ -127,7 +124,8 @@ static void vfio_emulated_unmap(void *data, unsigned long iova,
 {
 	struct vfio_device *vdev = data;
 
-	vdev->ops->dma_unmap(vdev, iova, length);
+	if (vdev->ops->dma_unmap)
+		vdev->ops->dma_unmap(vdev, iova, length);
 }
 
 static const struct iommufd_access_ops vfio_user_ops = {
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index e54eb752e1ba..19391dda5fba 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1374,6 +1374,9 @@ static const struct vfio_device_ops mbochs_dev_ops = {
 	.write = mbochs_write,
 	.ioctl = mbochs_ioctl,
 	.mmap = mbochs_mmap,
+	.bind_iommufd	= vfio_iommufd_emulated_bind,
+	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
+	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
 };
 
 static struct mdev_driver mbochs_driver = {
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index e8400fdab71d..5f48aef36995 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -663,6 +663,9 @@ static const struct vfio_device_ops mdpy_dev_ops = {
 	.write = mdpy_write,
 	.ioctl = mdpy_ioctl,
 	.mmap = mdpy_mmap,
+	.bind_iommufd	= vfio_iommufd_emulated_bind,
+	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
+	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
 };
 
 static struct mdev_driver mdpy_driver = {
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index e887de672c52..35460901b9f7 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1269,6 +1269,9 @@ static const struct vfio_device_ops mtty_dev_ops = {
 	.read = mtty_read,
 	.write = mtty_write,
 	.ioctl = mtty_ioctl,
+	.bind_iommufd	= vfio_iommufd_emulated_bind,
+	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
+	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
 };
 
 static struct mdev_driver mtty_driver = {
-- 
2.34.1

