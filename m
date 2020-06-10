Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E3A1F50B4
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 11:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgFJJAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 05:00:06 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:36642 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbgFJJAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 05:00:05 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B381C58EB9EE35D5898C;
        Wed, 10 Jun 2020 17:00:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.213) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 10 Jun 2020
 16:59:55 +0800
Subject: Re: [RFC PATCH v4 08/10] i40e/vf_migration: VF live migration -
 pass-through VF first
To:     Yan Zhao <yan.y.zhao@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <kevin.tian@intel.com>, <shaopeng.he@intel.com>,
        <yi.l.liu@intel.com>, <xin.zeng@intel.com>, <hang.yuan@intel.com>,
        Wang Haibin <wanghaibin.wang@huawei.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
 <20200518025316.14491-1-yan.y.zhao@intel.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <e45d5bb6-6f15-dd4d-6de2-478b36f88069@huawei.com>
Date:   Wed, 10 Jun 2020 16:59:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20200518025316.14491-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.213]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yan,

few nits below...

On 2020/5/18 10:53, Yan Zhao wrote:
> This driver intercepts all device operations as long as it's probed
> successfully by vfio-pci driver.
> 
> It will process regions and irqs of its interest and then forward
> operations to default handlers exported from vfio pci if it wishes to.
> 
> In this patch, this driver does nothing but pass through VFs to guest
> by calling to exported handlers from driver vfio-pci.
> 
> Cc: Shaopeng He <shaopeng.he@intel.com>
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/net/ethernet/intel/Kconfig            |  10 ++
>  drivers/net/ethernet/intel/i40e/Makefile      |   2 +
>  .../ethernet/intel/i40e/i40e_vf_migration.c   | 165 ++++++++++++++++++
>  .../ethernet/intel/i40e/i40e_vf_migration.h   |  59 +++++++
>  4 files changed, 236 insertions(+)
>  create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
>  create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
> 
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index ad34e4335df2..31780d9a59f1 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -264,6 +264,16 @@ config I40E_DCB
>  
>  	  If unsure, say N.
>  
> +config I40E_VF_MIGRATION
> +	tristate "XL710 Family VF live migration support -- loadable modules only"
> +	depends on I40E && VFIO_PCI && m
> +	help
> +	  Say m if you want to enable live migration of
> +	  Virtual Functions of Intel(R) Ethernet Controller XL710
> +	  Family of devices. It must be a module.
> +	  This module serves as vendor module of module vfio_pci.
> +	  VFs bind to module vfio_pci directly.
> +
>  # this is here to allow seamless migration from I40EVF --> IAVF name
>  # so that CONFIG_IAVF symbol will always mirror the state of CONFIG_I40EVF
>  config IAVF
> diff --git a/drivers/net/ethernet/intel/i40e/Makefile b/drivers/net/ethernet/intel/i40e/Makefile
> index 2f21b3e89fd0..b80c224c2602 100644
> --- a/drivers/net/ethernet/intel/i40e/Makefile
> +++ b/drivers/net/ethernet/intel/i40e/Makefile
> @@ -27,3 +27,5 @@ i40e-objs := i40e_main.o \
>  	i40e_xsk.o
>  
>  i40e-$(CONFIG_I40E_DCB) += i40e_dcb.o i40e_dcb_nl.o
> +
> +obj-$(CONFIG_I40E_VF_MIGRATION) += i40e_vf_migration.o
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
> new file mode 100644
> index 000000000000..96026dcf5c9d
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
> @@ -0,0 +1,165 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2013 - 2019 Intel Corporation. */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/vfio.h>
> +#include <linux/pci.h>
> +#include <linux/eventfd.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/sysfs.h>
> +#include <linux/file.h>
> +#include <linux/pci.h>
> +
> +#include "i40e.h"
> +#include "i40e_vf_migration.h"
> +
> +#define VERSION_STRING  "0.1"
> +#define DRIVER_AUTHOR   "Intel Corporation"
> +
> +static int i40e_vf_open(void *device_data)
> +{
> +	struct i40e_vf_migration *i40e_vf_dev =
> +		vfio_pci_vendor_data(device_data);
> +	int ret;
> +	struct vfio_device_migration_info *mig_ctl = NULL;
> +

"mig_ctl" is not used in this function. Shouldn't this declaration be
put into the next patch?

> +	if (!try_module_get(THIS_MODULE))
> +		return -ENODEV;
> +
> +	mutex_lock(&i40e_vf_dev->reflock);
> +	if (!i40e_vf_dev->refcnt) {
> +		vfio_pci_set_vendor_regions(device_data, 0);
> +		vfio_pci_set_vendor_irqs(device_data, 0);
> +	}
> +
> +	ret = vfio_pci_open(device_data);
> +	if (ret)
> +		goto error;
> +
> +	i40e_vf_dev->refcnt++;
> +	mutex_unlock(&i40e_vf_dev->reflock);
> +	return 0;
> +error:
> +	if (!i40e_vf_dev->refcnt) {
> +		vfio_pci_set_vendor_regions(device_data, 0);
> +		vfio_pci_set_vendor_irqs(device_data, 0);
> +	}
> +	module_put(THIS_MODULE);
> +	mutex_unlock(&i40e_vf_dev->reflock);
> +	return ret;
> +}
> +
> +void i40e_vf_release(void *device_data)
> +{
> +	struct i40e_vf_migration *i40e_vf_dev =
> +		vfio_pci_vendor_data(device_data);
> +
> +	mutex_lock(&i40e_vf_dev->reflock);
> +	if (!--i40e_vf_dev->refcnt) {
> +		vfio_pci_set_vendor_regions(device_data, 0);
> +		vfio_pci_set_vendor_irqs(device_data, 0);
> +	}
> +	vfio_pci_release(device_data);
> +	mutex_unlock(&i40e_vf_dev->reflock);
> +	module_put(THIS_MODULE);
> +}
> +
> +static long i40e_vf_ioctl(void *device_data,
> +			  unsigned int cmd, unsigned long arg)
> +{
> +	return vfio_pci_ioctl(device_data, cmd, arg);
> +}
> +
> +static ssize_t i40e_vf_read(void *device_data, char __user *buf,
> +			    size_t count, loff_t *ppos)
> +{
> +	return vfio_pci_read(device_data, buf, count, ppos);
> +}
> +
> +static ssize_t i40e_vf_write(void *device_data, const char __user *buf,
> +			     size_t count, loff_t *ppos)
> +{
> +	return vfio_pci_write(device_data, buf, count, ppos);
> +}
> +
> +static int i40e_vf_mmap(void *device_data, struct vm_area_struct *vma)
> +{
> +	return vfio_pci_mmap(device_data, vma);
> +}
> +
> +static void i40e_vf_request(void *device_data, unsigned int count)
> +{
> +	vfio_pci_request(device_data, count);
> +}
> +
> +static struct vfio_device_ops i40e_vf_device_ops_node = {
> +	.name		= "i40e_vf",
> +	.open		= i40e_vf_open,
> +	.release	= i40e_vf_release,
> +	.ioctl		= i40e_vf_ioctl,
> +	.read		= i40e_vf_read,
> +	.write		= i40e_vf_write,
> +	.mmap		= i40e_vf_mmap,
> +	.request	= i40e_vf_request,
> +};
> +
> +void *i40e_vf_probe(struct pci_dev *pdev)
> +{
> +	struct i40e_vf_migration *i40e_vf_dev = NULL;
> +	struct pci_dev *pf_dev, *vf_dev;
> +	struct i40e_pf *pf;
> +	struct i40e_vf *vf;
> +	unsigned int vf_devfn, devfn;
> +	int vf_id = -1;
> +	int i;
> +
> +	pf_dev = pdev->physfn;
> +	pf = pci_get_drvdata(pf_dev);
> +	vf_dev = pdev;
> +	vf_devfn = vf_dev->devfn;
> +
> +	for (i = 0; i < pci_num_vf(pf_dev); i++) {
> +		devfn = (pf_dev->devfn + pf_dev->sriov->offset +
> +			 pf_dev->sriov->stride * i) & 0xff;
> +		if (devfn == vf_devfn) {
> +			vf_id = i;
> +			break;
> +		}
> +	}
> +
> +	if (vf_id == -1)
> +		return ERR_PTR(-EINVAL);
> +
> +	i40e_vf_dev = kzalloc(sizeof(*i40e_vf_dev), GFP_KERNEL);
> +
> +	if (!i40e_vf_dev)
> +		return ERR_PTR(-ENOMEM);
> +
> +	i40e_vf_dev->vf_id = vf_id;
> +	i40e_vf_dev->vf_vendor = pdev->vendor;
> +	i40e_vf_dev->vf_device = pdev->device;
> +	i40e_vf_dev->pf_dev = pf_dev;
> +	i40e_vf_dev->vf_dev = vf_dev;
> +	mutex_init(&i40e_vf_dev->reflock);
> +
> +	vf = &pf->vf[vf_id];
> +

"vf" is also not used in this function...

> +	return i40e_vf_dev;
> +}
> +
> +static void i40e_vf_remove(void *vendor_data)
> +{
> +	kfree(vendor_data);
> +}
> +
> +#define i40e_vf_device_ops (&i40e_vf_device_ops_node)
> +module_vfio_pci_register_vendor_handler("I40E VF", i40e_vf_probe,
> +					i40e_vf_remove, i40e_vf_device_ops);
> +
> +MODULE_ALIAS("vfio-pci:8086-154c");
> +MODULE_LICENSE("GPL v2");
> +MODULE_INFO(supported, "Vendor driver of vfio pci to support VF live migration");
> +MODULE_VERSION(VERSION_STRING);
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
> new file mode 100644
> index 000000000000..696d40601ec3
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2013 - 2019 Intel Corporation. */
> +
> +#ifndef I40E_MIG_H
> +#define I40E_MIG_H
> +
> +#include <linux/pci.h>
> +#include <linux/vfio.h>
> +#include <linux/mdev.h>
> +
> +#include "i40e.h"
> +#include "i40e_txrx.h"
> +
> +/* helper macros copied from vfio-pci */
> +#define VFIO_PCI_OFFSET_SHIFT   40
> +#define VFIO_PCI_OFFSET_TO_INDEX(off)   ((off) >> VFIO_PCI_OFFSET_SHIFT)
> +#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
> +#define VFIO_PCI_OFFSET_MASK    (((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
> +
> +/* Single Root I/O Virtualization */
> +struct pci_sriov {
> +	int		pos;		/* Capability position */
> +	int		nres;		/* Number of resources */
> +	u32		cap;		/* SR-IOV Capabilities */
> +	u16		ctrl;		/* SR-IOV Control */
> +	u16		total_VFs;	/* Total VFs associated with the PF */
> +	u16		initial_VFs;	/* Initial VFs associated with the PF */
> +	u16		num_VFs;	/* Number of VFs available */
> +	u16		offset;		/* First VF Routing ID offset */
> +	u16		stride;		/* Following VF stride */
> +	u16		vf_device;	/* VF device ID */
> +	u32		pgsz;		/* Page size for BAR alignment */
> +	u8		link;		/* Function Dependency Link */
> +	u8		max_VF_buses;	/* Max buses consumed by VFs */
> +	u16		driver_max_VFs;	/* Max num VFs driver supports */
> +	struct pci_dev	*dev;		/* Lowest numbered PF */
> +	struct pci_dev	*self;		/* This PF */
> +	u32		cfg_size;	/* VF config space size */
> +	u32		class;		/* VF device */
> +	u8		hdr_type;	/* VF header type */
> +	u16		subsystem_vendor; /* VF subsystem vendor */
> +	u16		subsystem_device; /* VF subsystem device */
> +	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
> +	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
> +};
> +

Can "struct pci_sriov" be extracted for common use? This should not be exclusive
for "i40e_vf migration support".

> +struct i40e_vf_migration {
> +	__u32				vf_vendor;
> +	__u32				vf_device;
> +	__u32				handle;
> +	struct pci_dev			*pf_dev;
> +	struct pci_dev			*vf_dev;
> +	int				vf_id;
> +	int				refcnt;
> +	struct				mutex reflock; /*mutex protect refcnt */
                                                        ^                    ^

stray ' '

> +};
> +
> +#endif /* I40E_MIG_H */
> +
> 

-- 
Thanks,
Xiang

