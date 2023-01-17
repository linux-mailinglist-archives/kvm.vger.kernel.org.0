Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CFB66DF5E
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjAQNuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjAQNuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:50:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7D8367C2
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963398; x=1705499398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VIGYMeqehWy9X7tamECnp9oQp3atpYT9g1Gc4Cx0hq8=;
  b=V+NrCunqp4ezl1LRThWn0juxNiHfYyhmS8glOtaQE8/eertsCSjIgMAe
   vX7bfn/sI5AqxGSfNyXLVQYwQ2n2VZWIHvf425dFG6Xadx2BI7YAN79Wa
   zDSnOCil6RS5fwv3zzz5xLTD9TBH/eE+lj9S0aLakxH2Eg7nEqhOZPqN5
   D34bVc0xC3pbZvmUEBzYy4tnLfw0rG1x9uRN58HBBL413fCWMC4FQ+Zug
   0f3m7xSQ1TXvD6MAU9uVO4p0sJrEO2NX40r9VKcQesx6jB+1unGv/U8C/
   EBCY2OZPDGRtsEkfkMNwgpoao2jnz2cZjVQ+Ozils6ysInVf7dD/gHmip
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766464"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766464"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:49:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551084"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551084"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:58 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH 11/13] vfio: Add cdev for vfio_device
Date:   Tue, 17 Jan 2023 05:49:40 -0800
Message-Id: <20230117134942.101112-12-yi.l.liu@intel.com>
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

This allows user to directly open a vfio device w/o using the legacy
container/group interface, as a prerequisite for supporting new iommu
features like nested translation.

The device fd opened in this manner doesn't have the capability to access
the device as the fops open() doesn't open the device until the successful
BIND_IOMMUFD which be added in next patch.

With this patch, devices registered to vfio core have both group and device
interface created.

- group interface : /dev/vfio/$groupID
- device interface: /dev/vfio/devices/vfioX  (X is the minor number and
					      is unique across devices)

Given a vfio device the user can identify the matching vfioX by checking
the sysfs path of the device. Take PCI device (0000:6a:01.0) for example,
/sys/bus/pci/devices/0000\:6a\:01.0/vfio-dev/vfio0/dev contains the
major:minor of the matching vfioX.

Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
that the major:minor matches.

The vfio_device cdev logic in this patch:
*) __vfio_register_dev() path ends up doing cdev_device_add() for each
   vfio_device;
*) vfio_unregister_group_dev() path does cdev_device_del();

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/vfio/vfio_main.c | 103 ++++++++++++++++++++++++++++++++++++---
 include/linux/vfio.h     |   7 ++-
 2 files changed, 102 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 78725c28b933..6068ffb7c6b7 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -43,6 +43,9 @@
 static struct vfio {
 	struct class			*device_class;
 	struct ida			device_ida;
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	dev_t                           device_devt;
+#endif
 } vfio;
 
 static DEFINE_XARRAY(vfio_device_set_xa);
@@ -156,7 +159,11 @@ static void vfio_device_release(struct device *dev)
 			container_of(dev, struct vfio_device, device);
 
 	vfio_release_device_set(device);
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	ida_free(&vfio.device_ida, MINOR(device->device.devt));
+#else
 	ida_free(&vfio.device_ida, device->index);
+#endif
 
 	if (device->ops->release)
 		device->ops->release(device);
@@ -209,15 +216,16 @@ EXPORT_SYMBOL_GPL(_vfio_alloc_device);
 static int vfio_init_device(struct vfio_device *device, struct device *dev,
 			    const struct vfio_device_ops *ops)
 {
+	unsigned int minor;
 	int ret;
 
 	ret = ida_alloc_max(&vfio.device_ida, MINORMASK, GFP_KERNEL);
 	if (ret < 0) {
-		dev_dbg(dev, "Error to alloc index\n");
+		dev_dbg(dev, "Error to alloc minor\n");
 		return ret;
 	}
 
-	device->index = ret;
+	minor = ret;
 	init_completion(&device->comp);
 	device->dev = dev;
 	device->ops = ops;
@@ -232,17 +240,25 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
 	device->device.release = vfio_device_release;
 	device->device.class = vfio.device_class;
 	device->device.parent = device->dev;
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	device->device.devt = MKDEV(MAJOR(vfio.device_devt), minor);
+	cdev_init(&device->cdev, &vfio_device_fops);
+	device->cdev.owner = THIS_MODULE;
+#else
+	device->index = minor;
+#endif
 	return 0;
 
 out_uninit:
 	vfio_release_device_set(device);
-	ida_free(&vfio.device_ida, device->index);
+	ida_free(&vfio.device_ida, minor);
 	return ret;
 }
 
 static int __vfio_register_dev(struct vfio_device *device,
 			       enum vfio_group_type type)
 {
+	unsigned int minor;
 	int ret;
 
 	if (WARN_ON(device->ops->bind_iommufd &&
@@ -257,7 +273,12 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	ret = dev_set_name(&device->device, "vfio%d", device->index);
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	minor = MINOR(device->device.devt);
+#else
+	minor = device->index;
+#endif
+	ret = dev_set_name(&device->device, "vfio%d", minor);
 	if (ret)
 		return ret;
 
@@ -265,7 +286,11 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (ret)
 		return ret;
 
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	ret = cdev_device_add(&device->cdev, &device->device);
+#else
 	ret = device_add(&device->device);
+#endif
 	if (ret)
 		goto err_out;
 
@@ -305,6 +330,17 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	bool interrupted = false;
 	long rc;
 
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	/*
+	 * Balances device_add in register path. Putting it as the first
+	 * operation in unregister to prevent registration refcount from
+	 * incrementing per cdev open.
+	 */
+	cdev_device_del(&device->cdev, &device->device);
+#else
+	device_del(&device->device);
+#endif
+
 	vfio_device_put_registration(device);
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
@@ -330,9 +366,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 
 	vfio_device_group_unregister(device);
 
-	/* Balances device_add in register path */
-	device_del(&device->device);
-
 	/* Balances vfio_device_set_group in register path */
 	vfio_device_remove_group(device);
 }
@@ -502,6 +535,37 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
 /*
  * VFIO Device fd
  */
+#if IS_ENABLED(CONFIG_IOMMUFD)
+static int vfio_device_fops_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_device *device = container_of(inode->i_cdev,
+						  struct vfio_device, cdev);
+	struct vfio_device_file *df;
+	int ret;
+
+	if (!vfio_device_try_get_registration(device))
+		return -ENODEV;
+
+	/*
+	 * device access is blocked until .open_device() is called
+	 * in BIND_IOMMUFD.
+	 */
+	df = vfio_allocate_device_file(device, true);
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
+#endif
+
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device_file *df = filep->private_data;
@@ -1169,6 +1233,9 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 
 const struct file_operations vfio_device_fops = {
 	.owner		= THIS_MODULE,
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	.open		= vfio_device_fops_open,
+#endif
 	.release	= vfio_device_fops_release,
 	.read		= vfio_device_fops_read,
 	.write		= vfio_device_fops_write,
@@ -1522,6 +1589,13 @@ EXPORT_SYMBOL(vfio_dma_rw);
 /*
  * Module/class support
  */
+#if IS_ENABLED(CONFIG_IOMMUFD)
+static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
+}
+#endif
+
 static int __init vfio_init(void)
 {
 	int ret;
@@ -1543,9 +1617,21 @@ static int __init vfio_init(void)
 		goto err_dev_class;
 	}
 
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	vfio.device_class->devnode = vfio_device_devnode;
+	ret = alloc_chrdev_region(&vfio.device_devt, 0,
+				  MINORMASK + 1, "vfio-dev");
+	if (ret)
+		goto err_alloc_dev_chrdev;
+#endif
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return 0;
 
+#if IS_ENABLED(CONFIG_IOMMUFD)
+err_alloc_dev_chrdev:
+	class_destroy(vfio.device_class);
+	vfio.device_class = NULL;
+#endif
 err_dev_class:
 	vfio_virqfd_exit();
 err_virqfd:
@@ -1556,6 +1642,9 @@ static int __init vfio_init(void)
 static void __exit vfio_cleanup(void)
 {
 	ida_destroy(&vfio.device_ida);
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	unregister_chrdev_region(vfio.device_devt, MINORMASK + 1);
+#endif
 	class_destroy(vfio.device_class);
 	vfio.device_class = NULL;
 	vfio_virqfd_exit();
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 300318f0d448..4a31842ebe0b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/workqueue.h>
 #include <linux/poll.h>
+#include <linux/cdev.h>
 #include <uapi/linux/vfio.h>
 #include <linux/iova_bitmap.h>
 
@@ -50,8 +51,12 @@ struct vfio_device {
 	struct kvm *kvm;
 
 	/* Members below here are private, not for driver use */
-	unsigned int index;
 	struct device device;	/* device.kref covers object life circle */
+#if IS_ENABLED(CONFIG_IOMMUFD)
+	struct cdev cdev;
+#else
+	unsigned int index;
+#endif
 	refcount_t refcount;	/* user count on registered device*/
 	unsigned int open_count;
 	struct completion comp;
-- 
2.34.1

