Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6023D63F338
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiLAOzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiLAOzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:46 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1037BD886
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906545; x=1701442545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5HRQ1pCFxPi+biCDpg22iUYZPj5hUYPydjPJm4fpHLY=;
  b=R+DVqviID65eBkjkSe4xtLM5d33sRo2aGR3LyQbyAEJjTgqOPqvaTrJW
   agdFun/9WWINhOmG3Qbix9B/QOeq9j/Dcs9D6D+GWznsOtUurf7tXmt2D
   BQ09+pJF1lIo7Amg5pk9GQGftBctx6UragYMhU/WgGOBU2Hr4s8T97Utq
   V8BqPQAhH5pBlh4ijH8Bw2nDcSqHpqO/D8km3pn8yWrCgUdFVMF/01st6
   gYOpMQfEDOQjOtOwn4s/Xzk+Tx9mn/2YzzptreYhlcRWDh9muYIXS88Ys
   DBPQFndgXnCO7Z8ckSJb4FuhRARrel8+/a96UyOg07ElsPBlZ54dXTsAs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569319"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569319"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095189"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095189"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:44 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 07/10] vfio: Refactor vfio_device open and close
Date:   Thu,  1 Dec 2022 06:55:32 -0800
Message-Id: <20221201145535.589687-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201145535.589687-1-yi.l.liu@intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
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

This refactor makes the vfio_device_open() to accept device, iommufd_ctx
pointer and kvm pointer. These parameters are generic items in today's
group path and furute device cdev path. Caller of vfio_device_open() should
take care the necessary protections. e.g. the current group path need to
hold the group_lock to ensure the iommufd_ctx and kvm pointer are valid.

This refactor also wraps the group spefcific codes in the device open and
close paths to be paired helpers like:

- vfio_device_group_open/close(): call vfio_device_open/close()
- vfio_device_group_use/unuse_iommu(): call iommufd or container use/unuse
				       per iommufd_ctx pointer. Called by
				       vfio_device_first_open() and
				       vfio_device_last_close()

Such helpers are supposed to be moved to group.c. While iommufd related codes
will be kept in the generic helpers since future device cdev path also need
to handle iommufd.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_main.c | 133 +++++++++++++++++++++++++--------------
 1 file changed, 87 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 964d44a35624..6906aa099c0e 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -756,7 +756,38 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
 
-static int vfio_device_first_open(struct vfio_device *device)
+static int vfio_device_group_use_iommu(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+	int ret = 0;
+
+	lockdep_assert_held(&group->group_lock);
+
+	if (WARN_ON(!group->container))
+		return -EINVAL;
+
+	ret = vfio_group_use_container(group);
+	if (ret)
+		return ret;
+	vfio_device_container_register(device);
+	return 0;
+}
+
+static void vfio_device_group_unuse_iommu(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+
+	lockdep_assert_held(&group->group_lock);
+
+	if (WARN_ON(!group->container))
+		return;
+
+	vfio_device_container_unregister(device);
+	vfio_group_unuse_container(group);
+}
+
+static int vfio_device_first_open(struct vfio_device *device,
+				  struct iommufd_ctx *iommufd, struct kvm *kvm)
 {
 	int ret;
 
@@ -765,77 +796,56 @@ static int vfio_device_first_open(struct vfio_device *device)
 	if (!try_module_get(device->dev->driver->owner))
 		return -ENODEV;
 
-	/*
-	 * Here we pass the KVM pointer with the group under the lock.  If the
-	 * device driver will use it, it must obtain a reference and release it
-	 * during close_device.
-	 */
-	mutex_lock(&device->group->group_lock);
-	if (!vfio_group_has_iommu(device->group)) {
-		ret = -EINVAL;
+	if (iommufd)
+		ret = vfio_iommufd_bind(device, iommufd);
+	else
+		ret = vfio_device_group_use_iommu(device);
+	if (ret)
 		goto err_module_put;
-	}
 
-	if (device->group->container) {
-		ret = vfio_group_use_container(device->group);
-		if (ret)
-			goto err_module_put;
-		vfio_device_container_register(device);
-	} else if (device->group->iommufd) {
-		ret = vfio_iommufd_bind(device, device->group->iommufd);
-		if (ret)
-			goto err_module_put;
-	}
-
-	device->kvm = device->group->kvm;
+	device->kvm = kvm;
 	if (device->ops->open_device) {
 		ret = device->ops->open_device(device);
 		if (ret)
-			goto err_container;
+			goto err_unuse_iommu;
 	}
-	mutex_unlock(&device->group->group_lock);
 	return 0;
 
-err_container:
+err_unuse_iommu:
 	device->kvm = NULL;
-	if (device->group->container) {
-		vfio_device_container_unregister(device);
-		vfio_group_unuse_container(device->group);
-	} else if (device->group->iommufd) {
+	if (iommufd)
 		vfio_iommufd_unbind(device);
-	}
+	else
+		vfio_device_group_unuse_iommu(device);
 err_module_put:
-	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 	return ret;
 }
 
-static void vfio_device_last_close(struct vfio_device *device)
+static void vfio_device_last_close(struct vfio_device *device,
+				   struct iommufd_ctx *iommufd)
 {
 	lockdep_assert_held(&device->dev_set->lock);
 
-	mutex_lock(&device->group->group_lock);
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
-	if (device->group->container) {
-		vfio_device_container_unregister(device);
-		vfio_group_unuse_container(device->group);
-	} else if (device->group->iommufd) {
+	if (iommufd)
 		vfio_iommufd_unbind(device);
-	}
-	mutex_unlock(&device->group->group_lock);
+	else
+		vfio_device_group_unuse_iommu(device);
 	module_put(device->dev->driver->owner);
 }
 
-static int vfio_device_open(struct vfio_device *device)
+static int vfio_device_open(struct vfio_device *device,
+			    struct iommufd_ctx *iommufd, struct kvm *kvm)
 {
 	int ret = 0;
 
 	mutex_lock(&device->dev_set->lock);
 	device->open_count++;
 	if (device->open_count == 1) {
-		ret = vfio_device_first_open(device);
+		ret = vfio_device_first_open(device, iommufd, kvm);
 		if (ret)
 			device->open_count--;
 	}
@@ -844,22 +854,53 @@ static int vfio_device_open(struct vfio_device *device)
 	return ret;
 }
 
-static void vfio_device_close(struct vfio_device *device)
+static void vfio_device_close(struct vfio_device *device,
+			      struct iommufd_ctx *iommufd)
 {
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
 	if (device->open_count == 1)
-		vfio_device_last_close(device);
+		vfio_device_last_close(device, iommufd);
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 }
 
+static int vfio_device_group_open(struct vfio_device *device)
+{
+	int ret;
+
+	mutex_lock(&device->group->group_lock);
+	if (!vfio_group_has_iommu(device->group)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/*
+	 * Here we pass the KVM pointer with the group under the lock.  If the
+	 * device driver will use it, it must obtain a reference and release it
+	 * during close_device.
+	 */
+	ret = vfio_device_open(device, device->group->iommufd,
+			       device->group->kvm);
+
+out_unlock:
+	mutex_unlock(&device->group->group_lock);
+	return ret;
+}
+
+static void vfio_device_group_close(struct vfio_device *device)
+{
+	mutex_lock(&device->group->group_lock);
+	vfio_device_close(device, device->group->iommufd);
+	mutex_unlock(&device->group->group_lock);
+}
+
 static struct file *vfio_device_open_file(struct vfio_device *device)
 {
 	struct file *filep;
 	int ret;
 
-	ret = vfio_device_open(device);
+	ret = vfio_device_group_open(device);
 	if (ret)
 		goto err_out;
 
@@ -891,7 +932,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 	return filep;
 
 err_close_device:
-	vfio_device_close(device);
+	vfio_device_group_close(device);
 err_out:
 	return ERR_PTR(ret);
 }
@@ -1103,7 +1144,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
 
-	vfio_device_close(device);
+	vfio_device_group_close(device);
 
 	vfio_device_put_registration(device);
 
-- 
2.34.1

