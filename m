Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBA36E9FBB
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 01:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbjDTXSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 19:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbjDTXSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 19:18:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FB949EF
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 16:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682032646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nWq43n/Da2gDjYcqkmyxMMwjV9A2SxZm8Xmzf5b2hX4=;
        b=in5mFwxw1LuN9UBB9XqSdSJ4EiwddBN0wnmKdDfxOXGsKpBuil/YFO9gSDLDBAjXsZ7MqK
        FqsjJ4SWJrkEthLdQHyryPhCbx14SEUDfF5yVOKQb8oid5omCMqggYuI/CS/CyfOg+SUSi
        EVRYWagYIWEg2kXLla8hre2jDmE28QM=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-1nphNssFN3K-09S94iJjcg-1; Thu, 20 Apr 2023 19:17:24 -0400
X-MC-Unique: 1nphNssFN3K-09S94iJjcg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-32b532ee15bso53701695ab.1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 16:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682032644; x=1684624644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nWq43n/Da2gDjYcqkmyxMMwjV9A2SxZm8Xmzf5b2hX4=;
        b=ZGefOIQJhsqhxWNFqK79OOOjso43KMNeAt/1WS4UTxAX2gXG1ENOJiERS7hUWHtNRP
         8p6deJU4goPjWj26jIWjlwK64dcN/oGb8Kr1eeHx/V2KDB5jC9u4LDe1ucaCf5fxNZdT
         FsgBcdXy04qn2w1qaCviXc+IeJ45hefJxXyf+TEpQfshK6XH8C/o13SVltuWR/bLjewJ
         9orvsxMfq/ybwf8o+T87PDQ5LFubcfzzU2zSt/aaE18T2UUrTTYHn4wbKXyT4wkzl2s3
         AZVNUmkujQ15l1+Ak8sCr82r1NaV+bqDTQwJqu3hOka2zycPzUy9b+PRg86rU9pTo6Lf
         soZA==
X-Gm-Message-State: AAQBX9d/B0UyJNxUIoWVm9uUa5tyJdn1cyWx/lq2GqxZhpkvee6a9/+m
        Ybq13N4eFDCh1Qye260ScfNNG6FrJLBRcMgBlTUFzofG4odh3kCdSjekRg12ac1+L0ZtAVzbCAA
        rbHv9Wf/vh1ZG
X-Received: by 2002:a5d:9d92:0:b0:760:dffa:f13d with SMTP id ay18-20020a5d9d92000000b00760dffaf13dmr4398093iob.3.1682032643706;
        Thu, 20 Apr 2023 16:17:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350amVwGiYMTY3p5zmho3rzvdRwjWSqQzQr1MaD8LbIOjso2j2g0mYPQ8jeU8cCPGfVr2kwLkSg==
X-Received: by 2002:a5d:9d92:0:b0:760:dffa:f13d with SMTP id ay18-20020a5d9d92000000b00760dffaf13dmr4398083iob.3.1682032643322;
        Thu, 20 Apr 2023 16:17:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a6-20020a029406000000b0040bbb88f308sm843720jai.17.2023.04.20.16.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 16:17:22 -0700 (PDT)
Date:   Thu, 20 Apr 2023 17:17:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     <ankita@nvidia.com>
Cc:     <jgg@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
        <acurrid@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper device
Message-ID: <20230420171720.418a3c0d.alex.williamson@redhat.com>
In-Reply-To: <20230419222836.24714-1-ankita@nvidia.com>
References: <20230419222836.24714-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Apr 2023 15:28:36 -0700
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal propritary cache coherent interconnect.
> 
> This representation has a number of limitations compared to a real PCI
> device, in particular, it does not model the coherent GPU memory
> aperture as a PCI config space BAR, and PCI doesn't know anything
> about cacheable memory types.
> 
> Provide a VFIO PCI variant driver that adapts the unique PCI
> representation into a more standard PCI representation facing
> userspace. The GPU memory aperture is obtained from ACPI using
> device_property_read_u64(), according to the FW specification,
> and exported to userspace as the VFIO_REGION that covers the first
> PCI BAR. qemu will naturally generate a PCI device in the VM where the
> cacheable aperture is reported in BAR1.
> 
> Since this memory region is actually cache coherent with the CPU, the
> VFIO variant driver will mmap it into VMA using a cacheable mapping. The
> mapping is done using remap_pfn_range().
> 
> This goes along with a qemu series to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device.
> https://github.com/qemu/qemu/compare/master...ankita-nv:qemu:dev-ankit/cohmem-0330
> 
> This patch is split from a patch series being pursued separately:
> https://lore.kernel.org/lkml/20230405180134.16932-2-ankita@nvidia.com/
> 
> Applied and tested over v6.3-rc4.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                     |   6 +
>  drivers/vfio/pci/Kconfig        |   2 +
>  drivers/vfio/pci/Makefile       |   2 +
>  drivers/vfio/pci/nvgpu/Kconfig  |  10 ++
>  drivers/vfio/pci/nvgpu/Makefile |   3 +
>  drivers/vfio/pci/nvgpu/main.c   | 255 ++++++++++++++++++++++++++++++++
>  6 files changed, 278 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1dc8bd26b6cf..6b48756c30d3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21954,6 +21954,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/pci/mlx5/
>  
> +VFIO NVIDIA PCI DRIVER
> +M:	Ankit Agrawal <ankita@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/pci/nvgpu/
> +
>  VGA_SWITCHEROO
>  R:	Lukas Wunner <lukas@wunner.de>
>  S:	Maintained
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738..ade18b0ffb7b 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -59,4 +59,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
>  
>  source "drivers/vfio/pci/hisilicon/Kconfig"
>  
> +source "drivers/vfio/pci/nvgpu/Kconfig"
> +
>  endif
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 24c524224da5..0c93d452d0da 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>  obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> +
> +obj-$(CONFIG_NVGPU_VFIO_PCI) += nvgpu/
> diff --git a/drivers/vfio/pci/nvgpu/Kconfig b/drivers/vfio/pci/nvgpu/Kconfig
> new file mode 100644
> index 000000000000..066f764f7c5f
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgpu/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config NVGPU_VFIO_PCI
> +	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> +	select VFIO_PCI_CORE
> +	help
> +	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
> +	  required to assign the GPU device to a VM using KVM/qemu/etc.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/nvgpu/Makefile b/drivers/vfio/pci/nvgpu/Makefile
> new file mode 100644
> index 000000000000..00fd3a078218
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgpu/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_NVGPU_VFIO_PCI) += nvgpu-vfio-pci.o
> +nvgpu-vfio-pci-y := main.o
> diff --git a/drivers/vfio/pci/nvgpu/main.c b/drivers/vfio/pci/nvgpu/main.c
> new file mode 100644
> index 000000000000..9e08e8cf4606
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgpu/main.c
> @@ -0,0 +1,255 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#define DUMMY_PFN \
> +	(((nvdev->mem_prop.hpa + nvdev->mem_prop.mem_length) >> PAGE_SHIFT) - 1)
> +
> +struct dev_mem_properties {
> +	uint64_t hpa;
> +	uint64_t mem_length;
> +	int bar1_start_offset;
> +};
> +
> +struct nvgpu_vfio_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	struct dev_mem_properties mem_prop;
> +};
> +
> +static int vfio_get_bar1_start_offset(struct vfio_pci_core_device *vdev)
> +{
> +	u8 val = 0;
> +
> +	pci_read_config_byte(vdev->pdev, 0x10, &val);
> +	/*
> +	 * The BAR1 start offset in the PCI config space depends on the BAR0size.
> +	 * Check if the BAR0 is 64b and return the approproiate BAR1 offset.
> +	 */
> +	if (val & PCI_BASE_ADDRESS_MEM_TYPE_64)
> +		return VFIO_PCI_BAR2_REGION_INDEX;
> +
> +	return VFIO_PCI_BAR1_REGION_INDEX;
> +}

This is really confusing offsets vs indexes, it's clearly returning a
region index, not offset.  Also we already have resources setup for
BAR0, so rather than working on the raw BAR value, how about:

	return pci_resource_flags(vdev->pdev, 0) & IORESOURCE_MEM_64 ?
			VFIO_PCI_BAR2_REGION_INDEX : VFIO_PCI_BAR1_REGION_INDEX;

OTOH, why are we trying to pack the BARs, couldn't we always put it at
BAR2?

> +
> +static int nvgpu_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	nvdev->mem_prop.bar1_start_offset = vfio_get_bar1_start_offset(vdev);
> +
> +	return ret;
> +}
> +
> +static int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
> +			struct vm_area_struct *vma)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
> +
> +	unsigned long start_pfn;
> +	unsigned int index;
> +	u64 req_len, pgoff;
> +	int ret = 0;
> +
> +	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	if (index != nvdev->mem_prop.bar1_start_offset)

offset vs index...

> +		return vfio_pci_core_mmap(core_vdev, vma);
> +
> +	/*
> +	 * Request to mmap the BAR1. Map to the CPU accessible memory on the

But it might be BAR2...

> +	 * GPU using the memory information gathered from the system ACPI
> +	 * tables.
> +	 */
> +	start_pfn = nvdev->mem_prop.hpa >> PAGE_SHIFT;
> +	req_len = vma->vm_end - vma->vm_start;
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	if (pgoff >= (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	/*
> +	 * Perform a PFN map to the memory. The device BAR1 is backed by the
> +	 * GPU memory now. Check that the mapping does not overflow out of
> +	 * the GPU memory size.
> +	 */
> +	ret = remap_pfn_range(vma, vma->vm_start, start_pfn + pgoff,
> +			      min(req_len, nvdev->mem_prop.mem_length - pgoff),
> +			      vma->vm_page_prot);

What's the behavior of this "BAR" relative to things like
PCI_COMMAND_MEMORY or reset?  If the user generates a secondary bus
reset on the parent bridge in one thread, while accessing the device in
another thread, isn't that susceptible to platform error handling just
like any other PCI device?  This is why vfio-pci-core has all the
zapping and faulting of mmaps to real BARs.

> +	if (ret)
> +		return ret;
> +
> +	vma->vm_pgoff = start_pfn + pgoff;
> +
> +	return 0;
> +}
> +
> +static long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
> +			unsigned int cmd, unsigned long arg)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
> +
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct vfio_region_info info;
> +
> +	switch (cmd) {
> +	case VFIO_DEVICE_GET_REGION_INFO:
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (info.index == nvdev->mem_prop.bar1_start_offset) {

index vs offset...

> +			/*
> +			 * Request to determine the BAR1 region information. Send the
> +			 * GPU memory information.
> +			 */
> +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +			info.size = nvdev->mem_prop.mem_length;
> +			info.flags = VFIO_REGION_INFO_FLAG_READ |
> +				     VFIO_REGION_INFO_FLAG_WRITE |
> +				     VFIO_REGION_INFO_FLAG_MMAP;
> +			return copy_to_user((void __user *)arg, &info, minsz) ?
> +				       -EFAULT : 0;
> +		}
> +
> +		if (info.index == nvdev->mem_prop.bar1_start_offset + 1) {
> +			/*
> +			 * The BAR1 region is 64b. Ignore this access.
> +			 */
> +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +			info.size = 0;
> +			info.flags = 0;
> +			return copy_to_user((void __user *)arg, &info, minsz) ?
> +				-EFAULT : 0;
> +		}

Not sure why the core code doesn't handle BAR+1

> +
> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +
> +	default:
> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +	}

This might work better as simply:

	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
		/* virtual BAR returns... */
	}

	return vfio_pci_core_ioctl(...);

It at least avoids the duplication.

> +}
> +
> +static const struct vfio_device_ops nvgpu_vfio_pci_ops = {
> +	.name = "nvgpu-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = nvgpu_vfio_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = nvgpu_vfio_pci_ioctl,
> +	.read = vfio_pci_core_read,
> +	.write = vfio_pci_core_write,
> +	.mmap = nvgpu_vfio_pci_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +static struct nvgpu_vfio_pci_core_device *nvgpu_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct nvgpu_vfio_pci_core_device,
> +			    core_device);
> +}
> +
> +static int
> +nvgpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
> +				     struct nvgpu_vfio_pci_core_device *nvdev)
> +{
> +	int ret = 0;

Unnecessary initialization.  Thanks,

Alex

> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
> +	 */
> +	ret = device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-base-pa",
> +				       &(nvdev->mem_prop.hpa));
> +	if (ret)
> +		return ret;
> +
> +	ret = device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-size",
> +				       &(nvdev->mem_prop.mem_length));
> +	return ret;
> +}
> +
> +static int nvgpu_vfio_pci_probe(struct pci_dev *pdev,
> +				const struct pci_device_id *id)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev;
> +	int ret;
> +
> +	nvdev = vfio_alloc_device(nvgpu_vfio_pci_core_device, core_device.vdev,
> +				  &pdev->dev, &nvgpu_vfio_pci_ops);
> +	if (IS_ERR(nvdev))
> +		return PTR_ERR(nvdev);
> +
> +	dev_set_drvdata(&pdev->dev, nvdev);
> +
> +	ret = nvgpu_vfio_pci_fetch_memory_property(pdev, nvdev);
> +	if (ret)
> +		goto out_put_vdev;
> +
> +	ret = vfio_pci_core_register_device(&nvdev->core_device);
> +	if (ret)
> +		goto out_put_vdev;
> +
> +	return ret;
> +
> +out_put_vdev:
> +	vfio_put_device(&nvdev->core_device.vdev);
> +	return ret;
> +}
> +
> +static void nvgpu_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev = nvgpu_drvdata(pdev);
> +	struct vfio_pci_core_device *vdev = &nvdev->core_device;
> +
> +	vfio_pci_core_unregister_device(vdev);
> +	vfio_put_device(&vdev->vdev);
> +}
> +
> +static const struct pci_device_id nvgpu_vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2343) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, nvgpu_vfio_pci_table);
> +
> +static struct pci_driver nvgpu_vfio_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = nvgpu_vfio_pci_table,
> +	.probe = nvgpu_vfio_pci_probe,
> +	.remove = nvgpu_vfio_pci_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(nvgpu_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> +MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
> +MODULE_DESCRIPTION(
> +	"VFIO NVGPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");

