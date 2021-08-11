Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B883E9480
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhHKPZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhHKPZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:25:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2FFC061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OqpUv6OtWBmHvyi6Z12dclrApgGriaqyz4wE5a70YT4=; b=mOQ07tzIoiOJQxNNW+ffiTAM3C
        SWpIXo9uObtl3Z+L8i1CgR1JnchaR36WE7aadOdjkjDqP9jX4v35IOexxYaujnbm0ssqEMDDOmhqK
        x9OfSBq3PJ+CZORh+gPElJW3CrL1YNXJZzXv5eTkwswEc24Nizu1DhcXSw6rzMdU7rK73LMqagKR6
        19mHVlAzjci6iLVn/hq90YXsdPtnC9WdnUY1Pl0y5uqR0i1xIkVZUQ99Ks5+rIoiGCU9guP/40st7
        Zxroq5TDB0xcdlN2UPEse88FEE1VnyMnJkAYjdMGXDscsAvMeDhcMPwta0e4L5brVOtKX1KL/E2+V
        tOiPAbBg==;
Received: from [2001:4bb8:184:6215:ac7b:970b:bd9c:c36c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDq4u-00DYhT-On; Wed, 11 Aug 2021 15:23:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 09/14] vfio: move the vfio_iommu_driver_ops interface out of <linux/vfio.h>
Date:   Wed, 11 Aug 2021 17:14:55 +0200
Message-Id: <20210811151500.2744-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811151500.2744-1-hch@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a new private drivers/vfio/vfio.h header for the interface between
the VFIO core and the iommu drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio.c                 |  1 +
 drivers/vfio/vfio.h                 | 47 +++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_spapr_tce.c |  1 +
 drivers/vfio/vfio_iommu_type1.c     |  1 +
 include/linux/vfio.h                | 44 ---------------------------
 5 files changed, 50 insertions(+), 44 deletions(-)
 create mode 100644 drivers/vfio/vfio.h

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 609828c7366649..9022035a3742ed 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -32,6 +32,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
 #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
new file mode 100644
index 00000000000000..a78de649eb2f16
--- /dev/null
+++ b/drivers/vfio/vfio.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ */
+
+/* events for the backend driver notify callback */
+enum vfio_iommu_notify_type {
+	VFIO_IOMMU_CONTAINER_CLOSE = 0,
+};
+
+/**
+ * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
+ */
+struct vfio_iommu_driver_ops {
+	char		*name;
+	struct module	*owner;
+	void		*(*open)(unsigned long arg);
+	void		(*release)(void *iommu_data);
+	long		(*ioctl)(void *iommu_data, unsigned int cmd,
+				 unsigned long arg);
+	int		(*attach_group)(void *iommu_data,
+					struct iommu_group *group);
+	void		(*detach_group)(void *iommu_data,
+					struct iommu_group *group);
+	int		(*pin_pages)(void *iommu_data,
+				     struct iommu_group *group,
+				     unsigned long *user_pfn,
+				     int npage, int prot,
+				     unsigned long *phys_pfn);
+	int		(*unpin_pages)(void *iommu_data,
+				       unsigned long *user_pfn, int npage);
+	int		(*register_notifier)(void *iommu_data,
+					     unsigned long *events,
+					     struct notifier_block *nb);
+	int		(*unregister_notifier)(void *iommu_data,
+					       struct notifier_block *nb);
+	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
+				  void *data, size_t count, bool write);
+	struct iommu_domain *(*group_iommu_domain)(void *iommu_data,
+						   struct iommu_group *group);
+	void		(*notify)(void *iommu_data,
+				  enum vfio_iommu_notify_type event);
+};
+
+int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
+void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops);
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index fe888b5dcc0062..3efd09faeca4a8 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -20,6 +20,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/mm.h>
+#include "vfio.h"
 
 #include <asm/iommu.h>
 #include <asm/tce.h>
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4f7c174c7a2b..92777797578e50 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -40,6 +40,7 @@
 #include <linux/notifier.h>
 #include <linux/dma-iommu.h>
 #include <linux/irqdomain.h>
+#include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 82042690d7978d..5df56626751efd 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -82,50 +82,6 @@ extern void vfio_device_put(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 
-/* events for the backend driver notify callback */
-enum vfio_iommu_notify_type {
-	VFIO_IOMMU_CONTAINER_CLOSE = 0,
-};
-
-/**
- * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
- */
-struct vfio_iommu_driver_ops {
-	char		*name;
-	struct module	*owner;
-	void		*(*open)(unsigned long arg);
-	void		(*release)(void *iommu_data);
-	long		(*ioctl)(void *iommu_data, unsigned int cmd,
-				 unsigned long arg);
-	int		(*attach_group)(void *iommu_data,
-					struct iommu_group *group);
-	void		(*detach_group)(void *iommu_data,
-					struct iommu_group *group);
-	int		(*pin_pages)(void *iommu_data,
-				     struct iommu_group *group,
-				     unsigned long *user_pfn,
-				     int npage, int prot,
-				     unsigned long *phys_pfn);
-	int		(*unpin_pages)(void *iommu_data,
-				       unsigned long *user_pfn, int npage);
-	int		(*register_notifier)(void *iommu_data,
-					     unsigned long *events,
-					     struct notifier_block *nb);
-	int		(*unregister_notifier)(void *iommu_data,
-					       struct notifier_block *nb);
-	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
-				  void *data, size_t count, bool write);
-	struct iommu_domain *(*group_iommu_domain)(void *iommu_data,
-						   struct iommu_group *group);
-	void		(*notify)(void *iommu_data,
-				  enum vfio_iommu_notify_type event);
-};
-
-extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
-
-extern void vfio_unregister_iommu_driver(
-				const struct vfio_iommu_driver_ops *ops);
-
 /*
  * External user API
  */
-- 
2.30.2

