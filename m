Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D6D311317
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 22:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhBEVHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 16:07:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:37623 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhBETMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:12:09 -0500
IronPort-SDR: zWX+fy1q9AkGWedxHdQ8t4i3PjbTkmX5a7a/CpIBSnSgwNGQU6nIBUGlrmmpdqieXjIX3g/dnE
 rnSQ7gVEnUOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="181551568"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="181551568"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:52 -0800
IronPort-SDR: 5m9HgDclL4za8ezeMzEDad1ZEJ9kYRjw0ozQzEwzoEWELybEC3CkqFi3e2/qB/g8VUpM5qcPNV
 PVEoG8Yusi9Q==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="373513429"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:51 -0800
Subject: [PATCH v5 09/14] vfio/mdev: idxd: prep for virtual device commands
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
Date:   Fri, 05 Feb 2021 13:53:50 -0700
Message-ID: <161255843037.339900.11011951029875473128.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/dma/idxd/cdev.c       |    2 +
 drivers/dma/idxd/device.c     |   69 +++++++++++++++++++++++++++--------------
 drivers/dma/idxd/idxd.h       |    8 ++---
 drivers/dma/idxd/irq.c        |    2 +
 drivers/dma/idxd/sysfs.c      |    8 ++---
 drivers/vfio/mdev/idxd/mdev.c |    2 +
 6 files changed, 56 insertions(+), 35 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index b1518106434f..f46328ba8493 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -160,7 +160,7 @@ static int idxd_cdev_release(struct inode *node, struct file *filep)
 			if (rc < 0)
 				dev_err(dev, "wq disable pasid failed.\n");
 		} else {
-			idxd_wq_drain(wq);
+			idxd_wq_drain(wq, NULL);
 		}
 	}
 
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 89fa2bbe6ebf..245d576ddc43 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -216,22 +216,25 @@ void idxd_wq_free_resources(struct idxd_wq *wq)
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
 
@@ -240,11 +243,11 @@ int idxd_wq_enable(struct idxd_wq *wq)
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
 
@@ -254,10 +257,13 @@ int idxd_wq_disable(struct idxd_wq *wq)
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
 
@@ -267,20 +273,31 @@ int idxd_wq_disable(struct idxd_wq *wq)
 }
 EXPORT_SYMBOL_GPL(idxd_wq_disable);
 
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
@@ -307,11 +324,11 @@ void idxd_wq_unmap_portal(struct idxd_wq *wq)
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
@@ -321,9 +338,13 @@ int idxd_wq_abort(struct idxd_wq *wq)
 
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
 
@@ -339,7 +360,7 @@ int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
 	unsigned int offset;
 	unsigned long flags;
 
-	rc = idxd_wq_disable(wq);
+	rc = idxd_wq_disable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -351,7 +372,7 @@ int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
 	iowrite32(wqcfg.bits[WQCFG_PASID_IDX], idxd->reg_base + offset);
 	spin_unlock_irqrestore(&idxd->dev_lock, flags);
 
-	rc = idxd_wq_enable(wq);
+	rc = idxd_wq_enable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -366,7 +387,7 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 	unsigned int offset;
 	unsigned long flags;
 
-	rc = idxd_wq_disable(wq);
+	rc = idxd_wq_disable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
@@ -378,7 +399,7 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 	iowrite32(wqcfg.bits[WQCFG_PASID_IDX], idxd->reg_base + offset);
 	spin_unlock_irqrestore(&idxd->dev_lock, flags);
 
-	rc = idxd_wq_enable(wq);
+	rc = idxd_wq_enable(wq, NULL);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 67428c8d476d..41eee987c9b7 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -376,9 +376,9 @@ int idxd_device_release_int_handle(struct idxd_device *idxd, int handle,
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
@@ -386,7 +386,7 @@ int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
 int idxd_wq_disable_pasid(struct idxd_wq *wq);
 void idxd_wq_quiesce(struct idxd_wq *wq);
 int idxd_wq_init_percpu_ref(struct idxd_wq *wq);
-int idxd_wq_abort(struct idxd_wq *wq);
+int idxd_wq_abort(struct idxd_wq *wq, u32 *status);
 void idxd_wq_setup_pasid(struct idxd_wq *wq, int pasid);
 void idxd_wq_setup_priv(struct idxd_wq *wq, int priv);
 
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index a60ca11a5784..090926856df3 100644
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
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index d985a0ac23d9..913ff019fe36 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -189,7 +189,7 @@ static int enable_wq(struct idxd_wq *wq)
 		return rc;
 	}
 
-	rc = idxd_wq_enable(wq);
+	rc = idxd_wq_enable(wq, NULL);
 	if (rc < 0) {
 		mutex_unlock(&wq->wq_lock);
 		dev_warn(dev, "WQ %d enabling failed: %d\n", wq->id, rc);
@@ -199,7 +199,7 @@ static int enable_wq(struct idxd_wq *wq)
 	rc = idxd_wq_map_portal(wq);
 	if (rc < 0) {
 		dev_warn(dev, "wq portal mapping failed: %d\n", rc);
-		rc = idxd_wq_disable(wq);
+		rc = idxd_wq_disable(wq, NULL);
 		if (rc < 0)
 			dev_warn(dev, "IDXD wq disable failed\n");
 		mutex_unlock(&wq->wq_lock);
@@ -321,8 +321,8 @@ static void disable_wq(struct idxd_wq *wq)
 
 	idxd_wq_unmap_portal(wq);
 
-	idxd_wq_drain(wq);
-	rc = idxd_wq_disable(wq);
+	idxd_wq_drain(wq, NULL);
+	rc = idxd_wq_disable(wq, NULL);
 
 	idxd_wq_free_resources(wq);
 	wq->client_count = 0;
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 7529396f3812..67e6b33468cd 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -117,7 +117,7 @@ static void idxd_vdcm_init(struct vdcm_idxd *vidxd)
 	vidxd_mmio_init(vidxd);
 
 	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED)
-		idxd_wq_disable(wq);
+		idxd_wq_disable(wq, NULL);
 }
 
 static void idxd_vdcm_release(struct mdev_device *mdev)


