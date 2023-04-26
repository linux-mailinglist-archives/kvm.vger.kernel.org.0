Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3547F6EF6D0
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241220AbjDZOyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241215AbjDZOya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:54:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0159E76A9;
        Wed, 26 Apr 2023 07:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682520868; x=1714056868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sdoYFPhd6sLPYPVG93DO+sP/RGUhPCk04kqwDwb+nRY=;
  b=C9vWmpO0JVJWkP+LLzmUlRA4YkPnRvtQ5lDZ7ddtrBEXnq1EihXT/XXi
   Td/O4QJHaAPvKgpPITsYK56x24OIXzWTaBODiLVPRicwJ1g8tOW5oxzTb
   lOn+00ukouEnK/LH6FfBBg4ibv56dgkxAanBkHyolTV7GFk+xgKmj162S
   pL8DISKhHFcdwiaBADXQsZPoYqvy/wGnCcPPZSnkNWB96SS7Nct5eOqtU
   hL68btIQugIkGqeNN/i/GEI7iK4yIZSKyBm/Rse7RW1rweyOVF8epIz2J
   ble8+l67VaMAUvD1IWAPWGtQPBGzW/fRW8nJPgkhfrxg2YUivb/NapVf8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="433410248"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="433410248"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 07:54:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="758644002"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="758644002"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2023 07:54:27 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
Subject: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu devices
Date:   Wed, 26 Apr 2023 07:54:12 -0700
Message-Id: <20230426145419.450922-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426145419.450922-1-yi.l.liu@intel.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This binds noiommu device to iommufd and creates iommufd_access for this
bond. This is useful for adding an iommufd-based device ownership check
for VFIO_DEVICE_PCI_HOT_RESET since this model requires all the other
affected devices bound to the same iommufd as the device to be reset.
For noiommu devices, there is no backend iommu, so create iommufd_access
instead of iommufd_device.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 895852ad37ed..ca29c4feded3 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -29,7 +29,8 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 		 */
 		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
 			return -EPERM;
-		return 0;
+
+		return vfio_iommufd_emulated_bind(vdev, ictx, &device_id);
 	}
 
 	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
@@ -59,8 +60,10 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vdev->noiommu)
+	if (vdev->noiommu) {
+		vfio_iommufd_emulated_unbind(vdev);
 		return;
+	}
 
 	if (vdev->ops->unbind_iommufd)
 		vdev->ops->unbind_iommufd(vdev);
@@ -110,10 +113,14 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 EXPORT_SYMBOL_GPL(vfio_iommufd_physical_attach_ioas);
 
 /*
- * The emulated standard ops mean that vfio_device is going to use the
- * "mdev path" and will call vfio_pin_pages()/vfio_dma_rw(). Drivers using this
- * ops set should call vfio_register_emulated_iommu_dev(). Drivers that do
- * not call vfio_pin_pages()/vfio_dma_rw() have no need to provide dma_unmap.
+ * The emulated standard ops can be used by below usages:
+ * 1) The vfio_device that is going to use the "mdev path" and will call
+ *    vfio_pin_pages()/vfio_dma_rw().  Such drivers using should call
+ *    vfio_register_emulated_iommu_dev().  Drivers that do not call
+ *    vfio_pin_pages()/vfio_dma_rw() have no need to provide dma_unmap.
+ * 2) The noiommu device which doesn't have backend iommu but creating
+ *    an iommufd_access allows generating a dev_id for it. noiommu device
+ *    is not allowed to do map/unmap so this becomes a nop.
  */
 
 static void vfio_emulated_unmap(void *data, unsigned long iova,
@@ -121,7 +128,8 @@ static void vfio_emulated_unmap(void *data, unsigned long iova,
 {
 	struct vfio_device *vdev = data;
 
-	if (vdev->ops->dma_unmap)
+	/* noiommu devices cannot do map/unmap */
+	if (vdev->noiommu && vdev->ops->dma_unmap)
 		vdev->ops->dma_unmap(vdev, iova, length);
 }
 
-- 
2.34.1

