Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F356508C3
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiLSIsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiLSIro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:47:44 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641C3A1BB
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439663; x=1702975663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z1++cwa/9BiEjOCi3HhFCFArXNMgBy54jPpO2RM1dAU=;
  b=h9Fm10ddvJ7NaZap556EBCi1xabwfZWQcbR3ewbRCmtZi6uC+WoslYDQ
   eFt2ghp3Zd8+gOz0hkKmbqLyzgkzDBs532qSb+zL8vd4Vo2Q6XBatQ0rX
   v7ep4ZH0Q24z52iEnMpQ393XTxlNbK4xc5sMXZB6bOqGumS0svu8UZO8h
   3ZTioLpU+bv2kjYpa/m4IzXZccrYMTYtA7pVldadgerSQnhvfc/loqspH
   C6kcP7MoJKrtcjF/bWaSz1dERw0xWhEq2WvFddk+Fle+OZuy09Vdy9nrc
   5cdIOokWVlrBj1kme03kZAZodAsTshozkbuKeChfarBFxuRnuJNTAOlwe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381528470"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381528470"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:47:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628233781"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628233781"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 00:47:42 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com
Subject: [RFC 07/12] vfio: Block device access via device fd until device is opened
Date:   Mon, 19 Dec 2022 00:47:13 -0800
Message-Id: <20221219084718.9342-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219084718.9342-1-yi.l.liu@intel.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
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
opened but the device is not opened. This inbetween state is not used
when the device FD is spawned from the group FD, however when we create
the device FD directly by opening a cdev it will be opened in the
blocked state.

In the blocked state, currently only the bind operation is allowed,
other device accesses are not allowed. Completing bind will allow user
to further access the device.

This is implemented by adding a flag in struct vfio_device_file to mark
the blocked state and using a simple smp_load_acquire() to obtain the
flag value and serialize all the device setup with the thread accessing
this device.

Due to this scheme it is not possible to unbind the FD, once it bound it
remains bound until the FD is closed.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 24ccf9f0ab16..4f29e3a89f64 100644
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
index 2aa3597abb40..bd1d9621af46 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -444,6 +444,11 @@ int vfio_device_open(struct vfio_device_file *df)
 		}
 	}
 
+	/*
+	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
+	 * read/write/mmap
+	 */
+	smp_store_release(&df->access_granted, true);
 	return 0;
 }
 
@@ -452,6 +457,11 @@ void vfio_device_close(struct vfio_device_file *df)
 	struct vfio_device *device = df->device;
 
 	mutex_lock(&device->dev_set->lock);
+	/*
+	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
+	 * read/write/mmap
+	 */
+	smp_store_release(&df->access_granted, false);
 	vfio_assert_device_open(device);
 	if (device->open_count == 1)
 		vfio_device_last_close(df);
@@ -968,8 +978,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	bool access;
 	int ret;
 
+	/* Paired with smp_store_release() in vfio_device_open/close() */
+	access = smp_load_acquire(&df->access_granted);
+	if (!access)
+		return -EINVAL;
+
 	ret = vfio_device_pm_runtime_get(device);
 	if (ret)
 		return ret;
@@ -996,6 +1012,12 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	bool access;
+
+	/* Paired with smp_store_release() in vfio_device_open/close() */
+	access = smp_load_acquire(&df->access_granted);
+	if (!access)
+		return -EINVAL;
 
 	if (unlikely(!device->ops->read))
 		return -EINVAL;
@@ -1009,6 +1031,12 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	bool access;
+
+	/* Paired with smp_store_release() in vfio_device_open/close() */
+	access = smp_load_acquire(&df->access_granted);
+	if (!access)
+		return -EINVAL;
 
 	if (unlikely(!device->ops->write))
 		return -EINVAL;
@@ -1020,6 +1048,12 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	bool access;
+
+	/* Paired with smp_store_release() in vfio_device_open/close() */
+	access = smp_load_acquire(&df->access_granted);
+	if (!access)
+		return -EINVAL;
 
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
-- 
2.34.1

