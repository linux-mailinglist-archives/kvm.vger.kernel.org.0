Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8D469D9C3
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbjBUDtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbjBUDtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:49:41 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E843724CAD;
        Mon, 20 Feb 2023 19:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676951363; x=1708487363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BE9VA56JN7+YLYAFW4iTmCHAvkbGjlHc5frclqlJWvw=;
  b=K6O6NrOD18SF0lzN7bXIwwhZIQjB2gPm0v22SFEcaAbei8DHHdFAri61
   vGsU7WuapnVQ6bnYTqFycjCsMimXNSuK0YUUT1/12s5l9Ic6Bx9CLXo/E
   HKvTDAO+tVSKqvW4Nfh9fLrr1W1b4p3gm6VBsUkUGeiA9mryPlgIIgIIY
   zid434e0GrlyjdG0mgtiFgNwl9kyt8EaRho1XvVFhFO1uuSMZoklR0JCJ
   lN5GY8+FN+lP0EB56gw2lnwLo9G+uWDpiUu36O59qqDMrWcqhsqx5NoEH
   l2uoNgejoUAVqen3h2SlfhSJKMyrNzfSPYHMDtqsSvQOY+3095iSDmD/j
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="397218456"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="397218456"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 19:48:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="664822177"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="664822177"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 20 Feb 2023 19:48:20 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        yan.y.zhao@intel.com, xudong.hao@intel.com, terrence.xu@intel.com
Subject: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Date:   Mon, 20 Feb 2023 19:48:02 -0800
Message-Id: <20230221034812.138051-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221034812.138051-1-yi.l.liu@intel.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This prepares for using vfio device cdev as no group fd will be opened
in device cdev usage.

vfio_file_is_device_opened() is added for checking a given vfio file is
able to be a proof for the device ownership or not. The reason is that
the cdev path has the device opened in an in-between state, in which the
device is not fully opened. But to be proof of ownership, device should
be fully opened.

This also updates some comments as it also accepts device fd passed by
user. The uapi has no change, but user can specify a set of device fds
in the struct vfio_pci_hot_reset::group_fds field.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 11 ++++++-----
 drivers/vfio/vfio_main.c         | 19 +++++++++++++++++++
 include/linux/vfio.h             |  1 +
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 827524510f3f..09086fefd515 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1280,8 +1280,9 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 
 	/*
 	 * We can't let userspace give us an arbitrarily large buffer to copy,
-	 * so verify how many we think there could be.  Note groups can have
-	 * multiple devices so one group per device is the max.
+	 * so verify how many we think there could be.  Note user may provide
+	 * a set of groups, group can have multiple devices so one group per
+	 * device is the max.
 	 */
 	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
 					    &count, slot);
@@ -1308,7 +1309,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	}
 
 	/*
-	 * For each group_fd, get the group file, this ensures the group
+	 * For each fd, get the file, this ensures the group or device
 	 * is held across the reset.
 	 */
 	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
@@ -1320,7 +1321,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		}
 
 		/* Ensure the FD is a vfio FD.*/
-		if (!vfio_file_is_valid(file)) {
+		if (!vfio_file_is_device_opened(file)) {
 			fput(file);
 			ret = -EINVAL;
 			break;
@@ -2430,7 +2431,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
 		/*
 		 * Test whether all the affected devices are contained by the
-		 * set of groups provided by the user.
+		 * set of files provided by the user.
 		 */
 		if (!vfio_dev_in_groups(cur_vma, groups)) {
 			ret = -EINVAL;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 91c8f25393db..2c851e172586 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1209,6 +1209,25 @@ bool vfio_file_is_valid(struct file *file)
 }
 EXPORT_SYMBOL_GPL(vfio_file_is_valid);
 
+/**
+ * vfio_file_is_device_opened - True if the file is fully opened
+ * @file: VFIO group file or VFIO device file
+ */
+bool vfio_file_is_device_opened(struct file *file)
+{
+	struct vfio_device *device;
+
+	if (vfio_group_from_file(file))
+		return true;
+
+	device = vfio_device_from_file(file);
+	if (device)
+		return READ_ONCE(device->open_count);
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(vfio_file_is_device_opened);
+
 /**
  * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
  *        is always CPU cache coherent
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 6a07e1c6c38e..615f8a081a41 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -249,6 +249,7 @@ bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
+bool vfio_file_is_device_opened(struct file *file);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-- 
2.34.1

