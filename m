Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F1C3A8124
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhFONpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbhFONob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:44:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC5AC06124C;
        Tue, 15 Jun 2021 06:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=mK8kZxMmwpLFLvKSSecAo5yq1vW8IxoaNB0nNbcvV1U=; b=NeNkWrMpxi5NbqQfChlo/RWEN3
        2n4gR0BicGJZ/z5H1/Gy5berYFCbKixhTQaSQkSYy5zWUuwGEdCCkb2/tUMZke8iZh7QVEp+0VKaF
        T+eCQe6FmDQu559h598Gknm/pWm4A+ikqiD83CunvBMMw9jvOo6/7B83sk2OeLmGjepSlvV3A9dJV
        3O9OgDzVKNebRd2SnjKhOKnASe8BFuq4oszTj590roLoMSa2zyRyxhN5nKb2JmRB+mowtVjqH68NX
        8EwV/DeIDV+ImCKx7jCPcPudCdpo+LmKrakKGhFjiVE4X8bsFhvRtksmCeOVN/rEeyt1J6K+3958G
        8TX89lOA==;
Received: from [2001:4bb8:19b:fdce:9045:1e63:20f0:ca9] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lt9IF-006pNO-Vg; Tue, 15 Jun 2021 13:40:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 07/10] vfio/mdev: Allow the mdev_parent_ops to specify the device driver to bind
Date:   Tue, 15 Jun 2021 15:35:16 +0200
Message-Id: <20210615133519.754763-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615133519.754763-1-hch@lst.de>
References: <20210615133519.754763-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

This allows a mdev driver to opt out of using vfio_mdev.c, instead the
driver will provide a 'struct mdev_driver' and register directly with the
driver core.

Much of mdev_parent_ops becomes unused in this mode:
- create()/remove() are done via the mdev_driver probe()/remove()
- mdev_attr_groups becomes mdev_driver driver.dev_groups
- Wrapper function callbacks are replaced with the same ones from
  struct vfio_device_ops

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/mdev/mdev_core.c   | 30 ++++++++++++++++++++++--------
 drivers/vfio/mdev/mdev_driver.c | 10 ++++++++++
 include/linux/mdev.h            |  2 ++
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index ff8c1a845166..e4581ec093a6 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -94,9 +94,11 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
 	mdev_remove_sysfs_files(mdev);
 	device_del(&mdev->dev);
 	lockdep_assert_held(&parent->unreg_sem);
-	ret = parent->ops->remove(mdev);
-	if (ret)
-		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
+	if (parent->ops->remove) {
+		ret = parent->ops->remove(mdev);
+		if (ret)
+			dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
+	}
 
 	/* Balances with device_initialize() */
 	put_device(&mdev->dev);
@@ -127,7 +129,9 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	char *envp[] = { env_string, NULL };
 
 	/* check for mandatory ops */
-	if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups)
+	if (!ops || !ops->supported_type_groups)
+		return -EINVAL;
+	if (!ops->device_driver && (!ops->create || !ops->remove))
 		return -EINVAL;
 
 	dev = get_device(dev);
@@ -256,6 +260,7 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 	int ret;
 	struct mdev_device *mdev, *tmp;
 	struct mdev_parent *parent = type->parent;
+	struct mdev_driver *drv = parent->ops->device_driver;
 
 	mutex_lock(&mdev_list_lock);
 
@@ -296,14 +301,22 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 		goto out_put_device;
 	}
 
-	ret = parent->ops->create(mdev);
-	if (ret)
-		goto out_unlock;
+	if (parent->ops->create) {
+		ret = parent->ops->create(mdev);
+		if (ret)
+			goto out_unlock;
+	}
 
 	ret = device_add(&mdev->dev);
 	if (ret)
 		goto out_remove;
 
+	if (!drv)
+		drv = &vfio_mdev_driver;
+	ret = device_driver_attach(&drv->driver, &mdev->dev);
+	if (ret)
+		goto out_del;
+
 	ret = mdev_create_sysfs_files(mdev);
 	if (ret)
 		goto out_del;
@@ -317,7 +330,8 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 out_del:
 	device_del(&mdev->dev);
 out_remove:
-	parent->ops->remove(mdev);
+	if (parent->ops->remove)
+		parent->ops->remove(mdev);
 out_unlock:
 	up_read(&parent->unreg_sem);
 out_put_device:
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 041699571b7e..c368ec824e2b 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -71,10 +71,20 @@ static int mdev_remove(struct device *dev)
 	return 0;
 }
 
+static int mdev_match(struct device *dev, struct device_driver *drv)
+{
+	/*
+	 * No drivers automatically match. Drivers are only bound by explicit
+	 * device_driver_attach()
+	 */
+	return 0;
+}
+
 struct bus_type mdev_bus_type = {
 	.name		= "mdev",
 	.probe		= mdev_probe,
 	.remove		= mdev_remove,
+	.match		= mdev_match,
 };
 EXPORT_SYMBOL_GPL(mdev_bus_type);
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 1fb34ea394ad..3a38598c2605 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -55,6 +55,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
  * register the device to mdev module.
  *
  * @owner:		The module owner.
+ * @device_driver:	Which device driver to probe() on newly created devices
  * @dev_attr_groups:	Attributes of the parent device.
  * @mdev_attr_groups:	Attributes of the mediated device.
  * @supported_type_groups: Attributes to define supported types. It is mandatory
@@ -103,6 +104,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
  **/
 struct mdev_parent_ops {
 	struct module   *owner;
+	struct mdev_driver *device_driver;
 	const struct attribute_group **dev_attr_groups;
 	const struct attribute_group **mdev_attr_groups;
 	struct attribute_group **supported_type_groups;
-- 
2.30.2

