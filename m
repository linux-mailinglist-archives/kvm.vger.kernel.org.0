Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC76F26B4AB
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 01:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbgIOX3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 19:29:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:50403 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbgIOX3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 19:29:00 -0400
IronPort-SDR: ecUJIcx9HTEbRlrqx93s64aAN0NJL3hY+7pr+x/SGII57DwC6xQ/LzxiKkFWe3a0JXN2dYH/W9
 WELW5quH+cvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="244200291"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="244200291"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:28:59 -0700
IronPort-SDR: 7SVpz8o6qKHdfPiE4xcigHFUb8nzIGCbbNX8ZkbJLzt3JgPWlAwNg4pH1Go5qsJbbKwbFnyTNL
 aJhnCL4OdqUg==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="507771710"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:28:58 -0700
Subject: [PATCH v3 12/18] dmaengine: idxd: add mdev type as a new wq type
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
Date:   Tue, 15 Sep 2020 16:28:58 -0700
Message-ID: <160021253826.67751.7453808239640664490.stgit@djiang5-desk3.ch.intel.com>
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

Add "mdev" wq type and support helpers. The mdev wq type marks the wq
to be utilized as a VFIO mediated device.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/idxd.h  |    2 ++
 drivers/dma/idxd/sysfs.c |   13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 23d3ebca1da5..23287f8fd19a 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -65,6 +65,7 @@ enum idxd_wq_type {
 	IDXD_WQT_NONE = 0,
 	IDXD_WQT_KERNEL,
 	IDXD_WQT_USER,
+	IDXD_WQT_MDEV,
 };
 
 struct idxd_cdev {
@@ -290,6 +291,7 @@ void idxd_cleanup_sysfs(struct idxd_device *idxd);
 int idxd_register_driver(void);
 void idxd_unregister_driver(void);
 struct bus_type *idxd_get_bus_type(struct idxd_device *idxd);
+bool is_idxd_wq_mdev(struct idxd_wq *wq);
 
 /* device interrupt control */
 irqreturn_t idxd_irq_handler(int vec, void *data);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index cbb1038f1ed0..6eb67f744c8e 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -14,6 +14,7 @@ static char *idxd_wq_type_names[] = {
 	[IDXD_WQT_NONE]		= "none",
 	[IDXD_WQT_KERNEL]	= "kernel",
 	[IDXD_WQT_USER]		= "user",
+	[IDXD_WQT_MDEV]		= "mdev",
 };
 
 static void idxd_conf_device_release(struct device *dev)
@@ -69,6 +70,11 @@ static inline bool is_idxd_wq_cdev(struct idxd_wq *wq)
 	return wq->type == IDXD_WQT_USER;
 }
 
+inline bool is_idxd_wq_mdev(struct idxd_wq *wq)
+{
+	return wq->type == IDXD_WQT_MDEV ? true : false;
+}
+
 static int idxd_config_bus_match(struct device *dev,
 				 struct device_driver *drv)
 {
@@ -987,8 +993,9 @@ static ssize_t wq_type_show(struct device *dev,
 		return sprintf(buf, "%s\n",
 			       idxd_wq_type_names[IDXD_WQT_KERNEL]);
 	case IDXD_WQT_USER:
-		return sprintf(buf, "%s\n",
-			       idxd_wq_type_names[IDXD_WQT_USER]);
+		return sprintf(buf, "%s\n", idxd_wq_type_names[IDXD_WQT_USER]);
+	case IDXD_WQT_MDEV:
+		return sprintf(buf, "%s\n", idxd_wq_type_names[IDXD_WQT_MDEV]);
 	case IDXD_WQT_NONE:
 	default:
 		return sprintf(buf, "%s\n",
@@ -1015,6 +1022,8 @@ static ssize_t wq_type_store(struct device *dev,
 		wq->type = IDXD_WQT_KERNEL;
 	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_USER]))
 		wq->type = IDXD_WQT_USER;
+	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_MDEV]))
+		wq->type = IDXD_WQT_MDEV;
 	else
 		return -EINVAL;
 

