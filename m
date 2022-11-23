Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028066362A6
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238159AbiKWPCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237592AbiKWPBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:01:51 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D0B13D16
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 07:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215708; x=1700751708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SgJ2eGsOrXp+/fJzrjqBRR5imOhiYNJuNQ9qIjIIkxc=;
  b=aW1tR6jmGD9lS9Uzmx1c5DOtEJIqwkBSDBze0np2GY027ZB8u0PIOae8
   fxdY5DKgVw57AWw3JeAj4oNuKPvS+EDcNROySi2JiMc6OBwGIzDNwpNRp
   JupcSu0DUJqlsII0ywmGWJh7rSDWa2Byi8N+LYXGRfoMRRu+3mIdSC3xU
   5oNJXGqIzhiBCuhb1Zmfx/ZG+54SGfZlqFBNdkByJHBvfXBbaspxRPztb
   58KZnlWfPELuUd8wufqksTyVcink2Yq4js9qtJE4epFmB20JpPdMsct7r
   82bP8zU/k4wDvJ0LH6Tmk1SxHpaMRB1BgXXJ1BgprsVza26a0CB5ohSPO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301643010"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301643010"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674750990"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674750990"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 07:01:30 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC 10/10] vfio: Move vfio group specific code into group.c
Date:   Wed, 23 Nov 2022 07:01:13 -0800
Message-Id: <20221123150113.670399-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123150113.670399-1-yi.l.liu@intel.com>
References: <20221123150113.670399-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This prepares for compiling out vfio group after vfio device cdev is
added. No vfio_group decode code should be in vfio_main.c.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/Makefile    |   1 +
 drivers/vfio/group.c     | 834 +++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h      |  20 +
 drivers/vfio/vfio_main.c | 806 +------------------------------------
 4 files changed, 858 insertions(+), 803 deletions(-)
 create mode 100644 drivers/vfio/group.c

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index b953517dc70f..3783db7e8082 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -4,6 +4,7 @@ vfio_virqfd-y := virqfd.o
 obj-$(CONFIG_VFIO) += vfio.o
 
 vfio-y += vfio_main.o \
+	  group.o \
 	  iova_bitmap.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
 vfio-$(CONFIG_VFIO_CONTAINER) += container.o
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
new file mode 100644
index 000000000000..d8ef098c1f74
--- /dev/null
+++ b/drivers/vfio/group.c
@@ -0,0 +1,834 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VFIO core
+ *
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * Derived from original vfio:
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ */
+
+#include <linux/file.h>
+#include <linux/vfio.h>
+#include <linux/iommufd.h>
+#include "vfio.h"
+
+static struct vfio {
+	struct class			*class;
+	struct list_head		group_list;
+	struct mutex			group_lock; /* locks group_list */
+	struct ida			group_ida;
+	dev_t				group_devt;
+} vfio;
+
+/*
+ * VFIO Group fd, /dev/vfio/$GROUP
+ */
+static bool vfio_group_has_iommu(struct vfio_group *group)
+{
+	lockdep_assert_held(&group->group_lock);
+	/*
+	 * There can only be users if there is a container, and if there is a
+	 * container there must be users.
+	 */
+	WARN_ON(!group->container != !group->container_users);
+
+	return group->container || group->iommufd;
+}
+
+/*
+ * VFIO_GROUP_UNSET_CONTAINER should fail if there are other users or
+ * if there was no container to unset.  Since the ioctl is called on
+ * the group, we know that still exists, therefore the only valid
+ * transition here is 1->0.
+ */
+static int vfio_group_ioctl_unset_container(struct vfio_group *group)
+{
+	int ret = 0;
+
+	mutex_lock(&group->group_lock);
+	if (!vfio_group_has_iommu(group)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	if (group->container) {
+		if (group->container_users != 1) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+		vfio_group_detach_container(group);
+	}
+	if (group->iommufd) {
+		iommufd_ctx_put(group->iommufd);
+		group->iommufd = NULL;
+	}
+
+out_unlock:
+	mutex_unlock(&group->group_lock);
+	return ret;
+}
+
+static int vfio_group_ioctl_set_container(struct vfio_group *group,
+					  int __user *arg)
+{
+	struct vfio_container *container;
+	struct iommufd_ctx *iommufd;
+	struct fd f;
+	int ret;
+	int fd;
+
+	if (get_user(fd, arg))
+		return -EFAULT;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	mutex_lock(&group->group_lock);
+	if (vfio_group_has_iommu(group)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	if (!group->iommu_group) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	container = vfio_container_from_file(f.file);
+	if (container) {
+		ret = vfio_container_attach_group(container, group);
+		goto out_unlock;
+	}
+
+	iommufd = iommufd_ctx_from_file(f.file);
+	if (!IS_ERR(iommufd)) {
+		u32 ioas_id;
+
+		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
+		if (ret) {
+			iommufd_ctx_put(group->iommufd);
+			goto out_unlock;
+		}
+
+		group->iommufd = iommufd;
+		goto out_unlock;
+	}
+
+	/* The FD passed is not recognized. */
+	ret = -EBADFD;
+
+out_unlock:
+	mutex_unlock(&group->group_lock);
+	fdput(f);
+	return ret;
+}
+
+static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
+						     char *buf)
+{
+	struct vfio_device *it, *device = ERR_PTR(-ENODEV);
+
+	mutex_lock(&group->device_lock);
+	list_for_each_entry(it, &group->device_list, group_next) {
+		int ret;
+
+		if (it->ops->match) {
+			ret = it->ops->match(it, buf);
+			if (ret < 0) {
+				device = ERR_PTR(ret);
+				break;
+			}
+		} else {
+			ret = !strcmp(dev_name(it->dev), buf);
+		}
+
+		if (ret && vfio_device_try_get_registration(it)) {
+			device = it;
+			break;
+		}
+	}
+	mutex_unlock(&group->device_lock);
+
+	return device;
+}
+
+static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
+					  char __user *arg)
+{
+	struct vfio_device *device;
+	struct file *filep;
+	char *buf;
+	int fdno;
+	int ret;
+
+	buf = strndup_user(arg, PAGE_SIZE);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	device = vfio_device_get_from_name(group, buf);
+	kfree(buf);
+	if (IS_ERR(device))
+		return PTR_ERR(device);
+
+	fdno = get_unused_fd_flags(O_CLOEXEC);
+	if (fdno < 0) {
+		ret = fdno;
+		goto err_put_device;
+	}
+
+	filep = vfio_device_open_file(device);
+	if (IS_ERR(filep)) {
+		ret = PTR_ERR(filep);
+		goto err_put_fdno;
+	}
+
+	if (group->type == VFIO_NO_IOMMU)
+		dev_warn(device->dev, "vfio-noiommu device opened by user "
+			 "(%s:%d)\n", current->comm, task_pid_nr(current));
+
+	fd_install(fdno, filep);
+	return fdno;
+
+err_put_fdno:
+	put_unused_fd(fdno);
+err_put_device:
+	vfio_device_put_registration(device);
+	return ret;
+}
+
+static int vfio_group_ioctl_get_status(struct vfio_group *group,
+				       struct vfio_group_status __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_group_status, flags);
+	struct vfio_group_status status;
+
+	if (copy_from_user(&status, arg, minsz))
+		return -EFAULT;
+
+	if (status.argsz < minsz)
+		return -EINVAL;
+
+	status.flags = 0;
+
+	mutex_lock(&group->group_lock);
+	if (!group->iommu_group) {
+		mutex_unlock(&group->group_lock);
+		return -ENODEV;
+	}
+
+	/*
+	 * With the container FD the iommu_group_claim_dma_owner() is done
+	 * during SET_CONTAINER but for IOMMFD this is done during
+	 * VFIO_GROUP_GET_DEVICE_FD. Meaning that with iommufd
+	 * VFIO_GROUP_FLAGS_VIABLE could be set but GET_DEVICE_FD will fail due
+	 * to viability.
+	 */
+	if (vfio_group_has_iommu(group))
+		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
+				VFIO_GROUP_FLAGS_VIABLE;
+	else if (!iommu_group_dma_owner_claimed(group->iommu_group))
+		status.flags |= VFIO_GROUP_FLAGS_VIABLE;
+	mutex_unlock(&group->group_lock);
+
+	if (copy_to_user(arg, &status, minsz))
+		return -EFAULT;
+	return 0;
+}
+
+static long vfio_group_fops_unl_ioctl(struct file *filep,
+				      unsigned int cmd, unsigned long arg)
+{
+	struct vfio_group *group = filep->private_data;
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case VFIO_GROUP_GET_DEVICE_FD:
+		return vfio_group_ioctl_get_device_fd(group, uarg);
+	case VFIO_GROUP_GET_STATUS:
+		return vfio_group_ioctl_get_status(group, uarg);
+	case VFIO_GROUP_SET_CONTAINER:
+		return vfio_group_ioctl_set_container(group, uarg);
+	case VFIO_GROUP_UNSET_CONTAINER:
+		return vfio_group_ioctl_unset_container(group);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int vfio_group_fops_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_group *group =
+		container_of(inode->i_cdev, struct vfio_group, cdev);
+	int ret;
+
+	mutex_lock(&group->group_lock);
+
+	/*
+	 * drivers can be zero if this races with vfio_device_remove_group(), it
+	 * will be stable at 0 under the group rwsem
+	 */
+	if (refcount_read(&group->drivers) == 0) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
+	/*
+	 * Do we need multiple instances of the group open?  Seems not.
+	 */
+	if (group->opened_file) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+	group->opened_file = filep;
+	filep->private_data = group;
+	ret = 0;
+out_unlock:
+	mutex_unlock(&group->group_lock);
+	return ret;
+}
+
+static int vfio_group_fops_release(struct inode *inode, struct file *filep)
+{
+	struct vfio_group *group = filep->private_data;
+
+	filep->private_data = NULL;
+
+	mutex_lock(&group->group_lock);
+	/*
+	 * Device FDs hold a group file reference, therefore the group release
+	 * is only called when there are no open devices.
+	 */
+	WARN_ON(group->notifier.head);
+	if (group->container)
+		vfio_group_detach_container(group);
+	if (group->iommufd) {
+		iommufd_ctx_put(group->iommufd);
+		group->iommufd = NULL;
+	}
+	group->opened_file = NULL;
+	mutex_unlock(&group->group_lock);
+	return 0;
+}
+
+static const struct file_operations vfio_group_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= vfio_group_fops_unl_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+	.open		= vfio_group_fops_open,
+	.release	= vfio_group_fops_release,
+};
+
+/*
+ * Group objects - create, release, get, put, search
+ */
+static struct vfio_group *
+vfio_group_find_from_iommu(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group;
+
+	lockdep_assert_held(&vfio.group_lock);
+
+	/*
+	 * group->iommu_group from the vfio.group_list cannot be NULL
+	 * under the vfio.group_lock.
+	 */
+	list_for_each_entry(group, &vfio.group_list, vfio_next) {
+		if (group->iommu_group == iommu_group)
+			return group;
+	}
+	return NULL;
+}
+
+static void vfio_group_release(struct device *dev)
+{
+	struct vfio_group *group = container_of(dev, struct vfio_group, dev);
+
+	mutex_destroy(&group->device_lock);
+	mutex_destroy(&group->group_lock);
+	WARN_ON(group->iommu_group);
+	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
+	kfree(group);
+}
+
+static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
+					   enum vfio_group_type type)
+{
+	struct vfio_group *group;
+	int minor;
+
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group)
+		return ERR_PTR(-ENOMEM);
+
+	minor = ida_alloc_max(&vfio.group_ida, MINORMASK, GFP_KERNEL);
+	if (minor < 0) {
+		kfree(group);
+		return ERR_PTR(minor);
+	}
+
+	device_initialize(&group->dev);
+	group->dev.devt = MKDEV(MAJOR(vfio.group_devt), minor);
+	group->dev.class = vfio.class;
+	group->dev.release = vfio_group_release;
+	cdev_init(&group->cdev, &vfio_group_fops);
+	group->cdev.owner = THIS_MODULE;
+
+	refcount_set(&group->drivers, 1);
+	mutex_init(&group->group_lock);
+	INIT_LIST_HEAD(&group->device_list);
+	mutex_init(&group->device_lock);
+	group->iommu_group = iommu_group;
+	/* put in vfio_group_release() */
+	iommu_group_ref_get(iommu_group);
+	group->type = type;
+	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
+
+	return group;
+}
+
+static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
+		enum vfio_group_type type)
+{
+	struct vfio_group *group;
+	struct vfio_group *ret;
+	int err;
+
+	lockdep_assert_held(&vfio.group_lock);
+
+	group = vfio_group_alloc(iommu_group, type);
+	if (IS_ERR(group))
+		return group;
+
+	err = dev_set_name(&group->dev, "%s%d",
+			   group->type == VFIO_NO_IOMMU ? "noiommu-" : "",
+			   iommu_group_id(iommu_group));
+	if (err) {
+		ret = ERR_PTR(err);
+		goto err_put;
+	}
+
+	err = cdev_device_add(&group->cdev, &group->dev);
+	if (err) {
+		ret = ERR_PTR(err);
+		goto err_put;
+	}
+
+	list_add(&group->vfio_next, &vfio.group_list);
+
+	return group;
+
+err_put:
+	put_device(&group->dev);
+	return ret;
+}
+
+void vfio_device_remove_group(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+	struct iommu_group *iommu_group;
+
+	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
+		iommu_group_remove_device(device->dev);
+
+	/* Pairs with vfio_create_group() / vfio_group_get_from_iommu() */
+	if (!refcount_dec_and_mutex_lock(&group->drivers, &vfio.group_lock))
+		return;
+	list_del(&group->vfio_next);
+
+	/*
+	 * We could concurrently probe another driver in the group that might
+	 * race vfio_device_remove_group() with vfio_get_group(), so we have to
+	 * ensure that the sysfs is all cleaned up under lock otherwise the
+	 * cdev_device_add() will fail due to the name aready existing.
+	 */
+	cdev_device_del(&group->cdev, &group->dev);
+
+	mutex_lock(&group->group_lock);
+	/*
+	 * These data structures all have paired operations that can only be
+	 * undone when the caller holds a live reference on the device. Since
+	 * all pairs must be undone these WARN_ON's indicate some caller did not
+	 * properly hold the group reference.
+	 */
+	WARN_ON(!list_empty(&group->device_list));
+	WARN_ON(group->notifier.head);
+
+	/*
+	 * Revoke all users of group->iommu_group. At this point we know there
+	 * are no devices active because we are unplugging the last one. Setting
+	 * iommu_group to NULL blocks all new users.
+	 */
+	if (group->container)
+		vfio_group_detach_container(group);
+	iommu_group = group->iommu_group;
+	group->iommu_group = NULL;
+	mutex_unlock(&group->group_lock);
+	mutex_unlock(&vfio.group_lock);
+
+	iommu_group_put(iommu_group);
+	put_device(&group->dev);
+}
+
+struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
+					    enum vfio_group_type type)
+{
+	struct iommu_group *iommu_group;
+	struct vfio_group *group;
+	int ret;
+
+	iommu_group = iommu_group_alloc();
+	if (IS_ERR(iommu_group))
+		return ERR_CAST(iommu_group);
+
+	ret = iommu_group_set_name(iommu_group, "vfio-noiommu");
+	if (ret)
+		goto out_put_group;
+	ret = iommu_group_add_device(iommu_group, dev);
+	if (ret)
+		goto out_put_group;
+
+	mutex_lock(&vfio.group_lock);
+	group = vfio_create_group(iommu_group, type);
+	mutex_unlock(&vfio.group_lock);
+	if (IS_ERR(group)) {
+		ret = PTR_ERR(group);
+		goto out_remove_device;
+	}
+	iommu_group_put(iommu_group);
+	return group;
+
+out_remove_device:
+	iommu_group_remove_device(dev);
+out_put_group:
+	iommu_group_put(iommu_group);
+	return ERR_PTR(ret);
+}
+
+static bool vfio_group_has_device(struct vfio_group *group, struct device *dev)
+{
+	struct vfio_device *device;
+
+	mutex_lock(&group->device_lock);
+	list_for_each_entry(device, &group->device_list, group_next) {
+		if (device->dev == dev) {
+			mutex_unlock(&group->device_lock);
+			return true;
+		}
+	}
+	mutex_unlock(&group->device_lock);
+	return false;
+}
+
+struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
+{
+	struct iommu_group *iommu_group;
+	struct vfio_group *group;
+
+	iommu_group = iommu_group_get(dev);
+	if (!iommu_group && vfio_noiommu) {
+		/*
+		 * With noiommu enabled, create an IOMMU group for devices that
+		 * don't already have one, implying no IOMMU hardware/driver
+		 * exists.  Taint the kernel because we're about to give a DMA
+		 * capable device to a user without IOMMU protection.
+		 */
+		group = vfio_noiommu_group_alloc(dev, VFIO_NO_IOMMU);
+		if (!IS_ERR(group)) {
+			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
+		}
+		return group;
+	}
+
+	if (!iommu_group)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
+	 * restore cache coherency. It has to be checked here because it is only
+	 * valid for cases where we are using iommu groups.
+	 */
+	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY)) {
+		iommu_group_put(iommu_group);
+		return ERR_PTR(-EINVAL);
+	}
+
+	mutex_lock(&vfio.group_lock);
+	group = vfio_group_find_from_iommu(iommu_group);
+	if (group) {
+		if (WARN_ON(vfio_group_has_device(group, dev)))
+			group = ERR_PTR(-EINVAL);
+		else
+			refcount_inc(&group->drivers);
+	} else {
+		group = vfio_create_group(iommu_group, VFIO_IOMMU);
+	}
+	mutex_unlock(&vfio.group_lock);
+
+	/* The vfio_group holds a reference to the iommu_group */
+	iommu_group_put(iommu_group);
+	return group;
+}
+
+void vfio_device_group_register(struct vfio_device *device)
+{
+	mutex_lock(&device->group->device_lock);
+	list_add(&device->group_next, &device->group->device_list);
+	mutex_unlock(&device->group->device_lock);
+}
+
+void vfio_device_group_unregister(struct vfio_device *device)
+{
+	mutex_lock(&device->group->device_lock);
+	list_del(&device->group_next);
+	mutex_unlock(&device->group->device_lock);
+}
+
+int vfio_device_group_use_iommu(struct vfio_device *device)
+{
+	int ret = 0;
+
+	/*
+	 * Here we pass the KVM pointer with the group under the lock.  If the
+	 * device driver will use it, it must obtain a reference and release it
+	 * during close_device.
+	 */
+	mutex_lock(&device->group->group_lock);
+	if (!vfio_group_has_iommu(device->group)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (device->group->container) {
+		ret = vfio_group_use_container(device->group);
+		if (ret)
+			goto out_unlock;
+		vfio_device_container_register(device);
+	} else if (device->group->iommufd) {
+		ret = vfio_iommufd_bind(device, device->group->iommufd);
+	}
+
+out_unlock:
+	mutex_unlock(&device->group->group_lock);
+	return ret;
+}
+
+void vfio_device_group_unuse_iommu(struct vfio_device *device)
+{
+	mutex_lock(&device->group->group_lock);
+	if (device->group->container) {
+		vfio_device_container_unregister(device);
+		vfio_group_unuse_container(device->group);
+	} else if (device->group->iommufd) {
+		vfio_iommufd_unbind(device);
+	}
+	mutex_unlock(&device->group->group_lock);
+}
+
+struct kvm *vfio_group_get_kvm(struct vfio_group *group)
+{
+	mutex_lock(&group->group_lock);
+	if (!group->kvm) {
+		mutex_unlock(&group->group_lock);
+		return NULL;
+	}
+	/* group_lock is released in the vfio_group_put_kvm() */
+	return group->kvm;
+}
+
+void vfio_group_put_kvm(struct vfio_group *group)
+{
+	mutex_unlock(&group->group_lock);
+}
+
+void vfio_device_group_finalize_open(struct vfio_device *device)
+{
+	mutex_lock(&device->group->group_lock);
+	if (device->group->container)
+		vfio_device_container_register(device);
+	mutex_unlock(&device->group->group_lock);
+}
+
+void vfio_device_group_abort_open(struct vfio_device *device)
+{
+	mutex_lock(&device->group->group_lock);
+	if (device->group->container)
+		vfio_device_container_unregister(device);
+	mutex_unlock(&device->group->group_lock);
+}
+
+/**
+ * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
+ * @file: VFIO group file
+ *
+ * The returned iommu_group is valid as long as a ref is held on the file. This
+ * returns a reference on the group. This function is deprecated, only the SPAPR
+ * path in kvm should call it.
+ */
+struct iommu_group *vfio_file_iommu_group(struct file *file)
+{
+	struct vfio_group *group = file->private_data;
+	struct iommu_group *iommu_group = NULL;
+
+	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
+		return NULL;
+
+	if (!vfio_file_is_group(file))
+		return NULL;
+
+	mutex_lock(&group->group_lock);
+	if (group->iommu_group) {
+		iommu_group = group->iommu_group;
+		iommu_group_ref_get(iommu_group);
+	}
+	mutex_unlock(&group->group_lock);
+	return iommu_group;
+}
+EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
+
+/**
+ * vfio_file_is_group - True if the file is usable with VFIO aPIS
+ * @file: VFIO group file
+ */
+bool vfio_file_is_group(struct file *file)
+{
+	return file->f_op == &vfio_group_fops;
+}
+EXPORT_SYMBOL_GPL(vfio_file_is_group);
+
+/**
+ * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
+ *        is always CPU cache coherent
+ * @file: VFIO group file
+ *
+ * Enforced coherency means that the IOMMU ignores things like the PCIe no-snoop
+ * bit in DMA transactions. A return of false indicates that the user has
+ * rights to access additional instructions such as wbinvd on x86.
+ */
+bool vfio_file_enforced_coherent(struct file *file)
+{
+	struct vfio_group *group = file->private_data;
+	struct vfio_device *device;
+	bool ret = true;
+
+	if (!vfio_file_is_group(file))
+		return true;
+
+	/*
+	 * If the device does not have IOMMU_CAP_ENFORCE_CACHE_COHERENCY then
+	 * any domain later attached to it will also not support it. If the cap
+	 * is set then the iommu_domain eventually attached to the device/group
+	 * must use a domain with enforce_cache_coherency().
+	 */
+	mutex_lock(&group->device_lock);
+	list_for_each_entry(device, &group->device_list, group_next) {
+		if (!device_iommu_capable(device->dev,
+					  IOMMU_CAP_ENFORCE_CACHE_COHERENCY)) {
+			ret = false;
+			break;
+		}
+	}
+	mutex_unlock(&group->device_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
+
+/**
+ * vfio_file_set_kvm - Link a kvm with VFIO drivers
+ * @file: VFIO group file
+ * @kvm: KVM to link
+ *
+ * When a VFIO device is first opened the KVM will be available in
+ * device->kvm if one was associated with the group.
+ */
+void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
+{
+	struct vfio_group *group = file->private_data;
+
+	if (!vfio_file_is_group(file))
+		return;
+
+	mutex_lock(&group->group_lock);
+	group->kvm = kvm;
+	mutex_unlock(&group->group_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
+
+/**
+ * vfio_file_has_dev - True if the VFIO file is a handle for device
+ * @file: VFIO file to check
+ * @device: Device that must be part of the file
+ *
+ * Returns true if given file has permission to manipulate the given device.
+ */
+bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
+{
+	struct vfio_group *group = file->private_data;
+
+	if (!vfio_file_is_group(file))
+		return false;
+
+	return group == device->group;
+}
+EXPORT_SYMBOL_GPL(vfio_file_has_dev);
+
+bool vfio_group_has_container(struct vfio_group *group)
+{
+	return group->container;
+}
+
+static char *vfio_devnode(struct device *dev, umode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
+}
+
+int __init vfio_group_init(void)
+{
+	int ret;
+
+	ida_init(&vfio.group_ida);
+	mutex_init(&vfio.group_lock);
+	INIT_LIST_HEAD(&vfio.group_list);
+
+	ret = vfio_container_init();
+	if (ret)
+		return ret;
+
+	/* /dev/vfio/$GROUP */
+	vfio.class = class_create(THIS_MODULE, "vfio");
+	if (IS_ERR(vfio.class)) {
+		ret = PTR_ERR(vfio.class);
+		goto err_group_class;
+	}
+
+	vfio.class->devnode = vfio_devnode;
+
+	ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1, "vfio");
+	if (ret)
+		goto err_alloc_chrdev;
+	return 0;
+
+err_alloc_chrdev:
+	class_destroy(vfio.class);
+	vfio.class = NULL;
+err_group_class:
+	vfio_container_cleanup();
+	return ret;
+}
+
+void vfio_group_cleanup(void)
+{
+	WARN_ON(!list_empty(&vfio.group_list));
+	ida_destroy(&vfio.group_ida);
+	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
+	class_destroy(vfio.class);
+	vfio.class = NULL;
+	vfio_container_cleanup();
+}
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index d6b6bc20406b..670c9c5a55f1 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -15,6 +15,10 @@ struct iommu_group;
 struct vfio_device;
 struct vfio_container;
 
+void vfio_device_put_registration(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+struct file *vfio_device_open_file(struct vfio_device *device);
+
 enum vfio_group_type {
 	/*
 	 * Physical device with IOMMU backing.
@@ -66,6 +70,22 @@ struct vfio_group {
 	struct iommufd_ctx		*iommufd;
 };
 
+void vfio_device_remove_group(struct vfio_device *device);
+struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
+					    enum vfio_group_type type);
+struct vfio_group *vfio_group_find_or_alloc(struct device *dev);
+void vfio_device_group_register(struct vfio_device *device);
+void vfio_device_group_unregister(struct vfio_device *device);
+int vfio_device_group_use_iommu(struct vfio_device *device);
+void vfio_device_group_unuse_iommu(struct vfio_device *device);
+struct kvm *vfio_group_get_kvm(struct vfio_group *group);
+void vfio_group_put_kvm(struct vfio_group *group);
+void vfio_device_group_finalize_open(struct vfio_device *device);
+void vfio_device_group_abort_open(struct vfio_device *device);
+bool vfio_group_has_container(struct vfio_group *group);
+int __init vfio_group_init(void);
+void vfio_group_cleanup(void);
+
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index b6d3cb35a523..a7b966b4f3fc 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -43,11 +43,6 @@
 #define DRIVER_DESC	"VFIO - User Level meta-driver"
 
 static struct vfio {
-	struct class			*class;
-	struct list_head		group_list;
-	struct mutex			group_lock; /* locks group_list */
-	struct ida			group_ida;
-	dev_t				group_devt;
 	struct class			*device_class;
 	struct ida			device_ida;
 } vfio;
@@ -56,7 +51,6 @@ bool vfio_allow_unsafe_interrupts;
 EXPORT_SYMBOL_GPL(vfio_allow_unsafe_interrupts);
 
 static DEFINE_XARRAY(vfio_device_set_xa);
-static const struct file_operations vfio_group_fops;
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id)
 {
@@ -142,168 +136,17 @@ unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
 }
 EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
 
-/*
- * Group objects - create, release, get, put, search
- */
-static struct vfio_group *
-vfio_group_find_from_iommu(struct iommu_group *iommu_group)
-{
-	struct vfio_group *group;
-
-	lockdep_assert_held(&vfio.group_lock);
-
-	/*
-	 * group->iommu_group from the vfio.group_list cannot be NULL
-	 * under the vfio.group_lock.
-	 */
-	list_for_each_entry(group, &vfio.group_list, vfio_next) {
-		if (group->iommu_group == iommu_group)
-			return group;
-	}
-	return NULL;
-}
-
-static void vfio_group_release(struct device *dev)
-{
-	struct vfio_group *group = container_of(dev, struct vfio_group, dev);
-
-	mutex_destroy(&group->device_lock);
-	mutex_destroy(&group->group_lock);
-	WARN_ON(group->iommu_group);
-	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
-	kfree(group);
-}
-
-static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
-					   enum vfio_group_type type)
-{
-	struct vfio_group *group;
-	int minor;
-
-	group = kzalloc(sizeof(*group), GFP_KERNEL);
-	if (!group)
-		return ERR_PTR(-ENOMEM);
-
-	minor = ida_alloc_max(&vfio.group_ida, MINORMASK, GFP_KERNEL);
-	if (minor < 0) {
-		kfree(group);
-		return ERR_PTR(minor);
-	}
-
-	device_initialize(&group->dev);
-	group->dev.devt = MKDEV(MAJOR(vfio.group_devt), minor);
-	group->dev.class = vfio.class;
-	group->dev.release = vfio_group_release;
-	cdev_init(&group->cdev, &vfio_group_fops);
-	group->cdev.owner = THIS_MODULE;
-
-	refcount_set(&group->drivers, 1);
-	mutex_init(&group->group_lock);
-	INIT_LIST_HEAD(&group->device_list);
-	mutex_init(&group->device_lock);
-	group->iommu_group = iommu_group;
-	/* put in vfio_group_release() */
-	iommu_group_ref_get(iommu_group);
-	group->type = type;
-	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
-
-	return group;
-}
-
-static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
-		enum vfio_group_type type)
-{
-	struct vfio_group *group;
-	struct vfio_group *ret;
-	int err;
-
-	lockdep_assert_held(&vfio.group_lock);
-
-	group = vfio_group_alloc(iommu_group, type);
-	if (IS_ERR(group))
-		return group;
-
-	err = dev_set_name(&group->dev, "%s%d",
-			   group->type == VFIO_NO_IOMMU ? "noiommu-" : "",
-			   iommu_group_id(iommu_group));
-	if (err) {
-		ret = ERR_PTR(err);
-		goto err_put;
-	}
-
-	err = cdev_device_add(&group->cdev, &group->dev);
-	if (err) {
-		ret = ERR_PTR(err);
-		goto err_put;
-	}
-
-	list_add(&group->vfio_next, &vfio.group_list);
-
-	return group;
-
-err_put:
-	put_device(&group->dev);
-	return ret;
-}
-
-static void vfio_device_remove_group(struct vfio_device *device)
-{
-	struct vfio_group *group = device->group;
-	struct iommu_group *iommu_group;
-
-	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
-		iommu_group_remove_device(device->dev);
-
-	/* Pairs with vfio_create_group() / vfio_group_get_from_iommu() */
-	if (!refcount_dec_and_mutex_lock(&group->drivers, &vfio.group_lock))
-		return;
-	list_del(&group->vfio_next);
-
-	/*
-	 * We could concurrently probe another driver in the group that might
-	 * race vfio_device_remove_group() with vfio_get_group(), so we have to
-	 * ensure that the sysfs is all cleaned up under lock otherwise the
-	 * cdev_device_add() will fail due to the name aready existing.
-	 */
-	cdev_device_del(&group->cdev, &group->dev);
-
-	mutex_lock(&group->group_lock);
-	/*
-	 * These data structures all have paired operations that can only be
-	 * undone when the caller holds a live reference on the device. Since
-	 * all pairs must be undone these WARN_ON's indicate some caller did not
-	 * properly hold the group reference.
-	 */
-	WARN_ON(!list_empty(&group->device_list));
-	WARN_ON(group->notifier.head);
-
-	/*
-	 * Revoke all users of group->iommu_group. At this point we know there
-	 * are no devices active because we are unplugging the last one. Setting
-	 * iommu_group to NULL blocks all new users.
-	 */
-	if (group->container)
-		vfio_group_detach_container(group);
-	iommu_group = group->iommu_group;
-	group->iommu_group = NULL;
-	mutex_unlock(&group->group_lock);
-	mutex_unlock(&vfio.group_lock);
-
-	iommu_group_put(iommu_group);
-	put_device(&group->dev);
-}
-
 /*
  * Device objects - create, release, get, put, search
  */
 /* Device reference always implies a group reference */
-static void vfio_device_put_registration(struct vfio_device *device)
+void vfio_device_put_registration(struct vfio_device *device)
 {
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
 
-static bool vfio_device_try_get_registration(struct vfio_device *device)
+bool vfio_device_try_get_registration(struct vfio_device *device)
 {
 	return refcount_inc_not_zero(&device->refcount);
 }
@@ -416,121 +259,6 @@ void vfio_free_device(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_free_device);
 
-static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
-		enum vfio_group_type type)
-{
-	struct iommu_group *iommu_group;
-	struct vfio_group *group;
-	int ret;
-
-	iommu_group = iommu_group_alloc();
-	if (IS_ERR(iommu_group))
-		return ERR_CAST(iommu_group);
-
-	ret = iommu_group_set_name(iommu_group, "vfio-noiommu");
-	if (ret)
-		goto out_put_group;
-	ret = iommu_group_add_device(iommu_group, dev);
-	if (ret)
-		goto out_put_group;
-
-	mutex_lock(&vfio.group_lock);
-	group = vfio_create_group(iommu_group, type);
-	mutex_unlock(&vfio.group_lock);
-	if (IS_ERR(group)) {
-		ret = PTR_ERR(group);
-		goto out_remove_device;
-	}
-	iommu_group_put(iommu_group);
-	return group;
-
-out_remove_device:
-	iommu_group_remove_device(dev);
-out_put_group:
-	iommu_group_put(iommu_group);
-	return ERR_PTR(ret);
-}
-
-static bool vfio_group_has_device(struct vfio_group *group, struct device *dev)
-{
-	struct vfio_device *device;
-
-	mutex_lock(&group->device_lock);
-	list_for_each_entry(device, &group->device_list, group_next) {
-		if (device->dev == dev) {
-			mutex_unlock(&group->device_lock);
-			return true;
-		}
-	}
-	mutex_unlock(&group->device_lock);
-	return false;
-}
-
-static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
-{
-	struct iommu_group *iommu_group;
-	struct vfio_group *group;
-
-	iommu_group = iommu_group_get(dev);
-	if (!iommu_group && vfio_noiommu) {
-		/*
-		 * With noiommu enabled, create an IOMMU group for devices that
-		 * don't already have one, implying no IOMMU hardware/driver
-		 * exists.  Taint the kernel because we're about to give a DMA
-		 * capable device to a user without IOMMU protection.
-		 */
-		group = vfio_noiommu_group_alloc(dev, VFIO_NO_IOMMU);
-		if (!IS_ERR(group)) {
-			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
-			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
-		}
-		return group;
-	}
-
-	if (!iommu_group)
-		return ERR_PTR(-EINVAL);
-
-	/*
-	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
-	 * restore cache coherency. It has to be checked here because it is only
-	 * valid for cases where we are using iommu groups.
-	 */
-	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY)) {
-		iommu_group_put(iommu_group);
-		return ERR_PTR(-EINVAL);
-	}
-
-	mutex_lock(&vfio.group_lock);
-	group = vfio_group_find_from_iommu(iommu_group);
-	if (group) {
-		if (WARN_ON(vfio_group_has_device(group, dev)))
-			group = ERR_PTR(-EINVAL);
-		else
-			refcount_inc(&group->drivers);
-	} else {
-		group = vfio_create_group(iommu_group, VFIO_IOMMU);
-	}
-	mutex_unlock(&vfio.group_lock);
-
-	/* The vfio_group holds a reference to the iommu_group */
-	iommu_group_put(iommu_group);
-	return group;
-}
-
-static void vfio_device_group_register(struct vfio_device *device)
-{
-	mutex_lock(&device->group->device_lock);
-	list_add(&device->group_next, &device->group->device_list);
-	mutex_unlock(&device->group->device_lock);
-}
-
-static void vfio_device_group_unregister(struct vfio_device *device)
-{
-	mutex_lock(&device->group->device_lock);
-	list_del(&device->group_next);
-	mutex_unlock(&device->group->device_lock);
-}
-
 static int __vfio_register_dev(struct vfio_device *device,
 		struct vfio_group *group)
 {
@@ -595,35 +323,6 @@ int vfio_register_emulated_iommu_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
 
-static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
-						     char *buf)
-{
-	struct vfio_device *it, *device = ERR_PTR(-ENODEV);
-
-	mutex_lock(&group->device_lock);
-	list_for_each_entry(it, &group->device_list, group_next) {
-		int ret;
-
-		if (it->ops->match) {
-			ret = it->ops->match(it, buf);
-			if (ret < 0) {
-				device = ERR_PTR(ret);
-				break;
-			}
-		} else {
-			ret = !strcmp(dev_name(it->dev), buf);
-		}
-
-		if (ret && vfio_device_try_get_registration(it)) {
-			device = it;
-			break;
-		}
-	}
-	mutex_unlock(&group->device_lock);
-
-	return device;
-}
-
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
@@ -665,108 +364,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
-/*
- * VFIO Group fd, /dev/vfio/$GROUP
- */
-static bool vfio_group_has_iommu(struct vfio_group *group)
-{
-	lockdep_assert_held(&group->group_lock);
-	/*
-	 * There can only be users if there is a container, and if there is a
-	 * container there must be users.
-	 */
-	WARN_ON(!group->container != !group->container_users);
-
-	return group->container || group->iommufd;
-}
-
-/*
- * VFIO_GROUP_UNSET_CONTAINER should fail if there are other users or
- * if there was no container to unset.  Since the ioctl is called on
- * the group, we know that still exists, therefore the only valid
- * transition here is 1->0.
- */
-static int vfio_group_ioctl_unset_container(struct vfio_group *group)
-{
-	int ret = 0;
-
-	mutex_lock(&group->group_lock);
-	if (!vfio_group_has_iommu(group)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-	if (group->container) {
-		if (group->container_users != 1) {
-			ret = -EBUSY;
-			goto out_unlock;
-		}
-		vfio_group_detach_container(group);
-	}
-	if (group->iommufd) {
-		iommufd_ctx_put(group->iommufd);
-		group->iommufd = NULL;
-	}
-
-out_unlock:
-	mutex_unlock(&group->group_lock);
-	return ret;
-}
-
-static int vfio_group_ioctl_set_container(struct vfio_group *group,
-					  int __user *arg)
-{
-	struct vfio_container *container;
-	struct iommufd_ctx *iommufd;
-	struct fd f;
-	int ret;
-	int fd;
-
-	if (get_user(fd, arg))
-		return -EFAULT;
-
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
-
-	mutex_lock(&group->group_lock);
-	if (vfio_group_has_iommu(group)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-	if (!group->iommu_group) {
-		ret = -ENODEV;
-		goto out_unlock;
-	}
-
-	container = vfio_container_from_file(f.file);
-	if (container) {
-		ret = vfio_container_attach_group(container, group);
-		goto out_unlock;
-	}
-
-	iommufd = iommufd_ctx_from_file(f.file);
-	if (!IS_ERR(iommufd)) {
-		u32 ioas_id;
-
-		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
-		if (ret) {
-			iommufd_ctx_put(group->iommufd);
-			goto out_unlock;
-		}
-
-		group->iommufd = iommufd;
-		goto out_unlock;
-	}
-
-	/* The FD passed is not recognized. */
-	ret = -EBADFD;
-
-out_unlock:
-	mutex_unlock(&group->group_lock);
-	fdput(f);
-	return ret;
-}
-
 static const struct file_operations vfio_device_fops;
 
 /* true if the vfio_device has open_device() called but not close_device() */
@@ -775,63 +372,6 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
 
-static int vfio_device_group_use_iommu(struct vfio_device *device)
-{
-	int ret = 0;
-
-	/*
-	 * Here we pass the KVM pointer with the group under the lock.  If the
-	 * device driver will use it, it must obtain a reference and release it
-	 * during close_device.
-	 */
-	mutex_lock(&device->group->group_lock);
-	if (!vfio_group_has_iommu(device->group)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
-	if (device->group->container) {
-		ret = vfio_group_use_container(device->group);
-		if (ret)
-			goto out_unlock;
-		vfio_device_container_register(device);
-	} else if (device->group->iommufd) {
-		ret = vfio_iommufd_bind(device, device->group->iommufd);
-	}
-
-out_unlock:
-	mutex_unlock(&device->group->group_lock);
-	return ret;
-}
-
-static void vfio_device_group_unuse_iommu(struct vfio_device *device)
-{
-	mutex_lock(&device->group->group_lock);
-	if (device->group->container) {
-		vfio_device_container_unregister(device);
-		vfio_group_unuse_container(device->group);
-	} else if (device->group->iommufd) {
-		vfio_iommufd_unbind(device);
-	}
-	mutex_unlock(&device->group->group_lock);
-}
-
-static struct kvm *vfio_group_get_kvm(struct vfio_group *group)
-{
-	mutex_lock(&group->group_lock);
-	if (!group->kvm) {
-		mutex_unlock(&group->group_lock);
-		return NULL;
-	}
-	/* group_lock is released in the vfio_group_put_kvm() */
-	return group->kvm;
-}
-
-static void vfio_group_put_kvm(struct vfio_group *group)
-{
-	mutex_unlock(&group->group_lock);
-}
-
 static int vfio_device_first_open(struct vfio_device *device)
 {
 	struct kvm *kvm;
@@ -908,7 +448,7 @@ static void vfio_device_close(struct vfio_device *device)
 	mutex_unlock(&device->dev_set->lock);
 }
 
-static struct file *vfio_device_open_file(struct vfio_device *device)
+struct file *vfio_device_open_file(struct vfio_device *device)
 {
 	struct file *filep;
 	int ret;
@@ -947,177 +487,6 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 	return ERR_PTR(ret);
 }
 
-static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
-					  char __user *arg)
-{
-	struct vfio_device *device;
-	struct file *filep;
-	char *buf;
-	int fdno;
-	int ret;
-
-	buf = strndup_user(arg, PAGE_SIZE);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
-
-	device = vfio_device_get_from_name(group, buf);
-	kfree(buf);
-	if (IS_ERR(device))
-		return PTR_ERR(device);
-
-	fdno = get_unused_fd_flags(O_CLOEXEC);
-	if (fdno < 0) {
-		ret = fdno;
-		goto err_put_device;
-	}
-
-	filep = vfio_device_open_file(device);
-	if (IS_ERR(filep)) {
-		ret = PTR_ERR(filep);
-		goto err_put_fdno;
-	}
-
-	if (group->type == VFIO_NO_IOMMU)
-		dev_warn(device->dev, "vfio-noiommu device opened by user "
-			 "(%s:%d)\n", current->comm, task_pid_nr(current));
-
-	fd_install(fdno, filep);
-	return fdno;
-
-err_put_fdno:
-	put_unused_fd(fdno);
-err_put_device:
-	vfio_device_put_registration(device);
-	return ret;
-}
-
-static int vfio_group_ioctl_get_status(struct vfio_group *group,
-				       struct vfio_group_status __user *arg)
-{
-	unsigned long minsz = offsetofend(struct vfio_group_status, flags);
-	struct vfio_group_status status;
-
-	if (copy_from_user(&status, arg, minsz))
-		return -EFAULT;
-
-	if (status.argsz < minsz)
-		return -EINVAL;
-
-	status.flags = 0;
-
-	mutex_lock(&group->group_lock);
-	if (!group->iommu_group) {
-		mutex_unlock(&group->group_lock);
-		return -ENODEV;
-	}
-
-	/*
-	 * With the container FD the iommu_group_claim_dma_owner() is done
-	 * during SET_CONTAINER but for IOMMFD this is done during
-	 * VFIO_GROUP_GET_DEVICE_FD. Meaning that with iommufd
-	 * VFIO_GROUP_FLAGS_VIABLE could be set but GET_DEVICE_FD will fail due
-	 * to viability.
-	 */
-	if (vfio_group_has_iommu(group))
-		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
-				VFIO_GROUP_FLAGS_VIABLE;
-	else if (!iommu_group_dma_owner_claimed(group->iommu_group))
-		status.flags |= VFIO_GROUP_FLAGS_VIABLE;
-	mutex_unlock(&group->group_lock);
-
-	if (copy_to_user(arg, &status, minsz))
-		return -EFAULT;
-	return 0;
-}
-
-static long vfio_group_fops_unl_ioctl(struct file *filep,
-				      unsigned int cmd, unsigned long arg)
-{
-	struct vfio_group *group = filep->private_data;
-	void __user *uarg = (void __user *)arg;
-
-	switch (cmd) {
-	case VFIO_GROUP_GET_DEVICE_FD:
-		return vfio_group_ioctl_get_device_fd(group, uarg);
-	case VFIO_GROUP_GET_STATUS:
-		return vfio_group_ioctl_get_status(group, uarg);
-	case VFIO_GROUP_SET_CONTAINER:
-		return vfio_group_ioctl_set_container(group, uarg);
-	case VFIO_GROUP_UNSET_CONTAINER:
-		return vfio_group_ioctl_unset_container(group);
-	default:
-		return -ENOTTY;
-	}
-}
-
-static int vfio_group_fops_open(struct inode *inode, struct file *filep)
-{
-	struct vfio_group *group =
-		container_of(inode->i_cdev, struct vfio_group, cdev);
-	int ret;
-
-	mutex_lock(&group->group_lock);
-
-	/*
-	 * drivers can be zero if this races with vfio_device_remove_group(), it
-	 * will be stable at 0 under the group rwsem
-	 */
-	if (refcount_read(&group->drivers) == 0) {
-		ret = -ENODEV;
-		goto out_unlock;
-	}
-
-	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
-		ret = -EPERM;
-		goto out_unlock;
-	}
-
-	/*
-	 * Do we need multiple instances of the group open?  Seems not.
-	 */
-	if (group->opened_file) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-	group->opened_file = filep;
-	filep->private_data = group;
-	ret = 0;
-out_unlock:
-	mutex_unlock(&group->group_lock);
-	return ret;
-}
-
-static int vfio_group_fops_release(struct inode *inode, struct file *filep)
-{
-	struct vfio_group *group = filep->private_data;
-
-	filep->private_data = NULL;
-
-	mutex_lock(&group->group_lock);
-	/*
-	 * Device FDs hold a group file reference, therefore the group release
-	 * is only called when there are no open devices.
-	 */
-	WARN_ON(group->notifier.head);
-	if (group->container)
-		vfio_group_detach_container(group);
-	if (group->iommufd) {
-		iommufd_ctx_put(group->iommufd);
-		group->iommufd = NULL;
-	}
-	group->opened_file = NULL;
-	mutex_unlock(&group->group_lock);
-	return 0;
-}
-
-static const struct file_operations vfio_group_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= vfio_group_fops_unl_ioctl,
-	.compat_ioctl	= compat_ptr_ioctl,
-	.open		= vfio_group_fops_open,
-	.release	= vfio_group_fops_release,
-};
-
 /*
  * Wrapper around pm_runtime_resume_and_get().
  * Return error code on failure or 0 on success.
@@ -1691,121 +1060,6 @@ static const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
-/**
- * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
- * @file: VFIO group file
- *
- * The returned iommu_group is valid as long as a ref is held on the file. This
- * returns a reference on the group. This function is deprecated, only the SPAPR
- * path in kvm should call it.
- */
-struct iommu_group *vfio_file_iommu_group(struct file *file)
-{
-	struct vfio_group *group = file->private_data;
-	struct iommu_group *iommu_group = NULL;
-
-	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
-		return NULL;
-
-	if (!vfio_file_is_group(file))
-		return NULL;
-
-	mutex_lock(&group->group_lock);
-	if (group->iommu_group) {
-		iommu_group = group->iommu_group;
-		iommu_group_ref_get(iommu_group);
-	}
-	mutex_unlock(&group->group_lock);
-	return iommu_group;
-}
-EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
-
-/**
- * vfio_file_is_group - True if the file is usable with VFIO aPIS
- * @file: VFIO group file
- */
-bool vfio_file_is_group(struct file *file)
-{
-	return file->f_op == &vfio_group_fops;
-}
-EXPORT_SYMBOL_GPL(vfio_file_is_group);
-
-/**
- * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
- *        is always CPU cache coherent
- * @file: VFIO group file
- *
- * Enforced coherency means that the IOMMU ignores things like the PCIe no-snoop
- * bit in DMA transactions. A return of false indicates that the user has
- * rights to access additional instructions such as wbinvd on x86.
- */
-bool vfio_file_enforced_coherent(struct file *file)
-{
-	struct vfio_group *group = file->private_data;
-	struct vfio_device *device;
-	bool ret = true;
-
-	if (!vfio_file_is_group(file))
-		return true;
-
-	/*
-	 * If the device does not have IOMMU_CAP_ENFORCE_CACHE_COHERENCY then
-	 * any domain later attached to it will also not support it. If the cap
-	 * is set then the iommu_domain eventually attached to the device/group
-	 * must use a domain with enforce_cache_coherency().
-	 */
-	mutex_lock(&group->device_lock);
-	list_for_each_entry(device, &group->device_list, group_next) {
-		if (!device_iommu_capable(device->dev,
-					  IOMMU_CAP_ENFORCE_CACHE_COHERENCY)) {
-			ret = false;
-			break;
-		}
-	}
-	mutex_unlock(&group->device_lock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
-
-/**
- * vfio_file_set_kvm - Link a kvm with VFIO drivers
- * @file: VFIO group file
- * @kvm: KVM to link
- *
- * When a VFIO device is first opened the KVM will be available in
- * device->kvm if one was associated with the group.
- */
-void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
-{
-	struct vfio_group *group = file->private_data;
-
-	if (!vfio_file_is_group(file))
-		return;
-
-	mutex_lock(&group->group_lock);
-	group->kvm = kvm;
-	mutex_unlock(&group->group_lock);
-}
-EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
-
-/**
- * vfio_file_has_dev - True if the VFIO file is a handle for device
- * @file: VFIO file to check
- * @device: Device that must be part of the file
- *
- * Returns true if given file has permission to manipulate the given device.
- */
-bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
-{
-	struct vfio_group *group = file->private_data;
-
-	if (!vfio_file_is_group(file))
-		return false;
-
-	return group == device->group;
-}
-EXPORT_SYMBOL_GPL(vfio_file_has_dev);
-
 /*
  * Sub-module support
  */
@@ -1925,11 +1179,6 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 }
 EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
 
-static bool vfio_group_has_container(struct vfio_group *group)
-{
-	return group->container;
-}
-
 /*
  * Pin contiguous user pages and return their associated host pages for local
  * domain only.
@@ -2052,55 +1301,6 @@ EXPORT_SYMBOL(vfio_dma_rw);
 /*
  * Module/class support
  */
-static char *vfio_devnode(struct device *dev, umode_t *mode)
-{
-	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
-}
-
-static int __init vfio_group_init(void)
-{
-	int ret;
-
-	ida_init(&vfio.group_ida);
-	mutex_init(&vfio.group_lock);
-	INIT_LIST_HEAD(&vfio.group_list);
-
-	ret = vfio_container_init();
-	if (ret)
-		return ret;
-
-	/* /dev/vfio/$GROUP */
-	vfio.class = class_create(THIS_MODULE, "vfio");
-	if (IS_ERR(vfio.class)) {
-		ret = PTR_ERR(vfio.class);
-		goto err_group_class;
-	}
-
-	vfio.class->devnode = vfio_devnode;
-
-	ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1, "vfio");
-	if (ret)
-		goto err_alloc_chrdev;
-	return 0;
-
-err_alloc_chrdev:
-	class_destroy(vfio.class);
-	vfio.class = NULL;
-err_group_class:
-	vfio_container_cleanup();
-	return ret;
-}
-
-static void vfio_group_cleanup(void)
-{
-	WARN_ON(!list_empty(&vfio.group_list));
-	ida_destroy(&vfio.group_ida);
-	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
-	class_destroy(vfio.class);
-	vfio.class = NULL;
-	vfio_container_cleanup();
-}
-
 static int __init vfio_init(void)
 {
 	int ret;
-- 
2.34.1

