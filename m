Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990FF6BCFC9
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCPMmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCPMm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:42:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E586BB1A68;
        Thu, 16 Mar 2023 05:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678970546; x=1710506546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=21n59NueoZg+YCLGA7KIVcAZ1swA7rO+1yGotBMrp8E=;
  b=Oycs3McQ+Cu+vmIBYnRbLRYvSEUw+XjSItz+EW4ew5Q3e0Xsr9+Aw91R
   E0CKi2W9l8WnxehTbjZ/fm45gIFn20im979+t+UUWphM2PInAQjg7SsCS
   r39tyIOnhQbjE7Z2dymM9+/wopnn1/HM21XREJwN7JaH1MsAigOq+TWKU
   Mbamg51p34yJlkCJ8NRxtBo+/Phrt/+o1CAnobVXzM/1OGMN+DflWVe7v
   ejUrfolARYZb+5l2sDR563nopFxr5B2t315AggBVvEY1KD5cWOAwARrJk
   PmN3RjmF4LnyFRKmwWoKJ9guQ35VPF+LrEchCHWtKOoSFAzKceXakZVH6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="321812108"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="321812108"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:42:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="1009208007"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="1009208007"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 05:42:13 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH 6/7] vfio: Accpet device file from vfio PCI hot reset path
Date:   Thu, 16 Mar 2023 05:41:55 -0700
Message-Id: <20230316124156.12064-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316124156.12064-1-yi.l.liu@intel.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This extends both vfio_file_is_valid() and vfio_file_has_dev() to accept
device file from the vfio PCI hot reset.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index fe7446805afd..ebbb6b91a498 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1154,13 +1154,23 @@ const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
+static struct vfio_device *vfio_device_from_file(struct file *file)
+{
+	struct vfio_device *device = file->private_data;
+
+	if (file->f_op != &vfio_device_fops)
+		return NULL;
+	return device;
+}
+
 /**
  * vfio_file_is_valid - True if the file is valid vfio file
  * @file: VFIO group file or VFIO device file
  */
 bool vfio_file_is_valid(struct file *file)
 {
-	return vfio_group_from_file(file);
+	return vfio_group_from_file(file) ||
+	       vfio_device_from_file(file);
 }
 EXPORT_SYMBOL_GPL(vfio_file_is_valid);
 
@@ -1174,12 +1184,17 @@ EXPORT_SYMBOL_GPL(vfio_file_is_valid);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
 {
 	struct vfio_group *group;
+	struct vfio_device *vdev;
 
 	group = vfio_group_from_file(file);
-	if (!group)
-		return false;
+	if (group)
+		return vfio_group_has_dev(group, device);
+
+	vdev = vfio_device_from_file(file);
+	if (vdev)
+		return vdev == device;
 
-	return vfio_group_has_dev(group, device);
+	return false;
 }
 EXPORT_SYMBOL_GPL(vfio_file_has_dev);
 
-- 
2.34.1

