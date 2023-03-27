Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF236CA04E
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbjC0Jlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbjC0JlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:41:09 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A4A49E9;
        Mon, 27 Mar 2023 02:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679910066; x=1711446066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=plUlCrp6bygFf1uDNQYn5ATXNsu29vZxZWaihwKUYV8=;
  b=NW4fyZIgoQLtrxkdKaesH33yz+rgWjO1VZvzyWSYYk3TlAKUMf8eXpt2
   HGWDwCiMaLaHnd34IKcQOOC8rEf/EEQjuIUPQC7geVMEzOReb1b0Gn0to
   RdTbfDQIkUzmdM99+Xr+QaNAdCuK7tKzGFZkDpeVzptHm2X1GjY+5mS5W
   ZCQWAH9cA4u7rheCuqz4NyuE3avAK9L8dt4EKJ/Ti0Gp/qaV+3qPvZNjm
   KUQrXMxDk53CoOPKZfUI5WThD/YBf0CuOio9X/Y2l7/DGvZHTgPsPjeoF
   wHzQGIWG1HKFk+f5UMiq8eZQqzGwXpniduYf6W8ezLse69XmVnCuGP0nx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="426485429"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="426485429"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:41:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="660775829"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="660775829"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 27 Mar 2023 02:41:05 -0700
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
Subject: [PATCH v8 18/24] vfio: Determine noiommu in vfio_device registration
Date:   Mon, 27 Mar 2023 02:40:41 -0700
Message-Id: <20230327094047.47215-19-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327094047.47215-1-yi.l.liu@intel.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
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

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 2 +-
 drivers/vfio/vfio.h      | 6 +++---
 drivers/vfio/vfio_main.c | 2 ++
 include/linux/vfio.h     | 1 +
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 8f09e4541c3a..b0a73d82662e 100644
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
index eb53b1f8c828..805c34c7b0ef 100644
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
index 580cfc5728e8..5c06af04ed9e 100644
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

