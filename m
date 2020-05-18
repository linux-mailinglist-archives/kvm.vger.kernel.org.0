Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0D1D6F22
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 04:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgERCxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 22:53:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:38912 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbgERCxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 22:53:43 -0400
IronPort-SDR: v0031KGH8sPzZNW36l48JiqLD/Ypcles9iwOm9NYyPTbJvPwu16AgLt8YEuwUX9YhZBGwVDpLz
 hI4jkWd3plUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 19:53:42 -0700
IronPort-SDR: ajl1mKmNYUq8JZW6h0P0xcT210nfq6Cn+lB1ky8e0KlSTGHH5i3gnWv1CM7K3UqhXBHZhDBz1b
 Aw4BnjPfMmdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="411103805"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2020 19:53:39 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v4 01/10] vfio/pci: register/unregister vfio_pci_vendor_driver_ops
Date:   Sun, 17 May 2020 22:43:17 -0400
Message-Id: <20200518024317.14055-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200518024202.13996-1-yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pci_vendor_driver_ops includes two parts:
(1) .probe() and .remove() interface to be called by vfio_pci_probe()
and vfio_pci_remove().
(2) pointer to struct vfio_device_ops. It will be registered as ops of vfio
device if .probe() succeeds.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 102 +++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |   7 ++
 include/linux/vfio.h                |   9 +++
 3 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6c6b37b5c04e..43d10d34cbc2 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -68,6 +68,11 @@ static inline bool vfio_vga_disabled(void)
 #endif
 }
 
+static struct vfio_pci {
+	struct  mutex		vendor_drivers_lock;
+	struct  list_head	vendor_drivers_list;
+} vfio_pci;
+
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -1570,6 +1575,35 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 	return 0;
 }
 
+static int probe_vendor_drivers(struct vfio_pci_device *vdev)
+{
+	struct vfio_pci_vendor_driver *driver;
+	int ret = -ENODEV;
+
+	request_module("vfio-pci:%x-%x", vdev->pdev->vendor,
+					 vdev->pdev->device);
+
+	mutex_lock(&vfio_pci.vendor_drivers_lock);
+	list_for_each_entry(driver, &vfio_pci.vendor_drivers_list, next) {
+		void *data;
+
+		if (!try_module_get(driver->ops->owner))
+			continue;
+
+		data = driver->ops->probe(vdev->pdev);
+		if (IS_ERR(data)) {
+			module_put(driver->ops->owner);
+			continue;
+		}
+		vdev->vendor_driver = driver;
+		vdev->vendor_data = data;
+		ret = 0;
+		break;
+	}
+	mutex_unlock(&vfio_pci.vendor_drivers_lock);
+	return ret;
+}
+
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct vfio_pci_device *vdev;
@@ -1609,7 +1643,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	if (probe_vendor_drivers(vdev))
+		ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	else
+		ret = vfio_add_group_dev(&pdev->dev,
+					 vdev->vendor_driver->ops->device_ops,
+					 vdev);
 	if (ret)
 		goto out_free;
 
@@ -1698,6 +1737,11 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
+	if (vdev->vendor_driver) {
+		vdev->vendor_driver->ops->remove(vdev->vendor_data);
+		module_put(vdev->vendor_driver->ops->owner);
+	}
+
 	kfree(vdev->pm_save);
 	kfree(vdev);
 
@@ -2035,6 +2079,8 @@ static int __init vfio_pci_init(void)
 
 	vfio_pci_fill_ids();
 
+	mutex_init(&vfio_pci.vendor_drivers_lock);
+	INIT_LIST_HEAD(&vfio_pci.vendor_drivers_list);
 	return 0;
 
 out_driver:
@@ -2042,6 +2088,60 @@ static int __init vfio_pci_init(void)
 	return ret;
 }
 
+int __vfio_pci_register_vendor_driver(struct vfio_pci_vendor_driver_ops *ops)
+{
+	struct vfio_pci_vendor_driver *driver, *tmp;
+
+	if (!ops || !ops->device_ops)
+		return -EINVAL;
+
+	driver = kzalloc(sizeof(*driver), GFP_KERNEL);
+	if (!driver)
+		return -ENOMEM;
+
+	driver->ops = ops;
+
+	mutex_lock(&vfio_pci.vendor_drivers_lock);
+
+	/* Check for duplicates */
+	list_for_each_entry(tmp, &vfio_pci.vendor_drivers_list, next) {
+		if (tmp->ops->device_ops == ops->device_ops) {
+			mutex_unlock(&vfio_pci.vendor_drivers_lock);
+			kfree(driver);
+			return -EINVAL;
+		}
+	}
+
+	list_add(&driver->next, &vfio_pci.vendor_drivers_list);
+
+	mutex_unlock(&vfio_pci.vendor_drivers_lock);
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__vfio_pci_register_vendor_driver);
+
+void vfio_pci_unregister_vendor_driver(struct vfio_device_ops *device_ops)
+{
+	struct vfio_pci_vendor_driver *driver, *tmp;
+
+	mutex_lock(&vfio_pci.vendor_drivers_lock);
+	list_for_each_entry_safe(driver, tmp,
+				 &vfio_pci.vendor_drivers_list, next) {
+		if (driver->ops->device_ops == device_ops) {
+			list_del(&driver->next);
+			mutex_unlock(&vfio_pci.vendor_drivers_lock);
+			kfree(driver);
+			module_put(THIS_MODULE);
+			return;
+		}
+	}
+	mutex_unlock(&vfio_pci.vendor_drivers_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_unregister_vendor_driver);
+
 module_init(vfio_pci_init);
 module_exit(vfio_pci_cleanup);
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 36ec69081ecd..7758a20546fa 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -92,6 +92,11 @@ struct vfio_pci_vf_token {
 	int			users;
 };
 
+struct vfio_pci_vendor_driver {
+	const struct vfio_pci_vendor_driver_ops *ops;
+	struct list_head			next;
+};
+
 struct vfio_pci_device {
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
@@ -132,6 +137,8 @@ struct vfio_pci_device {
 	struct list_head	ioeventfds_list;
 	struct vfio_pci_vf_token	*vf_token;
 	struct notifier_block	nb;
+	void			*vendor_data;
+	struct vfio_pci_vendor_driver	*vendor_driver;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 38d3c6a8dc7e..3e53deb012b6 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -214,4 +214,13 @@ extern int vfio_virqfd_enable(void *opaque,
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+struct vfio_pci_vendor_driver_ops {
+	char			*name;
+	struct module		*owner;
+	void			*(*probe)(struct pci_dev *pdev);
+	void			(*remove)(void *vendor_data);
+	struct vfio_device_ops *device_ops;
+};
+int __vfio_pci_register_vendor_driver(struct vfio_pci_vendor_driver_ops *ops);
+void vfio_pci_unregister_vendor_driver(struct vfio_device_ops *device_ops);
 #endif /* VFIO_H */
-- 
2.17.1

