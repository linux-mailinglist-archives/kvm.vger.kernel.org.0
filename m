Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE55E7716
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 11:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiIWJ22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 05:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiIWJ1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 05:27:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A96F1900;
        Fri, 23 Sep 2022 02:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qpAI9lJpdDF9HWWBLsg6Mwha9epSJ6GbEs45TDgguZk=; b=mNnDkHhfw/OkvjXieZ+D1CEoER
        eR1r7pIeTtNxLMCQPc/QWfCkdXBsp/3Jkmu4Ge/Y6DkUsVoq8hPAeoTGsP5YiBli2r8qgAj6aavoN
        uPlqqfd8c5hOp7r+DmBeUHDUPho870TQV3Fy9T638fewVRMpIgVWZEv9YqMsT/N+wmuigkkjIdP6g
        vmw/UP5fcFOd0X+NVpsQcbN6Cg9gUueJMIyvBYzxX2JBscpDFeo2oPgDnkYnYp4dMBHr846oDAI5Z
        d0YB/uGxBKZ1gU955Kk8iTnaxqIEzaQu7c5/bHk8bK0+fmpo1/++yQvOlYmboVGWAetRj9AAiK9zt
        +Ddgac+Q==;
Received: from ip4d15bec4.dynamic.kabel-deutschland.de ([77.21.190.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obey2-003Jz8-Pg; Fri, 23 Sep 2022 09:27:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 14/14] vfio/mdev: add mdev available instance checking to the core
Date:   Fri, 23 Sep 2022 11:26:52 +0200
Message-Id: <20220923092652.100656-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220923092652.100656-1-hch@lst.de>
References: <20220923092652.100656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

Many of the mdev drivers use a simple counter for keeping track of the
available instances. Move this code to the core code and store the counter
in the mdev_parent. Implement it using correct locking, fixing mdpy.

Drivers just provide the value in the mdev_driver at registration time
and the core code takes care of maintaining it and exposing the value in
sysfs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[hch: count instances per-parent instead of per-type, use an atomic_t
 to avoid taking mdev_list_lock in the show method]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_drv.c       |  1 -
 drivers/s390/cio/vfio_ccw_ops.c       | 15 +--------------
 drivers/s390/cio/vfio_ccw_private.h   |  2 --
 drivers/s390/crypto/vfio_ap_ops.c     | 13 +------------
 drivers/s390/crypto/vfio_ap_private.h |  2 --
 drivers/vfio/mdev/mdev_core.c         | 22 +++++++++++++++++++---
 drivers/vfio/mdev/mdev_sysfs.c        |  5 ++++-
 include/linux/mdev.h                  |  3 +++
 samples/vfio-mdev/mdpy.c              | 22 ++++------------------
 9 files changed, 32 insertions(+), 53 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index e5f21c725326b..7f5402fe857a2 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -141,7 +141,6 @@ static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
 	INIT_LIST_HEAD(&private->crw);
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
 	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
-	atomic_set(&private->avail, 1);
 
 	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
 				       GFP_KERNEL);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 559ca18055928..6ae4d012d8008 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -44,13 +44,6 @@ static void vfio_ccw_dma_unmap(struct vfio_device *vdev, u64 iova, u64 length)
 	vfio_ccw_mdev_reset(private);
 }
 
-static unsigned int vfio_ccw_get_available(struct mdev_type *mtype)
-{
-	struct vfio_ccw_private *private = dev_get_drvdata(mtype->parent->dev);
-
-	return atomic_read(&private->avail);
-}
-
 static int vfio_ccw_mdev_init_dev(struct vfio_device *vdev)
 {
 	struct vfio_ccw_private *private =
@@ -68,9 +61,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	if (private->state == VFIO_CCW_STATE_NOT_OPER)
 		return -ENODEV;
 
-	if (atomic_dec_if_positive(&private->avail) < 0)
-		return -EPERM;
-
 	ret = vfio_init_device(&private->vdev, &mdev->dev, &vfio_ccw_dev_ops);
 	if (ret)
 		return ret;
@@ -88,7 +78,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 
 err_put_vdev:
 	vfio_put_device(&private->vdev);
-	atomic_inc(&private->avail);
 	return ret;
 }
 
@@ -130,8 +119,6 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 	 * cycle.
 	 */
 	wait_for_completion(&private->release_comp);
-
-	atomic_inc(&private->avail);
 }
 
 static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
@@ -605,6 +592,7 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
 
 struct mdev_driver vfio_ccw_mdev_driver = {
 	.device_api = VFIO_DEVICE_API_CCW_STRING,
+	.max_instances = 1,
 	.driver = {
 		.name = "vfio_ccw_mdev",
 		.owner = THIS_MODULE,
@@ -612,5 +600,4 @@ struct mdev_driver vfio_ccw_mdev_driver = {
 	},
 	.probe = vfio_ccw_mdev_probe,
 	.remove = vfio_ccw_mdev_remove,
-	.get_available = vfio_ccw_get_available,
 };
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 52caa721ec06c..bd5fb81456af8 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -73,7 +73,6 @@ struct vfio_ccw_crw {
  * @sch: pointer to the subchannel
  * @state: internal state of the device
  * @completion: synchronization helper of the I/O completion
- * @avail: available for creating a mediated device
  * @io_region: MMIO region to input/output I/O arguments/results
  * @io_mutex: protect against concurrent update of I/O regions
  * @region: additional regions for other subchannel operations
@@ -97,7 +96,6 @@ struct vfio_ccw_private {
 	struct subchannel	*sch;
 	int			state;
 	struct completion	*completion;
-	atomic_t		avail;
 	struct ccw_io_region	*io_region;
 	struct mutex		io_mutex;
 	struct vfio_ccw_region *region;
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 8606f5d75188c..2884189f38771 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -689,9 +689,6 @@ static int vfio_ap_mdev_init_dev(struct vfio_device *vdev)
 	struct ap_matrix_mdev *matrix_mdev =
 		container_of(vdev, struct ap_matrix_mdev, vdev);
 
-	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
-		return -EPERM;
-
 	matrix_mdev->mdev = to_mdev_device(vdev->dev);
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	matrix_mdev->pqap_hook = handle_pqap;
@@ -770,7 +767,6 @@ static void vfio_ap_mdev_unlink_fr_queues(struct ap_matrix_mdev *matrix_mdev)
 
 static void vfio_ap_mdev_release_dev(struct vfio_device *vdev)
 {
-	atomic_inc(&matrix_dev->available_instances);
 	vfio_free_device(vdev);
 }
 
@@ -790,11 +786,6 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	vfio_put_device(&matrix_mdev->vdev);
 }
 
-static unsigned int vfio_ap_mdev_get_available(struct mdev_type *mtype)
-{
-	return atomic_read(&matrix_dev->available_instances);
-}
-
 #define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
 			 "already assigned to %s"
 
@@ -1772,6 +1763,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
 
 static struct mdev_driver vfio_ap_matrix_driver = {
 	.device_api = VFIO_DEVICE_API_AP_STRING,
+	.max_instances = MAX_ZDEV_ENTRIES_EXT,
 	.driver = {
 		.name = "vfio_ap_mdev",
 		.owner = THIS_MODULE,
@@ -1780,15 +1772,12 @@ static struct mdev_driver vfio_ap_matrix_driver = {
 	},
 	.probe = vfio_ap_mdev_probe,
 	.remove = vfio_ap_mdev_remove,
-	.get_available = vfio_ap_mdev_get_available,
 };
 
 int vfio_ap_mdev_register(void)
 {
 	int ret;
 
-	atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
-
 	ret = mdev_register_driver(&vfio_ap_matrix_driver);
 	if (ret)
 		return ret;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 441dc8dda380b..2eddd5f34ed34 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -29,7 +29,6 @@
  * struct ap_matrix_dev - Contains the data for the matrix device.
  *
  * @device:	generic device structure associated with the AP matrix device
- * @available_instances: number of mediated matrix devices that can be created
  * @info:	the struct containing the output from the PQAP(QCI) instruction
  * @mdev_list:	the list of mediated matrix devices created
  * @mdevs_lock: mutex for locking the AP matrix device. This lock will be
@@ -46,7 +45,6 @@
  */
 struct ap_matrix_dev {
 	struct device device;
-	atomic_t available_instances;
 	struct ap_config_info info;
 	struct list_head mdev_list;
 	struct mutex mdevs_lock; /* serializes access to each ap_matrix_mdev */
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 93f8caf2e5f77..58f91b3bd670c 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -70,6 +70,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
 	parent->mdev_driver = mdev_driver;
 	parent->types = types;
 	parent->nr_types = nr_types;
+	atomic_set(&parent->available_instances, mdev_driver->max_instances);
 
 	if (!mdev_bus_compat_class) {
 		mdev_bus_compat_class = class_compat_register("mdev_bus");
@@ -115,14 +116,17 @@ EXPORT_SYMBOL(mdev_unregister_parent);
 static void mdev_device_release(struct device *dev)
 {
 	struct mdev_device *mdev = to_mdev_device(dev);
-
-	/* Pairs with the get in mdev_device_create() */
-	kobject_put(&mdev->type->kobj);
+	struct mdev_parent *parent = mdev->type->parent;
 
 	mutex_lock(&mdev_list_lock);
 	list_del(&mdev->next);
+	if (!parent->mdev_driver->get_available)
+		atomic_inc(&parent->available_instances);
 	mutex_unlock(&mdev_list_lock);
 
+	/* Pairs with the get in mdev_device_create() */
+	kobject_put(&mdev->type->kobj);
+
 	dev_dbg(&mdev->dev, "MDEV: destroying\n");
 	kfree(mdev);
 }
@@ -144,6 +148,18 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 		}
 	}
 
+	if (!drv->get_available) {
+		/*
+		 * Note: that non-atomic read and dec is fine here because
+		 * all modifications are under mdev_list_lock.
+		 */
+		if (!atomic_read(&parent->available_instances)) {
+			mutex_unlock(&mdev_list_lock);
+			return -EUSERS;
+		}
+		atomic_dec(&parent->available_instances);
+	}
+
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev) {
 		mutex_unlock(&mdev_list_lock);
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 658b3bf5ed0bf..abe3359dd477f 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -108,7 +108,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 {
 	struct mdev_driver *drv = mtype->parent->mdev_driver;
 
-	return sysfs_emit(buf, "%u\n", drv->get_available(mtype));
+	if (drv->get_available)
+		return sysfs_emit(buf, "%u\n", drv->get_available(mtype));
+	return sysfs_emit(buf, "%u\n",
+			  atomic_read(&mtype->parent->available_instances));
 }
 static MDEV_TYPE_ATTR_RO(available_instances);
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 33674cb5ed5d4..139d05b26f820 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -45,6 +45,7 @@ struct mdev_parent {
 	struct rw_semaphore unreg_sem;
 	struct mdev_type **types;
 	unsigned int nr_types;
+	atomic_t available_instances;
 };
 
 static inline struct mdev_device *to_mdev_device(struct device *dev)
@@ -55,6 +56,7 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
 /**
  * struct mdev_driver - Mediated device driver
  * @device_api: string to return for the device_api sysfs
+ * @max_instances: maximum number of instances supported (optional)
  * @probe: called when new device created
  * @remove: called when device removed
  * @get_available: Return the max number of instances that can be created
@@ -63,6 +65,7 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
  **/
 struct mdev_driver {
 	const char *device_api;
+	unsigned int max_instances;
 	int (*probe)(struct mdev_device *dev);
 	void (*remove)(struct mdev_device *dev);
 	unsigned int (*get_available)(struct mdev_type *mtype);
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index a7cf59246ddd0..946e8cfde6fdd 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -42,11 +42,6 @@
 
 MODULE_LICENSE("GPL v2");
 
-static int max_devices = 4;
-module_param_named(count, max_devices, int, 0444);
-MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
-
-
 #define MDPY_TYPE_1 "vga"
 #define MDPY_TYPE_2 "xga"
 #define MDPY_TYPE_3 "hd"
@@ -93,7 +88,6 @@ static struct class	*mdpy_class;
 static struct cdev	mdpy_cdev;
 static struct device	mdpy_dev;
 static struct mdev_parent mdpy_parent;
-static u32		mdpy_count;
 static const struct vfio_device_ops mdpy_dev_ops;
 
 /* State of each mdev device */
@@ -235,9 +229,6 @@ static int mdpy_init_dev(struct vfio_device *vdev)
 	u32 fbsize;
 	int ret = -ENOMEM;
 
-	if (mdpy_count >= max_devices)
-		return ret;
-
 	mdev_state->vconfig = kzalloc(MDPY_CONFIG_SPACE_SIZE, GFP_KERNEL);
 	if (!mdev_state->vconfig)
 		return ret;
@@ -257,8 +248,6 @@ static int mdpy_init_dev(struct vfio_device *vdev)
 
 	dev_info(vdev->dev, "%s: %s (%dx%d)\n", __func__, type->type.pretty_name,
 		 type->width, type->height);
-
-	mdpy_count++;
 	return 0;
 
 out_vconfig:
@@ -292,7 +281,6 @@ static void mdpy_release_dev(struct vfio_device *vdev)
 	struct mdev_state *mdev_state =
 		container_of(vdev, struct mdev_state, vdev);
 
-	mdpy_count--;
 	vfree(mdev_state->memblk);
 	kfree(mdev_state->vconfig);
 	vfio_free_device(vdev);
@@ -669,11 +657,6 @@ static ssize_t mdpy_show_description(struct mdev_type *mtype, char *buf)
 		       type->width, type->height);
 }
 
-static unsigned int mdpy_get_available(struct mdev_type *mtype)
-{
-	return max_devices - mdpy_count;
-}
-
 static const struct vfio_device_ops mdpy_dev_ops = {
 	.init = mdpy_init_dev,
 	.release = mdpy_release_dev,
@@ -685,6 +668,7 @@ static const struct vfio_device_ops mdpy_dev_ops = {
 
 static struct mdev_driver mdpy_driver = {
 	.device_api = VFIO_DEVICE_API_PCI_STRING,
+	.max_instances = 4,
 	.driver = {
 		.name = "mdpy",
 		.owner = THIS_MODULE,
@@ -693,7 +677,6 @@ static struct mdev_driver mdpy_driver = {
 	},
 	.probe = mdpy_probe,
 	.remove	= mdpy_remove,
-	.get_available = mdpy_get_available,
 	.show_description = mdpy_show_description,
 };
 
@@ -770,5 +753,8 @@ static void __exit mdpy_dev_exit(void)
 	mdpy_class = NULL;
 }
 
+module_param_named(count, mdpy_driver.max_instances, int, 0444);
+MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
+
 module_init(mdpy_dev_init)
 module_exit(mdpy_dev_exit)
-- 
2.30.2

