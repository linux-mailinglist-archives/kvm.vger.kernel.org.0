Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDE5410A34
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbhISGnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:43:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:63957 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhISGnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:43:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="203156045"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="203156045"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:41:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510701873"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:41:36 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Date:   Sun, 19 Sep 2021 14:38:30 +0800
Message-Id: <20210919063848.1476776-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces a new interface (/dev/vfio/devices/$DEVICE) for
userspace to directly open a vfio device w/o relying on container/group
(/dev/vfio/$GROUP). Anything related to group is now hidden behind
iommufd (more specifically in iommu core by this RFC) in a device-centric
manner.

In case a device is exposed in both legacy and new interfaces (see next
patch for how to decide it), this patch also ensures that when the device
is already opened via one interface then the other one must be blocked.

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.c  | 228 +++++++++++++++++++++++++++++++++++++++----
 include/linux/vfio.h |   2 +
 2 files changed, 213 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 02cc51ce6891..84436d7abedd 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -46,6 +46,12 @@ static struct vfio {
 	struct mutex			group_lock;
 	struct cdev			group_cdev;
 	dev_t				group_devt;
+	/* Fields for /dev/vfio/devices interface */
+	struct class			*device_class;
+	struct cdev			device_cdev;
+	dev_t				device_devt;
+	struct mutex			device_lock;
+	struct idr			device_idr;
 } vfio;
 
 struct vfio_iommu_driver {
@@ -81,9 +87,11 @@ struct vfio_group {
 	struct list_head		container_next;
 	struct list_head		unbound_list;
 	struct mutex			unbound_lock;
-	atomic_t			opened;
-	wait_queue_head_t		container_q;
+	struct mutex			opened_lock;
+	u32				opened;
+	bool				opened_by_nongroup_dev;
 	bool				noiommu;
+	wait_queue_head_t		container_q;
 	unsigned int			dev_counter;
 	struct kvm			*kvm;
 	struct blocking_notifier_head	notifier;
@@ -327,7 +335,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
 	INIT_LIST_HEAD(&group->unbound_list);
 	mutex_init(&group->unbound_lock);
 	atomic_set(&group->container_users, 0);
-	atomic_set(&group->opened, 0);
+	mutex_init(&group->opened_lock);
 	init_waitqueue_head(&group->container_q);
 	group->iommu_group = iommu_group;
 #ifdef CONFIG_VFIO_NOIOMMU
@@ -1489,10 +1497,53 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 	return ret;
 }
 
+/*
+ * group->opened is used to ensure that the group can be opened only via
+ * one of the two interfaces (/dev/vfio/$GROUP and /dev/vfio/devices/
+ * $DEVICE) instead of both.
+ *
+ * We also introduce a new group flag to indicate whether this group is
+ * opened via /dev/vfio/devices/$DEVICE. For multi-devices group,
+ * group->opened also tracks how many devices have been opened in the
+ * group if the new flag is true.
+ *
+ * Also add a new lock since two flags are operated here.
+ */
+static int vfio_group_try_open(struct vfio_group *group, bool nongroup_dev)
+{
+	int ret = 0;
+
+	mutex_lock(&group->opened_lock);
+	if (group->opened) {
+		if (nongroup_dev && group->opened_by_nongroup_dev)
+			group->opened++;
+		else
+			ret = -EBUSY;
+		goto out;
+	}
+
+	/*
+	 * Is something still in use from a previous open? Should
+	 * not allow new open if it is such case.
+	 */
+	if (group->container) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	group->opened = 1;
+	group->opened_by_nongroup_dev = nongroup_dev;
+
+out:
+	mutex_unlock(&group->opened_lock);
+
+	return ret;
+}
+
 static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 {
 	struct vfio_group *group;
-	int opened;
+	int ret;
 
 	group = vfio_group_get_from_minor(iminor(inode));
 	if (!group)
@@ -1503,18 +1554,10 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 		return -EPERM;
 	}
 
-	/* Do we need multiple instances of the group open?  Seems not. */
-	opened = atomic_cmpxchg(&group->opened, 0, 1);
-	if (opened) {
-		vfio_group_put(group);
-		return -EBUSY;
-	}
-
-	/* Is something still in use from a previous open? */
-	if (group->container) {
-		atomic_dec(&group->opened);
+	ret = vfio_group_try_open(group, false);
+	if (ret) {
 		vfio_group_put(group);
-		return -EBUSY;
+		return ret;
 	}
 
 	/* Warn if previous user didn't cleanup and re-init to drop them */
@@ -1534,7 +1577,9 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 
 	vfio_group_try_dissolve_container(group);
 
-	atomic_dec(&group->opened);
+	mutex_lock(&group->opened_lock);
+	group->opened--;
+	mutex_unlock(&group->opened_lock);
 
 	vfio_group_put(group);
 
@@ -1552,6 +1597,92 @@ static const struct file_operations vfio_group_fops = {
 /**
  * VFIO Device fd
  */
+static struct vfio_device *vfio_device_get_from_minor(int minor)
+{
+	struct vfio_device *device;
+
+	mutex_lock(&vfio.device_lock);
+	device = idr_find(&vfio.device_idr, minor);
+	if (!device || !vfio_device_try_get(device)) {
+		mutex_unlock(&vfio.device_lock);
+		return NULL;
+	}
+	mutex_unlock(&vfio.device_lock);
+
+	return device;
+}
+
+static int vfio_device_fops_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_device *device;
+	struct vfio_group *group;
+	int ret, opened;
+
+	device = vfio_device_get_from_minor(iminor(inode));
+	if (!device)
+		return -ENODEV;
+
+	/*
+	 * Check whether the user has opened this device via the legacy
+	 * container/group interface. If yes, then prevent the user from
+	 * opening it via device node in /dev/vfio/devices. Otherwise,
+	 * mark the group as opened to block the group interface. either
+	 * way, we must ensure only one interface is used to open the
+	 * device when it supports both legacy and new interfaces.
+	 */
+	group = vfio_group_try_get(device->group);
+	if (group) {
+		ret = vfio_group_try_open(group, true);
+		if (ret)
+			goto err_group_try_open;
+	}
+
+	/*
+	 * No support of multiple instances of the device open, similar to
+	 * the policy on the group open.
+	 */
+	opened = atomic_cmpxchg(&device->opened, 0, 1);
+	if (opened) {
+		ret = -EBUSY;
+		goto err_device_try_open;
+	}
+
+	if (!try_module_get(device->dev->driver->owner)) {
+		ret = -ENODEV;
+		goto err_module_get;
+	}
+
+	ret = device->ops->open(device);
+	if (ret)
+		goto err_device_open;
+
+	filep->private_data = device;
+
+	if (group)
+		vfio_group_put(group);
+	return 0;
+err_device_open:
+	module_put(device->dev->driver->owner);
+err_module_get:
+	atomic_dec(&device->opened);
+err_device_try_open:
+	if (group) {
+		mutex_lock(&group->opened_lock);
+		group->opened--;
+		mutex_unlock(&group->opened_lock);
+	}
+err_group_try_open:
+	if (group)
+		vfio_group_put(group);
+	vfio_device_put(device);
+	return ret;
+}
+
+static bool vfio_device_in_container(struct vfio_device *device)
+{
+	return !!(device->group && device->group->container);
+}
+
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
@@ -1560,7 +1691,16 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	module_put(device->dev->driver->owner);
 
-	vfio_group_try_dissolve_container(device->group);
+	if (vfio_device_in_container(device)) {
+		vfio_group_try_dissolve_container(device->group);
+	} else {
+		atomic_dec(&device->opened);
+		if (device->group) {
+			mutex_lock(&device->group->opened_lock);
+			device->group->opened--;
+			mutex_unlock(&device->group->opened_lock);
+		}
+	}
 
 	vfio_device_put(device);
 
@@ -1613,6 +1753,7 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 
 static const struct file_operations vfio_device_fops = {
 	.owner		= THIS_MODULE,
+	.open		= vfio_device_fops_open,
 	.release	= vfio_device_fops_release,
 	.read		= vfio_device_fops_read,
 	.write		= vfio_device_fops_write,
@@ -2295,6 +2436,52 @@ static struct miscdevice vfio_dev = {
 	.mode = S_IRUGO | S_IWUGO,
 };
 
+static char *vfio_device_devnode(struct device *dev, umode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
+}
+
+static int vfio_init_device_class(void)
+{
+	int ret;
+
+	mutex_init(&vfio.device_lock);
+	idr_init(&vfio.device_idr);
+
+	/* /dev/vfio/devices/$DEVICE */
+	vfio.device_class = class_create(THIS_MODULE, "vfio-device");
+	if (IS_ERR(vfio.device_class))
+		return PTR_ERR(vfio.device_class);
+
+	vfio.device_class->devnode = vfio_device_devnode;
+
+	ret = alloc_chrdev_region(&vfio.device_devt, 0, MINORMASK + 1, "vfio-device");
+	if (ret)
+		goto err_alloc_chrdev;
+
+	cdev_init(&vfio.device_cdev, &vfio_device_fops);
+	ret = cdev_add(&vfio.device_cdev, vfio.device_devt, MINORMASK + 1);
+	if (ret)
+		goto err_cdev_add;
+	return 0;
+
+err_cdev_add:
+	unregister_chrdev_region(vfio.device_devt, MINORMASK + 1);
+err_alloc_chrdev:
+	class_destroy(vfio.device_class);
+	vfio.device_class = NULL;
+	return ret;
+}
+
+static void vfio_destroy_device_class(void)
+{
+	cdev_del(&vfio.device_cdev);
+	unregister_chrdev_region(vfio.device_devt, MINORMASK + 1);
+	class_destroy(vfio.device_class);
+	vfio.device_class = NULL;
+	idr_destroy(&vfio.device_idr);
+}
+
 static int __init vfio_init(void)
 {
 	int ret;
@@ -2329,6 +2516,10 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_cdev_add;
 
+	ret = vfio_init_device_class();
+	if (ret)
+		goto err_init_device_class;
+
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 #ifdef CONFIG_VFIO_NOIOMMU
@@ -2336,6 +2527,8 @@ static int __init vfio_init(void)
 #endif
 	return 0;
 
+err_init_device_class:
+	cdev_del(&vfio.group_cdev);
 err_cdev_add:
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 err_alloc_chrdev:
@@ -2358,6 +2551,7 @@ static void __exit vfio_cleanup(void)
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 	class_destroy(vfio.class);
 	vfio.class = NULL;
+	vfio_destroy_device_class();
 	misc_deregister(&vfio_dev);
 }
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index a2c5b30e1763..4a5f3f99eab2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -24,6 +24,8 @@ struct vfio_device {
 	refcount_t refcount;
 	struct completion comp;
 	struct list_head group_next;
+	int minor;
+	atomic_t opened;
 };
 
 /**
-- 
2.25.1

