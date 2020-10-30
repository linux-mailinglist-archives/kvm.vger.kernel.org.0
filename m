Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2782A0E02
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgJ3Swf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:52:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:57349 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727159AbgJ3Swb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:31 -0400
IronPort-SDR: CSDWrC4kAupOvKgshVv5DvzuIkbdknOO/yxH2DMzfaE3AnNtSLs1WtydJDb454W4QPMTW1gRiI
 eyZarsuj78vQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="148507808"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="148507808"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:27 -0700
IronPort-SDR: hH1MMuCBHvpYrafB1x2GvMuuMv52ZUUNhPpXdhV7FOJmh1v8lAoH6bjtHuZtf5KUSTW6uQRGG7
 62zYq436VlqA==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="537163791"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:26 -0700
Subject: [PATCH v4 14/17] dmaengine: idxd: add mdev type as a new wq type
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
Date:   Fri, 30 Oct 2020 11:52:25 -0700
Message-ID: <160408394597.912050.15142293272388686868.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
index 72c30826f1bb..4e583fdd15d2 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -72,6 +72,7 @@ enum idxd_wq_type {
 	IDXD_WQT_NONE = 0,
 	IDXD_WQT_KERNEL,
 	IDXD_WQT_USER,
+	IDXD_WQT_MDEV,
 };
 
 struct idxd_cdev {
@@ -321,6 +322,7 @@ void idxd_cleanup_sysfs(struct idxd_device *idxd);
 int idxd_register_driver(void);
 void idxd_unregister_driver(void);
 struct bus_type *idxd_get_bus_type(struct idxd_device *idxd);
+bool is_idxd_wq_mdev(struct idxd_wq *wq);
 
 /* device interrupt control */
 irqreturn_t idxd_irq_handler(int vec, void *data);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index fe5f95509c5c..5b79d9019f2e 100644
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
@@ -1094,8 +1100,9 @@ static ssize_t wq_type_show(struct device *dev,
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
@@ -1122,6 +1129,8 @@ static ssize_t wq_type_store(struct device *dev,
 		wq->type = IDXD_WQT_KERNEL;
 	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_USER]))
 		wq->type = IDXD_WQT_USER;
+	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_MDEV]))
+		wq->type = IDXD_WQT_MDEV;
 	else
 		return -EINVAL;
 


