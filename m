Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413C17016E0
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbjEMNVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbjEMNVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:21:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808393C1D;
        Sat, 13 May 2023 06:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984100; x=1715520100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7Jud81j68GXwp1AZyUJqqegxBroEGFVO9r8F7tMxbEk=;
  b=VmnZAbkWd6jxEEfnxQQHRv6VQAIG99jzkrr54FzcoftnaE819hs6Jj6N
   SUKS7nQiobqHwrKrwKWCzuW+EwmsGs5mBrgPlWB8HoqpMkRW3+sDA7muz
   EwjIyQ7KaLaFyzildCq6oHHWgDGGbthQHQfuahzpTVXVPATb5iHWG3Cn6
   AdV85G2dsJigy69aAmCdtj+WQZLs+WphyA5y16i4mnhbBEFOWf5QzBSE+
   VpzEzzfzaLnGv9mE5qcOR8nPgW+9fBP7omBDTbnAPWhqKzMm7Fa+Df4Dl
   ICp9XEqbzlPCNfHBVv0kLdYhVzwja3lvYzi9wTJ59k/Xwz7yc/Ks3zMIw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="416598947"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="416598947"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:21:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="790126430"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="790126430"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 13 May 2023 06:21:39 -0700
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
Subject: [PATCH v5 01/10] vfio-iommufd: Create iommufd_access for noiommu devices
Date:   Sat, 13 May 2023 06:21:27 -0700
Message-Id: <20230513132136.15021-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230513132136.15021-1-yi.l.liu@intel.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/vfio/iommufd.c | 43 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/vfio.h   |  1 +
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 88b00c501015..c1379e826052 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -10,6 +10,42 @@
 MODULE_IMPORT_NS(IOMMUFD);
 MODULE_IMPORT_NS(IOMMUFD_VFIO);
 
+static void vfio_noiommu_access_unmap(void *data, unsigned long iova,
+				      unsigned long length)
+{
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
+	vdev->noiommu_access = user;
+	return 0;
+}
+
+static void vfio_iommufd_noiommu_unbind(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (vdev->noiommu_access) {
+		iommufd_access_destroy(vdev->noiommu_access);
+		vdev->noiommu_access = NULL;
+	}
+}
+
 int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 {
 	u32 ioas_id;
@@ -29,7 +65,8 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 		 */
 		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
 			return -EPERM;
-		return 0;
+
+		return vfio_iommufd_noiommu_bind(vdev, ictx, &device_id);
 	}
 
 	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
@@ -59,8 +96,10 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev))
+	if (vfio_device_is_noiommu(vdev)) {
+		vfio_iommufd_noiommu_unbind(vdev);
 		return;
+	}
 
 	if (vdev->ops->unbind_iommufd)
 		vdev->ops->unbind_iommufd(vdev);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 2c137ea94a3e..16fd04490550 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -57,6 +57,7 @@ struct vfio_device {
 	struct list_head group_next;
 	struct list_head iommu_entry;
 	struct iommufd_access *iommufd_access;
+	struct iommufd_access *noiommu_access;
 	void (*put_kvm)(struct kvm *kvm);
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
-- 
2.34.1

