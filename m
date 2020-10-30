Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B042A0E1B
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgJ3Swb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:52:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:56189 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgJ3Swa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:30 -0400
IronPort-SDR: 7DLXuMND1a8Kh351f0+mk051JOcQ/Pcitxa90weE01mjgO3WvOvqUIxxwy4nWQV/BiFpB81qko
 8H5dOyoDS0Gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="167868421"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="167868421"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:46 -0700
IronPort-SDR: wljAkm/RmAi+ReQrhytFmoF1qSKrwyD+ShKtCFX8Ps6kt5OZmxQcsvbZ2SQ0yBJsdAQQOYlZo2
 Cr65KqZ3lwvA==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="361933604"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:45 -0700
Subject: [PATCH v4 08/17] dmaengine: idxd: add device support functions in
 prep for mdev
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
Date:   Fri, 30 Oct 2020 11:51:44 -0700
Message-ID: <160408390489.912050.13504232395876662339.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add device support helper functions in preparation of adding VFIO
mdev support.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/device.c    |   61 ++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h      |    4 +++
 drivers/dma/idxd/registers.h |    3 +-
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index a9ae970db0a4..8aff07b1acb4 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -287,6 +287,30 @@ void idxd_wq_unmap_portal(struct idxd_wq *wq)
 	devm_iounmap(dev, wq->portal);
 }
 
+int idxd_wq_abort(struct idxd_wq *wq)
+{
+	struct idxd_device *idxd = wq->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand, status;
+
+	dev_dbg(dev, "Abort WQ %d\n", wq->id);
+	if (wq->state != IDXD_WQ_ENABLED) {
+		dev_dbg(dev, "WQ %d not active\n", wq->id);
+		return -ENXIO;
+	}
+
+	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
+	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_ABORT_WQ, operand);
+	idxd_cmd_exec(idxd, IDXD_CMD_ABORT_WQ, operand, &status);
+	if (status != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "WQ abort failed: %#x\n", status);
+		return -ENXIO;
+	}
+
+	dev_dbg(dev, "WQ %d aborted\n", wq->id);
+	return 0;
+}
+
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
 {
 	struct idxd_device *idxd = wq->idxd;
@@ -366,6 +390,32 @@ void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	}
 }
 
+void idxd_wq_setup_pasid(struct idxd_wq *wq, int pasid)
+{
+	struct idxd_device *idxd = wq->idxd;
+	int offset;
+
+	lockdep_assert_held(&idxd->dev_lock);
+
+	/* PASID fields are 8 bytes into the WQCFG register */
+	offset = WQCFG_OFFSET(idxd, wq->id, WQCFG_PASID_IDX);
+	wq->wqcfg->pasid = pasid;
+	iowrite32(wq->wqcfg->bits[WQCFG_PASID_IDX], idxd->reg_base + offset);
+}
+
+void idxd_wq_setup_priv(struct idxd_wq *wq, int priv)
+{
+	struct idxd_device *idxd = wq->idxd;
+	int offset;
+
+	lockdep_assert_held(&idxd->dev_lock);
+
+	/* priv field is 8 bytes into the WQCFG register */
+	offset = WQCFG_OFFSET(idxd, wq->id, WQCFG_PRIV_IDX);
+	wq->wqcfg->priv = !!priv;
+	iowrite32(wq->wqcfg->bits[WQCFG_PRIV_IDX], idxd->reg_base + offset);
+}
+
 /* Device control bits */
 static inline bool idxd_is_enabled(struct idxd_device *idxd)
 {
@@ -532,6 +582,17 @@ void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
 	dev_dbg(dev, "pasid %d drained\n", pasid);
 }
 
+void idxd_device_abort_pasid(struct idxd_device *idxd, int pasid)
+{
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand;
+
+	operand = pasid;
+	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_ABORT_PASID, operand);
+	idxd_cmd_exec(idxd, IDXD_CMD_ABORT_PASID, operand, NULL);
+	dev_dbg(dev, "pasid %d aborted\n", pasid);
+}
+
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
 				   enum idxd_interrupt_type irq_type)
 {
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 549426bfb443..eb8552d32a0a 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -331,6 +331,7 @@ void idxd_device_cleanup(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
+void idxd_device_abort_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
 				   enum idxd_interrupt_type irq_type);
@@ -348,6 +349,9 @@ void idxd_wq_unmap_portal(struct idxd_wq *wq);
 void idxd_wq_disable_cleanup(struct idxd_wq *wq);
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
 int idxd_wq_disable_pasid(struct idxd_wq *wq);
+int idxd_wq_abort(struct idxd_wq *wq);
+void idxd_wq_setup_pasid(struct idxd_wq *wq, int pasid);
+void idxd_wq_setup_priv(struct idxd_wq *wq, int priv);
 
 /* submission */
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc);
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index d02fd59a8e39..acc071df48eb 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -345,7 +345,8 @@ union wqcfg {
 	u32 bits[8];
 } __packed;
 
-#define WQCFG_PASID_IDX                2
+#define WQCFG_PASID_IDX		2
+#define WQCFG_PRIV_IDX		2
 
 /*
  * This macro calculates the offset into the WQCFG register


