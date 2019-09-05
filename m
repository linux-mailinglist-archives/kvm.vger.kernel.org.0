Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AF0AB3E6
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392625AbfIFIRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:17:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:23720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392615AbfIFIRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:17:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 01:17:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,472,1559545200"; 
   d="scan'208";a="383186201"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Sep 2019 01:17:46 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yan.y.zhao@intel.com, shaopeng.he@intel.com,
        chenbo.xia@intel.com, jun.j.tian@intel.com
Subject: [PATCH v2 10/13] samples: refine vfio-mdev-pci driver
Date:   Thu,  5 Sep 2019 15:59:27 +0800
Message-Id: <1567670370-4484-11-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

This patch refines the implementation of original vfio-mdev-pci driver.

And the vfio-mdev-pci-type_name will be named per the following rule:

	vmdev->attr.name = kasprintf(GFP_KERNEL,
				     "%04x:%04x:%04x:%04x:%06x:%02x",
				     pdev->vendor, pdev->device,
				     pdev->subsystem_vendor,
				     pdev->subsystem_device, pdev->class,
				     pdev->revision);

Before usage, check the /sys/bus/pci/devices/$bdf/mdev_supported_types/
to ensure the final mdev_supported_types.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_mdev_pci.c | 123 +++++++++++++++++++++++----------------
 1 file changed, 72 insertions(+), 51 deletions(-)

diff --git a/drivers/vfio/pci/vfio_mdev_pci.c b/drivers/vfio/pci/vfio_mdev_pci.c
index 07c8067..09143d3 100644
--- a/drivers/vfio/pci/vfio_mdev_pci.c
+++ b/drivers/vfio/pci/vfio_mdev_pci.c
@@ -65,18 +65,22 @@ MODULE_PARM_DESC(disable_idle_d3,
 
 static struct pci_driver vfio_mdev_pci_driver;
 
-static ssize_t
-name_show(struct kobject *kobj, struct device *dev, char *buf)
-{
-	return sprintf(buf, "%s-type1\n", dev_name(dev));
-}
-
-MDEV_TYPE_ATTR_RO(name);
+struct vfio_mdev_pci_device {
+	struct vfio_pci_device vdev;
+	struct mdev_parent_ops ops;
+	struct attribute_group *groups[2];
+	struct attribute_group attr;
+	atomic_t avail;
+};
 
 static ssize_t
 available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
 {
-	return sprintf(buf, "%d\n", 1);
+	struct vfio_mdev_pci_device *vmdev;
+
+	vmdev = pci_get_drvdata(to_pci_dev(dev));
+
+	return sprintf(buf, "%d\n", atomic_read(&vmdev->avail));
 }
 
 MDEV_TYPE_ATTR_RO(available_instances);
@@ -90,62 +94,57 @@ static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
 MDEV_TYPE_ATTR_RO(device_api);
 
 static struct attribute *vfio_mdev_pci_types_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
 
-static struct attribute_group vfio_mdev_pci_type_group1 = {
-	.name  = "type1",
-	.attrs = vfio_mdev_pci_types_attrs,
-};
-
-struct attribute_group *vfio_mdev_pci_type_groups[] = {
-	&vfio_mdev_pci_type_group1,
-	NULL,
-};
-
 struct vfio_mdev_pci {
 	struct vfio_pci_device *vdev;
 	struct mdev_device *mdev;
-	unsigned long handle;
 };
 
 static int vfio_mdev_pci_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct device *pdev;
-	struct vfio_pci_device *vdev;
+	struct vfio_mdev_pci_device *vmdev;
 	struct vfio_mdev_pci *pmdev;
 	int ret;
 
 	pdev = mdev_parent_dev(mdev);
-	vdev = dev_get_drvdata(pdev);
+	vmdev = dev_get_drvdata(pdev);
+
+	if (atomic_dec_if_positive(&vmdev->avail) < 0)
+		return -ENOSPC;
+
 	pmdev = kzalloc(sizeof(struct vfio_mdev_pci), GFP_KERNEL);
-	if (pmdev == NULL) {
-		ret = -EBUSY;
-		goto out;
-	}
+	if (!pmdev)
+		return -ENOMEM;
 
 	pmdev->mdev = mdev;
-	pmdev->vdev = vdev;
+	pmdev->vdev = &vmdev->vdev;
 	mdev_set_drvdata(mdev, pmdev);
 	ret = mdev_set_iommu_device(mdev_dev(mdev), pdev);
 	if (ret) {
 		pr_info("%s, failed to config iommu isolation for mdev: %s on pf: %s\n",
 			__func__, dev_name(mdev_dev(mdev)), dev_name(pdev));
-		goto out;
+		kfree(pmdev);
+		atomic_inc(&vmdev->avail);
+		return ret;
 	}
 
-out:
-	return ret;
+	return 0;
 }
 
 static int vfio_mdev_pci_remove(struct mdev_device *mdev)
 {
 	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+	struct vfio_mdev_pci_device *vmdev;
+
+	vmdev = container_of(pmdev->vdev, struct vfio_mdev_pci_device, vdev);
 
 	kfree(pmdev);
+	atomic_inc(&vmdev->avail);
 	pr_info("%s, succeeded for mdev: %s\n", __func__,
 		     dev_name(mdev_dev(mdev)));
 
@@ -237,24 +236,12 @@ static ssize_t vfio_mdev_pci_write(struct mdev_device *mdev,
 	return vfio_pci_write(pmdev->vdev, (char __user *)buf, count, ppos);
 }
 
-static const struct mdev_parent_ops vfio_mdev_pci_ops = {
-	.supported_type_groups	= vfio_mdev_pci_type_groups,
-	.create			= vfio_mdev_pci_create,
-	.remove			= vfio_mdev_pci_remove,
-
-	.open			= vfio_mdev_pci_open,
-	.release		= vfio_mdev_pci_release,
-
-	.read			= vfio_mdev_pci_read,
-	.write			= vfio_mdev_pci_write,
-	.mmap			= vfio_mdev_pci_mmap,
-	.ioctl			= vfio_mdev_pci_ioctl,
-};
-
 static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
 				       const struct pci_device_id *id)
 {
+	struct vfio_mdev_pci_device *vmdev;
 	struct vfio_pci_device *vdev;
+	const struct mdev_parent_ops *ops;
 	int ret;
 
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
@@ -273,10 +260,38 @@ static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
 		return -EBUSY;
 	}
 
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev)
+	vmdev = kzalloc(sizeof(*vmdev), GFP_KERNEL);
+	if (!vmdev)
 		return -ENOMEM;
 
+	vmdev->attr.name = kasprintf(GFP_KERNEL,
+				     "%04x:%04x:%04x:%04x:%06x:%02x",
+				     pdev->vendor, pdev->device,
+				     pdev->subsystem_vendor,
+				     pdev->subsystem_device, pdev->class,
+				     pdev->revision);
+	if (!vmdev->attr.name) {
+		kfree(vmdev);
+		return -ENOMEM;
+	}
+
+	atomic_set(&vmdev->avail, 1);
+
+	vmdev->attr.attrs = vfio_mdev_pci_types_attrs;
+	vmdev->groups[0] = &vmdev->attr;
+
+	vmdev->ops.supported_type_groups = vmdev->groups;
+	vmdev->ops.create = vfio_mdev_pci_create;
+	vmdev->ops.remove = vfio_mdev_pci_remove;
+	vmdev->ops.open	= vfio_mdev_pci_open;
+	vmdev->ops.release = vfio_mdev_pci_release;
+	vmdev->ops.read = vfio_mdev_pci_read;
+	vmdev->ops.write = vfio_mdev_pci_write;
+	vmdev->ops.mmap = vfio_mdev_pci_mmap;
+	vmdev->ops.ioctl = vfio_mdev_pci_ioctl;
+	ops = &vmdev->ops;
+
+	vdev = &vmdev->vdev;
 	vdev->pdev = pdev;
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
@@ -289,7 +304,7 @@ static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
 #endif
 	vdev->disable_idle_d3 = disable_idle_d3;
 
-	pci_set_drvdata(pdev, vdev);
+	pci_set_drvdata(pdev, vmdev);
 
 	ret = vfio_pci_reflck_attach(vdev);
 	if (ret) {
@@ -320,7 +335,7 @@ static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
-	ret = mdev_register_device(&pdev->dev, &vfio_mdev_pci_ops);
+	ret = mdev_register_device(&pdev->dev, ops);
 	if (ret)
 		pr_err("Cannot register mdev for device %s\n",
 			dev_name(&pdev->dev));
@@ -332,12 +347,17 @@ static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
 
 static void vfio_mdev_pci_driver_remove(struct pci_dev *pdev)
 {
+	struct vfio_mdev_pci_device *vmdev;
 	struct vfio_pci_device *vdev;
 
-	vdev = pci_get_drvdata(pdev);
-	if (!vdev)
+	mdev_unregister_device(&pdev->dev);
+
+	vmdev = pci_get_drvdata(pdev);
+	if (!vmdev)
 		return;
 
+	vdev = &vmdev->vdev;
+
 	vfio_pci_reflck_put(vdev->reflck);
 
 	kfree(vdev->region);
@@ -355,7 +375,8 @@ static void vfio_mdev_pci_driver_remove(struct pci_dev *pdev)
 				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
 	}
 
-	kfree(vdev);
+	kfree(vmdev->attr.name);
+	kfree(vmdev);
 }
 
 static struct pci_driver vfio_mdev_pci_driver = {
-- 
2.7.4

