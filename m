Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8FB2A0DD3
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgJ3Swd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:52:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:23396 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgJ3Swa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:30 -0400
IronPort-SDR: PfNxLOU0V84g5SakC6Qwcs6TZkxnK4SkC5RMA/stYPD5c1t4Pl06p8Chkmsq/hSwm0gmhaQUNR
 qegsAmUZGDlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="186464563"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="186464563"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:07 -0700
IronPort-SDR: +OhzfTUwoK3R6uaRRaSVUb38ye7Zbv/o732paXxR0zFqFO8ExjdCAmq3ZeEgEMKdhdN0cbPpMp
 iehYvDAtSHXw==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="469608347"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:06 -0700
Subject: [PATCH v4 11/17] dmaengine: idxd: prep for virtual device commands
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
Date:   Fri, 30 Oct 2020 11:52:06 -0700
Message-ID: <160408392598.912050.13058651162025112198.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update some of the device commands in order to support usage by the virtual
device commands emulated by the vdcm. Expose some of the commands' raw
status so the virtual commands can utilize them accordingly.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/cdev.c   |    2 +
 drivers/dma/idxd/device.c |   69 +++++++++++++++++++++++++++++----------------
 drivers/dma/idxd/idxd.h   |    8 +++--
 drivers/dma/idxd/irq.c    |    2 +
 drivers/dma/idxd/mdev.c   |    2 +
 drivers/dma/idxd/sysfs.c  |    8 +++--
 6 files changed, 56 insertions(+), 35 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index b774bf336347..1f504d1f0c42 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -159,7 +159,7 @@ static int idxd_cdev_release(struct inode *node, struct file *filep)
 			if (rc < 0)
 				dev_err(dev, "wq disable pasid failed.\n");
 		} else {
-			idxd_wq_drain(wq);
+			idxd_wq_drain(wq, NULL);
 		}
 	}
 
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 8aff07b1acb4..52fc8e64c5fc 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -197,22 +197,25 @@ void idxd_wq_free_resources(struct idxd_wq *wq)
 	sbitmap_queue_free(&wq->sbq);
 }
 
-int idxd_wq_enable(struct idxd_wq *wq)
+int idxd_wq_enable(struct idxd_wq *wq, u32 *status)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	u32 status;
+	u32 stat;
 
 	if (wq->state == IDXD_WQ_ENABLED) {
 		dev_dbg(dev, "WQ %d already enabled\n", wq->id);
 		return -ENXIO;
 	}
 
-	idxd_cmd_exec(idxd, IDXD_CMD_ENABLE_WQ, wq->id, &status);
+	idxd_cmd_exec(idxd, IDXD_CMD_ENABLE_WQ, wq->id, &stat);
 
-	if (status != IDXD_CMDSTS_SUCCESS &&
-	    status != IDXD_CMDSTS_ERR_WQ_ENABLED) {
-		dev_dbg(dev, "WQ enable failed: %#x\n", status);
+	if (status)
+		*status = stat;
+
+	if (stat != IDXD_CMDSTS_SUCCESS &&
+	    stat != IDXD_CMDSTS_ERR_WQ_ENABLED) {
+		dev_dbg(dev, "WQ enable failed: %#x\n", stat);
 		return -ENXIO;
 	}
 
@@ -221,11 +224,11 @@ int idxd_wq_enable(struct idxd_wq *wq)
 	return 0;
 }
 
-int idxd_wq_disable(struct idxd_wq *wq)
+int idxd_wq_disable(struct idxd_wq *wq, u32 *status)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	u32 status, operand;
+	u32 stat, operand;
 
 	dev_dbg(dev, "Disabling WQ %d\n", wq->id);
 
@@ -235,10 +238,13 @@ int idxd_wq_disable(struct idxd_wq *wq)
 	}
 
 	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
-	idxd_cmd_exec(idxd, IDXD_CMD_DISABLE_WQ, operand, &status);
+	idxd_cmd_exec(idxd, IDXD_CMD_DISABLE_WQ, operand, &stat);
+
+	if (status)
+		*status = stat;
 
-	if (status != IDXD_CMDSTS_SUCCESS) {
-		dev_dbg(dev, "WQ disable failed: %#x\n", status);
+	if (stat != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "WQ disable failed: %#x\n", stat);
 		return -ENXIO;
 	}
 
@@ -247,20 +253,31 @@ int idxd_wq_disable(struct idxd_wq *wq)
 	return 0;
 }
 
-void idxd_wq_drain(struct idxd_wq *wq)
+int idxd_wq_drain(struct idxd_wq *wq, u32 *status)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	u32 operand;
+	u32 operand, stat;
 
 	if (wq->state != IDXD_WQ_ENABLED) {
 		dev_dbg(dev, "WQ %d in wrong state: %d\n", wq->id, wq->state);
-		return;
+		return 0;
 	}
 
 	dev_dbg(dev, "Draining WQ %d\n", wq->id);
 	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
-	idxd_cmd_exec(idxd, IDXD_CMD_DRAIN_WQ, operand, NULL);
+	idxd_cmd_exec(idxd, IDXD_CMD_DRAIN_WQ, operand, &stat);
+
+	if (status)
+		*status = stat;
+
+	if (stat != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "WQ drain failed: %#x\n", stat);
+		return -ENXIO;
+	}
+
+	dev_dbg(dev, "WQ %d drained\n", wq->id);
+	return 0;
 }
 
 int idxd_wq_map_portal(struct idxd_wq *wq)
@@ -287,11 +304,11 @@ void idxd_wq_unmap_portal(struct idxd_wq *wq)
 	devm_iounmap(dev, wq->portal);
 }
 
-int idxd_wq_abort(struct idxd_wq *wq)
+int idxd_wq_abort(struct idxd_wq *wq, u32 *status)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	u32 operand, status;
+	u32 operand, stat;
 
 	dev_dbg(dev, "Abort WQ %d\n", wq->id);
 	if (wq->state != IDXD_WQ_ENABLED) {
@@ -301,9 +318,13 @@ int idxd_wq_abort(struct idxd_wq *wq)
 
 	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
 	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_ABORT_WQ, operand);
-	idxd_cmd_exec(idxd, IDXD_CMD_ABORT_WQ, operand, &status);
-	if (status != IDXD_CMDSTS_SUCCESS) {
-		dev_dbg(dev, "WQ abort failed: %#x\n", status);
+	idxd_cmd_exec(idxd, IDXD_CMD_ABORT_WQ, operand, &stat);
+
+	if (status)
+		*status = stat;
+
+	if (stat != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "WQ abort failed: %#x\n", stat);
 		return -ENXIO;
 	}
 
@@ -319,7 +340,7 @@ int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
 	unsigned int offset;
 	unsigned long flags;
 
-	rc = idxd_wq_disable(wq);
+	rc = idxd_wq_disable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -331,7 +352,7 @@ int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
 	iowrite32(wqcfg.bits[WQCFG_PASID_IDX], idxd->reg_base + offset);
 	spin_unlock_irqrestore(&idxd->dev_lock, flags);
 
-	rc = idxd_wq_enable(wq);
+	rc = idxd_wq_enable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -346,7 +367,7 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 	unsigned int offset;
 	unsigned long flags;
 
-	rc = idxd_wq_disable(wq);
+	rc = idxd_wq_disable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -358,7 +379,7 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 	iowrite32(wqcfg.bits[WQCFG_PASID_IDX], idxd->reg_base + offset);
 	spin_unlock_irqrestore(&idxd->dev_lock, flags);
 
-	rc = idxd_wq_enable(wq);
+	rc = idxd_wq_enable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index ab28a1bffb7c..e616d18b53c0 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -350,15 +350,15 @@ int idxd_device_release_int_handle(struct idxd_device *idxd, int handle,
 /* work queue control */
 int idxd_wq_alloc_resources(struct idxd_wq *wq);
 void idxd_wq_free_resources(struct idxd_wq *wq);
-int idxd_wq_enable(struct idxd_wq *wq);
-int idxd_wq_disable(struct idxd_wq *wq);
-void idxd_wq_drain(struct idxd_wq *wq);
+int idxd_wq_enable(struct idxd_wq *wq, u32 *status);
+int idxd_wq_disable(struct idxd_wq *wq, u32 *status);
+int idxd_wq_drain(struct idxd_wq *wq, u32 *status);
 int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
 void idxd_wq_disable_cleanup(struct idxd_wq *wq);
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
 int idxd_wq_disable_pasid(struct idxd_wq *wq);
-int idxd_wq_abort(struct idxd_wq *wq);
+int idxd_wq_abort(struct idxd_wq *wq, u32 *status);
 void idxd_wq_setup_pasid(struct idxd_wq *wq, int pasid);
 void idxd_wq_setup_priv(struct idxd_wq *wq, int priv);
 
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 593a2f6ed16c..a94fce00767b 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -48,7 +48,7 @@ static void idxd_device_reinit(struct work_struct *work)
 		struct idxd_wq *wq = &idxd->wqs[i];
 
 		if (wq->state == IDXD_WQ_ENABLED) {
-			rc = idxd_wq_enable(wq);
+			rc = idxd_wq_enable(wq, NULL);
 			if (rc < 0) {
 				dev_warn(dev, "Unable to re-enable wq %s\n",
 					 dev_name(&wq->conf_dev));
diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
index 3b6febe22a0e..91270121dfbc 100644
--- a/drivers/dma/idxd/mdev.c
+++ b/drivers/dma/idxd/mdev.c
@@ -85,7 +85,7 @@ static void idxd_vdcm_init(struct vdcm_idxd *vidxd)
 	vidxd_mmio_init(vidxd);
 
 	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED)
-		idxd_wq_disable(wq);
+		idxd_wq_disable(wq, NULL);
 }
 
 static void idxd_vdcm_release(struct mdev_device *mdev)
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 17f13ebae028..fe5f95509c5c 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -218,7 +218,7 @@ static int idxd_config_bus_probe(struct device *dev)
 			return rc;
 		}
 
-		rc = idxd_wq_enable(wq);
+		rc = idxd_wq_enable(wq, NULL);
 		if (rc < 0) {
 			mutex_unlock(&wq->wq_lock);
 			dev_warn(dev, "WQ %d enabling failed: %d\n",
@@ -229,7 +229,7 @@ static int idxd_config_bus_probe(struct device *dev)
 		rc = idxd_wq_map_portal(wq);
 		if (rc < 0) {
 			dev_warn(dev, "wq portal mapping failed: %d\n", rc);
-			rc = idxd_wq_disable(wq);
+			rc = idxd_wq_disable(wq, NULL);
 			if (rc < 0)
 				dev_warn(dev, "IDXD wq disable failed\n");
 			mutex_unlock(&wq->wq_lock);
@@ -287,8 +287,8 @@ static void disable_wq(struct idxd_wq *wq)
 
 	idxd_wq_unmap_portal(wq);
 
-	idxd_wq_drain(wq);
-	rc = idxd_wq_disable(wq);
+	idxd_wq_drain(wq, NULL);
+	rc = idxd_wq_disable(wq, NULL);
 
 	idxd_wq_free_resources(wq);
 	wq->client_count = 0;


