Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEAC120491
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 12:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfLPL57 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 16 Dec 2019 06:57:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:35770 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbfLPL56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 06:57:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 03:57:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,321,1571727600"; 
   d="scan'208";a="240017690"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga004.fm.intel.com with ESMTP; 16 Dec 2019 03:57:57 -0800
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 03:57:56 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.236]) with mapi id 14.03.0439.000;
 Mon, 16 Dec 2019 19:57:54 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits alloc/free
Thread-Topic: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits
 alloc/free
Thread-Index: AQHVoSnwVqdzrJe2wU2Z/flFcmihA6e7ao+AgAD9KVA=
Date:   Mon, 16 Dec 2019 11:57:54 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A134FBE@SHSMSX104.ccr.corp.intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
        <1574335427-3763-9-git-send-email-yi.l.liu@intel.com>
 <20191215154633.4641b05e@x1.home>
In-Reply-To: <20191215154633.4641b05e@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzYwOTY1MDYtNmJmZS00MTVhLWE1ZWEtMjBjMWQ4YmVlYzhlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiejd1N1wvZVBDeXJ1b2p6VFEyZkhyOVRuTWtPY2pmeWFKREJQZjBhaGpmaVQxMWFEOU0wWEh4ODZGRlAyM21yT0MifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Monday, December 16, 2019 6:47 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits alloc/free
> 
> On Thu, 21 Nov 2019 19:23:45 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch add a user numer track for the shared cap/ecap_perms bits,
> > and the alloc/free will hold a semaphore to protect the operations.
> > With the changes, first caller of vfio_pci_init_perm_bits() will
> > initialize the bits. While the last caller of vfio_pci_uninit_perm_bits()
> > will free the bits. This is a preparation to have multiple cap/ecap_perms
> > bits users.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_config.c | 33 +++++++++++++++++++++++++++++++--
> >  1 file changed, 31 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > index f0891bd..274c993 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -36,6 +36,13 @@
> >  	 (offset >= PCI_ROM_ADDRESS && offset < PCI_ROM_ADDRESS + 4))
> >
> >  /*
> > + * vfio_perm_bits_sem: prorects the shared perm_bits alloc/free
> > + * vfio_pci_perm_bits_users: tracks the user of the shared perm_bits
> > + */
> > +static DEFINE_SEMAPHORE(vfio_perm_bits_sem);
> > +static int vfio_pci_perm_bits_users;
> > +
> > +/*
> >   * Lengths of PCI Config Capabilities
> >   *   0: Removed from the user visible capability list
> >   *   FF: Variable length
> > @@ -995,7 +1002,7 @@ static int __init init_pci_ext_cap_pwr_perm(struct
> perm_bits *perm)
> >  /*
> >   * Initialize the shared permission tables
> >   */
> > -void vfio_pci_uninit_perm_bits(void)
> > +static void vfio_pci_uninit_perm_bits_internal(void)
> >  {
> >  	free_perm_bits(&cap_perms[PCI_CAP_ID_BASIC]);
> >
> > @@ -1009,10 +1016,30 @@ void vfio_pci_uninit_perm_bits(void)
> >  	free_perm_bits(&ecap_perms[PCI_EXT_CAP_ID_PWR]);
> >  }
> >
> > +void vfio_pci_uninit_perm_bits(void)
> > +{
> > +	down(&vfio_perm_bits_sem);
> > +
> > +	if (--vfio_pci_perm_bits_users > 0)
> > +		goto out;
> > +
> > +	vfio_pci_uninit_perm_bits_internal();
> > +
> > +out:
> > +	up(&vfio_perm_bits_sem);
> > +}
> > +
> >  int __init vfio_pci_init_perm_bits(void)
> >  {
> >  	int ret;
> >
> > +	down(&vfio_perm_bits_sem);
> > +
> > +	if (++vfio_pci_perm_bits_users > 1) {
> > +		ret = 0;
> > +		goto out;
> > +	}
> > +
> >  	/* Basic config space */
> >  	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
> >
> > @@ -1030,8 +1057,10 @@ int __init vfio_pci_init_perm_bits(void)
> >  	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
> >
> >  	if (ret)
> > -		vfio_pci_uninit_perm_bits();
> > +		vfio_pci_uninit_perm_bits_internal();
> >
> > +out:
> > +	up(&vfio_perm_bits_sem);
> >  	return ret;
> >  }
> >
> 
> Hi Yi,
> 
> Sorry for slowness in providing feedback on this series.  If we
> provided a vfio-pci-common module that vfio-pci and vfio-mdev-pci
> depend on, doesn't this entire problem go away? 

I checked previous email, export the common functions out of
vfio-pci module was proposed in RFC v2. But at that time, I didn't
propose to have a separate module. So I guess it may be just correct
way. Below is the reply at that time.

https://lkml.org/lkml/2019/3/19/756

> I played a little bit
> with this in the crude patch below, it seems to work.  To finish this,
> I think we'd move the function declarations out of the "private" header
> file and into one under include/linux, then we could also move
> vfio_mdev_pci.c to the samples directory like we intended originally.
> I know you had tried to link things from samples and it didn't work,
> but is the below a better attempt at resolving this?  It commits us to
> exporting a bunch of functions, we'll need to decide whether that's a
> good idea.  Thanks,

I played with your patch and added a crude patch to move
vfio-mdev-pci to samples directory. I can see below errors with
either CONFIG_VFIO_PCI_COMMON=y and
CONFIG_SAMPLE_VFIO_MDEV_PCI=y, or
CONFIG_VFIO_PCI_COMMON=m and
CONFIG_SAMPLE_VFIO_MDEV_PCI=m.

But CONFIG_VFIO_PCI_COMMON works well with CONFIG_VFIO_PCI...

Kernel: arch/x86/boot/bzImage is ready  (#88)
ERROR: "vfio_pci_fill_ids" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_err_handlers" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_reflck_attach" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_write" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_disable" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_reflck_put" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_refresh_config" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_set_power_state" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_enable" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_set_vga_decode" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_probe_power_state" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_mmap" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_ioctl" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
ERROR: "vfio_pci_read" [samples/vfio-mdev-pci/vfio-mdev-pci.ko] undefined!
scripts/Makefile.modpost:93: recipe for target '__modpost' failed

So I'm afraid that it still cannot resolve the problem which we encountered
when trying to place vfio-mdev-pci in samples/.

Regards,
Yi Liu

================= [the crude patch] =================
From fa860ff15ab188481141f7bd2b9cb3a1d500f24d Mon Sep 17 00:00:00 2001
From: Liu Yi L <yi.l.liu@intel.com>
Date: Sun, 15 Dec 2019 19:16:54 +0800
Subject: [PATCH] vfio/pci/sample: move vfio-pci-mdev to samples

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/Makefile             |   2 -
 drivers/vfio/pci/vfio_mdev_pci.c      | 421 ----------------------------------
 drivers/vfio/pci/vfio_pci.c           |   2 +-
 drivers/vfio/pci/vfio_pci_common.c    |   2 +-
 drivers/vfio/pci/vfio_pci_config.c    |   2 +-
 drivers/vfio/pci/vfio_pci_igd.c       |   2 +-
 drivers/vfio/pci/vfio_pci_intrs.c     |   2 +-
 drivers/vfio/pci/vfio_pci_nvlink2.c   |   2 +-
 drivers/vfio/pci/vfio_pci_private.h   | 228 ------------------
 drivers/vfio/pci/vfio_pci_rdwr.c      |   2 +-
 include/linux/vfio_pci_private.h      | 228 ++++++++++++++++++
 samples/Makefile                      |   1 +
 samples/vfio-mdev-pci/Makefile        |   4 +
 samples/vfio-mdev-pci/vfio_mdev_pci.c | 421 ++++++++++++++++++++++++++++++++++
 14 files changed, 661 insertions(+), 658 deletions(-)
 delete mode 100644 drivers/vfio/pci/vfio_mdev_pci.c
 delete mode 100644 drivers/vfio/pci/vfio_pci_private.h
 create mode 100644 include/linux/vfio_pci_private.h
 create mode 100644 samples/vfio-mdev-pci/Makefile
 create mode 100644 samples/vfio-mdev-pci/vfio_mdev_pci.c

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 9f599cb..ad60cfd 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -6,8 +6,6 @@ vfio-pci-common-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 vfio-pci-common-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
 
 vfio-pci-y := vfio_pci.o
-vfio-mdev-pci-y := vfio_mdev_pci.o
 
 obj-$(CONFIG_VFIO_PCI_COMMON) += vfio-pci-common.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
-obj-$(CONFIG_SAMPLE_VFIO_MDEV_PCI) += vfio-mdev-pci.o
diff --git a/drivers/vfio/pci/vfio_mdev_pci.c b/drivers/vfio/pci/vfio_mdev_pci.c
deleted file mode 100644
index e6b070f..0000000
--- a/drivers/vfio/pci/vfio_mdev_pci.c
+++ /dev/null
@@ -1,421 +0,0 @@
-/*
- * Copyright (c) 2019 Intel Corporation.
- *     Author: Liu Yi L <yi.l.liu@intel.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Derived from original vfio_pci.c:
- * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
- *     Author: Alex Williamson <alex.williamson@redhat.com>
- *
- * Derived from original vfio:
- * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
- * Author: Tom Lyon, pugs@cisco.com
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/device.h>
-#include <linux/eventfd.h>
-#include <linux/file.h>
-#include <linux/interrupt.h>
-#include <linux/iommu.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/notifier.h>
-#include <linux/pci.h>
-#include <linux/pm_runtime.h>
-#include <linux/slab.h>
-#include <linux/types.h>
-#include <linux/uaccess.h>
-#include <linux/vfio.h>
-#include <linux/vgaarb.h>
-#include <linux/nospec.h>
-#include <linux/mdev.h>
-
-#include "vfio_pci_private.h"
-
-#define DRIVER_VERSION  "0.1"
-#define DRIVER_AUTHOR   "Liu Yi L <yi.l.liu@intel.com>"
-#define DRIVER_DESC     "VFIO Mdev PCI - Sample driver for PCI device as a mdev"
-
-#define VFIO_MDEV_PCI_NAME  "vfio-mdev-pci"
-
-static char ids[1024] __initdata;
-module_param_string(ids, ids, sizeof(ids), 0);
-MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio-mdev-pci driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
-
-static bool nointxmask;
-module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(nointxmask,
-		  "Disable support for PCI 2.3 style INTx masking.  If this resolves problems for specific devices, report lspci -vvvxxx to linux-pci@vger.kernel.org so the device can be fixed automatically via the broken_intx_masking flag.");
-
-#ifdef CONFIG_VFIO_PCI_VGA
-static bool disable_vga;
-module_param(disable_vga, bool, S_IRUGO);
-MODULE_PARM_DESC(disable_vga, "Disable VGA resource access through vfio-mdev-pci");
-#endif
-
-static bool disable_idle_d3;
-module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(disable_idle_d3,
-		 "Disable using the PCI D3 low power state for idle, unused devices");
-
-static struct pci_driver vfio_mdev_pci_driver;
-
-struct vfio_mdev_pci_device {
-	struct vfio_pci_device vdev;
-	struct mdev_parent_ops ops;
-	struct attribute_group *groups[2];
-	struct attribute_group attr;
-	atomic_t avail;
-};
-
-static ssize_t
-available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
-{
-	struct vfio_mdev_pci_device *vmdev;
-
-	vmdev = pci_get_drvdata(to_pci_dev(dev));
-
-	return sprintf(buf, "%d\n", atomic_read(&vmdev->avail));
-}
-
-MDEV_TYPE_ATTR_RO(available_instances);
-
-static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
-		char *buf)
-{
-	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
-}
-
-MDEV_TYPE_ATTR_RO(device_api);
-
-static struct attribute *vfio_mdev_pci_types_attrs[] = {
-	&mdev_type_attr_device_api.attr,
-	&mdev_type_attr_available_instances.attr,
-	NULL,
-};
-
-struct vfio_mdev_pci {
-	struct vfio_pci_device *vdev;
-	struct mdev_device *mdev;
-};
-
-static int vfio_mdev_pci_create(struct kobject *kobj, struct mdev_device *mdev)
-{
-	struct device *pdev;
-	struct vfio_mdev_pci_device *vmdev;
-	struct vfio_mdev_pci *pmdev;
-	int ret;
-
-	pdev = mdev_parent_dev(mdev);
-	vmdev = dev_get_drvdata(pdev);
-
-	if (atomic_dec_if_positive(&vmdev->avail) < 0)
-		return -ENOSPC;
-
-	pmdev = kzalloc(sizeof(struct vfio_mdev_pci), GFP_KERNEL);
-	if (!pmdev) {
-		atomic_inc(&vmdev->avail);
-		return -ENOMEM;
-	}
-
-	pmdev->mdev = mdev;
-	pmdev->vdev = &vmdev->vdev;
-	mdev_set_drvdata(mdev, pmdev);
-	ret = mdev_set_iommu_device(mdev_dev(mdev), pdev);
-	if (ret) {
-		pr_info("%s, failed to config iommu isolation for mdev: %s on pf: %s\n",
-			__func__, dev_name(mdev_dev(mdev)), dev_name(pdev));
-		kfree(pmdev);
-		atomic_inc(&vmdev->avail);
-		return ret;
-	}
-
-	pr_info("%s, creation succeeded for mdev: %s\n", __func__,
-		     dev_name(mdev_dev(mdev)));
-	return 0;
-}
-
-static int vfio_mdev_pci_remove(struct mdev_device *mdev)
-{
-	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
-	struct vfio_mdev_pci_device *vmdev;
-
-	vmdev = container_of(pmdev->vdev, struct vfio_mdev_pci_device, vdev);
-
-	kfree(pmdev);
-	atomic_inc(&vmdev->avail);
-	pr_info("%s, succeeded for mdev: %s\n", __func__,
-		     dev_name(mdev_dev(mdev)));
-
-	return 0;
-}
-
-static int vfio_mdev_pci_open(struct mdev_device *mdev)
-{
-	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
-	struct vfio_pci_device *vdev = pmdev->vdev;
-	int ret = 0;
-
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
-	vfio_pci_refresh_config(vdev, nointxmask, disable_idle_d3);
-
-	mutex_lock(&vdev->reflck->lock);
-
-	if (!vdev->refcnt) {
-		ret = vfio_pci_enable(vdev);
-		if (ret)
-			goto error;
-
-		vfio_spapr_pci_eeh_open(vdev->pdev);
-	}
-	vdev->refcnt++;
-error:
-	mutex_unlock(&vdev->reflck->lock);
-	if (!ret)
-		pr_info("Succeeded to open mdev: %s on pf: %s\n",
-		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
-	else {
-		pr_info("Failed to open mdev: %s on pf: %s\n",
-		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
-		module_put(THIS_MODULE);
-	}
-	return ret;
-}
-
-static void vfio_mdev_pci_release(struct mdev_device *mdev)
-{
-	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
-	struct vfio_pci_device *vdev = pmdev->vdev;
-
-	pr_info("Release mdev: %s on pf: %s\n",
-		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
-
-	mutex_lock(&vdev->reflck->lock);
-
-	if (!(--vdev->refcnt)) {
-		vfio_spapr_pci_eeh_release(vdev->pdev);
-		vfio_pci_disable(vdev);
-	}
-
-	mutex_unlock(&vdev->reflck->lock);
-
-	module_put(THIS_MODULE);
-}
-
-static long vfio_mdev_pci_ioctl(struct mdev_device *mdev, unsigned int cmd,
-			     unsigned long arg)
-{
-	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
-
-	return vfio_pci_ioctl(pmdev->vdev, cmd, arg);
-}
-
-static int vfio_mdev_pci_mmap(struct mdev_device *mdev,
-				struct vm_area_struct *vma)
-{
-	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
-
-	return vfio_pci_mmap(pmdev->vdev, vma);
-}
-
-static ssize_t vfio_mdev_pci_read(struct mdev_device *mdev, char __user *buf,
-			size_t count, loff_t *ppos)
-{
-	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
-
-	return vfio_pci_read(pmdev->vdev, buf, count, ppos);
-}
-
-static ssize_t vfio_mdev_pci_write(struct mdev_device *mdev,
-				const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
-
-	return vfio_pci_write(pmdev->vdev, (char __user *)buf, count, ppos);
-}
-
-static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
-				       const struct pci_device_id *id)
-{
-	struct vfio_mdev_pci_device *vmdev;
-	struct vfio_pci_device *vdev;
-	const struct mdev_parent_ops *ops;
-	int ret;
-
-	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
-		return -EINVAL;
-
-	/*
-	 * Prevent binding to PFs with VFs enabled, this too easily allows
-	 * userspace instance with VFs and PFs from the same device, which
-	 * cannot work.  Disabling SR-IOV here would initiate removing the
-	 * VFs, which would unbind the driver, which is prone to blocking
-	 * if that VF is also in use by vfio-pci or vfio-mdev-pci. Just
-	 * reject these PFs and let the user sort it out.
-	 */
-	if (pci_num_vf(pdev)) {
-		pci_warn(pdev, "Cannot bind to PF with SR-IOV enabled\n");
-		return -EBUSY;
-	}
-
-	vmdev = kzalloc(sizeof(*vmdev), GFP_KERNEL);
-	if (!vmdev)
-		return -ENOMEM;
-
-	vmdev->attr.name = kasprintf(GFP_KERNEL,
-				     "%04x:%04x:%04x:%04x:%06x:%02x",
-				     pdev->vendor, pdev->device,
-				     pdev->subsystem_vendor,
-				     pdev->subsystem_device, pdev->class,
-				     pdev->revision);
-	if (!vmdev->attr.name) {
-		kfree(vmdev);
-		return -ENOMEM;
-	}
-
-	atomic_set(&vmdev->avail, 1);
-
-	vmdev->attr.attrs = vfio_mdev_pci_types_attrs;
-	vmdev->groups[0] = &vmdev->attr;
-
-	vmdev->ops.supported_type_groups = vmdev->groups;
-	vmdev->ops.create = vfio_mdev_pci_create;
-	vmdev->ops.remove = vfio_mdev_pci_remove;
-	vmdev->ops.open	= vfio_mdev_pci_open;
-	vmdev->ops.release = vfio_mdev_pci_release;
-	vmdev->ops.read = vfio_mdev_pci_read;
-	vmdev->ops.write = vfio_mdev_pci_write;
-	vmdev->ops.mmap = vfio_mdev_pci_mmap;
-	vmdev->ops.ioctl = vfio_mdev_pci_ioctl;
-	ops = &vmdev->ops;
-
-	vdev = &vmdev->vdev;
-	vdev->pdev = pdev;
-	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	mutex_init(&vdev->igate);
-	spin_lock_init(&vdev->irqlock);
-	mutex_init(&vdev->ioeventfds_lock);
-	INIT_LIST_HEAD(&vdev->ioeventfds_list);
-	vdev->nointxmask = nointxmask;
-#ifdef CONFIG_VFIO_PCI_VGA
-	vdev->disable_vga = disable_vga;
-#endif
-	vdev->disable_idle_d3 = disable_idle_d3;
-
-	pci_set_drvdata(pdev, vmdev);
-
-	ret = vfio_pci_reflck_attach(vdev);
-	if (ret) {
-		pci_set_drvdata(pdev, NULL);
-		kfree(vdev);
-		return ret;
-	}
-
-	if (vfio_pci_is_vga(pdev)) {
-		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
-		vga_set_legacy_decoding(pdev,
-					vfio_pci_set_vga_decode(vdev, false));
-	}
-
-	vfio_pci_probe_power_state(vdev);
-
-	if (!vdev->disable_idle_d3) {
-		/*
-		 * pci-core sets the device power state to an unknown value at
-		 * bootup and after being removed from a driver.  The only
-		 * transition it allows from this unknown state is to D0, which
-		 * typically happens when a driver calls pci_enable_device().
-		 * We're not ready to enable the device yet, but we do want to
-		 * be able to get to D3.  Therefore first do a D0 transition
-		 * before going to D3.
-		 */
-		vfio_pci_set_power_state(vdev, PCI_D0);
-		vfio_pci_set_power_state(vdev, PCI_D3hot);
-	}
-
-	ret = mdev_register_device(&pdev->dev, ops);
-	if (ret)
-		pr_err("Cannot register mdev for device %s\n",
-			dev_name(&pdev->dev));
-	else
-		pr_info("Wrap device %s as a mdev\n", dev_name(&pdev->dev));
-
-	return ret;
-}
-
-static void vfio_mdev_pci_driver_remove(struct pci_dev *pdev)
-{
-	struct vfio_mdev_pci_device *vmdev;
-	struct vfio_pci_device *vdev;
-
-	mdev_unregister_device(&pdev->dev);
-
-	vmdev = pci_get_drvdata(pdev);
-	if (!vmdev)
-		return;
-
-	vdev = &vmdev->vdev;
-
-	vfio_pci_reflck_put(vdev->reflck);
-
-	kfree(vdev->region);
-	mutex_destroy(&vdev->ioeventfds_lock);
-
-	if (!disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
-
-	kfree(vdev->pm_save);
-
-	if (vfio_pci_is_vga(pdev)) {
-		vga_client_register(pdev, NULL, NULL, NULL);
-		vga_set_legacy_decoding(pdev,
-				VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
-				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
-	}
-
-	kfree(vmdev->attr.name);
-	kfree(vmdev);
-}
-
-static struct pci_driver vfio_mdev_pci_driver = {
-	.name		= VFIO_MDEV_PCI_NAME,
-	.id_table	= NULL, /* only dynamic ids */
-	.probe		= vfio_mdev_pci_driver_probe,
-	.remove		= vfio_mdev_pci_driver_remove,
-	.err_handler	= &vfio_pci_err_handlers,
-};
-
-static void __exit vfio_mdev_pci_cleanup(void)
-{
-	pci_unregister_driver(&vfio_mdev_pci_driver);
-}
-
-static int __init vfio_mdev_pci_init(void)
-{
-	int ret;
-
-	/* Register and scan for devices */
-	ret = pci_register_driver(&vfio_mdev_pci_driver);
-	if (ret)
-		return ret;
-
-	vfio_pci_fill_ids(ids, &vfio_mdev_pci_driver);
-
-	return 0;
-}
-
-module_init(vfio_mdev_pci_init);
-module_exit(vfio_mdev_pci_cleanup);
-
-MODULE_VERSION(DRIVER_VERSION);
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7047667..5550858 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -28,7 +28,7 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 
-#include "vfio_pci_private.h"
+#include <linux/vfio_pci_private.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
diff --git a/drivers/vfio/pci/vfio_pci_common.c b/drivers/vfio/pci/vfio_pci_common.c
index dd6f8fd..0523dab 100644
--- a/drivers/vfio/pci/vfio_pci_common.c
+++ b/drivers/vfio/pci/vfio_pci_common.c
@@ -28,7 +28,7 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 
-#include "vfio_pci_private.h"
+#include <linux/vfio_pci_private.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index f0891bd..9040ba2 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -26,7 +26,7 @@
 #include <linux/vfio.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_private.h"
+#include <linux/vfio_pci_private.h>
 
 /* Fake capability ID for standard config space */
 #define PCI_CAP_ID_BASIC	0
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 53d97f4..4566e93 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -15,7 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 
-#include "vfio_pci_private.h"
+#include <linux/vfio_pci_private.h>
 
 #define OPREGION_SIGNATURE	"IntelGraphicsMem"
 #define OPREGION_SIZE		(8 * 1024)
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3fa3f72..6da3eba 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -20,7 +20,7 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_private.h"
+#include <linux/vfio_pci_private.h>
 
 /*
  * INTx
diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index f2983f0..7cac168 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -19,7 +19,7 @@
 #include <linux/sched/mm.h>
 #include <linux/mmu_context.h>
 #include <asm/kvm_ppc.h>
-#include "vfio_pci_private.h"
+#include <linux/vfio_pci_private.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
deleted file mode 100644
index 562b7c1..0000000
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ /dev/null
@@ -1,228 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
- *     Author: Alex Williamson <alex.williamson@redhat.com>
- *
- * Derived from original vfio:
- * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
- * Author: Tom Lyon, pugs@cisco.com
- */
-
-#include <linux/mutex.h>
-#include <linux/pci.h>
-#include <linux/irqbypass.h>
-#include <linux/types.h>
-
-#ifndef VFIO_PCI_PRIVATE_H
-#define VFIO_PCI_PRIVATE_H
-
-#define VFIO_PCI_OFFSET_SHIFT   40
-
-#define VFIO_PCI_OFFSET_TO_INDEX(off)	(off >> VFIO_PCI_OFFSET_SHIFT)
-#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
-#define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
-
-/* Special capability IDs predefined access */
-#define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
-#define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
-
-/* Cap maximum number of ioeventfds per device (arbitrary) */
-#define VFIO_PCI_IOEVENTFD_MAX		1000
-
-struct vfio_pci_ioeventfd {
-	struct list_head	next;
-	struct virqfd		*virqfd;
-	void __iomem		*addr;
-	uint64_t		data;
-	loff_t			pos;
-	int			bar;
-	int			count;
-};
-
-struct vfio_pci_irq_ctx {
-	struct eventfd_ctx	*trigger;
-	struct virqfd		*unmask;
-	struct virqfd		*mask;
-	char			*name;
-	bool			masked;
-	struct irq_bypass_producer	producer;
-};
-
-struct vfio_pci_device;
-struct vfio_pci_region;
-
-struct vfio_pci_regops {
-	size_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
-		      size_t count, loff_t *ppos, bool iswrite);
-	void	(*release)(struct vfio_pci_device *vdev,
-			   struct vfio_pci_region *region);
-	int	(*mmap)(struct vfio_pci_device *vdev,
-			struct vfio_pci_region *region,
-			struct vm_area_struct *vma);
-	int	(*add_capability)(struct vfio_pci_device *vdev,
-				  struct vfio_pci_region *region,
-				  struct vfio_info_cap *caps);
-};
-
-struct vfio_pci_region {
-	u32				type;
-	u32				subtype;
-	const struct vfio_pci_regops	*ops;
-	void				*data;
-	size_t				size;
-	u32				flags;
-};
-
-struct vfio_pci_dummy_resource {
-	struct resource		resource;
-	int			index;
-	struct list_head	res_next;
-};
-
-struct vfio_pci_reflck {
-	struct kref		kref;
-	struct mutex		lock;
-};
-
-struct vfio_pci_device {
-	struct pci_dev		*pdev;
-	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
-	bool			bar_mmap_supported[PCI_STD_RESOURCE_END + 1];
-	u8			*pci_config_map;
-	u8			*vconfig;
-	struct perm_bits	*msi_perm;
-	spinlock_t		irqlock;
-	struct mutex		igate;
-	struct vfio_pci_irq_ctx	*ctx;
-	int			num_ctx;
-	int			irq_type;
-	int			num_regions;
-	struct vfio_pci_region	*region;
-	u8			msi_qmax;
-	u8			msix_bar;
-	u16			msix_size;
-	u32			msix_offset;
-	u32			rbar[7];
-	bool			pci_2_3;
-	bool			virq_disabled;
-	bool			reset_works;
-	bool			extended_caps;
-	bool			bardirty;
-	bool			has_vga;
-	bool			needs_reset;
-	bool			nointx;
-	bool			needs_pm_restore;
-	struct pci_saved_state	*pci_saved_state;
-	struct pci_saved_state	*pm_save;
-	struct vfio_pci_reflck	*reflck;
-	int			refcnt;
-	int			ioeventfds_nr;
-	struct eventfd_ctx	*err_trigger;
-	struct eventfd_ctx	*req_trigger;
-	struct list_head	dummy_resources_list;
-	struct mutex		ioeventfds_lock;
-	struct list_head	ioeventfds_list;
-	bool			nointxmask;
-#ifdef CONFIG_VFIO_PCI_VGA
-	bool			disable_vga;
-#endif
-	bool			disable_idle_d3;
-};
-
-#define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
-#define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
-#define is_msix(vdev) (vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
-#define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
-#define irq_is(vdev, type) (vdev->irq_type == type)
-
-extern const struct pci_error_handlers vfio_pci_err_handlers;
-
-static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
-{
-	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
-}
-
-static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
-{
-#ifdef CONFIG_VFIO_PCI_VGA
-	return vdev->disable_vga;
-#else
-	return true;
-#endif
-}
-
-extern void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
-				bool nointxmask, bool disable_idle_d3);
-
-extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
-extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
-
-extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
-				   uint32_t flags, unsigned index,
-				   unsigned start, unsigned count, void *data);
-
-extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
-				  char __user *buf, size_t count,
-				  loff_t *ppos, bool iswrite);
-
-extern ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
-			       size_t count, loff_t *ppos, bool iswrite);
-
-extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
-			       size_t count, loff_t *ppos, bool iswrite);
-
-extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
-			       uint64_t data, int count, int fd);
-
-extern int vfio_pci_init_perm_bits(void);
-extern void vfio_pci_uninit_perm_bits(void);
-
-extern int vfio_config_init(struct vfio_pci_device *vdev);
-extern void vfio_config_free(struct vfio_pci_device *vdev);
-
-extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
-					unsigned int type, unsigned int subtype,
-					const struct vfio_pci_regops *ops,
-					size_t size, u32 flags, void *data);
-
-extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
-				    pci_power_t state);
-extern unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga);
-extern int vfio_pci_enable(struct vfio_pci_device *vdev);
-extern void vfio_pci_disable(struct vfio_pci_device *vdev);
-extern long vfio_pci_ioctl(void *device_data,
-			unsigned int cmd, unsigned long arg);
-extern ssize_t vfio_pci_read(void *device_data, char __user *buf,
-			size_t count, loff_t *ppos);
-extern ssize_t vfio_pci_write(void *device_data, const char __user *buf,
-			size_t count, loff_t *ppos);
-extern int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma);
-extern void vfio_pci_request(void *device_data, unsigned int count);
-extern void vfio_pci_fill_ids(char *ids, struct pci_driver *driver);
-extern int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
-extern void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
-extern void vfio_pci_probe_power_state(struct vfio_pci_device *vdev);
-
-#ifdef CONFIG_VFIO_PCI_IGD
-extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
-#else
-static inline int vfio_pci_igd_init(struct vfio_pci_device *vdev)
-{
-	return -ENODEV;
-}
-#endif
-#ifdef CONFIG_VFIO_PCI_NVLINK2
-extern int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev);
-extern int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev);
-#else
-static inline int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
-{
-	return -ENODEV;
-}
-
-static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
-{
-	return -ENODEV;
-}
-#endif
-#endif /* VFIO_PCI_PRIVATE_H */
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 0120d83..72bc689 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,7 +17,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 
-#include "vfio_pci_private.h"
+#include <linux/vfio_pci_private.h>
 
 #ifdef __LITTLE_ENDIAN
 #define vfio_ioread64	ioread64
diff --git a/include/linux/vfio_pci_private.h b/include/linux/vfio_pci_private.h
new file mode 100644
index 0000000..562b7c1
--- /dev/null
+++ b/include/linux/vfio_pci_private.h
@@ -0,0 +1,228 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * Derived from original vfio:
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ */
+
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/irqbypass.h>
+#include <linux/types.h>
+
+#ifndef VFIO_PCI_PRIVATE_H
+#define VFIO_PCI_PRIVATE_H
+
+#define VFIO_PCI_OFFSET_SHIFT   40
+
+#define VFIO_PCI_OFFSET_TO_INDEX(off)	(off >> VFIO_PCI_OFFSET_SHIFT)
+#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
+#define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
+
+/* Special capability IDs predefined access */
+#define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
+#define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
+
+/* Cap maximum number of ioeventfds per device (arbitrary) */
+#define VFIO_PCI_IOEVENTFD_MAX		1000
+
+struct vfio_pci_ioeventfd {
+	struct list_head	next;
+	struct virqfd		*virqfd;
+	void __iomem		*addr;
+	uint64_t		data;
+	loff_t			pos;
+	int			bar;
+	int			count;
+};
+
+struct vfio_pci_irq_ctx {
+	struct eventfd_ctx	*trigger;
+	struct virqfd		*unmask;
+	struct virqfd		*mask;
+	char			*name;
+	bool			masked;
+	struct irq_bypass_producer	producer;
+};
+
+struct vfio_pci_device;
+struct vfio_pci_region;
+
+struct vfio_pci_regops {
+	size_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
+		      size_t count, loff_t *ppos, bool iswrite);
+	void	(*release)(struct vfio_pci_device *vdev,
+			   struct vfio_pci_region *region);
+	int	(*mmap)(struct vfio_pci_device *vdev,
+			struct vfio_pci_region *region,
+			struct vm_area_struct *vma);
+	int	(*add_capability)(struct vfio_pci_device *vdev,
+				  struct vfio_pci_region *region,
+				  struct vfio_info_cap *caps);
+};
+
+struct vfio_pci_region {
+	u32				type;
+	u32				subtype;
+	const struct vfio_pci_regops	*ops;
+	void				*data;
+	size_t				size;
+	u32				flags;
+};
+
+struct vfio_pci_dummy_resource {
+	struct resource		resource;
+	int			index;
+	struct list_head	res_next;
+};
+
+struct vfio_pci_reflck {
+	struct kref		kref;
+	struct mutex		lock;
+};
+
+struct vfio_pci_device {
+	struct pci_dev		*pdev;
+	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
+	bool			bar_mmap_supported[PCI_STD_RESOURCE_END + 1];
+	u8			*pci_config_map;
+	u8			*vconfig;
+	struct perm_bits	*msi_perm;
+	spinlock_t		irqlock;
+	struct mutex		igate;
+	struct vfio_pci_irq_ctx	*ctx;
+	int			num_ctx;
+	int			irq_type;
+	int			num_regions;
+	struct vfio_pci_region	*region;
+	u8			msi_qmax;
+	u8			msix_bar;
+	u16			msix_size;
+	u32			msix_offset;
+	u32			rbar[7];
+	bool			pci_2_3;
+	bool			virq_disabled;
+	bool			reset_works;
+	bool			extended_caps;
+	bool			bardirty;
+	bool			has_vga;
+	bool			needs_reset;
+	bool			nointx;
+	bool			needs_pm_restore;
+	struct pci_saved_state	*pci_saved_state;
+	struct pci_saved_state	*pm_save;
+	struct vfio_pci_reflck	*reflck;
+	int			refcnt;
+	int			ioeventfds_nr;
+	struct eventfd_ctx	*err_trigger;
+	struct eventfd_ctx	*req_trigger;
+	struct list_head	dummy_resources_list;
+	struct mutex		ioeventfds_lock;
+	struct list_head	ioeventfds_list;
+	bool			nointxmask;
+#ifdef CONFIG_VFIO_PCI_VGA
+	bool			disable_vga;
+#endif
+	bool			disable_idle_d3;
+};
+
+#define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
+#define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
+#define is_msix(vdev) (vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
+#define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
+#define irq_is(vdev, type) (vdev->irq_type == type)
+
+extern const struct pci_error_handlers vfio_pci_err_handlers;
+
+static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
+{
+	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
+}
+
+static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
+{
+#ifdef CONFIG_VFIO_PCI_VGA
+	return vdev->disable_vga;
+#else
+	return true;
+#endif
+}
+
+extern void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
+				bool nointxmask, bool disable_idle_d3);
+
+extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
+extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
+
+extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
+				   uint32_t flags, unsigned index,
+				   unsigned start, unsigned count, void *data);
+
+extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
+				  char __user *buf, size_t count,
+				  loff_t *ppos, bool iswrite);
+
+extern ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite);
+
+extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite);
+
+extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
+			       uint64_t data, int count, int fd);
+
+extern int vfio_pci_init_perm_bits(void);
+extern void vfio_pci_uninit_perm_bits(void);
+
+extern int vfio_config_init(struct vfio_pci_device *vdev);
+extern void vfio_config_free(struct vfio_pci_device *vdev);
+
+extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
+					unsigned int type, unsigned int subtype,
+					const struct vfio_pci_regops *ops,
+					size_t size, u32 flags, void *data);
+
+extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
+				    pci_power_t state);
+extern unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga);
+extern int vfio_pci_enable(struct vfio_pci_device *vdev);
+extern void vfio_pci_disable(struct vfio_pci_device *vdev);
+extern long vfio_pci_ioctl(void *device_data,
+			unsigned int cmd, unsigned long arg);
+extern ssize_t vfio_pci_read(void *device_data, char __user *buf,
+			size_t count, loff_t *ppos);
+extern ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+			size_t count, loff_t *ppos);
+extern int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma);
+extern void vfio_pci_request(void *device_data, unsigned int count);
+extern void vfio_pci_fill_ids(char *ids, struct pci_driver *driver);
+extern int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
+extern void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
+extern void vfio_pci_probe_power_state(struct vfio_pci_device *vdev);
+
+#ifdef CONFIG_VFIO_PCI_IGD
+extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
+#else
+static inline int vfio_pci_igd_init(struct vfio_pci_device *vdev)
+{
+	return -ENODEV;
+}
+#endif
+#ifdef CONFIG_VFIO_PCI_NVLINK2
+extern int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev);
+extern int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev);
+#else
+static inline int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
+{
+	return -ENODEV;
+}
+
+static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
+{
+	return -ENODEV;
+}
+#endif
+#endif /* VFIO_PCI_PRIVATE_H */
diff --git a/samples/Makefile b/samples/Makefile
index 7d6e4ca..a5f8867 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -19,4 +19,5 @@ obj-$(CONFIG_SAMPLE_TRACE_EVENTS)	+= trace_events/
 obj-$(CONFIG_SAMPLE_TRACE_PRINTK)	+= trace_printk/
 obj-$(CONFIG_VIDEO_PCI_SKELETON)	+= v4l/
 obj-y					+= vfio-mdev/
+obj-y					+= vfio-mdev-pci/
 subdir-$(CONFIG_SAMPLE_VFS)		+= vfs
diff --git a/samples/vfio-mdev-pci/Makefile b/samples/vfio-mdev-pci/Makefile
new file mode 100644
index 0000000..41b2139
--- /dev/null
+++ b/samples/vfio-mdev-pci/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+vfio-mdev-pci-y := vfio_mdev_pci.o
+
+obj-$(CONFIG_SAMPLE_VFIO_MDEV_PCI) += vfio-mdev-pci.o
diff --git a/samples/vfio-mdev-pci/vfio_mdev_pci.c b/samples/vfio-mdev-pci/vfio_mdev_pci.c
new file mode 100644
index 0000000..e433b0a
--- /dev/null
+++ b/samples/vfio-mdev-pci/vfio_mdev_pci.c
@@ -0,0 +1,421 @@
+/*
+ * Copyright (c) 2019 Intel Corporation.
+ *     Author: Liu Yi L <yi.l.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Derived from original vfio_pci.c:
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * Derived from original vfio:
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vgaarb.h>
+#include <linux/nospec.h>
+#include <linux/mdev.h>
+
+#include <linux/vfio_pci_private.h>
+
+#define DRIVER_VERSION  "0.1"
+#define DRIVER_AUTHOR   "Liu Yi L <yi.l.liu@intel.com>"
+#define DRIVER_DESC     "VFIO Mdev PCI - Sample driver for PCI device as a mdev"
+
+#define VFIO_MDEV_PCI_NAME  "vfio-mdev-pci"
+
+static char ids[1024] __initdata;
+module_param_string(ids, ids, sizeof(ids), 0);
+MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio-mdev-pci driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
+
+static bool nointxmask;
+module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(nointxmask,
+		  "Disable support for PCI 2.3 style INTx masking.  If this resolves problems for specific devices, report lspci -vvvxxx to linux-pci@vger.kernel.org so the device can be fixed automatically via the broken_intx_masking flag.");
+
+#ifdef CONFIG_VFIO_PCI_VGA
+static bool disable_vga;
+module_param(disable_vga, bool, S_IRUGO);
+MODULE_PARM_DESC(disable_vga, "Disable VGA resource access through vfio-mdev-pci");
+#endif
+
+static bool disable_idle_d3;
+module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(disable_idle_d3,
+		 "Disable using the PCI D3 low power state for idle, unused devices");
+
+static struct pci_driver vfio_mdev_pci_driver;
+
+struct vfio_mdev_pci_device {
+	struct vfio_pci_device vdev;
+	struct mdev_parent_ops ops;
+	struct attribute_group *groups[2];
+	struct attribute_group attr;
+	atomic_t avail;
+};
+
+static ssize_t
+available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	struct vfio_mdev_pci_device *vmdev;
+
+	vmdev = pci_get_drvdata(to_pci_dev(dev));
+
+	return sprintf(buf, "%d\n", atomic_read(&vmdev->avail));
+}
+
+MDEV_TYPE_ATTR_RO(available_instances);
+
+static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
+		char *buf)
+{
+	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
+}
+
+MDEV_TYPE_ATTR_RO(device_api);
+
+static struct attribute *vfio_mdev_pci_types_attrs[] = {
+	&mdev_type_attr_device_api.attr,
+	&mdev_type_attr_available_instances.attr,
+	NULL,
+};
+
+struct vfio_mdev_pci {
+	struct vfio_pci_device *vdev;
+	struct mdev_device *mdev;
+};
+
+static int vfio_mdev_pci_create(struct kobject *kobj, struct mdev_device *mdev)
+{
+	struct device *pdev;
+	struct vfio_mdev_pci_device *vmdev;
+	struct vfio_mdev_pci *pmdev;
+	int ret;
+
+	pdev = mdev_parent_dev(mdev);
+	vmdev = dev_get_drvdata(pdev);
+
+	if (atomic_dec_if_positive(&vmdev->avail) < 0)
+		return -ENOSPC;
+
+	pmdev = kzalloc(sizeof(struct vfio_mdev_pci), GFP_KERNEL);
+	if (!pmdev) {
+		atomic_inc(&vmdev->avail);
+		return -ENOMEM;
+	}
+
+	pmdev->mdev = mdev;
+	pmdev->vdev = &vmdev->vdev;
+	mdev_set_drvdata(mdev, pmdev);
+	ret = mdev_set_iommu_device(mdev_dev(mdev), pdev);
+	if (ret) {
+		pr_info("%s, failed to config iommu isolation for mdev: %s on pf: %s\n",
+			__func__, dev_name(mdev_dev(mdev)), dev_name(pdev));
+		kfree(pmdev);
+		atomic_inc(&vmdev->avail);
+		return ret;
+	}
+
+	pr_info("%s, creation succeeded for mdev: %s\n", __func__,
+		     dev_name(mdev_dev(mdev)));
+	return 0;
+}
+
+static int vfio_mdev_pci_remove(struct mdev_device *mdev)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+	struct vfio_mdev_pci_device *vmdev;
+
+	vmdev = container_of(pmdev->vdev, struct vfio_mdev_pci_device, vdev);
+
+	kfree(pmdev);
+	atomic_inc(&vmdev->avail);
+	pr_info("%s, succeeded for mdev: %s\n", __func__,
+		     dev_name(mdev_dev(mdev)));
+
+	return 0;
+}
+
+static int vfio_mdev_pci_open(struct mdev_device *mdev)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+	struct vfio_pci_device *vdev = pmdev->vdev;
+	int ret = 0;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	vfio_pci_refresh_config(vdev, nointxmask, disable_idle_d3);
+
+	mutex_lock(&vdev->reflck->lock);
+
+	if (!vdev->refcnt) {
+		ret = vfio_pci_enable(vdev);
+		if (ret)
+			goto error;
+
+		vfio_spapr_pci_eeh_open(vdev->pdev);
+	}
+	vdev->refcnt++;
+error:
+	mutex_unlock(&vdev->reflck->lock);
+	if (!ret)
+		pr_info("Succeeded to open mdev: %s on pf: %s\n",
+		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
+	else {
+		pr_info("Failed to open mdev: %s on pf: %s\n",
+		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
+		module_put(THIS_MODULE);
+	}
+	return ret;
+}
+
+static void vfio_mdev_pci_release(struct mdev_device *mdev)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+	struct vfio_pci_device *vdev = pmdev->vdev;
+
+	pr_info("Release mdev: %s on pf: %s\n",
+		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
+
+	mutex_lock(&vdev->reflck->lock);
+
+	if (!(--vdev->refcnt)) {
+		vfio_spapr_pci_eeh_release(vdev->pdev);
+		vfio_pci_disable(vdev);
+	}
+
+	mutex_unlock(&vdev->reflck->lock);
+
+	module_put(THIS_MODULE);
+}
+
+static long vfio_mdev_pci_ioctl(struct mdev_device *mdev, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+
+	return vfio_pci_ioctl(pmdev->vdev, cmd, arg);
+}
+
+static int vfio_mdev_pci_mmap(struct mdev_device *mdev,
+				struct vm_area_struct *vma)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+
+	return vfio_pci_mmap(pmdev->vdev, vma);
+}
+
+static ssize_t vfio_mdev_pci_read(struct mdev_device *mdev, char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+
+	return vfio_pci_read(pmdev->vdev, buf, count, ppos);
+}
+
+static ssize_t vfio_mdev_pci_write(struct mdev_device *mdev,
+				const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+
+	return vfio_pci_write(pmdev->vdev, (char __user *)buf, count, ppos);
+}
+
+static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
+				       const struct pci_device_id *id)
+{
+	struct vfio_mdev_pci_device *vmdev;
+	struct vfio_pci_device *vdev;
+	const struct mdev_parent_ops *ops;
+	int ret;
+
+	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
+		return -EINVAL;
+
+	/*
+	 * Prevent binding to PFs with VFs enabled, this too easily allows
+	 * userspace instance with VFs and PFs from the same device, which
+	 * cannot work.  Disabling SR-IOV here would initiate removing the
+	 * VFs, which would unbind the driver, which is prone to blocking
+	 * if that VF is also in use by vfio-pci or vfio-mdev-pci. Just
+	 * reject these PFs and let the user sort it out.
+	 */
+	if (pci_num_vf(pdev)) {
+		pci_warn(pdev, "Cannot bind to PF with SR-IOV enabled\n");
+		return -EBUSY;
+	}
+
+	vmdev = kzalloc(sizeof(*vmdev), GFP_KERNEL);
+	if (!vmdev)
+		return -ENOMEM;
+
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
+	vdev->pdev = pdev;
+	vdev->irq_type = VFIO_PCI_NUM_IRQS;
+	mutex_init(&vdev->igate);
+	spin_lock_init(&vdev->irqlock);
+	mutex_init(&vdev->ioeventfds_lock);
+	INIT_LIST_HEAD(&vdev->ioeventfds_list);
+	vdev->nointxmask = nointxmask;
+#ifdef CONFIG_VFIO_PCI_VGA
+	vdev->disable_vga = disable_vga;
+#endif
+	vdev->disable_idle_d3 = disable_idle_d3;
+
+	pci_set_drvdata(pdev, vmdev);
+
+	ret = vfio_pci_reflck_attach(vdev);
+	if (ret) {
+		pci_set_drvdata(pdev, NULL);
+		kfree(vdev);
+		return ret;
+	}
+
+	if (vfio_pci_is_vga(pdev)) {
+		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
+		vga_set_legacy_decoding(pdev,
+					vfio_pci_set_vga_decode(vdev, false));
+	}
+
+	vfio_pci_probe_power_state(vdev);
+
+	if (!vdev->disable_idle_d3) {
+		/*
+		 * pci-core sets the device power state to an unknown value at
+		 * bootup and after being removed from a driver.  The only
+		 * transition it allows from this unknown state is to D0, which
+		 * typically happens when a driver calls pci_enable_device().
+		 * We're not ready to enable the device yet, but we do want to
+		 * be able to get to D3.  Therefore first do a D0 transition
+		 * before going to D3.
+		 */
+		vfio_pci_set_power_state(vdev, PCI_D0);
+		vfio_pci_set_power_state(vdev, PCI_D3hot);
+	}
+
+	ret = mdev_register_device(&pdev->dev, ops);
+	if (ret)
+		pr_err("Cannot register mdev for device %s\n",
+			dev_name(&pdev->dev));
+	else
+		pr_info("Wrap device %s as a mdev\n", dev_name(&pdev->dev));
+
+	return ret;
+}
+
+static void vfio_mdev_pci_driver_remove(struct pci_dev *pdev)
+{
+	struct vfio_mdev_pci_device *vmdev;
+	struct vfio_pci_device *vdev;
+
+	mdev_unregister_device(&pdev->dev);
+
+	vmdev = pci_get_drvdata(pdev);
+	if (!vmdev)
+		return;
+
+	vdev = &vmdev->vdev;
+
+	vfio_pci_reflck_put(vdev->reflck);
+
+	kfree(vdev->region);
+	mutex_destroy(&vdev->ioeventfds_lock);
+
+	if (!disable_idle_d3)
+		vfio_pci_set_power_state(vdev, PCI_D0);
+
+	kfree(vdev->pm_save);
+
+	if (vfio_pci_is_vga(pdev)) {
+		vga_client_register(pdev, NULL, NULL, NULL);
+		vga_set_legacy_decoding(pdev,
+				VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
+				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
+	}
+
+	kfree(vmdev->attr.name);
+	kfree(vmdev);
+}
+
+static struct pci_driver vfio_mdev_pci_driver = {
+	.name		= VFIO_MDEV_PCI_NAME,
+	.id_table	= NULL, /* only dynamic ids */
+	.probe		= vfio_mdev_pci_driver_probe,
+	.remove		= vfio_mdev_pci_driver_remove,
+	.err_handler	= &vfio_pci_err_handlers,
+};
+
+static void __exit vfio_mdev_pci_cleanup(void)
+{
+	pci_unregister_driver(&vfio_mdev_pci_driver);
+}
+
+static int __init vfio_mdev_pci_init(void)
+{
+	int ret;
+
+	/* Register and scan for devices */
+	ret = pci_register_driver(&vfio_mdev_pci_driver);
+	if (ret)
+		return ret;
+
+	vfio_pci_fill_ids(ids, &vfio_mdev_pci_driver);
+
+	return 0;
+}
+
+module_init(vfio_mdev_pci_init);
+module_exit(vfio_mdev_pci_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
-- 
2.7.4

