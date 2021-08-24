Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7225B3F60F4
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 16:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbhHXOwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 10:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237816AbhHXOwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 10:52:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2737EC061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=LyUBN9MHd9i/7GZXYBXpNHABFtz/7oOM8g7Qa97ahgg=; b=ubwJbhuTdnTqKxoVlQGcrYs73W
        Q+5qOAzRgQJZBlNIhKLAW97rDDTrRq7A/+FpFb8qeWYNPe3nFgEbFzcSHqMvnCSb6t4Xqo6vBv0Cb
        zaY6TcRoKs7tH+ZGTOgEEympQGb4eFaP2o9DIDmE0cdH1rGBhXaT8VnJd6KVg8K31XToy/F2qSUOE
        8wzdyiAa9yLfW3956uGaoo0RqE25SrnTVdqytGhhslZsxN3E6ooI3366j09R47QdObRmk5Ex/63nj
        wGH0tj7YHcVCgRxaY46QYiN5DqaP/sZcs1i7Drg6N8tSPhFDcNynKIPNSqZtmJa+9rnrYHn/QrBLb
        4YMKwQaA==;
Received: from [2001:4bb8:193:fd10:b8ba:7bad:652e:75fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIXka-00BC94-W7; Tue, 24 Aug 2021 14:50:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 02/14] vfio: factor out a vfio_iommu_driver_allowed helper
Date:   Tue, 24 Aug 2021 16:46:37 +0200
Message-Id: <20210824144649.1488190-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824144649.1488190-1-hch@lst.de>
References: <20210824144649.1488190-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out a little helper to make the checks for the noiommu driver less
ugly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 5bd520f0dc6107..6705349ed93378 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -267,8 +267,23 @@ static const struct vfio_iommu_driver_ops vfio_noiommu_ops = {
 	.attach_group = vfio_noiommu_attach_group,
 	.detach_group = vfio_noiommu_detach_group,
 };
-#endif
 
+/*
+ * Only noiommu containers can use vfio-noiommu and noiommu containers can only
+ * use vfio-noiommu.
+ */
+static inline bool vfio_iommu_driver_allowed(struct vfio_container *container,
+		const struct vfio_iommu_driver *driver)
+{
+	return container->noiommu == (driver->ops == &vfio_noiommu_ops);
+}
+#else
+static inline bool vfio_iommu_driver_allowed(struct vfio_container *container,
+		const struct vfio_iommu_driver *driver)
+{
+	return true;
+}
+#endif /* CONFIG_VFIO_NOIOMMU */
 
 /**
  * IOMMU driver registration
@@ -1031,13 +1046,10 @@ static long vfio_ioctl_check_extension(struct vfio_container *container,
 			list_for_each_entry(driver, &vfio.iommu_drivers_list,
 					    vfio_next) {
 
-#ifdef CONFIG_VFIO_NOIOMMU
 				if (!list_empty(&container->group_list) &&
-				    (container->noiommu !=
-				     (driver->ops == &vfio_noiommu_ops)))
+				    !vfio_iommu_driver_allowed(container,
+							       driver))
 					continue;
-#endif
-
 				if (!try_module_get(driver->ops->owner))
 					continue;
 
@@ -1109,15 +1121,8 @@ static long vfio_ioctl_set_iommu(struct vfio_container *container,
 	list_for_each_entry(driver, &vfio.iommu_drivers_list, vfio_next) {
 		void *data;
 
-#ifdef CONFIG_VFIO_NOIOMMU
-		/*
-		 * Only noiommu containers can use vfio-noiommu and noiommu
-		 * containers can only use vfio-noiommu.
-		 */
-		if (container->noiommu != (driver->ops == &vfio_noiommu_ops))
+		if (!vfio_iommu_driver_allowed(container, driver))
 			continue;
-#endif
-
 		if (!try_module_get(driver->ops->owner))
 			continue;
 
-- 
2.30.2

