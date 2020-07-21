Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2EB22848D
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgGUQCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:02:52 -0400
Received: from mga05.intel.com ([192.55.52.43]:34926 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730139AbgGUQCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:02:50 -0400
IronPort-SDR: VaHCkGAyRyTc/2ttMVfUPkySBzE4l2OWzJ1HTE3e7caqUGqlW9Gz63rLZw/UgO1LEr9BWAfIfQ
 suRxC3Ug+aLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="235019033"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="235019033"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:02:49 -0700
IronPort-SDR: Pr+0KiI06VsmzTFBtydA++sP59+6WbfdU2s9RymrQVjldSt2RIZk/UHi89wCH+k5jAVy67tmpf
 tkjTncYuWumg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="318379489"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008.jf.intel.com with ESMTP; 21 Jul 2020 09:02:48 -0700
Subject: [PATCH RFC v2 05/18] dmaengine: idxd: add support for readonly
 config devices
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
Date:   Tue, 21 Jul 2020 09:02:47 -0700
Message-ID: <159534736793.28840.16449656707947316088.stgit@djiang5-desk3.ch.intel.com>
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

The VFIO mediated device for idxd driver will provide a virtual DSA
device by backing it with a workqueue. The virtual device will be limited
with the wq configuration registers set to read-only. Add support and
helper functions for the handling of a DSA device with the configuration
registers marked as read-only.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/dma/idxd/device.c |  116 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h   |    1 
 drivers/dma/idxd/init.c   |    8 +++
 drivers/dma/idxd/sysfs.c  |   21 +++++---
 4 files changed, 137 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 9032b50b31af..7531ed9c1b81 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -750,3 +750,119 @@ int idxd_device_config(struct idxd_device *idxd)
 
 	return 0;
 }
+
+static int idxd_wq_load_config(struct idxd_wq *wq)
+{
+	struct idxd_device *idxd = wq->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	int wqcfg_offset;
+	int i;
+
+	wqcfg_offset = idxd->wqcfg_offset + wq->id * 32;
+	memcpy_fromio(&wq->wqcfg, idxd->reg_base + wqcfg_offset, sizeof(union wqcfg));
+
+	wq->size = wq->wqcfg.wq_size;
+	wq->threshold = wq->wqcfg.wq_thresh;
+	if (wq->wqcfg.priv)
+		wq->type = IDXD_WQT_KERNEL;
+
+	/* The driver does not support shared WQ mode in read-only config yet */
+	if (wq->wqcfg.mode == 0 || wq->wqcfg.pasid_en)
+		return -EOPNOTSUPP;
+
+	set_bit(WQ_FLAG_DEDICATED, &wq->flags);
+
+	wq->priority = wq->wqcfg.priority;
+
+	for (i = 0; i < 8; i++) {
+		wqcfg_offset = idxd->wqcfg_offset + wq->id * 32 + i * sizeof(u32);
+		dev_dbg(dev, "WQ[%d][%d][%#x]: %#x\n",
+			wq->id, i, wqcfg_offset, wq->wqcfg.bits[i]);
+	}
+
+	return 0;
+}
+
+static void idxd_group_load_config(struct idxd_group *group)
+{
+	struct idxd_device *idxd = group->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	int i, j, grpcfg_offset;
+
+	/*
+	 * Load WQS bit fields
+	 * Iterate through all 256 bits 64 bits at a time
+	 */
+	for (i = 0; i < 4; i++) {
+		struct idxd_wq *wq;
+
+		grpcfg_offset = idxd->grpcfg_offset + group->id * 64 + i * sizeof(u64);
+		group->grpcfg.wqs[i] = ioread64(idxd->reg_base + grpcfg_offset);
+		dev_dbg(dev, "GRPCFG wq[%d:%d: %#x]: %#llx\n",
+			group->id, i, grpcfg_offset, group->grpcfg.wqs[i]);
+
+		if (i * 64 >= idxd->max_wqs)
+			break;
+
+		/* Iterate through all 64 bits and check for wq set */
+		for (j = 0; j < 64; j++) {
+			int id = i * 64 + j;
+
+			/* No need to check beyond max wqs */
+			if (id >= idxd->max_wqs)
+				break;
+
+			/* Set group assignment for wq if wq bit is set */
+			if (group->grpcfg.wqs[i] & BIT(j)) {
+				wq = &idxd->wqs[id];
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
+	for (i = 0; i < 64; i++) {
+		if (i >= idxd->max_engines)
+			break;
+
+		if (group->grpcfg.engines & BIT(i)) {
+			struct idxd_engine *engine = &idxd->engines[i];
+
+			engine->group = group;
+		}
+	}
+
+	grpcfg_offset = idxd->grpcfg_offset + group->id * 64 + 40;
+	group->grpcfg.flags.bits = ioread32(idxd->reg_base + grpcfg_offset);
+	dev_dbg(dev, "GRPFLAGS flags[%d: %#x]: %#x\n",
+		group->id, grpcfg_offset, group->grpcfg.flags.bits);
+}
+
+int idxd_device_load_config(struct idxd_device *idxd)
+{
+	union gencfg_reg reg;
+	int i, rc;
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
+		rc = idxd_wq_load_config(wq);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 518768885d7b..fcea8bc060f5 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -306,6 +306,7 @@ void idxd_device_cleanup(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
+int idxd_device_load_config(struct idxd_device *idxd);
 
 /* work queue control */
 int idxd_wq_alloc_resources(struct idxd_wq *wq);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index a7e1dbfcd173..50c68de6b4ab 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -344,6 +344,14 @@ static int idxd_probe(struct idxd_device *idxd)
 	if (rc)
 		goto err_setup;
 
+	/* If the configs are readonly, then load them from device */
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags)) {
+		dev_dbg(dev, "Loading RO device config\n");
+		rc = idxd_device_load_config(idxd);
+		if (rc < 0)
+			goto err_setup;
+	}
+
 	rc = idxd_setup_interrupts(idxd);
 	if (rc)
 		goto err_setup;
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 57ea94a0dc51..fa1abdf503c2 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -102,7 +102,7 @@ static int idxd_config_bus_match(struct device *dev,
 
 static int idxd_config_bus_probe(struct device *dev)
 {
-	int rc;
+	int rc = 0;
 	unsigned long flags;
 
 	dev_dbg(dev, "%s called\n", __func__);
@@ -120,7 +120,8 @@ static int idxd_config_bus_probe(struct device *dev)
 
 		/* Perform IDXD configuration and enabling */
 		spin_lock_irqsave(&idxd->dev_lock, flags);
-		rc = idxd_device_config(idxd);
+		if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+			rc = idxd_device_config(idxd);
 		spin_unlock_irqrestore(&idxd->dev_lock, flags);
 		if (rc < 0) {
 			module_put(THIS_MODULE);
@@ -207,7 +208,8 @@ static int idxd_config_bus_probe(struct device *dev)
 		}
 
 		spin_lock_irqsave(&idxd->dev_lock, flags);
-		rc = idxd_device_config(idxd);
+		if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+			rc = idxd_device_config(idxd);
 		spin_unlock_irqrestore(&idxd->dev_lock, flags);
 		if (rc < 0) {
 			mutex_unlock(&wq->wq_lock);
@@ -328,13 +330,14 @@ static int idxd_config_bus_remove(struct device *dev)
 
 		idxd_unregister_dma_device(idxd);
 		rc = idxd_device_disable(idxd);
+		if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags)) {
+			for (i = 0; i < idxd->max_wqs; i++) {
+				struct idxd_wq *wq = &idxd->wqs[i];
 
-		for (i = 0; i < idxd->max_wqs; i++) {
-			struct idxd_wq *wq = &idxd->wqs[i];
-
-			mutex_lock(&wq->wq_lock);
-			idxd_wq_disable_cleanup(wq);
-			mutex_unlock(&wq->wq_lock);
+				mutex_lock(&wq->wq_lock);
+				idxd_wq_disable_cleanup(wq);
+				mutex_unlock(&wq->wq_lock);
+			}
 		}
 
 		module_put(THIS_MODULE);

