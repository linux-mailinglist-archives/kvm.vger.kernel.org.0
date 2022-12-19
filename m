Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080576508BD
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiLSIrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiLSIri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:47:38 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A996371
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439657; x=1702975657;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ACx54HxGUeHgxluZ+kGu+CJ2XPcih3ut499Z3ClBK/k=;
  b=h8LWB9o5HSXsZlzS1zx0dFskx9G0TK2rbnFV+LkG4ufOveW37YzQz0UJ
   /Z6IyfQDaNcm8D1eQz02PFuTpV5tV0WyFbv0ytipS/TfQaz62yy5MlBVD
   vbm50KoAxqPi2VN4ri6UTP0Z8CHUKhX04oXVux59FhOCDGzDkTmxP7Z8y
   RayA7LPaZWrTInq2QK7g62VL8hp0hi3tnLoBEs+7DEqWFv7GUJQ1H0HFB
   h0jQfxX4Q75JJjiU9ZLet1e941yGVMnW/Xpd2ZLarbuFrIrp6Jy8FOMfN
   UH3+aq4hRamA5AE28Bud2NVQTFi9TihdJfrWaeCrZbaBvHqdJXtn7XxAG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381528431"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381528431"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:47:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628233719"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628233719"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 00:47:36 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com
Subject: [RFC 01/12] vfio: Allocate per device file structure
Date:   Mon, 19 Dec 2022 00:47:07 -0800
Message-Id: <20221219084718.9342-2-yi.l.liu@intel.com>
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

This is preparation for adding vfio device cdev support. vfio device
cdev requires:
1) a per device file memory to store the kvm pointer set by KVM. It will
   be propagated to vfio_device:kvm after the device cdev file is bound
   to an iommufd
2) a mechanism to block device access through device cdev fd before it
   is bound to an iommufd

To address above requirements, this adds a per device file structure
named vfio_device_file. For now, it's only a wrapper of struct vfio_device
pointer. Other fields will be added to this per file structure in future
commits.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 13 +++++++++++--
 drivers/vfio/vfio.h      |  6 ++++++
 drivers/vfio/vfio_main.c | 31 +++++++++++++++++++++++++------
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index c5d8bf10495e..eb0fbc33217f 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -186,19 +186,26 @@ void vfio_device_group_close(struct vfio_device *device)
 
 static struct file *vfio_device_open_file(struct vfio_device *device)
 {
+	struct vfio_device_file *df;
 	struct file *filep;
 	int ret;
 
+	df = vfio_allocate_device_file(device);
+	if (IS_ERR(df)) {
+		ret = PTR_ERR(df);
+		goto err_out;
+	}
+
 	ret = vfio_device_group_open(device);
 	if (ret)
-		goto err_out;
+		goto err_free;
 
 	/*
 	 * We can't use anon_inode_getfd() because we need to modify
 	 * the f_mode flags directly to allow more than just ioctls
 	 */
 	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
-				   device, O_RDWR);
+				   df, O_RDWR);
 	if (IS_ERR(filep)) {
 		ret = PTR_ERR(filep);
 		goto err_close_device;
@@ -222,6 +229,8 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 
 err_close_device:
 	vfio_device_group_close(device);
+err_free:
+	kfree(df);
 err_out:
 	return ERR_PTR(ret);
 }
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 2e05418fd18d..2bfa05ad4c84 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -16,12 +16,18 @@ struct iommu_group;
 struct vfio_device;
 struct vfio_container;
 
+struct vfio_device_file {
+	struct vfio_device *device;
+};
+
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
 int vfio_device_open(struct vfio_device *device,
 		     struct iommufd_ctx *iommufd, struct kvm *kvm);
 void vfio_device_close(struct vfio_device *device,
 		       struct iommufd_ctx *iommufd);
+struct vfio_device_file *
+vfio_allocate_device_file(struct vfio_device *device);
 
 extern const struct file_operations vfio_device_fops;
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e21ff965141e..2ad08ef377d2 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -358,6 +358,20 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
 
+struct vfio_device_file *
+vfio_allocate_device_file(struct vfio_device *device)
+{
+	struct vfio_device_file *df;
+
+	df = kzalloc(sizeof(*df), GFP_KERNEL_ACCOUNT);
+	if (!df)
+		return ERR_PTR(-ENOMEM);
+
+	df->device = device;
+
+	return df;
+}
+
 static int vfio_device_first_open(struct vfio_device *device,
 				  struct iommufd_ctx *iommufd, struct kvm *kvm)
 {
@@ -475,10 +489,11 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
  */
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 
 	vfio_device_group_close(device);
-
+	kfree(df);
 	vfio_device_put_registration(device);
 
 	return 0;
@@ -943,7 +958,8 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 	int ret;
 
 	ret = vfio_device_pm_runtime_get(device);
@@ -970,7 +986,8 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 				     size_t count, loff_t *ppos)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 
 	if (unlikely(!device->ops->read))
 		return -EINVAL;
@@ -982,7 +999,8 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 				      const char __user *buf,
 				      size_t count, loff_t *ppos)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 
 	if (unlikely(!device->ops->write))
 		return -EINVAL;
@@ -992,7 +1010,8 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 
 static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
-- 
2.34.1

