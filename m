Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4E46378D8
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiKXM11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiKXM1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A887E0C81
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292834; x=1700828834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pPlKJCEHhhMAMBspQlQOEvjgZ8G7Qavh/9z2U83rdlg=;
  b=PaDzkJRQSuoOsbIvP3M7E4nqIbQpPb/4C+2LWFgwtPfpQpPqNOBXysCz
   1ON0epHmWGS/vH7JKbnN26fqk4+qROeCWBKptyqe6gEYgqifi61Fz4wmU
   p4sQsaO1XLLiNyGR6Lzsb5AohOe6aiU2NHyVLHrVWjeEeGQo1sGdv1i+A
   bJdl0anRLwp2nfKV2KNB7pDtyjMGUZV3tc2XR2b1gnBwNOFhTXX/HmLxq
   abhNrYVR7SlYj1JvUFqbPTs+Oepg7GOVp9aU2q+YFjeCUoStjFNu8HrWP
   wdC4b6tgRd6owfJTylTo97+16YS2iIHCqfzYeBpTYLkRwlIMNWlZNhUDp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649628"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649628"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337149"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337149"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:13 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 01/11] vfio: Simplify vfio_create_group()
Date:   Thu, 24 Nov 2022 04:26:52 -0800
Message-Id: <20221124122702.26507-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124122702.26507-1-yi.l.liu@intel.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The vfio.group_lock is now only used to serialize vfio_group creation
and destruction, we don't need a micro-optimization of searching,
unlocking, then allocating and searching again. Just hold the lock
the whole time.

Grabbed from:
https://lore.kernel.org/kvm/20220922152338.2a2238fe.alex.williamson@redhat.com/

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index b233805ff645..5388a11ed496 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -146,10 +146,12 @@ EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
  * Group objects - create, release, get, put, search
  */
 static struct vfio_group *
-__vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+vfio_group_get_from_iommu(struct iommu_group *iommu_group)
 {
 	struct vfio_group *group;
 
+	lockdep_assert_held(&vfio.group_lock);
+
 	/*
 	 * group->iommu_group from the vfio.group_list cannot be NULL
 	 * under the vfio.group_lock.
@@ -163,17 +165,6 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
 	return NULL;
 }
 
-static struct vfio_group *
-vfio_group_get_from_iommu(struct iommu_group *iommu_group)
-{
-	struct vfio_group *group;
-
-	mutex_lock(&vfio.group_lock);
-	group = __vfio_group_get_from_iommu(iommu_group);
-	mutex_unlock(&vfio.group_lock);
-	return group;
-}
-
 static void vfio_group_release(struct device *dev)
 {
 	struct vfio_group *group = container_of(dev, struct vfio_group, dev);
@@ -228,6 +219,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	struct vfio_group *ret;
 	int err;
 
+	lockdep_assert_held(&vfio.group_lock);
+
 	group = vfio_group_alloc(iommu_group, type);
 	if (IS_ERR(group))
 		return group;
@@ -240,26 +233,16 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 		goto err_put;
 	}
 
-	mutex_lock(&vfio.group_lock);
-
-	/* Did we race creating this group? */
-	ret = __vfio_group_get_from_iommu(iommu_group);
-	if (ret)
-		goto err_unlock;
-
 	err = cdev_device_add(&group->cdev, &group->dev);
 	if (err) {
 		ret = ERR_PTR(err);
-		goto err_unlock;
+		goto err_put;
 	}
 
 	list_add(&group->vfio_next, &vfio.group_list);
 
-	mutex_unlock(&vfio.group_lock);
 	return group;
 
-err_unlock:
-	mutex_unlock(&vfio.group_lock);
 err_put:
 	put_device(&group->dev);
 	return ret;
@@ -456,7 +439,9 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
 	if (ret)
 		goto out_put_group;
 
+	mutex_lock(&vfio.group_lock);
 	group = vfio_create_group(iommu_group, type);
+	mutex_unlock(&vfio.group_lock);
 	if (IS_ERR(group)) {
 		ret = PTR_ERR(group);
 		goto out_remove_device;
@@ -505,9 +490,11 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		return ERR_PTR(-EINVAL);
 	}
 
+	mutex_lock(&vfio.group_lock);
 	group = vfio_group_get_from_iommu(iommu_group);
 	if (!group)
 		group = vfio_create_group(iommu_group, VFIO_IOMMU);
+	mutex_unlock(&vfio.group_lock);
 
 	/* The vfio_group holds a reference to the iommu_group */
 	iommu_group_put(iommu_group);
-- 
2.34.1

