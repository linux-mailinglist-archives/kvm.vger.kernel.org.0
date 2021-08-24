Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25533F6105
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 16:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbhHXOzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 10:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbhHXOzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 10:55:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09765C061764
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=VMJwnCA5ghcWwuNc4LO4wy73p1rv5tdCMKp/hlLcTbM=; b=azxPkq1DZVU3875sfqnoqYGDGx
        h/+e7GSfivv5fx665b2UvVRnPpz1gpngJa+i6suzJDDMv4EMZOkJGCY1ASsx7SGXzWIOHrlsL+uBP
        DyvlxZHjHaJV8Q2HWqgYp4K28oDUvH5KCtds21lhjdAlR852UYeDOdkinwoY3Mwuu1S1Uq0ZB386Q
        1Zn4B4YiIsA7xeKuA3mR5LNJo0eQXcJid1YJ8EoR4+JfY0SLpHUCJmNodpAihWw7oyC0w95YCt08a
        rceMT9/9yLV8xQZ2eRqxPk/NuZNeHCVN3+Yvll1V6UPTQDC6PXTmNJEkq1OF/nYK9CuXZa2w3RojO
        E7bqpy3w==;
Received: from [2001:4bb8:193:fd10:b8ba:7bad:652e:75fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIXmc-00BCE0-NP; Tue, 24 Aug 2021 14:52:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Date:   Tue, 24 Aug 2021 16:46:39 +0200
Message-Id: <20210824144649.1488190-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824144649.1488190-1-hch@lst.de>
References: <20210824144649.1488190-1-hch@lst.de>
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

