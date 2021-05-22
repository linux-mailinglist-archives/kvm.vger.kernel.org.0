Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09FC38D27A
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhEVAXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:23:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:31480 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhEVAWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:22:33 -0400
IronPort-SDR: vVSjZ/+4IG0PjRoMpVORoaa6TqStWIZwOlEu2zK0d5mcl3GNvI0jTtA9XvQ/i5gzBYpt5EzpHJ
 1OIS6FX3mYQw==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="265504426"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="265504426"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:44 -0700
IronPort-SDR: p9ylZudZE/ebgREN7McnQJns4oDNrFuq3y077r7ZMETpJ+o52SSvtCHzMlMyFN+uxVFhCFHsVP
 n2NM2XTO+NHg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="631991932"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:44 -0700
Subject: [PATCH v6 16/20] vfio/mdev: idxd: add new wq state for mdev
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:43 -0700
Message-ID: <162164284391.261970.15032815614261092191.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a dedicated wq is enabled as mdev, we must disable the wq on the
device in order to program the pasid to the wq. Introduce a wq state
IDXD_WQ_LOCKED that is software state only in order to prevent the user
from modifying the configuration while mdev wq is in this state. While
in this state, the wq is not in DISABLED state and will prevent any
modifications to the configuration. It is also not in the ENABLED state
and therefore prevents any actions allowed in the ENABLED state.

For mdev, the dwq is disabled and set to LOCKED state upon the mdev
creation. When ->open() is called on the mdev and a pasid is programmed to
the WQCFG, the dwq is enabled again and goes to the ENABLED state.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/device.c     |   16 ++++++++++++++++
 drivers/dma/idxd/idxd.h       |    1 +
 drivers/dma/idxd/sysfs.c      |    2 ++
 drivers/vfio/mdev/idxd/mdev.c |    5 +++++
 drivers/vfio/mdev/idxd/vdev.c |    4 +++-
 5 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index cef41a273cc1..c46b6bc055bd 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -243,6 +243,14 @@ int idxd_wq_disable(struct idxd_wq *wq)
 
 	dev_dbg(dev, "Disabling WQ %d\n", wq->id);
 
+	/*
+	 * When the wq is in LOCKED state, it means it is disabled but
+	 * also at the same time is "enabled" as far as the user is
+	 * concerned. So a call to disable the hardware can be skipped.
+	 */
+	if (wq->state == IDXD_WQ_LOCKED)
+		return 0;
+
 	if (wq->state != IDXD_WQ_ENABLED) {
 		dev_dbg(dev, "WQ %d in wrong state: %d\n", wq->id, wq->state);
 		return 0;
@@ -285,6 +293,14 @@ void idxd_wq_reset(struct idxd_wq *wq)
 	struct device *dev = &idxd->pdev->dev;
 	u32 operand;
 
+	/*
+	 * When the wq is in LOCKED state, it means it is disabled but
+	 * also at the same time is "enabled" as far as the user is
+	 * concerned. So a call to reset the hardware can be skipped.
+	 */
+	if (wq->state == IDXD_WQ_LOCKED)
+		return;
+
 	if (wq->state != IDXD_WQ_ENABLED) {
 		dev_dbg(dev, "WQ %d in wrong state: %d\n", wq->id, wq->state);
 		return;
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 81c78add74dd..5e8da9019c46 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -120,6 +120,7 @@ struct idxd_pmu {
 enum idxd_wq_state {
 	IDXD_WQ_DISABLED = 0,
 	IDXD_WQ_ENABLED,
+	IDXD_WQ_LOCKED,
 };
 
 enum idxd_wq_flag {
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 3d3a84be2c9b..435ad3c62ad6 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -584,6 +584,8 @@ static ssize_t wq_state_show(struct device *dev,
 		return sysfs_emit(buf, "disabled\n");
 	case IDXD_WQ_ENABLED:
 		return sysfs_emit(buf, "enabled\n");
+	case IDXD_WQ_LOCKED:
+		return sysfs_emit(buf, "locked\n");
 	}
 
 	return sysfs_emit(buf, "unknown\n");
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 7dac024e2852..3257505fb7c7 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -894,6 +894,11 @@ static void idxd_mdev_drv_remove(struct device *dev)
 	struct idxd_device *idxd = wq->idxd;
 
 	drv_disable_wq(wq);
+	mutex_lock(&wq->wq_lock);
+	if (wq->state == IDXD_WQ_LOCKED)
+		wq->state = IDXD_WQ_DISABLED;
+	mutex_unlock(&wq->wq_lock);
+
 	dev_info(dev, "wq %s disabled\n", dev_name(dev));
 	kref_put_mutex(&idxd->mdev_kref, idxd_mdev_host_release, &idxd->kref_lock);
 	put_device(dev);
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
index 67da4c122a96..a444a0af8b5f 100644
--- a/drivers/vfio/mdev/idxd/vdev.c
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -75,8 +75,10 @@ void vidxd_init(struct vdcm_idxd *vidxd)
 
 	vidxd_mmio_init(vidxd);
 
-	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED)
+	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED) {
 		idxd_wq_disable(wq);
+		wq->state = IDXD_WQ_LOCKED;
+	}
 }
 
 void vidxd_send_interrupt(struct vdcm_idxd *vidxd, int vector)


