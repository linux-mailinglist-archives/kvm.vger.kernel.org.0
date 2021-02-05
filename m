Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0343112E6
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 21:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhBETON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 14:14:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:37593 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233723AbhBETMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:12:50 -0500
IronPort-SDR: fJdkk9BGeDch80PC9/g9WV6BGfHotRP2h5ZzrJm6kJgWVfGGrAabTnpJ2iHQbCg3iQHG6VyTFO
 SVnuFrIdjT+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="181551601"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="181551601"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:54:18 -0800
IronPort-SDR: Cge2ehvW9insyeKyV9XHY3vQmr6/rhDWwyFyeR62HO7mYG20bPdATVecw7vrDZMBAW2P8H5PQu
 4LzpDMECI5sw==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="416146008"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:54:17 -0800
Subject: [PATCH v5 13/14] vfio/mdev: idxd: add new wq state for mdev
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
Date:   Fri, 05 Feb 2021 13:54:17 -0700
Message-ID: <161255845740.339900.10615654311326039119.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/dma/idxd/device.c     |    9 +++++++++
 drivers/dma/idxd/idxd.h       |    1 +
 drivers/dma/idxd/sysfs.c      |    2 ++
 drivers/vfio/mdev/idxd/mdev.c |    4 +++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index c5faa23bd8ce..1cd64a6a60de 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -252,6 +252,14 @@ int idxd_wq_disable(struct idxd_wq *wq, u32 *status)
 
 	dev_dbg(dev, "Disabling WQ %d\n", wq->id);
 
+	/*
+	 * When the wq is in LOCKED state, it means it is disabled but
+	 * also at the same time is "enabled" as far as the user is
+	 * concerned. So a call to disable the hardware can be skipped.
+	 */
+	if (wq->state == IDXD_WQ_LOCKED)
+		goto out;
+
 	if (wq->state != IDXD_WQ_ENABLED) {
 		dev_dbg(dev, "WQ %d in wrong state: %d\n", wq->id, wq->state);
 		return 0;
@@ -268,6 +276,7 @@ int idxd_wq_disable(struct idxd_wq *wq, u32 *status)
 		return -ENXIO;
 	}
 
+ out:
 	wq->state = IDXD_WQ_DISABLED;
 	dev_dbg(dev, "WQ %d disabled\n", wq->id);
 	return 0;
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index c5ef6ccc9ba6..4afe35385f85 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -62,6 +62,7 @@ struct idxd_group {
 enum idxd_wq_state {
 	IDXD_WQ_DISABLED = 0,
 	IDXD_WQ_ENABLED,
+	IDXD_WQ_LOCKED,
 };
 
 enum idxd_wq_flag {
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 913ff019fe36..1bce55ac24b9 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -879,6 +879,8 @@ static ssize_t wq_state_show(struct device *dev,
 		return sprintf(buf, "disabled\n");
 	case IDXD_WQ_ENABLED:
 		return sprintf(buf, "enabled\n");
+	case IDXD_WQ_LOCKED:
+		return sprintf(buf, "locked\n");
 	}
 
 	return sprintf(buf, "unknown\n");
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index d59920f78109..60913950a4f5 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -116,8 +116,10 @@ static void idxd_vdcm_init(struct vdcm_idxd *vidxd)
 
 	vidxd_mmio_init(vidxd);
 
-	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED)
+	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED) {
 		idxd_wq_disable(wq, NULL);
+		wq->state = IDXD_WQ_LOCKED;
+	}
 }
 
 static void idxd_vdcm_release(struct mdev_device *mdev)


