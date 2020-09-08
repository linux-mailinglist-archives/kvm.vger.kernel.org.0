Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A96260BB4
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgIHHSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:18:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:30573 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbgIHHSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:18:02 -0400
IronPort-SDR: RV9utV7ksloTlCOhj9ft8L0rDC/J2HXyziceEBZM6Jkxsu3HNdTJRoTXIrOi4SemC2O/cYYhzm
 xaQgmZxtwasA==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="159058737"
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="159058737"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 00:18:01 -0700
IronPort-SDR: 16kxSz8FcibQjPAMjNL4fMfj/Uu0qMWU1yqlgh+aBu3zVs17c5oJ3mqCj+w2OBdwPmPu9UnxmK
 aM6CJrdBkFIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="448677709"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by orsmga004.jf.intel.com with ESMTP; 08 Sep 2020 00:17:59 -0700
From:   Xu Yilun <yilun.xu@intel.com>
To:     mdf@kernel.org, alex.williamson@redhat.com, kwankhede@nvidia.com,
        linux-fpga@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     trix@redhat.com, lgoncalv@redhat.com, yilun.xu@intel.com
Subject: [PATCH 1/3] fpga: dfl: add driver_override support
Date:   Tue,  8 Sep 2020 15:13:30 +0800
Message-Id: <1599549212-24253-2-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
References: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for overriding the default matching of a dfl device to a dfl
driver. It follows the same way that can be used for PCI and platform
devices. This patch adds the 'driver_override' sysfs file. It can be
used by VFIO to bind dfl devices for user accessing.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-dfl | 20 ++++++++++++
 drivers/fpga/dfl.c                      | 54 ++++++++++++++++++++++++++++++++-
 include/linux/fpga/dfl-bus.h            |  2 ++
 3 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dfl b/Documentation/ABI/testing/sysfs-bus-dfl
index 23543be..cf1357a 100644
--- a/Documentation/ABI/testing/sysfs-bus-dfl
+++ b/Documentation/ABI/testing/sysfs-bus-dfl
@@ -13,3 +13,23 @@ Contact:	Xu Yilun <yilun.xu@intel.com>
 Description:	Read-only. It returns feature identifier local to its DFL FIU
 		type.
 		Format: 0x%x
+
+What:		/sys/bus/dfl/devices/.../driver_override
+Date:		Sep 2020
+KernelVersion:	5.10
+Contact:	Xu Yilun <yilun.xu@intel.com>
+Description:	This file allows the driver for a device to be specified. When
+		specified, only a driver with a name matching the value written
+		to driver_override will have an opportunity to bind to the
+		device. The override is specified by writing a string to the
+		driver_override file (echo vfio-mdev-dfl > driver_override) and
+		may be cleared with an empty string (echo > driver_override).
+		This returns the device to standard matching rules binding.
+		Writing to driver_override does not automatically unbind the
+		device from its current driver or make any attempt to
+		automatically load the specified driver.  If no driver with a
+		matching name is currently loaded in the kernel, the device
+		will not bind to any driver.  This also allows devices to
+		opt-out of driver binding using a driver_override name such as
+		"none".  Only a single driver may be specified in the override,
+		there is no support for parsing delimiters.
diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index 02a6780..98f88ee 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -262,6 +262,10 @@ static int dfl_bus_match(struct device *dev, struct device_driver *drv)
 	struct dfl_driver *ddrv = to_dfl_drv(drv);
 	const struct dfl_device_id *id_entry;
 
+	/* When driver_override is set, only bind to the matching driver */
+	if (ddev->driver_override)
+		return !strcmp(ddev->driver_override, drv->name);
+
 	id_entry = ddrv->id_table;
 	if (id_entry) {
 		while (id_entry->feature_id) {
@@ -304,6 +308,53 @@ static int dfl_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 			      ddev->type, ddev->feature_id);
 }
 
+static ssize_t driver_override_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct dfl_device *ddev = to_dfl_dev(dev);
+	ssize_t len;
+
+	device_lock(dev);
+	len = sprintf(buf, "%s\n", ddev->driver_override);
+	device_unlock(dev);
+	return len;
+}
+
+static ssize_t driver_override_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct dfl_device *ddev = to_dfl_dev(dev);
+	char *driver_override, *old, *cp;
+
+	/* We need to keep extra room for a newline */
+	if (count >= (PAGE_SIZE - 1))
+		return -EINVAL;
+
+	driver_override = kstrndup(buf, count, GFP_KERNEL);
+	if (!driver_override)
+		return -ENOMEM;
+
+	cp = strchr(driver_override, '\n');
+	if (cp)
+		*cp = '\0';
+
+	device_lock(dev);
+	old = ddev->driver_override;
+	if (strlen(driver_override)) {
+		ddev->driver_override = driver_override;
+	} else {
+		kfree(driver_override);
+		ddev->driver_override = NULL;
+	}
+	device_unlock(dev);
+
+	kfree(old);
+
+	return count;
+}
+static DEVICE_ATTR_RW(driver_override);
+
 static ssize_t
 type_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -325,6 +376,7 @@ static DEVICE_ATTR_RO(feature_id);
 static struct attribute *dfl_dev_attrs[] = {
 	&dev_attr_type.attr,
 	&dev_attr_feature_id.attr,
+	&dev_attr_driver_override.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(dfl_dev);
@@ -470,7 +522,7 @@ static int dfl_devs_add(struct dfl_feature_platform_data *pdata)
 
 int __dfl_driver_register(struct dfl_driver *dfl_drv, struct module *owner)
 {
-	if (!dfl_drv || !dfl_drv->probe || !dfl_drv->id_table)
+	if (!dfl_drv || !dfl_drv->probe)
 		return -EINVAL;
 
 	dfl_drv->drv.owner = owner;
diff --git a/include/linux/fpga/dfl-bus.h b/include/linux/fpga/dfl-bus.h
index 2a2b283..09a9ee1 100644
--- a/include/linux/fpga/dfl-bus.h
+++ b/include/linux/fpga/dfl-bus.h
@@ -43,6 +43,8 @@ struct dfl_device {
 	unsigned int num_irqs;
 	struct dfl_fpga_cdev *cdev;
 	const struct dfl_device_id *id_entry;
+
+	char *driver_override;
 };
 
 /**
-- 
2.7.4

