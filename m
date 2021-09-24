Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBF1417816
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347238AbhIXQBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347225AbhIXQBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 12:01:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8880FC061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=52ooz06KjZqmIu8LpeH/ttC+7rUF9vGr+m1tKceNbDs=; b=pn7tsMdeuYkaM7oD3RpbP6qS/J
        Oj+o5nzz6T/HTmfbLDpfYJuZO4xGtVUThlTpWxzZhmNIjo66lb6Iyq44JHOfh9JFD5Y29LCfvz4Fv
        lWQMei2BAFBG5VjUsR25Oih2ydDCRO/3rE325RY9m2U6WSomLsA71sprSq5UUISXlDSwemOZrssCT
        JAyTfcpazKBrxu8ZBl4uaT7x9r1Yz28SSVUeIQuVvTIwjH7CO3Q8T+oU1moNbJyKaJFQmGEC+meqk
        a2Jar/fcrDXRD8WJaLA3OqbYKojymRGTF6ZBsg60Th8URS8wTluUEOWS9t6rShcWGxqjy9KGiYU3e
        PLCBkRDQ==;
Received: from [2001:4bb8:184:72db:e8f6:c47e:192b:5622] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTnaw-007MzI-LQ; Fri, 24 Sep 2021 15:58:54 +0000
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
Subject: [PATCH 02/15] vfio: factor out a vfio_iommu_driver_allowed helper
Date:   Fri, 24 Sep 2021 17:56:52 +0200
Message-Id: <20210924155705.4258-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924155705.4258-1-hch@lst.de>
References: <20210924155705.4258-1-hch@lst.de>
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
index b483b61b7c220d..faf8e0d637bb94 100644
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

