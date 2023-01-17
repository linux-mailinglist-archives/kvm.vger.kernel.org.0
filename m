Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D458766DF59
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjAQNuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjAQNuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:50:03 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDCA1A48B
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963396; x=1705499396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SNohEo4uoAYjf0ja6idxheK+5oGVjgxUYQVtjBwI2ec=;
  b=BK79cAyJ22hLLVaAhzrCmdZisMhxX7Asts/XXpgQrVjEW2G2iO5OZN+v
   fGfBzu7/oNZIa80iU4vP4FkFIIS6hqtExa05RmTomsQKOcum1PQrD9a4N
   BAHEBAUpO28eqzTNi0F+NTNvwwPJBTLa87XtwzPqEW5lGWHaczjJ6Sjdc
   TTpUwfB5TNTmz9pYhRycMN3heagqOPvXP3KFtysCNSNGpNf/yld3i7IdY
   +ihajvGo0YbdZ8evkMx3+dBEq1d18/KTIx2dUPfi9PttCaSENbAlJ6UVw
   lDV+gXvTv8uiZnVr55+1xD+wtf9IazKVQasQxTsbYWeJ8vhcsHuS1MNai
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766441"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766441"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:49:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551064"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551064"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:55 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: [PATCH 08/13] vfio: Block device access via device fd until device is opened
Date:   Tue, 17 Jan 2023 05:49:37 -0800
Message-Id: <20230117134942.101112-9-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117134942.101112-1-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
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

Allow the vfio_device file to be in a state where the device FD is
opened but the device cannot be used by userspace (i.e. its .open_device()
hasn't been called). This inbetween state is not used when the device
FD is spawned from the group FD, however when we create the device FD
directly by opening a cdev it will be opened in the blocked state.

In the blocked state, currently only the bind operation is allowed,
other device accesses are not allowed. Completing bind will allow user
to further access the device.

This is implemented by adding a flag in struct vfio_device_file to mark
the blocked state and using a simple smp_load_acquire() to obtain the
flag value and serialize all the device setup with the thread accessing
this device.

Due to this scheme it is not possible to unbind the FD, once it is bound,
it remains bound until the FD is closed.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 3d8ba165146c..c69a9902ea84 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -20,6 +20,7 @@ struct vfio_device_file {
 	struct vfio_device *device;
 	struct kvm *kvm;
 	struct iommufd_ctx *iommufd;
+	bool access_granted;
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 3df71bd9cd1e..d442ebaa4b21 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -430,6 +430,11 @@ int vfio_device_open(struct vfio_device_file *df)
 		}
 	}
 
+	/*
+	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
+	 * read/write/mmap
+	 */
+	smp_store_release(&df->access_granted, true);
 	return 0;
 }
 
@@ -1058,8 +1063,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	bool access;
 	int ret;
 
+	/* Paired with smp_store_release() in vfio_device_open() */
+	access = smp_load_acquire(&df->access_granted);
+	if (!access)
+		return -EINVAL;
+
 	ret = vfio_device_pm_runtime_get(device);
 	if (ret)
 		return ret;
@@ -1086,6 +1097,12 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	bool access;
+
+	/* Paired with smp_store_release() in vfio_device_open() */
+	access = smp_load_acquire(&df->access_granted);
+	if (!access)
+		return -EINVAL;
 
 	if (unlikely(!device->ops->read))
 		return -EINVAL;
@@ -1099,6 +1116,12 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	bool access;
+
+	/* Paired with smp_store_release() in vfio_device_open() */
+	access = smp_load_acquire(&df->access_granted);
+	if (!access)
+		return -EINVAL;
 
 	if (unlikely(!device->ops->write))
 		return -EINVAL;
@@ -1110,6 +1133,12 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	bool access;
+
+	/* Paired with smp_store_release() in vfio_device_open() */
+	access = smp_load_acquire(&df->access_granted);
+	if (!access)
+		return -EINVAL;
 
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
-- 
2.34.1

