Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ABC2A0DF0
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgJ3SxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:53:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:20436 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727660AbgJ3SxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:53:23 -0400
IronPort-SDR: uK2Pl6nZCymJBNIz5WnbblBcDVz6RWtqkKH/wYOhgJj8pZdpVnruWjxZh+dL8dfuamS1UFeW/E
 n3IwzspOsH2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="253357844"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="253357844"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:20 -0700
IronPort-SDR: 2aNGAojTYt3r+B1DPzIvQTYVxJBY0KYxNv3I+SYVqwvnXbKprodQgshAfE1YipyQZK1bRijD6k
 HXP7YP8US8/A==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="324168078"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:16 -0700
Subject: [PATCH v4 04/17] dmaengine: idxd: add support for readonly config
 devices
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
Date:   Fri, 30 Oct 2020 11:51:16 -0700
Message-ID: <160408387598.912050.4521050687104233583.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VFIO mediated device for idxd driver will provide a virtual DSA
device by backing it with a workqueue. The virtual device will be limited
with the wq configuration registers set to read-only. Add support and
helper functions for the handling of a DSA device with the configuration
registers marked as read-only.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/device.c |  116 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h   |    1 
 drivers/dma/idxd/init.c   |    8 +++
 drivers/dma/idxd/sysfs.c  |   20 +++++---
 4 files changed, 137 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index d6f551dcbcb6..7003884cd8ad 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -778,3 +778,119 @@ int idxd_device_config(struct idxd_device *idxd)
 
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
+	wqcfg_offset = WQCFG_OFFSET(idxd, wq->id, 0);
+	memcpy_fromio(wq->wqcfg, idxd->reg_base + wqcfg_offset, idxd->wqcfg_size);
+
+	wq->size = wq->wqcfg->wq_size;
+	wq->threshold = wq->wqcfg->wq_thresh;
+	if (wq->wqcfg->priv)
+		wq->type = IDXD_WQT_KERNEL;
+
+	/* The driver does not support shared WQ mode in read-only config yet */
+	if (wq->wqcfg->mode == 0 || wq->wqcfg->pasid_en)
+		return -EOPNOTSUPP;
+
+	set_bit(WQ_FLAG_DEDICATED, &wq->flags);
+
+	wq->priority = wq->wqcfg->priority;
+
+	for (i = 0; i < WQCFG_STRIDES(idxd); i++) {
+		wqcfg_offset = WQCFG_OFFSET(idxd, wq->id, i);
+		dev_dbg(dev, "WQ[%d][%d][%#x]: %#x\n", wq->id, i, wqcfg_offset, wq->wqcfg->bits[i]);
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
+	for (i = 0; i < GRPWQCFG_STRIDES; i++) {
+		struct idxd_wq *wq;
+
+		grpcfg_offset = GRPWQCFG_OFFSET(idxd, group->id, i);
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
+	grpcfg_offset = GRPENGCFG_OFFSET(idxd, group->id);
+	group->grpcfg.engines = ioread64(idxd->reg_base + grpcfg_offset);
+	dev_dbg(dev, "GRPCFG engs[%d: %#x]: %#llx\n", group->id,
+		grpcfg_offset, group->grpcfg.engines);
+
+	/* Iterate through all 64 bits to check engines set */
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
+	grpcfg_offset = GRPFLGCFG_OFFSET(idxd, group->id);
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
index 7e54209c433a..1afc34be4ed0 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -317,6 +317,7 @@ void idxd_device_cleanup(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
+int idxd_device_load_config(struct idxd_device *idxd);
 
 /* work queue control */
 int idxd_wq_alloc_resources(struct idxd_wq *wq);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 45b0eac640c3..98b1091181bb 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -349,6 +349,14 @@ static int idxd_probe(struct idxd_device *idxd)
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
index 6d292eb79bf3..304eb2cf532e 100644
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
@@ -328,12 +330,14 @@ static int idxd_config_bus_remove(struct device *dev)
 
 		idxd_unregister_dma_device(idxd);
 		rc = idxd_device_disable(idxd);
-		for (i = 0; i < idxd->max_wqs; i++) {
-			struct idxd_wq *wq = &idxd->wqs[i];
+		if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags)) {
+			for (i = 0; i < idxd->max_wqs; i++) {
+				struct idxd_wq *wq = &idxd->wqs[i];
 
-			mutex_lock(&wq->wq_lock);
-			idxd_wq_disable_cleanup(wq);
-			mutex_unlock(&wq->wq_lock);
+				mutex_lock(&wq->wq_lock);
+				idxd_wq_disable_cleanup(wq);
+				mutex_unlock(&wq->wq_lock);
+			}
 		}
 		module_put(THIS_MODULE);
 		if (rc < 0)


