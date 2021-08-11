Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC093E947A
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhHKPXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbhHKPXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:23:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4ECC061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HOS/3iGHnmAVoNc1AqutExDZoGRAyC1u5saAq4VYpY0=; b=avzHcA9dYWntqqWUBnbhELoFuY
        VX6/cgM4BkCrcfvvGDE01TQGC+fj+RlzKttL9Wd/32n/aPKFgUdruqFQf5iQ8CTgoByPYitOCcSSq
        tsZ+E/PkaUtAgnVO+kcfa/GtF13JBgkcgyPvz9xFi8y8nz5AdgRf5ngmuFLhpbLG3akAhpQzziUfc
        OWw+NFalLbWTUV5GIkz21LMatF6SprKerJHwGC+JfY94WeGYWqZNPzDibo3O9TsgdD4HGdTTVaWw2
        UGu0bav7SfgdDyG+13QOa0HALwd28QZbDksB/3JQTeCNwPHba2Fh2alLYe792Z50j8RYO5vwNM9XV
        MwogkEaw==;
Received: from [2001:4bb8:184:6215:ac7b:970b:bd9c:c36c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDq30-00DYcN-55; Wed, 11 Aug 2021 15:21:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 07/14] vfio: simplify iommu group allocation for mediated devices
Date:   Wed, 11 Aug 2021 17:14:53 +0200
Message-Id: <20210811151500.2744-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811151500.2744-1-hch@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reuse the logic in vfio_noiommu_group_alloc to allocate a single-device
iommu group for mediated device.  For this a new
vfio_register_mediated_dev is added that calls vfio_noiommu_group_alloc.
The noiommu boolean in struct vfio_group is replaced with a set of flags
to that mediated devices can be distinguished from noiommu devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/mdev/mdev_driver.c | 46 ++---------------------
 drivers/vfio/mdev/vfio_mdev.c   |  2 +-
 drivers/vfio/vfio.c             | 66 ++++++++++++++++++++-------------
 include/linux/vfio.h            |  1 +
 samples/vfio-mdev/mbochs.c      |  2 +-
 samples/vfio-mdev/mdpy.c        |  2 +-
 samples/vfio-mdev/mtty.c        |  2 +-
 7 files changed, 49 insertions(+), 72 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index c368ec824e2b5c..14b9ab17426838 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -13,61 +13,23 @@
 
 #include "mdev_private.h"
 
-static int mdev_attach_iommu(struct mdev_device *mdev)
-{
-	int ret;
-	struct iommu_group *group;
-
-	group = iommu_group_alloc();
-	if (IS_ERR(group))
-		return PTR_ERR(group);
-
-	ret = iommu_group_add_device(group, &mdev->dev);
-	if (!ret)
-		dev_info(&mdev->dev, "MDEV: group_id = %d\n",
-			 iommu_group_id(group));
-
-	iommu_group_put(group);
-	return ret;
-}
-
-static void mdev_detach_iommu(struct mdev_device *mdev)
-{
-	iommu_group_remove_device(&mdev->dev);
-	dev_info(&mdev->dev, "MDEV: detaching iommu\n");
-}
-
 static int mdev_probe(struct device *dev)
 {
 	struct mdev_driver *drv =
 		container_of(dev->driver, struct mdev_driver, driver);
-	struct mdev_device *mdev = to_mdev_device(dev);
-	int ret;
-
-	ret = mdev_attach_iommu(mdev);
-	if (ret)
-		return ret;
 
-	if (drv->probe) {
-		ret = drv->probe(mdev);
-		if (ret)
-			mdev_detach_iommu(mdev);
-	}
-
-	return ret;
+	if (!drv->probe)
+		return 0;
+	return drv->probe(to_mdev_device(dev));
 }
 
 static int mdev_remove(struct device *dev)
 {
 	struct mdev_driver *drv =
 		container_of(dev->driver, struct mdev_driver, driver);
-	struct mdev_device *mdev = to_mdev_device(dev);
 
 	if (drv->remove)
-		drv->remove(mdev);
-
-	mdev_detach_iommu(mdev);
-
+		drv->remove(to_mdev_device(dev));
 	return 0;
 }
 
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 7a9883048216e7..7bab075173145b 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -119,7 +119,7 @@ static int vfio_mdev_probe(struct mdev_device *mdev)
 		return -ENOMEM;
 
 	vfio_init_group_dev(vdev, &mdev->dev, &vfio_mdev_dev_ops);
-	ret = vfio_register_group_dev(vdev);
+	ret = vfio_register_mediated_dev(vdev);
 	if (ret)
 		goto out_uninit;
 
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 964e53c483baac..8d225038b04802 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -67,6 +67,9 @@ struct vfio_unbound_dev {
 	struct list_head		unbound_next;
 };
 
+#define VFIO_MEDIATED	(1 << 0)
+#define VFIO_NOIOMMU	(1 << 1)
+
 struct vfio_group {
 	struct kref			kref;
 	int				minor;
@@ -83,7 +86,7 @@ struct vfio_group {
 	struct mutex			unbound_lock;
 	atomic_t			opened;
 	wait_queue_head_t		container_q;
-	bool				noiommu;
+	unsigned int			flags;
 	unsigned int			dev_counter;
 	struct kvm			*kvm;
 	struct blocking_notifier_head	notifier;
@@ -336,7 +339,7 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
  * Group objects - create, release, get, put, search
  */
 static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
-		bool noiommu)
+		unsigned int flags)
 {
 	struct vfio_group *group, *tmp;
 	struct device *dev;
@@ -355,7 +358,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	atomic_set(&group->opened, 0);
 	init_waitqueue_head(&group->container_q);
 	group->iommu_group = iommu_group;
-	group->noiommu = noiommu;
+	group->flags = flags;
 	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
 
 	group->nb.notifier_call = vfio_iommu_group_notifier;
@@ -391,8 +394,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	}
 
 	dev = device_create(vfio.class, NULL,
-			    MKDEV(MAJOR(vfio.group_devt), minor),
-			    group, "%s%d", group->noiommu ? "noiommu-" : "",
+			    MKDEV(MAJOR(vfio.group_devt), minor), group, "%s%d",
+			    (group->flags & VFIO_NOIOMMU) ? "noiommu-" : "",
 			    iommu_group_id(iommu_group));
 	if (IS_ERR(dev)) {
 		vfio_free_group_minor(minor);
@@ -778,8 +781,8 @@ void vfio_uninit_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
 
-#ifdef CONFIG_VFIO_NOIOMMU
-static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
+static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
+		unsigned int flags)
 {
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
@@ -794,7 +797,7 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
 	if (ret)
 		goto out_put_group;
 
-	group = vfio_create_group(iommu_group, true);
+	group = vfio_create_group(iommu_group, flags);
 	if (IS_ERR(group)) {
 		ret = PTR_ERR(group);
 		goto out_remove_device;
@@ -808,7 +811,6 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
 	iommu_group_put(iommu_group);
 	return ERR_PTR(ret);
 }
-#endif
 
 static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 {
@@ -827,7 +829,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		if (noiommu && !iommu_present(dev->bus)) {
 			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
 			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
-			return vfio_noiommu_group_alloc(dev);
+			return vfio_noiommu_group_alloc(dev, VFIO_NOIOMMU);
 		}
 #endif
 		return ERR_PTR(-EINVAL);
@@ -839,7 +841,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	 */
 	group = vfio_group_get_from_iommu(iommu_group);
 	if (!group) {
-		group = vfio_create_group(iommu_group, false);
+		group = vfio_create_group(iommu_group, 0);
 		if (!IS_ERR(group))
 			return group;
 	}
@@ -848,10 +850,13 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	return group;
 }
 
-int vfio_register_group_dev(struct vfio_device *device)
+static int __vfio_register_dev(struct vfio_device *device,
+		struct vfio_group *group)
 {
 	struct vfio_device *existing_device;
-	struct vfio_group *group;
+
+	if (IS_ERR(group))
+		return PTR_ERR(group);
 
 	/*
 	 * If the driver doesn't specify a set then the device is added to a
@@ -860,16 +865,12 @@ int vfio_register_group_dev(struct vfio_device *device)
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	group = vfio_group_find_or_alloc(device->dev);
-	if (IS_ERR(group))
-		return PTR_ERR(group);
-
 	existing_device = vfio_group_get_device(group, device->dev);
 	if (existing_device) {
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(group->iommu_group));
 		vfio_device_put(existing_device);
-		if (group->noiommu)
+		if (group->flags & (VFIO_NOIOMMU | VFIO_MEDIATED))
 			iommu_group_remove_device(device->dev);
 		iommu_group_put(group->iommu_group);
 		return -EBUSY;
@@ -888,8 +889,21 @@ int vfio_register_group_dev(struct vfio_device *device)
 
 	return 0;
 }
+
+int vfio_register_group_dev(struct vfio_device *device)
+{
+	return __vfio_register_dev(device,
+		vfio_group_find_or_alloc(device->dev));
+}
 EXPORT_SYMBOL_GPL(vfio_register_group_dev);
 
+int vfio_register_mediated_dev(struct vfio_device *device)
+{
+	return __vfio_register_dev(device,
+		vfio_noiommu_group_alloc(device->dev, VFIO_MEDIATED));
+}
+EXPORT_SYMBOL_GPL(vfio_register_mediated_dev);
+
 /**
  * Get a reference to the vfio_device for a device.  Even if the
  * caller thinks they own the device, they could be racing with a
@@ -1016,7 +1030,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
-	if (group->noiommu)
+	if (group->flags & (VFIO_NOIOMMU | VFIO_MEDIATED))
 		iommu_group_remove_device(device->dev);
 	iommu_group_put(group->iommu_group);
 }
@@ -1363,7 +1377,7 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	if (atomic_read(&group->container_users))
 		return -EINVAL;
 
-	if (group->noiommu && !capable(CAP_SYS_RAWIO))
+	if ((group->flags & VFIO_NOIOMMU) && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	f = fdget(container_fd);
@@ -1383,7 +1397,7 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 
 	/* Real groups and fake groups cannot mix */
 	if (!list_empty(&container->group_list) &&
-	    container->noiommu != group->noiommu) {
+	    container->noiommu != (group->flags & VFIO_NOIOMMU)) {
 		ret = -EPERM;
 		goto unlock_out;
 	}
@@ -1397,7 +1411,7 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	}
 
 	group->container = container;
-	container->noiommu = group->noiommu;
+	container->noiommu = (group->flags & VFIO_NOIOMMU);
 	list_add(&group->container_next, &container->group_list);
 
 	/* Get a reference on the container and mark a user within the group */
@@ -1421,7 +1435,7 @@ static int vfio_group_add_container_user(struct vfio_group *group)
 	if (!atomic_inc_not_zero(&group->container_users))
 		return -EINVAL;
 
-	if (group->noiommu) {
+	if (group->flags & VFIO_NOIOMMU) {
 		atomic_dec(&group->container_users);
 		return -EPERM;
 	}
@@ -1446,7 +1460,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	    !group->container->iommu_driver || !vfio_group_viable(group))
 		return -EINVAL;
 
-	if (group->noiommu && !capable(CAP_SYS_RAWIO))
+	if ((group->flags & VFIO_NOIOMMU) && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	device = vfio_device_get_from_name(group, buf);
@@ -1493,7 +1507,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 
 	fd_install(fdno, filep);
 
-	if (group->noiommu)
+	if (group->flags & VFIO_NOIOMMU)
 		dev_warn(device->dev, "vfio-noiommu device opened by user "
 			 "(%s:%d)\n", current->comm, task_pid_nr(current));
 	return fdno;
@@ -1589,7 +1603,7 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 	if (!group)
 		return -ENODEV;
 
-	if (group->noiommu && !capable(CAP_SYS_RAWIO)) {
+	if ((group->flags & VFIO_NOIOMMU) && !capable(CAP_SYS_RAWIO)) {
 		vfio_group_put(group);
 		return -EPERM;
 	}
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f7083c2fd0d099..2ffbb2d02c9346 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -75,6 +75,7 @@ void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
 			 const struct vfio_device_ops *ops);
 void vfio_uninit_group_dev(struct vfio_device *device);
 int vfio_register_group_dev(struct vfio_device *device);
+int vfio_register_mediated_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index c313ab4d1f4e4e..f59218e03dd1b4 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -553,7 +553,7 @@ static int mbochs_probe(struct mdev_device *mdev)
 	mbochs_create_config_space(mdev_state);
 	mbochs_reset(mdev_state);
 
-	ret = vfio_register_group_dev(&mdev_state->vdev);
+	ret = vfio_register_mediated_dev(&mdev_state->vdev);
 	if (ret)
 		goto err_mem;
 	dev_set_drvdata(&mdev->dev, mdev_state);
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 8d1a80a0722aa9..4df380014ad914 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -258,7 +258,7 @@ static int mdpy_probe(struct mdev_device *mdev)
 
 	mdpy_count++;
 
-	ret = vfio_register_group_dev(&mdev_state->vdev);
+	ret = vfio_register_mediated_dev(&mdev_state->vdev);
 	if (ret)
 		goto err_mem;
 	dev_set_drvdata(&mdev->dev, mdev_state);
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 5983cdb16e3d1d..ef9f48bfe8d04f 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -741,7 +741,7 @@ static int mtty_probe(struct mdev_device *mdev)
 
 	mtty_create_config_space(mdev_state);
 
-	ret = vfio_register_group_dev(&mdev_state->vdev);
+	ret = vfio_register_mediated_dev(&mdev_state->vdev);
 	if (ret)
 		goto err_vconfig;
 	dev_set_drvdata(&mdev->dev, mdev_state);
-- 
2.30.2

