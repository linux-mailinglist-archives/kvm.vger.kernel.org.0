Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE7E70173B
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238803AbjEMN2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbjEMN2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:28:50 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AABF3C39;
        Sat, 13 May 2023 06:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984525; x=1715520525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EgsiHxp3ch5RhsjSPv6RMxR4l5RlTu18tOocI9MBQOA=;
  b=m1e6OiA4WWgBcLmdMpxz6xc0VFde48J0+FCfGKzB0zCbfnmGbvKhB+8q
   AaKmcbI9M2QZDFVv+Xv5QEKP8VdgA1jfaxv3z4WJ9HMlXjTkUofy/jspV
   4JBIAejCNBydLd7jG7w4fsXkQU3uqLI1CnlmqRM8D5EdCiUN6MZsc3pH5
   RzeZrzkdeIw7PzFUZoNzYrW/vyeK70v3kFSus9BagfEzLl2T6xKh8Nob3
   2eWZ4MUqHZjhMe9tT5x8r9Zy4YI5Rgim0Rma8tpuAc5fRnlIpDl+RQex0
   9edrvpMf5gVb6UvtaJN8HDOtrHepFd/V4OdWjYQ3sQfS/ahSyuSj98bxF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="354100723"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="354100723"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="703459489"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="703459489"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 13 May 2023 06:28:44 -0700
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
Subject: [PATCH v11 10/23] vfio-iommufd: Move noiommu compat probe out of vfio_iommufd_bind()
Date:   Sat, 13 May 2023 06:28:14 -0700
Message-Id: <20230513132827.39066-11-yi.l.liu@intel.com>
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

into vfio_device_group_open(). This is more consistent with what will
be done in vfio device cdev path.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c   |  6 ++++++
 drivers/vfio/iommufd.c | 32 +++++++++++++++++++-------------
 drivers/vfio/vfio.h    |  9 +++++++++
 3 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index a17584e8be15..cfd0b9254bbc 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -192,6 +192,12 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 		vfio_device_group_get_kvm_safe(device);
 
 	df->iommufd = device->group->iommufd;
+	if (df->iommufd && vfio_device_is_noiommu(device) && device->open_count == 0) {
+		ret = vfio_iommufd_compat_probe_noiommu(device,
+							df->iommufd);
+		if (ret)
+			goto out_put_kvm;
+	}
 
 	ret = vfio_device_open(df);
 	if (ret) {
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index a18e920be164..7a654a1437f0 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -46,6 +46,24 @@ static void vfio_iommufd_noiommu_unbind(struct vfio_device *vdev)
 	}
 }
 
+int vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
+				      struct iommufd_ctx *ictx)
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
@@ -54,20 +72,8 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 
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
-
+	if (vfio_device_is_noiommu(vdev))
 		return vfio_iommufd_noiommu_bind(vdev, ictx, &device_id);
-	}
 
 	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
 	if (ret)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 785afc40ece8..8884b557fb26 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -234,9 +234,18 @@ static inline void vfio_container_cleanup(void)
 #endif
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
+int vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
+				      struct iommufd_ctx *ictx);
 int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
 void vfio_iommufd_unbind(struct vfio_device *device);
 #else
+static inline int
+vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
+				  struct iommufd_ctx *ictx)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int vfio_iommufd_bind(struct vfio_device *device,
 				    struct iommufd_ctx *ictx)
 {
-- 
2.34.1

