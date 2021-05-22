Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9660E38D277
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhEVAXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:23:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:56072 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231286AbhEVAWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:22:22 -0400
IronPort-SDR: 3fbRic06r2VCumwW6SahWbJyjULxrDNM5h2XQk4lNxOzH9Bm9jvM7G8m4VOqLAL8+VHFrvqcAS
 NWn0+MbSb+pQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="199661288"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="199661288"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:58 -0700
IronPort-SDR: r66u16T10yzWEpgnFp0w9VS6i7FXAGZWvjKzU4FWhmUAM8XjWV9w3sHQKzn0pTZmCSLTCeP1RZ
 epSHqwRlOJGQ==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="474753058"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:57 -0700
Subject: [PATCH v6 18/20] vfio: move vfio_pci_set_ctx_trigger_single to common
 code
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:56 -0700
Message-ID: <162164285626.261970.18327549914978174180.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With mdev needing to also use the same function, move the function to a
common place where vfio pci and mdev can both utilize.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/vfio/Makefile             |    2 +
 drivers/vfio/pci/vfio_pci_intrs.c |   63 ++------------------------------
 drivers/vfio/vfio_common.c        |   74 +++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h              |    4 ++
 4 files changed, 83 insertions(+), 60 deletions(-)
 create mode 100644 drivers/vfio/vfio_common.c

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index fee73f3d9480..fc7fd2412dee 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 vfio_virqfd-y := virqfd.o
 
-obj-$(CONFIG_VFIO) += vfio.o
+obj-$(CONFIG_VFIO) += vfio.o vfio_common.o
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 9c8efad3a859..926cff00146c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -561,61 +561,6 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
-					   unsigned int count, uint32_t flags,
-					   void *data)
-{
-	/* DATA_NONE/DATA_BOOL enables loopback testing */
-	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		if (*ctx) {
-			if (count) {
-				eventfd_signal(*ctx, 1);
-			} else {
-				eventfd_ctx_put(*ctx);
-				*ctx = NULL;
-			}
-			return 0;
-		}
-	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
-		uint8_t trigger;
-
-		if (!count)
-			return -EINVAL;
-
-		trigger = *(uint8_t *)data;
-		if (trigger && *ctx)
-			eventfd_signal(*ctx, 1);
-
-		return 0;
-	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
-		int32_t fd;
-
-		if (!count)
-			return -EINVAL;
-
-		fd = *(int32_t *)data;
-		if (fd == -1) {
-			if (*ctx)
-				eventfd_ctx_put(*ctx);
-			*ctx = NULL;
-		} else if (fd >= 0) {
-			struct eventfd_ctx *efdctx;
-
-			efdctx = eventfd_ctx_fdget(fd);
-			if (IS_ERR(efdctx))
-				return PTR_ERR(efdctx);
-
-			if (*ctx)
-				eventfd_ctx_put(*ctx);
-
-			*ctx = efdctx;
-		}
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
@@ -623,8 +568,8 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
 	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->err_trigger,
-					       count, flags, data);
+	return vfio_set_ctx_trigger_single(&vdev->err_trigger,
+					   count, flags, data);
 }
 
 static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
@@ -634,8 +579,8 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->req_trigger,
-					       count, flags, data);
+	return vfio_set_ctx_trigger_single(&vdev->req_trigger,
+					   count, flags, data);
 }
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
diff --git a/drivers/vfio/vfio_common.c b/drivers/vfio/vfio_common.c
new file mode 100644
index 000000000000..b209d57c7312
--- /dev/null
+++ b/drivers/vfio/vfio_common.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 Intel, Corp. All rights reserved.
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ * VFIO common helper functions
+ */
+
+#include <linux/eventfd.h>
+#include <linux/vfio.h>
+
+/*
+ * Common helper to set single eventfd trigger
+ *
+ * @ctx [out]		: address of eventfd ctx to be written to
+ * @count [in]		: number of vectors (should be 1)
+ * @flags [in]		: VFIO IRQ flags
+ * @data [in]		: data from ioctl
+ */
+int vfio_set_ctx_trigger_single(struct eventfd_ctx **ctx,
+				unsigned int count, u32 flags,
+				void *data)
+{
+	/* DATA_NONE/DATA_BOOL enables loopback testing */
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		if (*ctx) {
+			if (count) {
+				eventfd_signal(*ctx, 1);
+			} else {
+				eventfd_ctx_put(*ctx);
+				*ctx = NULL;
+			}
+			return 0;
+		}
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		u8 trigger;
+
+		if (!count)
+			return -EINVAL;
+
+		trigger = *(uint8_t *)data;
+		if (trigger && *ctx)
+			eventfd_signal(*ctx, 1);
+
+		return 0;
+	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		s32 fd;
+
+		if (!count)
+			return -EINVAL;
+
+		fd = *(s32 *)data;
+		if (fd == -1) {
+			if (*ctx)
+				eventfd_ctx_put(*ctx);
+			*ctx = NULL;
+		} else if (fd >= 0) {
+			struct eventfd_ctx *efdctx;
+
+			efdctx = eventfd_ctx_fdget(fd);
+			if (IS_ERR(efdctx))
+				return PTR_ERR(efdctx);
+
+			if (*ctx)
+				eventfd_ctx_put(*ctx);
+
+			*ctx = efdctx;
+		}
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vfio_set_ctx_trigger_single);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ed5ca027eb49..aa7cb0e1b8b2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -235,4 +235,8 @@ extern int vfio_virqfd_enable(void *opaque,
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+/* common lib functions */
+extern int vfio_set_ctx_trigger_single(struct eventfd_ctx **ctx,
+				       unsigned int count, u32 flags,
+				       void *data);
 #endif /* VFIO_H */


