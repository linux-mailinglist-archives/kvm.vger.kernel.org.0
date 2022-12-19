Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF7F6508C2
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiLSIsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiLSIro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:47:44 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B4DA444
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439662; x=1702975662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iARyju5j7zMxzngW4OV9Q9wFKYeL68bdy1M4JIwiA18=;
  b=BNmMDFl2ochpacSyImGhYNZ0D+poD/NBhlncXUqRyLZ1luIVeaUqPDZs
   xbBI2Gz4OcLoo06G7r0qj5zbCUbhT49/J8yy3rvIRgpB9PFMxs7PFIe15
   iYJoEkw74OnRI/HK5FuDSINvFi2uKWV05/Ii/qPqnYOuM2PFfdIYxIj8a
   UL1Sm+M92Y+yBF/7PdT1xrvGkKiIlsj9BLN7StzOZbhxqekfPQRgPRxHJ
   K8sg0Irnh8uZ8U4dwL8awNbNFqiO+8qaBEy0opn/2ax+BO/4tj6VW1yX+
   bo1sVtRkn3rl1ZMNbC6l5+Hg7LxwDGQfegYVGdowcgpwAZF3JD+1qEDjK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381528465"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381528465"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:47:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628233772"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628233772"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 00:47:41 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com
Subject: [RFC 06/12] vfio: Pass struct vfio_device_file * to vfio_device_open/close()
Date:   Mon, 19 Dec 2022 00:47:12 -0800
Message-Id: <20221219084718.9342-7-yi.l.liu@intel.com>
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

This avoids passing struct kvm * and struct iommufd_ctx * in multiple
functions. vfio_device_open() becomes to be a locked helper, while
vfio_device_open() still holds device->dev_set->lock itself.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 34 +++++++++++++++++++++++++---------
 drivers/vfio/vfio.h      | 10 +++++-----
 drivers/vfio/vfio_main.c | 40 ++++++++++++++++++++++++----------------
 3 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index fe73db270984..1030a0ad3cf1 100644
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
index f0e411995997..24ccf9f0ab16 100644
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
index 481502a6964a..2aa3597abb40 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -372,9 +372,11 @@ vfio_allocate_device_file(struct vfio_device *device)
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
@@ -408,9 +410,11 @@ static int vfio_device_first_open(struct vfio_device *device,
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
@@ -423,30 +427,34 @@ static void vfio_device_last_close(struct vfio_device *device,
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
@@ -492,7 +500,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	vfio_device_group_close(device);
+	vfio_device_group_close(df);
 	kfree(df);
 	vfio_device_put_registration(device);
 
-- 
2.34.1

