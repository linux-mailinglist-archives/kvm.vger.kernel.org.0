Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50AA4C644
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 06:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfFTE0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 00:26:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfFTE0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 00:26:51 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C822C05D3F4;
        Thu, 20 Jun 2019 04:26:49 +0000 (UTC)
Received: from x1.home (ovpn-116-32.phx2.redhat.com [10.3.116.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 676B360FAB;
        Thu, 20 Jun 2019 04:26:48 +0000 (UTC)
Date:   Wed, 19 Jun 2019 22:26:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, yi.y.sun@intel.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Message-ID: <20190619222647.72efc76a@x1.home>
In-Reply-To: <1560000071-3543-10-git-send-email-yi.l.liu@intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
        <1560000071-3543-10-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 20 Jun 2019 04:26:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  8 Jun 2019 21:21:11 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch adds sample driver named vfio-mdev-pci. It is to wrap
> a PCI device as a mediated device. For a pci device, once bound
> to vfio-mdev-pci driver, user space access of this device will
> go through vfio mdev framework. The usage of the device follows
> mdev management method. e.g. user should create a mdev before
> exposing the device to user-space.
> 
> Benefit of this new driver would be acting as a sample driver
> for recent changes from "vfio/mdev: IOMMU aware mediated device"
> patchset. Also it could be a good experiment driver for future
> device specific mdev migration support.
> 
> To use this driver:
> a) build and load vfio-mdev-pci.ko module
>    execute "make menuconfig" and config CONFIG_SAMPLE_VFIO_MDEV_PCI
>    then load it with following command
>    > sudo modprobe vfio
>    > sudo modprobe vfio-pci
>    > sudo insmod drivers/vfio/pci/vfio-mdev-pci.ko  
> 
> b) unbind original device driver
>    e.g. use following command to unbind its original driver
>    > echo $dev_bdf > /sys/bus/pci/devices/$dev_bdf/driver/unbind  
> 
> c) bind vfio-mdev-pci driver to the physical device
>    > echo $vend_id $dev_id > /sys/bus/pci/drivers/vfio-mdev-pci/new_id  
> 
> d) check the supported mdev instances
>    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/  
>      vfio-mdev-pci-type1
>    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\  
>      vfio-mdev-pci-type1/
>      available_instances  create  device_api  devices  name


I think the static type name here is a problem (and why does it
include "type1"?).  We generally consider that a type defines a
software compatible mdev, but in this case any PCI device wrapped in
vfio-mdev-pci gets the same mdev type.  This is only a sample driver,
but that's a bad precedent.  I've taken a stab at fixing this in the
patch below, using the PCI vendor ID, device ID, subsystem vendor ID,
subsystem device ID, class code, and revision to try to make the type
as specific to the physical device assigned as we can through PCI.

> 
> e)  create mdev on this physical device (only 1 instance)
>    > echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1003" > \  
>      /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\
>      vfio-mdev-pci-type1/create

Whoops, available_instances always reports 1 and it doesn't appear that
the create function prevents additional mdevs.  Also addressed in the
patch below.
 
> f) passthru the mdev to guest
>    add the following line in Qemu boot command
>    -device vfio-pci,\
>     sysfsdev=/sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003
> 
> g) destroy mdev
>    > echo 1 > /sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003/\  
>      remove
> 

I also found that unbinding the parent device doesn't unregister with
mdev, so it cannot be bound again, also fixed below.

However, the patch below just makes the mdev interface behave
correctly, I can't make it work on my system because commit
7bd50f0cd2fd ("vfio/type1: Add domain at(de)taching group helpers")
used iommu_attach_device() rather than iommu_attach_group() for non-aux
mdev iommu_device.  Is there a requirement that the mdev parent device
is in a singleton iommu group?  If this is a simplification, then
vfio-mdev-pci should not bind to devices where this is violated since
there's no way to use the device.  Can we support it though?

If I have two devices in the same group and bind them both to
vfio-mdev-pci, I end up with three groups, one for each mdev device and
the original physical device group.  vfio.c works with the mdev groups
and will try to match both groups to the container.  vfio_iommu_type1.c
also works with the mdev groups, except for the point where we actually
try to attach a group to a domain, which is the only window where we use
the iommu_device rather than the provided group, but we don't record
that anywhere.  Should struct vfio_group have a pointer to a reference
counted object that tracks the actual iommu_group attached, such that
we can determine that the group is already attached to the domain and
not try to attach again?  Ideally I'd be able to bind one device to
vfio-pci, the other to vfio-mdev-pci, and be able to use them both
within the same container.  It seems like this should be possible, it's
the same effective iommu configuration as if they were both bound to
vfio-pci.  Thanks,

Alex

diff --git a/drivers/vfio/pci/vfio_mdev_pci.c b/drivers/vfio/pci/vfio_mdev_pci.c
index 07c8067b3f73..09143d3e5473 100644
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
