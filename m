Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6686D322E
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 17:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjDAPTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 11:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjDAPSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 11:18:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243D12544B;
        Sat,  1 Apr 2023 08:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680362324; x=1711898324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PirptMYKJTaup2Gvl84lhjR2Vgw3w06sDHqdMR/RpfQ=;
  b=UfoH8/Cc7roGI1Xg1ZzpXmOoK+F+5p5mNl5BPKht15360stLE3nhukkD
   Bv2Ovj88LjVHCivC5DDNDFntcWlw1ccFeFMjphx9dRIEVwLvUFyfQZdw6
   7CLCrN3NcAru5q7IaHVnE4Eli21nAIIrQNuVYHYQRZ9fr63Ve6nS2C+rq
   sa9wYLhgsmIg1s9bC7YSP1VhBJ/GezmVqvLwe6FLqZhmJyxDzs4m8djm9
   kd/a+od00B1X/Ikq8LtXATe7XDOrClClYmWGQckK/UODcGlOqIP15KkLl
   6jnWPXfDuBWYeHFWTZ9jYr40QeIqY31Jeh+GF6MtseCdshE9AFEUgiZkO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="404411286"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404411286"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 08:18:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="678937197"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="678937197"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2023 08:18:42 -0700
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
Subject: [PATCH v9 12/25] vfio-iommufd: Move noiommu support out of vfio_iommufd_bind()
Date:   Sat,  1 Apr 2023 08:18:20 -0700
Message-Id: <20230401151833.124749-13-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401151833.124749-1-yi.l.liu@intel.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
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

into vfio_device_group_open(). This is also more consistent with what
will be done in vfio device cdev path.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c   |  9 +++++++++
 drivers/vfio/iommufd.c | 35 ++++++++++++++++++-----------------
 drivers/vfio/vfio.h    |  9 +++++++++
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 63a4bf06ab9f..6178ac5d0b10 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -192,6 +192,15 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 		vfio_device_group_get_kvm_safe(device);
 
 	df->iommufd = device->group->iommufd;
+	if (df->iommufd && vfio_device_is_noiommu(device)) {
+		if (device->open_count == 0) {
+			ret = vfio_iommufd_enable_noiommu_compat(device,
+								 df->iommufd);
+			if (ret)
+				goto out_put_kvm;
+		}
+		df->iommufd = NULL;
+	}
 
 	ret = vfio_device_open(df);
 	if (ret) {
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 809f2dd73b9e..11f5148b446e 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -10,6 +10,24 @@
 MODULE_IMPORT_NS(IOMMUFD);
 MODULE_IMPORT_NS(IOMMUFD_VFIO);
 
+int vfio_iommufd_enable_noiommu_compat(struct vfio_device *device,
+				       struct iommufd_ctx *ictx)
+{
+	u32 ioas_id;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	/*
+	 * Require no compat ioas to be assigned to proceed.  The basic
+	 * statement is that the user cannot have done something that
+	 * implies they expected translation to exist
+	 */
+	if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
+		return -EPERM;
+	return 0;
+}
+
 int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 {
 	u32 ioas_id;
@@ -18,20 +36,6 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev)) {
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-
-		/*
-		 * Require no compat ioas to be assigned to proceed. The basic
-		 * statement is that the user cannot have done something that
-		 * implies they expected translation to exist
-		 */
-		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
-			return -EPERM;
-		return 0;
-	}
-
 	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
 	if (ret)
 		return ret;
@@ -59,9 +63,6 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev))
-		return;
-
 	if (vdev->ops->unbind_iommufd)
 		vdev->ops->unbind_iommufd(vdev);
 }
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 7d4108cbc185..136137b8618d 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -236,9 +236,18 @@ static inline void vfio_container_cleanup(void)
 #endif
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
+int vfio_iommufd_enable_noiommu_compat(struct vfio_device *device,
+				       struct iommufd_ctx *ictx);
 int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
 void vfio_iommufd_unbind(struct vfio_device *device);
 #else
+static inline int
+vfio_iommufd_enable_noiommu_compat(struct vfio_device *device,
+				   struct iommufd_ctx *ictx)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int vfio_iommufd_bind(struct vfio_device *device,
 				    struct iommufd_ctx *ictx)
 {
-- 
2.34.1

