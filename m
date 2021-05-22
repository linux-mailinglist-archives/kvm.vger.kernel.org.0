Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA9E38D253
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhEVAUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:20:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:39645 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhEVAUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:20:50 -0400
IronPort-SDR: Q1morS0lcA7UBlWOuN2o8qZpvWByhYgxJCbrrGh6hfa748M++Na94aM99NxKDjK4cUzXiBXoDQ
 GGLSLAGxEEmQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="201312114"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="201312114"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:25 -0700
IronPort-SDR: SS8nw179FZK2ypju3HOo8yDQMZGa4TvwCjl2XtqtqE0MprseuOZP3YLsEH01gn5zILEtRFUmyg
 54HFIk+JupCg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="406873451"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:24 -0700
Subject: [PATCH v6 03/20] dmaengine: idxd: add IMS offset and size retrieval
 code
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:19:24 -0700
Message-ID: <162164276439.261970.331517339815823049.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add retrieval code for Interrupt Message Store (IMS) related info
(table offset and size). IMS is used to back the MSIX vectors that
support the descriptor completion interrupt for the mediated device.

In the SIOV spec [1], IMS is specified as detected via DVSEC. Here's the
upstream discussion WRT having the device driver doing the detection
vs a platform detection feature: [2]. The latest agreement is that IMS
should be done from platform perspective. Given that DSA 1.0 and
any foreseeable future devices is expected to support IMS, the driver
will just check the ims size field to determine if IMS is supported.

[1]: https://software.intel.com/en-us/download/intel-scalable-io-virtualization-technical-specification
[2]: https://lore.kernel.org/dmaengine/20201030224534.GN2620339@nvidia.com/

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ABI/stable/sysfs-driver-dma-idxd |    6 ++++++
 drivers/dma/idxd/idxd.h                        |    2 ++
 drivers/dma/idxd/init.c                        |    4 ++++
 drivers/dma/idxd/sysfs.c                       |    9 +++++++++
 4 files changed, 21 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-driver-dma-idxd b/Documentation/ABI/stable/sysfs-driver-dma-idxd
index 55285c136cf0..884065b2e85c 100644
--- a/Documentation/ABI/stable/sysfs-driver-dma-idxd
+++ b/Documentation/ABI/stable/sysfs-driver-dma-idxd
@@ -129,6 +129,12 @@ KernelVersion:	5.10.0
 Contact:	dmaengine@vger.kernel.org
 Description:	The last executed device administrative command's status/error.
 
+What:		/sys/bus/dsa/devices/dsa<m>/ims_size
+Date:		May 3, 2021
+KernelVersion:	5.14.0
+Contact:	dmaengine@vger.kernel.org
+Description:	The total number of vectors available for Interrupt Message Store.
+
 What:		/sys/bus/dsa/devices/wq<m>.<n>/block_on_fault
 Date:		Oct 27, 2020
 KernelVersion:	5.11.0
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 22afaf7ee637..288e3fe15b3e 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -266,6 +266,7 @@ struct idxd_device {
 
 	int num_groups;
 
+	u32 ims_offset;
 	u32 msix_perm_offset;
 	u32 wqcfg_offset;
 	u32 grpcfg_offset;
@@ -273,6 +274,7 @@ struct idxd_device {
 
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
+	int ims_size;
 	int max_groups;
 	int max_engines;
 	int max_tokens;
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index bed9169152f9..16ff37be2d26 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -381,6 +381,8 @@ static void idxd_read_table_offsets(struct idxd_device *idxd)
 	dev_dbg(dev, "IDXD Work Queue Config Offset: %#x\n", idxd->wqcfg_offset);
 	idxd->msix_perm_offset = offsets.msix_perm * IDXD_TABLE_MULT;
 	dev_dbg(dev, "IDXD MSIX Permission Offset: %#x\n", idxd->msix_perm_offset);
+	idxd->ims_offset = offsets.ims * IDXD_TABLE_MULT;
+	dev_dbg(dev, "IDXD IMS Offset: %#x\n", idxd->ims_offset);
 	idxd->perfmon_offset = offsets.perfmon * IDXD_TABLE_MULT;
 	dev_dbg(dev, "IDXD Perfmon Offset: %#x\n", idxd->perfmon_offset);
 }
@@ -403,6 +405,8 @@ static void idxd_read_caps(struct idxd_device *idxd)
 	dev_dbg(dev, "max xfer size: %llu bytes\n", idxd->max_xfer_bytes);
 	idxd->max_batch_size = 1U << idxd->hw.gen_cap.max_batch_shift;
 	dev_dbg(dev, "max batch size: %u\n", idxd->max_batch_size);
+	idxd->ims_size = idxd->hw.gen_cap.max_ims_mult * 256ULL;
+	dev_dbg(dev, "IMS size: %u\n", idxd->ims_size);
 	if (idxd->hw.gen_cap.config_en)
 		set_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags);
 
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 4fcb8833a4df..6583c9c2e992 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1166,6 +1166,14 @@ static ssize_t numa_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t ims_size_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct idxd_device *idxd = confdev_to_idxd(dev);
+
+	return sysfs_emit(buf, "%u\n", idxd->ims_size);
+}
+static DEVICE_ATTR_RO(ims_size);
+
 static ssize_t max_batch_size_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1352,6 +1360,7 @@ static struct attribute *idxd_device_attributes[] = {
 	&dev_attr_max_work_queues_size.attr,
 	&dev_attr_max_engines.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_ims_size.attr,
 	&dev_attr_max_batch_size.attr,
 	&dev_attr_max_transfer_size.attr,
 	&dev_attr_op_cap.attr,


