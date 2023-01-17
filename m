Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF1766DF5A
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjAQNuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjAQNuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:50:03 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FBB3B674
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963394; x=1705499394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X2wMousrXWtPiKPa2X5dsrGJnfQx7rARTKO+czpRmCg=;
  b=DX60nCxEjGiMS9ykzj88ux+jUOQ97/GWWeokT5EgwdLl4D64DUHkCqW8
   SabsVI8sdfHIkcDpDFXSNcglF6FAcI9YyprGgwxUPxZgU5H/v/P3e6Y3T
   1xTOzmP+AjLz7iwZeT0sAFwlZZ7tUfyxxS8YzEf/FW0yXLoq/oukrp75N
   28OmYFjEZW+7xuYXTC4+3na0mSwKtHxDxLqXTZLK5WS6+aqAgBFHElgyF
   GAoxBWPlgW39r+hC03PN4Oi9PushhDt+EXIFr0TRrmGiwqItrDqLPy+lP
   5buiDj2U18R6ETo+pLfKBMikxJ1TJdAZvgw/DllngvdJES3koQbLVjeyt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766424"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766424"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:49:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551050"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551050"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:52 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: [PATCH 07/13] vfio: Pass struct vfio_device_file * to vfio_device_open/close()
Date:   Tue, 17 Jan 2023 05:49:36 -0800
Message-Id: <20230117134942.101112-8-yi.l.liu@intel.com>
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

This avoids passing struct kvm * and struct iommufd_ctx * in multiple
functions. vfio_device_open() becomes to be a locked helper.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 34 +++++++++++++++++++++++++---------
 drivers/vfio/vfio.h      | 10 +++++-----
 drivers/vfio/vfio_main.c | 40 ++++++++++++++++++++++++----------------
 3 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index d83cf069d290..7200304663e5 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -154,33 +154,49 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 	return ret;
 }
 
-static int vfio_device_group_open(struct vfio_device *device)
+static int vfio_device_group_open(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
 	int ret;
 
 	mutex_lock(&device->group->group_lock);
 	if (!vfio_group_has_iommu(device->group)) {
 		ret = -EINVAL;
-		goto out_unlock;
+		goto err_unlock_group;
 	}
 
+	mutex_lock(&device->dev_set->lock);
 	/*
 	 * Here we pass the KVM pointer with the group under the lock.  If the
 	 * device driver will use it, it must obtain a reference and release it
 	 * during close_device.
 	 */
-	ret = vfio_device_open(device, device->group->iommufd,
-			       device->group->kvm);
+	df->kvm = device->group->kvm;
+	df->iommufd = device->group->iommufd;
+
+	ret = vfio_device_open(df);
+	if (ret)
+		goto err_unlock_device;
+	mutex_unlock(&device->dev_set->lock);
 
-out_unlock:
+	mutex_unlock(&device->group->group_lock);
+	return 0;
+
+err_unlock_device:
+	df->kvm = NULL;
+	df->iommufd = NULL;
+	mutex_unlock(&device->dev_set->lock);
+err_unlock_group:
 	mutex_unlock(&device->group->group_lock);
 	return ret;
 }
 
-void vfio_device_group_close(struct vfio_device *device)
+void vfio_device_group_close(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
+
 	mutex_lock(&device->group->group_lock);
-	vfio_device_close(device, device->group->iommufd);
+	vfio_device_close(df);
 	mutex_unlock(&device->group->group_lock);
 }
 
@@ -196,7 +212,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 		goto err_out;
 	}
 
-	ret = vfio_device_group_open(device);
+	ret = vfio_device_group_open(df);
 	if (ret)
 		goto err_free;
 
@@ -228,7 +244,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 	return filep;
 
 err_close_device:
-	vfio_device_group_close(device);
+	vfio_device_group_close(df);
 err_free:
 	kfree(df);
 err_out:
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 53af6e3ea214..3d8ba165146c 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -19,14 +19,14 @@ struct vfio_container;
 struct vfio_device_file {
 	struct vfio_device *device;
 	struct kvm *kvm;
+	struct iommufd_ctx *iommufd;
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
-int vfio_device_open(struct vfio_device *device,
-		     struct iommufd_ctx *iommufd, struct kvm *kvm);
-void vfio_device_close(struct vfio_device *device,
-		       struct iommufd_ctx *iommufd);
+int vfio_device_open(struct vfio_device_file *df);
+void vfio_device_close(struct vfio_device_file *device);
+
 struct vfio_device_file *
 vfio_allocate_device_file(struct vfio_device *device);
 
@@ -90,7 +90,7 @@ void vfio_device_group_register(struct vfio_device *device);
 void vfio_device_group_unregister(struct vfio_device *device);
 int vfio_device_group_use_iommu(struct vfio_device *device);
 void vfio_device_group_unuse_iommu(struct vfio_device *device);
-void vfio_device_group_close(struct vfio_device *device);
+void vfio_device_group_close(struct vfio_device_file *df);
 struct vfio_group *vfio_group_from_file(struct file *file);
 bool vfio_group_enforced_coherent(struct vfio_group *group);
 void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index dc08d5dd62cc..3df71bd9cd1e 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -358,9 +358,11 @@ vfio_allocate_device_file(struct vfio_device *device)
 	return df;
 }
 
-static int vfio_device_first_open(struct vfio_device *device,
-				  struct iommufd_ctx *iommufd, struct kvm *kvm)
+static int vfio_device_first_open(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
+	struct iommufd_ctx *iommufd = df->iommufd;
+	struct kvm *kvm = df->kvm;
 	int ret;
 
 	lockdep_assert_held(&device->dev_set->lock);
@@ -394,9 +396,11 @@ static int vfio_device_first_open(struct vfio_device *device,
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
@@ -409,30 +413,34 @@ static void vfio_device_last_close(struct vfio_device *device,
 	module_put(device->dev->driver->owner);
 }
 
-int vfio_device_open(struct vfio_device *device,
-		     struct iommufd_ctx *iommufd, struct kvm *kvm)
+int vfio_device_open(struct vfio_device_file *df)
 {
-	int ret = 0;
+	struct vfio_device *device = df->device;
+
+	lockdep_assert_held(&device->dev_set->lock);
 
-	mutex_lock(&device->dev_set->lock);
 	device->open_count++;
 	if (device->open_count == 1) {
-		ret = vfio_device_first_open(device, iommufd, kvm);
-		if (ret)
+		int ret;
+
+		ret = vfio_device_first_open(df);
+		if (ret) {
 			device->open_count--;
+			return ret;
+		}
 	}
-	mutex_unlock(&device->dev_set->lock);
 
-	return ret;
+	return 0;
 }
 
-void vfio_device_close(struct vfio_device *device,
-		       struct iommufd_ctx *iommufd)
+void vfio_device_close(struct vfio_device_file *df)
 {
+	struct vfio_device *device = df->device;
+
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
 	if (device->open_count == 1)
-		vfio_device_last_close(device, iommufd);
+		vfio_device_last_close(df);
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 }
@@ -478,7 +486,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	vfio_device_group_close(device);
+	vfio_device_group_close(df);
 
 	vfio_device_put_registration(device);
 
-- 
2.34.1

