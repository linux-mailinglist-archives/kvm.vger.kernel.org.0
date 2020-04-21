Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A96C1B3361
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgDUXfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:35:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:34876 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgDUXfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:35:04 -0400
IronPort-SDR: z4fLPTsfZeKPfTktkvj75Qo3QZ7L0MM4EqbE1UMmSG73qvLa/stNObnCVIcPwfAblHGQK6Uc1v
 n8fc+2QGpzGA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:35:03 -0700
IronPort-SDR: e8IXMnwcVy9R7z/Z76DjhLiCt+m694yLoHh2Wh79Jq5CoUJZXiQOn11QrwRKUR0T7U3sR9pjtg
 JhCdYIHWfNzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="255449685"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga003.jf.intel.com with ESMTP; 21 Apr 2020 16:35:02 -0700
Subject: [PATCH RFC 12/15] dmaengine: idxd: add device support functions in
 prep for mdev
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
Date:   Tue, 21 Apr 2020 16:35:02 -0700
Message-ID: <158751210234.36773.5978383376123318481.stgit@djiang5-desk3.ch.intel.com>
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

Add some device support helper functions that will be used by VFIO mediated
device in preparation of adding VFIO mdev support.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/device.c |  130 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h   |    7 ++
 drivers/dma/idxd/init.c   |   19 +++++++
 3 files changed, 156 insertions(+)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index a46b6558984c..830aa5859646 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -319,6 +319,40 @@ void idxd_wq_unmap_portal(struct idxd_wq *wq)
 	devm_iounmap(dev, wq->portal);
 }
 
+int idxd_wq_abort(struct idxd_wq *wq)
+{
+	int rc;
+	struct idxd_device *idxd = wq->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand, status;
+
+	lockdep_assert_held(&idxd->dev_lock);
+
+	dev_dbg(dev, "Abort WQ %d\n", wq->id);
+	if (wq->state != IDXD_WQ_ENABLED) {
+		dev_dbg(dev, "WQ %d not active\n", wq->id);
+		return -ENXIO;
+	}
+
+	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
+	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_ABORT_WQ, operand);
+	rc = idxd_cmd_send(idxd, IDXD_CMD_ABORT_WQ, operand);
+	if (rc < 0)
+		return rc;
+
+	rc = idxd_cmd_wait(idxd, &status, IDXD_DRAIN_TIMEOUT);
+	if (rc < 0)
+		return rc;
+
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
@@ -372,6 +406,66 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 	return 0;
 }
 
+void idxd_wq_update_pasid(struct idxd_wq *wq, int pasid)
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
+void idxd_wq_update_priv(struct idxd_wq *wq, int priv)
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
+int idxd_wq_drain(struct idxd_wq *wq)
+{
+	int rc;
+	struct idxd_device *idxd = wq->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand, status;
+
+	lockdep_assert_held(&idxd->dev_lock);
+
+	dev_dbg(dev, "Drain WQ %d\n", wq->id);
+	if (wq->state != IDXD_WQ_ENABLED) {
+		dev_dbg(dev, "WQ %d not active\n", wq->id);
+		return -ENXIO;
+	}
+
+	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
+	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_DRAIN_WQ, operand);
+	rc = idxd_cmd_send(idxd, IDXD_CMD_DRAIN_WQ, operand);
+	if (rc < 0)
+		return rc;
+
+	rc = idxd_cmd_wait(idxd, &status, IDXD_DRAIN_TIMEOUT);
+	if (rc < 0)
+		return rc;
+
+	if (status != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "WQ drain failed: %#x\n", status);
+		return -ENXIO;
+	}
+
+	dev_dbg(dev, "WQ %d drained\n", wq->id);
+	return 0;
+}
+
 /* Device control bits */
 static inline bool idxd_is_enabled(struct idxd_device *idxd)
 {
@@ -542,6 +636,42 @@ int idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
 	return 0;
 }
 
+int idxd_device_request_int_handle(struct idxd_device *idxd, int idx,
+				   int *handle)
+{
+	int rc;
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand, status;
+
+	lockdep_assert_held(&idxd->dev_lock);
+
+	if (!idxd->hw.gen_cap.int_handle_req)
+		return -EOPNOTSUPP;
+
+	dev_dbg(dev, "get int handle, idx %d\n", idx);
+
+	operand = idx & 0xffff;
+	dev_dbg(dev, "cmd: %u operand: %#x\n",
+		IDXD_CMD_REQUEST_INT_HANDLE, operand);
+	rc = idxd_cmd_send(idxd, IDXD_CMD_REQUEST_INT_HANDLE, operand);
+	if (rc < 0)
+		return rc;
+
+	rc = idxd_cmd_wait(idxd, &status, IDXD_REG_TIMEOUT);
+	if (rc < 0)
+		return rc;
+
+	if (status != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "request int handle failed: %#x\n", status);
+		return -ENXIO;
+	}
+
+	*handle = (status >> 8) & 0xffff;
+
+	dev_dbg(dev, "int handle acquired: %u\n", *handle);
+	return 0;
+}
+
 /* Device configuration bits */
 static void idxd_group_config_write(struct idxd_group *group)
 {
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 3a942e9c5980..9b56a4c7f3fc 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -199,6 +199,7 @@ struct idxd_device {
 
 	atomic_t num_allocated_ims;
 	struct sbitmap ims_sbmap;
+	int *int_handles;
 };
 
 /* IDXD software descriptor */
@@ -303,6 +304,8 @@ int idxd_device_ro_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 int idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
 void idxd_device_load_config(struct idxd_device *idxd);
+int idxd_device_request_int_handle(struct idxd_device *idxd,
+				   int idx, int *handle);
 
 /* work queue control */
 int idxd_wq_alloc_resources(struct idxd_wq *wq);
@@ -313,6 +316,10 @@ int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
 int idxd_wq_disable_pasid(struct idxd_wq *wq);
+int idxd_wq_abort(struct idxd_wq *wq);
+void idxd_wq_update_pasid(struct idxd_wq *wq, int pasid);
+void idxd_wq_update_priv(struct idxd_wq *wq, int priv);
+int idxd_wq_drain(struct idxd_wq *wq);
 
 /* submission */
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc,
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 15b3ef73cac3..babe6e614087 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -56,6 +56,7 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 	int i, msixcnt;
 	int rc = 0;
 	union msix_perm mperm;
+	unsigned long flags;
 
 	msixcnt = pci_msix_vec_count(pdev);
 	if (msixcnt < 0) {
@@ -130,6 +131,17 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 		}
 		dev_dbg(dev, "Allocated idxd-msix %d for vector %d\n",
 			i, msix->vector);
+
+		if (idxd->hw.gen_cap.int_handle_req) {
+			spin_lock_irqsave(&idxd->dev_lock, flags);
+			rc = idxd_device_request_int_handle(idxd, i,
+							    &idxd->int_handles[i]);
+			spin_unlock_irqrestore(&idxd->dev_lock, flags);
+			if (rc < 0)
+				goto err_no_irq;
+			dev_dbg(dev, "int handle requested: %u\n",
+				idxd->int_handles[i]);
+		}
 	}
 
 	idxd_unmask_error_interrupts(idxd);
@@ -168,6 +180,13 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 	struct device *dev = &idxd->pdev->dev;
 	int i;
 
+	if (idxd->hw.gen_cap.int_handle_req) {
+		idxd->int_handles = devm_kcalloc(dev, idxd->max_wqs,
+						 sizeof(int), GFP_KERNEL);
+		if (!idxd->int_handles)
+			return -ENOMEM;
+	}
+
 	idxd->groups = devm_kcalloc(dev, idxd->max_groups,
 				    sizeof(struct idxd_group), GFP_KERNEL);
 	if (!idxd->groups)

