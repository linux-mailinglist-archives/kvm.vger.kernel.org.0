Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B938D264
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhEVAVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:21:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:24594 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230448AbhEVAVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:21:32 -0400
IronPort-SDR: LF2MPiCXllk4cEOIio/MgJsD2XjDb8r3gO3Eo/CB6EiZ5UQqfJDruwoicit5zF1DkuWj2bsL/k
 LJHaw9Rp9R0A==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="222715671"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="222715671"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:08 -0700
IronPort-SDR: hZOuSZ0CJpLCgrLBJ3aW1MyOVv4Ft8V37cTrk97PDJSE+4tfuBU2QM5z2+p5QWjpF1Gp1S4kO/
 b3CaTPLj5mQA==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="628864578"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:07 -0700
Subject: [PATCH v6 10/20] vfio/mdev: idxd: add mdev type as a new wq type
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:07 -0700
Message-ID: <162164280754.261970.2354155734920115161.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/dma/idxd/idxd.h  |    6 ++++++
 drivers/dma/idxd/sysfs.c |    5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 34ffa6dad53a..cbb046c2921f 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -129,6 +129,7 @@ enum idxd_wq_type {
 	IDXD_WQT_NONE = 0,
 	IDXD_WQT_KERNEL,
 	IDXD_WQT_USER,
+	IDXD_WQT_MDEV,
 };
 
 struct idxd_cdev {
@@ -424,6 +425,11 @@ static inline bool is_idxd_wq_user(struct idxd_wq *wq)
 	return wq->type == IDXD_WQT_USER;
 }
 
+static inline bool is_idxd_wq_mdev(struct idxd_wq *wq)
+{
+	return (wq->type == IDXD_WQT_MDEV);
+}
+
 static inline bool wq_dedicated(struct idxd_wq *wq)
 {
 	return test_bit(WQ_FLAG_DEDICATED, &wq->flags);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 6583c9c2e992..3d3a84be2c9b 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -17,6 +17,7 @@ static char *idxd_wq_type_names[] = {
 	[IDXD_WQT_NONE]		= "none",
 	[IDXD_WQT_KERNEL]	= "kernel",
 	[IDXD_WQT_USER]		= "user",
+	[IDXD_WQT_MDEV]		= "mdev",
 };
 
 static bool is_idxd_dev_drv(struct device_driver *drv)
@@ -860,6 +861,8 @@ static ssize_t wq_type_show(struct device *dev,
 		return sysfs_emit(buf, "%s\n", idxd_wq_type_names[IDXD_WQT_KERNEL]);
 	case IDXD_WQT_USER:
 		return sysfs_emit(buf, "%s\n", idxd_wq_type_names[IDXD_WQT_USER]);
+	case IDXD_WQT_MDEV:
+		return sysfs_emit(buf, "%s\n", idxd_wq_type_names[IDXD_WQT_MDEV]);
 	case IDXD_WQT_NONE:
 	default:
 		return sysfs_emit(buf, "%s\n", idxd_wq_type_names[IDXD_WQT_NONE]);
@@ -885,6 +888,8 @@ static ssize_t wq_type_store(struct device *dev,
 		wq->type = IDXD_WQT_KERNEL;
 	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_USER]))
 		wq->type = IDXD_WQT_USER;
+	else if (sysfs_streq(buf, idxd_wq_type_names[IDXD_WQT_MDEV]))
+		wq->type = IDXD_WQT_MDEV;
 	else
 		return -EINVAL;
 


