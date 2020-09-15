Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF1326B4B5
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 01:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgIOXae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 19:30:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:1337 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727413AbgIOX3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 19:29:24 -0400
IronPort-SDR: c5CYUpBXcMGvcRAcmH6DFwvTTrMRj3lo8uNT5xentpQbhb5cR+J7xvYE0UgH5UnZN8afLssxUR
 Ct0qgqsWbXqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="158647438"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="158647438"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:29:19 -0700
IronPort-SDR: Wi6xhsSDxbd+zDpjEtWs1fQNfQEstja/dGnHtkNTPfdWsa6cmNibpeaGPiTaUjBtABaEOx6EIO
 u6CZf5jHPtUQ==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="346035920"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:29:17 -0700
Subject: [PATCH v3 15/18] dmaengine: idxd: add error notification from host
 driver to mediated device
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 15 Sep 2020 16:29:17 -0700
Message-ID: <160021255739.67751.18063125769657114052.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/dma/idxd/idxd.h |   12 ++++++++++++
 drivers/dma/idxd/irq.c  |    4 ++++
 drivers/dma/idxd/vdev.c |   32 ++++++++++++++++++++++++++++++++
 drivers/dma/idxd/vdev.h |    1 +
 4 files changed, 49 insertions(+)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index f67c0036f968..07e1e3fcd4aa 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -359,4 +359,16 @@ void idxd_wq_del_cdev(struct idxd_wq *wq);
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
index 04f00255dae0..f9df0910b799 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -79,6 +79,8 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 			if (wq->type == IDXD_WQT_USER)
 				wake_up_interruptible(&wq->idxd_cdev.err_queue);
+			else if (wq->type == IDXD_WQT_MDEV)
+				idxd_wq_vidxd_send_errors(wq);
 		} else {
 			int i;
 
@@ -87,6 +89,8 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 				if (wq->type == IDXD_WQT_USER)
 					wake_up_interruptible(&wq->idxd_cdev.err_queue);
+				else if (wq->type == IDXD_WQT_MDEV)
+					idxd_wq_vidxd_send_errors(wq);
 			}
 		}
 
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
index fa7c27d746cc..ce2f19b9b860 100644
--- a/drivers/dma/idxd/vdev.c
+++ b/drivers/dma/idxd/vdev.c
@@ -978,3 +978,35 @@ void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
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
+
+	if (swerr->valid) {
+		if (!swerr->overflow)
+			swerr->overflow = 1;
+		return;
+	}
+
+	lockdep_assert_held(&idxd->dev_lock);
+	for (i = 0; i < 4; i++) {
+		swerr->bits[i] = idxd->sw_err.bits[i];
+		swerr++;
+	}
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
index e04c92c432d8..1bfdcdeed8e7 100644
--- a/drivers/dma/idxd/vdev.h
+++ b/drivers/dma/idxd/vdev.h
@@ -25,5 +25,6 @@ int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx);
 void vidxd_free_ims_entries(struct vdcm_idxd *vidxd);
 int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd);
 void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val);
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq);
 
 #endif

