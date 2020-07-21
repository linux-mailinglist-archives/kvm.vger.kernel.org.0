Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368F72284AC
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbgGUQDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:03:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:9860 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgGUQDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:03:49 -0400
IronPort-SDR: mT8yMac5VWnWmqcNRDp7w8T5XNLSma1VsrjjGNI8gsY6K5qZLaIWmqeygrQPkjnipyaO91Mqt/
 N8+YtquiNJww==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="148100754"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="148100754"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:03:48 -0700
IronPort-SDR: 0oyIdad1lxDFJNYjQZK8aIhpAdXIs04RAE6PYdWPXVFD8P0lQpJHwvS0/LaL43Mmz4E/cYPjqi
 /e3oekyyyIRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="310293846"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jul 2020 09:03:47 -0700
Subject: [PATCH RFC v2 14/18] dmaengine: idxd: add mdev type as a new wq type
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
Date:   Tue, 21 Jul 2020 09:03:47 -0700
Message-ID: <159534742756.28840.2462836305382720334.stgit@djiang5-desk3.ch.intel.com>
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

Add "mdev" wq type and support helpers. The mdev wq type marks the wq
to be utilized as a VFIO mediated device.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/dma/idxd/idxd.h  |    2 ++
 drivers/dma/idxd/sysfs.c |   13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 1e4d9ec9b00d..1f03019bb45d 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -71,6 +71,7 @@ enum idxd_wq_type {
 	IDXD_WQT_NONE = 0,
 	IDXD_WQT_KERNEL,
 	IDXD_WQT_USER,
+	IDXD_WQT_MDEV,
 };
 
 struct idxd_cdev {
@@ -308,6 +309,7 @@ void idxd_cleanup_sysfs(struct idxd_device *idxd);
 int idxd_register_driver(void);
 void idxd_unregister_driver(void);
 struct bus_type *idxd_get_bus_type(struct idxd_device *idxd);
+bool is_idxd_wq_mdev(struct idxd_wq *wq);
 
 /* device interrupt control */
 irqreturn_t idxd_irq_handler(int vec, void *data);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index cdf2b5aac314..d3b0a95b0d1d 100644
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
@@ -1095,8 +1101,9 @@ static ssize_t wq_type_show(struct device *dev,
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
@@ -1123,6 +1130,8 @@ static ssize_t wq_type_store(struct device *dev,
 		wq->type = IDXD_WQT_KERNEL;
 	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_USER]))
 		wq->type = IDXD_WQT_USER;
+	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_MDEV]))
+		wq->type = IDXD_WQT_MDEV;
 	else
 		return -EINVAL;
 

