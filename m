Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C20622849E
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgGUQDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:03:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:5374 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbgGUQDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:03:11 -0400
IronPort-SDR: 1tC4jcURO/5EA5m326zKKKMVORHDAvpiyK2ky8j4dbDFSyqwpc1ZrkS2/C/StobG1JNZFHrdIX
 fuM7ldvObc4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="138252508"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="138252508"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:03:09 -0700
IronPort-SDR: /pjMsLIxKcWsy/wn5atmSOoFzSeBxOeyT/vCygbm1+GDCi5YJ0eKbF6XHsOu13smUjm15HgFNj
 DWG3BMtxOP3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="462124823"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga005.jf.intel.com with ESMTP; 21 Jul 2020 09:03:07 -0700
Subject: [PATCH RFC v2 08/18] dmaengine: idxd: add device support functions
 in prep for mdev
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
Date:   Tue, 21 Jul 2020 09:03:07 -0700
Message-ID: <159534738747.28840.9497901333645332923.stgit@djiang5-desk3.ch.intel.com>
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

Add device support helper functions in preparation of adding VFIO
mdev support.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/dma/idxd/device.c |   61 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h   |    4 +++
 2 files changed, 65 insertions(+)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 2b4e8ab99ebd..7443ffb5d3c3 100644
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
+	offset = idxd->wqcfg_offset + wq->id * 32 + 8;
+	wq->wqcfg.pasid = pasid;
+	iowrite32(wq->wqcfg.bits[2], idxd->reg_base + offset);
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
+	offset = idxd->wqcfg_offset + wq->id * 32 + 8;
+	wq->wqcfg.priv = !!priv;
+	iowrite32(wq->wqcfg.bits[2], idxd->reg_base + offset);
+}
+
 /* Device control bits */
 static inline bool idxd_is_enabled(struct idxd_device *idxd)
 {
@@ -502,6 +552,17 @@ void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
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
 #define INT_HANDLE_IMS_TABLE	0x10000
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx,
 				   int *handle, enum idxd_interrupt_type irq_type)
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index c65fb6dcb7e0..438d6478a3f8 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -321,6 +321,7 @@ void idxd_device_cleanup(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
+void idxd_device_abort_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
 				   enum idxd_interrupt_type irq_type);
@@ -336,6 +337,9 @@ void idxd_wq_unmap_portal(struct idxd_wq *wq);
 void idxd_wq_disable_cleanup(struct idxd_wq *wq);
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
 int idxd_wq_disable_pasid(struct idxd_wq *wq);
+int idxd_wq_abort(struct idxd_wq *wq);
+void idxd_wq_setup_pasid(struct idxd_wq *wq, int pasid);
+void idxd_wq_setup_priv(struct idxd_wq *wq, int priv);
 
 /* submission */
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc);

