Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590AA2284C2
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgGUQE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:04:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:60689 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730190AbgGUQEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:04:25 -0400
IronPort-SDR: BN+IzXx+bvOLUw5wa7acB/+Hm67ILI7AZDBXoVVTJxEmwYKQUoP3DV/MDUgzG3rMr20OH8WJpk
 GurFtnvQYNiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="129729280"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="129729280"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:04:09 -0700
IronPort-SDR: uIhYV1BtmBsDEUUu449cmsykJiDu6nAJjNvn9+pmdhgXkuSprKae7Mz27UljJwqINePgn6rjvW
 EvUZsaEQyTaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="270476704"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jul 2020 09:04:08 -0700
Subject: [PATCH RFC v2 17/18] dmaengine: idxd: add error notification from
 host driver to mediated device
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, jgg@mellanox.com,
        rafael@kernel.org, dave.hansen@intel.com, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Jul 2020 09:04:07 -0700
Message-ID: <159534744785.28840.7098006109300534327.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a device error occurs, the mediated device need to be notified in
order to notify the guest of device error. Add support to notify the
specific mdev when an error is wq specific and broadcast errors to all mdev
when it's a generic device error.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/dma/idxd/idxd.h |   12 ++++++++++++
 drivers/dma/idxd/irq.c  |    4 ++++
 drivers/dma/idxd/vdev.c |   34 ++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/vdev.h |    1 +
 4 files changed, 51 insertions(+)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index cc0665335aee..4a3947b84f20 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -377,4 +377,16 @@ void idxd_wq_del_cdev(struct idxd_wq *wq);
 int idxd_mdev_host_init(struct idxd_device *idxd);
 void idxd_mdev_host_release(struct idxd_device *idxd);
 
+#ifdef CONFIG_INTEL_IDXD_MDEV
+void idxd_vidxd_send_errors(struct idxd_device *idxd);
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq);
+#else
+static inline void idxd_vidxd_send_errors(struct idxd_device *idxd)
+{
+}
+static inline void idxd_wq_vidxd_send_errors(struct idxd_wq *wq)
+{
+}
+#endif /* CONFIG_INTEL_IDXD_MDEV */
+
 #endif
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index c818acb34a14..32e59ba85cd0 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -148,6 +148,8 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 			if (wq->type == IDXD_WQT_USER)
 				wake_up_interruptible(&wq->idxd_cdev.err_queue);
+			else if (wq->type == IDXD_WQT_MDEV)
+				idxd_wq_vidxd_send_errors(wq);
 		} else {
 			int i;
 
@@ -156,6 +158,8 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 				if (wq->type == IDXD_WQT_USER)
 					wake_up_interruptible(&wq->idxd_cdev.err_queue);
+				else if (wq->type == IDXD_WQT_MDEV)
+					idxd_wq_vidxd_send_errors(wq);
 			}
 		}
 
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
index 66e59cb02635..d87c5355e0cb 100644
--- a/drivers/dma/idxd/vdev.c
+++ b/drivers/dma/idxd/vdev.c
@@ -926,3 +926,37 @@ void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
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
+	int i;
+	unsigned long flags;
+
+	if (swerr->valid) {
+		if (!swerr->overflow)
+			swerr->overflow = 1;
+		return;
+	}
+
+	spin_lock_irqsave(&idxd->dev_lock, flags);
+	for (i = 0; i < 4; i++) {
+		swerr->bits[i] = idxd->sw_err.bits[i];
+		swerr++;
+	}
+	spin_unlock_irqrestore(&idxd->dev_lock, flags);
+
+	if (genctrl->softerr_int_en)
+		vidxd_send_interrupt(vidxd, 0);
+}
+
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq)
+{
+	struct vdcm_idxd *vidxd;
+
+	list_for_each_entry(vidxd, &wq->vdcm_list, list)
+		vidxd_send_errors(vidxd);
+}
diff --git a/drivers/dma/idxd/vdev.h b/drivers/dma/idxd/vdev.h
index 2dc8d22d3ea7..8ba7cbdb7e8b 100644
--- a/drivers/dma/idxd/vdev.h
+++ b/drivers/dma/idxd/vdev.h
@@ -23,5 +23,6 @@ int vidxd_disable_host_ims_pasid(struct vdcm_idxd *vidxd, int ims_idx);
 int vidxd_enable_host_ims_pasid(struct vdcm_idxd *vidxd, int ims_idx);
 int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx);
 void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val);
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq);
 
 #endif

