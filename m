Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984F769D9CD
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbjBUDuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbjBUDuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:50:06 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E0A24CA3;
        Mon, 20 Feb 2023 19:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676951385; x=1708487385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FXzNEDf94XR/xhCGOn032JaDdGvPPpuLUojrjUnLDXU=;
  b=RWQOpk5yERXQCxd7laA5BQNG3L+02xkj7dtBYJOUZ29wMA/cYWnISBWI
   6MQKAG+luCiY5I/ZJ/2RHTa+nPXqRiF39XCDZSDNpyFF1sLc76NtwsrqH
   B1DMRNplKagerh9Gy/jsS+UZxqSh8eVrZrIwmewdWvPJfV49fI5BH0ZCJ
   5lrMGPN/USAnJciiHbqmA7mj+54VOhBFooBdfoc6ZmeVc3qUU0YujITiE
   lP4ajYAKyHbvYzfkr9WNaamve/iGdB45WF9NsLLJ61LH6pCLtN/GGCgNQ
   j2HSNPrxYZiQOc8BHN6gap1lHLqX1zDnZeP6ypPNFqzOYFu/xi0kdTkPg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="397218495"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="397218495"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 19:48:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="664822198"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="664822198"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 20 Feb 2023 19:48:24 -0800
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
Subject: [PATCH v4 13/19] vfio: Add cdev_device_open_cnt to vfio_group
Date:   Mon, 20 Feb 2023 19:48:06 -0800
Message-Id: <20230221034812.138051-14-yi.l.liu@intel.com>
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

for counting the devices that are opened via the cdev path. This count
is increased and decreased by the cdev path. The group path checks it
to achieve exclusion with the cdev path. With this, only one path (group
path or cdev path) will claim DMA ownership. This avoids scenarios in
which devices within the same group may be opened via different paths.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c | 32 ++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h  |  3 +++
 2 files changed, 35 insertions(+)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 77559e035078..c19be9ea398b 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -387,6 +387,33 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 	}
 }
 
+int vfio_device_block_group(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+	int ret = 0;
+
+	mutex_lock(&group->group_lock);
+	if (group->opened_file) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	group->cdev_device_open_cnt++;
+
+out_unlock:
+	mutex_unlock(&group->group_lock);
+	return ret;
+}
+
+void vfio_device_unblock_group(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+
+	mutex_lock(&group->group_lock);
+	group->cdev_device_open_cnt--;
+	mutex_unlock(&group->group_lock);
+}
+
 static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 {
 	struct vfio_group *group =
@@ -409,6 +436,11 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 		goto out_unlock;
 	}
 
+	if (group->cdev_device_open_cnt) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	/*
 	 * Do we need multiple instances of the group open?  Seems not.
 	 */
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 6f063e31d08a..bf84cf36eac7 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -84,8 +84,11 @@ struct vfio_group {
 	struct blocking_notifier_head	notifier;
 	struct iommufd_ctx		*iommufd;
 	spinlock_t			kvm_ref_lock;
+	unsigned int			cdev_device_open_cnt;
 };
 
+int vfio_device_block_group(struct vfio_device *device);
+void vfio_device_unblock_group(struct vfio_device *device);
 int vfio_device_set_group(struct vfio_device *device,
 			  enum vfio_group_type type);
 void vfio_device_remove_group(struct vfio_device *device);
-- 
2.34.1

