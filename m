Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5B92284BA
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgGUQEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:04:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:14425 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730080AbgGUQED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:04:03 -0400
IronPort-SDR: pXVf3wa2xyMRS1o+iXuBjNzhdtT0c0D20ZR+9oFuKUhqz7/SsJbil8xKam0G3CiXhMFWp6PDXI
 6Kyuu7E1mJQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="130239905"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="130239905"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:04:03 -0700
IronPort-SDR: di9UGr7zBb4po9MxWVUgchybeldRT6F2HWvHNaXAElWEkdKakEhqHDPOwpurfTC+pBGYZTsv2O
 Vs3ioLe2++vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="287968306"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006.jf.intel.com with ESMTP; 21 Jul 2020 09:04:01 -0700
Subject: [PATCH RFC v2 16/18] dmaengine: idxd: add new wq state for mdev
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
Date:   Tue, 21 Jul 2020 09:04:00 -0700
Message-ID: <159534744069.28840.5832146066812507209.stgit@djiang5-desk3.ch.intel.com>
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

When a dedicated wq is enabled as mdev, we must disable the wq on the
device in order to program the pasid to the wq. Introduce a wq state
IDXD_WQ_LOCKED that is software state only in order to prevent the user
from modifying the configuration while mdev wq is in this state. While
in this state, the wq is not in DISABLED state and will prevent any
modifications to the configuration. It is also not in the ENABLED state
and therefore prevents any actions allowed in the ENABLED state.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/dma/idxd/idxd.h  |    1 +
 drivers/dma/idxd/mdev.c  |    4 +++-
 drivers/dma/idxd/sysfs.c |    2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 1f03019bb45d..cc0665335aee 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -60,6 +60,7 @@ struct idxd_group {
 enum idxd_wq_state {
 	IDXD_WQ_DISABLED = 0,
 	IDXD_WQ_ENABLED,
+	IDXD_WQ_LOCKED,
 };
 
 enum idxd_wq_flag {
diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
index 744adfdc06cd..e3c32f9566b5 100644
--- a/drivers/dma/idxd/mdev.c
+++ b/drivers/dma/idxd/mdev.c
@@ -69,8 +69,10 @@ static void idxd_vdcm_init(struct vdcm_idxd *vidxd)
 
 	vidxd_mmio_init(vidxd);
 
-	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED)
+	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED) {
 		idxd_wq_disable(wq, NULL);
+		wq->state = IDXD_WQ_LOCKED;
+	}
 }
 
 static void __idxd_vdcm_release(struct vdcm_idxd *vidxd)
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index d3b0a95b0d1d..6344cc719897 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -822,6 +822,8 @@ static ssize_t wq_state_show(struct device *dev,
 		return sprintf(buf, "disabled\n");
 	case IDXD_WQ_ENABLED:
 		return sprintf(buf, "enabled\n");
+	case IDXD_WQ_LOCKED:
+		return sprintf(buf, "locked\n");
 	}
 
 	return sprintf(buf, "unknown\n");

