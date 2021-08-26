Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060F93F892E
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 15:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbhHZNlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 09:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242681AbhHZNlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 09:41:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C606C0613C1
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 06:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wbQ0tQTp/hqLaCjQ4F1Xqzgarh8YawHi7exDeqiqN/Y=; b=Gphhx/dzw2vWPDCDL1J27iLHdY
        J0IUl2uyFLr3qBdiaJ15cATH8jVyhZfIKed3xXjy5fnOpFbuEUNMbw2G6PeQeTGh4fusjfGgUz3xb
        VlYNIvaow/AQKQEnOw2Wjg+gLB68iOPaq9rshH7h/Kmd1HKZpHTM30Ls0Iyc/Rsw5gT9PBy+KPuOt
        8PKe295zeT8zs/lwS0lk9XMIXszfWxMk+kb9QBNwg1x70jJpvk8Yq/LksbdQystOe3XY7+Gt1lqMJ
        9z4S2D7HxUm2Yf/HhzY8to6qOS+70slJUrhJ1+hhJrdiRBCGVOijvVU2w81zO/TRvL/LclCPH5/be
        QoS8Gb2Q==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJFa6-00DL5a-DL; Thu, 26 Aug 2021 13:38:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Date:   Thu, 26 Aug 2021 15:34:14 +0200
Message-Id: <20210826133424.3362-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826133424.3362-1-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out a helper to find or allocate the vfio_group to reduce the
spagetthi code in vfio_register_group_dev a little.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 59 ++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 18e4c7906d1b3f..852fe22125520d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -823,10 +823,38 @@ void vfio_uninit_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
 
+struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
+{
+	struct iommu_group *iommu_group;
+	struct vfio_group *group;
+
+	iommu_group = vfio_iommu_group_get(dev);
+	if (!iommu_group)
+		return ERR_PTR(-EINVAL);
+
+	/* a found vfio_group already holds a reference to the iommu_group */
+	group = vfio_group_get_from_iommu(iommu_group);
+	if (group)
+		goto out_put;
+
+	/* a newly created vfio_group keeps the reference. */
+	group = vfio_create_group(iommu_group);
+	if (IS_ERR(group))
+		goto out_put;
+	return group;
+
+out_put:
+#ifdef CONFIG_VFIO_NOIOMMU
+	if (iommu_group_get_iommudata(iommu_group) == &noiommu)
+		iommu_group_remove_device(dev);
+#endif
+	iommu_group_put(iommu_group);
+	return group;
+}
+
 int vfio_register_group_dev(struct vfio_device *device)
 {
 	struct vfio_device *existing_device;
-	struct iommu_group *iommu_group;
 	struct vfio_group *group;
 
 	/*
@@ -836,36 +864,17 @@ int vfio_register_group_dev(struct vfio_device *device)
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	iommu_group = vfio_iommu_group_get(device->dev);
-	if (!iommu_group)
-		return -EINVAL;
-
-	group = vfio_group_get_from_iommu(iommu_group);
-	if (!group) {
-		group = vfio_create_group(iommu_group);
-		if (IS_ERR(group)) {
-#ifdef CONFIG_VFIO_NOIOMMU
-			if (iommu_group_get_iommudata(iommu_group) == &noiommu)
-				iommu_group_remove_device(device->dev);
-#endif
-			iommu_group_put(iommu_group);
-			return PTR_ERR(group);
-		}
-	} else {
-		/*
-		 * A found vfio_group already holds a reference to the
-		 * iommu_group.  A created vfio_group keeps the reference.
-		 */
-		iommu_group_put(iommu_group);
-	}
+	group = vfio_group_find_or_alloc(device->dev);
+	if (IS_ERR(group))
+		return PTR_ERR(group);
 
 	existing_device = vfio_group_get_device(group, device->dev);
 	if (existing_device) {
 		dev_WARN(device->dev, "Device already exists on group %d\n",
-			 iommu_group_id(iommu_group));
+			 iommu_group_id(group->iommu_group));
 		vfio_device_put(existing_device);
 #ifdef CONFIG_VFIO_NOIOMMU
-		if (iommu_group_get_iommudata(iommu_group) == &noiommu)
+		if (iommu_group_get_iommudata(group->iommu_group) == &noiommu)
 			iommu_group_remove_device(device->dev);
 #endif
 		vfio_group_put(group);
-- 
2.30.2

