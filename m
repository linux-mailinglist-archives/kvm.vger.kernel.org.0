Return-Path: <kvm+bounces-3034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F57A7FFE56
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 23:10:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 869F5B20B2B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 22:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBFF361FA4;
	Thu, 30 Nov 2023 22:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZloRHaVu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FF810DF
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 14:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701382230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pvwjNJIMaOIpO5fNXUSb1JhcPf0PO98uaIi6VTTl8xI=;
	b=ZloRHaVu0GbWf5XS/PfZAt9MlZcYpa42P4Zun6mqfNDGiseNLFtCMFDoGrlhik/leYZvQ0
	JrFOX7RGIflLnU65cuG3P/7hHeIOagc5DizsEcdxsE9LmuiG5r0/xPk7pqGczaPqC6lawV
	rrQgRNWpFNVq4/5dzEjx+TEg2LmYmVo=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-Q4C0uV1kNom2sug4vo5B2w-1; Thu, 30 Nov 2023 17:10:29 -0500
X-MC-Unique: Q4C0uV1kNom2sug4vo5B2w-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7b37e9c600cso141736639f.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 14:10:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701382228; x=1701987028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvwjNJIMaOIpO5fNXUSb1JhcPf0PO98uaIi6VTTl8xI=;
        b=pmecgdmANjy57t5/VkL7D0zQDIXA3AWcsOuOcgUS2ouJCvA+G0edMNoO5MSo0+DzgV
         qzyHWUZViSicXum2qcNhxlPP1hv99YV0ZGEWQe6VnTcwonj3PBJJvGv8OrTTlrr2MzTD
         +XofzBpEAUBoJgVSMbIiN4JSfn36OOMAMND0GHEnjdWtAhfEVs2HADl1gq6RpqApNAly
         JGvXcyAg5ZhU4tdAhaHXoZxG6bTKUB2zomsi/H1ce7cynHgf0QRVY8N0ktMUp+igrh06
         wmzCYQ/4cTEHOEagKcUPi44fyNOdOacembV0qHJhcndQh7r7FJilwSuycWBdmchXAmf7
         N0/g==
X-Gm-Message-State: AOJu0YykxikvmAi12IuDrc+pcIe2Wvg7Lrq8K4MgyIXnzMmuVJR27otI
	IwtV7defWpb0mS5clziJJ9sKAWENAaivA2iS7Jzn7OrjvTm9178NpcP933wxrmlq+bwfIEq/9TD
	tIv2x418O7DsV
X-Received: by 2002:a05:6602:2259:b0:7a9:529d:4b79 with SMTP id o25-20020a056602225900b007a9529d4b79mr23012185ioo.21.1701382228475;
        Thu, 30 Nov 2023 14:10:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IETNMhsNgLKABtUi2zTcdNTTaJjXnSM99gB5zuE8h4+dIyZ3P6Uyb/9acz8+XGfAeYx2vPcnQ==
X-Received: by 2002:a05:6602:2259:b0:7a9:529d:4b79 with SMTP id o25-20020a056602225900b007a9529d4b79mr23012149ioo.21.1701382227914;
        Thu, 30 Nov 2023 14:10:27 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id s18-20020a02c512000000b00466dad8a78fsm519983jam.87.2023.11.30.14.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 14:10:27 -0800 (PST)
Date: Thu, 30 Nov 2023 15:10:25 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
 <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
 <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V4 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231130151025.045bdddf.alex.williamson@redhat.com>
In-Reply-To: <20231129143746.6153-10-yishaih@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
	<20231129143746.6153-10-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Nov 2023 16:37:46 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Introduce a vfio driver over virtio devices to support the legacy
> interface functionality for VFs.
> 
> Background, from the virtio spec [1].
> --------------------------------------------------------------------
> In some systems, there is a need to support a virtio legacy driver with
> a device that does not directly support the legacy interface. In such
> scenarios, a group owner device can provide the legacy interface
> functionality for the group member devices. The driver of the owner
> device can then access the legacy interface of a member device on behalf
> of the legacy member device driver.
> 
> For example, with the SR-IOV group type, group members (VFs) can not
> present the legacy interface in an I/O BAR in BAR0 as expected by the
> legacy pci driver. If the legacy driver is running inside a virtual
> machine, the hypervisor executing the virtual machine can present a
> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
> legacy driver accesses to this I/O BAR and forwards them to the group
> owner device (PF) using group administration commands.
> --------------------------------------------------------------------
> 
> Specifically, this driver adds support for a virtio-net VF to be exposed
> as a transitional device to a guest driver and allows the legacy IO BAR
> functionality on top.
> 
> This allows a VM which uses a legacy virtio-net driver in the guest to
> work transparently over a VF which its driver in the host is that new
> driver.
> 
> The driver can be extended easily to support some other types of virtio
> devices (e.g virtio-blk), by adding in a few places the specific type
> properties as was done for virtio-net.
> 
> For now, only the virtio-net use case was tested and as such we introduce
> the support only for such a device.
> 
> Practically,
> Upon probing a VF for a virtio-net device, in case its PF supports
> legacy access over the virtio admin commands and the VF doesn't have BAR
> 0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
> transitional device with I/O BAR in BAR 0.
> 
> The existence of the simulated I/O bar is reported later on by
> overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
> exposes itself as a transitional device by overwriting some properties
> upon reading its config space.
> 
> Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
> guest may use it via read/write calls according to the virtio
> specification.
> 
> Any read/write towards the control parts of the BAR will be captured by
> the new driver and will be translated into admin commands towards the
> device.
> 
> Any data path read/write access (i.e. virtio driver notifications) will
> be forwarded to the physical BAR which its properties were supplied by
> the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
> probing/init flow.
> 
> With that code in place a legacy driver in the guest has the look and
> feel as if having a transitional device with legacy support for both its
> control and data path flows.
> 
> [1]
> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  MAINTAINERS                      |   7 +
>  drivers/vfio/pci/Kconfig         |   2 +
>  drivers/vfio/pci/Makefile        |   2 +
>  drivers/vfio/pci/virtio/Kconfig  |  16 +
>  drivers/vfio/pci/virtio/Makefile |   4 +
>  drivers/vfio/pci/virtio/main.c   | 554 +++++++++++++++++++++++++++++++
>  6 files changed, 585 insertions(+)
>  create mode 100644 drivers/vfio/pci/virtio/Kconfig
>  create mode 100644 drivers/vfio/pci/virtio/Makefile
>  create mode 100644 drivers/vfio/pci/virtio/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 012df8ccf34e..b246b769092d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22872,6 +22872,13 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/pci/mlx5/
>  
> +VFIO VIRTIO PCI DRIVER
> +M:	Yishai Hadas <yishaih@nvidia.com>
> +L:	kvm@vger.kernel.org
> +L:	virtualization@lists.linux-foundation.org
> +S:	Maintained
> +F:	drivers/vfio/pci/virtio
> +
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
>  R:	Yishai Hadas <yishaih@nvidia.com>
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 8125e5f37832..18c397df566d 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>  
>  source "drivers/vfio/pci/pds/Kconfig"
>  
> +source "drivers/vfio/pci/virtio/Kconfig"
> +
>  endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 45167be462d8..046139a4eca5 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>  
>  obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> +
> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
> new file mode 100644
> index 000000000000..3a6707639220
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/Kconfig
> @@ -0,0 +1,16 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config VIRTIO_VFIO_PCI
> +        tristate "VFIO support for VIRTIO NET PCI devices"
> +        depends on VIRTIO_PCI
> +        select VFIO_PCI_CORE
> +        help
> +          This provides support for exposing VIRTIO NET VF devices which support
> +          legacy IO access, using the VFIO framework that can work with a legacy
> +          virtio driver in the guest.
> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
> +          not indicate I/O Space.
> +          As of that this driver emulated I/O BAR in software to let a VF be
> +          seen as a transitional device in the guest and let it work with
> +          a legacy driver.
> +
> +          If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
> new file mode 100644
> index 000000000000..2039b39fb723
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
> +virtio-vfio-pci-y := main.o
> +
> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
> new file mode 100644
> index 000000000000..3ca19c891673
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/main.c
> @@ -0,0 +1,554 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/pci.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/virtio_pci.h>
> +#include <linux/virtio_net.h>
> +#include <linux/virtio_pci_admin.h>
> +
> +struct virtiovf_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	u8 bar0_virtual_buf_size;

Poor packing here, move it down with notify_bar.

> +	u8 *bar0_virtual_buf;
> +	/* synchronize access to the virtual buf */
> +	struct mutex bar_mutex;
> +	void __iomem *notify_addr;
> +	u64 notify_offset;
> +	__le32 pci_base_addr_0;
> +	__le16 pci_cmd;
> +	u8 notify_bar;
> +};
> +
> +static int
> +virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
> +			     loff_t pos, char __user *buf,
> +			     size_t count, bool read)
> +{
> +	bool msix_enabled =
> +		(virtvdev->core_device.irq_type == VFIO_PCI_MSIX_IRQ_INDEX);

This is racy, the irq_type could change, do we care or does that fall
into poor driver behavior?

> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> +	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
> +	bool common;
> +	u8 offset;
> +	int ret;
> +
> +	common = pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled);

I don't understand virtio, but this looks like it has the effect of the
mac and status fields shifting in IO BAR depending on whether MSIX
is enabled.  Doesn't that give the user access to 4 bytes beyond the
status field?  Is that how it's supposed to work or should we be
dropping accesses to the 4-bytes MSIX support adds when not enabled?

> +	/* offset within the relevant configuration area */
> +	offset = common ? pos : pos - VIRTIO_PCI_CONFIG_OFF(msix_enabled);
> +	mutex_lock(&virtvdev->bar_mutex);
> +	if (read) {
> +		if (common)
> +			ret = virtio_pci_admin_legacy_common_io_read(pdev, offset,
> +					count, bar0_buf + pos);
> +		else
> +			ret = virtio_pci_admin_legacy_device_io_read(pdev, offset,
> +					count, bar0_buf + pos);
> +		if (ret)
> +			goto out;
> +		if (copy_to_user(buf, bar0_buf + pos, count))
> +			ret = -EFAULT;
> +	} else {
> +		if (copy_from_user(bar0_buf + pos, buf, count)) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		if (common)
> +			ret = virtio_pci_admin_legacy_common_io_write(pdev, offset,
> +					count, bar0_buf + pos);
> +		else
> +			ret = virtio_pci_admin_legacy_device_io_write(pdev, offset,
> +					count, bar0_buf + pos);
> +	}
> +out:
> +	mutex_unlock(&virtvdev->bar_mutex);
> +	return ret;
> +}
> +
> +static int
> +translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
> +			    loff_t pos, char __user *buf,
> +			    size_t count, bool read)
> +{
> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
> +	u16 queue_notify;
> +	int ret;
> +
> +	if (pos + count > virtvdev->bar0_virtual_buf_size)
> +		return -EINVAL;
> +
> +	switch (pos) {
> +	case VIRTIO_PCI_QUEUE_NOTIFY:
> +		if (count != sizeof(queue_notify))
> +			return -EINVAL;
> +		if (read) {
> +			ret = vfio_pci_ioread16(core_device, true, &queue_notify,
> +						virtvdev->notify_addr);
> +			if (ret)
> +				return ret;
> +			if (copy_to_user(buf, &queue_notify,
> +					 sizeof(queue_notify)))
> +				return -EFAULT;
> +		} else {
> +			if (copy_from_user(&queue_notify, buf, count))
> +				return -EFAULT;
> +			ret = vfio_pci_iowrite16(core_device, true, queue_notify,
> +						 virtvdev->notify_addr);
> +		}
> +		break;
> +	default:
> +		ret = virtiovf_issue_legacy_rw_cmd(virtvdev, pos, buf, count,
> +						   read);
> +	}
> +
> +	return ret ? ret : count;
> +}
> +
> +static bool range_intersect_range(loff_t range1_start, size_t count1,
> +				  loff_t range2_start, size_t count2,
> +				  loff_t *start_offset,
> +				  size_t *intersect_count,
> +				  size_t *register_offset)
> +{
> +	if (range1_start <= range2_start &&
> +	    range1_start + count1 > range2_start) {
> +		*start_offset = range2_start - range1_start;
> +		*intersect_count = min_t(size_t, count2,
> +					 range1_start + count1 - range2_start);
> +		*register_offset = 0;
> +		return true;
> +	}
> +
> +	if (range1_start > range2_start &&
> +	    range1_start < range2_start + count2) {
> +		*start_offset = 0;
> +		*intersect_count = min_t(size_t, count1,
> +					 range2_start + count2 - range1_start);
> +		*register_offset = range1_start - range2_start;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
> +					char __user *buf, size_t count,
> +					loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	size_t register_offset;
> +	loff_t copy_offset;
> +	size_t copy_count;
> +	__le32 val32;
> +	__le16 val16;
> +	u8 val8;
> +	int ret;
> +
> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
> +	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
> +				   copy_count))
> +			return -EFAULT;
> +		val16 |= cpu_to_le16(PCI_COMMAND_IO);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
> +				 copy_count))
> +			return -EFAULT;
> +	}

Seems like COMMAND_IO survives across reset, pci_cmd is only ever
modified by user writes.

I also don't see that we honor COMMAND_IO for accesses.  Shouldn't reads
return -1 and writes get dropped if COMMAND_IO is cleared?

> +
> +	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		/* Transional needs to have revision 0 */
> +		val8 = 0;
> +		if (copy_to_user(buf + copy_offset, &val8, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		u8 log_bar_size = ilog2(roundup_pow_of_two(virtvdev->bar0_virtual_buf_size));
> +		u32 mask_size = ~((BIT(log_bar_size) - 1));

bar0_virtual_buf_size already needs to be a power-of-2, the size we
report here needs to match the REGION_INFO size, so we should enforce
the size in virtio_vf_pci_init_device().  I think it's 32bytes, so
we're actually good on the size, but the above makes no sense, ie.
rounding a value that's already a power-of-2 to a power-of-2, getting
the log2 size, shifting that back into the size we started with to get
a mask... why isn't it just:

		u32 bar_mask = ~(virtvdev->bar0_virtual_buf_size - 1);
?


> +		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
> +
> +		val32 = cpu_to_le32((pci_base_addr_0 & mask_size) | PCI_BASE_ADDRESS_SPACE_IO);

Looks like what I suggested to Ankit :)

Per our prior variant driver agreement, we're going to need to enlist
another reviewer as well.  Thanks,

Alex

> +		if (copy_to_user(buf + copy_offset, (void *)&val32 + register_offset, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		/*
> +		 * Transitional devices use the PCI subsystem device id as
> +		 * virtio device id, same as legacy driver always did.
> +		 */
> +		val16 = cpu_to_le16(VIRTIO_ID_NET);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
> +				 copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID, sizeof(val16),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
> +				 copy_count))
> +			return -EFAULT;
> +	}
> +
> +	return count;
> +}
> +
> +static ssize_t
> +virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
> +		       size_t count, loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
> +		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
> +
> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
> +		return vfio_pci_core_read(core_vdev, buf, count, ppos);
> +
> +	ret = pm_runtime_resume_and_get(&pdev->dev);
> +	if (ret) {
> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
> +				     ret);
> +		return -EIO;
> +	}
> +
> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
> +	pm_runtime_put(&pdev->dev);
> +	return ret;
> +}
> +
> +static ssize_t
> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
> +		size_t register_offset;
> +		loff_t copy_offset;
> +		size_t copy_count;
> +
> +		if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
> +					  &copy_offset, &copy_count,
> +					  &register_offset)) {
> +			if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
> +					   buf + copy_offset,
> +					   copy_count))
> +				return -EFAULT;
> +		}
> +
> +		if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
> +					  sizeof(virtvdev->pci_base_addr_0),
> +					  &copy_offset, &copy_count,
> +					  &register_offset)) {
> +			if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
> +					   buf + copy_offset,
> +					   copy_count))
> +				return -EFAULT;
> +		}
> +	}
> +
> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
> +		return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +
> +	ret = pm_runtime_resume_and_get(&pdev->dev);
> +	if (ret) {
> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
> +		return -EIO;
> +	}
> +
> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
> +	pm_runtime_put(&pdev->dev);
> +	return ret;
> +}
> +
> +static int
> +virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
> +				   unsigned int cmd, unsigned long arg)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	void __user *uarg = (void __user *)arg;
> +	struct vfio_region_info info = {};
> +
> +	if (copy_from_user(&info, uarg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	switch (info.index) {
> +	case VFIO_PCI_BAR0_REGION_INDEX:
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		info.size = virtvdev->bar0_virtual_buf_size;
> +		info.flags = VFIO_REGION_INFO_FLAG_READ |
> +			     VFIO_REGION_INFO_FLAG_WRITE;
> +		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
> +	default:
> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +	}
> +}
> +
> +static long
> +virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> +			     unsigned long arg)
> +{
> +	switch (cmd) {
> +	case VFIO_DEVICE_GET_REGION_INFO:
> +		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
> +	default:
> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +	}
> +}
> +
> +static int
> +virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
> +{
> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
> +	int ret;
> +
> +	/*
> +	 * Setup the BAR where the 'notify' exists to be used by vfio as well
> +	 * This will let us mmap it only once and use it when needed.
> +	 */
> +	ret = vfio_pci_core_setup_barmap(core_device,
> +					 virtvdev->notify_bar);
> +	if (ret)
> +		return ret;
> +
> +	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
> +			virtvdev->notify_offset;
> +	return 0;
> +}
> +
> +static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	if (virtvdev->bar0_virtual_buf) {
> +		/*
> +		 * Upon close_device() the vfio_pci_core_disable() is called
> +		 * and will close all the previous mmaps, so it seems that the
> +		 * valid life cycle for the 'notify' addr is per open/close.
> +		 */
> +		ret = virtiovf_set_notify_addr(virtvdev);
> +		if (ret) {
> +			vfio_pci_core_disable(vdev);
> +			return ret;
> +		}
> +	}
> +
> +	vfio_pci_core_finish_enable(vdev);
> +	return 0;
> +}
> +
> +static int virtiovf_get_device_config_size(unsigned short device)
> +{
> +	/* Network card */
> +	return offsetofend(struct virtio_net_config, status);
> +}
> +
> +static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
> +{
> +	u64 offset;
> +	int ret;
> +	u8 bar;
> +
> +	ret = virtio_pci_admin_legacy_io_notify_info(virtvdev->core_device.pdev,
> +				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
> +				&bar, &offset);
> +	if (ret)
> +		return ret;
> +
> +	virtvdev->notify_bar = bar;
> +	virtvdev->notify_offset = offset;
> +	return 0;
> +}
> +
> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev;
> +	int ret;
> +
> +	ret = vfio_pci_core_init_dev(core_vdev);
> +	if (ret)
> +		return ret;
> +
> +	pdev = virtvdev->core_device.pdev;
> +	ret = virtiovf_read_notify_info(virtvdev);
> +	if (ret)
> +		return ret;
> +
> +	/* Being ready with a buffer that supports MSIX */
> +	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
> +				virtiovf_get_device_config_size(pdev->device);
> +	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
> +					     GFP_KERNEL);
> +	if (!virtvdev->bar0_virtual_buf)
> +		return -ENOMEM;
> +	mutex_init(&virtvdev->bar_mutex);
> +	return 0;
> +}
> +
> +static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +
> +	kfree(virtvdev->bar0_virtual_buf);
> +	vfio_pci_core_release_dev(core_vdev);
> +}
> +
> +static const struct vfio_device_ops virtiovf_vfio_pci_tran_ops = {
> +	.name = "virtio-vfio-pci-trans",
> +	.init = virtiovf_pci_init_device,
> +	.release = virtiovf_pci_core_release_dev,
> +	.open_device = virtiovf_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = virtiovf_vfio_pci_core_ioctl,
> +	.read = virtiovf_pci_core_read,
> +	.write = virtiovf_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
> +	.name = "virtio-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = virtiovf_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.device_feature = vfio_pci_core_ioctl_feature,
> +	.read = vfio_pci_core_read,
> +	.write = vfio_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +static bool virtiovf_bar0_exists(struct pci_dev *pdev)
> +{
> +	struct resource *res = pdev->resource;
> +
> +	return res->flags ? true : false;
> +}
> +
> +static int virtiovf_pci_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
> +	struct virtiovf_pci_core_device *virtvdev;
> +	int ret;
> +
> +	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
> +	    !virtiovf_bar0_exists(pdev))
> +		ops = &virtiovf_vfio_pci_tran_ops;
> +
> +	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
> +				     &pdev->dev, ops);
> +	if (IS_ERR(virtvdev))
> +		return PTR_ERR(virtvdev);
> +
> +	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
> +	ret = vfio_pci_core_register_device(&virtvdev->core_device);
> +	if (ret)
> +		goto out;
> +	return 0;
> +out:
> +	vfio_put_device(&virtvdev->core_device.vdev);
> +	return ret;
> +}
> +
> +static void virtiovf_pci_remove(struct pci_dev *pdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
> +
> +	vfio_pci_core_unregister_device(&virtvdev->core_device);
> +	vfio_put_device(&virtvdev->core_device.vdev);
> +}
> +
> +static const struct pci_device_id virtiovf_pci_table[] = {
> +	/* Only virtio-net is supported/tested so far */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
> +
> +static struct pci_driver virtiovf_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = virtiovf_pci_table,
> +	.probe = virtiovf_pci_probe,
> +	.remove = virtiovf_pci_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(virtiovf_pci_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
> +MODULE_DESCRIPTION(
> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");


