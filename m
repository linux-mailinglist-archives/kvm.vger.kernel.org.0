Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685F674E4DB
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 05:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjGKC77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 22:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjGKC75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 22:59:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7668A10E7;
        Mon, 10 Jul 2023 19:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689044387; x=1720580387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V9bQ3d+nphu/TE67jwxFvrpOP8ZJXLyPvc4NFncqvnM=;
  b=J1NatIMyaTIUTMInXleKc4hbEDW+gSrxqFj8tTo5E86sOMETYvbToI5Z
   aMITP6W8CFOvmS1X5ZvTs4i+OHe95jiFacfmh5ljHU2I7qJ79sPXGjyw2
   MEvlboafRDLSeE5ACTQd1ibltdcPTF2gMd9oVjXbgJeCDYvByyTOvHBzY
   R0NO/iTEL4dWilDzBZXvEMTfkC4OzHhOdJitVaktV9ceM4MwUcBkKi3+t
   w2UNEdkxggIVftUR2z78lvjYwQP77CJkY5JuHUiw8J4lHvgi24rzIWSe1
   cQYMbskvl/6u+RjzWgICRFnaDHpsFipTfRMVgP7JBlD6HZvUepw4Sp219
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="361973085"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="361973085"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 19:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="724250844"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="724250844"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2023 19:59:40 -0700
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
Subject: [PATCH v14 11/26] vfio-iommufd: Split bind/attach into two steps
Date:   Mon, 10 Jul 2023 19:59:13 -0700
Message-Id: <20230711025928.6438-12-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711025928.6438-1-yi.l.liu@intel.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This aligns the bind/attach logic with the coming vfio device cdev support.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c   | 17 +++++++++++++----
 drivers/vfio/iommufd.c | 35 +++++++++++++++++------------------
 drivers/vfio/vfio.h    |  9 +++++++++
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index b8b77daf7aa6..41a09a2df690 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -207,9 +207,13 @@ static int vfio_df_group_open(struct vfio_device_file *df)
 	}
 
 	ret = vfio_df_open(df);
-	if (ret) {
-		df->iommufd = NULL;
+	if (ret)
 		goto out_put_kvm;
+
+	if (df->iommufd && device->open_count == 1) {
+		ret = vfio_iommufd_compat_attach_ioas(device, df->iommufd);
+		if (ret)
+			goto out_close_device;
 	}
 
 	/*
@@ -218,12 +222,17 @@ static int vfio_df_group_open(struct vfio_device_file *df)
 	 */
 	smp_store_release(&df->access_granted, true);
 
+	mutex_unlock(&device->dev_set->lock);
+	mutex_unlock(&device->group->group_lock);
+	return 0;
+
+out_close_device:
+	vfio_df_close(df);
 out_put_kvm:
+	df->iommufd = NULL;
 	if (device->open_count == 0)
 		vfio_device_put_kvm(device);
-
 	mutex_unlock(&device->dev_set->lock);
-
 out_unlock:
 	mutex_unlock(&device->group->group_lock);
 	return ret;
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 36f838dad084..91fdae69bb45 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -20,33 +20,32 @@ bool vfio_iommufd_device_has_compat_ioas(struct vfio_device *vdev,
 
 int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 {
-	u32 ioas_id;
 	u32 device_id;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	/* The legacy path has no way to return the device id */
+	return vdev->ops->bind_iommufd(vdev, ictx, &device_id);
+}
+
+int vfio_iommufd_compat_attach_ioas(struct vfio_device *vdev,
+				    struct iommufd_ctx *ictx)
+{
+	u32 ioas_id;
 	int ret;
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
-	if (ret)
-		return ret;
+	/* compat noiommu does not need to do ioas attach */
+	if (vfio_device_is_noiommu(vdev))
+		return 0;
 
 	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
 	if (ret)
-		goto err_unbind;
-	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
-	if (ret)
-		goto err_unbind;
-
-	/*
-	 * The legacy path has no way to return the device id or the selected
-	 * pt_id
-	 */
-	return 0;
+		return ret;
 
-err_unbind:
-	if (vdev->ops->unbind_iommufd)
-		vdev->ops->unbind_iommufd(vdev);
-	return ret;
+	/* The legacy path has no way to return the selected pt_id */
+	return vdev->ops->attach_ioas(vdev, &ioas_id);
 }
 
 void vfio_iommufd_unbind(struct vfio_device *vdev)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 300cab04f4e1..04755379940c 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -238,6 +238,8 @@ bool vfio_iommufd_device_has_compat_ioas(struct vfio_device *vdev,
 					 struct iommufd_ctx *ictx);
 int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
 void vfio_iommufd_unbind(struct vfio_device *device);
+int vfio_iommufd_compat_attach_ioas(struct vfio_device *device,
+				    struct iommufd_ctx *ictx);
 #else
 static inline bool
 vfio_iommufd_device_has_compat_ioas(struct vfio_device *vdev,
@@ -255,6 +257,13 @@ static inline int vfio_iommufd_bind(struct vfio_device *device,
 static inline void vfio_iommufd_unbind(struct vfio_device *device)
 {
 }
+
+static inline int
+vfio_iommufd_compat_attach_ioas(struct vfio_device *device,
+				struct iommufd_ctx *ictx)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
-- 
2.34.1

