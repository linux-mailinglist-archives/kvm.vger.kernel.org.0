Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31CC41782F
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347266AbhIXQL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347149AbhIXQL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 12:11:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D643C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=UySBjKtuGNdtmuajso+nQXYeigCBAR6FokRkVBbR5XI=; b=vhN9UcAFDDHactRAB79WAL2vS5
        x4ABozXpJgUuWXaC0dfrtowSobhEJoUoSdRHtbsW0O1Q5b0CdRb0AmIr5LWKOs81l9xpWCmv7o0U8
        FPT+aK7XyMU3W5ORxip6/JG3HaHRWLsjGmIKPS3GV6Ja1cYoj8YOtAazWIJOImp9h9Ud+Uu9UjV7a
        jSG9ewUYRSPbQzUDTCtqYCKZLAc+kYzr8XFaIY5nCy689chABp/bij1+8doe9I8dm7IAB2FzqA8Qq
        +QhuO6k7nsW/76Jbvfgp2YDVtqPH+TAA3XuFkreIruu3S05xtFMbROjqMRTWTCrrMkLttPLizzopY
        fqS0B3Sg==;
Received: from [2001:4bb8:184:72db:e8f6:c47e:192b:5622] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTnkY-007NWp-2Q; Fri, 24 Sep 2021 16:08:45 +0000
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
Subject: [PATCH 11/15] vfio: clean up the check for mediated device in vfio_iommu_type1
Date:   Fri, 24 Sep 2021 17:57:01 +0200
Message-Id: <20210924155705.4258-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924155705.4258-1-hch@lst.de>
References: <20210924155705.4258-1-hch@lst.de>
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
 drivers/vfio/vfio.c                 | 32 +++++------------------------
 drivers/vfio/vfio.h                 | 27 +++++++++++++++++++++++-
 drivers/vfio/vfio_iommu_spapr_tce.c |  2 +-
 drivers/vfio/vfio_iommu_type1.c     | 19 ++---------------
 4 files changed, 34 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 6589e296ef348c..08b27b64f0f935 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -68,30 +68,6 @@ struct vfio_unbound_dev {
 	struct list_head		unbound_next;
 };
 
-enum vfio_group_type {
-	/*
-	 * Physical device with IOMMU backing.
-	 */
-	VFIO_IOMMU,
-
-	/*
-	 * Virtual device without IOMMU backing. The VFIO core fakes up an
-	 * iommu_group as the iommu_group sysfs interface is part of the
-	 * userspace ABI.  The user of these devices must not be able to
-	 * directly trigger unmediated DMA.
-	 */
-	VFIO_EMULATED_IOMMU,
-
-	/*
-	 * Physical device without IOMMU backing. The VFIO core fakes up an
-	 * iommu_group as the iommu_group sysfs interface is part of the
-	 * userspace ABI.  Users can trigger unmediated DMA by the device,
-	 * usage is highly dangerous, requires an explicit opt-in and will
-	 * taint the kernel.
-	 */
-	VFIO_NO_IOMMU,
-};
-
 struct vfio_group {
 	struct kref			kref;
 	int				minor;
@@ -219,7 +195,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
 }
 
 static int vfio_noiommu_attach_group(void *iommu_data,
-				     struct iommu_group *iommu_group)
+		struct iommu_group *iommu_group, enum vfio_group_type type)
 {
 	return 0;
 }
@@ -1129,7 +1105,8 @@ static int __vfio_container_attach_groups(struct vfio_container *container,
 	int ret = -ENODEV;
 
 	list_for_each_entry(group, &container->group_list, container_next) {
-		ret = driver->ops->attach_group(data, group->iommu_group);
+		ret = driver->ops->attach_group(data, group->iommu_group,
+						group->type);
 		if (ret)
 			goto unwind;
 	}
@@ -1387,7 +1364,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	driver = container->iommu_driver;
 	if (driver) {
 		ret = driver->ops->attach_group(container->iommu_data,
-						group->iommu_group);
+						group->iommu_group,
+						group->type);
 		if (ret)
 			goto unlock_out;
 	}
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index a78de649eb2f16..a6713022115155 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -4,6 +4,30 @@
  *     Author: Alex Williamson <alex.williamson@redhat.com>
  */
 
+enum vfio_group_type {
+	/*
+	 * Physical device with IOMMU backing.
+	 */
+	VFIO_IOMMU,
+
+	/*
+	 * Virtual device without IOMMU backing. The VFIO core fakes up an
+	 * iommu_group as the iommu_group sysfs interface is part of the
+	 * userspace ABI.  The user of these devices must not be able to
+	 * directly trigger unmediated DMA.
+	 */
+	VFIO_EMULATED_IOMMU,
+
+	/*
+	 * Physical device without IOMMU backing. The VFIO core fakes up an
+	 * iommu_group as the iommu_group sysfs interface is part of the
+	 * userspace ABI.  Users can trigger unmediated DMA by the device,
+	 * usage is highly dangerous, requires an explicit opt-in and will
+	 * taint the kernel.
+	 */
+	VFIO_NO_IOMMU,
+};
+
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
 	VFIO_IOMMU_CONTAINER_CLOSE = 0,
@@ -20,7 +44,8 @@ struct vfio_iommu_driver_ops {
 	long		(*ioctl)(void *iommu_data, unsigned int cmd,
 				 unsigned long arg);
 	int		(*attach_group)(void *iommu_data,
-					struct iommu_group *group);
+					struct iommu_group *group,
+					enum vfio_group_type);
 	void		(*detach_group)(void *iommu_data,
 					struct iommu_group *group);
 	int		(*pin_pages)(void *iommu_data,
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 3efd09faeca4a8..936a26b13c0b01 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -1239,7 +1239,7 @@ static long tce_iommu_take_ownership_ddw(struct tce_container *container,
 }
 
 static int tce_iommu_attach_group(void *iommu_data,
-		struct iommu_group *iommu_group)
+		struct iommu_group *iommu_group, enum vfio_group_type type)
 {
 	int ret = 0;
 	struct tce_container *container = iommu_data;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 42a6be1fb7265e..a48e9f597cb213 100644
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
+		struct iommu_group *iommu_group, enum vfio_group_type type)
 {
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_iommu_group *group;
@@ -2207,7 +2192,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_free;
 
-	if (vfio_bus_is_mdev(bus)) {
+	if (type == VFIO_EMULATED_IOMMU) {
 		if (!iommu->external_domain) {
 			INIT_LIST_HEAD(&domain->group_list);
 			iommu->external_domain = domain;
-- 
2.30.2

