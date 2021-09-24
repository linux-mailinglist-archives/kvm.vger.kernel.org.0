Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F7341782D
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347251AbhIXQKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347149AbhIXQKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 12:10:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833B4C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=O9Npri61FM9JGR//6zG8i5lWNNuzAcIsRcVeZkegu1w=; b=bnc7e+07tNFMW7rqW1Yidb0Nbc
        7MnLxwXhYHjr7E/ZzOVVUX1fFy8KB4Ksvz51SRwpb2GaY7G93SShfcscM4iEZY0qw+jc3hjo97MUq
        stzFuR1duQ3aFzjplapI5Q95TmLbvovZJB3XZaM6+f0WowpayjSFjBahfIjNt3hwxOJzyPNTPQ4vy
        3q9VojKLPeizZAZuANqQ6Wz5Gsz9zDFsdm2EAJbfJpHecujTdRWgaI+7nZFQFlI059/nUtiMsxb1r
        Gr/MvSEvZCuO4QEzBD5WKH7im/Imq/gbgIqIpwahhm2ZsTW7drZKXbkeMfSZr04nkcdKqnU+OKbOO
        UgoIM20Q==;
Received: from [2001:4bb8:184:72db:e8f6:c47e:192b:5622] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTniW-007NQO-TP; Fri, 24 Sep 2021 16:06:48 +0000
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
Subject: [PATCH 09/15] vfio: move the vfio_iommu_driver_ops interface out of <linux/vfio.h>
Date:   Fri, 24 Sep 2021 17:56:59 +0200
Message-Id: <20210924155705.4258-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924155705.4258-1-hch@lst.de>
References: <20210924155705.4258-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a new private drivers/vfio/vfio.h header for the interface between
the VFIO core and the iommu drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio.c                 |  1 +
 drivers/vfio/vfio.h                 | 47 +++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_spapr_tce.c |  1 +
 drivers/vfio/vfio_iommu_type1.c     |  1 +
 include/linux/vfio.h                | 44 ---------------------------
 5 files changed, 50 insertions(+), 44 deletions(-)
 create mode 100644 drivers/vfio/vfio.h

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2c1c7316aa192c..6589e296ef348c 100644
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
index 0e9217687f5c3e..2e51e4390c1531 100644
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
index 7a57a0077f9637..76191d7abed185 100644
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

