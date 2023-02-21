Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570DD69D9C0
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbjBUDt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbjBUDtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:49:25 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6892B252A4;
        Mon, 20 Feb 2023 19:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676951351; x=1708487351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/h9a1UpumCTWmQmp37F9w/rOzmCKJYFD57pL6RR5oNg=;
  b=H6rowMv9sknXVtzRGcbwtqcLoLAD6ZuFACb9BQhZhVJ+C+5tR1sFUG2p
   Z+oyWvLaxlJHFr4L1FfEifQwXX+E1ZheBCsONci2lt/hOJpVkVe/Vpu73
   CWW867kekxXHSrwIC1pXhR5X0CtZAIoTWWNSOnbccTFHjEq79uz04Z1/U
   1CCyfAjh9KoRtW7wgYvhAv/siRnuYi+0wRM8Hfd1w9psnoY5rYh1xoniu
   N8pA9c0l5AnNMkgNBES/d5+lgcmQI2WbuYOu/Aat0DPwCyzfDDQkCZTh2
   4aeEtUYhmCXvxLmbw+BguwePVoVNindb0dnDoVIG5ZhjNUtfjDbeagCc2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="397218439"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="397218439"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 19:48:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="664822169"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="664822169"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 20 Feb 2023 19:48:19 -0800
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
Subject: [PATCH v4 07/19] vfio: Block device access via device fd until device is opened
Date:   Mon, 20 Feb 2023 19:48:00 -0800
Message-Id: <20230221034812.138051-8-yi.l.liu@intel.com>
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

Allow the vfio_device file to be in a state where the device FD is
opened but the device cannot be used by userspace (i.e. its .open_device()
hasn't been called). This inbetween state is not used when the device
FD is spawned from the group FD, however when we create the device FD
directly by opening a cdev it will be opened in the blocked state.

The reason for the inbetween state is that userspace only gets a FD but
doesn't gain access permission until binding the FD to an iommufd. So in
the blocked state, only the bind operation is allowed. Completing bind
will allow user to further access the device.

This is implemented by adding a flag in struct vfio_device_file to mark
the blocked state and using a simple smp_load_acquire() to obtain the
flag value and serialize all the device setup with the thread accessing
this device.

Following this lockless scheme, it can safely handle the device FD
unbound->bound but it cannot handle bound->unbound. To allow this we'd
need to add a lock on all the vfio ioctls which seems costly. So once
device FD is bound, it remains bound until the FD is closed.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/group.c     |  6 ++++++
 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 16 ++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 2abf55c69281..14e29525e354 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -197,6 +197,12 @@ static int vfio_device_group_open(struct vfio_device_file *df)
 	if (device->open_count == 0)
 		vfio_device_put_kvm(device);
 
+	/*
+	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
+	 * read/write/mmap
+	 */
+	smp_store_release(&df->access_granted, true);
+
 	mutex_unlock(&device->dev_set->lock);
 
 out_unlock:
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 11e56fe079a1..d56cdb114024 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,6 +18,7 @@ struct vfio_container;
 
 struct vfio_device_file {
 	struct vfio_device *device;
+	bool access_granted;
 	spinlock_t kvm_ref_lock; /* protect kvm field */
 	struct kvm *kvm;
 	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index ea507a61e3b7..91c8f25393db 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1106,6 +1106,10 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	struct vfio_device *device = df->device;
 	int ret;
 
+	/* Paired with smp_store_release() in vfio_device_open() */
+	if (!smp_load_acquire(&df->access_granted))
+		return -EINVAL;
+
 	ret = vfio_device_pm_runtime_get(device);
 	if (ret)
 		return ret;
@@ -1133,6 +1137,10 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
+	/* Paired with smp_store_release() in vfio_device_open() */
+	if (!smp_load_acquire(&df->access_granted))
+		return -EINVAL;
+
 	if (unlikely(!device->ops->read))
 		return -EINVAL;
 
@@ -1146,6 +1154,10 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
+	/* Paired with smp_store_release() in vfio_device_open() */
+	if (!smp_load_acquire(&df->access_granted))
+		return -EINVAL;
+
 	if (unlikely(!device->ops->write))
 		return -EINVAL;
 
@@ -1157,6 +1169,10 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
+	/* Paired with smp_store_release() in vfio_device_open() */
+	if (!smp_load_acquire(&df->access_granted))
+		return -EINVAL;
+
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
 
-- 
2.34.1

