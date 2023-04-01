Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831386D3238
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 17:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjDAPTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 11:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjDAPSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 11:18:55 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA4D2546F;
        Sat,  1 Apr 2023 08:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680362328; x=1711898328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=opGN95o7pF1df9Ozf4TXyBS5az+9mr8bUEPUq1TuJqs=;
  b=G0GeimkCK49GH8h3zoDxK5W+FJZisGy3jHm2JnJlZEPpOJbIv/rLWGvp
   wCdr2F/G5UQnL9CKlFly4ykNv4n3VqjNxvTXyVNGpO+4C4QlbVjC5xLEv
   66car+TZvpdshHtbQwz4VhP8Xonq8Bm8WjQEdaB/LlIMkJRHzjGd0qPZl
   DCDBdELrL2d8YPhLxNzaQPq6gja/9O2m7MYp7ZIjXTs/DXllzBhymNXAj
   3AdWrE9vv0wBNIHc1SJZjGoq7tGC7e/326CIJxkYgceeg4mhpoCZcQwUG
   G1GS7MWVib7gEIFVM+V9slnBlanDZXhG0iw9V/xNtAKeno0iVglzESF9m
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="404411345"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404411345"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 08:18:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="678937218"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="678937218"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2023 08:18:45 -0700
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
Subject: [PATCH v9 18/25] vfio: Determine noiommu in vfio_device registration
Date:   Sat,  1 Apr 2023 08:18:26 -0700
Message-Id: <20230401151833.124749-19-yi.l.liu@intel.com>
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

This adds a noiommu flag in vfio_device, hence caller of the
vfio_device_is_noiommu() just refers to the flag for noiommu
check.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 2 +-
 drivers/vfio/vfio.h      | 6 +++---
 drivers/vfio/vfio_main.c | 2 ++
 include/linux/vfio.h     | 1 +
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index de9f09c7cf00..8c88bff0fc59 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -192,7 +192,7 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 		vfio_device_group_get_kvm_safe(device);
 
 	df->iommufd = device->group->iommufd;
-	if (df->iommufd && vfio_device_is_noiommu(device)) {
+	if (df->iommufd && device->noiommu) {
 		if (device->open_count == 0) {
 			ret = vfio_iommufd_enable_noiommu_compat(device,
 								 df->iommufd);
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index b47b186573ac..41dfc9d5205a 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -108,10 +108,10 @@ bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
 
-static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
+static inline void vfio_device_set_noiommu(struct vfio_device *device)
 {
-	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
-	       vdev->group->type == VFIO_NO_IOMMU;
+	device->noiommu = IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
+			  device->group->type == VFIO_NO_IOMMU;
 }
 
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index bc2ecbb7c22a..989c40a49171 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -277,6 +277,8 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (ret)
 		return ret;
 
+	vfio_device_set_noiommu(device);
+
 	ret = device_add(&device->device);
 	if (ret)
 		goto err_out;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 1445eb185121..672c0d9ac3fa 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -63,6 +63,7 @@ struct vfio_device {
 	bool iommufd_attached;
 #endif
 	bool cdev_opened;
+	bool noiommu;
 };
 
 /**
-- 
2.34.1

