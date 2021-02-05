Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88201311303
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 22:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhBETUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 14:20:32 -0500
Received: from mga12.intel.com ([192.55.52.136]:30881 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233630AbhBETMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:12:23 -0500
IronPort-SDR: gYIR2fB7z72T09LeE127MckFYCBnQlZFDBUfKid/acZojIKGPThDTrvMYuSs0YzYHBAdX+1OD3
 EYgBoKFqHrXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="160645235"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="160645235"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:54:25 -0800
IronPort-SDR: uhZLUkkHEErKzCwzWYQJT5naWnl2dq0WsrMNy1yXXf8wDRsWV5X0cpgNFlAy/5ONLy2smKpGFX
 KlHEuIJjiBpg==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434597079"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:54:23 -0800
Subject: [PATCH v5 14/14] vfio/mdev: idxd: add error notification from host
 driver to mediated device
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        jgg@mellanox.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 05 Feb 2021 13:54:23 -0700
Message-ID: <161255846348.339900.12785712530534526428.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/dma/idxd/irq.c        |    6 ++++++
 drivers/vfio/mdev/idxd/mdev.c |    5 +++++
 drivers/vfio/mdev/idxd/vdev.c |   32 ++++++++++++++++++++++++++++++++
 drivers/vfio/mdev/idxd/vdev.h |    1 +
 5 files changed, 51 insertions(+)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 4afe35385f85..6016df029ed4 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -295,10 +295,17 @@ enum idxd_interrupt_type {
 	IDXD_IRQ_IMS,
 };
 
+struct aux_mdev_ops {
+	void (*notify_error)(struct idxd_wq *wq);
+};
+
 struct idxd_mdev_aux_drv {
 	        struct auxiliary_driver auxiliary_drv;
+		const struct aux_mdev_ops ops;
 };
 
+#define to_mdev_aux_drv(_aux_drv) container_of(_aux_drv, struct idxd_mdev_aux_drv, auxiliary_drv)
+
 static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot,
 					    enum idxd_interrupt_type irq_type)
 {
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 090926856df3..9cdd3e789799 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -118,6 +118,8 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 	u32 val = 0;
 	int i;
 	bool err = false;
+	struct auxiliary_driver *auxdrv = to_auxiliary_drv(idxd->mdev_auxdev->dev.driver);
+	struct idxd_mdev_aux_drv *mdevdrv = to_mdev_aux_drv(auxdrv);
 
 	if (cause & IDXD_INTC_ERR) {
 		spin_lock_bh(&idxd->dev_lock);
@@ -132,6 +134,8 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 
 			if (wq->type == IDXD_WQT_USER)
 				wake_up_interruptible(&wq->idxd_cdev.err_queue);
+			else if (wq->type == IDXD_WQT_MDEV)
+				mdevdrv->ops.notify_error(wq);
 		} else {
 			int i;
 
@@ -140,6 +144,8 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 
 				if (wq->type == IDXD_WQT_USER)
 					wake_up_interruptible(&wq->idxd_cdev.err_queue);
+				else if (wq->type == IDXD_WQT_MDEV)
+					mdevdrv->ops.notify_error(wq);
 			}
 		}
 
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 60913950a4f5..edccaad66c8c 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -1266,12 +1266,17 @@ static const struct auxiliary_device_id idxd_mdev_auxbus_id_table[] = {
 };
 MODULE_DEVICE_TABLE(auxiliary, idxd_mdev_auxbus_id_table);
 
+static const struct aux_mdev_ops aux_mdev_ops = {
+	.notify_error = idxd_wq_vidxd_send_errors,
+};
+
 static struct idxd_mdev_aux_drv idxd_mdev_aux_drv = {
 	.auxiliary_drv = {
 		.id_table = idxd_mdev_auxbus_id_table,
 		.probe = idxd_mdev_aux_probe,
 		.remove = idxd_mdev_aux_remove,
 	},
+	.ops = aux_mdev_ops,
 };
 
 static int idxd_mdev_auxdev_drv_register(struct idxd_mdev_aux_drv *drv)
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
index 8626438a9e54..3aa9d5b870e8 100644
--- a/drivers/vfio/mdev/idxd/vdev.c
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -980,3 +980,35 @@ void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
 		break;
 	}
 }
+
+static void vidxd_send_errors(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	u8 *bar0 = vidxd->bar0;
+	union sw_err_reg *swerr = (union sw_err_reg *)(bar0 + IDXD_SWERR_OFFSET);
+	union genctrl_reg *genctrl = (union genctrl_reg *)(bar0 + IDXD_GENCTRL_OFFSET);
+	u32 *intcause = (u32 *)(bar0 + IDXD_INTCAUSE_OFFSET);
+	int i;
+
+	if (swerr->valid) {
+		if (!swerr->overflow)
+			swerr->overflow = 1;
+		return;
+	}
+
+	lockdep_assert_held(&idxd->dev_lock);
+	for (i = 0; i < 4; i++)
+		swerr->bits[i] = idxd->sw_err.bits[i];
+
+	*intcause |= IDXD_INTC_ERR;
+	if (genctrl->softerr_int_en)
+		vidxd_send_interrupt(&vidxd->irq_entries[0]);
+}
+
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq)
+{
+	struct vdcm_idxd *vidxd;
+
+	list_for_each_entry(vidxd, &wq->vdcm_list, list)
+		vidxd_send_errors(vidxd);
+}
diff --git a/drivers/vfio/mdev/idxd/vdev.h b/drivers/vfio/mdev/idxd/vdev.h
index fc0f405baa40..00df08f9a963 100644
--- a/drivers/vfio/mdev/idxd/vdev.h
+++ b/drivers/vfio/mdev/idxd/vdev.h
@@ -23,5 +23,6 @@ int vidxd_send_interrupt(struct ims_irq_entry *iie);
 int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd);
 void vidxd_free_ims_entries(struct vdcm_idxd *vidxd);
 void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val);
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq);
 
 #endif


