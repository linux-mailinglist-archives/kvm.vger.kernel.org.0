Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B398F3F891A
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 15:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242691AbhHZNi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 09:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241385AbhHZNiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 09:38:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E756C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 06:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vweiZh77d6HbzrcxiqPv9iaxIdW7lH4OOzT9ZJhkw1U=; b=rhBpAY+6d4GbzCnyIUYINvPnSV
        HPfUgQ+hCDPCRU9swdkVRnAMapzUDMQOoSjGzorwXx4mD+NCTqaG0MI+qHHMT+swJQHYWDNADzQYn
        TS7QtuL2YNtnFDOZm+RjgCbsn4V9+944IFg5Yp1nV1n+xgZvWfxu8LKHr9SCSBtLwcKQGz7F0Ob3Q
        /w+95c1Q/sKNfRBmszxfhC6/mqMASVFzZUfldMHGRr6chxAg7hUcqVrCSLS65DSMjRb3aDCYmCIEO
        Y1zdjO84l7rxwZLzgJqqOGP8FiGIePgMxTOHtHi1ZVZZWMuWKxU0A22rwjT/XvMz4bz8P5WOY/3AI
        Kkg7b5YA==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJFY5-00DKzG-Sc; Thu, 26 Aug 2021 13:36:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 02/14] vfio: factor out a vfio_iommu_driver_allowed helper
Date:   Thu, 26 Aug 2021 15:34:12 +0200
Message-Id: <20210826133424.3362-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826133424.3362-1-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index b39da9b90c95bc..e53756743f1b6a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -257,8 +257,23 @@ static const struct vfio_iommu_driver_ops vfio_noiommu_ops = {
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
@@ -1034,13 +1049,10 @@ static long vfio_ioctl_check_extension(struct vfio_container *container,
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
 
@@ -1112,15 +1124,8 @@ static long vfio_ioctl_set_iommu(struct vfio_container *container,
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

