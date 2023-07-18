Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BF7757EC2
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 15:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjGRN6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 09:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbjGRN6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 09:58:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD89AC;
        Tue, 18 Jul 2023 06:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688697; x=1721224697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9oSzt+Qjxbm5o8hEt23r35NFXF06gcMZujcuINafNKM=;
  b=mCmXQ93ZA/pkYYhc/Se0qLslUJI820lT2Zh1hZNTxQEEcucxaWzIxDRa
   HCtfGSELUnIkdIj1ZTvb7/pCOQ97z8N7gSy/NKqdEmHYgVC9WVpttIT8u
   DhnAEW/S8TMirAfVQirT/9+nMiN4+HMgErwu/jfPMRM5wnV8tlERs9N40
   W3SbRjUJ3JPcMECefJ1fEcjRTRoEh9SGgv3P4sA8sTgogLqNgzzqnqIh0
   ATYJW/95OUvZJoRMEg9vE3hvODc8IFl1APqS3u0hOQF/Dg/kHavbz8ic7
   MpqenAti4Vc5yHaTfl+6bLvA0dUfm7QYqszPckh2a8HnLDihfcfyJ95PR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="452590846"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452590846"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:56:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="970251163"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="970251163"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jul 2023 06:56:13 -0700
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
Subject: [PATCH v15 24/26] vfio: Move the IOMMU_CAP_CACHE_COHERENCY check in __vfio_register_dev()
Date:   Tue, 18 Jul 2023 06:55:49 -0700
Message-Id: <20230718135551.6592-25-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230718135551.6592-1-yi.l.liu@intel.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The IOMMU_CAP_CACHE_COHERENCY check only applies to the physical devices
that are IOMMU-backed. But it is now in the group code. If want to compile
vfio_group infrastructure out, this check needs to be moved out of the group
code.

Another reason for this change is to fail the device registration for the
physical devices that do not have IOMMU if the group code is not compiled
as the cdev interface does not support such devices.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 10 ----------
 drivers/vfio/vfio_main.c | 11 +++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 5c17ad812313..610a429c6191 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -682,16 +682,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	if (!iommu_group)
 		return ERR_PTR(-EINVAL);
 
-	/*
-	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
-	 * restore cache coherency. It has to be checked here because it is only
-	 * valid for cases where we are using iommu groups.
-	 */
-	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY)) {
-		iommu_group_put(iommu_group);
-		return ERR_PTR(-EINVAL);
-	}
-
 	mutex_lock(&vfio.group_lock);
 	group = vfio_group_find_from_iommu(iommu_group);
 	if (group) {
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index ba1d84afe081..902f06e52c48 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -292,6 +292,17 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (ret)
 		return ret;
 
+	/*
+	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
+	 * restore cache coherency. It has to be checked here because it is only
+	 * valid for cases where we are using iommu groups.
+	 */
+	if (type == VFIO_IOMMU && !vfio_device_is_noiommu(device) &&
+	    !device_iommu_capable(device->dev, IOMMU_CAP_CACHE_COHERENCY)) {
+		ret = -EINVAL;
+		goto err_out;
+	}
+
 	ret = vfio_device_add(device);
 	if (ret)
 		goto err_out;
-- 
2.34.1

