Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299587AF177
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 19:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjIZRBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 13:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjIZRBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 13:01:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E815124
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 10:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695747623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z1RBVWMCBpG3fJC015YmdiRwM0HSCYMuc9SlKIQb+oE=;
        b=eFH/fnipan0suYlJM1uDIXMrGcZKT+PG8XXdRFCPanC/0DYeHBCbCn7WTYIcnH7mfb2E+L
        IgHHm2sqVLnJIeTI4vWrqJ7mKBENU+Z9p6YOUTHMA6mjihJOtv/gui5IiJa/uoUuF3VXZS
        xYDqpzfqqzaR4Rtofj21mDIRY8vi1x8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-775Bi4dYM8eQMXZXUlY2zA-1; Tue, 26 Sep 2023 13:00:21 -0400
X-MC-Unique: 775Bi4dYM8eQMXZXUlY2zA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2be51691dd5so139208981fa.3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 10:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695747620; x=1696352420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1RBVWMCBpG3fJC015YmdiRwM0HSCYMuc9SlKIQb+oE=;
        b=COQ/6MhHjTvIH9/J1X8vRXme2xjN1QPSFs56YeOUMxtUnq72BwapjMby0+06bCh1UI
         lE4i6N+WuCHUyqvv+4rcz5xMjTcZReqLuoZsptaqQhCgHEs978o9MGC2JmJbhUO4UhW6
         9sirjxOBulU4mLlH6/rMQyBqXU/Sjkyjaa+jecUbWDKQo2enDtv0X4eYd2lLN4RjZ3Y5
         TRk+PaJ53EgYM5YRGAPySMRAkonFoI1PngCs99hKvvFJBPmCY9bQgUFzbmPyrGn/xOg1
         dw8uWpBAZyZpnSMABaq8IoN3+OoUx/aoYFwWB6Aidk09f4CrlLgXaGynWeuOTEFQuzYj
         rmVA==
X-Gm-Message-State: AOJu0YyyL5vdczQxyVTBDMVtgmbDmZmIL3f8oifax6vDXbvfyWiwfX74
        +gAsDhDNtw1eHYz94d8+UhGCIygNDPvPZBsTZuOb5P3chZz1gD9YffpFnq1ry+hIaR7YQ+fQSQx
        dUfbquw9dh1eB
X-Received: by 2002:a2e:2417:0:b0:2bd:ddf:8aa7 with SMTP id k23-20020a2e2417000000b002bd0ddf8aa7mr8100543ljk.0.1695747619895;
        Tue, 26 Sep 2023 10:00:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvnTcqZP3iv6mhO9KOmzlswilUnL5DHfVwi2wFQIiJzoc9QrwSWKdF2GBHM9ZZ4d7vxNldyg==
X-Received: by 2002:a2e:2417:0:b0:2bd:ddf:8aa7 with SMTP id k23-20020a2e2417000000b002bd0ddf8aa7mr8100504ljk.0.1695747618731;
        Tue, 26 Sep 2023 10:00:18 -0700 (PDT)
Received: from redhat.com ([2.52.31.177])
        by smtp.gmail.com with ESMTPSA id t15-20020a170906608f00b009a9fbeb15f2sm7978467ejj.62.2023.09.26.10.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 10:00:17 -0700 (PDT)
Date:   Tue, 26 Sep 2023 13:00:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, jasowang@redhat.com,
        jgg@nvidia.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230926121955-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921135832.020d102a.alex.williamson@redhat.com>
 <537b6b22-892e-5ecd-cc46-2159f37dd3d7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537b6b22-892e-5ecd-cc46-2159f37dd3d7@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 06:20:45PM +0300, Yishai Hadas wrote:
> On 21/09/2023 22:58, Alex Williamson wrote:
> > On Thu, 21 Sep 2023 15:40:40 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> > 
> > > Introduce a vfio driver over virtio devices to support the legacy
> > > interface functionality for VFs.
> > > 
> > > Background, from the virtio spec [1].
> > > --------------------------------------------------------------------
> > > In some systems, there is a need to support a virtio legacy driver with
> > > a device that does not directly support the legacy interface. In such
> > > scenarios, a group owner device can provide the legacy interface
> > > functionality for the group member devices. The driver of the owner
> > > device can then access the legacy interface of a member device on behalf
> > > of the legacy member device driver.
> > > 
> > > For example, with the SR-IOV group type, group members (VFs) can not
> > > present the legacy interface in an I/O BAR in BAR0 as expected by the
> > > legacy pci driver. If the legacy driver is running inside a virtual
> > > machine, the hypervisor executing the virtual machine can present a
> > > virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
> > > legacy driver accesses to this I/O BAR and forwards them to the group
> > > owner device (PF) using group administration commands.
> > > --------------------------------------------------------------------
> > > 
> > > Specifically, this driver adds support for a virtio-net VF to be exposed
> > > as a transitional device to a guest driver and allows the legacy IO BAR
> > > functionality on top.
> > > 
> > > This allows a VM which uses a legacy virtio-net driver in the guest to
> > > work transparently over a VF which its driver in the host is that new
> > > driver.
> > > 
> > > The driver can be extended easily to support some other types of virtio
> > > devices (e.g virtio-blk), by adding in a few places the specific type
> > > properties as was done for virtio-net.
> > > 
> > > For now, only the virtio-net use case was tested and as such we introduce
> > > the support only for such a device.
> > > 
> > > Practically,
> > > Upon probing a VF for a virtio-net device, in case its PF supports
> > > legacy access over the virtio admin commands and the VF doesn't have BAR
> > > 0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
> > > transitional device with I/O BAR in BAR 0.
> > > 
> > > The existence of the simulated I/O bar is reported later on by
> > > overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
> > > exposes itself as a transitional device by overwriting some properties
> > > upon reading its config space.
> > > 
> > > Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
> > > guest may use it via read/write calls according to the virtio
> > > specification.
> > > 
> > > Any read/write towards the control parts of the BAR will be captured by
> > > the new driver and will be translated into admin commands towards the
> > > device.
> > > 
> > > Any data path read/write access (i.e. virtio driver notifications) will
> > > be forwarded to the physical BAR which its properties were supplied by
> > > the command VIRTIO_PCI_QUEUE_NOTIFY upon the probing/init flow.
> > > 
> > > With that code in place a legacy driver in the guest has the look and
> > > feel as if having a transitional device with legacy support for both its
> > > control and data path flows.
> > > 
> > > [1]
> > > https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
> > > 
> > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > ---
> > >   MAINTAINERS                      |   6 +
> > >   drivers/vfio/pci/Kconfig         |   2 +
> > >   drivers/vfio/pci/Makefile        |   2 +
> > >   drivers/vfio/pci/virtio/Kconfig  |  15 +
> > >   drivers/vfio/pci/virtio/Makefile |   4 +
> > >   drivers/vfio/pci/virtio/cmd.c    |   4 +-
> > >   drivers/vfio/pci/virtio/cmd.h    |   8 +
> > >   drivers/vfio/pci/virtio/main.c   | 546 +++++++++++++++++++++++++++++++
> > >   8 files changed, 585 insertions(+), 2 deletions(-)
> > >   create mode 100644 drivers/vfio/pci/virtio/Kconfig
> > >   create mode 100644 drivers/vfio/pci/virtio/Makefile
> > >   create mode 100644 drivers/vfio/pci/virtio/main.c
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index bf0f54c24f81..5098418c8389 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -22624,6 +22624,12 @@ L:	kvm@vger.kernel.org
> > >   S:	Maintained
> > >   F:	drivers/vfio/pci/mlx5/
> > > +VFIO VIRTIO PCI DRIVER
> > > +M:	Yishai Hadas <yishaih@nvidia.com>
> > > +L:	kvm@vger.kernel.org
> > > +S:	Maintained
> > > +F:	drivers/vfio/pci/virtio
> > > +
> > >   VFIO PCI DEVICE SPECIFIC DRIVERS
> > >   R:	Jason Gunthorpe <jgg@nvidia.com>
> > >   R:	Yishai Hadas <yishaih@nvidia.com>
> > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > index 8125e5f37832..18c397df566d 100644
> > > --- a/drivers/vfio/pci/Kconfig
> > > +++ b/drivers/vfio/pci/Kconfig
> > > @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
> > >   source "drivers/vfio/pci/pds/Kconfig"
> > > +source "drivers/vfio/pci/virtio/Kconfig"
> > > +
> > >   endmenu
> > > diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> > > index 45167be462d8..046139a4eca5 100644
> > > --- a/drivers/vfio/pci/Makefile
> > > +++ b/drivers/vfio/pci/Makefile
> > > @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
> > >   obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> > >   obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> > > +
> > > +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
> > > diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
> > > new file mode 100644
> > > index 000000000000..89eddce8b1bd
> > > --- /dev/null
> > > +++ b/drivers/vfio/pci/virtio/Kconfig
> > > @@ -0,0 +1,15 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only
> > > +config VIRTIO_VFIO_PCI
> > > +        tristate "VFIO support for VIRTIO PCI devices"
> > > +        depends on VIRTIO_PCI
> > > +        select VFIO_PCI_CORE
> > > +        help
> > > +          This provides support for exposing VIRTIO VF devices using the VFIO
> > > +          framework that can work with a legacy virtio driver in the guest.
> > > +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
> > > +          not indicate I/O Space.
> > > +          As of that this driver emulated I/O BAR in software to let a VF be
> > > +          seen as a transitional device in the guest and let it work with
> > > +          a legacy driver.
> > > +
> > > +          If you don't know what to do here, say N.
> > > diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
> > > new file mode 100644
> > > index 000000000000..584372648a03
> > > --- /dev/null
> > > +++ b/drivers/vfio/pci/virtio/Makefile
> > > @@ -0,0 +1,4 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only
> > > +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
> > > +virtio-vfio-pci-y := main.o cmd.o
> > > +
> > > diff --git a/drivers/vfio/pci/virtio/cmd.c b/drivers/vfio/pci/virtio/cmd.c
> > > index f068239cdbb0..aea9d25fbf1d 100644
> > > --- a/drivers/vfio/pci/virtio/cmd.c
> > > +++ b/drivers/vfio/pci/virtio/cmd.c
> > > @@ -44,7 +44,7 @@ int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> > >   {
> > >   	struct virtio_device *virtio_dev =
> > >   		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> > > -	struct virtio_admin_cmd_data_lr_write *in;
> > > +	struct virtio_admin_cmd_legacy_wr_data *in;
> > >   	struct scatterlist in_sg;
> > >   	struct virtio_admin_cmd cmd = {};
> > >   	int ret;
> > > @@ -74,7 +74,7 @@ int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> > >   {
> > >   	struct virtio_device *virtio_dev =
> > >   		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> > > -	struct virtio_admin_cmd_data_lr_read *in;
> > > +	struct virtio_admin_cmd_legacy_rd_data *in;
> > >   	struct scatterlist in_sg, out_sg;
> > >   	struct virtio_admin_cmd cmd = {};
> > >   	int ret;
> > > diff --git a/drivers/vfio/pci/virtio/cmd.h b/drivers/vfio/pci/virtio/cmd.h
> > > index c2a3645f4b90..347b1dc85570 100644
> > > --- a/drivers/vfio/pci/virtio/cmd.h
> > > +++ b/drivers/vfio/pci/virtio/cmd.h
> > > @@ -13,7 +13,15 @@
> > >   struct virtiovf_pci_core_device {
> > >   	struct vfio_pci_core_device core_device;
> > > +	u8 bar0_virtual_buf_size;
> > > +	u8 *bar0_virtual_buf;
> > > +	/* synchronize access to the virtual buf */
> > > +	struct mutex bar_mutex;
> > >   	int vf_id;
> > > +	void __iomem *notify_addr;
> > > +	u32 notify_offset;
> > > +	u8 notify_bar;
> > > +	u8 pci_cmd_io :1;
> > >   };
> > >   int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
> > > diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
> > > new file mode 100644
> > > index 000000000000..2486991c49f3
> > > --- /dev/null
> > > +++ b/drivers/vfio/pci/virtio/main.c
> > > @@ -0,0 +1,546 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> > > + */
> > > +
> > > +#include <linux/device.h>
> > > +#include <linux/module.h>
> > > +#include <linux/mutex.h>
> > > +#include <linux/pci.h>
> > > +#include <linux/pm_runtime.h>
> > > +#include <linux/types.h>
> > > +#include <linux/uaccess.h>
> > > +#include <linux/vfio.h>
> > > +#include <linux/vfio_pci_core.h>
> > > +#include <linux/virtio_pci.h>
> > > +#include <linux/virtio_net.h>
> > > +#include <linux/virtio_pci_modern.h>
> > > +
> > > +#include "cmd.h"
> > > +
> > > +#define VIRTIO_LEGACY_IO_BAR_HEADER_LEN 20
> > > +#define VIRTIO_LEGACY_IO_BAR_MSIX_HEADER_LEN 4
> > > +
> > > +static int virtiovf_issue_lr_cmd(struct virtiovf_pci_core_device *virtvdev,
> > > +				 loff_t pos, char __user *buf,
> > > +				 size_t count, bool read)
> > > +{
> > > +	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
> > > +	u16 opcode;
> > > +	int ret;
> > > +
> > > +	mutex_lock(&virtvdev->bar_mutex);
> > > +	if (read) {
> > > +		opcode = (pos < VIRTIO_PCI_CONFIG_OFF(true)) ?
> > > +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ :
> > > +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ;
> > > +		ret = virtiovf_cmd_lr_read(virtvdev, opcode, pos,
> > > +					   count, bar0_buf + pos);
> > > +		if (ret)
> > > +			goto out;
> > > +		if (copy_to_user(buf, bar0_buf + pos, count))
> > > +			ret = -EFAULT;
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (copy_from_user(bar0_buf + pos, buf, count)) {
> > > +		ret = -EFAULT;
> > > +		goto out;
> > > +	}
> > > +
> > > +	opcode = (pos < VIRTIO_PCI_CONFIG_OFF(true)) ?
> > > +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE :
> > > +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE;
> > > +	ret = virtiovf_cmd_lr_write(virtvdev, opcode, pos, count,
> > > +				    bar0_buf + pos);
> > > +out:
> > > +	mutex_unlock(&virtvdev->bar_mutex);
> > > +	return ret;
> > > +}
> > > +
> > > +static int
> > > +translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
> > > +			    loff_t pos, char __user *buf,
> > > +			    size_t count, bool read)
> > > +{
> > > +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
> > > +	u16 queue_notify;
> > > +	int ret;
> > > +
> > > +	if (pos + count > virtvdev->bar0_virtual_buf_size)
> > > +		return -EINVAL;
> > > +
> > > +	switch (pos) {
> > > +	case VIRTIO_PCI_QUEUE_NOTIFY:
> > > +		if (count != sizeof(queue_notify))
> > > +			return -EINVAL;
> > > +		if (read) {
> > > +			ret = vfio_pci_ioread16(core_device, true, &queue_notify,
> > > +						virtvdev->notify_addr);
> > > +			if (ret)
> > > +				return ret;
> > > +			if (copy_to_user(buf, &queue_notify,
> > > +					 sizeof(queue_notify)))
> > > +				return -EFAULT;
> > > +			break;
> > > +		}
> > > +
> > > +		if (copy_from_user(&queue_notify, buf, count))
> > > +			return -EFAULT;
> > > +
> > > +		ret = vfio_pci_iowrite16(core_device, true, queue_notify,
> > > +					 virtvdev->notify_addr);
> > > +		break;
> > > +	default:
> > > +		ret = virtiovf_issue_lr_cmd(virtvdev, pos, buf, count, read);
> > > +	}
> > > +
> > > +	return ret ? ret : count;
> > > +}
> > > +
> > > +static bool range_contains_range(loff_t range1_start, size_t count1,
> > > +				 loff_t range2_start, size_t count2,
> > > +				 loff_t *start_offset)
> > > +{
> > > +	if (range1_start <= range2_start &&
> > > +	    range1_start + count1 >= range2_start + count2) {
> > > +		*start_offset = range2_start - range1_start;
> > > +		return true;
> > > +	}
> > > +	return false;
> > > +}
> > > +
> > > +static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
> > > +					char __user *buf, size_t count,
> > > +					loff_t *ppos)
> > > +{
> > > +	struct virtiovf_pci_core_device *virtvdev = container_of(
> > > +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> > > +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> > > +	loff_t copy_offset;
> > > +	__le32 val32;
> > > +	__le16 val16;
> > > +	u8 val8;
> > > +	int ret;
> > > +
> > > +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	if (range_contains_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
> > > +				 &copy_offset)) {
> > > +		val16 = cpu_to_le16(0x1000);
> > > +		if (copy_to_user(buf + copy_offset, &val16, sizeof(val16)))
> > > +			return -EFAULT;
> > > +	}
> > So we take a 0x1041 ("Virtio 1.0 network device") and turn it into a
> > 0x1000 ("Virtio network device").  Are there no features implied by the
> > device ID?  NB, a byte-wise access would read the real device ID.
> 
> From spec POV 0x1000 is a transitional device which covers the functionality
> of 0x1041 device and the legacy device, so we should be fine here.
> 
> Re the byte-wise access, do we have such an access from QEMU ? I couldn't
> see a partial read of a config field.
> As of that I preferred to keep the code simple and to not manage such a
> partial flow.
> However, If we may still be concerned about, I can allow that partial read
> as part of V1.
> 
> What do you think ?
> 
> > > +
> > > +	if (virtvdev->pci_cmd_io &&
> > > +	    range_contains_range(pos, count, PCI_COMMAND, sizeof(val16),
> > > +				 &copy_offset)) {
> > > +		if (copy_from_user(&val16, buf, sizeof(val16)))
> > > +			return -EFAULT;
> > > +		val16 |= cpu_to_le16(PCI_COMMAND_IO);
> > > +		if (copy_to_user(buf + copy_offset, &val16, sizeof(val16)))
> > > +			return -EFAULT;
> > > +	}
> > So we can't turn off I/O memory.
> 
> See below as part of virtiovf_pci_core_write(), it can be turned off, the
> next virtiovf_pci_read_config() won't turn it on in that case.
> 
> This is what ' virtvdev->pci_cmd_io' field was used for.
> 
> > 
> > > +
> > > +	if (range_contains_range(pos, count, PCI_REVISION_ID, sizeof(val8),
> > > +				 &copy_offset)) {
> > > +		/* Transional needs to have revision 0 */
> > > +		val8 = 0;
> > > +		if (copy_to_user(buf + copy_offset, &val8, sizeof(val8)))
> > > +			return -EFAULT;
> > > +	}
> > Surely some driver cares about this, right?  How is this supposed to
> > work in a world where libvirt parses modules.alias and automatically
> > loads this driver rather than vfio-pci for all 0x1041 devices?  We'd
> > need to denylist this driver to ever see the device for what it is.

I think I'm missing something. What in this patch might make
libvirt load this driver automatically?



> 
> This was needed by the guest driver to support both modern and legacy
> access, it can still chose the modern one.
> 
> Please see below re libvirt.
> 
> > 
> > > +
> > > +	if (range_contains_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
> > > +				 &copy_offset)) {
> > > +		val32 = cpu_to_le32(PCI_BASE_ADDRESS_SPACE_IO);
> > > +		if (copy_to_user(buf + copy_offset, &val32, sizeof(val32)))
> > > +			return -EFAULT;
> > > +	}
> > Sloppy BAR emulation compared to the real BARs.  QEMU obviously doesn't
> > care.
> 
> From what I could see, QEMU needs the bit for 'PCI_BASE_ADDRESS_SPACE_IO'.
> 
> It doesn't really care about the address as you wrote, this is why it was
> just left as zero here.
> Does it make sense to you ?

I mean if all you care about is QEMU then you should just keep all this
code in QEMU. One you have some behaviour in UAPI you can never take
it back even if it's a bug userspace will come to depend on it.


> > 
> > > +
> > > +	if (range_contains_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
> > > +				 &copy_offset)) {
> > > +		/* Transitional devices use the PCI subsystem device id as
> > > +		 * virtio device id, same as legacy driver always did.
> > > +		 */
> > Non-networking multi-line comment style throughout please.
> 
> Sure, will handle as part of V1.
> 
> > 
> > > +		val16 = cpu_to_le16(VIRTIO_ID_NET);
> > > +		if (copy_to_user(buf + copy_offset, &val16, sizeof(val16)))
> > > +			return -EFAULT;
> > > +	}
> > > +
> > > +	return count;
> > > +}
> > > +
> > > +static ssize_t
> > > +virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
> > > +		       size_t count, loff_t *ppos)
> > > +{
> > > +	struct virtiovf_pci_core_device *virtvdev = container_of(
> > > +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> > > +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> > > +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> > > +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> > > +	int ret;
> > > +
> > > +	if (!count)
> > > +		return 0;
> > > +
> > > +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
> > > +		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
> > > +
> > > +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
> > > +		return vfio_pci_core_read(core_vdev, buf, count, ppos);
> > > +
> > > +	ret = pm_runtime_resume_and_get(&pdev->dev);
> > > +	if (ret) {
> > > +		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
> > > +				     ret);
> > > +		return -EIO;
> > > +	}
> > > +
> > > +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
> > If the heart of this driver is simply pretending to have an I/O BAR
> > where I/O accesses into that BAR are translated to accesses in the MMIO
> > BAR, why can't this be done in the VMM, ie. QEMU?  Could I/O to MMIO
> > translation in QEMU improve performance (ex. if the MMIO is mmap'd and
> > can be accessed without bouncing back into kernel code)?

Hmm. Not this patch, but Jason tells me there are devices which actually do have
it implemented like this (with an MMIO BAR). You have to convert writes
into MMIO write+MMIO read to make it robus.


> The I/O bar control registers access is not converted to MMIO but into admin
> commands.
> Such admin commands transported using an admin queue owned by the hypervisor
> driver.
> Hypervisor driver in future may use admin queue for other tasks such as
> device msix config, features provisioning, device migration commands (dirty
> page tracking, device state read/write) and may be more.
> Only the driver notification register (i.e. kick/doorbell register) is
> converted to the MMIO.
> Hence, the VFIO solution looks the better approach to match current UAPI.
> 
> > > +	pm_runtime_put(&pdev->dev);
> > > +	return ret;
> > > +}
> > > +
> > > +static ssize_t
> > > +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
> > > +			size_t count, loff_t *ppos)
> > > +{
> > > +	struct virtiovf_pci_core_device *virtvdev = container_of(
> > > +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> > > +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> > > +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> > > +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> > > +	int ret;
> > > +
> > > +	if (!count)
> > > +		return 0;
> > > +
> > > +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
> > > +		loff_t copy_offset;
> > > +		u16 cmd;
> > > +
> > > +		if (range_contains_range(pos, count, PCI_COMMAND, sizeof(cmd),
> > > +					 &copy_offset)) {
> > > +			if (copy_from_user(&cmd, buf + copy_offset, sizeof(cmd)))
> > > +				return -EFAULT;
> > > +			virtvdev->pci_cmd_io = (cmd & PCI_COMMAND_IO);
> > If we're tracking writes to PCI_COMMAND_IO, why did we statically
> > report I/O enabled in the read function previously?
> 
> In case it will be turned off here, we may not turn it on back upon the
> read(), please see the above note in that area.
> 
> 
> > > +		}
> > > +	}
> > > +
> > > +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
> > > +		return vfio_pci_core_write(core_vdev, buf, count, ppos);
> > > +
> > > +	ret = pm_runtime_resume_and_get(&pdev->dev);
> > > +	if (ret) {
> > > +		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
> > > +		return -EIO;
> > > +	}
> > > +
> > > +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
> > > +	pm_runtime_put(&pdev->dev);
> > > +	return ret;
> > > +}
> > > +
> > > +static int
> > > +virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
> > > +				   unsigned int cmd, unsigned long arg)
> > > +{
> > > +	struct virtiovf_pci_core_device *virtvdev = container_of(
> > > +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> > > +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> > > +	void __user *uarg = (void __user *)arg;
> > > +	struct vfio_region_info info = {};
> > > +
> > > +	if (copy_from_user(&info, uarg, minsz))
> > > +		return -EFAULT;
> > > +
> > > +	if (info.argsz < minsz)
> > > +		return -EINVAL;
> > > +
> > > +	switch (info.index) {
> > > +	case VFIO_PCI_BAR0_REGION_INDEX:
> > > +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> > > +		info.size = virtvdev->bar0_virtual_buf_size;
> > > +		info.flags = VFIO_REGION_INFO_FLAG_READ |
> > > +			     VFIO_REGION_INFO_FLAG_WRITE;
> > > +		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
> > > +	default:
> > > +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> > > +	}
> > > +}
> > > +
> > > +static long
> > > +virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> > > +			     unsigned long arg)
> > > +{
> > > +	switch (cmd) {
> > > +	case VFIO_DEVICE_GET_REGION_INFO:
> > > +		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
> > > +	default:
> > > +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> > > +	}
> > > +}
> > > +
> > > +static int
> > > +virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
> > > +{
> > > +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
> > > +	int ret;
> > > +
> > > +	/* Setup the BAR where the 'notify' exists to be used by vfio as well
> > > +	 * This will let us mmap it only once and use it when needed.
> > > +	 */
> > > +	ret = vfio_pci_core_setup_barmap(core_device,
> > > +					 virtvdev->notify_bar);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
> > > +			virtvdev->notify_offset;
> > > +	return 0;
> > > +}
> > > +
> > > +static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
> > > +{
> > > +	struct virtiovf_pci_core_device *virtvdev = container_of(
> > > +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> > > +	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
> > > +	int ret;
> > > +
> > > +	ret = vfio_pci_core_enable(vdev);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	if (virtvdev->bar0_virtual_buf) {
> > > +		/* upon close_device() the vfio_pci_core_disable() is called
> > > +		 * and will close all the previous mmaps, so it seems that the
> > > +		 * valid life cycle for the 'notify' addr is per open/close.
> > > +		 */
> > > +		ret = virtiovf_set_notify_addr(virtvdev);
> > > +		if (ret) {
> > > +			vfio_pci_core_disable(vdev);
> > > +			return ret;
> > > +		}
> > > +	}
> > > +
> > > +	vfio_pci_core_finish_enable(vdev);
> > > +	return 0;
> > > +}
> > > +
> > > +static void virtiovf_pci_close_device(struct vfio_device *core_vdev)
> > > +{
> > > +	vfio_pci_core_close_device(core_vdev);
> > > +}
> > Why does this function exist?
> 
> From symmetric reasons, as we have the virtiovf_pci_open_device() I put also
> the close() one.
> However, we can just set virtiovf_pci_close_device() on the ops and drop
> this code.
> > 
> > > +
> > > +static int virtiovf_get_device_config_size(unsigned short device)
> > > +{
> > > +	switch (device) {
> > > +	case 0x1041:
> > > +		/* network card */
> > > +		return offsetofend(struct virtio_net_config, status);
> > > +	default:
> > > +		return 0;
> > > +	}
> > > +}
> > > +
> > > +static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
> > > +{
> > > +	u64 offset;
> > > +	int ret;
> > > +	u8 bar;
> > > +
> > > +	ret = virtiovf_cmd_lq_read_notify(virtvdev,
> > > +				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
> > > +				&bar, &offset);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	virtvdev->notify_bar = bar;
> > > +	virtvdev->notify_offset = offset;
> > > +	return 0;
> > > +}
> > > +
> > > +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
> > > +{
> > > +	struct virtiovf_pci_core_device *virtvdev = container_of(
> > > +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> > > +	struct pci_dev *pdev;
> > > +	int ret;
> > > +
> > > +	ret = vfio_pci_core_init_dev(core_vdev);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	pdev = virtvdev->core_device.pdev;
> > > +	virtvdev->vf_id = pci_iov_vf_id(pdev);
> > > +	if (virtvdev->vf_id < 0)
> > > +		return -EINVAL;
> > vf_id is never used.
> 
> It's used as part of the virtio commands, see the previous preparation
> patch.
> 
> > 
> > > +
> > > +	ret = virtiovf_read_notify_info(virtvdev);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	virtvdev->bar0_virtual_buf_size = VIRTIO_LEGACY_IO_BAR_HEADER_LEN +
> > > +		VIRTIO_LEGACY_IO_BAR_MSIX_HEADER_LEN +
> > > +		virtiovf_get_device_config_size(pdev->device);
> > > +	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
> > > +					     GFP_KERNEL);
> > > +	if (!virtvdev->bar0_virtual_buf)
> > > +		return -ENOMEM;
> > > +	mutex_init(&virtvdev->bar_mutex);
> > > +	return 0;
> > > +}
> > > +
> > > +static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
> > > +{
> > > +	struct virtiovf_pci_core_device *virtvdev = container_of(
> > > +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> > > +
> > > +	kfree(virtvdev->bar0_virtual_buf);
> > > +	vfio_pci_core_release_dev(core_vdev);
> > > +}
> > > +
> > > +static const struct vfio_device_ops virtiovf_acc_vfio_pci_tran_ops = {
> > > +	.name = "virtio-transitional-vfio-pci",
> > > +	.init = virtiovf_pci_init_device,
> > > +	.release = virtiovf_pci_core_release_dev,
> > > +	.open_device = virtiovf_pci_open_device,
> > > +	.close_device = virtiovf_pci_close_device,
> > > +	.ioctl = virtiovf_vfio_pci_core_ioctl,
> > > +	.read = virtiovf_pci_core_read,
> > > +	.write = virtiovf_pci_core_write,
> > > +	.mmap = vfio_pci_core_mmap,
> > > +	.request = vfio_pci_core_request,
> > > +	.match = vfio_pci_core_match,
> > > +	.bind_iommufd = vfio_iommufd_physical_bind,
> > > +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> > > +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> > > +};
> > > +
> > > +static const struct vfio_device_ops virtiovf_acc_vfio_pci_ops = {
> > > +	.name = "virtio-acc-vfio-pci",
> > > +	.init = vfio_pci_core_init_dev,
> > > +	.release = vfio_pci_core_release_dev,
> > > +	.open_device = virtiovf_pci_open_device,
> > > +	.close_device = virtiovf_pci_close_device,
> > > +	.ioctl = vfio_pci_core_ioctl,
> > > +	.device_feature = vfio_pci_core_ioctl_feature,
> > > +	.read = vfio_pci_core_read,
> > > +	.write = vfio_pci_core_write,
> > > +	.mmap = vfio_pci_core_mmap,
> > > +	.request = vfio_pci_core_request,
> > > +	.match = vfio_pci_core_match,
> > > +	.bind_iommufd = vfio_iommufd_physical_bind,
> > > +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> > > +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> > > +};
> > Why are we claiming devices that should just use vfio-pci instead?
> 
> 
> Upon probe we may chose to set those default vfio-pci ops in case the device
> is not legacy capable.
> This will eliminate any usage of the new driver functionality when it's not
> applicable.
> 
> > 
> > > +
> > > +static bool virtiovf_bar0_exists(struct pci_dev *pdev)
> > > +{
> > > +	struct resource *res = pdev->resource;
> > > +
> > > +	return res->flags ? true : false;
> > > +}
> > > +
> > > +#define VIRTIOVF_USE_ADMIN_CMD_BITMAP \
> > > +	(BIT_ULL(VIRTIO_ADMIN_CMD_LIST_QUERY) | \
> > > +	 BIT_ULL(VIRTIO_ADMIN_CMD_LIST_USE) | \
> > > +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
> > > +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
> > > +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
> > > +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
> > > +	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
> > > +
> > > +static bool virtiovf_support_legacy_access(struct pci_dev *pdev)
> > > +{
> > > +	int buf_size = DIV_ROUND_UP(VIRTIO_ADMIN_MAX_CMD_OPCODE, 64) * 8;
> > > +	u8 *buf;
> > > +	int ret;
> > > +
> > > +	/* Only virtio-net is supported/tested so far */
> > > +	if (pdev->device != 0x1041)
> > > +		return false;
> > Seems like the ID table should handle this, why are we preemptively
> > claiming all virtio devices... or actually all 0x1af4 devices, which
> > might not even be virtio, ex. the non-virtio ivshmem devices is 0x1110.
> 
> Makes sense, will change in the ID table from PCI_ANY_ID to 0x1041 and
> cleanup that code.
> 
> > > +
> > > +	buf = kzalloc(buf_size, GFP_KERNEL);
> > > +	if (!buf)
> > > +		return false;
> > > +
> > > +	ret = virtiovf_cmd_list_query(pdev, buf, buf_size);
> > > +	if (ret)
> > > +		goto end;
> > > +
> > > +	if ((le64_to_cpup((__le64 *)buf) & VIRTIOVF_USE_ADMIN_CMD_BITMAP) !=
> > > +		VIRTIOVF_USE_ADMIN_CMD_BITMAP) {
> > > +		ret = -EOPNOTSUPP;
> > > +		goto end;
> > > +	}
> > > +
> > > +	/* confirm the used commands */
> > > +	memset(buf, 0, buf_size);
> > > +	*(__le64 *)buf = cpu_to_le64(VIRTIOVF_USE_ADMIN_CMD_BITMAP);
> > > +	ret = virtiovf_cmd_list_use(pdev, buf, buf_size);
> > > +
> > > +end:
> > > +	kfree(buf);
> > > +	return ret ? false : true;
> > > +}
> > > +
> > > +static int virtiovf_pci_probe(struct pci_dev *pdev,
> > > +			      const struct pci_device_id *id)
> > > +{
> > > +	const struct vfio_device_ops *ops = &virtiovf_acc_vfio_pci_ops;
> > > +	struct virtiovf_pci_core_device *virtvdev;
> > > +	int ret;
> > > +
> > > +	if (pdev->is_virtfn && virtiovf_support_legacy_access(pdev) &&
> > > +	    !virtiovf_bar0_exists(pdev) && pdev->msix_cap)
> > > +		ops = &virtiovf_acc_vfio_pci_tran_ops;
> > > +
> > > +	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
> > > +				     &pdev->dev, ops);
> > > +	if (IS_ERR(virtvdev))
> > > +		return PTR_ERR(virtvdev);
> > > +
> > > +	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
> > > +	ret = vfio_pci_core_register_device(&virtvdev->core_device);
> > > +	if (ret)
> > > +		goto out;
> > > +	return 0;
> > > +out:
> > > +	vfio_put_device(&virtvdev->core_device.vdev);
> > > +	return ret;
> > > +}
> > > +
> > > +static void virtiovf_pci_remove(struct pci_dev *pdev)
> > > +{
> > > +	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
> > > +
> > > +	vfio_pci_core_unregister_device(&virtvdev->core_device);
> > > +	vfio_put_device(&virtvdev->core_device.vdev);
> > > +}
> > > +
> > > +static const struct pci_device_id virtiovf_pci_table[] = {
> > > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> > libvirt will blindly use this driver for all devices matching this as
> > we've discussed how it should make use of modules.alias.  I don't think
> > this driver should be squatting on devices where it doesn't add value
> > and it's not clear whether this is adding or subtracting value in all
> > cases for the one NIC that it modifies.
> 
> 
> When the device is not legacy capable, we chose the vfio-pci default ops as
> pointed above, otherwise we may chose the new functionality to enable it in
> the guest.
> 
> >    How should libvirt choose when
> > and where to use this driver?  What regressions are we going to see
> > with VMs that previously saw "modern" virtio-net devices and now see a
> > legacy compatible device?  Thanks,
> We don't expect a regression here, a modern driver in the guest will
> continue using its direct access flow.
> 
> Do you see a real concern why to not enable it by default and come with some
> pre-configuration before the probe phase to activate it ?
> If so, any specific suggestion how to manage that ?
> 
> Thanks,
> Yishai

I would not claim that it can't happen.
For example, a transitional device
must not in theory be safely passed through to guest userspace, because
guest then might try to use it through the legacy BAR
without acknowledging ACCESS_PLATFORM.
Do any guests check this and fail? Hard to say.

> > Alex
> > 
> > > +	{}
> > > +};
> > > +
> > > +MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
> > > +
> > > +static struct pci_driver virtiovf_pci_driver = {
> > > +	.name = KBUILD_MODNAME,
> > > +	.id_table = virtiovf_pci_table,
> > > +	.probe = virtiovf_pci_probe,
> > > +	.remove = virtiovf_pci_remove,
> > > +	.err_handler = &vfio_pci_core_err_handlers,
> > > +	.driver_managed_dma = true,
> > > +};
> > > +
> > > +module_pci_driver(virtiovf_pci_driver);
> > > +
> > > +MODULE_LICENSE("GPL");
> > > +MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
> > > +MODULE_DESCRIPTION(
> > > +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO device family");
> 

