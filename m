Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5CC103070
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 00:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfKSX43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 18:56:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36593 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727329AbfKSX43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 18:56:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574207786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QSUMhah2Sl05f2BtPYajl6y1IgKm0HFkuzBJb2Obo/s=;
        b=a3+/9t4olh7MdFITiJINat6UpYWKUpywuy5vOWnxQB3vSbMbigtWKnMqUE1AKuWrAX6rte
        gFcMflCzFsNcg4dIreLlV6mMxtJi87awH7sIR4lDDDt5BGab/p4ExHES44BMcpJT1LIxeo
        sfZ6PO0HUw8rNBqGMOYYy/Jod6rDjKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-qAgxEFI9M9Kzx9JRr_P37g-1; Tue, 19 Nov 2019 18:56:25 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F316D801E5D;
        Tue, 19 Nov 2019 23:56:22 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 564866CE40;
        Tue, 19 Nov 2019 23:56:21 +0000 (UTC)
Date:   Tue, 19 Nov 2019 16:56:20 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     lantianyu1986@gmail.com
Cc:     cohuck@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        mchehab+samsung@kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, robh@kernel.org,
        Jonathan.Cameron@huawei.com, paulmck@linux.ibm.com,
        michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Message-ID: <20191119165620.0f42e5ba@x1.home>
In-Reply-To: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: qAgxEFI9M9Kzx9JRr_P37g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Nov 2019 16:45:07 +0800
lantianyu1986@gmail.com wrote:

> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>=20
> This patch is to add VFIO VMBUS driver support in order to expose
> VMBUS devices to user space drivers(Reference Hyper-V UIO driver).
> DPDK now has netvsc PMD driver support and it may get VMBUS resources
> via VFIO interface with new driver support.
>=20
> So far, Hyper-V doesn't provide virtual IOMMU support and so this
> driver needs to be used with VFIO noiommu mode.

Let's be clear here, vfio no-iommu mode taints the kernel and was a
compromise that we can re-use vfio-pci in its entirety, so it had a
high code reuse value for minimal code and maintenance investment.  It
was certainly not intended to provoke new drivers that rely on this mode
of operation.  In fact, no-iommu should be discouraged as it provides
absolutely no isolation.  I'd therefore ask, why should this be in the
kernel versus any other unsupportable out of tree driver?  It appears
almost entirely self contained.  Thanks,

Alex
=20
> Current netvsc PMD driver in DPDK doesn't have IRQ mode support.
> This driver version skips IRQ control part and adds later when
> there is a real request.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  MAINTAINERS                     |   1 +
>  drivers/vfio/Kconfig            |   1 +
>  drivers/vfio/Makefile           |   1 +
>  drivers/vfio/vmbus/Kconfig      |   9 +
>  drivers/vfio/vmbus/vfio_vmbus.c | 407 ++++++++++++++++++++++++++++++++++=
++++++
>  include/uapi/linux/vfio.h       |  12 ++
>  6 files changed, 431 insertions(+)
>  create mode 100644 drivers/vfio/vmbus/Kconfig
>  create mode 100644 drivers/vfio/vmbus/vfio_vmbus.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 55199ef7fa74..6f61fb351a5d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7574,6 +7574,7 @@ F:=09drivers/scsi/storvsc_drv.c
>  F:=09drivers/uio/uio_hv_generic.c
>  F:=09drivers/video/fbdev/hyperv_fb.c
>  F:=09drivers/iommu/hyperv-iommu.c
> +F:=09drivers/vfio/vmbus/
>  F:=09net/vmw_vsock/hyperv_transport.c
>  F:=09include/clocksource/hyperv_timer.h
>  F:=09include/linux/hyperv.h
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index fd17db9b432f..f4e075fcedbe 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -47,4 +47,5 @@ menuconfig VFIO_NOIOMMU
>  source "drivers/vfio/pci/Kconfig"
>  source "drivers/vfio/platform/Kconfig"
>  source "drivers/vfio/mdev/Kconfig"
> +source "drivers/vfio/vmbus/Kconfig"
>  source "virt/lib/Kconfig"
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index de67c4725cce..acef916cba7f 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_VFIO_SPAPR_EEH) +=3D vfio_spapr_eeh.o
>  obj-$(CONFIG_VFIO_PCI) +=3D pci/
>  obj-$(CONFIG_VFIO_PLATFORM) +=3D platform/
>  obj-$(CONFIG_VFIO_MDEV) +=3D mdev/
> +obj-$(CONFIG_VFIO_VMBUS) +=3D vmbus/
> diff --git a/drivers/vfio/vmbus/Kconfig b/drivers/vfio/vmbus/Kconfig
> new file mode 100644
> index 000000000000..27a85daae55a
> --- /dev/null
> +++ b/drivers/vfio/vmbus/Kconfig
> @@ -0,0 +1,9 @@
> +config VFIO_VMBUS
> +=09tristate "VFIO support for vmbus devices"
> +=09depends on VFIO && HYPERV
> +=09help
> +=09  Support for the VMBUS VFIO bus driver. Expose VMBUS
> +=09  resources to user space drivers(e.g, DPDK and SPDK).
> +
> +=09  If you don't know what to do here, say N.
> +
> diff --git a/drivers/vfio/vmbus/vfio_vmbus.c b/drivers/vfio/vmbus/vfio_vm=
bus.c
> new file mode 100644
> index 000000000000..25d9cafa2c0a
> --- /dev/null
> +++ b/drivers/vfio/vmbus/vfio_vmbus.c
> @@ -0,0 +1,407 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * VFIO VMBUS driver.
> + *
> + * Copyright (C) 2019, Microsoft, Inc.
> + *
> + * Author : Lan Tianyu <Tianyu.Lan@microsoft.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/vfio.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/hyperv.h>
> +
> +#include "../../hv/hyperv_vmbus.h"
> +
> +
> +#define DRIVER_VERSION=09"0.0.1"
> +#define DRIVER_AUTHOR=09"Tianyu Lan <Tianyu.Lan@microsoft.com>"
> +#define DRIVER_DESC=09"VFIO driver for VMBus devices"
> +
> +#define HV_RING_SIZE=09 (512 * HV_HYP_PAGE_SIZE) /* 2M Ring size */
> +#define SEND_BUFFER_SIZE (16 * 1024 * 1024)
> +#define RECV_BUFFER_SIZE (31 * 1024 * 1024)
> +
> +struct vmbus_mem {
> +=09phys_addr_t=09=09addr;
> +=09resource_size_t=09=09size;
> +};
> +
> +struct vfio_vmbus_device {
> +=09struct hv_device *hdev;
> +=09atomic_t refcnt;
> +=09struct  vmbus_mem mem[VFIO_VMBUS_MAX_MAP_NUM];
> +
> +=09void=09*recv_buf;
> +=09void=09*send_buf;
> +};
> +
> +static void vfio_vmbus_channel_cb(void *context)
> +{
> +=09struct vmbus_channel *chan =3D context;
> +
> +=09/* Disable interrupts on channel */
> +=09chan->inbound.ring_buffer->interrupt_mask =3D 1;
> +
> +=09/* Issue a full memory barrier after masking interrupt */
> +=09virt_mb();
> +}
> +
> +static int vfio_vmbus_ring_mmap(struct file *filp, struct kobject *kobj,
> +=09=09=09    struct bin_attribute *attr,
> +=09=09=09    struct vm_area_struct *vma)
> +{
> +=09struct vmbus_channel *channel
> +=09=09=3D container_of(kobj, struct vmbus_channel, kobj);
> +=09void *ring_buffer =3D page_address(channel->ringbuffer_page);
> +
> +=09if (channel->state !=3D CHANNEL_OPENED_STATE)
> +=09=09return -ENODEV;
> +
> +=09return vm_iomap_memory(vma, virt_to_phys(ring_buffer),
> +=09=09=09       channel->ringbuffer_pagecount << PAGE_SHIFT);
> +}
> +
> +static const struct bin_attribute ring_buffer_bin_attr =3D {
> +=09.attr =3D {
> +=09=09.name =3D "ring",
> +=09=09.mode =3D 0600,
> +=09},
> +=09.size =3D 2 * HV_RING_SIZE,
> +=09.mmap =3D vfio_vmbus_ring_mmap,
> +};
> +
> +static void
> +vfio_vmbus_new_channel(struct vmbus_channel *new_sc)
> +{
> +=09struct hv_device *hv_dev =3D new_sc->primary_channel->device_obj;
> +=09struct device *device =3D &hv_dev->device;
> +=09int ret;
> +
> +=09/* Create host communication ring */
> +=09ret =3D vmbus_open(new_sc, HV_RING_SIZE, HV_RING_SIZE, NULL, 0,
> +=09=09=09 vfio_vmbus_channel_cb, new_sc);
> +=09if (ret) {
> +=09=09dev_err(device, "vmbus_open subchannel failed: %d\n", ret);
> +=09=09return;
> +=09}
> +
> +=09/* Disable interrupts on sub channel */
> +=09new_sc->inbound.ring_buffer->interrupt_mask =3D 1;
> +=09set_channel_read_mode(new_sc, HV_CALL_ISR);
> +
> +=09ret =3D sysfs_create_bin_file(&new_sc->kobj, &ring_buffer_bin_attr);
> +=09if (ret)
> +=09=09dev_notice(&hv_dev->device,
> +=09=09=09   "sysfs create ring bin file failed; %d\n", ret);
> +}
> +
> +static int vfio_vmbus_open(void *device_data)
> +{
> +=09struct vfio_vmbus_device *vdev =3D device_data;
> +=09struct hv_device *dev =3D vdev->hdev;
> +=09int ret;
> +
> +=09vmbus_set_sc_create_callback(dev->channel, vfio_vmbus_new_channel);
> +
> +=09ret =3D vmbus_connect_ring(dev->channel,
> +=09=09=09vfio_vmbus_channel_cb, dev->channel);
> +=09if (ret =3D=3D 0)
> +=09=09dev->channel->inbound.ring_buffer->interrupt_mask =3D 1;
> +
> +=09return 0;
> +}
> +
> +static long vfio_vmbus_ioctl(void *device_data, unsigned int cmd,
> +=09=09=09 unsigned long arg)
> +{
> +=09struct vfio_vmbus_device *vdev =3D device_data;
> +=09unsigned long minsz;
> +
> +=09if (cmd =3D=3D VFIO_DEVICE_GET_INFO) {
> +=09=09struct vfio_device_info info;
> +
> +=09=09minsz =3D offsetofend(struct vfio_device_info, num_irqs);
> +
> +=09=09if (copy_from_user(&info, (void __user *)arg, minsz))
> +=09=09=09return -EFAULT;
> +
> +=09=09if (info.argsz < minsz)
> +=09=09=09return -EINVAL;
> +
> +=09=09info.flags =3D VFIO_DEVICE_FLAGS_VMBUS;
> +=09=09info.num_regions =3D VFIO_VMBUS_MAX_MAP_NUM;
> +
> +=09=09return copy_to_user((void __user *)arg, &info, minsz) ?
> +=09=09=09-EFAULT : 0;
> +=09} else if (cmd =3D=3D VFIO_DEVICE_GET_REGION_INFO) {
> +=09=09struct vfio_region_info info;
> +
> +=09=09minsz =3D offsetofend(struct vfio_region_info, offset);
> +
> +=09=09if (copy_from_user(&info, (void __user *)arg, minsz))
> +=09=09=09return -EFAULT;
> +
> +=09=09if (info.argsz < minsz)
> +=09=09=09return -EINVAL;
> +
> +=09=09if (info.index >=3D VFIO_VMBUS_MAX_MAP_NUM)
> +=09=09=09return -EINVAL;
> +
> +=09=09info.offset =3D vdev->mem[info.index].addr;
> +=09=09info.size =3D vdev->mem[info.index].size;
> +=09=09info.flags =3D VFIO_REGION_INFO_FLAG_READ
> +=09=09=09| VFIO_REGION_INFO_FLAG_WRITE
> +=09=09=09| VFIO_REGION_INFO_FLAG_MMAP;
> +
> +=09=09return copy_to_user((void __user *)arg, &info, minsz) ?
> +=09=09=09-EFAULT : 0;
> +=09}
> +
> +=09return -ENOTTY;
> +}
> +
> +static void vfio_vmbus_release(void *device_data)
> +{
> +=09struct vfio_vmbus_device *vdev =3D device_data;
> +
> +=09vmbus_disconnect_ring(vdev->hdev->channel);
> +}
> +
> +static vm_fault_t vfio_vma_fault(struct vm_fault *vmf)
> +{
> +=09struct vfio_vmbus_device *vdev =3D vmf->vma->vm_private_data;
> +=09struct vm_area_struct *vma =3D vmf->vma;
> +=09struct page *page;
> +=09unsigned long offset;
> +=09void *addr;
> +=09int index;
> +
> +=09index =3D vma->vm_pgoff;
> +
> +=09/*
> +=09 * Page fault should only happen on mmap regiones
> +=09 * and bypass GPADL indexes here.
> +=09 */
> +=09if (index >=3D VFIO_VMBUS_MAX_MAP_NUM - 2)
> +=09=09return VM_FAULT_SIGBUS;
> +
> +=09offset =3D (vmf->pgoff - index) << PAGE_SHIFT;
> +=09addr =3D (void *)(vdev->mem[index].addr + offset);
> +
> +=09if (index =3D=3D VFIO_VMBUS_SEND_BUF_MAP ||
> +=09    index =3D=3D VFIO_VMBUS_RECV_BUF_MAP)
> +=09=09page =3D vmalloc_to_page(addr);
> +=09else
> +=09=09page =3D virt_to_page(addr);
> +
> +=09get_page(page);
> +=09vmf->page =3D page;
> +
> +=09return 0;
> +}
> +
> +static const struct vm_operations_struct vfio_logical_vm_ops =3D {
> +=09.fault =3D vfio_vma_fault,
> +};
> +
> +static const struct vm_operations_struct vfio_physical_vm_ops =3D {
> +#ifdef CONFIG_HAVE_IOREMAP_PROT
> +=09.access =3D generic_access_phys,
> +#endif
> +};
> +
> +static int vfio_vmbus_mmap(void *device_data, struct vm_area_struct *vma=
)
> +{
> +=09struct vfio_vmbus_device *vdev =3D device_data;
> +=09int index;
> +
> +=09if (vma->vm_end < vma->vm_start)
> +=09=09return -EINVAL;
> +
> +=09/*
> +=09 * Mmap should only happen on map regions
> +=09 * and bypass GPADL index here.
> +=09 */
> +=09if (vma->vm_pgoff >=3D VFIO_VMBUS_MAX_MAP_NUM - 2)
> +=09=09return -EINVAL;
> +
> +=09index =3D vma->vm_pgoff;
> +=09vma->vm_private_data =3D vdev;
> +
> +=09if (index =3D=3D VFIO_VMBUS_TXRX_RING_MAP) {
> +=09=09u64 addr;
> +
> +=09=09addr =3D vdev->mem[VFIO_VMBUS_TXRX_RING_MAP].addr;
> +=09=09vma->vm_ops =3D &vfio_physical_vm_ops;
> +=09=09return remap_pfn_range(vma,
> +=09=09=09       vma->vm_start,
> +=09=09=09       addr >> PAGE_SHIFT,
> +=09=09=09       vma->vm_end - vma->vm_start,
> +=09=09=09       vma->vm_page_prot);
> +=09} else {
> +=09=09vma->vm_flags |=3D VM_DONTEXPAND | VM_DONTDUMP;
> +=09=09vma->vm_ops =3D &vfio_logical_vm_ops;
> +=09=09return 0;
> +=09}
> +}
> +
> +static const struct vfio_device_ops vfio_vmbus_ops =3D {
> +=09.name=09=09=3D "vfio-vmbus",
> +=09.open=09=09=3D vfio_vmbus_open,
> +=09.release=09=3D vfio_vmbus_release,
> +=09.mmap=09=09=3D vfio_vmbus_mmap,
> +=09.ioctl=09=09=3D vfio_vmbus_ioctl,
> +};
> +
> +static int vfio_vmbus_probe(struct hv_device *dev,
> +=09=09=09 const struct hv_vmbus_device_id *dev_id)
> +{
> +=09struct vmbus_channel *channel =3D dev->channel;
> +=09struct vfio_vmbus_device *vdev;
> +=09struct iommu_group *group;
> +=09u32 gpadl;
> +=09void *ring_buffer;
> +=09int ret;
> +
> +=09group =3D vfio_iommu_group_get(&dev->device);
> +=09if (!group)
> +=09=09return -EINVAL;
> +
> +=09vdev =3D kzalloc(sizeof(*vdev), GFP_KERNEL);
> +=09if (!vdev) {
> +=09=09vfio_iommu_group_put(group, &dev->device);
> +=09=09return -ENOMEM;
> +=09}
> +
> +=09ret =3D vfio_add_group_dev(&dev->device, &vfio_vmbus_ops, vdev);
> +=09if (ret)
> +=09=09goto free_vdev;
> +
> +=09vdev->hdev =3D dev;
> +=09ret =3D vmbus_alloc_ring(channel, HV_RING_SIZE, HV_RING_SIZE);
> +=09if (ret)
> +=09=09goto del_group_dev;
> +
> +=09set_channel_read_mode(channel, HV_CALL_ISR);
> +
> +=09ring_buffer =3D page_address(channel->ringbuffer_page);
> +=09vdev->mem[VFIO_VMBUS_TXRX_RING_MAP].addr
> +=09=09=3D virt_to_phys(ring_buffer);
> +=09vdev->mem[VFIO_VMBUS_TXRX_RING_MAP].size
> +=09=09=3D channel->ringbuffer_pagecount << PAGE_SHIFT;
> +
> +=09vdev->mem[VFIO_VMBUS_INT_PAGE_MAP].addr
> +=09=09=3D (phys_addr_t)vmbus_connection.int_page;
> +=09vdev->mem[VFIO_VMBUS_INT_PAGE_MAP].size =3D PAGE_SIZE;
> +
> +=09vdev->mem[VFIO_VMBUS_MON_PAGE_MAP].addr
> +=09=09=3D (phys_addr_t)vmbus_connection.monitor_pages[1];
> +=09vdev->mem[VFIO_VMBUS_MON_PAGE_MAP].size =3D PAGE_SIZE;
> +
> +=09vdev->recv_buf =3D vzalloc(RECV_BUFFER_SIZE);
> +=09if (vdev->recv_buf =3D=3D NULL) {
> +=09=09ret =3D -ENOMEM;
> +=09=09goto free_ring;
> +=09}
> +
> +=09ret =3D vmbus_establish_gpadl(channel, vdev->recv_buf,
> +=09=09=09=09    RECV_BUFFER_SIZE, &gpadl);
> +=09if (ret)
> +=09=09goto free_recv_buf;
> +
> +=09vdev->mem[VFIO_VMBUS_RECV_BUF_MAP].addr
> +=09=09=3D (phys_addr_t)vdev->recv_buf;
> +=09vdev->mem[VFIO_VMBUS_RECV_BUF_MAP].size =3D RECV_BUFFER_SIZE;
> +
> +=09/* Expose Recv GPADL via region info. */
> +=09vdev->mem[VFIO_VMBUS_RECV_GPADL].addr =3D gpadl;
> +
> +=09vdev->send_buf =3D vzalloc(SEND_BUFFER_SIZE);
> +=09if (vdev->send_buf =3D=3D NULL) {
> +=09=09ret =3D -ENOMEM;
> +=09=09goto free_recv_gpadl;
> +=09}
> +
> +=09ret =3D vmbus_establish_gpadl(channel, vdev->send_buf,
> +=09=09=09=09    SEND_BUFFER_SIZE, &gpadl);
> +=09if (ret)
> +=09=09goto free_send_buf;
> +
> +=09vdev->mem[VFIO_VMBUS_SEND_BUF_MAP].addr
> +=09=09=3D (phys_addr_t)vdev->send_buf;
> +=09vdev->mem[VFIO_VMBUS_SEND_BUF_MAP].size =3D SEND_BUFFER_SIZE;
> +
> +=09/* Expose Send GPADL via region info. */
> +=09vdev->mem[VFIO_VMBUS_SEND_GPADL].addr =3D gpadl;
> +
> +=09ret =3D sysfs_create_bin_file(&channel->kobj, &ring_buffer_bin_attr);
> +=09if (ret)
> +=09=09dev_notice(&dev->device,
> +=09=09=09   "sysfs create ring bin file failed; %d\n", ret);
> +
> +=09return 0;
> +
> + free_send_buf:
> +=09vfree(vdev->send_buf);
> + free_recv_gpadl:
> +=09vmbus_teardown_gpadl(channel, vdev->mem[VFIO_VMBUS_RECV_GPADL].addr);
> + free_recv_buf:
> +=09vfree(vdev->recv_buf);
> + free_ring:
> +=09vmbus_free_ring(channel);
> + del_group_dev:
> +=09vfio_del_group_dev(&dev->device);
> + free_vdev:
> +=09vfio_iommu_group_put(group, &dev->device);
> +=09kfree(vdev);
> +=09return -EINVAL;
> +}
> +
> +static int vfio_vmbus_remove(struct hv_device *hdev)
> +{
> +=09struct vfio_vmbus_device *vdev =3D vfio_del_group_dev(&hdev->device);
> +=09struct vmbus_channel *channel =3D hdev->channel;
> +
> +=09if (!vdev)
> +=09=09return 0;
> +
> +=09sysfs_remove_bin_file(&channel->kobj, &ring_buffer_bin_attr);
> +
> +=09vmbus_teardown_gpadl(channel, vdev->mem[VFIO_VMBUS_SEND_GPADL].addr);
> +=09vmbus_teardown_gpadl(channel, vdev->mem[VFIO_VMBUS_RECV_GPADL].addr);
> +=09vfree(vdev->recv_buf);
> +=09vfree(vdev->send_buf);
> +=09vmbus_free_ring(channel);
> +=09vfio_iommu_group_put(hdev->device.iommu_group, &hdev->device);
> +=09kfree(vdev);
> +
> +=09return 0;
> +}
> +
> +static struct hv_driver hv_vfio_drv =3D {
> +=09.name =3D "hv_vfio",
> +=09.id_table =3D NULL,
> +=09.probe =3D vfio_vmbus_probe,
> +=09.remove =3D vfio_vmbus_remove,
> +};
> +
> +static int __init vfio_vmbus_init(void)
> +{
> +=09return vmbus_driver_register(&hv_vfio_drv);
> +}
> +
> +static void __exit vfio_vmbus_exit(void)
> +{
> +=09vmbus_driver_unregister(&hv_vfio_drv);
> +}
> +
> +module_init(vfio_vmbus_init);
> +module_exit(vfio_vmbus_exit);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a147ead..611baf7a30e4 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -201,6 +201,7 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)=09/* vfio-amba device */
>  #define VFIO_DEVICE_FLAGS_CCW=09(1 << 4)=09/* vfio-ccw device */
>  #define VFIO_DEVICE_FLAGS_AP=09(1 << 5)=09/* vfio-ap device */
> +#define VFIO_DEVICE_FLAGS_VMBUS  (1 << 6)=09/* vfio-vmbus device */
>  =09__u32=09num_regions;=09/* Max region index + 1 */
>  =09__u32=09num_irqs;=09/* Max IRQ index + 1 */
>  };
> @@ -564,6 +565,17 @@ enum {
>  =09VFIO_PCI_NUM_IRQS
>  };
> =20
> +enum {
> +=09VFIO_VMBUS_TXRX_RING_MAP =3D 0,
> +=09VFIO_VMBUS_INT_PAGE_MAP,
> +=09VFIO_VMBUS_MON_PAGE_MAP,
> +=09VFIO_VMBUS_RECV_BUF_MAP,
> +=09VFIO_VMBUS_SEND_BUF_MAP,
> +=09VFIO_VMBUS_RECV_GPADL,
> +=09VFIO_VMBUS_SEND_GPADL,
> +=09VFIO_VMBUS_MAX_MAP_NUM,
> +};
> +
>  /*
>   * The vfio-ccw bus driver makes use of the following fixed region and
>   * IRQ index mapping. Unimplemented regions return a size of zero.

