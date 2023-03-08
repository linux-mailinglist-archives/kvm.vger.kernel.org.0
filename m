Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9847B6B091F
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjCHNcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjCHNbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:31:42 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E0393E2;
        Wed,  8 Mar 2023 05:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282195; x=1709818195;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z989pXr8cKO9ICuEG/SHwdMZNnkhbkrQGmWc0s0dx1c=;
  b=lW78s/CXGXlsfz1murVh7P11yHlrJNtN6lsvmVHohDhFYSCZixMf0cOj
   qwtuk9uYFBf0SVVdsFPHxsPij9s825AZ47gjm2IqYJfnNKjcvaLZctzl+
   4buMTnlFhQEUvCVoijGeMyh2DkFimBdV4pibS0egLjinDEvVH4SycdxKc
   1ynXYh5G2Hctu4/IfCv+WSgiTjsEi8lw0jgO/RgRDpDGvfbXr0WTItH7U
   3zhoX5bIpC30H9Gxyajrjats76qIASobxSDyRwrjrrLT04RnRNbenlNyn
   NOCDtKo5AslaIUJBzovPlmimgjtGTarKF0fkdeoZWjzgh0zA0KH2MIXdh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165207"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165207"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789357"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789357"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:23 -0800
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
Subject: [PATCH v6 10/24] vfio/pci: Rename the helpers and data in hot reset path to accept device fd
Date:   Wed,  8 Mar 2023 05:28:49 -0800
Message-Id: <20230308132903.465159-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308132903.465159-1-yi.l.liu@intel.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No function change is intended, just to make the helpers and structures
to be prepared to accept device fds as proof of device ownership.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 40 ++++++++++++++++----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f13b093557a9..265a0058436c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -177,10 +177,10 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 	}
 }
 
-struct vfio_pci_group_info;
+struct vfio_pci_user_file_info;
 static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups);
+				      struct vfio_pci_user_file_info *user_info);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -799,7 +799,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
-struct vfio_pci_group_info {
+struct vfio_pci_user_file_info {
 	int count;
 	struct file **files;
 };
@@ -1260,9 +1260,9 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 {
 	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
 	struct vfio_pci_hot_reset hdr;
-	int32_t *group_fds;
+	int32_t *user_fds;
 	struct file **files;
-	struct vfio_pci_group_info info;
+	struct vfio_pci_user_file_info info;
 	bool slot = false;
 	int file_idx, count = 0, ret = 0;
 
@@ -1292,17 +1292,17 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	if (!hdr.count || hdr.count > count)
 		return -EINVAL;
 
-	group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
+	user_fds = kcalloc(hdr.count, sizeof(*user_fds), GFP_KERNEL);
 	files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
-	if (!group_fds || !files) {
-		kfree(group_fds);
+	if (!user_fds || !files) {
+		kfree(user_fds);
 		kfree(files);
 		return -ENOMEM;
 	}
 
-	if (copy_from_user(group_fds, arg->group_fds,
-			   hdr.count * sizeof(*group_fds))) {
-		kfree(group_fds);
+	if (copy_from_user(user_fds, arg->group_fds,
+			   hdr.count * sizeof(*user_fds))) {
+		kfree(user_fds);
 		kfree(files);
 		return -EFAULT;
 	}
@@ -1312,7 +1312,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	 * the reset
 	 */
 	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
-		struct file *file = fget(group_fds[file_idx]);
+		struct file *file = fget(user_fds[file_idx]);
 
 		if (!file) {
 			ret = -EBADF;
@@ -1329,9 +1329,9 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		files[file_idx] = file;
 	}
 
-	kfree(group_fds);
+	kfree(user_fds);
 
-	/* release reference to groups on error */
+	/* release reference to user_fds on error */
 	if (ret)
 		goto hot_reset_release;
 
@@ -2312,13 +2312,13 @@ const struct pci_error_handlers vfio_pci_core_err_handlers = {
 };
 EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
-static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
-			       struct vfio_pci_group_info *groups)
+static bool vfio_dev_in_user_fds(struct vfio_pci_core_device *vdev,
+				 struct vfio_pci_user_file_info *user_info)
 {
 	unsigned int i;
 
-	for (i = 0; i < groups->count; i++)
-		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
+	for (i = 0; i < user_info->count; i++)
+		if (vfio_file_has_dev(user_info->files[i], &vdev->vdev))
 			return true;
 	return false;
 }
@@ -2398,7 +2398,7 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
  * get each memory_lock.
  */
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups)
+				      struct vfio_pci_user_file_info *user_info)
 {
 	struct vfio_pci_core_device *cur_mem;
 	struct vfio_pci_core_device *cur_vma;
@@ -2445,7 +2445,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 * set of groups provided by the user.
 		 */
 		if (cur_vma->vdev.open_count &&
-		    !vfio_dev_in_groups(cur_vma, groups)) {
+		    !vfio_dev_in_user_fds(cur_vma, user_info)) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
-- 
2.34.1

