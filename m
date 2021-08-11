Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5C13E9483
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhHKP1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhHKP1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:27:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410F8C061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=MGcMTnV4cNwzUqm8hIPqybQWfS5jPp4Bs4qvfxIpOVI=; b=juB4P7iRPZ06z9XQoIoGecdkp8
        7+U1O++kvMbuAN4ctvKHmZfITe4fDiJOQCGnkVgFNxaJhhHIX19JK+BR9pswHmFNXD4keT16eDoXN
        NDcTxdvoOT+q5f6oOcZ9XNu+oRl6HXdh4nfGD/vubMKlnx45aHmsmrDkeoAVaV7eP1TtH3mxXiIY1
        CAxq63DYkbrRbn9xQQQpFtzlslCpQozrXakY4qDYdSknBqzZm3XTxoWkdX0K/5Gy11lTQ5Ww7qV07
        dAHQt+zaCp2I9ppQyv2X9H1XvEailyneBZ1h2By5zZ3Wy3UaH8S0Cn1fwiB/0h1CiZxVOT4hRX7tc
        2XP4dWJg==;
Received: from [2001:4bb8:184:6215:ac7b:970b:bd9c:c36c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDq6K-00DYlt-Rc; Wed, 11 Aug 2021 15:25:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 11/14] vfio: clean up the check for mediated device in vfio_iommu_type1
Date:   Wed, 11 Aug 2021 17:14:57 +0200
Message-Id: <20210811151500.2744-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811151500.2744-1-hch@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the group flags to ->attach_group and remove the messy check for
the bus type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio.c                 | 11 +++++------
 drivers/vfio/vfio.h                 |  7 ++++++-
 drivers/vfio/vfio_iommu_spapr_tce.c |  2 +-
 drivers/vfio/vfio_iommu_type1.c     | 19 ++-----------------
 4 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 9022035a3742ed..aa5d5b71b11b90 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -68,9 +68,6 @@ struct vfio_unbound_dev {
 	struct list_head		unbound_next;
 };
 
-#define VFIO_MEDIATED	(1 << 0)
-#define VFIO_NOIOMMU	(1 << 1)
-
 struct vfio_group {
 	struct kref			kref;
 	int				minor;
@@ -198,7 +195,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
 }
 
 static int vfio_noiommu_attach_group(void *iommu_data,
-				     struct iommu_group *iommu_group)
+		struct iommu_group *iommu_group, unsigned int flags)
 {
 	return 0;
 }
@@ -1098,7 +1095,8 @@ static int __vfio_container_attach_groups(struct vfio_container *container,
 	int ret = -ENODEV;
 
 	list_for_each_entry(group, &container->group_list, container_next) {
-		ret = driver->ops->attach_group(data, group->iommu_group);
+		ret = driver->ops->attach_group(data, group->iommu_group,
+						group->flags);
 		if (ret)
 			goto unwind;
 	}
@@ -1356,7 +1354,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	driver = container->iommu_driver;
 	if (driver) {
 		ret = driver->ops->attach_group(container->iommu_data,
-						group->iommu_group);
+						group->iommu_group,
+						group->flags);
 		if (ret)
 			goto unlock_out;
 	}
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index a78de649eb2f16..0c1a88fa991545 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -9,6 +9,10 @@ enum vfio_iommu_notify_type {
 	VFIO_IOMMU_CONTAINER_CLOSE = 0,
 };
 
+/* flags for group->flags and ->attach_group */
+#define VFIO_MEDIATED	(1 << 0)
+#define VFIO_NOIOMMU	(1 << 1)
+
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
  */
@@ -20,7 +24,8 @@ struct vfio_iommu_driver_ops {
 	long		(*ioctl)(void *iommu_data, unsigned int cmd,
 				 unsigned long arg);
 	int		(*attach_group)(void *iommu_data,
-					struct iommu_group *group);
+					struct iommu_group *group,
+					unsigned int flags);
 	void		(*detach_group)(void *iommu_data,
 					struct iommu_group *group);
 	int		(*pin_pages)(void *iommu_data,
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 3efd09faeca4a8..7567328d347d25 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -1239,7 +1239,7 @@ static long tce_iommu_take_ownership_ddw(struct tce_container *container,
 }
 
 static int tce_iommu_attach_group(void *iommu_data,
-		struct iommu_group *iommu_group)
+		struct iommu_group *iommu_group, unsigned int flags)
 {
 	int ret = 0;
 	struct tce_container *container = iommu_data;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 39e2706d0b3f34..44a3abdca580a0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -36,7 +36,6 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
-#include <linux/mdev.h>
 #include <linux/notifier.h>
 #include <linux/dma-iommu.h>
 #include <linux/irqdomain.h>
@@ -1934,20 +1933,6 @@ static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
 	return ret;
 }
 
-static bool vfio_bus_is_mdev(struct bus_type *bus)
-{
-	struct bus_type *mdev_bus;
-	bool ret = false;
-
-	mdev_bus = symbol_get(mdev_bus_type);
-	if (mdev_bus) {
-		ret = (bus == mdev_bus);
-		symbol_put(mdev_bus_type);
-	}
-
-	return ret;
-}
-
 /*
  * This is a helper function to insert an address range to iova list.
  * The list is initially created with a single entry corresponding to
@@ -2172,7 +2157,7 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 }
 
 static int vfio_iommu_type1_attach_group(void *iommu_data,
-					 struct iommu_group *iommu_group)
+		struct iommu_group *iommu_group, unsigned int flags)
 {
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_iommu_group *group;
@@ -2207,7 +2192,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_free;
 
-	if (vfio_bus_is_mdev(bus)) {
+	if (flags & VFIO_MEDIATED) {
 		if (!iommu->external_domain) {
 			INIT_LIST_HEAD(&domain->group_list);
 			iommu->external_domain = domain;
-- 
2.30.2

