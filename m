Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301FA6EF6D7
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbjDZOyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241267AbjDZOyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:54:35 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F387C7A9D;
        Wed, 26 Apr 2023 07:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682520874; x=1714056874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F/+2vNJVk+zK6U7ggeqab7eTb50HgDYfR/ztN//ugrU=;
  b=TsJiadvsZDLQrGIQd9bzJ+yC+c2DovOxYUaUU2T+GPVKqbQI8m7DfW97
   4kQaNN7o9XkmfoCmk7DCGeTuyn0TviIpGeTlOedcALZ+dCA/fBppPCh7s
   QyZIHtrbEJEg2YMhzJKbCtTYxozr93GioE6cR14FPvLlwBorrEeiJ8JL1
   HU3srx0RzGtxhX1rlgn2R1kcJYfqGw8gjW2/3lDBXSQnia4vUWJ40DeGs
   zgciKp6BZ6BrMrApxjvQmrJ8bzaj2KETDea2sHdXKshoTpsSXy2lWUgoG
   l13PWjVNH8AuyjDY4hf4BebbKINiv0cYskDCyaQ/x/7IGA6shP/B/WXOs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="433410302"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="433410302"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 07:54:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="758644025"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="758644025"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2023 07:54:32 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
Subject: [PATCH v4 4/9] vfio/pci: Move the existing hot reset logic to be a helper
Date:   Wed, 26 Apr 2023 07:54:14 -0700
Message-Id: <20230426145419.450922-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426145419.450922-1-yi.l.liu@intel.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This prepares to add another method for hot reset. The major hot reset logic
are moved to vfio_pci_ioctl_pci_hot_reset_groups().

No functional change is intended.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 55 +++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f824de4dbf27..39e7823088e7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1255,29 +1255,16 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	return ret;
 }
 
-static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
-					struct vfio_pci_hot_reset __user *arg)
+static int
+vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
+				    int array_count, bool slot,
+				    struct vfio_pci_hot_reset __user *arg)
 {
-	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
-	struct vfio_pci_hot_reset hdr;
 	int32_t *group_fds;
 	struct file **files;
 	struct vfio_pci_group_info info;
-	bool slot = false;
 	int file_idx, count = 0, ret = 0;
 
-	if (copy_from_user(&hdr, arg, minsz))
-		return -EFAULT;
-
-	if (hdr.argsz < minsz || hdr.flags)
-		return -EINVAL;
-
-	/* Can we do a slot or bus reset or neither? */
-	if (!pci_probe_reset_slot(vdev->pdev->slot))
-		slot = true;
-	else if (pci_probe_reset_bus(vdev->pdev->bus))
-		return -ENODEV;
-
 	/*
 	 * We can't let userspace give us an arbitrarily large buffer to copy,
 	 * so verify how many we think there could be.  Note groups can have
@@ -1289,11 +1276,11 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		return ret;
 
 	/* Somewhere between 1 and count is OK */
-	if (!hdr.count || hdr.count > count)
+	if (!array_count || array_count > count)
 		return -EINVAL;
 
-	group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
-	files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
+	group_fds = kcalloc(array_count, sizeof(*group_fds), GFP_KERNEL);
+	files = kcalloc(array_count, sizeof(*files), GFP_KERNEL);
 	if (!group_fds || !files) {
 		kfree(group_fds);
 		kfree(files);
@@ -1301,7 +1288,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	}
 
 	if (copy_from_user(group_fds, arg->group_fds,
-			   hdr.count * sizeof(*group_fds))) {
+			   array_count * sizeof(*group_fds))) {
 		kfree(group_fds);
 		kfree(files);
 		return -EFAULT;
@@ -1311,7 +1298,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	 * Get the group file for each fd to ensure the group is held across
 	 * the reset
 	 */
-	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
+	for (file_idx = 0; file_idx < array_count; file_idx++) {
 		struct file *file = fget(group_fds[file_idx]);
 
 		if (!file) {
@@ -1335,7 +1322,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	if (ret)
 		goto hot_reset_release;
 
-	info.count = hdr.count;
+	info.count = array_count;
 	info.files = files;
 
 	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
@@ -1348,6 +1335,28 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
+static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
+					struct vfio_pci_hot_reset __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
+	struct vfio_pci_hot_reset hdr;
+	bool slot = false;
+
+	if (copy_from_user(&hdr, arg, minsz))
+		return -EFAULT;
+
+	if (hdr.argsz < minsz || hdr.flags)
+		return -EINVAL;
+
+	/* Can we do a slot or bus reset or neither? */
+	if (!pci_probe_reset_slot(vdev->pdev->slot))
+		slot = true;
+	else if (pci_probe_reset_bus(vdev->pdev->bus))
+		return -ENODEV;
+
+	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
+}
+
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
 				    struct vfio_device_ioeventfd __user *arg)
 {
-- 
2.34.1

