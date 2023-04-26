Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3836EF6CD
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241218AbjDZOya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241157AbjDZOy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:54:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658AF6A65;
        Wed, 26 Apr 2023 07:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682520866; x=1714056866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ei+ldlGBA0woJE13bWLVPf1qW3075XzsC5F91f4P4Ag=;
  b=FSY4ouGrW6qyIfEZgQaIB/Dyn+ASlIGiVbrQ2YIey+VJYjN0mGLRqjoZ
   1qeOE11wVRxTcfWxm8rHsngjP4JXfEOk49sk/YCEOsk+vEDVG2WQx7sDi
   VJTRiffJAWiSaA9Jxbp1VmdnhX5zQ/gXLSuZ5BmhtvDMk1vURu4oJTems
   FRZcGWkVSCTCvIwVKTKXUf4tUiqPrP4VJ3nwmjEEEldrn+IyHq7Wz4ibG
   owjT9F2iePrinEGSrzUZ4keG5mn1ajZ+sG0ZkqAAi51hpPKwn//nBWRLo
   hb12ze0LJjquBqDUez+AjjuT171R9QKxJ7XEMJu/1xFBEHOFNQA66KT6W
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="433410230"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="433410230"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 07:54:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="758643988"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="758643988"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2023 07:54:24 -0700
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
Subject: [PATCH v4 1/9] vfio: Determine noiommu in vfio_device registration
Date:   Wed, 26 Apr 2023 07:54:11 -0700
Message-Id: <20230426145419.450922-2-yi.l.liu@intel.com>
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

This adds a noiommu flag in vfio_device, hence caller of the
vfio_device_is_noiommu() just refers to the flag for noiommu
check.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/iommufd.c   | 4 ++--
 drivers/vfio/vfio.h      | 7 ++++---
 drivers/vfio/vfio_main.c | 4 ++++
 include/linux/vfio.h     | 1 +
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 88b00c501015..895852ad37ed 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -18,7 +18,7 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev)) {
+	if (vdev->noiommu) {
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
 
@@ -59,7 +59,7 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev))
+	if (vdev->noiommu)
 		return;
 
 	if (vdev->ops->unbind_iommufd)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 7b19c621e0e6..1ddf43863ad6 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -88,10 +88,11 @@ bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
 
-static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
+static inline int vfio_device_set_noiommu(struct vfio_device *device)
 {
-	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
-	       vdev->group->type == VFIO_NO_IOMMU;
+	device->noiommu = IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
+			  device->group->type == VFIO_NO_IOMMU;
+	return 0;
 }
 
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 89497c933490..09be9df2ceca 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -276,6 +276,10 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (ret)
 		return ret;
 
+	ret = vfio_device_set_noiommu(device);
+	if (ret)
+		goto err_out;
+
 	ret = device_add(&device->device);
 	if (ret)
 		goto err_out;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 2c137ea94a3e..4ee613924435 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -62,6 +62,7 @@ struct vfio_device {
 	struct iommufd_device *iommufd_device;
 	bool iommufd_attached;
 #endif
+	bool noiommu;
 };
 
 /**
-- 
2.34.1

