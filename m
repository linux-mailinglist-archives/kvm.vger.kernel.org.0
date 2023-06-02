Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C60F7201DB
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 14:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbjFBMR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 08:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235865AbjFBMR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 08:17:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934241A7;
        Fri,  2 Jun 2023 05:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685708244; x=1717244244;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LeOKu9sKBvsX3/QW8tj+Bho1wk3YtDCVNdCvqStJ7Gk=;
  b=X2k9HJSAe4O17+K9ZoQvDS5RETqLct6bGfnVWaXoYBNfzLDnqrjRQv5Z
   lVUf2dodmAidzZhhCoDIih+qP0VAUPgAqBfE9mulEApFp+EEis13riVrV
   1BsKU5IoSzRAGsLrr+OjeMIAiG9qf9H9RwIta5HUZpEiY23nFW7qDp15B
   2rPX4KRf2KyLJnixsyb2lPug2ULIOy91AohR+3WGKIwjTQ/Ek9CwiVkMo
   2og8U3/P8OUKEesKfqkubThwQ+ABtxBfUgG9IgGN/FVH//bLeseK8F7Jd
   g2tU36Mb0kuLYFrz7ECmYtxRelXq4eFc5u1zCRy9Nt/Q07xVrQ32CR0N6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="384136756"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="384136756"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 05:17:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="1037947437"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="1037947437"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jun 2023 05:17:23 -0700
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
Subject: [PATCH v12 22/24] vfio: Remove vfio_device_is_noiommu()
Date:   Fri,  2 Jun 2023 05:16:51 -0700
Message-Id: <20230602121653.80017-23-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602121653.80017-1-yi.l.liu@intel.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This converts noiommu test to use vfio_device->noiommu flag. Per this
change, vfio_device_is_noiommu() is removed.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c   | 2 +-
 drivers/vfio/iommufd.c | 4 ++--
 drivers/vfio/vfio.h    | 9 ++-------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 64cdd0ea8825..08d37811507e 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -191,7 +191,7 @@ static int vfio_df_group_open(struct vfio_device_file *df)
 		vfio_device_group_get_kvm_safe(device);
 
 	df->iommufd = device->group->iommufd;
-	if (df->iommufd && vfio_device_is_noiommu(device) && device->open_count == 0) {
+	if (df->iommufd && device->noiommu && device->open_count == 0) {
 		/*
 		 * Require no compat ioas to be assigned to proceed.  The basic
 		 * statement is that the user cannot have done something that
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index a59ed4f881aa..fac8ca74ec85 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -37,7 +37,7 @@ int vfio_iommufd_compat_attach_ioas(struct vfio_device *vdev,
 	lockdep_assert_held(&vdev->dev_set->lock);
 
 	/* compat noiommu does not need to do ioas attach */
-	if (vfio_device_is_noiommu(vdev))
+	if (vdev->noiommu)
 		return 0;
 
 	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
@@ -54,7 +54,7 @@ void vfio_df_iommufd_unbind(struct vfio_device_file *df)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
-	if (vfio_device_is_noiommu(vdev))
+	if (vdev->noiommu)
 		return;
 
 	if (vdev->ops->unbind_iommufd)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 1b89e8bc8571..b138b8334fe0 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -106,11 +106,6 @@ bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
 
-static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
-{
-	return vdev->group->type == VFIO_NO_IOMMU;
-}
-
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
@@ -271,7 +266,7 @@ void vfio_init_device_cdev(struct vfio_device *device);
 static inline int vfio_device_add(struct vfio_device *device)
 {
 	/* cdev does not support noiommu device */
-	if (vfio_device_is_noiommu(device))
+	if (device->noiommu)
 		return device_add(&device->device);
 	vfio_init_device_cdev(device);
 	return cdev_device_add(&device->cdev, &device->device);
@@ -279,7 +274,7 @@ static inline int vfio_device_add(struct vfio_device *device)
 
 static inline void vfio_device_del(struct vfio_device *device)
 {
-	if (vfio_device_is_noiommu(device))
+	if (device->noiommu)
 		device_del(&device->device);
 	else
 		cdev_device_del(&device->cdev, &device->device);
-- 
2.34.1

