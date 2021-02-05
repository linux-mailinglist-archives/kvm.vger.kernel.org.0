Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631D93112DE
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 21:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhBETMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 14:12:36 -0500
Received: from mga17.intel.com ([192.55.52.151]:61557 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbhBETLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:11:46 -0500
IronPort-SDR: gsEoVXZASDEKW9dCeVSI0zZVi4G95fQJ/h/h/GE16XSJfbufKAGjo8+Yn1hs5107zV+/BpwR0s
 FsIShFR3f6mA==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="161241404"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="161241404"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:13 -0800
IronPort-SDR: WQo7t6UA6OS/eq/Jgf1sDDWOvVmnA2Nk9gHdyAJycQg/KlCybzaQhvmK9zrvo8ubBOkTS924/i
 UwXn2QJxvCmg==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434596858"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:12 -0800
Subject: [PATCH v5 03/14] dmaengine: idxd: add device support functions in
 prep for mdev
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
Date:   Fri, 05 Feb 2021 13:53:11 -0700
Message-ID: <161255839186.339900.4487176195680305351.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
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
index d6c447d09a6f..2491b27c8125 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -306,6 +306,30 @@ void idxd_wq_unmap_portal(struct idxd_wq *wq)
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
@@ -412,6 +436,32 @@ void idxd_wq_quiesce(struct idxd_wq *wq)
 	percpu_ref_exit(&wq->wq_active);
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
@@ -599,6 +649,17 @@ void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
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
index 90c9458903e1..a2438b3166db 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -350,6 +350,7 @@ void idxd_device_cleanup(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
+void idxd_device_abort_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
 				   enum idxd_interrupt_type irq_type);
@@ -369,6 +370,9 @@ int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
 int idxd_wq_disable_pasid(struct idxd_wq *wq);
 void idxd_wq_quiesce(struct idxd_wq *wq);
 int idxd_wq_init_percpu_ref(struct idxd_wq *wq);
+int idxd_wq_abort(struct idxd_wq *wq);
+void idxd_wq_setup_pasid(struct idxd_wq *wq, int pasid);
+void idxd_wq_setup_priv(struct idxd_wq *wq, int priv);
 
 /* submission */
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc);
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index c97f700bcf34..d9a732decdd5 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -347,7 +347,8 @@ union wqcfg {
 	u32 bits[8];
 } __packed;
 
-#define WQCFG_PASID_IDX                2
+#define WQCFG_PASID_IDX		2
+#define WQCFG_PRIV_IDX		2
 
 /*
  * This macro calculates the offset into the WQCFG register


