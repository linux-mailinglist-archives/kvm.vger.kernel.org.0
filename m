Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099DE1B3358
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgDUXew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:34:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:48558 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbgDUXev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:34:51 -0400
IronPort-SDR: WhHJM5adF9msLUpJxVzlNVQMMpaBWVSv6yZaMqv8uWIOb2GOCC8IO5/LUXfloWyh0dtS3avXQo
 sDzT3GBJ3LvA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:34:50 -0700
IronPort-SDR: XkIbvsMu7UxsdfxuM7r4XqFx0YfeWv0LreNwYwu+n4gq+Gy8zDHcg+pzn2MIflGRBhUQf+3uzh
 hkQTfj2/rePg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="334433607"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2020 16:34:49 -0700
Subject: [PATCH RFC 10/15] dmaengine: idxd: add config support for readonly
 devices
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
Date:   Tue, 21 Apr 2020 16:34:49 -0700
Message-ID: <158751208922.36773.10261419272041374043.stgit@djiang5-desk3.ch.intel.com>
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

The device can have a readonly bit set for configuration. This especially
is true for mediated device in guest that are software emulated. Add
support to load configuration if the device config is read only.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/device.c |  159 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/dma/idxd/idxd.h   |    2 +
 drivers/dma/idxd/init.c   |    6 ++
 drivers/dma/idxd/sysfs.c  |   45 +++++++++----
 4 files changed, 194 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 684a0e167770..a46b6558984c 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -603,6 +603,36 @@ static int idxd_groups_config_write(struct idxd_device *idxd)
 	return 0;
 }
 
+static int idxd_wq_config_write_ro(struct idxd_wq *wq)
+{
+	struct idxd_device *idxd = wq->idxd;
+	int wq_offset;
+
+	if (!wq->group)
+		return 0;
+
+	if (idxd->pasid_enabled) {
+		wq->wqcfg.pasid_en = 1;
+		if (wq->type == IDXD_WQT_KERNEL && wq_dedicated(wq))
+			wq->wqcfg.pasid = idxd->pasid;
+	} else {
+		wq->wqcfg.pasid_en = 0;
+	}
+
+	if (wq->type == IDXD_WQT_KERNEL)
+		wq->wqcfg.priv = 1;
+
+	if (idxd->type == IDXD_TYPE_DSA &&
+	    idxd->hw.gen_cap.block_on_fault &&
+	    test_bit(WQ_FLAG_BOF, &wq->flags))
+		wq->wqcfg.bof = 1;
+
+	wq_offset = idxd->wqcfg_offset + wq->id * 32 + 2 * sizeof(u32);
+	iowrite32(wq->wqcfg.bits[2], idxd->reg_base + wq_offset);
+
+	return 0;
+}
+
 static int idxd_wq_config_write(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
@@ -633,7 +663,8 @@ static int idxd_wq_config_write(struct idxd_wq *wq)
 
 	if (idxd->pasid_enabled) {
 		wq->wqcfg.pasid_en = 1;
-		wq->wqcfg.pasid = idxd->pasid;
+		if (wq->type == IDXD_WQT_KERNEL && wq_dedicated(wq))
+			wq->wqcfg.pasid = idxd->pasid;
 	}
 
 	wq->wqcfg.priority = wq->priority;
@@ -658,14 +689,17 @@ static int idxd_wq_config_write(struct idxd_wq *wq)
 	return 0;
 }
 
-static int idxd_wqs_config_write(struct idxd_device *idxd)
+static int idxd_wqs_config_write(struct idxd_device *idxd, bool rw)
 {
 	int i, rc;
 
 	for (i = 0; i < idxd->max_wqs; i++) {
 		struct idxd_wq *wq = &idxd->wqs[i];
 
-		rc = idxd_wq_config_write(wq);
+		if (rw)
+			rc = idxd_wq_config_write(wq);
+		else
+			rc = idxd_wq_config_write_ro(wq);
 		if (rc < 0)
 			return rc;
 	}
@@ -764,6 +798,12 @@ static int idxd_wqs_setup(struct idxd_device *idxd)
 	return 0;
 }
 
+int idxd_device_ro_config(struct idxd_device *idxd)
+{
+	lockdep_assert_held(&idxd->dev_lock);
+	return idxd_wqs_config_write(idxd, false);
+}
+
 int idxd_device_config(struct idxd_device *idxd)
 {
 	int rc;
@@ -779,7 +819,7 @@ int idxd_device_config(struct idxd_device *idxd)
 
 	idxd_group_flags_setup(idxd);
 
-	rc = idxd_wqs_config_write(idxd);
+	rc = idxd_wqs_config_write(idxd, true);
 	if (rc < 0)
 		return rc;
 
@@ -789,3 +829,114 @@ int idxd_device_config(struct idxd_device *idxd)
 
 	return 0;
 }
+
+static void idxd_wq_load_config(struct idxd_wq *wq)
+{
+	struct idxd_device *idxd = wq->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	int wqcfg_offset;
+	int i;
+
+	wqcfg_offset = idxd->wqcfg_offset + wq->id * 32;
+	memcpy_fromio(&wq->wqcfg, idxd->reg_base + wqcfg_offset,
+		      sizeof(union wqcfg));
+
+	wq->size = wq->wqcfg.wq_size;
+	wq->threshold = wq->wqcfg.wq_thresh;
+	if (wq->wqcfg.priv)
+		wq->type = IDXD_WQT_KERNEL;
+
+	if (wq->wqcfg.mode)
+		set_bit(WQ_FLAG_DEDICATED, &wq->flags);
+
+	wq->priority = wq->wqcfg.priority;
+
+	if (wq->wqcfg.bof)
+		set_bit(WQ_FLAG_BOF, &wq->flags);
+
+	if (idxd->pasid_enabled) {
+		wq->wqcfg.pasid_en = 1;
+		wqcfg_offset = idxd->wqcfg_offset +
+			       wq->id * 32 + 2 * sizeof(u32);
+		iowrite32(wq->wqcfg.bits[2], idxd->reg_base + wqcfg_offset);
+	}
+
+	for (i = 0; i < 8; i++) {
+		wqcfg_offset = idxd->wqcfg_offset +
+			       wq->id * 32 + i * sizeof(u32);
+		dev_dbg(dev, "WQ[%d][%d][%#x]: %#x\n",
+			wq->id, i, wqcfg_offset, wq->wqcfg.bits[i]);
+	}
+}
+
+static void idxd_group_load_config(struct idxd_group *group)
+{
+	struct idxd_device *idxd = group->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	int i, j, grpcfg_offset;
+
+	/* load wqs */
+	for (i = 0; i < 4; i++) {
+		struct idxd_wq *wq;
+
+		grpcfg_offset = idxd->grpcfg_offset +
+				group->id * 64 + i * sizeof(u64);
+		group->grpcfg.wqs[i] =
+			ioread64(idxd->reg_base + grpcfg_offset);
+		dev_dbg(dev, "GRPCFG wq[%d:%d: %#x]: %#llx\n",
+			group->id, i, grpcfg_offset,
+			group->grpcfg.wqs[i]);
+
+		for (j = 0; j < sizeof(u64); j++) {
+			int wq_id = i * 64 + j;
+
+			if (wq_id >= idxd->max_wqs)
+				break;
+			if (group->grpcfg.wqs[i] & BIT(j)) {
+				wq = &idxd->wqs[wq_id];
+				wq->group = group;
+			}
+		}
+	}
+
+	grpcfg_offset = idxd->grpcfg_offset + group->id * 64 + 32;
+	group->grpcfg.engines = ioread64(idxd->reg_base + grpcfg_offset);
+	dev_dbg(dev, "GRPCFG engs[%d: %#x]: %#llx\n", group->id,
+		grpcfg_offset, group->grpcfg.engines);
+
+	for (i = 0; i < sizeof(u64); i++) {
+		if (i > idxd->max_engines)
+			break;
+		if (group->grpcfg.engines & BIT(i)) {
+			struct idxd_engine *engine = &idxd->engines[i];
+
+			engine->group = group;
+		}
+	}
+
+	grpcfg_offset = grpcfg_offset + group->id * 64 + 40;
+	group->grpcfg.flags.bits = ioread32(idxd->reg_base + grpcfg_offset);
+	dev_dbg(dev, "GRPFLAGS flags[%d: %#x]: %#x\n",
+		group->id, grpcfg_offset, group->grpcfg.flags.bits);
+}
+
+void idxd_device_load_config(struct idxd_device *idxd)
+{
+	union gencfg_reg reg;
+	int i;
+
+	reg.bits = ioread32(idxd->reg_base + IDXD_GENCFG_OFFSET);
+	idxd->token_limit = reg.token_limit;
+
+	for (i = 0; i < idxd->max_groups; i++) {
+		struct idxd_group *group = &idxd->groups[i];
+
+		idxd_group_load_config(group);
+	}
+
+	for (i = 0; i < idxd->max_wqs; i++) {
+		struct idxd_wq *wq = &idxd->wqs[i];
+
+		idxd_wq_load_config(wq);
+	}
+}
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 304b76169c0d..82a9b6035722 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -286,8 +286,10 @@ int idxd_device_reset(struct idxd_device *idxd);
 int __idxd_device_reset(struct idxd_device *idxd);
 void idxd_device_cleanup(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
+int idxd_device_ro_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 int idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
+void idxd_device_load_config(struct idxd_device *idxd);
 
 /* work queue control */
 int idxd_wq_alloc_resources(struct idxd_wq *wq);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index f794ee1c7c1b..c0fd796e9dce 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -367,6 +367,12 @@ static int idxd_probe(struct idxd_device *idxd)
 	if (rc)
 		goto err_setup;
 
+	/* If the configs are readonly, then load them from device */
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags)) {
+		dev_dbg(dev, "Loading RO device config\n");
+		idxd_device_load_config(idxd);
+	}
+
 	rc = idxd_setup_interrupts(idxd);
 	if (rc)
 		goto err_setup;
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index dc38172be42e..1dd3ade2e438 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -120,13 +120,17 @@ static int idxd_config_bus_probe(struct device *dev)
 
 		spin_lock_irqsave(&idxd->dev_lock, flags);
 
-		/* Perform IDXD configuration and enabling */
-		rc = idxd_device_config(idxd);
-		if (rc < 0) {
-			spin_unlock_irqrestore(&idxd->dev_lock, flags);
-			module_put(THIS_MODULE);
-			dev_warn(dev, "Device config failed: %d\n", rc);
-			return rc;
+		if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags)) {
+			/* Perform DSA configuration and enabling */
+			rc = idxd_device_config(idxd);
+			if (rc < 0) {
+				spin_unlock_irqrestore(&idxd->dev_lock,
+						       flags);
+				module_put(THIS_MODULE);
+				dev_warn(dev, "Device config failed: %d\n",
+					 rc);
+				return rc;
+			}
 		}
 
 		/* start device */
@@ -211,13 +215,26 @@ static int idxd_config_bus_probe(struct device *dev)
 		}
 
 		spin_lock_irqsave(&idxd->dev_lock, flags);
-		rc = idxd_device_config(idxd);
-		if (rc < 0) {
-			spin_unlock_irqrestore(&idxd->dev_lock, flags);
-			mutex_unlock(&wq->wq_lock);
-			dev_warn(dev, "Writing WQ %d config failed: %d\n",
-				 wq->id, rc);
-			return rc;
+		if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags)) {
+			rc = idxd_device_config(idxd);
+			if (rc < 0) {
+				spin_unlock_irqrestore(&idxd->dev_lock,
+						       flags);
+				mutex_unlock(&wq->wq_lock);
+				dev_warn(dev, "Writing WQ %d config failed: %d\n",
+					 wq->id, rc);
+				return rc;
+			}
+		} else {
+			rc = idxd_device_ro_config(idxd);
+			if (rc < 0) {
+				spin_unlock_irqrestore(&idxd->dev_lock,
+						       flags);
+				mutex_unlock(&wq->wq_lock);
+				dev_warn(dev, "Writing WQ %d config failed: %d\n",
+					 wq->id, rc);
+				return rc;
+			}
 		}
 
 		rc = idxd_wq_enable(wq);

