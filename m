Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4A31B3365
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgDUXfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:35:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:39205 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgDUXfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:35:17 -0400
IronPort-SDR: oWe5K7SBdwNh0+W1YYGoSMcsxrfr/ZBVR3DM96VBH47FlffjuDyP2EF5S1wTFPlD4bVJadP6ZW
 +0jgvWAIsZYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:35:17 -0700
IronPort-SDR: L7TUKFuOs0nA+TAwy+KcP+IKm9U25fgE1ivpraZI9cf7sTYIE5bXfqOUI9KapnOd2y84/lpQB4
 tirC60FDpeFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="258876602"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2020 16:35:15 -0700
Subject: [PATCH RFC 14/15] dmaengine: idxd: add error notification from host
 driver to mediated device
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Apr 2020 16:35:15 -0700
Message-ID: <158751211522.36773.1692028393873153808.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
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
---
 drivers/dma/idxd/idxd.h |    2 ++
 drivers/dma/idxd/irq.c  |    4 ++++
 drivers/dma/idxd/vdev.c |   33 +++++++++++++++++++++++++++++++++
 drivers/dma/idxd/vdev.h |    1 +
 4 files changed, 40 insertions(+)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 92a9718daa15..651196514ad5 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -362,5 +362,7 @@ void idxd_wq_del_cdev(struct idxd_wq *wq);
 /* mdev */
 int idxd_mdev_host_init(struct idxd_device *idxd);
 void idxd_mdev_host_release(struct idxd_device *idxd);
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq);
+void idxd_vidxd_send_errors(struct idxd_device *idxd);
 
 #endif
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index bc634dc4e485..256ef7d8a5c9 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -167,6 +167,8 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 			if (wq->type == IDXD_WQT_USER)
 				wake_up_interruptible(&wq->idxd_cdev.err_queue);
+			else if (wq->type == IDXD_WQT_MDEV)
+				idxd_wq_vidxd_send_errors(wq);
 		} else {
 			int i;
 
@@ -175,6 +177,8 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 				if (wq->type == IDXD_WQT_USER)
 					wake_up_interruptible(&wq->idxd_cdev.err_queue);
+				else if (wq->type == IDXD_WQT_MDEV)
+					idxd_vidxd_send_errors(idxd);
 			}
 		}
 
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
index d2a15f1dae6a..83985f0a336e 100644
--- a/drivers/dma/idxd/vdev.c
+++ b/drivers/dma/idxd/vdev.c
@@ -568,3 +568,36 @@ int vidxd_free_ims_entry(struct vdcm_idxd *vidxd, int msix_idx)
 {
 	return 0;
 }
+
+static void vidxd_send_errors(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	struct vdcm_idxd_pci_bar0 *bar0 = &vidxd->bar0;
+	u64 *swerr = (u64 *)&bar0->cap_ctrl_regs[IDXD_SWERR_OFFSET];
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		*swerr = idxd->sw_err.bits[i];
+		swerr++;
+	}
+	vidxd_send_interrupt(vidxd, 0);
+}
+
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq)
+{
+	struct vdcm_idxd *vidxd;
+
+	list_for_each_entry(vidxd, &wq->vdcm_list, list)
+		vidxd_send_errors(vidxd);
+}
+
+void idxd_vidxd_send_errors(struct idxd_device *idxd)
+{
+	int i;
+
+	for (i = 0; i < idxd->max_wqs; i++) {
+		struct idxd_wq *wq = &idxd->wqs[i];
+
+		idxd_wq_vidxd_send_errors(wq);
+	}
+}
diff --git a/drivers/dma/idxd/vdev.h b/drivers/dma/idxd/vdev.h
index 3dfff6d0f641..14c6631e670c 100644
--- a/drivers/dma/idxd/vdev.h
+++ b/drivers/dma/idxd/vdev.h
@@ -38,5 +38,6 @@ int vidxd_setup_ims_entry(struct vdcm_idxd *vidxd, int ims_idx, u32 val);
 int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx);
 void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val);
 void vidxd_reset(struct vdcm_idxd *vidxd);
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq);
 
 #endif

