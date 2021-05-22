Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3041138D281
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhEVAX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:23:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:27110 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230478AbhEVAXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:23:12 -0400
IronPort-SDR: 4lA4DYl3TTO9RPf0v5L5QiaWGOTxZBixkJKYwdJWrIm4osS0K8HpxPda6iBNKVjPWR0Yu+9H7h
 Z4laU5ucfnlA==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="201634425"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="201634425"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:21:05 -0700
IronPort-SDR: C9TyUlnAuHhIlKxxo2Tnq56G+67p2ETA+MiqYq+SL80Q7Eryb088zy2NlZJpimmgJ33hd5cwmU
 U7cU4wJNypxg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="441149772"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:21:03 -0700
Subject: [PATCH v6 19/20] vfio: mdev: Add device request interface
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:21:03 -0700
Message-ID: <162164286322.261970.2647654897518928545.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to commit 6140a8f56238 ("vfio-pci: Add device request interface").
Add request interface for mdev to allow userspace to opt in to receive
a device request notification, indicating that the device should be
released.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/vfio/mdev/mdev_irqs.c |   23 +++++++++++++++++++++++
 include/linux/mdev.h          |   15 +++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_irqs.c b/drivers/vfio/mdev/mdev_irqs.c
index ed2d11a7c729..11b1f8df020c 100644
--- a/drivers/vfio/mdev/mdev_irqs.c
+++ b/drivers/vfio/mdev/mdev_irqs.c
@@ -316,3 +316,26 @@ void mdev_irqs_free(struct mdev_device *mdev)
 	memset(&mdev->mdev_irq, 0, sizeof(mdev->mdev_irq));
 }
 EXPORT_SYMBOL_GPL(mdev_irqs_free);
+
+void vfio_mdev_request(struct vfio_device *vdev, unsigned int count)
+{
+	struct device *dev = vdev->dev;
+	struct mdev_device *mdev = to_mdev_device(dev);
+
+	if (mdev->req_trigger) {
+		dev_dbg(dev, "Requesting device from user\n");
+		eventfd_signal(mdev->req_trigger, 1);
+	}
+}
+EXPORT_SYMBOL_GPL(vfio_mdev_request);
+
+int vfio_mdev_set_req_trigger(struct mdev_device *mdev, unsigned int index,
+			      unsigned int start, unsigned int count, u32 flags,
+			      void *data)
+{
+	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count != 1)
+		return -EINVAL;
+
+	return vfio_set_ctx_trigger_single(&mdev->req_trigger, count, flags, data);
+}
+EXPORT_SYMBOL_GPL(vfio_mdev_set_req_trigger);
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 035c021e8068..db73d58f5e81 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -11,6 +11,8 @@
 #define MDEV_H
 
 #include <linux/irqbypass.h>
+#include <linux/eventfd.h>
+#include <linux/vfio.h>
 
 struct mdev_type;
 
@@ -38,6 +40,7 @@ struct mdev_device {
 	struct device *iommu_device;
 	struct mutex creation_lock;
 	struct mdev_irq mdev_irq;
+	struct eventfd_ctx *req_trigger;
 };
 
 static inline struct mdev_device *irq_to_mdev(struct mdev_irq *mdev_irq)
@@ -131,6 +134,10 @@ void mdev_msix_send_signal(struct mdev_device *mdev, int vector);
 int mdev_irqs_init(struct mdev_device *mdev, int num, bool *ims_map);
 void mdev_irqs_free(struct mdev_device *mdev);
 void mdev_irqs_set_pasid(struct mdev_device *mdev, u32 pasid);
+void vfio_mdev_request(struct vfio_device *vdev, unsigned int count);
+int vfio_mdev_set_req_trigger(struct mdev_device *mdev, unsigned int index,
+			      unsigned int start, unsigned int count, u32 flags,
+			      void *data);
 #else
 static inline int mdev_set_msix_trigger(struct mdev_device *mdev, unsigned int index,
 					unsigned int start, unsigned int count, u32 flags,
@@ -148,6 +155,14 @@ static inline int mdev_irqs_init(struct mdev_device *mdev, int num, bool *ims_ma
 
 void mdev_irqs_free(struct mdev_device *mdev) {}
 void mdev_irqs_set_pasid(struct mdev_device *mdev, u32 pasid) {}
+void vfio_mdev_request(struct vfio_device *vdev, unsigned int count) {}
+
+int vfio_mdev_set_req_trigger(struct mdev_device *mdev, unsigned int index,
+			      unsigned int start, unsigned int count, u32 flags,
+			      void *data)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_VFIO_MDEV_IMS */
 
 #endif /* MDEV_H */


