Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C913E9472
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhHKPVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhHKPVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:21:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87352C061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=VMJwnCA5ghcWwuNc4LO4wy73p1rv5tdCMKp/hlLcTbM=; b=UezVsvu+LKV2EMCW+kB3l2Co4W
        pUJwL6dRuJzx30iPL4EIP61CCwCthvOCvKcrDCXz8+nX3DX3FUoNficqcFyD+RGJ0+CLvYWnQ8HVo
        uZ6bOTYFepWE2WD9D0B+sgx0Ydnp8NZHjdxjKvS0JNXCyM0t75Kdz4AqYOZOm48p+oz6Dnwe7UE87
        dPyX78QBvoVbaHKg/bjjAZQUt9Sdw/qD/Km0Bi6xwKWJt6FUfoUXaVUmid09yC6nj83s00oM0goIT
        IQdQIumGJJX7M08R5fVYzwxn0QgTva4uBjd1ogmCyqQAg+CH+IqW1x8Sa11f3a60XpSOdnS5Ko8oo
        74dSjp1A==;
Received: from [2001:4bb8:184:6215:ac7b:970b:bd9c:c36c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDq0N-00DYR4-6e; Wed, 11 Aug 2021 15:19:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Date:   Wed, 11 Aug 2021 17:14:50 +0200
Message-Id: <20210811151500.2744-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811151500.2744-1-hch@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out a helper to find or allocate the vfio_group to reduce the
spagetthi code in vfio_register_group_dev a little.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio.c | 49 ++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 00aeef5bb29abd..9e97ad36a1c052 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -833,10 +833,32 @@ void vfio_uninit_group_dev(struct vfio_device *device)
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
+	/*
+	 * A found vfio_group already holds a reference to the iommu_group.
+	 * A created vfio_group keeps the reference.
+	 */
+	group = vfio_group_get_from_iommu(iommu_group);
+	if (!group) {
+		group = vfio_create_group(iommu_group);
+		if (!IS_ERR(group))
+			return group;
+	}
+	vfio_iommu_group_put(iommu_group, dev);
+	return group;
+}
+
 int vfio_register_group_dev(struct vfio_device *device)
 {
 	struct vfio_device *existing_device;
-	struct iommu_group *iommu_group;
 	struct vfio_group *group;
 
 	/*
@@ -846,31 +868,16 @@ int vfio_register_group_dev(struct vfio_device *device)
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
-			vfio_iommu_group_put(iommu_group, device->dev);
-			return PTR_ERR(group);
-		}
-	} else {
-		/*
-		 * A found vfio_group already holds a reference to the
-		 * iommu_group.  A created vfio_group keeps the reference.
-		 */
-		vfio_iommu_group_put(iommu_group, device->dev);
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
-		vfio_iommu_group_put(iommu_group, device->dev);
+		vfio_iommu_group_put(group->iommu_group, device->dev);
 		return -EBUSY;
 	}
 
-- 
2.30.2

