Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FC72A0DFB
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgJ3Swv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:52:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:65456 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727457AbgJ3Swn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:43 -0400
IronPort-SDR: r/uik6O+cL/PotGwbyf43M4mKE3wubuCyiRmVRXwecL88iakbE5GFWiIVLg0Ueyyd71CeIEZtE
 j5YTqEOmwQ6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="230287931"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="230287931"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:42 -0700
IronPort-SDR: yi6ih3tbmuV2vdf2jorI4qWEUeO2gw83dlmTJAuOwlUFIwikNDtbviJIfE4Wzek81sfINS5KOo
 uJ+q3CtMGdYw==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="324168355"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:39 -0700
Subject: [PATCH v4 16/17] dmaengine: idxd: add new wq state for mdev
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
Date:   Fri, 30 Oct 2020 11:52:39 -0700
Message-ID: <160408395903.912050.14092194237099902168.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
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

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/idxd.h  |    1 +
 drivers/dma/idxd/mdev.c  |    4 +++-
 drivers/dma/idxd/sysfs.c |    2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 4e583fdd15d2..03275ad9e849 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -61,6 +61,7 @@ struct idxd_group {
 enum idxd_wq_state {
 	IDXD_WQ_DISABLED = 0,
 	IDXD_WQ_ENABLED,
+	IDXD_WQ_LOCKED,
 };
 
 enum idxd_wq_flag {
diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
index 16b56f8f7fc1..3db7717a10c0 100644
--- a/drivers/dma/idxd/mdev.c
+++ b/drivers/dma/idxd/mdev.c
@@ -84,8 +84,10 @@ static void idxd_vdcm_init(struct vdcm_idxd *vidxd)
 
 	vidxd_mmio_init(vidxd);
 
-	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED)
+	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED) {
 		idxd_wq_disable(wq, NULL);
+		wq->state = IDXD_WQ_LOCKED;
+	}
 }
 
 static void idxd_vdcm_release(struct mdev_device *mdev)
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 5b79d9019f2e..3bbbd413980e 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -821,6 +821,8 @@ static ssize_t wq_state_show(struct device *dev,
 		return sprintf(buf, "disabled\n");
 	case IDXD_WQ_ENABLED:
 		return sprintf(buf, "enabled\n");
+	case IDXD_WQ_LOCKED:
+		return sprintf(buf, "locked\n");
 	}
 
 	return sprintf(buf, "unknown\n");


