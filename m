Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BDD6BCFCC
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjCPMmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjCPMm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:42:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33944B32B4;
        Thu, 16 Mar 2023 05:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678970547; x=1710506547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z/3DeM31wos4hPFJcOhBa/QKGeGtDvnA4E5EZwXXXyw=;
  b=GS71EibQtbG2ztomF0UtMkSI13xfH51dSmr3HUkAGy17lT52Hp6qZbmh
   nPE9cvzkXttKulDy57OzqNA0t06zHkgklx0lu6hUgkmF8PtfWaiM/kgF8
   KzoNUaKYVPc84n1rsYgikI/pF8u5LA+cTkzm2vts7pp0+jhMnJkT4SKJG
   82PVliRUEBZLvYieAhiuSeQOFd6rhyWN6vmQCYcDUvbr2ZzNiKNHTzF1p
   r6eB4Yc6t2Ysph8/6ubHxfoIvUJOUdcb6i1FUXGiFWBBnlFFLkG6m88i9
   /fXVQ9ZVniJsFC6v2iTQUv4TabXGQ6YZSylRvHyyeKtbZE/Beb6oYfKQH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="321812123"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="321812123"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:42:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="1009208018"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="1009208018"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 05:42:14 -0700
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
Subject: [PATCH 7/7] vfio/pci: Accept device fd in VFIO_DEVICE_PCI_HOT_RESET ioctl
Date:   Thu, 16 Mar 2023 05:41:56 -0700
Message-Id: <20230316124156.12064-8-yi.l.liu@intel.com>
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

Now user can also provide an array of device fds as a 3rd method to verify
the reset ownership. It's not useful at this point when the device fds are
acquired via group fds. But it's necessary when moving to device cdev which
allows the user to directly acquire device fds by skipping group. In that
case this method can be used as a last resort when the preferred iommufd
verification doesn't work, e.g. in noiommu usages.

Clarify it in uAPI.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 6 +++---
 include/uapi/linux/vfio.h        | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b7de1816b97b..19f5b075d70a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1289,7 +1289,7 @@ vfio_pci_ioctl_pci_hot_reset_files(struct vfio_pci_core_device *vdev,
 		return -ENOMEM;
 	}
 
-	if (copy_from_user(fds, arg->group_fds,
+	if (copy_from_user(fds, arg->fds,
 			   hdr->count * sizeof(*fds))) {
 		kfree(fds);
 		kfree(files);
@@ -1297,8 +1297,8 @@ vfio_pci_ioctl_pci_hot_reset_files(struct vfio_pci_core_device *vdev,
 	}
 
 	/*
-	 * Get the group file for each fd to ensure the group held across
-	 * the reset
+	 * Get the file for each fd to ensure the group/device file
+	 * is held across the reset
 	 */
 	for (file_idx = 0; file_idx < hdr->count; file_idx++) {
 		struct file *file = fget(fds[file_idx]);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 17aa5d09db41..25432ef213ee 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -681,6 +681,7 @@ struct vfio_pci_hot_reset_info {
  *
  * The ownership can be proved by:
  *   - An array of group fds
+ *   - An array of device fds
  *   - A zero-length array
  *
  * In the last case all affected devices which are opened by this user
@@ -694,7 +695,7 @@ struct vfio_pci_hot_reset {
 	__u32	argsz;
 	__u32	flags;
 	__u32	count;
-	__s32	group_fds[];
+	__s32	fds[];
 };
 
 #define VFIO_DEVICE_PCI_HOT_RESET	_IO(VFIO_TYPE, VFIO_BASE + 13)
-- 
2.34.1

