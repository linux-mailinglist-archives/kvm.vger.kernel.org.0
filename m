Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE99158C94
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgBKKVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:21:18 -0500
Received: from mga12.intel.com ([192.55.52.136]:55839 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbgBKKVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 05:21:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 02:21:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="221888389"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 02:21:15 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v3 3/9] vfio/pci: register/unregister vfio_pci_vendor_driver_ops
Date:   Tue, 11 Feb 2020 05:11:55 -0500
Message-Id: <20200211101155.20894-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211095727.20426-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
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
 drivers/vfio/pci/vfio_pci.c         | 105 +++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |   6 ++
 include/linux/vfio.h                |  11 +++
 3 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 02297bd3f6c2..e5bfb4948667 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -62,6 +62,10 @@ static inline bool vfio_vga_disabled(void)
 	return true;
 #endif
 }
+static struct vfio_pci {
+	struct  mutex		vendor_drivers_lock;
+	struct  list_head	vendor_drivers_list;
+} vfio_pci;
 
 /*
  * Our VGA arbiter participation is limited since we don't know anything
@@ -1310,6 +1314,37 @@ static const struct vfio_device_ops vfio_pci_ops = {
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
 
+static int probe_vendor_drivers(struct vfio_pci_device *vdev)
+{
+	struct vfio_pci_device_private *priv = container_of(vdev,
+				struct vfio_pci_device_private, vdev);
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
+		priv->vendor_driver = driver;
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
 	struct vfio_pci_device_private *priv;
@@ -1349,7 +1384,13 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&priv->ioeventfds_lock);
 	INIT_LIST_HEAD(&priv->ioeventfds_list);
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, &priv->vdev);
+	if (probe_vendor_drivers(&priv->vdev))
+		ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops,
+					 &priv->vdev);
+	else
+		ret = vfio_add_group_dev(&pdev->dev,
+					 priv->vendor_driver->ops->device_ops,
+					 &priv->vdev);
 	if (ret) {
 		vfio_iommu_group_put(group, &pdev->dev);
 		kfree(priv);
@@ -1387,6 +1428,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(&priv->vdev, PCI_D3hot);
 	}
 
+
 	return ret;
 }
 
@@ -1410,6 +1452,11 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
+	if (priv->vendor_driver) {
+		priv->vendor_driver->ops->remove(vdev->vendor_data);
+		module_put(priv->vendor_driver->ops->owner);
+	}
+
 	kfree(priv->pm_save);
 	kfree(priv);
 
@@ -1725,6 +1772,8 @@ static int __init vfio_pci_init(void)
 
 	vfio_pci_fill_ids();
 
+	mutex_init(&vfio_pci.vendor_drivers_lock);
+	INIT_LIST_HEAD(&vfio_pci.vendor_drivers_list);
 	return 0;
 
 out_driver:
@@ -1732,6 +1781,60 @@ static int __init vfio_pci_init(void)
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
index df665fa8be52..a5bc53e2d849 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -84,6 +84,11 @@ struct vfio_pci_reflck {
 	struct mutex		lock;
 };
 
+struct vfio_pci_vendor_driver {
+	const struct vfio_pci_vendor_driver_ops *ops;
+	struct list_head			next;
+};
+
 struct vfio_pci_device_private {
 	struct vfio_pci_device	vdev;
 	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
@@ -120,6 +125,7 @@ struct vfio_pci_device_private {
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
+	struct vfio_pci_vendor_driver	*vendor_driver;
 };
 #define VDEV_TO_PRIV(p) container_of((p), struct vfio_pci_device_private, vdev)
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 64714cbd02f9..43b2222da2bf 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -195,10 +195,21 @@ extern int vfio_virqfd_enable(void *opaque,
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
+
 struct vfio_pci_device {
 	struct pci_dev			*pdev;
 	int				num_regions;
 	int				irq_type;
+	void				*vendor_data;
 };
 
 extern long vfio_pci_ioctl(void *device_data,
-- 
2.17.1

