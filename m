Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947F87AB54F
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbjIVPyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjIVPyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:54:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C4E102
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695397992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oD6GPaTKOinLAtkRTYcbJL+0zsGzbGQ7H5NmGO1oNWg=;
        b=ElxG8yOaXz+Tswox+GBHwZiAGfYSDhvUFjn8xx8TP5xWYPMAd9MZP6Y5o7tEf87SNlWw+q
        iyigCzCM+vwSH60qovfRuuDFZn5DZPjrhpmYoTQD0z9FSVOEwNcS8iY+qjdmEGVDlxdzRY
        q9iLVYx09a+gqKK4WNZdC+pM7Xy1y9g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-866QEqB2PNeaPRTcMhrpKQ-1; Fri, 22 Sep 2023 11:53:10 -0400
X-MC-Unique: 866QEqB2PNeaPRTcMhrpKQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9ad8ab8bc9fso171149766b.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695397989; x=1696002789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oD6GPaTKOinLAtkRTYcbJL+0zsGzbGQ7H5NmGO1oNWg=;
        b=WAc/TO5F/sTmT5lKZEKpoC8ShRxbcxTdLZx8IBpn7aqw48qx58lwW8XrgWpzret9C6
         V/GlMv/hIzGEbvdOv8lyKHTPYuWmpA9Z5XTtPGiuxXA1F8opC7J5A7+7Rv5fXx6Kd49o
         o+qeGTbJRKH6krUus2GIKv5UlQnzS8ng+pLeRZ85PsQ4UUVj7t6GYOw8VLbk5xIvDr1P
         mK/Yj6yfngHTMV7BxjHIyJ/5OAfmWfpnV4+aEuZGaCin3jCzzU2nVWwGgWoB6i6SDIXk
         cJ1K6XrGy2QPWquvuhQf7k2rfk3ltWxT+PLwYedeDFzVSSxsY26bdQu8dPEudcY+pUh3
         pmWw==
X-Gm-Message-State: AOJu0YwDx62RqeRV7a1u0TDmoLoBfJFFHQDGF950JBnI07eccXsrzfcn
        NuO+qn9nA1wOoXOvUPkOXp06LGLd3uOSa+GbZgbV2g7F4mq2mjV+KByQII9Butud/cGKi5cZ49u
        Ko825Z0yxeOJVWy9pMsmG
X-Received: by 2002:a17:906:844b:b0:99c:ad52:b00 with SMTP id e11-20020a170906844b00b0099cad520b00mr7451863ejy.6.1695397988720;
        Fri, 22 Sep 2023 08:53:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4ZIA+pZTVI0SbSC68GcfTrUgCUWmBqJjluSwlnxsSIA1EDUvUOCFf2InpbeDwXeTzoE2fSw==
X-Received: by 2002:a17:906:844b:b0:99c:ad52:b00 with SMTP id e11-20020a170906844b00b0099cad520b00mr7451835ejy.6.1695397988246;
        Fri, 22 Sep 2023 08:53:08 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id i8-20020a17090685c800b009ad7fc17b2asm2888279ejy.224.2023.09.22.08.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 08:53:07 -0700 (PDT)
Date:   Fri, 22 Sep 2023 11:53:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922114539-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124040.145386-12-yishaih@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:40:40PM +0300, Yishai Hadas wrote:
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
> the command VIRTIO_PCI_QUEUE_NOTIFY upon the probing/init flow.
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
>  MAINTAINERS                      |   6 +
>  drivers/vfio/pci/Kconfig         |   2 +
>  drivers/vfio/pci/Makefile        |   2 +
>  drivers/vfio/pci/virtio/Kconfig  |  15 +
>  drivers/vfio/pci/virtio/Makefile |   4 +
>  drivers/vfio/pci/virtio/cmd.c    |   4 +-
>  drivers/vfio/pci/virtio/cmd.h    |   8 +
>  drivers/vfio/pci/virtio/main.c   | 546 +++++++++++++++++++++++++++++++
>  8 files changed, 585 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/pci/virtio/Kconfig
>  create mode 100644 drivers/vfio/pci/virtio/Makefile
>  create mode 100644 drivers/vfio/pci/virtio/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bf0f54c24f81..5098418c8389 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22624,6 +22624,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/pci/mlx5/
>  
> +VFIO VIRTIO PCI DRIVER
> +M:	Yishai Hadas <yishaih@nvidia.com>
> +L:	kvm@vger.kernel.org
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
> index 000000000000..89eddce8b1bd
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/Kconfig
> @@ -0,0 +1,15 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config VIRTIO_VFIO_PCI
> +        tristate "VFIO support for VIRTIO PCI devices"
> +        depends on VIRTIO_PCI
> +        select VFIO_PCI_CORE
> +        help
> +          This provides support for exposing VIRTIO VF devices using the VFIO
> +          framework that can work with a legacy virtio driver in the guest.
> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
> +          not indicate I/O Space.
> +          As of that this driver emulated I/O BAR in software to let a VF be
> +          seen as a transitional device in the guest and let it work with
> +          a legacy driver.
> +
> +          If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
> new file mode 100644
> index 000000000000..584372648a03
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
> +virtio-vfio-pci-y := main.o cmd.o
> +
> diff --git a/drivers/vfio/pci/virtio/cmd.c b/drivers/vfio/pci/virtio/cmd.c
> index f068239cdbb0..aea9d25fbf1d 100644
> --- a/drivers/vfio/pci/virtio/cmd.c
> +++ b/drivers/vfio/pci/virtio/cmd.c
> @@ -44,7 +44,7 @@ int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
>  {
>  	struct virtio_device *virtio_dev =
>  		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> -	struct virtio_admin_cmd_data_lr_write *in;
> +	struct virtio_admin_cmd_legacy_wr_data *in;
>  	struct scatterlist in_sg;
>  	struct virtio_admin_cmd cmd = {};
>  	int ret;
> @@ -74,7 +74,7 @@ int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
>  {
>  	struct virtio_device *virtio_dev =
>  		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> -	struct virtio_admin_cmd_data_lr_read *in;
> +	struct virtio_admin_cmd_legacy_rd_data *in;
>  	struct scatterlist in_sg, out_sg;
>  	struct virtio_admin_cmd cmd = {};
>  	int ret;
> diff --git a/drivers/vfio/pci/virtio/cmd.h b/drivers/vfio/pci/virtio/cmd.h
> index c2a3645f4b90..347b1dc85570 100644
> --- a/drivers/vfio/pci/virtio/cmd.h
> +++ b/drivers/vfio/pci/virtio/cmd.h
> @@ -13,7 +13,15 @@
>  
>  struct virtiovf_pci_core_device {
>  	struct vfio_pci_core_device core_device;
> +	u8 bar0_virtual_buf_size;
> +	u8 *bar0_virtual_buf;
> +	/* synchronize access to the virtual buf */
> +	struct mutex bar_mutex;
>  	int vf_id;
> +	void __iomem *notify_addr;
> +	u32 notify_offset;
> +	u8 notify_bar;
> +	u8 pci_cmd_io :1;
>  };
>  
>  int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
> new file mode 100644
> index 000000000000..2486991c49f3
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/main.c
> @@ -0,0 +1,546 @@
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
> +#include <linux/virtio_pci_modern.h>
> +
> +#include "cmd.h"
> +
> +#define VIRTIO_LEGACY_IO_BAR_HEADER_LEN 20
> +#define VIRTIO_LEGACY_IO_BAR_MSIX_HEADER_LEN 4
> +
> +static int virtiovf_issue_lr_cmd(struct virtiovf_pci_core_device *virtvdev,
> +				 loff_t pos, char __user *buf,
> +				 size_t count, bool read)
> +{
> +	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
> +	u16 opcode;
> +	int ret;
> +
> +	mutex_lock(&virtvdev->bar_mutex);
> +	if (read) {
> +		opcode = (pos < VIRTIO_PCI_CONFIG_OFF(true)) ?
> +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ :
> +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ;
> +		ret = virtiovf_cmd_lr_read(virtvdev, opcode, pos,
> +					   count, bar0_buf + pos);
> +		if (ret)
> +			goto out;
> +		if (copy_to_user(buf, bar0_buf + pos, count))
> +			ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (copy_from_user(bar0_buf + pos, buf, count)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	opcode = (pos < VIRTIO_PCI_CONFIG_OFF(true)) ?
> +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE :
> +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE;
> +	ret = virtiovf_cmd_lr_write(virtvdev, opcode, pos, count,
> +				    bar0_buf + pos);
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
> +			break;
> +		}
> +
> +		if (copy_from_user(&queue_notify, buf, count))
> +			return -EFAULT;
> +
> +		ret = vfio_pci_iowrite16(core_device, true, queue_notify,
> +					 virtvdev->notify_addr);
> +		break;
> +	default:
> +		ret = virtiovf_issue_lr_cmd(virtvdev, pos, buf, count, read);
> +	}
> +
> +	return ret ? ret : count;
> +}
> +
> +static bool range_contains_range(loff_t range1_start, size_t count1,
> +				 loff_t range2_start, size_t count2,
> +				 loff_t *start_offset)
> +{
> +	if (range1_start <= range2_start &&
> +	    range1_start + count1 >= range2_start + count2) {
> +		*start_offset = range2_start - range1_start;
> +		return true;
> +	}
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
> +	loff_t copy_offset;
> +	__le32 val32;
> +	__le16 val16;
> +	u8 val8;
> +	int ret;
> +
> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (range_contains_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
> +				 &copy_offset)) {
> +		val16 = cpu_to_le16(0x1000);
> +		if (copy_to_user(buf + copy_offset, &val16, sizeof(val16)))
> +			return -EFAULT;
> +	}
> +
> +	if (virtvdev->pci_cmd_io &&
> +	    range_contains_range(pos, count, PCI_COMMAND, sizeof(val16),
> +				 &copy_offset)) {
> +		if (copy_from_user(&val16, buf, sizeof(val16)))
> +			return -EFAULT;
> +		val16 |= cpu_to_le16(PCI_COMMAND_IO);
> +		if (copy_to_user(buf + copy_offset, &val16, sizeof(val16)))
> +			return -EFAULT;
> +	}
> +
> +	if (range_contains_range(pos, count, PCI_REVISION_ID, sizeof(val8),
> +				 &copy_offset)) {
> +		/* Transional needs to have revision 0 */
> +		val8 = 0;
> +		if (copy_to_user(buf + copy_offset, &val8, sizeof(val8)))
> +			return -EFAULT;
> +	}
> +
> +	if (range_contains_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
> +				 &copy_offset)) {
> +		val32 = cpu_to_le32(PCI_BASE_ADDRESS_SPACE_IO);
> +		if (copy_to_user(buf + copy_offset, &val32, sizeof(val32)))
> +			return -EFAULT;
> +	}
> +
> +	if (range_contains_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
> +				 &copy_offset)) {
> +		/* Transitional devices use the PCI subsystem device id as
> +		 * virtio device id, same as legacy driver always did.
> +		 */
> +		val16 = cpu_to_le16(VIRTIO_ID_NET);
> +		if (copy_to_user(buf + copy_offset, &val16, sizeof(val16)))
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
> +		loff_t copy_offset;
> +		u16 cmd;
> +
> +		if (range_contains_range(pos, count, PCI_COMMAND, sizeof(cmd),
> +					 &copy_offset)) {
> +			if (copy_from_user(&cmd, buf + copy_offset, sizeof(cmd)))
> +				return -EFAULT;
> +			virtvdev->pci_cmd_io = (cmd & PCI_COMMAND_IO);
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
> +	/* Setup the BAR where the 'notify' exists to be used by vfio as well
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
> +		/* upon close_device() the vfio_pci_core_disable() is called
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
> +static void virtiovf_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	vfio_pci_core_close_device(core_vdev);
> +}
> +
> +static int virtiovf_get_device_config_size(unsigned short device)
> +{
> +	switch (device) {
> +	case 0x1041:
> +		/* network card */
> +		return offsetofend(struct virtio_net_config, status);
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
> +{
> +	u64 offset;
> +	int ret;
> +	u8 bar;
> +
> +	ret = virtiovf_cmd_lq_read_notify(virtvdev,
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
> +	virtvdev->vf_id = pci_iov_vf_id(pdev);
> +	if (virtvdev->vf_id < 0)
> +		return -EINVAL;
> +
> +	ret = virtiovf_read_notify_info(virtvdev);
> +	if (ret)
> +		return ret;
> +
> +	virtvdev->bar0_virtual_buf_size = VIRTIO_LEGACY_IO_BAR_HEADER_LEN +
> +		VIRTIO_LEGACY_IO_BAR_MSIX_HEADER_LEN +
> +		virtiovf_get_device_config_size(pdev->device);
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
> +static const struct vfio_device_ops virtiovf_acc_vfio_pci_tran_ops = {
> +	.name = "virtio-transitional-vfio-pci",
> +	.init = virtiovf_pci_init_device,
> +	.release = virtiovf_pci_core_release_dev,
> +	.open_device = virtiovf_pci_open_device,
> +	.close_device = virtiovf_pci_close_device,
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
> +static const struct vfio_device_ops virtiovf_acc_vfio_pci_ops = {
> +	.name = "virtio-acc-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = virtiovf_pci_open_device,
> +	.close_device = virtiovf_pci_close_device,
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
> +#define VIRTIOVF_USE_ADMIN_CMD_BITMAP \
> +	(BIT_ULL(VIRTIO_ADMIN_CMD_LIST_QUERY) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LIST_USE) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
> +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
> +
> +static bool virtiovf_support_legacy_access(struct pci_dev *pdev)
> +{
> +	int buf_size = DIV_ROUND_UP(VIRTIO_ADMIN_MAX_CMD_OPCODE, 64) * 8;
> +	u8 *buf;
> +	int ret;
> +
> +	/* Only virtio-net is supported/tested so far */
> +	if (pdev->device != 0x1041)
> +		return false;
> +
> +	buf = kzalloc(buf_size, GFP_KERNEL);
> +	if (!buf)
> +		return false;
> +
> +	ret = virtiovf_cmd_list_query(pdev, buf, buf_size);
> +	if (ret)
> +		goto end;
> +
> +	if ((le64_to_cpup((__le64 *)buf) & VIRTIOVF_USE_ADMIN_CMD_BITMAP) !=
> +		VIRTIOVF_USE_ADMIN_CMD_BITMAP) {
> +		ret = -EOPNOTSUPP;
> +		goto end;
> +	}
> +
> +	/* confirm the used commands */
> +	memset(buf, 0, buf_size);
> +	*(__le64 *)buf = cpu_to_le64(VIRTIOVF_USE_ADMIN_CMD_BITMAP);
> +	ret = virtiovf_cmd_list_use(pdev, buf, buf_size);
> +
> +end:
> +	kfree(buf);
> +	return ret ? false : true;
> +}
> +
> +static int virtiovf_pci_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	const struct vfio_device_ops *ops = &virtiovf_acc_vfio_pci_ops;
> +	struct virtiovf_pci_core_device *virtvdev;
> +	int ret;
> +
> +	if (pdev->is_virtfn && virtiovf_support_legacy_access(pdev) &&
> +	    !virtiovf_bar0_exists(pdev) && pdev->msix_cap)

I see this is the reason you set MSIX to true. But I think it's a
misunderstanding - that true means MSIX is enabled by guest, not that
it exists.


> +		ops = &virtiovf_acc_vfio_pci_tran_ops;



Actually, I remember there's a problem with just always doing
transitional and that is VIRTIO_F_ACCESS_PLATFORM - some configs just
break in weird ways as device will go through an iommu. It would be
nicer I think if userspace had the last word on whether it wants to
enable legacy or not, even if hardware supports that.


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
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
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
> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO device family");
> -- 
> 2.27.0

