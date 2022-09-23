Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C715E76F4
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 11:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiIWJ1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 05:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiIWJ1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 05:27:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C994D12F76B;
        Fri, 23 Sep 2022 02:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=97YJ2Vae64alChwrkJ1YMKoWcWlxKH6f5sMK5+SFeaU=; b=hZrsNBeGUsOtUAQculQWOdtb25
        sMjBn5jH97+umJgfsBZJzvIKRbad7IBLQ2ChGrn32IfH0CM6SgHX9+d0wCT3L5Wb+y0dRKgFy/4b7
        MN6qG9Pi3qJMGgeVidYzZllYUJotbvmwzhqj3ubBpr/IXwqx+dE9LonQktIpsKhA9FjmyDkkBAH4w
        RmPWg+TDmcDYgz8JU3nikve8fMXXwMYQ4QpWVsPVZJo3QW3324G8AyfuKalghqGKdq2uZJ5NVEi+R
        gkMNW19cA9lDpsBSdYov+n8EKCEmn/60p5Ti0IgGL4kqaMR0rPR9jAsecWj0L0w+7cRXwEV0j40io
        6iDxENTw==;
Received: from ip4d15bec4.dynamic.kabel-deutschland.de ([77.21.190.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obexd-003Jjk-0f; Fri, 23 Sep 2022 09:27:05 +0000
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
Subject: [PATCH 04/14] vfio/mdev: embedd struct mdev_parent in the parent data structure
Date:   Fri, 23 Sep 2022 11:26:42 +0200
Message-Id: <20220923092652.100656-5-hch@lst.de>
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

Simplify mdev_{un}register_device by requiring the caller to pass in
a structure allocate as part of the parent device structure.  This
removes the need for a list of parents and the separate mdev_parent
refcount as we can simplify rely on the reference to the parent device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       |  12 +-
 Documentation/s390/vfio-ap.rst                |   2 +-
 Documentation/s390/vfio-ccw.rst               |   2 +-
 drivers/gpu/drm/i915/gvt/gvt.h                |   2 +
 drivers/gpu/drm/i915/gvt/kvmgt.c              |   5 +-
 drivers/s390/cio/vfio_ccw_drv.c               |   5 +-
 drivers/s390/cio/vfio_ccw_ops.c               |   1 -
 drivers/s390/cio/vfio_ccw_private.h           |   4 +
 drivers/s390/crypto/vfio_ap_ops.c             |   5 +-
 drivers/s390/crypto/vfio_ap_private.h         |   1 +
 drivers/vfio/mdev/mdev_core.c                 | 120 ++++--------------
 drivers/vfio/mdev/mdev_private.h              |  23 ----
 drivers/vfio/mdev/mdev_sysfs.c                |   4 +-
 include/linux/mdev.h                          |  15 ++-
 samples/vfio-mdev/mbochs.c                    |   5 +-
 samples/vfio-mdev/mdpy.c                      |   5 +-
 samples/vfio-mdev/mtty.c                      |   6 +-
 17 files changed, 71 insertions(+), 146 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index f47dca6645aae..cd1667608ab5d 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -58,19 +58,19 @@ devices as examples, as these devices are the first devices to use this module::
      |  MDEV CORE    |
      |   MODULE      |
      |   mdev.ko     |
-     | +-----------+ |  mdev_register_device() +--------------+
+     | +-----------+ |  mdev_register_parent() +--------------+
      | |           | +<------------------------+              |
      | |           | |                         |  nvidia.ko   |<-> physical
      | |           | +------------------------>+              |    device
      | |           | |        callbacks        +--------------+
      | | Physical  | |
-     | |  device   | |  mdev_register_device() +--------------+
+     | |  device   | |  mdev_register_parent() +--------------+
      | | interface | |<------------------------+              |
      | |           | |                         |  i915.ko     |<-> physical
      | |           | +------------------------>+              |    device
      | |           | |        callbacks        +--------------+
      | |           | |
-     | |           | |  mdev_register_device() +--------------+
+     | |           | |  mdev_register_parent() +--------------+
      | |           | +<------------------------+              |
      | |           | |                         | ccw_device.ko|<-> physical
      | |           | +------------------------>+              |    device
@@ -125,8 +125,8 @@ vfio_device_ops.
 When a driver wants to add the GUID creation sysfs to an existing device it has
 probe'd to then it should call::
 
-    int mdev_register_device(struct device *dev,
-                             struct mdev_driver *mdev_driver);
+    int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
+			struct mdev_driver *mdev_driver);
 
 This will provide the 'mdev_supported_types/XX/create' files which can then be
 used to trigger the creation of a mdev_device. The created mdev_device will be
@@ -134,7 +134,7 @@ attached to the specified driver.
 
 When the driver needs to remove itself it calls::
 
-    void mdev_unregister_device(struct device *dev);
+    void mdev_unregister_parent(struct mdev_parent *parent);
 
 Which will unbind and destroy all the created mdevs and remove the sysfs files.
 
diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/s390/vfio-ap.rst
index 61a0a3c6c7b4b..00f4a04f6d4c6 100644
--- a/Documentation/s390/vfio-ap.rst
+++ b/Documentation/s390/vfio-ap.rst
@@ -297,7 +297,7 @@ of the VFIO AP mediated device driver::
    |  MDEV CORE  |
    |   MODULE    |
    |   mdev.ko   |
-   | +---------+ | mdev_register_device() +--------------+
+   | +---------+ | mdev_register_parent() +--------------+
    | |Physical | +<-----------------------+              |
    | | device  | |                        |  vfio_ap.ko  |<-> matrix
    | |interface| +----------------------->+              |    device
diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index 8aad08a8b8a50..ea928a3806f43 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -156,7 +156,7 @@ Below is a high Level block diagram::
  |  MDEV CORE  |
  |   MODULE    |
  |   mdev.ko   |
- | +---------+ | mdev_register_device() +--------------+
+ | +---------+ | mdev_register_parent() +--------------+
  | |Physical | +<-----------------------+              |
  | | device  | |                        |  vfio_ccw.ko |<-> subchannel
  | |interface| +----------------------->+              |     device
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 563ffc2fdfb7a..fa4a56b50c828 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -36,6 +36,7 @@
 #include <uapi/linux/pci_regs.h>
 #include <linux/kvm_host.h>
 #include <linux/vfio.h>
+#include <linux/mdev.h>
 
 #include "i915_drv.h"
 #include "intel_gvt.h"
@@ -337,6 +338,7 @@ struct intel_gvt {
 	struct intel_gvt_workload_scheduler scheduler;
 	struct notifier_block shadow_ctx_notifier_block[I915_NUM_ENGINES];
 	DECLARE_HASHTABLE(cmd_table, GVT_CMD_HASH_BITS);
+	struct mdev_parent parent;
 	struct intel_vgpu_type *types;
 	unsigned int num_types;
 	struct intel_vgpu *idle_vgpu;
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 68f022c4aafbc..29531b797010f 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1922,7 +1922,7 @@ static void intel_gvt_clean_device(struct drm_i915_private *i915)
 	if (drm_WARN_ON(&i915->drm, !gvt))
 		return;
 
-	mdev_unregister_device(i915->drm.dev);
+	mdev_unregister_parent(&gvt->parent);
 	intel_gvt_cleanup_vgpu_type_groups(gvt);
 	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
 	intel_gvt_clean_vgpu_types(gvt);
@@ -2027,7 +2027,8 @@ static int intel_gvt_init_device(struct drm_i915_private *i915)
 	if (ret)
 		goto out_destroy_idle_vgpu;
 
-	ret = mdev_register_device(i915->drm.dev, &intel_vgpu_mdev_driver);
+	ret = mdev_register_parent(&gvt->parent, i915->drm.dev,
+				   &intel_vgpu_mdev_driver);
 	if (ret)
 		goto out_cleanup_vgpu_type_groups;
 
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index e9985c63dc6bf..7d105915bd149 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -221,7 +221,8 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 
 	dev_set_drvdata(&sch->dev, private);
 
-	ret = mdev_register_device(&sch->dev, &vfio_ccw_mdev_driver);
+	ret = mdev_register_parent(&private->parent, &sch->dev,
+				   &vfio_ccw_mdev_driver);
 	if (ret)
 		goto out_free;
 
@@ -240,7 +241,7 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 
-	mdev_unregister_device(&sch->dev);
+	mdev_unregister_parent(&private->parent);
 
 	dev_set_drvdata(&sch->dev, NULL);
 
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 9f8486c0d3d37..9a0e0c5ffb1a5 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/vfio.h>
-#include <linux/mdev.h>
 #include <linux/nospec.h>
 #include <linux/slab.h>
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 63d9202b29c7f..1a4bfb1b5a808 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -18,6 +18,7 @@
 #include <linux/workqueue.h>
 #include <linux/vfio_ccw.h>
 #include <linux/vfio.h>
+#include <linux/mdev.h>
 #include <asm/crw.h>
 #include <asm/debug.h>
 
@@ -89,6 +90,7 @@ struct vfio_ccw_crw {
  * @io_work: work for deferral process of I/O handling
  * @crw_work: work for deferral process of CRW handling
  * @release_comp: synchronization helper for vfio device release
+ * @parent: parent data structures for mdevs created
  */
 struct vfio_ccw_private {
 	struct vfio_device vdev;
@@ -116,6 +118,8 @@ struct vfio_ccw_private {
 	struct work_struct	crw_work;
 
 	struct completion	release_comp;
+
+	struct mdev_parent	parent;
 } __aligned(8);
 
 int vfio_ccw_sch_quiesce(struct subchannel *sch);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 161597357a642..724d09a74a8f1 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1830,7 +1830,8 @@ int vfio_ap_mdev_register(void)
 	if (ret)
 		return ret;
 
-	ret = mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_driver);
+	ret = mdev_register_parent(&matrix_dev->parent, &matrix_dev->device,
+				   &vfio_ap_matrix_driver);
 	if (ret)
 		goto err_driver;
 	return 0;
@@ -1842,7 +1843,7 @@ int vfio_ap_mdev_register(void)
 
 void vfio_ap_mdev_unregister(void)
 {
-	mdev_unregister_device(&matrix_dev->device);
+	mdev_unregister_parent(&matrix_dev->parent);
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
 
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 163eeaaf24cee..35165730f5174 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -52,6 +52,7 @@ struct ap_matrix_dev {
 	struct mutex mdevs_lock; /* serializes access to each ap_matrix_mdev */
 	struct ap_driver  *vfio_ap_drv;
 	struct mutex guests_lock; /* serializes access to each KVM guest */
+	struct mdev_parent parent;
 };
 
 extern struct ap_matrix_dev *matrix_dev;
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 2c32923fbad27..fa05ac3396950 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -18,8 +18,6 @@
 #define DRIVER_AUTHOR		"NVIDIA Corporation"
 #define DRIVER_DESC		"Mediated device Core Driver"
 
-static LIST_HEAD(parent_list);
-static DEFINE_MUTEX(parent_list_lock);
 static struct class_compat *mdev_bus_compat_class;
 
 static LIST_HEAD(mdev_list);
@@ -61,28 +59,6 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype)
 }
 EXPORT_SYMBOL(mtype_get_parent_dev);
 
-/* Should be called holding parent_list_lock */
-static struct mdev_parent *__find_parent_device(struct device *dev)
-{
-	struct mdev_parent *parent;
-
-	list_for_each_entry(parent, &parent_list, next) {
-		if (parent->dev == dev)
-			return parent;
-	}
-	return NULL;
-}
-
-void mdev_release_parent(struct kref *kref)
-{
-	struct mdev_parent *parent = container_of(kref, struct mdev_parent,
-						  ref);
-	struct device *dev = parent->dev;
-
-	kfree(parent);
-	put_device(dev);
-}
-
 /* Caller must hold parent unreg_sem read or write lock */
 static void mdev_device_remove_common(struct mdev_device *mdev)
 {
@@ -105,125 +81,73 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
 }
 
 /*
- * mdev_register_device : Register a device
+ * mdev_register_parent: Register a device as parent for mdevs
+ * @parent: parent structure registered
  * @dev: device structure representing parent device.
  * @mdev_driver: Device driver to bind to the newly created mdev
  *
- * Add device to list of registered parent devices.
+ * Registers the @parent stucture as a parent for mdev types and thus mdev
+ * devices.  The caller needs to hold a reference on @dev that must not be
+ * released until after the call to mdev_unregister_parent().
+ *
  * Returns a negative value on error, otherwise 0.
  */
-int mdev_register_device(struct device *dev, struct mdev_driver *mdev_driver)
+int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
+		struct mdev_driver *mdev_driver)
 {
-	int ret;
-	struct mdev_parent *parent;
 	char *env_string = "MDEV_STATE=registered";
 	char *envp[] = { env_string, NULL };
+	int ret;
 
 	/* check for mandatory ops */
 	if (!mdev_driver->supported_type_groups)
 		return -EINVAL;
 
-	dev = get_device(dev);
-	if (!dev)
-		return -EINVAL;
-
-	mutex_lock(&parent_list_lock);
-
-	/* Check for duplicate */
-	parent = __find_parent_device(dev);
-	if (parent) {
-		parent = NULL;
-		ret = -EEXIST;
-		goto add_dev_err;
-	}
-
-	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
-	if (!parent) {
-		ret = -ENOMEM;
-		goto add_dev_err;
-	}
-
-	kref_init(&parent->ref);
+	memset(parent, 0, sizeof(*parent));
 	init_rwsem(&parent->unreg_sem);
-
 	parent->dev = dev;
 	parent->mdev_driver = mdev_driver;
 
 	if (!mdev_bus_compat_class) {
 		mdev_bus_compat_class = class_compat_register("mdev_bus");
-		if (!mdev_bus_compat_class) {
-			ret = -ENOMEM;
-			goto add_dev_err;
-		}
+		if (!mdev_bus_compat_class)
+			return -ENOMEM;
 	}
 
 	ret = parent_create_sysfs_files(parent);
 	if (ret)
-		goto add_dev_err;
+		return ret;
 
 	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
 	if (ret)
 		dev_warn(dev, "Failed to create compatibility class link\n");
 
-	list_add(&parent->next, &parent_list);
-	mutex_unlock(&parent_list_lock);
-
 	dev_info(dev, "MDEV: Registered\n");
 	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
-
 	return 0;
-
-add_dev_err:
-	mutex_unlock(&parent_list_lock);
-	if (parent)
-		mdev_put_parent(parent);
-	else
-		put_device(dev);
-	return ret;
 }
-EXPORT_SYMBOL(mdev_register_device);
+EXPORT_SYMBOL(mdev_register_parent);
 
 /*
- * mdev_unregister_device : Unregister a parent device
- * @dev: device structure representing parent device.
- *
- * Remove device from list of registered parent devices. Give a chance to free
- * existing mediated devices for given device.
+ * mdev_unregister_parent : Unregister a parent device
+ * @parent: parent structure to unregister
  */
-
-void mdev_unregister_device(struct device *dev)
+void mdev_unregister_parent(struct mdev_parent *parent)
 {
-	struct mdev_parent *parent;
 	char *env_string = "MDEV_STATE=unregistered";
 	char *envp[] = { env_string, NULL };
 
-	mutex_lock(&parent_list_lock);
-	parent = __find_parent_device(dev);
-
-	if (!parent) {
-		mutex_unlock(&parent_list_lock);
-		return;
-	}
-	dev_info(dev, "MDEV: Unregistering\n");
-
-	list_del(&parent->next);
-	mutex_unlock(&parent_list_lock);
+	dev_info(parent->dev, "MDEV: Unregistering\n");
 
 	down_write(&parent->unreg_sem);
-
-	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
-
-	device_for_each_child(dev, NULL, mdev_device_remove_cb);
-
+	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
+	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
 	parent_remove_sysfs_files(parent);
 	up_write(&parent->unreg_sem);
 
-	mdev_put_parent(parent);
-
-	/* We still have the caller's reference to use for the uevent */
-	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+	kobject_uevent_env(&parent->dev->kobj, KOBJ_CHANGE, envp);
 }
-EXPORT_SYMBOL(mdev_unregister_device);
+EXPORT_SYMBOL(mdev_unregister_parent);
 
 static void mdev_device_release(struct device *dev)
 {
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 7c9fc79f3d838..297f911fdc890 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -13,17 +13,6 @@
 int  mdev_bus_register(void);
 void mdev_bus_unregister(void);
 
-struct mdev_parent {
-	struct device *dev;
-	struct mdev_driver *mdev_driver;
-	struct kref ref;
-	struct list_head next;
-	struct kset *mdev_types_kset;
-	struct list_head type_list;
-	/* Synchronize device creation/removal with parent unregistration */
-	struct rw_semaphore unreg_sem;
-};
-
 struct mdev_type {
 	struct kobject kobj;
 	struct kobject *devices_kobj;
@@ -48,16 +37,4 @@ void mdev_remove_sysfs_files(struct mdev_device *mdev);
 int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
 int  mdev_device_remove(struct mdev_device *dev);
 
-void mdev_release_parent(struct kref *kref);
-
-static inline void mdev_get_parent(struct mdev_parent *parent)
-{
-	kref_get(&parent->ref);
-}
-
-static inline void mdev_put_parent(struct mdev_parent *parent)
-{
-	kref_put(&parent->ref, mdev_release_parent);
-}
-
 #endif /* MDEV_PRIVATE_H */
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 4bfbf49aaa66a..b71ffc5594870 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)
 
 	pr_debug("Releasing group %s\n", kobj->name);
 	/* Pairs with the get in add_mdev_supported_type() */
-	mdev_put_parent(type->parent);
+	put_device(type->parent->dev);
 	kfree(type);
 }
 
@@ -110,7 +110,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 	type->kobj.kset = parent->mdev_types_kset;
 	type->parent = parent;
 	/* Pairs with the put in mdev_type_release() */
-	mdev_get_parent(parent);
+	get_device(parent->dev);
 	type->type_group_id = type_group_id;
 
 	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index a5d8ae6132a20..262512c2a8ffc 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -23,6 +23,16 @@ struct mdev_device {
 	bool active;
 };
 
+/* embedded into the struct device that the mdev devices hang off */
+struct mdev_parent {
+	struct device *dev;
+	struct mdev_driver *mdev_driver;
+	struct kset *mdev_types_kset;
+	struct list_head type_list;
+	/* Synchronize device creation/removal with parent unregistration */
+	struct rw_semaphore unreg_sem;
+};
+
 static inline struct mdev_device *to_mdev_device(struct device *dev)
 {
 	return container_of(dev, struct mdev_device, dev);
@@ -70,8 +80,9 @@ struct mdev_driver {
 
 extern struct bus_type mdev_bus_type;
 
-int mdev_register_device(struct device *dev, struct mdev_driver *mdev_driver);
-void mdev_unregister_device(struct device *dev);
+int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
+		struct mdev_driver *mdev_driver);
+void mdev_unregister_parent(struct mdev_parent *parent);
 
 int mdev_register_driver(struct mdev_driver *drv);
 void mdev_unregister_driver(struct mdev_driver *drv);
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 985b6e7136219..2c4791abbc3d3 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -128,6 +128,7 @@ static dev_t		mbochs_devt;
 static struct class	*mbochs_class;
 static struct cdev	mbochs_cdev;
 static struct device	mbochs_dev;
+static struct mdev_parent mbochs_parent;
 static atomic_t mbochs_avail_mbytes;
 static const struct vfio_device_ops mbochs_dev_ops;
 
@@ -1475,7 +1476,7 @@ static int __init mbochs_dev_init(void)
 	if (ret)
 		goto err_class;
 
-	ret = mdev_register_device(&mbochs_dev, &mbochs_driver);
+	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver);
 	if (ret)
 		goto err_device;
 
@@ -1496,7 +1497,7 @@ static int __init mbochs_dev_init(void)
 static void __exit mbochs_dev_exit(void)
 {
 	mbochs_dev.bus = NULL;
-	mdev_unregister_device(&mbochs_dev);
+	mdev_unregister_parent(&mbochs_parent);
 
 	device_unregister(&mbochs_dev);
 	mdev_unregister_driver(&mbochs_driver);
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 1daab012b5d89..01f345430b975 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -83,6 +83,7 @@ static dev_t		mdpy_devt;
 static struct class	*mdpy_class;
 static struct cdev	mdpy_cdev;
 static struct device	mdpy_dev;
+static struct mdev_parent mdpy_parent;
 static u32		mdpy_count;
 static const struct vfio_device_ops mdpy_dev_ops;
 
@@ -778,7 +779,7 @@ static int __init mdpy_dev_init(void)
 	if (ret)
 		goto err_class;
 
-	ret = mdev_register_device(&mdpy_dev, &mdpy_driver);
+	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver);
 	if (ret)
 		goto err_device;
 
@@ -799,7 +800,7 @@ static int __init mdpy_dev_init(void)
 static void __exit mdpy_dev_exit(void)
 {
 	mdpy_dev.bus = NULL;
-	mdev_unregister_device(&mdpy_dev);
+	mdev_unregister_parent(&mdpy_parent);
 
 	device_unregister(&mdpy_dev);
 	mdev_unregister_driver(&mdpy_driver);
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 86843ce3d9a27..e80baac513811 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -72,6 +72,7 @@ static struct mtty_dev {
 	struct cdev	vd_cdev;
 	struct idr	vd_idr;
 	struct device	dev;
+	struct mdev_parent parent;
 } mtty_dev;
 
 struct mdev_region_info {
@@ -1361,7 +1362,8 @@ static int __init mtty_dev_init(void)
 	if (ret)
 		goto err_class;
 
-	ret = mdev_register_device(&mtty_dev.dev, &mtty_driver);
+	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
+				   &mtty_driver);
 	if (ret)
 		goto err_device;
 	return 0;
@@ -1381,7 +1383,7 @@ static int __init mtty_dev_init(void)
 static void __exit mtty_dev_exit(void)
 {
 	mtty_dev.dev.bus = NULL;
-	mdev_unregister_device(&mtty_dev.dev);
+	mdev_unregister_parent(&mtty_dev.parent);
 
 	device_unregister(&mtty_dev.dev);
 	idr_destroy(&mtty_dev.vd_idr);
-- 
2.30.2

