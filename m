Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DB03E9474
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhHKPVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbhHKPVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:21:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91152C061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=s2rdxn/8estbMnmyebaLF3YyeZqhNh6FBJnJn0Ezlno=; b=tvtfN07uA/3gC6zJXpiDCsncDS
        fAdghfEw/dQjcS71PGZlhWV0e6VEaed210DQkVxmXfFVnrTG77XclbmLFNzDYL5sC4sijqLIO7Hn2
        yVlLn0WOan85EdG2FFvquTcOsLTsxMFQ9fm66vpZoNVlGZA0pP5fnwYEJxJ3stR9HTf87uhNPJldq
        RlHuJIJ3qv4GSeN9JJWKW1mWfycpvzGJ3EM1VBgVsLgecfNYHzYV1Z1jyCB5ikMtZWuIB0y9pyveK
        ZbeNCbfaGx8ejmdFRhIO4FAIsemrIQ/iEw54fw9q8+JKXQ2MReo4RAsaIJgNyUA+f8AkWD5OQWx11
        lqygfUqQ==;
Received: from [2001:4bb8:184:6215:ac7b:970b:bd9c:c36c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDq1a-00DYWP-Fh; Wed, 11 Aug 2021 15:20:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 05/14] vfio: refactor noiommu group creation
Date:   Wed, 11 Aug 2021 17:14:51 +0200
Message-Id: <20210811151500.2744-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811151500.2744-1-hch@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the actual noiommu group creation from vfio_iommu_group_get into a
new helper, and open code the rest of vfio_iommu_group_get in its only
caller.  This creates an antirely separate and clear code path for the
noiommu group creation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio.c | 100 +++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 48 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 9e97ad36a1c052..d96acd7af50398 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -169,50 +169,6 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
-static struct iommu_group *vfio_iommu_group_get(struct device *dev)
-{
-	struct iommu_group *group;
-	int __maybe_unused ret;
-
-	group = iommu_group_get(dev);
-
-#ifdef CONFIG_VFIO_NOIOMMU
-	/*
-	 * With noiommu enabled, an IOMMU group will be created for a device
-	 * that doesn't already have one and doesn't have an iommu_ops on their
-	 * bus.  We set iommudata simply to be able to identify these groups
-	 * as special use and for reclamation later.
-	 */
-	if (group || !noiommu || iommu_present(dev->bus))
-		return group;
-
-	group = iommu_group_alloc();
-	if (IS_ERR(group))
-		return NULL;
-
-	iommu_group_set_name(group, "vfio-noiommu");
-	iommu_group_set_iommudata(group, &noiommu, NULL);
-	ret = iommu_group_add_device(group, dev);
-	if (ret) {
-		iommu_group_put(group);
-		return NULL;
-	}
-
-	/*
-	 * Where to taint?  At this point we've added an IOMMU group for a
-	 * device that is not backed by iommu_ops, therefore any iommu_
-	 * callback using iommu_ops can legitimately Oops.  So, while we may
-	 * be about to give a DMA capable device to a user without IOMMU
-	 * protection, which is clearly taint-worthy, let's go ahead and do
-	 * it here.
-	 */
-	add_taint(TAINT_USER, LOCKDEP_STILL_OK);
-	dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
-#endif
-
-	return group;
-}
-
 static void vfio_iommu_group_put(struct iommu_group *group, struct device *dev)
 {
 #ifdef CONFIG_VFIO_NOIOMMU
@@ -833,14 +789,61 @@ void vfio_uninit_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
 
-struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
+#ifdef CONFIG_VFIO_NOIOMMU
+static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
 {
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
+	int ret;
 
-	iommu_group = vfio_iommu_group_get(dev);
-	if (!iommu_group)
+	iommu_group = iommu_group_alloc();
+	if (IS_ERR(iommu_group))
+		return ERR_CAST(iommu_group);
+
+	iommu_group_set_name(iommu_group, "vfio-noiommu");
+	iommu_group_set_iommudata(iommu_group, &noiommu, NULL);
+	ret = iommu_group_add_device(iommu_group, dev);
+	if (ret)
+		goto out_put_group;
+
+	group = vfio_create_group(iommu_group);
+	if (IS_ERR(group)) {
+		ret = PTR_ERR(group);
+		goto out_remove_device;
+	}
+
+	return group;
+
+out_remove_device:
+	iommu_group_remove_device(dev);
+out_put_group:
+	iommu_group_put(iommu_group);
+	return ERR_PTR(ret);
+}
+#endif
+
+static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
+{
+	struct iommu_group *iommu_group;
+	struct vfio_group *group;
+
+	iommu_group = iommu_group_get(dev);
+	if (!iommu_group) {
+#ifdef CONFIG_VFIO_NOIOMMU
+		/*
+		 * With noiommu enabled, create an IOMMU group for devices that
+		 * don't already have one and don't have an iommu_ops on their
+		 * bus.  Taint the kernel because we're about to give a DMA
+		 * capable device to a user without IOMMU protection.
+		 */
+		if (noiommu && !iommu_present(dev->bus)) {
+			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
+			return vfio_noiommu_group_alloc(dev);
+		}
+#endif
 		return ERR_PTR(-EINVAL);
+	}
 
 	/*
 	 * A found vfio_group already holds a reference to the iommu_group.
@@ -852,7 +855,8 @@ struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		if (!IS_ERR(group))
 			return group;
 	}
-	vfio_iommu_group_put(iommu_group, dev);
+
+	iommu_group_put(iommu_group);
 	return group;
 }
 
-- 
2.30.2

