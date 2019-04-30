Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0240B102C0
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 00:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfD3Wty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 18:49:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45904 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727580AbfD3Wtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 18:49:53 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 May 2019 01:49:50 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x3UMncna009688;
        Wed, 1 May 2019 01:49:49 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com
Cc:     cjia@nvidia.com, parav@mellanox.com
Subject: [PATCHv2 06/10] vfio/mdev: Fix aborting mdev child device removal if one fails
Date:   Tue, 30 Apr 2019 17:49:33 -0500
Message-Id: <20190430224937.57156-7-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190430224937.57156-1-parav@mellanox.com>
References: <20190430224937.57156-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

device_for_each_child() stops executing callback function for remaining
child devices, if callback hits an error.
Each child mdev device is independent of each other.
While unregistering parent device, mdev core must remove all child mdev
devices.
Therefore, mdev_device_remove_cb() always returns success so that
device_for_each_child doesn't abort if one child removal hits error.

While at it, improve remove and unregister functions for below simplicity.

There isn't need to pass forced flag pointer during mdev parent
removal which invokes mdev_device_remove(). So simplify the flow.

mdev_device_remove() is called from two paths.
1. mdev_unregister_driver()
     mdev_device_remove_cb()
       mdev_device_remove()
2. remove_store()
     mdev_device_remove()

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 836d31985f14..1a317e409355 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -149,10 +149,10 @@ static int mdev_device_remove_ops(struct mdev_device *mdev, bool force_remove)
 
 static int mdev_device_remove_cb(struct device *dev, void *data)
 {
-	if (!dev_is_mdev(dev))
-		return 0;
+	if (dev_is_mdev(dev))
+		mdev_device_remove(dev, true);
 
-	return mdev_device_remove(dev, data ? *(bool *)data : true);
+	return 0;
 }
 
 /*
@@ -240,7 +240,6 @@ EXPORT_SYMBOL(mdev_register_device);
 void mdev_unregister_device(struct device *dev)
 {
 	struct mdev_parent *parent;
-	bool force_remove = true;
 
 	mutex_lock(&parent_list_lock);
 	parent = __find_parent_device(dev);
@@ -254,8 +253,7 @@ void mdev_unregister_device(struct device *dev)
 	list_del(&parent->next);
 	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
 
-	device_for_each_child(dev, (void *)&force_remove,
-			      mdev_device_remove_cb);
+	device_for_each_child(dev, NULL, mdev_device_remove_cb);
 
 	parent_remove_sysfs_files(parent);
 
-- 
2.19.2

