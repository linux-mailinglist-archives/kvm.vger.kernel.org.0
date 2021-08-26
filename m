Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0210B3F8957
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 15:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242723AbhHZNsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 09:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242731AbhHZNsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 09:48:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E125CC061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 06:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=46KN0SO8DFFA7SmbbIApjB/CZ+FItjv3FWXKrjt1Cgk=; b=OEaX21I1vj6CZ0PkgRnsJbQ2gK
        C+pVLSxtX6LZAOAFA0u8MwFqywN4A5zgiWBeSRcejCTncGUPVRNw5djEzJzyzSxF0GhaMPA8I9/8t
        mzXlbIYXv2+t/J/OVtaHLe1B/vX/UbqoV8MecudKcYYRNdfQCzj16NuAAiAHDdu/EFVyn2jmqyCKE
        KDv7aCAKpyMItf+FDxtOpBDZY2lT/j9foOx3i5NIJg7eZuYF+xA6lVwPUZByif7rNVQM7Lab4l/BU
        Y4X4E9u1XXhX9pT/lARNtzhC77tDxk6HKSS0EX/i7QS+bORVsKyIRCqiciktNKx5lzt5LuRVA5DbE
        8oAYKxOw==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJFhx-00DLZg-0E; Thu, 26 Aug 2021 13:46:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 11/14] vfio: clean up the check for mediated device in vfio_iommu_type1
Date:   Thu, 26 Aug 2021 15:34:21 +0200
Message-Id: <20210826133424.3362-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826133424.3362-1-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the group flags to ->attach_group and remove the messy check for
the bus type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio.c                 | 23 +++++------------------
 drivers/vfio/vfio.h                 | 18 +++++++++++++++++-
 drivers/vfio/vfio_iommu_spapr_tce.c |  2 +-
 drivers/vfio/vfio_iommu_type1.c     | 19 ++-----------------
 4 files changed, 25 insertions(+), 37 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index b2f2951f7fc759..3a668fe2ea96f7 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -68,21 +68,6 @@ struct vfio_unbound_dev {
 	struct list_head		unbound_next;
 };
 
-/*
- * Virtual device without IOMMU backing. The VFIO core fakes up an iommu_group
- * as the iommu_group sysfs interface is part of the userspace ABI.  The user
- * of these devices must not be able to directly trigger unmediated DMA.
- */
-#define VFIO_EMULATED_IOMMU	(1 << 0)
-
-/*
- * Physical device without IOMMU backing. The VFIO core fakes up an iommu_group
- * as the iommu_group sysfs interface is part of the userspace ABI.  Users can
- * trigger unmediated DMA by the device, usage is highly dangerous, requires
- * an explicit opt-in and will taint the kernel.
- */
-#define VFIO_NO_IOMMU		(1 << 1)
-
 struct vfio_group {
 	struct kref			kref;
 	int				minor;
@@ -210,7 +195,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
 }
 
 static int vfio_noiommu_attach_group(void *iommu_data,
-				     struct iommu_group *iommu_group)
+		struct iommu_group *iommu_group, unsigned int flags)
 {
 	return 0;
 }
@@ -1119,7 +1104,8 @@ static int __vfio_container_attach_groups(struct vfio_container *container,
 	int ret = -ENODEV;
 
 	list_for_each_entry(group, &container->group_list, container_next) {
-		ret = driver->ops->attach_group(data, group->iommu_group);
+		ret = driver->ops->attach_group(data, group->iommu_group,
+						group->flags);
 		if (ret)
 			goto unwind;
 	}
@@ -1377,7 +1363,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
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
index a78de649eb2f16..3bdf21416563a4 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -9,6 +9,21 @@ enum vfio_iommu_notify_type {
 	VFIO_IOMMU_CONTAINER_CLOSE = 0,
 };
 
+/*
+ * Virtual device without IOMMU backing. The VFIO core fakes up an iommu_group
+ * as the iommu_group sysfs interface is part of the userspace ABI.  The user
+ * of these devices must not be able to directly trigger unmediated DMA.
+ */
+#define VFIO_EMULATED_IOMMU	(1 << 0)
+
+/*
+ * Physical device without IOMMU backing. The VFIO core fakes up an iommu_group
+ * as the iommu_group sysfs interface is part of the userspace ABI.  Users can
+ * trigger unmediated DMA by the device, usage is highly dangerous, requires
+ * an explicit opt-in and will taint the kernel.
+ */
+#define VFIO_NO_IOMMU		(1 << 1)
+
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
  */
@@ -20,7 +35,8 @@ struct vfio_iommu_driver_ops {
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
index 39e2706d0b3f34..ca3c995c84166f 100644
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
+	if (flags & VFIO_EMULATED_IOMMU) {
 		if (!iommu->external_domain) {
 			INIT_LIST_HEAD(&domain->group_list);
 			iommu->external_domain = domain;
-- 
2.30.2

