Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E021568B83C
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 10:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjBFJHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 04:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjBFJHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 04:07:08 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F423A1EFD6;
        Mon,  6 Feb 2023 01:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675674401; x=1707210401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C7WpaZv8w7vyN+pvZP4FCdmwKcbV8ktjs9obY4tho1c=;
  b=j/sc1dZBxURNnVTMczD0Ut2iCyEhdkfx1svtEdvaxXG+mtL5CwEoXdln
   hgBPXqcmEgSJrJVnF3d3KEuN+sjT/cgCnC6o8KyBraltl1xPrOb7dLyln
   yRydKpkEmMu/A4i58A0BAYC002qYrZ0Y2YgCd5jDFN4Uv9JSDfSP87ILr
   Fy4RoQoHdn2siOyi+b1JSBxx+oemhigqbdnPHi9A7007WGomgnLjKQeLX
   /bkkJKbf3pKHVjC3B6Iv/CEqUTVv+J5MJxdDyhne6SFG8YoXuJ1AgdOGt
   so9KU81BX7cfSHIGOzcpCyyGV3pKvkbfZsJAM5oOrFbefuxrW5p8B8Xmy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="309495896"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="309495896"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 01:06:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="911862860"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="911862860"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 06 Feb 2023 01:06:01 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v2 11/14] vfio: Make vfio_device_open() exclusive between group path and device cdev path
Date:   Mon,  6 Feb 2023 01:05:29 -0800
Message-Id: <20230206090532.95598-12-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206090532.95598-1-yi.l.liu@intel.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
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

With the introduction of vfio device cdev, userspace can get device
access by either the legacy group path or the cdev path. For VFIO devices,
it can only be opened by one of the group path and the cdev path at one
time. e.g. when the device is opened via cdev path, the group path should
be failed. Both paths will call into vfio_device_open(), so the exclusion
is done in it.

VFIO group has historically allowed multi-open of the device FD. This
was made secure because the "open" was executed via an ioctl to the
group FD which is itself only single open.

However, no known use of multiple device FDs today. It is kind of a
strange thing to do because new device FDs can naturally be created
via dup().

When we implement the new device uAPI (only used in cdev path) there is
no natural way to allow the device itself from being multi-opened in a
secure manner. Without the group FD we cannot prove the security context
of the opener.

Thus, when moving to the new uAPI we block the ability to multi-open
the device. Old group path still allows it. This requires vfio_device_open()
exclusive between the cdev path with the group path.

The main logic is in the vfio_device_open(). It needs to sustain both
the legacy behavior i.e. multi-open in the group path and the new
behavior i.e. single-open in the cdev path. This mixture leads to the
introduction of a new is_cdev_device flag in struct vfio_device_file,
and a single_open flag in struct vfio_device.
    - vfio_device_file::is_cdev_device is set per the vfio_device_file
      allocation.
    - vfio_device::single_open is set after open_device op is called
      successfully if vfio_device_file::is_cdev_device is set.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     |  2 +-
 drivers/vfio/vfio.h      |  4 +++-
 drivers/vfio/vfio_main.c | 26 +++++++++++++++++++++++---
 include/linux/vfio.h     |  1 +
 4 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 9f3f6f0e4942..a90273aa77ec 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -237,7 +237,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 	struct file *filep;
 	int ret;
 
-	df = vfio_allocate_device_file(device);
+	df = vfio_allocate_device_file(device, false);
 	if (IS_ERR(df)) {
 		ret = PTR_ERR(df);
 		goto err_out;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 9126500381f5..2debf0173861 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,6 +18,8 @@ struct vfio_container;
 
 struct vfio_device_file {
 	struct vfio_device *device;
+	bool is_cdev_device;
+
 	bool access_granted;
 	spinlock_t kvm_ref_lock; /* protect kvm field */
 	struct kvm *kvm;
@@ -30,7 +32,7 @@ int vfio_device_open(struct vfio_device_file *df,
 		     u32 *dev_id, u32 *pt_id);
 void vfio_device_close(struct vfio_device_file *df);
 struct vfio_device_file *
-vfio_allocate_device_file(struct vfio_device *device);
+vfio_allocate_device_file(struct vfio_device *device, bool is_cdev_device);
 
 extern const struct file_operations vfio_device_fops;
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 05dd4b89e9d1..e07b185f9820 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -398,7 +398,7 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 }
 
 struct vfio_device_file *
-vfio_allocate_device_file(struct vfio_device *device)
+vfio_allocate_device_file(struct vfio_device *device, bool is_cdev_device)
 {
 	struct vfio_device_file *df;
 
@@ -407,6 +407,7 @@ vfio_allocate_device_file(struct vfio_device *device)
 		return ERR_PTR(-ENOMEM);
 
 	df->device = device;
+	df->is_cdev_device = is_cdev_device;
 	spin_lock_init(&df->kvm_ref_lock);
 
 	return df;
@@ -472,11 +473,23 @@ int vfio_device_open(struct vfio_device_file *df,
 
 	lockdep_assert_held(&device->dev_set->lock);
 
+	/*
+	 * Device cdev path cannot support multiple device open since
+	 * it doesn't have a secure way for it. So a second device
+	 * open attempt should be failed if the caller is from a cdev
+	 * path or the device has already been opened by a cdev path.
+	 */
+	if (device->open_count != 0 &&
+	    (df->is_cdev_device || device->single_open))
+		return -EINVAL;
+
 	device->open_count++;
 	if (device->open_count == 1) {
 		ret = vfio_device_first_open(df, dev_id, pt_id);
 		if (ret)
 			device->open_count--;
+		else
+			device->single_open = df->is_cdev_device;
 	}
 
 	if (ret)
@@ -497,8 +510,10 @@ void vfio_device_close(struct vfio_device_file *df)
 	lockdep_assert_held(&device->dev_set->lock);
 
 	vfio_assert_device_open(device);
-	if (device->open_count == 1)
+	if (device->open_count == 1) {
 		vfio_device_last_close(df);
+		device->single_open = false; // clear single_open flag
+	}
 	device->open_count--;
 }
 
@@ -543,7 +558,12 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	vfio_device_group_close(df);
+	/*
+	 * group path supports multiple device open, while cdev doesn't.
+	 * So use vfio_device_group_close() for !singel_open case.
+	 */
+	if (!df->is_cdev_device)
+		vfio_device_group_close(df);
 
 	vfio_device_put_registration(device);
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 70380d4955e1..83d1e0af0a70 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -63,6 +63,7 @@ struct vfio_device {
 	struct iommufd_ctx *iommufd_ictx;
 	bool iommufd_attached;
 #endif
+	bool single_open;
 };
 
 /**
-- 
2.34.1

