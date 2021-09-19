Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738AA410A3B
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbhISGnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:43:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:2305 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236208AbhISGnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:43:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="223030141"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="223030141"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:41:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510701898"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:41:43 -0700
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
Subject: [RFC 03/20] vfio: Add vfio_[un]register_device()
Date:   Sun, 19 Sep 2021 14:38:31 +0800
Message-Id: <20210919063848.1476776-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With /dev/vfio/devices introduced, now a vfio device driver has three
options to expose its device to userspace:

a)  only legacy group interface, for devices which haven't been moved to
    iommufd (e.g. platform devices, sw mdev, etc.);

b)  both legacy group interface and new device-centric interface, for
    devices which supports iommufd but also wants to keep backward
    compatibility (e.g. pci devices in this RFC);

c)  only new device-centric interface, for new devices which don't carry
    backward compatibility burden (e.g. hw mdev/subdev with pasid);

This patch introduces vfio_[un]register_device() helpers for the device
drivers to specify the device exposure policy to vfio core. Hence the
existing vfio_[un]register_group_dev() become the wrapper of the new
helper functions. The new device-centric interface is described as
'nongroup' to differentiate from existing 'group' stuff.

TBD: this patch needs to rebase on top of below series from Christoph in
next version.

	"cleanup vfio iommu_group creation"

Legacy userspace continues to follow the legacy group interface.

Newer userspace can first try the new device-centric interface if the
device is present under /dev/vfio/devices. Otherwise fall back to the
group interface.

One open about how to organize the device nodes under /dev/vfio/devices/.
This RFC adopts a simple policy by keeping a flat layout with mixed devname
from all kinds of devices. The prerequisite of this model is that devnames
from different bus types are unique formats:

	/dev/vfio/devices/0000:00:14.2 (pci)
	/dev/vfio/devices/PNP0103:00 (platform)
	/dev/vfio/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1001 (mdev)

One alternative option is to arrange device nodes in sub-directories based
on the device type. But doing so also adds one trouble to userspace. The
current vfio uAPI is designed to have the user query device type via
VFIO_DEVICE_GET_INFO after opening the device. With this option the user
instead needs to figure out the device type before opening the device, to
identify the sub-directory. Another tricky thing is that "pdev. vs. mdev"
and "pci vs. platform vs. ccw,..." are orthogonal categorizations. Need
more thoughts on whether both or just one category should be used to define
the sub-directories.

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.c  | 137 +++++++++++++++++++++++++++++++++++++++----
 include/linux/vfio.h |   9 +++
 2 files changed, 134 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 84436d7abedd..1e87b25962f1 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -51,6 +51,7 @@ static struct vfio {
 	struct cdev			device_cdev;
 	dev_t				device_devt;
 	struct mutex			device_lock;
+	struct list_head		device_list;
 	struct idr			device_idr;
 } vfio;
 
@@ -757,7 +758,7 @@ void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
 }
 EXPORT_SYMBOL_GPL(vfio_init_group_dev);
 
-int vfio_register_group_dev(struct vfio_device *device)
+static int __vfio_register_group_dev(struct vfio_device *device)
 {
 	struct vfio_device *existing_device;
 	struct iommu_group *iommu_group;
@@ -794,8 +795,13 @@ int vfio_register_group_dev(struct vfio_device *device)
 	/* Our reference on group is moved to the device */
 	device->group = group;
 
-	/* Refcounting can't start until the driver calls register */
-	refcount_set(&device->refcount, 1);
+	/*
+	 * Refcounting can't start until the driver call register. Don’t
+	 * start twice when the device is exposed in both group and nongroup
+	 * interfaces.
+	 */
+	if (!refcount_read(&device->refcount))
+		refcount_set(&device->refcount, 1);
 
 	mutex_lock(&group->device_lock);
 	list_add(&device->group_next, &group->device_list);
@@ -804,7 +810,78 @@ int vfio_register_group_dev(struct vfio_device *device)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vfio_register_group_dev);
+
+static int __vfio_register_nongroup_dev(struct vfio_device *device)
+{
+	struct vfio_device *existing_device;
+	struct device *dev;
+	int ret = 0, minor;
+
+	mutex_lock(&vfio.device_lock);
+	list_for_each_entry(existing_device, &vfio.device_list, vfio_next) {
+		if (existing_device == device) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+	}
+
+	minor = idr_alloc(&vfio.device_idr, device, 0, MINORMASK + 1, GFP_KERNEL);
+	pr_debug("%s - mnior: %d\n", __func__, minor);
+	if (minor < 0) {
+		ret = minor;
+		goto out_unlock;
+	}
+
+	dev = device_create(vfio.device_class, NULL,
+			    MKDEV(MAJOR(vfio.device_devt), minor),
+			    device, "%s", dev_name(device->dev));
+	if (IS_ERR(dev)) {
+		idr_remove(&vfio.device_idr, minor);
+		ret = PTR_ERR(dev);
+		goto out_unlock;
+	}
+
+	/*
+	 * Refcounting can't start until the driver call register. Don’t
+	 * start twice when the device is exposed in both group and nongroup
+	 * interfaces.
+	 */
+	if (!refcount_read(&device->refcount))
+		refcount_set(&device->refcount, 1);
+
+	device->minor = minor;
+	list_add(&device->vfio_next, &vfio.device_list);
+	dev_info(device->dev, "Creates Device interface successfully!\n");
+out_unlock:
+	mutex_unlock(&vfio.device_lock);
+	return ret;
+}
+
+int vfio_register_device(struct vfio_device *device, u32 flags)
+{
+	int ret = -EINVAL;
+
+	device->minor = -1;
+	device->group = NULL;
+	atomic_set(&device->opened, 0);
+
+	if (flags & ~(VFIO_DEVNODE_GROUP | VFIO_DEVNODE_NONGROUP))
+		return ret;
+
+	if (flags & VFIO_DEVNODE_GROUP) {
+		ret = __vfio_register_group_dev(device);
+		if (ret)
+			return ret;
+	}
+
+	if (flags & VFIO_DEVNODE_NONGROUP) {
+		ret = __vfio_register_nongroup_dev(device);
+		if (ret && device->group)
+			vfio_unregister_device(device);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_register_device);
 
 /**
  * Get a reference to the vfio_device for a device.  Even if the
@@ -861,13 +938,14 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
-void vfio_unregister_group_dev(struct vfio_device *device)
+void vfio_unregister_device(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
 	struct vfio_unbound_dev *unbound;
 	unsigned int i = 0;
 	bool interrupted = false;
 	long rc;
+	int minor = device->minor;
 
 	/*
 	 * When the device is removed from the group, the group suddenly
@@ -878,14 +956,20 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	 * solve this, we track such devices on the unbound_list to bridge
 	 * the gap until they're fully unbound.
 	 */
-	unbound = kzalloc(sizeof(*unbound), GFP_KERNEL);
-	if (unbound) {
-		unbound->dev = device->dev;
-		mutex_lock(&group->unbound_lock);
-		list_add(&unbound->unbound_next, &group->unbound_list);
-		mutex_unlock(&group->unbound_lock);
+	if (group) {
+		/*
+		 * If caller hasn't called vfio_register_group_dev(), this
+		 * branch is not necessary.
+		 */
+		unbound = kzalloc(sizeof(*unbound), GFP_KERNEL);
+		if (unbound) {
+			unbound->dev = device->dev;
+			mutex_lock(&group->unbound_lock);
+			list_add(&unbound->unbound_next, &group->unbound_list);
+			mutex_unlock(&group->unbound_lock);
+		}
+		WARN_ON(!unbound);
 	}
-	WARN_ON(!unbound);
 
 	vfio_device_put(device);
 	rc = try_wait_for_completion(&device->comp);
@@ -910,6 +994,21 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 		}
 	}
 
+	/* nongroup interface related cleanup */
+	if (minor >= 0) {
+		mutex_lock(&vfio.device_lock);
+		list_del(&device->vfio_next);
+		device->minor = -1;
+		device_destroy(vfio.device_class,
+			       MKDEV(MAJOR(vfio.device_devt), minor));
+		idr_remove(&vfio.device_idr, minor);
+		mutex_unlock(&vfio.device_lock);
+	}
+
+	/* No need go further if no group. */
+	if (!group)
+		return;
+
 	mutex_lock(&group->device_lock);
 	list_del(&device->group_next);
 	group->dev_counter--;
@@ -935,6 +1034,18 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	/* Matches the get in vfio_register_group_dev() */
 	vfio_group_put(group);
 }
+EXPORT_SYMBOL_GPL(vfio_unregister_device);
+
+int vfio_register_group_dev(struct vfio_device *device)
+{
+	return vfio_register_device(device, VFIO_DEVNODE_GROUP);
+}
+EXPORT_SYMBOL_GPL(vfio_register_group_dev);
+
+void vfio_unregister_group_dev(struct vfio_device *device)
+{
+	vfio_unregister_device(device);
+}
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
 /**
@@ -2447,6 +2558,7 @@ static int vfio_init_device_class(void)
 
 	mutex_init(&vfio.device_lock);
 	idr_init(&vfio.device_idr);
+	INIT_LIST_HEAD(&vfio.device_list);
 
 	/* /dev/vfio/devices/$DEVICE */
 	vfio.device_class = class_create(THIS_MODULE, "vfio-device");
@@ -2542,6 +2654,7 @@ static int __init vfio_init(void)
 static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
+	WARN_ON(!list_empty(&vfio.device_list));
 
 #ifdef CONFIG_VFIO_NOIOMMU
 	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 4a5f3f99eab2..9448b751b663 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -26,6 +26,7 @@ struct vfio_device {
 	struct list_head group_next;
 	int minor;
 	atomic_t opened;
+	struct list_head vfio_next;
 };
 
 /**
@@ -73,6 +74,14 @@ enum vfio_iommu_notify_type {
 	VFIO_IOMMU_CONTAINER_CLOSE = 0,
 };
 
+/* The device can be opened via VFIO_GROUP_GET_DEVICE_FD */
+#define VFIO_DEVNODE_GROUP	BIT(0)
+/* The device can be opened via /dev/sys/devices/${DEVICE} */
+#define VFIO_DEVNODE_NONGROUP	BIT(1)
+
+extern int vfio_register_device(struct vfio_device *device, u32 flags);
+extern void vfio_unregister_device(struct vfio_device *device);
+
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
  */
-- 
2.25.1

