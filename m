Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDF9338A9
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 20:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfFCS5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 14:57:15 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36594 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726715AbfFCS5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 14:57:13 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Jun 2019 21:57:08 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x53Iv0Qi018101;
        Mon, 3 Jun 2019 21:57:07 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, kwankhede@nvidia.com, alex.williamson@redhat.com
Cc:     cjia@nvidia.com, parav@mellanox.com
Subject: [PATCHv6 3/3] vfio/mdev: Synchronize device create/remove with parent removal
Date:   Mon,  3 Jun 2019 13:56:58 -0500
Message-Id: <20190603185658.54517-4-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190603185658.54517-1-parav@mellanox.com>
References: <20190603185658.54517-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In following sequences, child devices created while removing mdev parent
device can be left out, or it may lead to race of removing half
initialized child mdev devices.

issue-1:
--------
       cpu-0                         cpu-1
       -----                         -----
                                  mdev_unregister_device()
                                    device_for_each_child()
                                      mdev_device_remove_cb()
                                        mdev_device_remove()
create_store()
  mdev_device_create()                   [...]
    device_add()
                                  parent_remove_sysfs_files()

/* BUG: device added by cpu-0
 * whose parent is getting removed
 * and it won't process this mdev.
 */

issue-2:
--------
Below crash is observed when user initiated remove is in progress
and mdev_unregister_driver() completes parent unregistration.

       cpu-0                         cpu-1
       -----                         -----
remove_store()
   mdev_device_remove()
   active = false;
                                  mdev_unregister_device()
                                  parent device removed.
   [...]
   parents->ops->remove()
 /*
  * BUG: Accessing invalid parent.
  */

This is similar race like create() racing with mdev_unregister_device().

BUG: unable to handle kernel paging request at ffffffffc0585668
PGD e8f618067 P4D e8f618067 PUD e8f61a067 PMD 85adca067 PTE 0
Oops: 0000 [#1] SMP PTI
CPU: 41 PID: 37403 Comm: bash Kdump: loaded Not tainted 5.1.0-rc6-vdevbus+ #6
Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b 08/09/2016
RIP: 0010:mdev_device_remove+0xfa/0x140 [mdev]
Call Trace:
 remove_store+0x71/0x90 [mdev]
 kernfs_fop_write+0x113/0x1a0
 vfs_write+0xad/0x1b0
 ksys_write+0x5a/0xe0
 do_syscall_64+0x5a/0x210
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Therefore, mdev core is improved as below to overcome above issues.

Wait for any ongoing mdev create() and remove() to finish before
unregistering parent device.
This continues to allow multiple create and remove to progress in
parallel for different mdev devices as most common case.
At the same time guard parent removal while parent is being accessed by
create() and remove() callbacks.
create()/remove() and unregister_device() are synchronized by the rwsem.

Refactor device removal code to mdev_device_remove_common() to avoid
acquiring unreg_sem of the parent.

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c    | 71 ++++++++++++++++++++++++--------
 drivers/vfio/mdev/mdev_private.h |  2 +
 2 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 0bef0cae1d4b..c544656191cd 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -102,11 +102,35 @@ static void mdev_put_parent(struct mdev_parent *parent)
 		kref_put(&parent->ref, mdev_release_parent);
 }
 
+/* Caller must hold parent unreg_sem read or write lock */
+static void mdev_device_remove_common(struct mdev_device *mdev)
+{
+	struct mdev_parent *parent;
+	struct mdev_type *type;
+	int ret;
+
+	type = to_mdev_type(mdev->type_kobj);
+	mdev_remove_sysfs_files(&mdev->dev, type);
+	device_del(&mdev->dev);
+	parent = mdev->parent;
+	lockdep_assert_held(&parent->unreg_sem);
+	ret = parent->ops->remove(mdev);
+	if (ret)
+		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
+
+	/* Balances with device_initialize() */
+	put_device(&mdev->dev);
+	mdev_put_parent(parent);
+}
+
 static int mdev_device_remove_cb(struct device *dev, void *data)
 {
-	if (dev_is_mdev(dev))
-		mdev_device_remove(dev);
+	if (dev_is_mdev(dev)) {
+		struct mdev_device *mdev;
 
+		mdev = to_mdev_device(dev);
+		mdev_device_remove_common(mdev);
+	}
 	return 0;
 }
 
@@ -148,6 +172,7 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	}
 
 	kref_init(&parent->ref);
+	init_rwsem(&parent->unreg_sem);
 
 	parent->dev = dev;
 	parent->ops = ops;
@@ -206,21 +231,23 @@ void mdev_unregister_device(struct device *dev)
 	dev_info(dev, "MDEV: Unregistering\n");
 
 	list_del(&parent->next);
+	mutex_unlock(&parent_list_lock);
+
+	down_write(&parent->unreg_sem);
+
 	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
 
 	device_for_each_child(dev, NULL, mdev_device_remove_cb);
 
 	parent_remove_sysfs_files(parent);
+	up_write(&parent->unreg_sem);
 
-	mutex_unlock(&parent_list_lock);
 	mdev_put_parent(parent);
 }
 EXPORT_SYMBOL(mdev_unregister_device);
 
-static void mdev_device_release(struct device *dev)
+static void mdev_device_free(struct mdev_device *mdev)
 {
-	struct mdev_device *mdev = to_mdev_device(dev);
-
 	mutex_lock(&mdev_list_lock);
 	list_del(&mdev->next);
 	mutex_unlock(&mdev_list_lock);
@@ -229,6 +256,13 @@ static void mdev_device_release(struct device *dev)
 	kfree(mdev);
 }
 
+static void mdev_device_release(struct device *dev)
+{
+	struct mdev_device *mdev = to_mdev_device(dev);
+
+	mdev_device_free(mdev);
+}
+
 int mdev_device_create(struct kobject *kobj,
 		       struct device *dev, const guid_t *uuid)
 {
@@ -265,6 +299,12 @@ int mdev_device_create(struct kobject *kobj,
 
 	mdev->parent = parent;
 
+	if (!down_read_trylock(&parent->unreg_sem)) {
+		mdev_device_free(mdev);
+		ret = -ENODEV;
+		goto mdev_fail;
+	}
+
 	device_initialize(&mdev->dev);
 	mdev->dev.parent  = dev;
 	mdev->dev.bus     = &mdev_bus_type;
@@ -287,6 +327,7 @@ int mdev_device_create(struct kobject *kobj,
 
 	mdev->active = true;
 	dev_dbg(&mdev->dev, "MDEV: created\n");
+	up_read(&parent->unreg_sem);
 
 	return 0;
 
@@ -295,6 +336,7 @@ int mdev_device_create(struct kobject *kobj,
 add_fail:
 	parent->ops->remove(mdev);
 ops_create_fail:
+	up_read(&parent->unreg_sem);
 	put_device(&mdev->dev);
 mdev_fail:
 	mdev_put_parent(parent);
@@ -305,8 +347,6 @@ int mdev_device_remove(struct device *dev)
 {
 	struct mdev_device *mdev, *tmp;
 	struct mdev_parent *parent;
-	struct mdev_type *type;
-	int ret;
 
 	mdev = to_mdev_device(dev);
 
@@ -329,18 +369,13 @@ int mdev_device_remove(struct device *dev)
 	mdev->active = false;
 	mutex_unlock(&mdev_list_lock);
 
-	type = to_mdev_type(mdev->type_kobj);
-	mdev_remove_sysfs_files(dev, type);
-	device_del(&mdev->dev);
 	parent = mdev->parent;
-	ret = parent->ops->remove(mdev);
-	if (ret)
-		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
-
-	/* Balances with device_initialize() */
-	put_device(&mdev->dev);
-	mdev_put_parent(parent);
+	/* Check if parent unregistration has started */
+	if (!down_read_trylock(&parent->unreg_sem))
+		return -ENODEV;
 
+	mdev_device_remove_common(mdev);
+	up_read(&parent->unreg_sem);
 	return 0;
 }
 
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 924ed2274941..398767526276 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -23,6 +23,8 @@ struct mdev_parent {
 	struct list_head next;
 	struct kset *mdev_types_kset;
 	struct list_head type_list;
+	/* Synchronize device creation/removal with parent unregistration */
+	struct rw_semaphore unreg_sem;
 };
 
 struct mdev_device {
-- 
2.19.2

