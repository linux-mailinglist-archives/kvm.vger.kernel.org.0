Return-Path: <kvm+bounces-54205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD59AB1CF0C
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 00:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9898D7ABADC
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB3023815D;
	Wed,  6 Aug 2025 22:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bh9a1F/Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB10622E406
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 22:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754519106; cv=none; b=uD/eh0dQq2i0sTy5jPWANkVZodHumnHb8DyqAE8yQeLh+HgR8/yNRGTPHS4d5pTGjIyxD6YLZ+NpPqjazUAJ5zf8GtA+foXMHW/nAy1jawiwbQfs6NPdqa8rWJzhwETRaSHMMElGS/voB+i+/ZmNDU08FFuDwHh6kCbBcGLuMwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754519106; c=relaxed/simple;
	bh=E8mVSJu/tMPT+RCSYBB/JKwAzVd4GM2qVRUojQoI5Yk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=URouqswwmnpT+sVykv3EB2CPs0hZkCxtDvGgbOEafrvABFmQFQpRrXW/ZwpBfgUhtOsltz9NGgfBPE4iN7a0nLPcVX1EzxvLBLfDoPyTi2AUkch+nw9t4Y2zd8UBQC84neSRKXzvkkV3gISspwh2j57iEDqQwbUA67FUjWvyWpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bh9a1F/Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754519102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2KWudinkIbXD4F4ulzK9/+oUi2avXDJW6sBf89lUWmU=;
	b=bh9a1F/QQZqimR8naHWs7xCUacLE+AxSbAHAEijZVyyquS0D9T2eFJ0G0hp0DDa1n9qNXp
	YJmz395QE9CrfZJ8Mqk+Fh/sa7Coqbv4/P3Mmrk2l3YyYXIOgIEN9dros7cP28LKQGa+eL
	HAC4VmznYjuYblq7jM72edaJ8bmTtvk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-8OUtA03YMCCfe1tFKvaq2g-1; Wed, 06 Aug 2025 18:25:01 -0400
X-MC-Unique: 8OUtA03YMCCfe1tFKvaq2g-1
X-Mimecast-MFC-AGG-ID: 8OUtA03YMCCfe1tFKvaq2g_1754519101
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e40b854187so1018275ab.1
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 15:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754519101; x=1755123901;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2KWudinkIbXD4F4ulzK9/+oUi2avXDJW6sBf89lUWmU=;
        b=ubdSGDj7S/KEmsqaJZDxvSRZmSnwf2sv7J3yeYMIkpo2AsXBdRelXmW1c0qfIRXcgm
         DtKyClIu6VKCoF2PHqSs+3/oqhiLCbJ+rRBQ4ZdkkSVjIpG97E+YcWhlsQowTB/tVhpx
         eaPGcMH++NWLBvzyhdpTqM88q2Q2vUKN3MV4fFf8bpxqxR2WK2XYCb0UBnQQgDbc8OLK
         P6iyedCLop2P0e4zEVSqCV7zsiwzIa/pCzwqdsTZTcX7Ng17IctK/FxgYfUw2fFgvERV
         g2/8ypzlyhHGDM3KLNtREOGFCFHjm4MLUdUtUSHDU6qT7tQTwdaNvFNmPkajjgTkGAJS
         ndbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS2olyx+Qb8A6QZwOyz/Bm2xggIYcPfGsp6H118UABO3cLicCBDWy9aguUYMlG3ccJBQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSWJyknEofJtUwpBU5RGn/9IBDVxJV2slDMAQHZndrMORzUWYP
	1xWL4f/og4axcsPhDS+lpOt2uelhLaeiwvWRuqMu3Sx5LYm5E+UKWc3jqb3KeboUnUxLBLvY0aZ
	Hf/IFH+ExkbFBQG8lXigt7H1ZaMccPGighGW1BCrJ4yNEK8inb5O5Qg==
X-Gm-Gg: ASbGncs7JGymvDhxKX0SN1/F0A/EmXrPZIkzPCvfAA9q4mILxTBl1FO6Z5saIgwF5C3
	ZhdXC2ntmMTxVMETTo0FYpZO5ZtaS9qBKUOMvmLFJ0CwPHHGee/hKX/Lw+4uAkphqtoMeyqhVnU
	a+QkhXCWxxeTTHw7NbqetVGcSwbh+mWW3ZacWhwC2Oyhtj/ac2M6VY3j+hcXZ5EHYj36MMwUoGa
	tAbZ+mzxzHj2q9pVilpyFKxpVoss7eG04I9S8Lz9O01Y/jO/VK5n7inZMWJTFNjC+1XTroiewJA
	KaiTbBWYJt+uDbczMFy/OgCW+N3Ykz3CzJEBE2paYLs=
X-Received: by 2002:a05:6602:148a:b0:85d:9793:e0d8 with SMTP id ca18e2360f4ac-8819eddca30mr265752439f.0.1754519100582;
        Wed, 06 Aug 2025 15:25:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJbvSuwj5vna+ENO4HZHTFh+EQIF6Bqd2408Pfz1T06ISMEQUJO+65aGvhO/KGJJ7KSEu0KQ==
X-Received: by 2002:a05:6602:148a:b0:85d:9793:e0d8 with SMTP id ca18e2360f4ac-8819eddca30mr265749739f.0.1754519100087;
        Wed, 06 Aug 2025 15:25:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-88175b2e0c6sm314280239f.31.2025.08.06.15.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 15:24:59 -0700 (PDT)
Date: Wed, 6 Aug 2025 16:24:55 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Christoph Hellwig <hch@lst.de>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250806162455.350f73a4.alex.williamson@redhat.com>
In-Reply-To: <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
	<5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  4 Aug 2025 16:00:45 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add support for exporting PCI device MMIO regions through dma-buf,
> enabling safe sharing of non-struct page memory with controlled
> lifetime management. This allows RDMA and other subsystems to import
> dma-buf FDs and build them into memory regions for PCI P2P operations.
> 
> The implementation provides a revocable attachment mechanism using
> dma-buf move operations. MMIO regions are normally pinned as BARs
> don't change physical addresses, but access is revoked when the VFIO
> device is closed or a PCI reset is issued. This ensures kernel
> self-defense against potentially hostile userspace.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig           |  20 ++
>  drivers/vfio/pci/Makefile          |   2 +
>  drivers/vfio/pci/vfio_pci_config.c |  22 +-
>  drivers/vfio/pci/vfio_pci_core.c   |  25 +-
>  drivers/vfio/pci/vfio_pci_dmabuf.c | 390 +++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
>  include/linux/dma-buf.h            |   1 +
>  include/linux/vfio_pci_core.h      |   3 +
>  include/uapi/linux/vfio.h          |  25 ++
>  9 files changed, 506 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 2b0172f546652..55ae888bf26ae 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -55,6 +55,26 @@ config VFIO_PCI_ZDEV_KVM
>  
>  	  To enable s390x KVM vfio-pci extensions, say Y.
>  
> +config VFIO_PCI_DMABUF
> +	bool "VFIO PCI extensions for DMA-BUF"
> +	depends on VFIO_PCI_CORE
> +	depends on PCI_P2PDMA && DMA_SHARED_BUFFER
> +	default y
> +	help
> +	  Enable support for VFIO PCI extensions that allow exporting
> +	  device MMIO regions as DMA-BUFs for peer devices to access via
> +	  peer-to-peer (P2P) DMA.
> +
> +	  This feature enables a VFIO-managed PCI device to export a portion
> +	  of its MMIO BAR as a DMA-BUF file descriptor, which can be passed
> +	  to other userspace drivers or kernel subsystems capable of
> +	  initiating DMA to that region.
> +
> +	  Say Y here if you want to enable VFIO DMABUF-based MMIO export
> +	  support for peer-to-peer DMA use cases.
> +
> +	  If unsure, say N.
> +
>  source "drivers/vfio/pci/mlx5/Kconfig"
>  
>  source "drivers/vfio/pci/hisilicon/Kconfig"
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index cf00c0a7e55c8..f9155e9c5f630 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -2,7 +2,9 @@
>  
>  vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
>  vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV_KVM) += vfio_pci_zdev.o
> +
>  obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
> +vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o
>  
>  vfio-pci-y := vfio_pci.o
>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 8f02f236b5b4b..7e23387a43b4d 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -589,10 +589,12 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
>  		virt_mem = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_MEMORY);
>  		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
>  
> -		if (!new_mem)
> +		if (!new_mem) {
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
> -		else
> +			vfio_pci_dma_buf_move(vdev, true);
> +		} else {
>  			down_write(&vdev->memory_lock);
> +		}
>  
>  		/*
>  		 * If the user is writing mem/io enable (new_mem/io) and we
> @@ -627,6 +629,8 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
>  		*virt_cmd &= cpu_to_le16(~mask);
>  		*virt_cmd |= cpu_to_le16(new_cmd & mask);
>  
> +		if (__vfio_pci_memory_enabled(vdev))
> +			vfio_pci_dma_buf_move(vdev, false);
>  		up_write(&vdev->memory_lock);
>  	}
>  
> @@ -707,12 +711,16 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
>  static void vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
>  					  pci_power_t state)
>  {
> -	if (state >= PCI_D3hot)
> +	if (state >= PCI_D3hot) {
>  		vfio_pci_zap_and_down_write_memory_lock(vdev);
> -	else
> +		vfio_pci_dma_buf_move(vdev, true);
> +	} else {
>  		down_write(&vdev->memory_lock);
> +	}
>  
>  	vfio_pci_set_power_state(vdev, state);
> +	if (__vfio_pci_memory_enabled(vdev))
> +		vfio_pci_dma_buf_move(vdev, false);
>  	up_write(&vdev->memory_lock);
>  }
>  
> @@ -900,7 +908,10 @@ static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
>  
>  		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
> +			vfio_pci_dma_buf_move(vdev, true);
>  			pci_try_reset_function(vdev->pdev);
> +			if (__vfio_pci_memory_enabled(vdev))
> +				vfio_pci_dma_buf_move(vdev, true);

@revoked true -> true seems wrong.

>  			up_write(&vdev->memory_lock);
>  		}
>  	}
> @@ -982,7 +993,10 @@ static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
>  
>  		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
> +			vfio_pci_dma_buf_move(vdev, true);
>  			pci_try_reset_function(vdev->pdev);
> +			if (__vfio_pci_memory_enabled(vdev))
> +				vfio_pci_dma_buf_move(vdev, true);

Same.

>  			up_write(&vdev->memory_lock);
>  		}
>  	}
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index b1863d84b11aa..8e840ac413e9b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -28,7 +28,9 @@
>  #include <linux/nospec.h>
>  #include <linux/sched/mm.h>
>  #include <linux/iommufd.h>
> +#ifdef CONFIG_VFIO_PCI_DMABUF
>  #include <linux/pci-p2pdma.h>
> +#endif
>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
> @@ -287,6 +289,8 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
>  	 * semaphore.
>  	 */
>  	vfio_pci_zap_and_down_write_memory_lock(vdev);
> +	vfio_pci_dma_buf_move(vdev, true);
> +
>  	if (vdev->pm_runtime_engaged) {
>  		up_write(&vdev->memory_lock);
>  		return -EINVAL;
> @@ -370,6 +374,8 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
>  	 */
>  	down_write(&vdev->memory_lock);
>  	__vfio_pci_runtime_pm_exit(vdev);
> +	if (__vfio_pci_memory_enabled(vdev))
> +		vfio_pci_dma_buf_move(vdev, false);
>  	up_write(&vdev->memory_lock);
>  }
>  
> @@ -690,6 +696,8 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  #endif
>  	vfio_pci_core_disable(vdev);
>  
> +	vfio_pci_dma_buf_cleanup(vdev);
> +
>  	mutex_lock(&vdev->igate);
>  	if (vdev->err_trigger) {
>  		eventfd_ctx_put(vdev->err_trigger);
> @@ -1222,7 +1230,10 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
>  	 */
>  	vfio_pci_set_power_state(vdev, PCI_D0);
>  
> +	vfio_pci_dma_buf_move(vdev, true);
>  	ret = pci_try_reset_function(vdev->pdev);
> +	if (__vfio_pci_memory_enabled(vdev))
> +		vfio_pci_dma_buf_move(vdev, false);
>  	up_write(&vdev->memory_lock);
>  
>  	return ret;
> @@ -1511,6 +1522,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  		return vfio_pci_core_pm_exit(vdev, flags, arg, argsz);
>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>  		return vfio_pci_core_feature_token(vdev, flags, arg, argsz);
> +	case VFIO_DEVICE_FEATURE_DMA_BUF:
> +		return vfio_pci_core_feature_dma_buf(vdev, flags, arg, argsz);
>  	default:
>  		return -ENOTTY;
>  	}
> @@ -2085,9 +2098,13 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
>  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
>  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> +#ifdef CONFIG_VFIO_PCI_DMABUF
>  	vdev->provider = pci_p2pdma_enable(vdev->pdev);
>  	if (IS_ERR(vdev->provider))
>  		return PTR_ERR(vdev->provider);
> +
> +	INIT_LIST_HEAD(&vdev->dmabufs);
> +#endif
>  	init_rwsem(&vdev->memory_lock);
>  	xa_init(&vdev->ctx);
>  
> @@ -2470,11 +2487,17 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  	 * cause the PCI config space reset without restoring the original
>  	 * state (saved locally in 'vdev->pm_save').
>  	 */
> -	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> +	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list) {
> +		vfio_pci_dma_buf_move(vdev, true);
>  		vfio_pci_set_power_state(vdev, PCI_D0);
> +	}

The revoke should have happened at the time the BARs were zapped.
Thanks,

Alex

>  
>  	ret = pci_reset_bus(pdev);
>  
> +	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> +		if (__vfio_pci_memory_enabled(vdev))
> +			vfio_pci_dma_buf_move(vdev, false);
> +
>  	vdev = list_last_entry(&dev_set->device_list,
>  			       struct vfio_pci_core_device, vdev.dev_set_list);
>  


