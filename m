Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5433F893F
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 15:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242681AbhHZNnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 09:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242505AbhHZNnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 09:43:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A928FC061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 06:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=o2yq1I0CE2cySW6RIxK8EwSBq7/HAENLE5xnuyoKIt8=; b=u34HgMb+nH1wQSUqYuOiivTMH1
        lkKmMVbVmo4pCNTWDNX/0qJtr3q4k/20eg/MyL4QR7LIJ+IQ9jrHsD/kbOlfisG2zv8WiPIJ/qvc0
        dTCPNPp65tqosoJ9vdJeLYPYNxhTYYI2j04aO0fhDl3Il4fqsJDBNx8e+gP54otg+HvEr0JFdiVKB
        afjllwD/lZhsABxVvX7UQQ+p9zguOF9UBGgccO9He8YT+ZwCyurhgEPu+zE77D0M9sGKwGM0BatBl
        /YkVU+RedOY0r6WzNGMZOlA4DbdtcbmZb3a8LB9SHj9NuJawM3ZvK6jTulOYT+NeHn+dit9Pb0YmV
        04sYjTqQ==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJFcl-00DLFS-GL; Thu, 26 Aug 2021 13:41:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 06/14] vfio: remove the iommudata hack for noiommu groups
Date:   Thu, 26 Aug 2021 15:34:16 +0200
Message-Id: <20210826133424.3362-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826133424.3362-1-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just pass a noiommu argument to vfio_create_group and set up the
->noiommu flag directly, and remove the now superflous
vfio_iommu_group_put helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 109d3ef57665b0..94c5e18a05e0d0 100644
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
-	if (iommu_group_get_iommudata(group) == &noiommu)
-		iommu_group_remove_device(dev);
-#endif
+	if (group->noiommu)
+		iommu_group_remove_device(device->dev);
+
 	/* Matches the get in vfio_register_group_dev() */
 	vfio_group_put(group);
 }
-- 
2.30.2

