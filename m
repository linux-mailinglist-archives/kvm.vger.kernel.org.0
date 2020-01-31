Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06BDE14E70E
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 03:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgAaCUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 21:20:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:24318 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgAaCUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 21:20:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 18:20:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="262395513"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2020 18:20:31 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 3/9] vfio/pci: register/unregister vfio_pci_vendor_driver_ops
Date:   Thu, 30 Jan 2020 21:11:11 -0500
Message-Id: <20200131021111.27722-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131020803.27519-1-yan.y.zhao@intel.com>
References: <20200131020803.27519-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pci_vendor_driver_ops includes two parts:
(1) .probe() and .remove() interfaces to be called by vfio_pci_probe()
and vfio_pci_remove().
(2) pointer to struct vfio_device_ops. It will be registered as vfio
device ops if .probe() succeeds.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 102 +++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |   6 ++
 include/linux/vfio.h                |  13 ++++
 3 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f72c6d80d0e9..1a08b7cc9246 100644
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
@@ -1301,6 +1305,36 @@ static const struct vfio_device_ops vfio_pci_ops = {
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
 
+static int probe_vendor_drivers(struct vfio_pci_device *vdev)
+{
+
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
@@ -1346,7 +1380,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&vdev->priv->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->priv->ioeventfds_list);
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	if (probe_vendor_drivers(vdev))
+		ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	else
+		ret = vfio_add_group_dev(&pdev->dev,
+				vdev->vendor_driver->ops->device_ops, vdev);
 	if (ret) {
 		vfio_iommu_group_put(group, &pdev->dev);
 		kfree(vdev);
@@ -1383,6 +1421,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
+
 	return ret;
 }
 
@@ -1403,6 +1442,11 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
+	if (vdev->vendor_driver) {
+		vdev->vendor_driver->ops->remove(vdev->vendor_data);
+		module_put(vdev->vendor_driver->ops->owner);
+	}
+
 	kfree(vdev->priv->pm_save);
 	kfree(vdev);
 
@@ -1708,6 +1752,8 @@ static int __init vfio_pci_init(void)
 
 	vfio_pci_fill_ids();
 
+	mutex_init(&vfio_pci.vendor_drivers_lock);
+	INIT_LIST_HEAD(&vfio_pci.vendor_drivers_list);
 	return 0;
 
 out_driver:
@@ -1715,6 +1761,60 @@ static int __init vfio_pci_init(void)
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
index 4e0d1a38fe30..32013bb69ec4 100644
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
 	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
 	bool			bar_mmap_supported[PCI_STD_RESOURCE_END + 1];
@@ -119,6 +124,7 @@ struct vfio_pci_device_private {
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
+
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 291e25b4d850..69519cf1fd4f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -195,12 +195,25 @@ extern int vfio_virqfd_enable(void *opaque,
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+
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
 struct vfio_pci_device_private;
 struct vfio_pci_device {
 	struct pci_dev			*pdev;
 	int				num_regions;
 	int				irq_type;
 	struct vfio_pci_device_private *priv;
+	struct vfio_pci_vendor_driver	*vendor_driver;
+	void				*vendor_data;
 };
 
 extern long vfio_pci_ioctl(void *device_data,
-- 
2.17.1

