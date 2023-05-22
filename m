Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5AC70BC96
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 13:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbjEVL6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 07:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjEVL6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 07:58:04 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D14B109;
        Mon, 22 May 2023 04:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684756675; x=1716292675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NDUAP9Oi2WIIYUBeFOPVqAVyLqAhhC5Si2F9JyHHIdc=;
  b=kNAKjdTO9RivLy3MHnUsZJcwbBYu8xP2pqMMKqCuujLZqnsR13GQwPom
   bt7dXheM1B2uCCn9nKFqdo4mKRg18oT+tHW3SWbbaGZJNQRK0LmQmI0aJ
   cJ0Y2imeJ2+oX9zPnBgI/ufvbkjZWUhSxXoIp1L2iPJ3FmVDwuAtVZGVv
   3nvOy5+JxRtUaaGO2fr0vKT/BbeXc3uX6RGoNCimGk+rWQCdjTxt9GYX0
   NPw9i4/e7idK2xxXe8eZehQwfpmHAtQzzaKCxChPr8px6Uo0VACU1iNEV
   kF+TrKOTHCVKPx3RiLrfwFgATfxijXcZoSkTsTKxvqAegmMfkyX6jm8I6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="356128145"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="356128145"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 04:57:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="815660165"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="815660165"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2023 04:57:53 -0700
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
Subject: [PATCH v6 01/10] vfio-iommufd: Create iommufd_access for noiommu devices
Date:   Mon, 22 May 2023 04:57:42 -0700
Message-Id: <20230522115751.326947-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230522115751.326947-1-yi.l.liu@intel.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c | 44 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 88b00c501015..356dd215a8d5 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -10,6 +10,43 @@
 MODULE_IMPORT_NS(IOMMUFD);
 MODULE_IMPORT_NS(IOMMUFD_VFIO);
 
+static void vfio_noiommu_access_unmap(void *data, unsigned long iova,
+				      unsigned long length)
+{
+	WARN_ON(1);
+}
+
+static const struct iommufd_access_ops vfio_user_noiommu_ops = {
+	.needs_pin_pages = 1,
+	.unmap = vfio_noiommu_access_unmap,
+};
+
+static int vfio_iommufd_noiommu_bind(struct vfio_device *vdev,
+				     struct iommufd_ctx *ictx,
+				     u32 *out_device_id)
+{
+	struct iommufd_access *user;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	user = iommufd_access_create(ictx, &vfio_user_noiommu_ops,
+				     vdev, out_device_id);
+	if (IS_ERR(user))
+		return PTR_ERR(user);
+	vdev->iommufd_access = user;
+	return 0;
+}
+
+static void vfio_iommufd_noiommu_unbind(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (vdev->iommufd_access) {
+		iommufd_access_destroy(vdev->iommufd_access);
+		vdev->iommufd_access = NULL;
+	}
+}
+
 int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 {
 	u32 ioas_id;
@@ -29,7 +66,8 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 		 */
 		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
 			return -EPERM;
-		return 0;
+
+		return vfio_iommufd_noiommu_bind(vdev, ictx, &device_id);
 	}
 
 	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
@@ -59,8 +97,10 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev))
+	if (vfio_device_is_noiommu(vdev)) {
+		vfio_iommufd_noiommu_unbind(vdev);
 		return;
+	}
 
 	if (vdev->ops->unbind_iommufd)
 		vdev->ops->unbind_iommufd(vdev);
-- 
2.34.1

