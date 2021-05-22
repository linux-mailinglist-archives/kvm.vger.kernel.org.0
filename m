Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5038D27D
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhEVAXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:23:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:24212 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhEVAW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:22:57 -0400
IronPort-SDR: 5FW0h8FVWdJ4bgabPRBKyeIbVEJK0GW27bLlcaHowfpgVXrE1eKQnXiVa6jZ1AwubBrRIOIjVV
 QxIx3PCgWj/A==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="181210685"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="181210685"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:51 -0700
IronPort-SDR: MPcVlthEflmHx/IsUHghDBX+s9yREoSIh+uaaWREq5h4+vYWuwki8NFImjdQ6FQssNd/zhVHsJ
 KJR2qgwPq5vA==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="412801885"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:50 -0700
Subject: [PATCH v6 17/20] vfio/mdev: idxd: add error notification from host
 driver to mediated device
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:49 -0700
Message-ID: <162164284985.261970.10964903081717121200.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a device error occurs, the mediated device need to be notified in
order to notify the guest of device error. Add support to notify the
specific mdev when an error is wq specific and broadcast errors to all mdev
when it's a generic device error.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/idxd.h       |    7 +++++++
 drivers/dma/idxd/irq.c        |   21 +++++++++++++++++++--
 drivers/vfio/mdev/idxd/mdev.c |    5 +++++
 drivers/vfio/mdev/idxd/mdev.h |    1 +
 drivers/vfio/mdev/idxd/vdev.c |   23 +++++++++++++++++++++++
 5 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 5e8da9019c46..b1d94463fce5 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -50,10 +50,17 @@ enum idxd_type {
 #define IDXD_NAME_SIZE		128
 #define IDXD_PMU_EVENT_MAX	64
 
+struct idxd_wq;
+
+struct idxd_device_ops {
+	void (*notify_error)(struct idxd_wq *wq);
+};
+
 struct idxd_device_driver {
 	const char *name;
 	int (*probe)(struct device *dev);
 	void (*remove)(struct device *dev);
+	struct idxd_device_ops *ops;
 	struct device_driver drv;
 };
 
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index d1a635ecc7f3..b8b6c93f4480 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -104,6 +104,7 @@ static int idxd_device_schedule_fault_process(struct idxd_device *idxd,
 
 static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 {
+	struct idxd_device_driver *wq_drv;
 	struct device *dev = &idxd->pdev->dev;
 	union gensts_reg gensts;
 	u32 val = 0;
@@ -123,16 +124,32 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 			int id = idxd->sw_err.wq_idx;
 			struct idxd_wq *wq = idxd->wqs[id];
 
-			if (wq->type == IDXD_WQT_USER)
+			if (is_idxd_wq_user(wq)) {
 				wake_up_interruptible(&wq->err_queue);
+			} else if (is_idxd_wq_mdev(wq)) {
+				struct device *conf_dev = wq_confdev(wq);
+				struct device_driver *drv = conf_dev->driver;
+
+				wq_drv = container_of(drv, struct idxd_device_driver, drv);
+				if (wq_drv)
+					wq_drv->ops->notify_error(wq);
+			}
 		} else {
 			int i;
 
 			for (i = 0; i < idxd->max_wqs; i++) {
 				struct idxd_wq *wq = idxd->wqs[i];
 
-				if (wq->type == IDXD_WQT_USER)
+				if (is_idxd_wq_user(wq)) {
 					wake_up_interruptible(&wq->err_queue);
+				} else if (is_idxd_wq_mdev(wq)) {
+					struct device *conf_dev = wq_confdev(wq);
+					struct device_driver *drv = conf_dev->driver;
+
+					wq_drv = container_of(drv, struct idxd_device_driver, drv);
+					if (wq_drv)
+						wq_drv->ops->notify_error(wq);
+				}
 			}
 		}
 
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 3257505fb7c7..25d1ac67b0c9 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -904,10 +904,15 @@ static void idxd_mdev_drv_remove(struct device *dev)
 	put_device(dev);
 }
 
+static struct idxd_device_ops mdev_wq_ops = {
+	.notify_error = idxd_wq_vidxd_send_errors,
+};
+
 static struct idxd_device_driver idxd_mdev_driver = {
 	.probe = idxd_mdev_drv_probe,
 	.remove = idxd_mdev_drv_remove,
 	.name = idxd_mdev_drv_name,
+	.ops = &mdev_wq_ops,
 };
 
 static int __init idxd_mdev_init(void)
diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
index dd4290bce772..10358831da6a 100644
--- a/drivers/vfio/mdev/idxd/mdev.h
+++ b/drivers/vfio/mdev/idxd/mdev.h
@@ -107,5 +107,6 @@ int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigne
 int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size);
 int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
 int vidxd_mmio_read(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq);
 
 #endif
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
index a444a0af8b5f..2a066e483dd8 100644
--- a/drivers/vfio/mdev/idxd/vdev.c
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -151,6 +151,29 @@ static void vidxd_report_swerror(struct vdcm_idxd *vidxd, unsigned int error)
 	send_swerr_interrupt(vidxd);
 }
 
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq)
+{
+	struct vdcm_idxd *vidxd = wq->vidxd;
+	struct idxd_device *idxd = vidxd->idxd;
+	u8 *bar0 = vidxd->bar0;
+	union sw_err_reg *swerr = (union sw_err_reg *)(bar0 + IDXD_SWERR_OFFSET);
+	int i;
+
+	if (swerr->valid) {
+		if (!swerr->overflow) {
+			swerr->overflow = 1;
+			send_swerr_interrupt(vidxd);
+		}
+		return;
+	}
+
+	lockdep_assert_held(&idxd->dev_lock);
+	for (i = 0; i < 4; i++)
+		swerr->bits[i] = idxd->sw_err.bits[i];
+
+	send_swerr_interrupt(vidxd);
+}
+
 int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size)
 {
 	u32 offset = pos & (vidxd->bar_size[0] - 1);


