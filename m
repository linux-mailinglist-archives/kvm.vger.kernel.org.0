Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D3C41781D
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347228AbhIXQEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347183AbhIXQEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 12:04:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8066C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=39/hMqhFw0hNnHcm9fCIsVGJ2ndOz35Pg/IFWHK8o/0=; b=PauiKfI6zywOipuoOAHrnYFETW
        3MlFSDow3O4ovNIUuZq+AxMIOMeQsODeBI3x79SFLWAuVgQbav7iUk5/zL5tcXZSYNI2VaIFkSEjd
        4qmFKPGB/qWQcRpcZ8pqoAoBD/myDDEpl+ls5xZpGVEQGuaIMdexUsN/4byoxVlZ63VsKZpXqvRc3
        gMosQqtH7wGYtT8Aj5W+9JZyu7yudh2Bii2vtayNQRjtDOZTu98GUEGAyWsvTmdEDJBeQxpsmPBWF
        Dhye9TNhhu1Tf9a82zc3u9tsZPQX5avj537Z2DX9mGphIKa++dbAqzPrpRLyvIXhoJkjqtISwiHsb
        3q6DE9lg==;
Received: from [2001:4bb8:184:72db:e8f6:c47e:192b:5622] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTncY-007N4M-L4; Fri, 24 Sep 2021 16:00:35 +0000
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
Subject: [PATCH 04/15] vfio: factor out a vfio_group_find_or_alloc helper
Date:   Fri, 24 Sep 2021 17:56:54 +0200
Message-Id: <20210924155705.4258-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924155705.4258-1-hch@lst.de>
References: <20210924155705.4258-1-hch@lst.de>
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio.c | 60 ++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 8bd4b0b96b94a3..2b2679c7126fdf 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -823,10 +823,39 @@ void vfio_uninit_group_dev(struct vfio_device *device)
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
+		goto out_remove;
+	return group;
+
+out_remove:
+#ifdef CONFIG_VFIO_NOIOMMU
+	if (iommu_group_get_iommudata(iommu_group) == &noiommu)
+		iommu_group_remove_device(dev);
+#endif
+out_put:
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
@@ -836,36 +865,17 @@ int vfio_register_group_dev(struct vfio_device *device)
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

