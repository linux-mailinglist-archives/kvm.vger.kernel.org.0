Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92826732C51
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244582AbjFPJlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344675AbjFPJk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:40:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C362117;
        Fri, 16 Jun 2023 02:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686908426; x=1718444426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NNIIXz+C7qHNWm1seHZ8X0fNP4FYEKUC/PmwbYoJq7M=;
  b=XMx8eX+j1PmQ+SRGNgU0AvOyQU6uosA4FcweTJEXYVp6K5JlcRU7R49D
   ORvq6T0SreUfpw5bcD7Enh1afq+QcOTAeETcMhZoTIxv0Q3I7KIJWOgme
   mEzcL9YHqUV1VLnOOyKfOFPAemtFwNT8K5ShEkbnPWBW8UiPPpMcpXJAv
   w9fp0RUT4/ICu4jU2rqm+ed3weAD0uTTvQUOUItjDQe9b53YziKW66bM5
   uiJP19s53iAfJUER1Sz02P3Lem9eKxJV7aWhuuDBDc+A2ch8i6EZZtsd6
   bXTVopSiMTV81AxPKV3j4YP+bDkBes5+h6Pd3hVnsFWLp8/MH7gtRN8FX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="361700418"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="361700418"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 02:40:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715951240"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="715951240"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2023 02:40:24 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v13 17/22] vfio: Add cdev for vfio_device
Date:   Fri, 16 Jun 2023 02:39:41 -0700
Message-Id: <20230616093946.68711-18-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616093946.68711-1-yi.l.liu@intel.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows user to directly open a vfio device w/o using the legacy
container/group interface, as a prerequisite for supporting new iommu
features like nested translation.

The device fd opened in this manner doesn't have the capability to access
the device as the fops open() doesn't open the device until the successful
BIND_IOMMUFD which be added in next patch.

With this patch, devices registered to vfio core have both group and device
interface created.

- group interface : /dev/vfio/$groupID
- device interface: /dev/vfio/devices/vfioX - normal device
		    ("X" is the minor number and is unique across devices)

Given a vfio device the user can identify the matching vfioX by checking
the sysfs path of the device. Take PCI device (0000:6a:01.0) for example,
/sys/bus/pci/devices/0000\:6a\:01.0/vfio-dev/vfio0/dev contains the
major:minor of the matching vfioX.

Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
that the major:minor matches.

The vfio_device cdev logic in this patch:
*) __vfio_register_dev() path ends up doing cdev_device_add() for each
   vfio_device if VFIO_DEVICE_CDEV configured.
*) vfio_unregister_group_dev() path does cdev_device_del();

cdev interface does not support noiommu devices, so VFIO only registers
the group interface for the physcial devices that do not have IOMMU. noiommu
users should use the legacy group interface.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/Kconfig       | 12 ++++++++
 drivers/vfio/Makefile      |  1 +
 drivers/vfio/device_cdev.c | 62 ++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        | 54 +++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c   | 23 +++++++++++---
 include/linux/vfio.h       |  4 +++
 6 files changed, 151 insertions(+), 5 deletions(-)
 create mode 100644 drivers/vfio/device_cdev.c

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 89e06c981e43..1cab8e4729de 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -12,6 +12,18 @@ menuconfig VFIO
 	  If you don't know what to do here, say N.
 
 if VFIO
+config VFIO_DEVICE_CDEV
+	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
+	depends on IOMMUFD
+	help
+	  The VFIO device cdev is another way for userspace to get device
+	  access. Userspace gets device fd by opening device cdev under
+	  /dev/vfio/devices/vfioX, and then bind the device fd with an iommufd
+	  to set up secure DMA context for device access.  This interface does
+	  not support noiommu.
+
+	  If you don't know what to do here, say N.
+
 config VFIO_CONTAINER
 	bool "Support for the VFIO container /dev/vfio/vfio"
 	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 70e7dcb302ef..245394aeb94b 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_VFIO) += vfio.o
 vfio-y += vfio_main.o \
 	  group.o \
 	  iova_bitmap.o
+vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
 vfio-$(CONFIG_VFIO_CONTAINER) += container.o
 vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
new file mode 100644
index 000000000000..1c640016a824
--- /dev/null
+++ b/drivers/vfio/device_cdev.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023 Intel Corporation.
+ */
+#include <linux/vfio.h>
+
+#include "vfio.h"
+
+static dev_t device_devt;
+
+void vfio_init_device_cdev(struct vfio_device *device)
+{
+	device->device.devt = MKDEV(MAJOR(device_devt), device->index);
+	cdev_init(&device->cdev, &vfio_device_fops);
+	device->cdev.owner = THIS_MODULE;
+}
+
+/*
+ * device access via the fd opened by this function is blocked until
+ * .open_device() is called successfully during BIND_IOMMUFD.
+ */
+int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_device *device = container_of(inode->i_cdev,
+						  struct vfio_device, cdev);
+	struct vfio_device_file *df;
+	int ret;
+
+	if (!vfio_device_try_get_registration(device))
+		return -ENODEV;
+
+	df = vfio_allocate_device_file(device);
+	if (IS_ERR(df)) {
+		ret = PTR_ERR(df);
+		goto err_put_registration;
+	}
+
+	filep->private_data = df;
+
+	return 0;
+
+err_put_registration:
+	vfio_device_put_registration(device);
+	return ret;
+}
+
+static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
+}
+
+int vfio_cdev_init(struct class *device_class)
+{
+	device_class->devnode = vfio_device_devnode;
+	return alloc_chrdev_region(&device_devt, 0,
+				   MINORMASK + 1, "vfio-dev");
+}
+
+void vfio_cdev_cleanup(void)
+{
+	unregister_chrdev_region(device_devt, MINORMASK + 1);
+}
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 58801adc1a7e..fb8f2fac3d23 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -266,6 +266,60 @@ vfio_iommufd_compat_attach_ioas(struct vfio_device *device,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
+void vfio_init_device_cdev(struct vfio_device *device);
+
+static inline int vfio_device_add(struct vfio_device *device)
+{
+	/* cdev does not support noiommu device */
+	if (vfio_device_is_noiommu(device))
+		return device_add(&device->device);
+	vfio_init_device_cdev(device);
+	return cdev_device_add(&device->cdev, &device->device);
+}
+
+static inline void vfio_device_del(struct vfio_device *device)
+{
+	if (vfio_device_is_noiommu(device))
+		device_del(&device->device);
+	else
+		cdev_device_del(&device->cdev, &device->device);
+}
+
+int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
+int vfio_cdev_init(struct class *device_class);
+void vfio_cdev_cleanup(void);
+#else
+static inline void vfio_init_device_cdev(struct vfio_device *device)
+{
+}
+
+static inline int vfio_device_add(struct vfio_device *device)
+{
+	return device_add(&device->device);
+}
+
+static inline void vfio_device_del(struct vfio_device *device)
+{
+	device_del(&device->device);
+}
+
+static inline int vfio_device_fops_cdev_open(struct inode *inode,
+					     struct file *filep)
+{
+	return 0;
+}
+
+static inline int vfio_cdev_init(struct class *device_class)
+{
+	return 0;
+}
+
+static inline void vfio_cdev_cleanup(void)
+{
+}
+#endif /* CONFIG_VFIO_DEVICE_CDEV */
+
 #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
 int __init vfio_virqfd_init(void);
 void vfio_virqfd_exit(void);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6d45caa1f9a0..8a9ebcc6980b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -292,7 +292,7 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (ret)
 		return ret;
 
-	ret = device_add(&device->device);
+	ret = vfio_device_add(device);
 	if (ret)
 		goto err_out;
 
@@ -338,6 +338,12 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	 */
 	vfio_device_group_unregister(device);
 
+	/*
+	 * Balances vfio_device_add() in register path, also prevents
+	 * new device opened by userspace in the cdev path.
+	 */
+	vfio_device_del(device);
+
 	vfio_device_put_registration(device);
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
@@ -361,9 +367,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 		}
 	}
 
-	/* Balances device_add in register path */
-	device_del(&device->device);
-
 	/* Balances vfio_device_set_group in register path */
 	vfio_device_remove_group(device);
 }
@@ -567,7 +570,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
-	vfio_df_group_close(df);
+	if (df->group)
+		vfio_df_group_close(df);
 
 	vfio_device_put_registration(device);
 
@@ -1216,6 +1220,7 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 
 const struct file_operations vfio_device_fops = {
 	.owner		= THIS_MODULE,
+	.open		= vfio_device_fops_cdev_open,
 	.release	= vfio_device_fops_release,
 	.read		= vfio_device_fops_read,
 	.write		= vfio_device_fops_write,
@@ -1567,9 +1572,16 @@ static int __init vfio_init(void)
 		goto err_dev_class;
 	}
 
+	ret = vfio_cdev_init(vfio.device_class);
+	if (ret)
+		goto err_alloc_dev_chrdev;
+
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return 0;
 
+err_alloc_dev_chrdev:
+	class_destroy(vfio.device_class);
+	vfio.device_class = NULL;
 err_dev_class:
 	vfio_virqfd_exit();
 err_virqfd:
@@ -1580,6 +1592,7 @@ static int __init vfio_init(void)
 static void __exit vfio_cleanup(void)
 {
 	ida_destroy(&vfio.device_ida);
+	vfio_cdev_cleanup();
 	class_destroy(vfio.device_class);
 	vfio.device_class = NULL;
 	vfio_virqfd_exit();
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 24091a7c7bdb..e0069f26488d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/workqueue.h>
 #include <linux/poll.h>
+#include <linux/cdev.h>
 #include <uapi/linux/vfio.h>
 #include <linux/iova_bitmap.h>
 
@@ -51,6 +52,9 @@ struct vfio_device {
 	/* Members below here are private, not for driver use */
 	unsigned int index;
 	struct device device;	/* device.kref covers object life circle */
+#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
+	struct cdev cdev;
+#endif
 	refcount_t refcount;	/* user count on registered device*/
 	unsigned int open_count;
 	struct completion comp;
-- 
2.34.1

