Return-Path: <kvm+bounces-28645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A8C99AB01
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 20:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2ED89B23389
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 18:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DEE2405FB;
	Fri, 11 Oct 2024 18:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QMtf1ffu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B39819F13B
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 18:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728671642; cv=none; b=uidHDwfvZqydP8MtACxD2TwUwWSEKmFnOwi5xwseCobrONb51mif9nHBOCulO9huORDZIZLcWyK+H3uzk2UNRoTb+eK9yhc/CXU0WKgyC2/KNVdgfHM+/XNqIlZ8BsWrHfJ9iqNy9fcwLWIbna3HxPf3Fw0u9bipSr25jSVOTwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728671642; c=relaxed/simple;
	bh=3/GHCGogAuhYSv//x85j/Z6b9fGW4Nuf2Rs+fdP7h/c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lXJBruRw98VInIaD3fhEXio4zvuZ0U1xLSuXwgZPFsL4Ic4iyExzDRfbP42azzRAYGMBN3gE54c9msAoTbUsWNboPsqflQTeVRJGG9rXlbmzc6Ctn+Vobv0qE6baNNi3OxJnRTzGfiM3cqCbRGehre0w/pv+7f2nS9fgOdLFt8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QMtf1ffu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728671639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VWEsJtQknKO+f6wwawdGRc5BYz0aknSe6+kTVKNHDEQ=;
	b=QMtf1ffuSTMx3nhOqoB44EWZhV1c7VliyDcoh4m/GIAnI/ThBivRBfk2h1ruw6p15iUkRT
	Q6XUuKhozjt/+a6w2+yfw+ME45uOTXOCVyG/YlReidqxl1e9xE+zqpOZN7WgJO2uZBOf87
	u5+m5WA2936Oz6UVxvHxaAvtocM2JsQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-LOaqGv-vOEG7tt-iH1-Cdw-1; Fri, 11 Oct 2024 14:33:56 -0400
X-MC-Unique: LOaqGv-vOEG7tt-iH1-Cdw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8353bd6481fso32441239f.1
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 11:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728671636; x=1729276436;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VWEsJtQknKO+f6wwawdGRc5BYz0aknSe6+kTVKNHDEQ=;
        b=iF4cnQi1yNr/XjO4e3HjbrMSfwzJxD1pnfEeLCNFcsQBifKu+4dcbYgo1XH87ms7mj
         VwiIo7LlaWZhxkBSNhRKR6+U4XKpv/DnM42pZIHn+vuW6KgXGrODKmEU8ldKFLDl+ic3
         a+2DWJlD1jml8u97NXTG0M0JKdl04L3mnVK76Fy2zndUgrDN4mk07Ugru6aPfjH7GoVs
         E1IKBsMfiAOROw9UtVFUV74kXvLuDWvSOZXZ6M4UJmsLfE+4CXv9zBPtP33DLeGx7U0S
         lcFT625KUJ1rsVp1TQL7J25RbVXmjnHQwtessVk+c2ye9hPoqe4KMxbaZajIKfElEtOP
         Vk0A==
X-Gm-Message-State: AOJu0Yw3pWqseAF5Irn/5KvRtqNyGJTrQYwEpImg82FTbMVoERvMlJfS
	rTwJredr5UnevrSRaEJFISzEhN1N/NsJIUy9NzYuZHCjqaAtLFeGKfnNwg7xavIatLZLbCEhqjb
	8jrw6H+cpCu2Jrr/JDZ8D8TwssrpznjbMRzKMRwLjD0mvRr/aMQ==
X-Received: by 2002:a5e:df09:0:b0:82c:edde:1284 with SMTP id ca18e2360f4ac-8378f459394mr85040039f.0.1728671635660;
        Fri, 11 Oct 2024 11:33:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEd6OXg+HD0QliOBqjfCfwDOnHpiNIAAOMAgvMMk32OIcgd0iGT0f7gaPJGraeLqmTu/XYybQ==
X-Received: by 2002:a5e:df09:0:b0:82c:edde:1284 with SMTP id ca18e2360f4ac-8378f459394mr85037139f.0.1728671635073;
        Fri, 11 Oct 2024 11:33:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbada84a35sm749888173.117.2024.10.11.11.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 11:33:54 -0700 (PDT)
Date: Fri, 11 Oct 2024 12:33:51 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <alison.schofield@intel.com>,
 <dan.j.williams@intel.com>, <dave.jiang@intel.com>, <dave@stgolabs.net>,
 <jonathan.cameron@huawei.com>, <ira.weiny@intel.com>,
 <vishal.l.verma@intel.com>, <alucerop@amd.com>, <acurrid@nvidia.com>,
 <cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
 <aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
 <zhiwang@kernel.org>
Subject: Re: [RFC 04/13] vfio: introduce vfio-cxl core preludes
Message-ID: <20241011123351.27474f2b.alex.williamson@redhat.com>
In-Reply-To: <20240920223446.1908673-5-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
	<20240920223446.1908673-5-zhiw@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Sep 2024 15:34:37 -0700
Zhi Wang <zhiw@nvidia.com> wrote:

> In VFIO, common functions that used by VFIO variant drivers are managed
> in a set of "core" functions. E.g. the vfio-pci-core provides the common
> functions used by VFIO variant drviers to support PCI device
> passhthrough.
> 
> Although the CXL type-2 device has a PCI-compatible interface for device
> configuration and programming, they still needs special handlings when
> initialize the device:
> 
> - Probing the CXL DVSECs in the configuration.
> - Probing the CXL register groups implemented by the device.
> - Configuring the CXL device state required by the kernel CXL core.
> - Create the CXL region.
> - Special handlings of the CXL MMIO BAR.
> 
> Introduce vfio-cxl core predules to hold all the common functions used

s/predules/preludes/

> by VFIO variant drivers to support CXL device passthrough.
> 
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig         |   4 +
>  drivers/vfio/pci/Makefile        |   3 +
>  drivers/vfio/pci/vfio_cxl_core.c | 264 +++++++++++++++++++++++++++++++
>  include/linux/vfio_pci_core.h    |  37 +++++
>  4 files changed, 308 insertions(+)
>  create mode 100644 drivers/vfio/pci/vfio_cxl_core.c
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index bf50ffa10bde..2196e79b132b 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -7,6 +7,10 @@ config VFIO_PCI_CORE
>  	select VFIO_VIRQFD
>  	select IRQ_BYPASS_MANAGER
>  
> +config VFIO_CXL_CORE
> +	tristate
> +	select VFIO_PCI_CORE

I don't see anything in this series that depends on CXL Kconfigs, so it
seems this will break in randconfig when the resulting vfio-cxl variant
driver is enabled without core CXL support.

> +
>  config VFIO_PCI_MMAP
>  	def_bool y if !S390
>  	depends on VFIO_PCI_CORE
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index cf00c0a7e55c..b51221b94b0b 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -8,6 +8,9 @@ vfio-pci-y := vfio_pci.o
>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>  obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>  
> +vfio-cxl-core-y := vfio_cxl_core.o
> +obj-$(CONFIG_VFIO_CXL_CORE) += vfio-cxl-core.o
> +
>  obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
> new file mode 100644
> index 000000000000..6a7859333f67
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_cxl_core.c
> @@ -0,0 +1,264 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
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
> +
> +#include "vfio_pci_priv.h"
> +
> +#define DRIVER_AUTHOR "Zhi Wang <zhiw@nvidia.com>"
> +#define DRIVER_DESC "core driver for VFIO based CXL devices"
> +
> +static int get_hpa_and_request_dpa(struct vfio_pci_core_device *core_dev)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +	struct pci_dev *pdev = core_dev->pdev;
> +	u64 max;
> +
> +	cxl->cxlrd = cxl_get_hpa_freespace(cxl->endpoint, 1,
> +					   CXL_DECODER_F_RAM |
> +					   CXL_DECODER_F_TYPE2,
> +					   &max);

I don't see that this adhere to the comment in cxl_get_hpa_freespace()
that the caller needs to deal with the elevated ref count on the root
decoder.  There's no put_device() call in either the error path or
disable path.

Also, maybe this is inherent in the cxl code, but cxl->cxlrd seems
redundant to me, couldn't we refer to this as cxl->root_decoder? (or
some variant more descriptive than "rd")

Is this exclusively a type2 extension or how do you envision type1/3
devices with vfio?

> +	if (IS_ERR(cxl->cxlrd)) {
> +		pci_err(pdev, "Fail to get HPA space.\n");
> +		return PTR_ERR(cxl->cxlrd);
> +	}
> +
> +	if (max < cxl->region.size) {
> +		pci_err(pdev, "No enough free HPA space %llu < %llu\n",
> +			max, cxl->region.size);
> +		return -ENOSPC;
> +	}
> +
> +	cxl->cxled = cxl_request_dpa(cxl->endpoint, true, cxl->region.size,
> +				     cxl->region.size);

cxl->endpoint_decoder? cxl->endp_dec?

> +	if (IS_ERR(cxl->cxled)) {
> +		pci_err(pdev, "Fail to request DPA\n");
> +		return PTR_ERR(cxl->cxled);
> +	}
> +
> +	return 0;
> +}
> +
> +static int create_cxl_region(struct vfio_pci_core_device *core_dev)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +	struct pci_dev *pdev = core_dev->pdev;
> +	resource_size_t start, end;
> +	int ret;
> +
> +	ret = cxl_accel_request_resource(cxl->cxlds, true);
> +	if (ret) {
> +		pci_err(pdev, "Fail to request CXL resource\n");
> +		return ret;
> +	}

Where is the corresponding release_resource()?

> +
> +	if (!cxl_await_media_ready(cxl->cxlds)) {
> +		cxl_accel_set_media_ready(cxl->cxlds);
> +	} else {
> +		pci_err(pdev, "CXL media is not active\n");
> +		return ret;
> +	}

We're not capturing the media ready error for this return.  I think
Jason would typically suggest a success oriented flow as:

	ret = cxl_await_media_ready(cxl->cxlds)
	if (ret) {
		pci_err(...);
		return ret;
	}
	cxl_accel_set_media_ready(cxl->cxlds);

> +
> +	cxl->cxlmd = devm_cxl_add_memdev(&pdev->dev, cxl->cxlds);
> +	if (IS_ERR(cxl->cxlmd)) {
> +		pci_err(pdev, "Fail to create CXL memdev\n");
> +		return PTR_ERR(cxl->cxlmd);
> +	}
> +
> +	cxl->endpoint = cxl_acquire_endpoint(cxl->cxlmd);
> +	if (IS_ERR(cxl->endpoint)) {
> +		pci_err(pdev, "Fail to acquire CXL endpoint\n");
> +		return PTR_ERR(cxl->endpoint);
> +	}
> +
> +	ret = get_hpa_and_request_dpa(core_dev);
> +	if (ret)
> +		goto out;
> +
> +	cxl->region.region = cxl_create_region(cxl->cxlrd, &cxl->cxled, 1);
> +	if (IS_ERR(cxl->region.region)) {
> +		ret = PTR_ERR(cxl->region.region);
> +		pci_err(pdev, "Fail to create CXL region\n");
> +		cxl_dpa_free(cxl->cxled);
> +		goto out;
> +	}
> +
> +	cxl_accel_get_region_params(cxl->region.region, &start, &end);
> +
> +	cxl->region.addr = start;
> +out:
> +	cxl_release_endpoint(cxl->cxlmd, cxl->endpoint);
> +	return ret;
> +}
> +
> +/* Standard CXL-type 2 driver initialization sequence */
> +static int enable_cxl(struct vfio_pci_core_device *core_dev, u16 dvsec)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +	struct pci_dev *pdev = core_dev->pdev;
> +	u32 count;
> +	u64 offset, size;
> +	int ret;
> +
> +	cxl->cxlds = cxl_accel_state_create(&pdev->dev, cxl->caps);
> +	if (IS_ERR(cxl->cxlds))
> +		return PTR_ERR(cxl->cxlds);
> +
> +	cxl_accel_set_dvsec(cxl->cxlds, dvsec);
> +	cxl_accel_set_serial(cxl->cxlds, pdev->dev.id);

Doesn't seem to meet the description were cxl_device_state.serial is
described as the PCIe device serial number, not a struct device
instance number.

> +
> +	cxl_accel_set_resource(cxl->cxlds, cxl->dpa_res, CXL_ACCEL_RES_DPA);
> +	cxl_accel_set_resource(cxl->cxlds, cxl->ram_res, CXL_ACCEL_RES_RAM);
> +
> +	ret = cxl_pci_accel_setup_regs(pdev, cxl->cxlds);
> +	if (ret) {
> +		pci_err(pdev, "Fail to setup CXL accel regs\n");
> +		return ret;
> +	}
> +
> +	ret = cxl_get_hdm_info(cxl->cxlds, &count, &offset, &size);
> +	if (ret)
> +		return ret;
> +
> +	if (!count || !size) {
> +		pci_err(pdev, "Fail to find CXL HDM reg offset\n");
> +		return -ENODEV;
> +	}
> +
> +	cxl->hdm_count = count;
> +	cxl->hdm_reg_offset = offset;
> +	cxl->hdm_reg_size = size;
> +
> +	return create_cxl_region(core_dev);
> +}
> +
> +static void disable_cxl(struct vfio_pci_core_device *core_dev)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +
> +	if (cxl->region.region)
> +		cxl_region_detach(cxl->cxled);
> +
> +	if (cxl->cxled)
> +		cxl_dpa_free(cxl->cxled);
> +}
> +
> +int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +	struct pci_dev *pdev = core_dev->pdev;
> +	u16 dvsec;
> +	int ret;
> +
> +	dvsec = pci_find_dvsec_capability(pdev, PCI_VENDOR_ID_CXL,
> +					  CXL_DVSEC_PCIE_DEVICE);
> +	if (!dvsec)
> +		return -ENODEV;
> +
> +	if (!cxl->region.size)
> +		return -EINVAL;
> +
> +	ret = vfio_pci_core_enable(core_dev);
> +	if (ret)
> +		return ret;
> +
> +	ret = enable_cxl(core_dev, dvsec);
> +	if (ret)
> +		goto err_enable_cxl_device;
> +
> +	return 0;
> +
> +err_enable_cxl_device:
> +	vfio_pci_core_disable(core_dev);
> +	return ret;
> +}
> +EXPORT_SYMBOL(vfio_cxl_core_enable);

These should all be _GPL symbols by default, right?

> +
> +void vfio_cxl_core_finish_enable(struct vfio_pci_core_device *core_dev)
> +{
> +	vfio_pci_core_finish_enable(core_dev);
> +}
> +EXPORT_SYMBOL(vfio_cxl_core_finish_enable);
> +
> +void vfio_cxl_core_close_device(struct vfio_device *vdev)
> +{
> +	struct vfio_pci_core_device *core_dev =
> +		container_of(vdev, struct vfio_pci_core_device, vdev);
> +
> +	disable_cxl(core_dev);
> +	vfio_pci_core_close_device(vdev);
> +}
> +EXPORT_SYMBOL(vfio_cxl_core_close_device);
> +
> +/*
> + * Configure the resource required by the kernel CXL core:
> + * device DPA and device RAM size
> + */
> +void vfio_cxl_core_set_resource(struct vfio_pci_core_device *core_dev,
> +				struct resource res,
> +				enum accel_resource type)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +
> +	switch (type) {
> +	case CXL_ACCEL_RES_DPA:
> +		cxl->dpa_size = res.end - res.start + 1;
> +		cxl->dpa_res = res;
> +		break;
> +
> +	case CXL_ACCEL_RES_RAM:
> +		cxl->ram_res = res;
> +		break;
> +
> +	default:
> +		WARN(1, "invalid resource type: %d\n", type);
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL(vfio_cxl_core_set_resource);

It's not obvious to me why we want to multiplex these through one
function rather than have separate functions to set the dpa and ram.
The usage in patch 12/ doesn't really dictate a multiplexed function.

> +
> +/* Configure the expected CXL region size to be created */
> +void vfio_cxl_core_set_region_size(struct vfio_pci_core_device *core_dev,
> +				   u64 size)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +
> +	if (WARN_ON(size > cxl->dpa_size))
> +		return;
> +
> +	if (WARN_ON(cxl->region.region))
> +		return;
> +
> +	cxl->region.size = size;
> +}
> +EXPORT_SYMBOL(vfio_cxl_core_set_region_size);
> +
> +/* Configure the driver cap required by the kernel CXL core */
> +void vfio_cxl_core_set_driver_hdm_cap(struct vfio_pci_core_device *core_dev)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +
> +	cxl->caps |= CXL_ACCEL_DRIVER_CAP_HDM;
> +}
> +EXPORT_SYMBOL(vfio_cxl_core_set_driver_hdm_cap);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_IMPORT_NS(CXL);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index fbb472dd99b3..7762d4a3e825 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -15,6 +15,8 @@
>  #include <linux/types.h>
>  #include <linux/uuid.h>
>  #include <linux/notifier.h>
> +#include <linux/cxl_accel_mem.h>
> +#include <linux/cxl_accel_pci.h>
>  
>  #ifndef VFIO_PCI_CORE_H
>  #define VFIO_PCI_CORE_H
> @@ -49,6 +51,31 @@ struct vfio_pci_region {
>  	u32				flags;
>  };
>  
> +struct vfio_cxl_region {
> +	u64 size;
> +	u64 addr;
> +	struct cxl_region *region;
> +};
> +
> +struct vfio_cxl {
> +	u8 caps;
> +	u64 dpa_size;
> +
> +	u32 hdm_count;

Poor packing, caps and hdm_count should at least be adjacent to leave
only a single 24-bit gap.

> +	u64 hdm_reg_offset;
> +	u64 hdm_reg_size;
> +
> +	struct cxl_dev_state *cxlds;
> +	struct cxl_memdev *cxlmd;
> +	struct cxl_root_decoder *cxlrd;
> +	struct cxl_port *endpoint;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct resource dpa_res;
> +	struct resource ram_res;
> +
> +	struct vfio_cxl_region region;
> +};
> +
>  struct vfio_pci_core_device {
>  	struct vfio_device	vdev;
>  	struct pci_dev		*pdev;
> @@ -94,6 +121,7 @@ struct vfio_pci_core_device {
>  	struct vfio_pci_core_device	*sriov_pf_core_dev;
>  	struct notifier_block	nb;
>  	struct rw_semaphore	memory_lock;
> +	struct vfio_cxl		cxl;

I'd prefer we not embed a structure here that's unused for 100% of
current use cases.  Why can't we have:

struct vfio_cxl_core_device {
	struct vfio_pci_core_device	pci_core;
	struct vfio_cxl			clx;
};

Thanks,
Alex

>  };
>  
>  /* Will be exported for vfio pci drivers usage */
> @@ -159,4 +187,13 @@ VFIO_IOREAD_DECLARATION(32)
>  VFIO_IOREAD_DECLARATION(64)
>  #endif
>  
> +int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev);
> +void vfio_cxl_core_finish_enable(struct vfio_pci_core_device *core_dev);
> +void vfio_cxl_core_close_device(struct vfio_device *vdev);
> +void vfio_cxl_core_set_resource(struct vfio_pci_core_device *core_dev,
> +				struct resource res,
> +				enum accel_resource type);
> +void vfio_cxl_core_set_region_size(struct vfio_pci_core_device *core_dev,
> +				   u64 size);
> +void vfio_cxl_core_set_driver_hdm_cap(struct vfio_pci_core_device *core_dev);
>  #endif /* VFIO_PCI_CORE_H */


