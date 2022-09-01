Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6569E5A9007
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 09:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbiIAHXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 03:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiIAHWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 03:22:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D019FB4B;
        Thu,  1 Sep 2022 00:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662016874; x=1693552874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yPWKM7p4vcbptQIIIvkMNuxbJPUQXyRKvKLc8vZijDk=;
  b=Uh8be+pyyBHL2e3eeQK6snPNM/5QulzjbLvPoAu5ZAMXv7PnzCH0XEN1
   m8LmdQ6XmPrApSgmuFcOxGBXM+ZNGvzOJb953hRZ2RVz5YIu96nnJLNv4
   e4q8gS6b+j2xSp5ZIKE9UH6ihpJb/G1CO5HshVKEAM8viSMFh4YEKBjJh
   Mxw1/bjTu4NuXa/2s563QHM/HDWqsWzHf0mMKXphdrH+vSjajHVzbe0Al
   iXbaMwt/5Rtj398qwjyZe/u/1RjxnVHwgnj9vPVdWhWTVinD7QiD1NjTR
   JX9dbyfovlYVfybCJfuSIoDOtbu9Rg2Wr4rKCLhalTyL2sji0At7nVggi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="381934375"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="381934375"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 00:19:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="673720896"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 00:19:41 -0700
From:   Kevin Tian <kevin.tian@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 15/15] vfio: Add struct device to vfio_device
Date:   Thu,  1 Sep 2022 22:37:47 +0800
Message-Id: <20220901143747.32858-16-kevin.tian@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220901143747.32858-1-kevin.tian@intel.com>
References: <20220901143747.32858-1-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

and replace kref. With it a 'vfio-dev/vfioX' node is created under the
sysfs path of the parent, indicating the device is bound to a vfio
driver, e.g.:

/sys/devices/pci0000\:6f/0000\:6f\:01.0/vfio-dev/vfio0

It is also a preparatory step toward adding cdev for supporting future
device-oriented uAPI.

Add Documentation/ABI/testing/sysfs-devices-vfio-dev.

Also take this chance to rename chardev 'vfio' to 'vfio-group' in
/proc/devices.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../ABI/testing/sysfs-devices-vfio-dev        |  8 +++
 drivers/vfio/vfio_main.c                      | 67 +++++++++++++++----
 include/linux/vfio.h                          |  6 +-
 3 files changed, 66 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-vfio-dev

diff --git a/Documentation/ABI/testing/sysfs-devices-vfio-dev b/Documentation/ABI/testing/sysfs-devices-vfio-dev
new file mode 100644
index 000000000000..e21424fd9666
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-vfio-dev
@@ -0,0 +1,8 @@
+What:		 /sys/.../<device>/vfio-dev/vfioX/
+Date:		 September 2022
+Contact:	 Yi Liu <yi.l.liu@intel.com>
+Description:
+		 This directory is created when the device is bound to a
+		 vfio driver. The layout under this directory matches what
+		 exists for a standard 'struct device'. 'X' is a unique
+		 index marking this device in vfio.
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index bfa675d314ab..141f55c3faf5 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -46,6 +46,8 @@ static struct vfio {
 	struct mutex			group_lock; /* locks group_list */
 	struct ida			group_ida;
 	dev_t				group_devt;
+	struct class			*device_class;
+	struct ida			device_ida;
 } vfio;
 
 struct vfio_iommu_driver {
@@ -483,12 +485,13 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
  * VFIO driver API
  */
 /* Release helper called by vfio_put_device() */
-void vfio_device_release(struct kref *kref)
+static void vfio_device_release(struct device *dev)
 {
 	struct vfio_device *device =
-			container_of(kref, struct vfio_device, kref);
+			container_of(dev, struct vfio_device, device);
 
 	vfio_release_device_set(device);
+	ida_free(&vfio.device_ida, device->index);
 
 	/*
 	 * kvfree() cannot be done here due to a life cycle mess in
@@ -498,7 +501,6 @@ void vfio_device_release(struct kref *kref)
 	 */
 	device->ops->release(device);
 }
-EXPORT_SYMBOL_GPL(vfio_device_release);
 
 /*
  * Alloc and initialize vfio_device so it can be registered to vfio
@@ -546,6 +548,13 @@ int vfio_init_device(struct vfio_device *device, struct device *dev,
 {
 	int ret;
 
+	ret = ida_alloc_max(&vfio.device_ida, MINORMASK, GFP_KERNEL);
+	if (ret < 0) {
+		dev_dbg(dev, "Error to alloc index\n");
+		return ret;
+	}
+
+	device->index = ret;
 	init_completion(&device->comp);
 	device->dev = dev;
 	device->ops = ops;
@@ -556,11 +565,15 @@ int vfio_init_device(struct vfio_device *device, struct device *dev,
 			goto out_uninit;
 	}
 
-	kref_init(&device->kref);
+	device_initialize(&device->device);
+	device->device.release = vfio_device_release;
+	device->device.class = vfio.device_class;
+	device->device.parent = device->dev;
 	return 0;
 
 out_uninit:
 	vfio_release_device_set(device);
+	ida_free(&vfio.device_ida, device->index);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_init_device);
@@ -657,6 +670,7 @@ static int __vfio_register_dev(struct vfio_device *device,
 		struct vfio_group *group)
 {
 	struct vfio_device *existing_device;
+	int ret;
 
 	if (IS_ERR(group))
 		return PTR_ERR(group);
@@ -673,16 +687,21 @@ static int __vfio_register_dev(struct vfio_device *device,
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(group->iommu_group));
 		vfio_device_put_registration(existing_device);
-		if (group->type == VFIO_NO_IOMMU ||
-		    group->type == VFIO_EMULATED_IOMMU)
-			iommu_group_remove_device(device->dev);
-		vfio_group_put(group);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err_out;
 	}
 
 	/* Our reference on group is moved to the device */
 	device->group = group;
 
+	ret = dev_set_name(&device->device, "vfio%d", device->index);
+	if (ret)
+		goto err_out;
+
+	ret = device_add(&device->device);
+	if (ret)
+		goto err_out;
+
 	/* Refcounting can't start until the driver calls register */
 	refcount_set(&device->refcount, 1);
 
@@ -692,6 +711,12 @@ static int __vfio_register_dev(struct vfio_device *device,
 	mutex_unlock(&group->device_lock);
 
 	return 0;
+err_out:
+	if (group->type == VFIO_NO_IOMMU ||
+	    group->type == VFIO_EMULATED_IOMMU)
+		iommu_group_remove_device(device->dev);
+	vfio_group_put(group);
+	return ret;
 }
 
 int vfio_register_group_dev(struct vfio_device *device)
@@ -779,6 +804,9 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	group->dev_counter--;
 	mutex_unlock(&group->device_lock);
 
+	/* Balances device_add in register path */
+	device_del(&device->device);
+
 	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
 		iommu_group_remove_device(device->dev);
 
@@ -2145,6 +2173,7 @@ static int __init vfio_init(void)
 	int ret;
 
 	ida_init(&vfio.group_ida);
+	ida_init(&vfio.device_ida);
 	mutex_init(&vfio.group_lock);
 	mutex_init(&vfio.iommu_drivers_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
@@ -2160,12 +2189,20 @@ static int __init vfio_init(void)
 	vfio.class = class_create(THIS_MODULE, "vfio");
 	if (IS_ERR(vfio.class)) {
 		ret = PTR_ERR(vfio.class);
-		goto err_class;
+		goto err_group_class;
 	}
 
 	vfio.class->devnode = vfio_devnode;
 
-	ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1, "vfio");
+	/* /sys/class/vfio-dev/vfioX */
+	vfio.device_class = class_create(THIS_MODULE, "vfio-dev");
+	if (IS_ERR(vfio.device_class)) {
+		ret = PTR_ERR(vfio.device_class);
+		goto err_dev_class;
+	}
+
+	ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1,
+				  "vfio-group");
 	if (ret)
 		goto err_alloc_chrdev;
 
@@ -2181,9 +2218,12 @@ static int __init vfio_init(void)
 err_driver_register:
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 err_alloc_chrdev:
+	class_destroy(vfio.device_class);
+	vfio.device_class = NULL;
+err_dev_class:
 	class_destroy(vfio.class);
 	vfio.class = NULL;
-err_class:
+err_group_class:
 	misc_deregister(&vfio_dev);
 	return ret;
 }
@@ -2195,8 +2235,11 @@ static void __exit vfio_cleanup(void)
 #ifdef CONFIG_VFIO_NOIOMMU
 	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
 #endif
+	ida_destroy(&vfio.device_ida);
 	ida_destroy(&vfio.group_ida);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
+	class_destroy(vfio.device_class);
+	vfio.device_class = NULL;
 	class_destroy(vfio.class);
 	vfio.class = NULL;
 	misc_deregister(&vfio_dev);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f03447c8774d..5c13f74da1bb 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -45,7 +45,8 @@ struct vfio_device {
 	struct kvm *kvm;
 
 	/* Members below here are private, not for driver use */
-	struct kref kref;	/* object life cycle */
+	unsigned int index;
+	struct device device;	/* device.kref covers object life circle */
 	refcount_t refcount;	/* user count on registered device*/
 	unsigned int open_count;
 	struct completion comp;
@@ -154,10 +155,9 @@ struct vfio_device *_vfio_alloc_device(size_t size, struct device *dev,
 int vfio_init_device(struct vfio_device *device, struct device *dev,
 		     const struct vfio_device_ops *ops);
 void vfio_free_device(struct vfio_device *device);
-void vfio_device_release(struct kref *kref);
 static inline void vfio_put_device(struct vfio_device *device)
 {
-	kref_put(&device->kref, vfio_device_release);
+	put_device(&device->device);
 }
 
 int vfio_register_group_dev(struct vfio_device *device);
-- 
2.21.3

