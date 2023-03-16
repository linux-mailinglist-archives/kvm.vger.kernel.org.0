Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F81B6BD00A
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjCPMz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCPMzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:55:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC10038B52;
        Thu, 16 Mar 2023 05:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678971338; x=1710507338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8seZCXB3celVVDfQAMECL1Hn/d7SvWwsCAvyGyN4R+4=;
  b=TKWU/OLne2Dpa33f7JZYPuEqdByZjJXYTYYRrYi5ARUKJMVzEutnv7Aj
   K9a05UzLylbqqv314DFbv0gkg/O1ZqpTifyS7VIThGfYjpDVPGRNJDbZj
   QvIyJWA1goESvSmrwOa2c3BfFCZb7KifY5JmYOm4GFltppNSidv/CDv6+
   fYOSCUyvro0vlCZ5v7AYe9VZJuiXcYD0VUHwdQBvm17AS9NM7NYp4tikC
   B8P2POhveQYxOVJh03LdsOUhGh5moBbN31hs8xdeuVX6QwdmNps38TkGy
   3+c8fYl9sTHglrhEd1YYPSgS3xzFA5bf3Z3JazYpQQlWodKuigq78tkC8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336667989"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336667989"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:55:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="790277739"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="790277739"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 05:55:37 -0700
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
Subject: [PATCH v7 01/22] vfio: Allocate per device file structure
Date:   Thu, 16 Mar 2023 05:55:13 -0700
Message-Id: <20230316125534.17216-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316125534.17216-1-yi.l.liu@intel.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
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
1) A per device file memory to store the kvm pointer set by KVM. It will
   be propagated to vfio_device:kvm after the device cdev file is bound
   to an iommufd.
2) A mechanism to block device access through device cdev fd before it
   is bound to an iommufd.

To address above requirements, this adds a per device file structure
named vfio_device_file. For now, it's only a wrapper of struct vfio_device
pointer. Other fields will be added to this per file structure in future
commits.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 13 +++++++++++--
 drivers/vfio/vfio.h      |  6 ++++++
 drivers/vfio/vfio_main.c | 35 ++++++++++++++++++++++++++++-------
 3 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index d0c95d033605..8a13cea43f49 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -218,19 +218,26 @@ void vfio_device_group_close(struct vfio_device *device)
 
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
@@ -254,6 +261,8 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 
 err_close_device:
 	vfio_device_group_close(device);
+err_free:
+	kfree(df);
 err_out:
 	return ERR_PTR(ret);
 }
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index c0aeea24fbd6..250fbd3786c5 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -16,11 +16,17 @@ struct iommufd_ctx;
 struct iommu_group;
 struct vfio_container;
 
+struct vfio_device_file {
+	struct vfio_device *device;
+};
+
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
 int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd);
 void vfio_device_close(struct vfio_device *device,
 		       struct iommufd_ctx *iommufd);
+struct vfio_device_file *
+vfio_allocate_device_file(struct vfio_device *device);
 
 extern const struct file_operations vfio_device_fops;
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index ebbb6b91a498..89722bf87edc 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -404,6 +404,20 @@ static bool vfio_assert_device_open(struct vfio_device *device)
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
 				  struct iommufd_ctx *iommufd)
 {
@@ -517,12 +531,15 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
  */
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 
 	vfio_device_group_close(device);
 
 	vfio_device_put_registration(device);
 
+	kfree(df);
+
 	return 0;
 }
 
@@ -1087,7 +1104,8 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 	int ret;
 
 	ret = vfio_device_pm_runtime_get(device);
@@ -1114,7 +1132,8 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 				     size_t count, loff_t *ppos)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 
 	if (unlikely(!device->ops->read))
 		return -EINVAL;
@@ -1126,7 +1145,8 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 				      const char __user *buf,
 				      size_t count, loff_t *ppos)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 
 	if (unlikely(!device->ops->write))
 		return -EINVAL;
@@ -1136,7 +1156,8 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 
 static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
-	struct vfio_device *device = filep->private_data;
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
 
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
@@ -1156,11 +1177,11 @@ const struct file_operations vfio_device_fops = {
 
 static struct vfio_device *vfio_device_from_file(struct file *file)
 {
-	struct vfio_device *device = file->private_data;
+	struct vfio_device_file *df = file->private_data;
 
 	if (file->f_op != &vfio_device_fops)
 		return NULL;
-	return device;
+	return df->device;
 }
 
 /**
-- 
2.34.1

