Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E586A3F7A78
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240348AbhHYQ1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhHYQ1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:27:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A665C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 09:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=B2DlXrIXOwjG3qvsrzsoZ3t8RaK0K9bTXUFknsUUi5Y=; b=alHIdHRT2/T521mALUtz1yJHdX
        FP6zthpgwCUETfjvV0J7Kq528zNYoNVR+eh0PloOZvjfyGZ5XyQIS+MoAqC4boKjS88RJydUwUXNL
        3rRTWc/X4MYRTqyYe8RngyQeI0EynhiycWY+tBIAWNamIgv57PNULVLhckg9NO9RyEPagpvRbYsc4
        kDiNDIPY+bv3kKtVPHaJ794bHtDJwljI9BN+zgZs6JfPyxcS5oXE99ctsYkjGOxdG/6NQUGYXTUYa
        pBaIe2Gk2aSs7Bx3/bRVjXYM2PjlewcqndgJhoy1w56eVRb8rtzpauOxCY0SU6lN8l6PjOk+1p1in
        obQkQxKw==;
Received: from [2001:4bb8:193:fd10:a3f9:5689:21a4:711f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIvgF-00CT0m-7H; Wed, 25 Aug 2021 16:24:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 02/14] vfio: factor out a vfio_iommu_driver_allowed helper
Date:   Wed, 25 Aug 2021 18:19:03 +0200
Message-Id: <20210825161916.50393-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825161916.50393-1-hch@lst.de>
References: <20210825161916.50393-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out a little helper to make the checks for the noiommu driver less
ugly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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

