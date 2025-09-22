Return-Path: <kvm+bounces-58412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6AFB93501
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 23:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17ECA7B1B91
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44DB199920;
	Mon, 22 Sep 2025 21:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVzzMELp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EDA23C516
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 21:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758574844; cv=none; b=WSb4KVRLaRmCSM370Z91y+EfIIHEXdo6pi14nQetY8aWEGaGUjvbBtOPucli3Q6f6V3dhbpBNSNAND/sWtZwzsM9vuxmuImVw21HuaL4wJsXLhW7YA4R4MHvqioi02Gn5ee3CaZPUgBA5gjhDKFu1jNm9vDeMnkiB5CBFMtIC5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758574844; c=relaxed/simple;
	bh=r3BZKXh93YGgH/dUToiacxXnRoM0iGzJBY4eyKdtWC8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XugVVuJH02m+mh7LBp3jgvqZNDgJ711xBP08hpdAzdo62qCEJqq1RirKy3aLKds5at0E0DDIgeSPLdjXLDh8pA/autHCjSWEI+gbJ/bi8HNlj1fVIF94k5qNoyHHGT7cg83BFHqP/2S4dPjM7sMqu5QwAHKKY2uKvSfzkPVPWEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KVzzMELp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758574842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u976ILMXRioS/uyYdClouLABKNXfjZw/zLt8Qjs8X1U=;
	b=KVzzMELpWgWsqQDiNWA9G1E2a5oTTvDz4Gh9Wo00/3Z86jUbaH5NmjkpWVlUBXtIu75QdK
	Jl3MpbRMx+ejOQNHva/NvIM/S0z2AiyQLs50ADROxSGg/+Tnj7TKdA0khcv9qn1RtjySer
	ytrljgqktLD90dqqEAsnriPsEF4B99I=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-6pmJrsIfPPyH2mFBZEZb3g-1; Mon, 22 Sep 2025 17:00:37 -0400
X-MC-Unique: 6pmJrsIfPPyH2mFBZEZb3g-1
X-Mimecast-MFC-AGG-ID: 6pmJrsIfPPyH2mFBZEZb3g_1758574837
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4246f1a9723so11507915ab.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 14:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758574837; x=1759179637;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u976ILMXRioS/uyYdClouLABKNXfjZw/zLt8Qjs8X1U=;
        b=FB6QJRZulUZ2iFNNRwC8BnCFq2ArWukaqpfjcdh4VjLQ9NgLPB0JEB9MwaL9YQh7d0
         IaaQywSdqPLhU6OFZ2aFb1HtcRjPfl7WGECwrdCIjiDNtnZLAbZJjXXXIdbHKvctXL1J
         gCj+8/rj4msZnGHKj6L9wOBQ1UrMh9zHj1p2hVevy5QzwEEO5dblF2oeYeu1c8Nt5jcT
         GAZYhi47n09WTyrw2a1PFNNHtbfll/4/p99MZ3zpkFbBQzSjcvAzrCY29zKIdTvDeYGT
         hzIgRcOrkYthOwulnpzi+3d7xFTKZkxFFFkAnbwzX5U4t0TpzQiMWdg8hQIzhR58KhKM
         DPBg==
X-Forwarded-Encrypted: i=1; AJvYcCWMKufPl09frBS6jOZEdjrJwQVzdCfPzRChex1fyW8Qk0+EX11w8QvSovLEwftwRrWufPw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwS74ce+axKAfvbZGgkIH0Ea5WGvw6V3tGRVJrYHVv+pCceggS
	SK8GNGfZNGkj80Hvx4PRVKe5OOn3BYB+5UCfvpH8lFUBsaWAka3YFmMcawQUicgBJAqymFjix+9
	IonOo3Bc8UIQj/uIEEVLQ9Xu46IW7AnaqrlplgITARCnDO1TdIUdgkQ==
X-Gm-Gg: ASbGncslWgE7qHgbzAonfCUIhhkxcwJZG+8wlW25zokELNbDqgFdLsu5+Yc5oA+B3Ff
	asi2fi7fqKJZ3ToJwh4TB0YbdLdeOBlyELrEg/Jk9s0VCgpdXMsatxLb7DqncbvH6+WSNT/IDNV
	A+TWbhACVymkeoYYgKRZnt2kpSI5p9jiIqlSpXFWAThDa3Zpfaik0+mmd+DFSeY9Om5Lqm10da8
	BQtg6kGu32yYZC40QbXTlJhIVkjgWGtXqyRQh8o8rXbyMS9Cx0SJESzhLpiGwhdGk7n0lPEVGs8
	r629/OU8yqEsGoUaKu2Jx7Z4AHYdLLmoTqYPlh+hmKI=
X-Received: by 2002:a05:6e02:1564:b0:424:1774:6908 with SMTP id e9e14a558f8ab-42581d411aemr2507525ab.0.1758574836528;
        Mon, 22 Sep 2025 14:00:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHevCmO0qja9+CaJmqTAnyT70ByyebOs+GgzBvQQPshgkX8jExSjBAAuoPEqWA6rRJFVM2cg==
X-Received: by 2002:a05:6e02:1564:b0:424:1774:6908 with SMTP id e9e14a558f8ab-42581d411aemr2507095ab.0.1758574835992;
        Mon, 22 Sep 2025 14:00:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d3e337bebsm6192605173.28.2025.09.22.14.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 14:00:35 -0700 (PDT)
Date: Mon, 22 Sep 2025 15:00:32 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, dri-devel@lists.freedesktop.org,
 iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
 <joro@8bytes.org>, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250922150032.3e3da410.alex.williamson@redhat.com>
In-Reply-To: <1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
	<1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Sep 2025 14:33:07 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Refactor the PCI P2PDMA subsystem to separate the core peer-to-peer DMA
> functionality from the optional memory allocation layer. This creates a
> two-tier architecture:
> 
> The core layer provides P2P mapping functionality for physical addresses
> based on PCI device MMIO BARs and integrates with the DMA API for
> mapping operations. This layer is required for all P2PDMA users.
> 
> The optional upper layer provides memory allocation capabilities
> including gen_pool allocator, struct page support, and sysfs interface
> for user space access.
> 
> This separation allows subsystems like VFIO to use only the core P2P
> mapping functionality without the overhead of memory allocation features
> they don't need. The core functionality is now available through the
> new pci_p2pdma_enable() function that returns a p2pdma_provider
> structure.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/pci/p2pdma.c       | 129 +++++++++++++++++++++++++++----------
>  include/linux/pci-p2pdma.h |   5 ++
>  2 files changed, 100 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 176a99232fdca..c22cbb3a26030 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -25,11 +25,12 @@ struct pci_p2pdma {
>  	struct gen_pool *pool;
>  	bool p2pmem_published;
>  	struct xarray map_types;
> +	struct p2pdma_provider mem[PCI_STD_NUM_BARS];
>  };
>  
>  struct pci_p2pdma_pagemap {
>  	struct dev_pagemap pgmap;
> -	struct p2pdma_provider mem;
> +	struct p2pdma_provider *mem;
>  };
>  
>  static struct pci_p2pdma_pagemap *to_p2p_pgmap(struct dev_pagemap *pgmap)
> @@ -204,7 +205,7 @@ static void p2pdma_page_free(struct page *page)
>  	struct pci_p2pdma_pagemap *pgmap = to_p2p_pgmap(page_pgmap(page));
>  	/* safe to dereference while a reference is held to the percpu ref */
>  	struct pci_p2pdma *p2pdma = rcu_dereference_protected(
> -		to_pci_dev(pgmap->mem.owner)->p2pdma, 1);
> +		to_pci_dev(pgmap->mem->owner)->p2pdma, 1);
>  	struct percpu_ref *ref;
>  
>  	gen_pool_free_owner(p2pdma->pool, (uintptr_t)page_to_virt(page),
> @@ -227,44 +228,93 @@ static void pci_p2pdma_release(void *data)
>  
>  	/* Flush and disable pci_alloc_p2p_mem() */
>  	pdev->p2pdma = NULL;
> -	synchronize_rcu();
> +	if (p2pdma->pool)
> +		synchronize_rcu();
> +	xa_destroy(&p2pdma->map_types);
> +
> +	if (!p2pdma->pool)
> +		return;
>  
>  	gen_pool_destroy(p2pdma->pool);
>  	sysfs_remove_group(&pdev->dev.kobj, &p2pmem_group);
> -	xa_destroy(&p2pdma->map_types);
>  }
>  
> -static int pci_p2pdma_setup(struct pci_dev *pdev)
> +/**
> + * pcim_p2pdma_enable - Enable peer-to-peer DMA support for a PCI device
> + * @pdev: The PCI device to enable P2PDMA for
> + * @bar: BAR index to get provider
> + *
> + * This function initializes the peer-to-peer DMA infrastructure for a PCI
> + * device. It allocates and sets up the necessary data structures to support
> + * P2PDMA operations, including mapping type tracking.
> + */
> +struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
>  {
> -	int error = -ENOMEM;
>  	struct pci_p2pdma *p2p;
> +	int i, ret;
> +
> +	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
> +	if (p2p)
> +		/* PCI device was "rebound" to the driver */
> +		return &p2p->mem[bar];
>  

This seems like two separate functions rolled into one, an 'initialize
providers' and a 'get provider for BAR'.  The comment above even makes
it sound like only a driver re-probing a device would encounter this
branch, but the use case later in vfio-pci shows it to be the common
case to iterate BARs for a device.

But then later in patch 8/ and again in 10/ why exactly do we cache
the provider on the vfio_pci_core_device rather than ask for it on
demand from the p2pdma?

It also seems like the coordination of a valid provider is ad-hoc
between p2pdma and vfio-pci.  For example, this only fills providers
for MMIO BARs and vfio-pci validates that dmabuf operations are for
MMIO BARs, but it would be more consistent if vfio-pci relied on p2pdma
to give it a valid provider for a given BAR.  Thanks,

Alex

>  	p2p = devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
>  	if (!p2p)
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  
>  	xa_init(&p2p->map_types);
> +	/*
> +	 * Iterate over all standard PCI BARs and record only those that
> +	 * correspond to MMIO regions. Skip non-memory resources (e.g. I/O
> +	 * port BARs) since they cannot be used for peer-to-peer (P2P)
> +	 * transactions.
> +	 */
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> +		if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
> +			continue;
>  
> -	p2p->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
> -	if (!p2p->pool)
> -		goto out;
> +		p2p->mem[i].owner = &pdev->dev;
> +		p2p->mem[i].bus_offset =
> +			pci_bus_address(pdev, i) - pci_resource_start(pdev, i);
> +	}
>  
> -	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_release, pdev);
> -	if (error)
> -		goto out_pool_destroy;
> +	ret = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_release, pdev);
> +	if (ret)
> +		goto out_p2p;
>  
> -	error = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
> -	if (error)
> +	rcu_assign_pointer(pdev->p2pdma, p2p);
> +	return &p2p->mem[bar];
> +
> +out_p2p:
> +	devm_kfree(&pdev->dev, p2p);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(pcim_p2pdma_enable);
> +
> +static int pci_p2pdma_setup_pool(struct pci_dev *pdev)
> +{
> +	struct pci_p2pdma *p2pdma;
> +	int ret;
> +
> +	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
> +	if (p2pdma->pool)
> +		/* We already setup pools, do nothing, */
> +		return 0;
> +
> +	p2pdma->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
> +	if (!p2pdma->pool)
> +		return -ENOMEM;
> +
> +	ret = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
> +	if (ret)
>  		goto out_pool_destroy;
>  
> -	rcu_assign_pointer(pdev->p2pdma, p2p);
>  	return 0;
>  
>  out_pool_destroy:
> -	gen_pool_destroy(p2p->pool);
> -out:
> -	devm_kfree(&pdev->dev, p2p);
> -	return error;
> +	gen_pool_destroy(p2pdma->pool);
> +	p2pdma->pool = NULL;
> +	return ret;
>  }
>  
>  static void pci_p2pdma_unmap_mappings(void *data)
> @@ -276,7 +326,7 @@ static void pci_p2pdma_unmap_mappings(void *data)
>  	 * unmap_mapping_range() on the inode, teardown any existing userspace
>  	 * mappings and prevent new ones from being created.
>  	 */
> -	sysfs_remove_file_from_group(&p2p_pgmap->mem.owner->kobj,
> +	sysfs_remove_file_from_group(&p2p_pgmap->mem->owner->kobj,
>  				     &p2pmem_alloc_attr.attr,
>  				     p2pmem_group.name);
>  }
> @@ -295,6 +345,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  			    u64 offset)
>  {
>  	struct pci_p2pdma_pagemap *p2p_pgmap;
> +	struct p2pdma_provider *mem;
>  	struct dev_pagemap *pgmap;
>  	struct pci_p2pdma *p2pdma;
>  	void *addr;
> @@ -312,15 +363,25 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  	if (size + offset > pci_resource_len(pdev, bar))
>  		return -EINVAL;
>  
> -	if (!pdev->p2pdma) {
> -		error = pci_p2pdma_setup(pdev);
> +	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
> +	if (!p2pdma) {
> +		mem = pcim_p2pdma_enable(pdev, bar);
> +		if (IS_ERR(mem))
> +			return PTR_ERR(mem);
> +
> +		error = pci_p2pdma_setup_pool(pdev);
>  		if (error)
>  			return error;
> -	}
> +
> +		p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
> +	} else
> +		mem = &p2pdma->mem[bar];
>  
>  	p2p_pgmap = devm_kzalloc(&pdev->dev, sizeof(*p2p_pgmap), GFP_KERNEL);
> -	if (!p2p_pgmap)
> -		return -ENOMEM;
> +	if (!p2p_pgmap) {
> +		error = -ENOMEM;
> +		goto free_pool;
> +	}
>  
>  	pgmap = &p2p_pgmap->pgmap;
>  	pgmap->range.start = pci_resource_start(pdev, bar) + offset;
> @@ -328,9 +389,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  	pgmap->nr_range = 1;
>  	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
>  	pgmap->ops = &p2pdma_pgmap_ops;
> -	p2p_pgmap->mem.owner = &pdev->dev;
> -	p2p_pgmap->mem.bus_offset =
> -		pci_bus_address(pdev, bar) - pci_resource_start(pdev, bar);
> +	p2p_pgmap->mem = mem;
>  
>  	addr = devm_memremap_pages(&pdev->dev, pgmap);
>  	if (IS_ERR(addr)) {
> @@ -343,7 +402,6 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  	if (error)
>  		goto pages_free;
>  
> -	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
>  	error = gen_pool_add_owner(p2pdma->pool, (unsigned long)addr,
>  			pci_bus_address(pdev, bar) + offset,
>  			range_len(&pgmap->range), dev_to_node(&pdev->dev),
> @@ -359,7 +417,10 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  pages_free:
>  	devm_memunmap_pages(&pdev->dev, pgmap);
>  pgmap_free:
> -	devm_kfree(&pdev->dev, pgmap);
> +	devm_kfree(&pdev->dev, p2p_pgmap);
> +free_pool:
> +	sysfs_remove_group(&pdev->dev.kobj, &p2pmem_group);
> +	gen_pool_destroy(p2pdma->pool);
>  	return error;
>  }
>  EXPORT_SYMBOL_GPL(pci_p2pdma_add_resource);
> @@ -1008,11 +1069,11 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
>  {
>  	struct pci_p2pdma_pagemap *p2p_pgmap = to_p2p_pgmap(page_pgmap(page));
>  
> -	if (state->mem == &p2p_pgmap->mem)
> +	if (state->mem == p2p_pgmap->mem)
>  		return;
>  
> -	state->mem = &p2p_pgmap->mem;
> -	state->map = pci_p2pdma_map_type(&p2p_pgmap->mem, dev);
> +	state->mem = p2p_pgmap->mem;
> +	state->map = pci_p2pdma_map_type(p2p_pgmap->mem, dev);
>  }
>  
>  /**
> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> index eef96636c67e6..888ad7b0c54cf 100644
> --- a/include/linux/pci-p2pdma.h
> +++ b/include/linux/pci-p2pdma.h
> @@ -27,6 +27,7 @@ struct p2pdma_provider {
>  };
>  
>  #ifdef CONFIG_PCI_P2PDMA
> +struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar);
>  int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  		u64 offset);
>  int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
> @@ -45,6 +46,10 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
>  ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
>  			       bool use_p2pdma);
>  #else /* CONFIG_PCI_P2PDMA */
> +static inline struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
>  static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
>  		size_t size, u64 offset)
>  {


