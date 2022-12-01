Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B7E63F332
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiLAOzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiLAOzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7802DBB7EF
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906539; x=1701442539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YJ2qsUTGwm0Dnzm5K+vRHn8A4CYt3JBgl4xvQYbTveU=;
  b=gBfxBouriF+ees847obA+U6kXi3SJzwn4bO83Rj8B1bmooTW9sEyZTrT
   C71peiD/+RgHAzDXWLRx6TV1aG7SfNzgURAiJxMjpkJN6cGLosZzQAPSA
   Uu0bcfQ5qz2E/PA2TihJJ4A1ijDRfWxfqodGA1KZpWEzolXkA4uZz9smB
   ZVLM6hyxxBwZz1FPc7WaZioyeVL5AuNxTPPjThvrdTk61bbHJSp9KzSmc
   8nQV002TfKZUS0NUqWlK4PLb0FtSo6xMoiUg13oqjgBW8Fuv3HUI4KgRu
   qku3ETNJA7FndnpPtq9OiONWAmmaZ5HmzLdsD7Xxmqf2omquyJUxiyjnj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569282"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569282"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095144"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095144"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:38 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 01/10] vfio: Simplify vfio_create_group()
Date:   Thu,  1 Dec 2022 06:55:26 -0800
Message-Id: <20221201145535.589687-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201145535.589687-1-yi.l.liu@intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index c1c78858b45e..0e66eb40992b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -130,10 +130,12 @@ static void vfio_release_device_set(struct vfio_device *device)
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
@@ -147,17 +149,6 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
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
@@ -212,6 +203,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	struct vfio_group *ret;
 	int err;
 
+	lockdep_assert_held(&vfio.group_lock);
+
 	group = vfio_group_alloc(iommu_group, type);
 	if (IS_ERR(group))
 		return group;
@@ -224,26 +217,16 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
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
@@ -440,7 +423,9 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
 	if (ret)
 		goto out_put_group;
 
+	mutex_lock(&vfio.group_lock);
 	group = vfio_create_group(iommu_group, type);
+	mutex_unlock(&vfio.group_lock);
 	if (IS_ERR(group)) {
 		ret = PTR_ERR(group);
 		goto out_remove_device;
@@ -489,9 +474,11 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
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

