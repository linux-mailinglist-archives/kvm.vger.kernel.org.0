Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1997417827
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347296AbhIXQGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347149AbhIXQGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 12:06:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DED2C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=pZLv37WaFYBql3ZgqAmcO7EYXKF8vGWW/iSJBc6Ut9c=; b=COk8KnQ/fpcl/jGh9NGM+Pe2Vg
        79DHubSDjsSFNRzZzl5NxFmiaN/FXKxacGX/rYKshijs62nQ8PuOEiWal8OzWWfMJQjtHfG8hHoia
        EYFDWZhF/Jk7wh906OYY3shPlUt9ca+L+XL9qTmqzLHxh/FKXJPWkY4zKpmllR3vfyfR6TZG+kBwP
        wCWflt/AGv4KJiE2AWmPo9S2fDtWN/H71BuWSJZybU2bnw66xcDANArfyO13Ot3vqVxqxzg8cAYAO
        i5mfrNuBB05mR/3ICQYCfpCfsskU84gLUhngjBdiucp5TB6lEyAnkRb+IYpNoZrXG5rlSZhPQr+pz
        HlN2TAlg==;
Received: from [2001:4bb8:184:72db:e8f6:c47e:192b:5622] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTnfB-007NBd-EX; Fri, 24 Sep 2021 16:03:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 06/15] vfio: remove the iommudata hack for noiommu groups
Date:   Fri, 24 Sep 2021 17:56:56 +0200
Message-Id: <20210924155705.4258-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924155705.4258-1-hch@lst.de>
References: <20210924155705.4258-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just pass a noiommu argument to vfio_create_group and set up the
->noiommu flag directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index b1ed156adccd04..23eaebd2e28cd9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -335,7 +335,8 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
 /**
  * Group objects - create, release, get, put, search
  */
-static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
+static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
+		bool noiommu)
 {
 	struct vfio_group *group, *tmp;
 	struct device *dev;
@@ -354,9 +355,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
 	atomic_set(&group->opened, 0);
 	init_waitqueue_head(&group->container_q);
 	group->iommu_group = iommu_group;
-#ifdef CONFIG_VFIO_NOIOMMU
-	group->noiommu = (iommu_group_get_iommudata(iommu_group) == &noiommu);
-#endif
+	group->noiommu = noiommu;
 	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
 
 	group->nb.notifier_call = vfio_iommu_group_notifier;
@@ -791,12 +790,11 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
 		return ERR_CAST(iommu_group);
 
 	iommu_group_set_name(iommu_group, "vfio-noiommu");
-	iommu_group_set_iommudata(iommu_group, &noiommu, NULL);
 	ret = iommu_group_add_device(iommu_group, dev);
 	if (ret)
 		goto out_put_group;
 
-	group = vfio_create_group(iommu_group);
+	group = vfio_create_group(iommu_group, true);
 	if (IS_ERR(group)) {
 		ret = PTR_ERR(group);
 		goto out_remove_device;
@@ -843,7 +841,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		goto out_put;
 
 	/* a newly created vfio_group keeps the reference. */
-	group = vfio_create_group(iommu_group);
+	group = vfio_create_group(iommu_group, false);
 	if (IS_ERR(group))
 		goto out_put;
 	return group;
@@ -874,10 +872,8 @@ int vfio_register_group_dev(struct vfio_device *device)
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(group->iommu_group));
 		vfio_device_put(existing_device);
-#ifdef CONFIG_VFIO_NOIOMMU
-		if (iommu_group_get_iommudata(group->iommu_group) == &noiommu)
+		if (group->noiommu)
 			iommu_group_remove_device(device->dev);
-#endif
 		vfio_group_put(group);
 		return -EBUSY;
 	}
@@ -1023,10 +1019,9 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
-#ifdef CONFIG_VFIO_NOIOMMU
-	if (iommu_group_get_iommudata(group->iommu_group) == &noiommu)
+	if (group->noiommu)
 		iommu_group_remove_device(device->dev);
-#endif
+
 	/* Matches the get in vfio_register_group_dev() */
 	vfio_group_put(group);
 }
-- 
2.30.2

