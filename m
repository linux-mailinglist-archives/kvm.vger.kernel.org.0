Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A45C6B0914
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjCHNbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjCHNaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:30:46 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57678E3F6;
        Wed,  8 Mar 2023 05:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282170; x=1709818170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xzsdz0GZ0x3LH67TtI4aQESYRlZwoGYHkjcQObdvaxo=;
  b=kTPHW0irYYT+DfZLn1X1WUrc0Wx2fyof54uhqIsBVmuIBgRKBmBGr5Rr
   j1RaePdcCTXPA5X8GVmzwHjwuQsETd2wDFpx/2I2ak4R6c6DzvHrQBqan
   QsGhQtdjyHCzhlMniAIEUGa7JZNSqR1din0O8e34shikuB5ly3MIS297O
   9kWh2b1cxU9weBeG/cpQckMw7FJIflgUAj/siaoPRYaJrBDtM4hmCl7mh
   Y8DiN4N0uatDqaJX5tBdCv6h1oSONzPzOsMZWXwUhO3FLBkK4JovHbXe9
   Yw+DAB7MHkVbOidDwh2wqMzicW7sMpc8kLU7Io1BhZ4T//PiNjipyeAFp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165152"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165152"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789318"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789318"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:16 -0800
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
Subject: [PATCH v6 06/24] vfio: Pass struct vfio_device_file * to vfio_device_open/close()
Date:   Wed,  8 Mar 2023 05:28:45 -0800
Message-Id: <20230308132903.465159-7-yi.l.liu@intel.com>
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

This avoids passing too much parameters in multiple functions.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/group.c     | 19 +++++++++++++------
 drivers/vfio/vfio.h      |  8 ++++----
 drivers/vfio/vfio_main.c | 25 +++++++++++++++----------
 3 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index a293e1f92e89..160a4c891dda 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -169,8 +169,9 @@ static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
 	spin_unlock(&device->group->kvm_ref_lock);
 }
 
-static int vfio_device_group_open(struct vfio_device *device)
+static int vfio_device_group_open(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
 	int ret;
 
 	mutex_lock(&device->group->group_lock);
@@ -190,7 +191,11 @@ static int vfio_device_group_open(struct vfio_device *device)
 	if (device->open_count == 0)
 		vfio_device_group_get_kvm_safe(device);
 
-	ret = vfio_device_open(device, device->group->iommufd);
+	df->iommufd = device->group->iommufd;
+
+	ret = vfio_device_open(df);
+	if (ret)
+		df->iommufd = NULL;
 
 	if (device->open_count == 0)
 		vfio_device_put_kvm(device);
@@ -202,12 +207,14 @@ static int vfio_device_group_open(struct vfio_device *device)
 	return ret;
 }
 
-void vfio_device_group_close(struct vfio_device *device)
+void vfio_device_group_close(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
+
 	mutex_lock(&device->group->group_lock);
 	mutex_lock(&device->dev_set->lock);
 
-	vfio_device_close(device, device->group->iommufd);
+	vfio_device_close(df);
 
 	if (device->open_count == 0)
 		vfio_device_put_kvm(device);
@@ -228,7 +235,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 		goto err_out;
 	}
 
-	ret = vfio_device_group_open(device);
+	ret = vfio_device_group_open(df);
 	if (ret)
 		goto err_free;
 
@@ -260,7 +267,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 	return filep;
 
 err_close_device:
-	vfio_device_group_close(device);
+	vfio_device_group_close(df);
 err_free:
 	kfree(df);
 err_out:
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 69e1a0692b06..7ced404526d9 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -20,13 +20,13 @@ struct vfio_device_file {
 	struct vfio_device *device;
 	spinlock_t kvm_ref_lock; /* protect kvm field */
 	struct kvm *kvm;
+	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
-int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd);
-void vfio_device_close(struct vfio_device *device,
-		       struct iommufd_ctx *iommufd);
+int vfio_device_open(struct vfio_device_file *df);
+void vfio_device_close(struct vfio_device_file *df);
 struct vfio_device_file *
 vfio_allocate_device_file(struct vfio_device *device);
 
@@ -91,7 +91,7 @@ void vfio_device_group_register(struct vfio_device *device);
 void vfio_device_group_unregister(struct vfio_device *device);
 int vfio_device_group_use_iommu(struct vfio_device *device);
 void vfio_device_group_unuse_iommu(struct vfio_device *device);
-void vfio_device_group_close(struct vfio_device *device);
+void vfio_device_group_close(struct vfio_device_file *df);
 struct vfio_group *vfio_group_from_file(struct file *file);
 bool vfio_group_enforced_coherent(struct vfio_group *group);
 void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 03d5b2979f79..8c9b05f540fd 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -419,9 +419,10 @@ vfio_allocate_device_file(struct vfio_device *device)
 	return df;
 }
 
-static int vfio_device_first_open(struct vfio_device *device,
-				  struct iommufd_ctx *iommufd)
+static int vfio_device_first_open(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
+	struct iommufd_ctx *iommufd = df->iommufd;
 	int ret;
 
 	lockdep_assert_held(&device->dev_set->lock);
@@ -453,9 +454,11 @@ static int vfio_device_first_open(struct vfio_device *device,
 	return ret;
 }
 
-static void vfio_device_last_close(struct vfio_device *device,
-				   struct iommufd_ctx *iommufd)
+static void vfio_device_last_close(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
+	struct iommufd_ctx *iommufd = df->iommufd;
+
 	lockdep_assert_held(&device->dev_set->lock);
 
 	if (device->ops->close_device)
@@ -467,15 +470,16 @@ static void vfio_device_last_close(struct vfio_device *device,
 	module_put(device->dev->driver->owner);
 }
 
-int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd)
+int vfio_device_open(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
 	int ret = 0;
 
 	lockdep_assert_held(&device->dev_set->lock);
 
 	device->open_count++;
 	if (device->open_count == 1) {
-		ret = vfio_device_first_open(device, iommufd);
+		ret = vfio_device_first_open(df);
 		if (ret)
 			device->open_count--;
 	}
@@ -483,14 +487,15 @@ int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd)
 	return ret;
 }
 
-void vfio_device_close(struct vfio_device *device,
-		       struct iommufd_ctx *iommufd)
+void vfio_device_close(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
+
 	lockdep_assert_held(&device->dev_set->lock);
 
 	vfio_assert_device_open(device);
 	if (device->open_count == 1)
-		vfio_device_last_close(device, iommufd);
+		vfio_device_last_close(df);
 	device->open_count--;
 }
 
@@ -535,7 +540,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	vfio_device_group_close(device);
+	vfio_device_group_close(df);
 
 	vfio_device_put_registration(device);
 
-- 
2.34.1

