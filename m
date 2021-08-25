Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CFF3F7A87
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbhHYQaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhHYQaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:30:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E6DC061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 09:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jiGoaZoNlqyor+b80Mnyr3wZw6aKHqGra5GzD3If/Dg=; b=kztYG21Jz8sZDlgCGLPdV2HYay
        ETe8Y2sV5ZKNRHNn3VDf4/qaak26fP/uAs8cZYfkRYMXAkb53r4Wc1BcoF5mDrX+UB/CXFtTq3jf+
        wjUWeH/GQd28Wti5P7i0YzTGoOGTuECYd/ApxYA7jLh5cki+Ti3cs4Vu6mjH9ek8hBEDOwCzap6Yx
        Zcmu3y+R/1lLR2K17VJI0h4c0A4/cOHzdoWEBPs4tU9R1cE+y27EcD9XuiCaBCaE3XoSj3UWhCeY4
        V90lkQPMhy/rqY9gVp7HDj9ZxJor08wyM1f4+EpkFXZ4lcTUdkkQYdhEuINoa+e5hayz2bBaIAGDJ
        LvrXOO6A==;
Received: from [2001:4bb8:193:fd10:a3f9:5689:21a4:711f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIvlR-00CTTr-RX; Wed, 25 Aug 2021 16:28:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 06/14] vfio: remove the iommudata hack for noiommu groups
Date:   Wed, 25 Aug 2021 18:19:07 +0200
Message-Id: <20210825161916.50393-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825161916.50393-1-hch@lst.de>
References: <20210825161916.50393-1-hch@lst.de>
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
---
 drivers/vfio/vfio.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index d440828505d9d7..71e0d3c4f1ac08 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -169,16 +169,6 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
-static void vfio_iommu_group_put(struct iommu_group *group, struct device *dev)
-{
-#ifdef CONFIG_VFIO_NOIOMMU
-	if (iommu_group_get_iommudata(group) == &noiommu)
-		iommu_group_remove_device(dev);
-#endif
-
-	iommu_group_put(group);
-}
-
 #ifdef CONFIG_VFIO_NOIOMMU
 static void *vfio_noiommu_open(unsigned long arg)
 {
@@ -345,7 +335,8 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
 /**
  * Group objects - create, release, get, put, search
  */
-static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
+static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
+		bool noiommu)
 {
 	struct vfio_group *group, *tmp;
 	struct device *dev;
@@ -364,9 +355,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
 	atomic_set(&group->opened, 0);
 	init_waitqueue_head(&group->container_q);
 	group->iommu_group = iommu_group;
-#ifdef CONFIG_VFIO_NOIOMMU
-	group->noiommu = (iommu_group_get_iommudata(iommu_group) == &noiommu);
-#endif
+	group->noiommu = noiommu;
 	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
 
 	group->nb.notifier_call = vfio_iommu_group_notifier;
@@ -801,12 +790,11 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
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
@@ -853,7 +841,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		goto out_put;
 
 	/* a newly created vfio_group keeps the reference. */
-	group = vfio_create_group(iommu_group);
+	group = vfio_create_group(iommu_group, false);
 	if (IS_ERR(group))
 		goto out_put;
 	return group;
@@ -884,7 +872,9 @@ int vfio_register_group_dev(struct vfio_device *device)
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(group->iommu_group));
 		vfio_device_put(existing_device);
-		vfio_iommu_group_put(group->iommu_group, device->dev);
+		if (group->noiommu)
+			iommu_group_remove_device(device->dev);
+		iommu_group_put(group->iommu_group);
 		return -EBUSY;
 	}
 
@@ -1029,7 +1019,9 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
-	vfio_iommu_group_put(group->iommu_group, device->dev);
+	if (group->noiommu)
+		iommu_group_remove_device(device->dev);
+	iommu_group_put(group->iommu_group);
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
-- 
2.30.2

