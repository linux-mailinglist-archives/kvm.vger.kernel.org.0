Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EE37D5BF6
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 21:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344062AbjJXT6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 15:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343931AbjJXT6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 15:58:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8BC186
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 12:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698177441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7y0a62ib1Df6QtnO+2Fw/k8pGqZoYJNUh5teU2GWuFg=;
        b=I9BBJKFCNG4a3UUSa+jskEciKFuU1dNh+4yWT5ANdZ1kpIA8mymA/3YHbuHuWsG6HUezGi
        OCdVfZstNaC1x2nrNTvJuWL5tQxojLPvhn2Jn9DmPcO6BUfcFKbb4KWlHfdsd1z6nG/e45
        q5OSMesL431dOfTqh05ht+zKQMRFU+4=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-d1GsSv7iNGGr-ds_NLaM4g-1; Tue, 24 Oct 2023 15:57:17 -0400
X-MC-Unique: d1GsSv7iNGGr-ds_NLaM4g-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-35278d347bbso61358285ab.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 12:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698177436; x=1698782236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7y0a62ib1Df6QtnO+2Fw/k8pGqZoYJNUh5teU2GWuFg=;
        b=wbDgyXty5tL5pxzEvG74jR5EwfzY9pdoMsBXxw5KnO0O+ku8dTK3GnQy8ZNTH0WVdF
         xrddi+t5JBu/uiLno0UPdxi18S+V71ugGqxzI5E8FfW38ZYVPgc2gixOot2YZzu+Eg62
         R97aWufjp1Hn7SxBTsrSKYTyptYe47ZcGIO9l/ievHD2o+yFOhDs+3MJ05AjHKaVqtZ/
         tz3uTwbQLOvoc5nIbf9at4WWIcjEmOU5C2ckEeitWcb008jlI6/jV3wBvzTsdvkvr7ND
         H/4T7JsqzMf7jmBfTG8+jLzbuyKVrYHWUEEnVwct6Ibx8o2Lf/fEWOQe5i9LGMaN0Z14
         i+SQ==
X-Gm-Message-State: AOJu0Ywe0jXkUR4fHpgcDFQAttRiWTrG1nxF35pfiPk0ywzZBbZ6m8Yo
        +7l8m2z2DRp/ZV+/NyFrn5qfBTXuosDOV95ksq3BdrvgekaxERFF62IZdsJvuXMKYhMvGFIZxm9
        3dHx/GKnciE5J
X-Received: by 2002:a92:c90d:0:b0:34f:c7f7:18b with SMTP id t13-20020a92c90d000000b0034fc7f7018bmr12865509ilp.2.1698177436167;
        Tue, 24 Oct 2023 12:57:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcin2N2kcMQ5BGgkCfyircVfGRs/qzAGxl9V0Gi6v0+/atPRuYKd8V0xjWk6P1jfMC37lEow==
X-Received: by 2002:a92:c90d:0:b0:34f:c7f7:18b with SMTP id t13-20020a92c90d000000b0034fc7f7018bmr12865491ilp.2.1698177435698;
        Tue, 24 Oct 2023 12:57:15 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id fz24-20020a0566381ed800b0041a9022c3dasm2975203jab.118.2023.10.24.12.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 12:57:15 -0700 (PDT)
Date:   Tue, 24 Oct 2023 13:57:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231024135713.360c2980.alex.williamson@redhat.com>
In-Reply-To: <20231017134217.82497-10-yishaih@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
        <20231017134217.82497-10-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Oct 2023 16:42:17 +0300
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
>  drivers/vfio/pci/virtio/Kconfig  |  15 +
>  drivers/vfio/pci/virtio/Makefile |   4 +
>  drivers/vfio/pci/virtio/main.c   | 577 +++++++++++++++++++++++++++++++
>  6 files changed, 607 insertions(+)
>  create mode 100644 drivers/vfio/pci/virtio/Kconfig
>  create mode 100644 drivers/vfio/pci/virtio/Makefile
>  create mode 100644 drivers/vfio/pci/virtio/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7a7bd8bd80e9..680a70063775 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22620,6 +22620,13 @@ L:	kvm@vger.kernel.org
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

This description is a little bit subtle to the hard requirements on the
device.  Reading this, one might think that this should work for any
SR-IOV VF virtio device, when in reality it only support virtio-net
currently and places a number of additional requirements on the device
(ex. legacy access and MSI-X support).

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
> index 000000000000..3fef4b21f7e6
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/main.c
> @@ -0,0 +1,577 @@
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
> +	u8 *bar0_virtual_buf;
> +	/* synchronize access to the virtual buf */
> +	struct mutex bar_mutex;
> +	void __iomem *notify_addr;
> +	u32 notify_offset;
> +	u8 notify_bar;

Push the above u8 to the end of the structure for better packing.

> +	u16 pci_cmd;
> +	u16 msix_ctrl;
> +};
> +
> +static int
> +virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
> +			     loff_t pos, char __user *buf,
> +			     size_t count, bool read)
> +{
> +	bool msix_enabled = virtvdev->msix_ctrl & PCI_MSIX_FLAGS_ENABLE;
> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> +	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
> +	u16 opcode;
> +	int ret;
> +
> +	mutex_lock(&virtvdev->bar_mutex);
> +	if (read) {
> +		opcode = (pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled)) ?
> +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ :
> +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ;
> +		ret = virtio_pci_admin_legacy_io_read(pdev, opcode, pos, count,
> +						      bar0_buf + pos);
> +		if (ret)
> +			goto out;
> +		if (copy_to_user(buf, bar0_buf + pos, count))
> +			ret = -EFAULT;
> +		goto out;
> +	}

TBH, I think the symmetry of read vs write would be more apparent if
this were an else branch.

> +
> +	if (copy_from_user(bar0_buf + pos, buf, count)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	opcode = (pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled)) ?
> +			VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE :
> +			VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE;
> +	ret = virtio_pci_admin_legacy_io_write(pdev, opcode, pos, count,
> +					       bar0_buf + pos);
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

Same.

> +
> +		if (copy_from_user(&queue_notify, buf, count))
> +			return -EFAULT;
> +
> +		ret = vfio_pci_iowrite16(core_device, true, queue_notify,
> +					 virtvdev->notify_addr);
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
> +		if (register_offset)
> +			*register_offset = 0;
> +		return true;
> +	}
> +
> +	if (range1_start > range2_start &&
> +	    range1_start < range2_start + count2) {
> +		*start_offset = range1_start;
> +		*intersect_count = min_t(size_t, count1,
> +					 range2_start + count2 - range1_start);
> +		if (register_offset)
> +			*register_offset = range1_start - range2_start;
> +		return true;
> +	}

Seems like we're missing a case, and some documentation.

The first test requires range1 to fully enclose range2 and provides the
offset of range2 within range1 and the length of the intersection.

The second test requires range1 to start from a non-zero offset within
range2 and returns the absolute offset of range1 and the length of the
intersection.

The register offset is then non-zero offset of range1 into range2.  So
does the caller use the zero value in the previous test to know range2
exists within range1?

We miss the cases where range1_start is <= range2_start and range1
terminates within range2.  I suppose we'll see below how this is used,
but it seems asymmetric and incomplete.

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
> +				  &copy_offset, &copy_count, NULL)) {

If a user does 'setpci -s x:00.0 2.b' (range1 <= range2, but terminates
within range2) they'll not enter this branch and see 41 rather than 00.

If a user does 'setpci -s x:00.0 3.b' (range1 > range2, range 1
contained within range 2), the above function returns a copy_offset of
range1_start (ie. 3).  But that offset is applied to the buffer, which
is out of bounds.  The function needs to have returned an offset of 1
and it should have applied to the val16 address.

I don't think this works like it's intended.


> +		val16 = cpu_to_le16(0x1000);

Please #define this somewhere rather than hiding a magic value here.

> +		if (copy_to_user(buf + copy_offset, &val16, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if ((virtvdev->pci_cmd & PCI_COMMAND_IO) &&
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
> +
> +	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
> +				  &copy_offset, &copy_count, NULL)) {
> +		/* Transional needs to have revision 0 */
> +		val8 = 0;
> +		if (copy_to_user(buf + copy_offset, &val8, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
> +				  &copy_offset, &copy_count, NULL)) {
> +		val32 = cpu_to_le32(PCI_BASE_ADDRESS_SPACE_IO);

I'd still like to see the remainder of the BAR follow the semantics
vfio-pci does.  I think this requires a __le32 bar0 field on the
virtvdev struct to store writes and the read here would mask the lower
bits up to the BAR size and OR in the IO indicator bit.


> +		if (copy_to_user(buf + copy_offset, &val32, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
> +				  &copy_offset, &copy_count, NULL)) {
> +		/*
> +		 * Transitional devices use the PCI subsystem device id as
> +		 * virtio device id, same as legacy driver always did.

Where did we require the subsystem vendor ID to be 0x1af4?  This
subsystem device ID really only makes since given that subsystem
vendor ID, right?  Otherwise I don't see that non-transitional devices,
such as the VF, have a hard requirement per the spec for the subsystem
vendor ID.

Do we want to make this only probe the correct subsystem vendor ID or do
we want to emulate the subsystem vendor ID as well?  I don't see this is
correct without one of those options.

> +		 */
> +		val16 = cpu_to_le16(VIRTIO_ID_NET);
> +		if (copy_to_user(buf + copy_offset, &val16, copy_count))
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
> +		if (range_intersect_range(pos, count, pdev->msix_cap + PCI_MSIX_FLAGS,
> +					  sizeof(virtvdev->msix_ctrl),
> +					  &copy_offset, &copy_count,
> +					  &register_offset)) {
> +			if (copy_from_user((void *)&virtvdev->msix_ctrl + register_offset,
> +					   buf + copy_offset,
> +					   copy_count))
> +				return -EFAULT;
> +		}

MSI-X is setup via ioctl, so you're relying on a userspace that writes
through the control register bit even though it doesn't do anything.
Why not use vfio_pci_core_device.irq_type to track if MSI-X mode is
enabled?

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
> +static const struct vfio_device_ops virtiovf_acc_vfio_pci_tran_ops = {
> +	.name = "virtio-transitional-vfio-pci",
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
> +static const struct vfio_device_ops virtiovf_acc_vfio_pci_ops = {
> +	.name = "virtio-acc-vfio-pci",
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
> +	buf = kzalloc(buf_size, GFP_KERNEL);
> +	if (!buf)
> +		return false;
> +
> +	ret = virtio_pci_admin_list_query(pdev, buf, buf_size);
> +	if (ret)
> +		goto end;
> +
> +	if ((le64_to_cpup((__le64 *)buf) & VIRTIOVF_USE_ADMIN_CMD_BITMAP) !=
> +		VIRTIOVF_USE_ADMIN_CMD_BITMAP) {
> +		ret = -EOPNOTSUPP;
> +		goto end;
> +	}
> +
> +	/* Confirm the used commands */
> +	memset(buf, 0, buf_size);
> +	*(__le64 *)buf = cpu_to_le64(VIRTIOVF_USE_ADMIN_CMD_BITMAP);
> +	ret = virtio_pci_admin_list_use(pdev, buf, buf_size);
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


All but the last test here are fairly evident requirements of the
driver.  Why do we require a device that supports MSI-X?

Thanks,
Alex


> +		ops = &virtiovf_acc_vfio_pci_tran_ops;
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
> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO device family");

