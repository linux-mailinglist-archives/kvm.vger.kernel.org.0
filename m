Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2893136376
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 23:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgAIWsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 17:48:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55624 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729295AbgAIWsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 17:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578610117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h3t3n3hlMbE9bUAZVNR3bJcmocKoLwqCG/Xs1NrAfA8=;
        b=SEk0RBUsnwzjEr34MnQ+ydQp88JWvuvvYNLgvOtQSbkXrm+5W5CnveFWVcBX9SVQV8tWQ2
        lPw3hQHiPQPIRYfV3lbPgIiP2O+hPWT6X2aRF54nXiSjlZQxVkl/Sx+QP/l2uLco6VBT50
        WZwkgLFCKRB9Y7kxl2X+zSI21wTzUiA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-F1teiJvmN2OhcKwIkif3CA-1; Thu, 09 Jan 2020 17:48:36 -0500
X-MC-Unique: F1teiJvmN2OhcKwIkif3CA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38F9D477;
        Thu,  9 Jan 2020 22:48:35 +0000 (UTC)
Received: from w520.home (ovpn-116-128.phx2.redhat.com [10.3.116.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 272CF7C3D0;
        Thu,  9 Jan 2020 22:48:32 +0000 (UTC)
Date:   Thu, 9 Jan 2020 15:48:31 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kevin.tian@intel.com, joro@8bytes.org,
        peterx@redhat.com, baolu.lu@linux.intel.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
Message-ID: <20200109154831.4c43564f@w520.home>
In-Reply-To: <1578398509-26453-12-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-12-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jan 2020 20:01:48 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch adds sample driver named vfio-mdev-pci. It is to wrap
> a PCI device as a mediated device. For a pci device, once bound
> to vfio-mdev-pci driver, user space access of this device will
> go through vfio mdev framework. The usage of the device follows
> mdev management method. e.g. user should create a mdev before
> exposing the device to user-space.
>=20
> Benefit of this new driver would be acting as a sample driver
> for recent changes from "vfio/mdev: IOMMU aware mediated device"
> patchset. Also it could be a good experiment driver for future
> device specific mdev migration support. This sample driver only
> supports singleton iommu groups, for non-singleton iommu groups,
> this sample driver doesn't work. It will fail when trying to assign
> the non-singleton iommu group to VMs.
>=20
> To use this driver:
> a) build and load vfio-mdev-pci.ko module
>    execute "make menuconfig" and config CONFIG_SAMPLE_VFIO_MDEV_PCI
>    then load it with following command:
>    > sudo modprobe vfio
>    > sudo modprobe vfio-pci
>    > sudo insmod samples/vfio-mdev-pci/vfio-mdev-pci.ko =20
>=20
> b) unbind original device driver
>    e.g. use following command to unbind its original driver
>    > echo $dev_bdf > /sys/bus/pci/devices/$dev_bdf/driver/unbind =20
>=20
> c) bind vfio-mdev-pci driver to the physical device
>    > echo $vend_id $dev_id > /sys/bus/pci/drivers/vfio-mdev-pci/new_id =20
>=20
> d) check the supported mdev instances
>    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/ =20
>      vfio-mdev-pci-type_name
>    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\ =20
>      vfio-mdev-pci-type_name/
>      available_instances  create  device_api  devices  name
>=20
> e)  create mdev on this physical device (only 1 instance)
>    > echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1003" > \ =20
>      /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\
>      vfio-mdev-pci-type_name/create
>=20
> f) passthru the mdev to guest
>    add the following line in QEMU boot command
>     -device vfio-pci,\
>      sysfsdev=3D/sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003
>=20
> g) destroy mdev
>    > echo 1 > /sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003/=
\ =20
>      remove
>=20
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  samples/Kconfig                       |  10 +
>  samples/Makefile                      |   1 +
>  samples/vfio-mdev-pci/Makefile        |   4 +
>  samples/vfio-mdev-pci/vfio_mdev_pci.c | 397 ++++++++++++++++++++++++++++=
++++++
>  4 files changed, 412 insertions(+)
>  create mode 100644 samples/vfio-mdev-pci/Makefile
>  create mode 100644 samples/vfio-mdev-pci/vfio_mdev_pci.c
>=20
> diff --git a/samples/Kconfig b/samples/Kconfig
> index 9d236c3..50d207c 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -190,5 +190,15 @@ config SAMPLE_INTEL_MEI
>  	help
>  	  Build a sample program to work with mei device.
> =20
> +config SAMPLE_VFIO_MDEV_PCI
> +	tristate "Sample driver for wrapping PCI device as a mdev"
> +	select VFIO_PCI_COMMON
> +	select VFIO_PCI
> +	depends on VFIO_MDEV && VFIO_MDEV_DEVICE
> +	help
> +	  Sample driver for wrapping a PCI device as a mdev. Once bound to
> +	  this driver, device passthru should through mdev path.
> +
> +	  If you don't know what to do here, say N.
> =20
>  endif # SAMPLES
> diff --git a/samples/Makefile b/samples/Makefile
> index 5ce50ef..84faced 100644
> --- a/samples/Makefile
> +++ b/samples/Makefile
> @@ -21,5 +21,6 @@ obj-$(CONFIG_SAMPLE_FTRACE_DIRECT)	+=3D ftrace/
>  obj-$(CONFIG_SAMPLE_TRACE_ARRAY)	+=3D ftrace/
>  obj-$(CONFIG_VIDEO_PCI_SKELETON)	+=3D v4l/
>  obj-y					+=3D vfio-mdev/
> +obj-y					+=3D vfio-mdev-pci/

I think we could just lump this into vfio-mdev rather than making
another directory.

>  subdir-$(CONFIG_SAMPLE_VFS)		+=3D vfs
>  obj-$(CONFIG_SAMPLE_INTEL_MEI)		+=3D mei/
> diff --git a/samples/vfio-mdev-pci/Makefile b/samples/vfio-mdev-pci/Makef=
ile
> new file mode 100644
> index 0000000..41b2139
> --- /dev/null
> +++ b/samples/vfio-mdev-pci/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +vfio-mdev-pci-y :=3D vfio_mdev_pci.o
> +
> +obj-$(CONFIG_SAMPLE_VFIO_MDEV_PCI) +=3D vfio-mdev-pci.o
> diff --git a/samples/vfio-mdev-pci/vfio_mdev_pci.c b/samples/vfio-mdev-pc=
i/vfio_mdev_pci.c
> new file mode 100644
> index 0000000..b180356
> --- /dev/null
> +++ b/samples/vfio-mdev-pci/vfio_mdev_pci.c
> @@ -0,0 +1,397 @@
> +/*
> + * Copyright =C2=A9 2020 Intel Corporation.
> + *     Author: Liu Yi L <yi.l.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Derived from original vfio_pci.c:
> + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> + *     Author: Alex Williamson <alex.williamson@redhat.com>
> + *
> + * Derived from original vfio:
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/file.h>
> +#include <linux/interrupt.h>
> +#include <linux/iommu.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +#include <linux/pci.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +#include <linux/vgaarb.h>
> +#include <linux/nospec.h>
> +#include <linux/mdev.h>
> +#include <linux/vfio_pci_common.h>
> +
> +#define DRIVER_VERSION  "0.1"
> +#define DRIVER_AUTHOR   "Liu Yi L <yi.l.liu@intel.com>"
> +#define DRIVER_DESC     "VFIO Mdev PCI - Sample driver for PCI device as=
 a mdev"
> +
> +#define VFIO_MDEV_PCI_NAME  "vfio-mdev-pci"
> +
> +static char ids[1024] __initdata;
> +module_param_string(ids, ids, sizeof(ids), 0);
> +MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio-mdev-pci drive=
r, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\"=
 and multiple comma separated entries can be specified");
> +
> +static bool nointxmask;
> +module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(nointxmask,
> +		  "Disable support for PCI 2.3 style INTx masking.  If this resolves p=
roblems for specific devices, report lspci -vvvxxx to linux-pci@vger.kernel=
.org so the device can be fixed automatically via the broken_intx_masking f=
lag.");
> +
> +#ifdef CONFIG_VFIO_PCI_VGA
> +static bool disable_vga;
> +module_param(disable_vga, bool, S_IRUGO);
> +MODULE_PARM_DESC(disable_vga, "Disable VGA resource access through vfio-=
mdev-pci");
> +#endif
> +
> +static bool disable_idle_d3;
> +module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(disable_idle_d3,
> +		 "Disable using the PCI D3 low power state for idle, unused devices");
> +
> +static struct pci_driver vfio_mdev_pci_driver;
> +
> +static ssize_t
> +name_show(struct kobject *kobj, struct device *dev, char *buf)
> +{
> +	return sprintf(buf, "%s-type1\n", dev_name(dev));
> +}
> +
> +MDEV_TYPE_ATTR_RO(name);
> +
> +static ssize_t
> +available_instances_show(struct kobject *kobj, struct device *dev, char =
*buf)
> +{
> +	return sprintf(buf, "%d\n", 1);
> +}
> +
> +MDEV_TYPE_ATTR_RO(available_instances);
> +
> +static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
> +		char *buf)
> +{
> +	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> +}
> +
> +MDEV_TYPE_ATTR_RO(device_api);
> +
> +static struct attribute *vfio_mdev_pci_types_attrs[] =3D {
> +	&mdev_type_attr_name.attr,
> +	&mdev_type_attr_device_api.attr,
> +	&mdev_type_attr_available_instances.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group vfio_mdev_pci_type_group1 =3D {
> +	.name  =3D "type1",
> +	.attrs =3D vfio_mdev_pci_types_attrs,
> +};
> +
> +struct attribute_group *vfio_mdev_pci_type_groups[] =3D {
> +	&vfio_mdev_pci_type_group1,
> +	NULL,
> +};
> +
> +struct vfio_mdev_pci {
> +	struct vfio_pci_device *vdev;
> +	struct mdev_device *mdev;
> +	unsigned long handle;
> +};
> +
> +static int vfio_mdev_pci_create(struct kobject *kobj, struct mdev_device=
 *mdev)
> +{
> +	struct device *pdev;
> +	struct vfio_pci_device *vdev;
> +	struct vfio_mdev_pci *pmdev;
> +	int ret;
> +
> +	pdev =3D mdev_parent_dev(mdev);
> +	vdev =3D dev_get_drvdata(pdev);
> +	pmdev =3D kzalloc(sizeof(struct vfio_mdev_pci), GFP_KERNEL);
> +	if (pmdev =3D=3D NULL) {
> +		ret =3D -EBUSY;
> +		goto out;
> +	}
> +
> +	pmdev->mdev =3D mdev;
> +	pmdev->vdev =3D vdev;
> +	mdev_set_drvdata(mdev, pmdev);
> +	ret =3D mdev_set_iommu_device(mdev_dev(mdev), pdev);
> +	if (ret) {
> +		pr_info("%s, failed to config iommu isolation for mdev: %s on pf: %s\n=
",
> +			__func__, dev_name(mdev_dev(mdev)), dev_name(pdev));
> +		goto out;
> +	}
> +
> +	pr_info("%s, creation succeeded for mdev: %s\n", __func__,
> +		     dev_name(mdev_dev(mdev)));
> +out:
> +	return ret;
> +}
> +
> +static int vfio_mdev_pci_remove(struct mdev_device *mdev)
> +{
> +	struct vfio_mdev_pci *pmdev =3D mdev_get_drvdata(mdev);
> +
> +	kfree(pmdev);
> +	pr_info("%s, succeeded for mdev: %s\n", __func__,
> +		     dev_name(mdev_dev(mdev)));
> +
> +	return 0;
> +}
> +
> +static int vfio_mdev_pci_open(struct mdev_device *mdev)
> +{
> +	struct vfio_mdev_pci *pmdev =3D mdev_get_drvdata(mdev);
> +	struct vfio_pci_device *vdev =3D pmdev->vdev;
> +	int ret =3D 0;
> +
> +	if (!try_module_get(THIS_MODULE))
> +		return -ENODEV;
> +
> +	vfio_pci_refresh_config(vdev, nointxmask, disable_idle_d3);
> +
> +	mutex_lock(&vdev->reflck->lock);
> +
> +	if (!vdev->refcnt) {
> +		ret =3D vfio_pci_enable(vdev);
> +		if (ret)
> +			goto error;
> +
> +		vfio_spapr_pci_eeh_open(vdev->pdev);
> +	}
> +	vdev->refcnt++;
> +error:
> +	mutex_unlock(&vdev->reflck->lock);
> +	if (!ret)
> +		pr_info("Succeeded to open mdev: %s on pf: %s\n",
> +		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
> +	else {
> +		pr_info("Failed to open mdev: %s on pf: %s\n",
> +		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
> +		module_put(THIS_MODULE);
> +	}
> +	return ret;
> +}
> +
> +static void vfio_mdev_pci_release(struct mdev_device *mdev)
> +{
> +	struct vfio_mdev_pci *pmdev =3D mdev_get_drvdata(mdev);
> +	struct vfio_pci_device *vdev =3D pmdev->vdev;
> +
> +	pr_info("Release mdev: %s on pf: %s\n",
> +		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
> +
> +	mutex_lock(&vdev->reflck->lock);
> +
> +	if (!(--vdev->refcnt)) {
> +		vfio_spapr_pci_eeh_release(vdev->pdev);
> +		vfio_pci_disable(vdev);
> +	}
> +
> +	mutex_unlock(&vdev->reflck->lock);
> +
> +	module_put(THIS_MODULE);
> +}

open() and release() here are almost identical between vfio_pci and
vfio_mdev_pci, which suggests maybe there should be common functions to
call into like we do for the below.

> +static long vfio_mdev_pci_ioctl(struct mdev_device *mdev, unsigned int c=
md,
> +			     unsigned long arg)
> +{
> +	struct vfio_mdev_pci *pmdev =3D mdev_get_drvdata(mdev);
> +
> +	return vfio_pci_ioctl(pmdev->vdev, cmd, arg);
> +}
> +
> +static int vfio_mdev_pci_mmap(struct mdev_device *mdev,
> +				struct vm_area_struct *vma)
> +{
> +	struct vfio_mdev_pci *pmdev =3D mdev_get_drvdata(mdev);
> +
> +	return vfio_pci_mmap(pmdev->vdev, vma);
> +}
> +
> +static ssize_t vfio_mdev_pci_read(struct mdev_device *mdev, char __user =
*buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct vfio_mdev_pci *pmdev =3D mdev_get_drvdata(mdev);
> +
> +	return vfio_pci_read(pmdev->vdev, buf, count, ppos);
> +}
> +
> +static ssize_t vfio_mdev_pci_write(struct mdev_device *mdev,
> +				const char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	struct vfio_mdev_pci *pmdev =3D mdev_get_drvdata(mdev);
> +
> +	return vfio_pci_write(pmdev->vdev, (char __user *)buf, count, ppos);
> +}
> +
> +static const struct mdev_parent_ops vfio_mdev_pci_ops =3D {
> +	.supported_type_groups	=3D vfio_mdev_pci_type_groups,
> +	.create			=3D vfio_mdev_pci_create,
> +	.remove			=3D vfio_mdev_pci_remove,
> +
> +	.open			=3D vfio_mdev_pci_open,
> +	.release		=3D vfio_mdev_pci_release,
> +
> +	.read			=3D vfio_mdev_pci_read,
> +	.write			=3D vfio_mdev_pci_write,
> +	.mmap			=3D vfio_mdev_pci_mmap,
> +	.ioctl			=3D vfio_mdev_pci_ioctl,
> +};
> +
> +static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
> +				       const struct pci_device_id *id)
> +{
> +	struct vfio_pci_device *vdev;
> +	int ret;
> +
> +	if (pdev->hdr_type !=3D PCI_HEADER_TYPE_NORMAL)
> +		return -EINVAL;
> +
> +	/*
> +	 * Prevent binding to PFs with VFs enabled, this too easily allows
> +	 * userspace instance with VFs and PFs from the same device, which
> +	 * cannot work.  Disabling SR-IOV here would initiate removing the
> +	 * VFs, which would unbind the driver, which is prone to blocking
> +	 * if that VF is also in use by vfio-pci or vfio-mdev-pci. Just
> +	 * reject these PFs and let the user sort it out.
> +	 */
> +	if (pci_num_vf(pdev)) {
> +		pci_warn(pdev, "Cannot bind to PF with SR-IOV enabled\n");
> +		return -EBUSY;
> +	}
> +
> +	vdev =3D kzalloc(sizeof(*vdev), GFP_KERNEL);
> +	if (!vdev)
> +		return -ENOMEM;
> +
> +	vdev->pdev =3D pdev;
> +	vdev->irq_type =3D VFIO_PCI_NUM_IRQS;
> +	mutex_init(&vdev->igate);
> +	spin_lock_init(&vdev->irqlock);
> +	mutex_init(&vdev->ioeventfds_lock);
> +	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> +	vdev->nointxmask =3D nointxmask;
> +#ifdef CONFIG_VFIO_PCI_VGA
> +	vdev->disable_vga =3D disable_vga;
> +#endif
> +	vdev->disable_idle_d3 =3D disable_idle_d3;
> +
> +	pci_set_drvdata(pdev, vdev);
> +
> +	ret =3D vfio_pci_reflck_attach(vdev);
> +	if (ret) {
> +		pci_set_drvdata(pdev, NULL);
> +		kfree(vdev);
> +		return ret;
> +	}
> +
> +	if (vfio_pci_is_vga(pdev)) {
> +		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
> +		vga_set_legacy_decoding(pdev,
> +					vfio_pci_set_vga_decode(vdev, false));
> +	}
> +
> +	vfio_pci_probe_power_state(vdev);
> +
> +	if (!vdev->disable_idle_d3) {
> +		/*
> +		 * pci-core sets the device power state to an unknown value at
> +		 * bootup and after being removed from a driver.  The only
> +		 * transition it allows from this unknown state is to D0, which
> +		 * typically happens when a driver calls pci_enable_device().
> +		 * We're not ready to enable the device yet, but we do want to
> +		 * be able to get to D3.  Therefore first do a D0 transition
> +		 * before going to D3.
> +		 */
> +		vfio_pci_set_power_state(vdev, PCI_D0);
> +		vfio_pci_set_power_state(vdev, PCI_D3hot);
> +	}

Ditto here and remove below, this seems like boilerplate that shouldn't
be duplicated per leaf module.  Thanks,

Alex


> +
> +	ret =3D mdev_register_device(&pdev->dev, &vfio_mdev_pci_ops);
> +	if (ret)
> +		pr_err("Cannot register mdev for device %s\n",
> +			dev_name(&pdev->dev));
> +	else
> +		pr_info("Wrap device %s as a mdev\n", dev_name(&pdev->dev));
> +
> +	return ret;
> +}
> +
> +static void vfio_mdev_pci_driver_remove(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_device *vdev;
> +
> +	vdev =3D pci_get_drvdata(pdev);
> +	if (!vdev)
> +		return;
> +
> +	vfio_pci_reflck_put(vdev->reflck);
> +
> +	kfree(vdev->region);
> +	mutex_destroy(&vdev->ioeventfds_lock);
> +
> +	if (!disable_idle_d3)
> +		vfio_pci_set_power_state(vdev, PCI_D0);
> +
> +	kfree(vdev->pm_save);
> +
> +	if (vfio_pci_is_vga(pdev)) {
> +		vga_client_register(pdev, NULL, NULL, NULL);
> +		vga_set_legacy_decoding(pdev,
> +				VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
> +				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
> +	}
> +
> +	kfree(vdev);
> +}
> +
> +static struct pci_driver vfio_mdev_pci_driver =3D {
> +	.name		=3D VFIO_MDEV_PCI_NAME,
> +	.id_table	=3D NULL, /* only dynamic ids */
> +	.probe		=3D vfio_mdev_pci_driver_probe,
> +	.remove		=3D vfio_mdev_pci_driver_remove,
> +	.err_handler	=3D &vfio_pci_err_handlers,
> +};
> +
> +static void __exit vfio_mdev_pci_cleanup(void)
> +{
> +	pci_unregister_driver(&vfio_mdev_pci_driver);
> +}
> +
> +static int __init vfio_mdev_pci_init(void)
> +{
> +	int ret;
> +
> +	/* Register and scan for devices */
> +	ret =3D pci_register_driver(&vfio_mdev_pci_driver);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_fill_ids(ids, &vfio_mdev_pci_driver);
> +
> +	return 0;
> +}
> +
> +module_init(vfio_mdev_pci_init);
> +module_exit(vfio_mdev_pci_cleanup);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);

