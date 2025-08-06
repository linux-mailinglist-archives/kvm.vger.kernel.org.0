Return-Path: <kvm+bounces-54204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C859B1CEE7
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 00:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 848C45802A6
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D34B2356D9;
	Wed,  6 Aug 2025 22:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CFdqmzkX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99671FF5E3
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 22:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754517732; cv=none; b=j+vBDNoIgaeUUTEGwJf1Ma0IMOlZXoAb6AzeGZwEJMIaHJSnaEfon1x501xyH1g2MSc4ij4omb4eL2F0isP20C5xJfTU0U1O6FuAtBob+fQZ7NtUpVA4CixyIKL0Zq9A8F87DVFT8tAVs+icEbcMpZPrxGahLHQj0QZBZbI2pws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754517732; c=relaxed/simple;
	bh=sBGR4NtuEpYLnU8xLpZkN2kUNrTNO6/D2QzCl2EwKDw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gksL4NNuHTlUsmpubVfm1EUFGe+Ey9GZEKVsqwPT9OlVOg3baOfm9UF8DhY4pZI/Pn2BGkQyHGE5vZoSEVcgIgHP5KdZP+thqPnjZqxtH7FDNtyGpwqxd8T1LtxsoLSqsZk/J0xwmmVlbxU/dVisK4tWkgvfaMndm6tacd2LmrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CFdqmzkX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754517730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DPKtzeEHbCO/oC/mPOhJydcV6bGZHZZqGISB9ILuO/c=;
	b=CFdqmzkXwjG7/90VFtMUN12j30HgBWafM3zN1/K36BMDJmGJqaoAWh11AXsNwIt3vtZhgy
	eCkNPcT7BppW6x84/Vn8r6n4zLedL2r4suT8IWJ0GaOlzgVzWbHJtPTqhu1V7s+CeCLE9J
	48+RGb7UcKsexp4IfnPS6250Gte8pxs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-JqN-fmn0MXm8NUYTYT1b0Q-1; Wed, 06 Aug 2025 18:02:09 -0400
X-MC-Unique: JqN-fmn0MXm8NUYTYT1b0Q-1
X-Mimecast-MFC-AGG-ID: JqN-fmn0MXm8NUYTYT1b0Q_1754517728
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e3fdfa4b39so609805ab.2
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 15:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754517728; x=1755122528;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DPKtzeEHbCO/oC/mPOhJydcV6bGZHZZqGISB9ILuO/c=;
        b=L89n+rhvpabPHnqwBQx1PjmJ+kkRhhpbFhE8JIIjUt09hx7345EuF2K4HHWLOWbYbs
         JNvFwKOOvU4969clCbZlhX3oUXEALPzqXXUJYZA/CpgYsUfnN/Ys9gGjpOF5CA9WGTQ5
         UtBya1wDhsPlPotgZf2J27hNeWZGTihQpeelTbsz1WDXvf3WygB/9/hu71XFp1uGkNs3
         ckshW2Chl6GWt267hzupHEyet8B2D8OMPS6MSBShyUgf+LjCLyiTXKSpkOkYUr1zDDs4
         rh5f0ACRfuu0tquXsquqRFH65iSIXmhYd94gb8gyDfZqGE8NxOO/OFM7YmDPVif7eKrI
         mMFw==
X-Forwarded-Encrypted: i=1; AJvYcCV0AbEngSH5TDPD/rzdnHE3kVwlAGdhE7QT+isAO0g2He1ytSL7Aq415/tkI7TYFSIoGDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPTxkjnNrLTq+jSBJzkr5SnxVSdjEQL1jeo+L1C7Mfe6ABohMI
	Sq28KMbDdvcqsUN5oLfOsYBHOw1j9mEwL3cTy5GbyhyVDPwDF71o7TOvquvJarotZ9SeyLeh7PV
	vegQl2gMFriepkb7QMiJyAn1LOEUSmUn7pQXHg78vG6U1UkqypeKflw==
X-Gm-Gg: ASbGnctR1aR/kKMTORbK2GcoP5N+PmzSFOnDnoy0GPOtmX0+mD5EksCT3L9Kk/cU4dI
	kFgpVBePlJhR3770d9ytWuKWPMiaHLxm4G6CctawFBl4gkycb+nbj9eJ3n49lMliCflNdwv0gJe
	uYfHyEW0j5ZdLiqALzYP/FcA95hkbG9mFmdbQU1L5ppLHR2dAgFv5NJuLgpn7vDFIAMWbEQLDfu
	N80NGR2gS62PzTdySYeZCIYVNf8+rJ1eH2cIQ/Go6LsMLJ6+6hQ2GAeCUQvccRUEZ3cqTYX3smZ
	eHV44Puh35kjjenODKMHsF3kIJGpIphb4rcoLKWfl68=
X-Received: by 2002:a05:6e02:3193:b0:3dd:c927:3b4f with SMTP id e9e14a558f8ab-3e51b8854c1mr22433065ab.2.1754517727893;
        Wed, 06 Aug 2025 15:02:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIzdy8eeJry7tYq6oPCO7e2LCNwpZ/0SyAUMoLDbyTlBwk+OaaK/N75sVSFjgffH+CpRQ7JQ==
X-Received: by 2002:a05:6e02:3193:b0:3dd:c927:3b4f with SMTP id e9e14a558f8ab-3e51b8854c1mr22432755ab.2.1754517727346;
        Wed, 06 Aug 2025 15:02:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e40297c389sm63783105ab.2.2025.08.06.15.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 15:02:05 -0700 (PDT)
Date: Wed, 6 Aug 2025 16:02:01 -0600
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
Subject: Re: [PATCH v1 08/10] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20250806160201.2b72e7a0.alex.williamson@redhat.com>
In-Reply-To: <edb2ec654fc27ba8f73695382ab0a029f18422b5.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
	<edb2ec654fc27ba8f73695382ab0a029f18422b5.1754311439.git.leon@kernel.org>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  4 Aug 2025 16:00:43 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that all VFIO PCI devices have peer-to-peer capabilities
> enables, so we would be able to export their MMIO memory through DMABUF,
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 4 ++++
>  include/linux/vfio_pci_core.h    | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 31bdb9110cc0f..df9a32d3deac9 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -28,6 +28,7 @@
>  #include <linux/nospec.h>
>  #include <linux/sched/mm.h>
>  #include <linux/iommufd.h>
> +#include <linux/pci-p2pdma.h>
>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
> @@ -2088,6 +2089,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
>  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
>  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> +	vdev->provider = pci_p2pdma_enable(vdev->pdev);
> +	if (IS_ERR(vdev->provider))
> +		return PTR_ERR(vdev->provider);

I think this just made all vfio-pci drivers functionally dependent on
CONFIG_PCI_P2PDMA.  Seems at best exporting a dma-buf should be
restricted if this fails.  Thanks,

Alex

>  	init_rwsem(&vdev->memory_lock);
>  	xa_init(&vdev->ctx);
>  
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index fbb472dd99b36..b017fae251811 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -94,6 +94,7 @@ struct vfio_pci_core_device {
>  	struct vfio_pci_core_device	*sriov_pf_core_dev;
>  	struct notifier_block	nb;
>  	struct rw_semaphore	memory_lock;
> +	struct p2pdma_provider  *provider;
>  };
>  
>  /* Will be exported for vfio pci drivers usage */


