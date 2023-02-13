Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AAD694AC9
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 16:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjBMPPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 10:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjBMPPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 10:15:19 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBF21CF4B;
        Mon, 13 Feb 2023 07:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676301300; x=1707837300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CzcwFRuRHGuRhT4hUBMtWnKCin1oHYB8n/oS+HSYTCQ=;
  b=JZJvME93LpvctjbsI8LBsV0nYm+0MVo3/HQHASF8vcYA7840ypTGztIB
   Qz4ZBNh290CiJlEyQgchgzFFbOZFh0lyA5cc3XByxjUWXwI+fzzFWgOTz
   YobAfE1zSgiiuae9uevTm4jIT37+q+TW6NjWcSaZaif6d8nmMWey9ULZN
   H0LEqRdhFkCYIHRZLLlY1YLwk4b5Ny1V82W1of3BmZNyzU3NaVl8ZqGUs
   ERqggcCknETw3E8UhhwS9CVTNCay8JZatyF6L6tUZxJKGm2Ovq1VpqMiF
   PeXJl12u7JpyC/ug3eDIVyYrFDm+BkKBRWQNS4aYMMsDRypfBsxafoqBv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="318931635"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="318931635"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 07:14:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701289684"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701289684"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2023 07:13:59 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     joro@8bytes.org, alex.williamson@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, robin.murphy@arm.com
Cc:     cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 11/15] vfio: Add cdev_device_open_cnt to vfio_group
Date:   Mon, 13 Feb 2023 07:13:44 -0800
Message-Id: <20230213151348.56451-12-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213151348.56451-1-yi.l.liu@intel.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/vfio/group.c | 5 +++++
 drivers/vfio/vfio.h  | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 9f3f6f0e4942..f3f5f4589cdd 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -403,6 +403,11 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
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
index 6f063e31d08a..7a77fb12bd2c 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -84,6 +84,7 @@ struct vfio_group {
 	struct blocking_notifier_head	notifier;
 	struct iommufd_ctx		*iommufd;
 	spinlock_t			kvm_ref_lock;
+	unsigned int			cdev_device_open_cnt;
 };
 
 int vfio_device_set_group(struct vfio_device *device,
-- 
2.34.1

