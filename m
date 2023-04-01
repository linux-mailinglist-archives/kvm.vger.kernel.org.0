Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEF96D3191
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 16:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjDAOou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 10:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjDAOok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 10:44:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D871E700;
        Sat,  1 Apr 2023 07:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680360278; x=1711896278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o+4hvtO01Hxfljc0ef73oUe7c+gXDNaaBG7dxXvC5xY=;
  b=D4ZC829FWPr6+n6xqee8C76wvTP+2G6TINiXaJLdcK/IH99yiiTXs1NE
   bSSI0njp9DY8eTJU/vmr8zQXKJpqRAizow4wrbpKHfrnoF7awMwrXyJDK
   Lk6IVs2HUHQMLgXs9KcHaGEh4swgg9IoaRy5CbNcDsAtxR8DfVaAy69tw
   3uN+YjWCX75F62rd/oLpLa3Fp3t+TJ2LSrJWo25P0ZoukcpSZxRPcHOAL
   GYJu/UnupesFzk9O0lOYKu+SQ1xWRJIVKAWMy2IiQj8LiJCD8wnb8qfGG
   +wr3rktFmPU8mE2TaI3yJF28sa9L+3+wYPAFATAzpMeL3/Iz9oFHpKArG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="340385153"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="340385153"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 07:44:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="662705847"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="662705847"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 01 Apr 2023 07:44:38 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: [PATCH v3 09/12] vfio/pci: Accept device fd in VFIO_DEVICE_PCI_HOT_RESET ioctl
Date:   Sat,  1 Apr 2023 07:44:26 -0700
Message-Id: <20230401144429.88673-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401144429.88673-1-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 9 +++++----
 include/uapi/linux/vfio.h        | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index da6325008872..19f5b075d70a 100644
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
@@ -2469,7 +2469,8 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 * cannot race being opened by another user simultaneously.
 		 *
 		 * Otherwise all opened devices in the dev_set must be
-		 * contained by the set of groups provided by the user.
+		 * contained by the set of groups/devices provided by
+		 * the user.
 		 *
 		 * If user provides a zero-length array, then all the
 		 * opened devices must be bound to a same iommufd_ctx.
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

