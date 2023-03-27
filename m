Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56B36C9FB7
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbjC0Jet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbjC0Je2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:34:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9423430ED;
        Mon, 27 Mar 2023 02:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679909661; x=1711445661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SDM9jyf+OXhd1Zokm6qIgm/u2mKnKiVjbUza2h6GkY8=;
  b=mn7Z81alpa07jd3ONE5Ujj+AWpLoFYWGbAgKYxZ5rNefuomTOi1EoX0d
   ev1w9bz69TQINJhey00y3QsT3uGDmrOaw9MV1+8cUbnSDb2dDCfX3Is99
   5llwGG1loYVwa4Q34Lzaiem8IWpcqceJZrOa9NSzwLOnC87nrzFNw9rwX
   BYutIspWMbThjyOzcdg3bncNLQGUgU7awT9xf7H2ISMV1zX0FKCw8qAXL
   NGJriUQc9IvY28NX3yRXUV64wk1ovovUUOTfGqOTmYA9cc+XG5cucaaE7
   2mJ2AbFNFTwDtIyeXJV2KsLR4rY4EMSwQbqFpNOKezK6MnknJDLegW2kG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="402817956"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="402817956"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:33:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="685908089"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="685908089"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2023 02:33:58 -0700
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
Subject: [PATCH v3 5/6] vfio/mdev: Uses the vfio emulated iommufd ops set in the mdev sample drivers
Date:   Mon, 27 Mar 2023 02:33:50 -0700
Message-Id: <20230327093351.44505-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327093351.44505-1-yi.l.liu@intel.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
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

This harmonizes the no-DMA devices (the vfio-mdev sample drivers) with
the emulated devices (gvt-g, vfio-ap etc.). It makes it easier to add
BIND_IOMMUFD user interface which requires to return an iommufd ID to
represent the device/iommufd bond.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c     | 14 ++++++--------
 samples/vfio-mdev/mbochs.c |  3 +++
 samples/vfio-mdev/mdpy.c   |  3 +++
 samples/vfio-mdev/mtty.c   |  3 +++
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 1ee558c0be25..890ea101685c 100644
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
+ * not call vfio_pin_pages()/vfio_dma_rw() have no need to provide dma_unmap.
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

