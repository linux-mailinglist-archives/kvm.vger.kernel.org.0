Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5AC3AB5EE
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 16:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhFQO2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 10:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhFQO2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 10:28:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A64C061574;
        Thu, 17 Jun 2021 07:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BdElzP13DjvqjM7IlDdOM/qR69AkSxFHfsD86w8dyEk=; b=JhM10Tcg+K7GHysQsOTKk5lDvb
        BWlbKCaHNJ/sIMS5RxMW0X+stSJeekJiHXs2fF6XJdRZgx46m5+Oc0AX9ZkVeRieiLAjLNHmXe8dt
        Psn88ebnFe4vlZSYKqK67Po8sg4Gpwaf1bw/IUAAPtlkrRQgAr8wjgQ3mwVap4w/pZltB6JQ7QLWI
        bSQvYpzvIXXy8RkvR5tfEA/jEKAB0sNsR/thE5EMARlFeSKP5kIdIim8XKsx9Lb8CaqxQzdzRYy55
        DR1cp0pOIoBNUB2aw4XfWwBWcm+SuIc3MajCkJ3zTpFg5pItL0XRG3k2IaYKthlCTOALSN3ZNFkys
        Zf/qTWzw==;
Received: from [2001:4bb8:19b:fdce:dccf:26cc:e207:71f6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltsx5-009DkA-Cg; Thu, 17 Jun 2021 14:25:09 +0000
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
Date:   Thu, 17 Jun 2021 16:22:15 +0200
Message-Id: <20210617142218.1877096-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210617142218.1877096-1-hch@lst.de>
References: <20210617142218.1877096-1-hch@lst.de>
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
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       | 35 +++++++------------
 drivers/vfio/mdev/mdev_core.c                 | 30 +++++++++++-----
 drivers/vfio/mdev/mdev_driver.c               | 10 ++++++
 include/linux/mdev.h                          |  2 ++
 4 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 1779b85f014e..9f26079cacae 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -93,7 +93,7 @@ interfaces:
 Registration Interface for a Mediated Bus Driver
 ------------------------------------------------
 
-The registration interface for a mediated bus driver provides the following
+The registration interface for a mediated device driver provides the following
 structure to represent a mediated device's driver::
 
      /*
@@ -136,37 +136,26 @@ The structures in the mdev_parent_ops structure are as follows:
 * dev_attr_groups: attributes of the parent device
 * mdev_attr_groups: attributes of the mediated device
 * supported_config: attributes to define supported configurations
+* device_driver: device driver to bind for mediated device instances
 
-The functions in the mdev_parent_ops structure are as follows:
+The mdev_parent_ops also still has various functions pointers.  Theses exist
+for historical reasons only and shall not be used for new drivers.
 
-* create: allocate basic resources in a driver for a mediated device
-* remove: free resources in a driver when a mediated device is destroyed
-
-(Note that mdev-core provides no implicit serialization of create/remove
-callbacks per mdev parent device, per mdev type, or any other categorization.
-Vendor drivers are expected to be fully asynchronous in this respect or
-provide their own internal resource protection.)
-
-The callbacks in the mdev_parent_ops structure are as follows:
-
-* open: open callback of mediated device
-* close: close callback of mediated device
-* ioctl: ioctl callback of mediated device
-* read : read emulation callback
-* write: write emulation callback
-* mmap: mmap emulation callback
-
-A driver should use the mdev_parent_ops structure in the function call to
-register itself with the mdev core driver::
+When a driver wants to add the GUID creation sysfs to an existing device it has
+probe'd to then it should call::
 
 	extern int  mdev_register_device(struct device *dev,
 	                                 const struct mdev_parent_ops *ops);
 
-However, the mdev_parent_ops structure is not required in the function call
-that a driver should use to unregister itself with the mdev core driver::
+This will provide the 'mdev_supported_types/XX/create' files which can then be
+used to trigger the creation of a mdev_device. The created mdev_device will be
+attached to the specified driver.
+
+When the driver needs to remove itself it calls::
 
 	extern void mdev_unregister_device(struct device *dev);
 
+Which will unbind and destroy all the created mdevs and remove the sysfs files.
 
 Mediated Device Management Interface Through sysfs
 ==================================================
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

