Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203632A0DD8
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgJ3Swu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:52:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:35263 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbgJ3Sws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:48 -0400
IronPort-SDR: yBzCYjpCKjaKTHOtDgB2KJWFsscKfdS+ibukx1R1m/ObbBrUNmkZtk+bV/pE2xiYWCux35AXUF
 qQXrwdubE3lQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="147937020"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="147937020"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:48 -0700
IronPort-SDR: CcqNTyjW675Bk6IYiyG6bHH0TCiyjC2KDKMqn8JT90vViBpjuOXPbj7xnLKUA1Q/aTu4zPtSY3
 2gdOHBnsw49Q==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="469608487"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:47 -0700
Subject: [PATCH v4 17/17] dmaengine: idxd: add error notification from host
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
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 30 Oct 2020 11:52:46 -0700
Message-ID: <160408396666.912050.13272769874427386756.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/dma/idxd/idxd.h |   12 ++++++++++++
 drivers/dma/idxd/irq.c  |    4 ++++
 drivers/dma/idxd/vdev.c |   32 ++++++++++++++++++++++++++++++++
 drivers/dma/idxd/vdev.h |    1 +
 4 files changed, 49 insertions(+)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 03275ad9e849..2f9e44bcd436 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -393,4 +393,16 @@ int idxd_mdev_host_init(struct idxd_device *idxd);
 void idxd_mdev_host_release(struct idxd_device *idxd);
 int idxd_mdev_get_pasid(struct mdev_device *mdev);
 
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
index a94fce00767b..9219dcf0a34d 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -137,6 +137,8 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 			if (wq->type == IDXD_WQT_USER)
 				wake_up_interruptible(&wq->idxd_cdev.err_queue);
+			else if (wq->type == IDXD_WQT_MDEV)
+				idxd_wq_vidxd_send_errors(wq);
 		} else {
 			int i;
 
@@ -145,6 +147,8 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 				if (wq->type == IDXD_WQT_USER)
 					wake_up_interruptible(&wq->idxd_cdev.err_queue);
+				else if (wq->type == IDXD_WQT_MDEV)
+					idxd_wq_vidxd_send_errors(wq);
 			}
 		}
 
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
index d61bc17624b9..fd42674490d6 100644
--- a/drivers/dma/idxd/vdev.c
+++ b/drivers/dma/idxd/vdev.c
@@ -942,3 +942,35 @@ void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
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
index d23e63eb7f43..98810ae95782 100644
--- a/drivers/dma/idxd/vdev.h
+++ b/drivers/dma/idxd/vdev.h
@@ -23,5 +23,6 @@ int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx);
 int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd);
 void vidxd_free_ims_entries(struct vdcm_idxd *vidxd);
 void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val);
+void idxd_wq_vidxd_send_errors(struct idxd_wq *wq);
 
 #endif


