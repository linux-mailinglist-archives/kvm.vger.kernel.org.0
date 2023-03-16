Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E556BCF32
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjCPMPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjCPMPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:15:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05276505B;
        Thu, 16 Mar 2023 05:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678968931; x=1710504931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IYwmJkJhej3FobgFXSTgzXhZZzLMmukcDQZuUXtxfLM=;
  b=BNrhmac7hNCJajdDF4jZIeh5PSRBKCP4dRjpP5FwqKTJ3t1Y8lj1t8aO
   DxvPs7J6hc91wCzRnQBOC8Fe4L41LiLprAl/NUBdKqwqgHuXGfeUnwJ9D
   Y8c2AmXw67O/yVLYNKUEoJs1867sYZz0fJbhYEEMdJzRMx6dU8V3JuvV9
   4cwuiWBtsPM+3Oj7bCsWVnRUdnNiEywBZjQW9USK7u9kVi2fXE0lIulIh
   xVrDb3SvbGq6FNwc8KNzTMgDLCc6zU7eut1s+w2RHpSnDxzpacXUQIZUp
   w0QX6iYF+pRfUUkBHbhFUfeKM0p5nV/tGFQSP8oI8AAzmXT2Ubcdde2hr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336661401"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336661401"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:15:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="679874218"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679874218"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 05:15:30 -0700
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
Subject: [PATCH v2 4/5] vfio/mdev: Uses the vfio emulated iommufd ops set in the mdev sample drivers
Date:   Thu, 16 Mar 2023 05:15:25 -0700
Message-Id: <20230316121526.5644-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316121526.5644-1-yi.l.liu@intel.com>
References: <20230316121526.5644-1-yi.l.liu@intel.com>
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

This harmonizes the no-DMA devices (the vfio-mdev sample drivers) with
the emulated devices (gvt-g, vfio-ap etc.). It makes it easier to add
BIND_IOMMUFD user interface which requires to return an iommufd ID to
represent the device/iommufd bond.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c     | 14 ++++++--------
 samples/vfio-mdev/mbochs.c |  3 +++
 samples/vfio-mdev/mdpy.c   |  3 +++
 samples/vfio-mdev/mtty.c   |  3 +++
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index e40c0e9fea30..345ff8cf29e7 100644
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

