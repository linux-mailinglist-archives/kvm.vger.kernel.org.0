Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC31526B4BE
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 01:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgIOXa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 19:30:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:39780 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgIOX3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 19:29:13 -0400
IronPort-SDR: 1ho4d7MImUHCoKcIFh9Z7dDVeeZMfVkwrdpOsaVUQ+Ac+q5tcoC68SL1UAiJnX1DkB4asPfD/Z
 8nANsTxNbE2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="160300249"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="160300249"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:29:12 -0700
IronPort-SDR: k0U9QmM+u6hubZU49zqqGjcsOs5mlYLD6h9iOBwGCj30m+NZRwHRy5OAncHd1aTqWcjta4dYYv
 1MLSN0h8fZVQ==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="343691342"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:29:11 -0700
Subject: [PATCH v3 14/18] dmaengine: idxd: add new wq state for mdev
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
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 15 Sep 2020 16:29:11 -0700
Message-ID: <160021255105.67751.1103109119558046722.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
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
---
 drivers/dma/idxd/idxd.h  |    1 +
 drivers/dma/idxd/mdev.c  |    4 +++-
 drivers/dma/idxd/sysfs.c |    2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 23287f8fd19a..f67c0036f968 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -55,6 +55,7 @@ struct idxd_group {
 enum idxd_wq_state {
 	IDXD_WQ_DISABLED = 0,
 	IDXD_WQ_ENABLED,
+	IDXD_WQ_LOCKED,
 };
 
 enum idxd_wq_flag {
diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
index 2d3ff1a50d39..ea07e7c1ba31 100644
--- a/drivers/dma/idxd/mdev.c
+++ b/drivers/dma/idxd/mdev.c
@@ -72,8 +72,10 @@ static void idxd_vdcm_init(struct vdcm_idxd *vidxd)
 
 	vidxd_mmio_init(vidxd);
 
-	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED)
+	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED) {
 		idxd_wq_disable(wq, NULL);
+		wq->state = IDXD_WQ_LOCKED;
+	}
 }
 
 static void idxd_vdcm_release(struct mdev_device *mdev)
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 6eb67f744c8e..4cc05392130c 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -797,6 +797,8 @@ static ssize_t wq_state_show(struct device *dev,
 		return sprintf(buf, "disabled\n");
 	case IDXD_WQ_ENABLED:
 		return sprintf(buf, "enabled\n");
+	case IDXD_WQ_LOCKED:
+		return sprintf(buf, "locked\n");
 	}
 
 	return sprintf(buf, "unknown\n");

