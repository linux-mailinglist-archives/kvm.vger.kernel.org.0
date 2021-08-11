Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05203E9476
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhHKPWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbhHKPWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:22:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA86C061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=o5OoNMAiXhEjfIw0cs+WQxTF9+5ud2bfiI74BNL8YC0=; b=OKSnRNDyCRsCOnX651MKHZEMPe
        rlFv0h1CXqPczY6swu3keF9wFqfHS5DMwF7YZ/YSjlxo/cyBseiRDDjxaFEHgeolsF2JX/Vf8N2TF
        tXKKjgsRLjKFXNs0HHMzk/DXiqjzYSXoJYZpizdCXQitPTcbf/mXkufy1Jq7evy1dP7FzqBXjPtlK
        m84qPAnbARFII0Fy9i5vqi6e09jX2KS4x1WTiyfhFIp2kfqqaESuPKO8yLyACNq6G2GrBMnUIqu2J
        +w9NQSSpuwDmscrJ+Xk+RPv5+ioRlamw3iMQtNC6fkPkol448tbBUbMVKX2edPLfVHre4HA1/AK7n
        iXYqR9+A==;
Received: from [2001:4bb8:184:6215:ac7b:970b:bd9c:c36c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDq2N-00DYa9-3n; Wed, 11 Aug 2021 15:21:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 06/14] vfio: remove the iommudata hack for noiommu groups
Date:   Wed, 11 Aug 2021 17:14:52 +0200
Message-Id: <20210811151500.2744-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811151500.2744-1-hch@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
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
---
 drivers/vfio/vfio.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index d96acd7af50398..964e53c483baac 100644
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
@@ -851,7 +839,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	 */
 	group = vfio_group_get_from_iommu(iommu_group);
 	if (!group) {
-		group = vfio_create_group(iommu_group);
+		group = vfio_create_group(iommu_group, false);
 		if (!IS_ERR(group))
 			return group;
 	}
@@ -881,7 +869,9 @@ int vfio_register_group_dev(struct vfio_device *device)
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(group->iommu_group));
 		vfio_device_put(existing_device);
-		vfio_iommu_group_put(group->iommu_group, device->dev);
+		if (group->noiommu)
+			iommu_group_remove_device(device->dev);
+		iommu_group_put(group->iommu_group);
 		return -EBUSY;
 	}
 
@@ -1026,7 +1016,9 @@ void vfio_unregister_group_dev(struct vfio_device *device)
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

