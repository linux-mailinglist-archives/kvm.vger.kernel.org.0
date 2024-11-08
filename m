Return-Path: <kvm+bounces-31322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 872F29C25A2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:34:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0CBD1C234CE
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DEA1C1F1D;
	Fri,  8 Nov 2024 19:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="dnsz5YfG"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A786233D79;
	Fri,  8 Nov 2024 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731094464; cv=none; b=i/+n+UOmpYgHvq0ZprUE369CeVOoxJiLHPFhlSIWN5CHcalR7Vj2RgIgKh1KZ8qxBEWwYUFE08fLKJMCEG2ktsELhOEsHsNVbLMGMwNiC1ZSmAutjAx+WfOvzbIl+0wDnKfz8oI8G2MciDZPr5v/dIsxOyODGu8bhVxbFw2robM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731094464; c=relaxed/simple;
	bh=C3uvS5ZTq0aLuBTlnvNbPqplUhDEa0uq5Q6Z92WD/yE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=h8nLlObSDSThwHelbvAKc0PmG72n10fPLiscQ2eIik98h9NVF9YplOpjleGb1XLq/desXZVGIuab4ri2KFjmftdiL2ynsIJ/Xy++W2+dIJqqhh1m3065pTvIyotaCf0I6H8ufVCOmeYyxsaGROQJIVwzq64bMP0QzdgBU3LYzy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=dnsz5YfG; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 443C842C17
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1731094462; bh=2mf7KL6RauZLJCGVMslddkfvUkwUMRQBSzo8JS8PbOo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dnsz5YfGWANp6sFnIUKjORH9aQENZDGixeRFgCKU+EHYtfew50seKAGvAytaFY9oj
	 05nxCVWbEfcD++04BAkjYS67T71ZQKhzyu6q3WZ8JM+Nq5axZuGUldvxslQ6IDBgXj
	 4TWkgRvZmPQDP4+rVCptcrXwBOfBXoMDeUZRH8Wp3ugkYqZvGKmWHOgN92MEiBDxr5
	 9u5STRUt+O2euSBwkgcMhfsaH0RnwMEO/iN2P0oM2sZd22f5AUcPoAVVdjXDvknK/o
	 T3zwqzKkVrYA3KBU7u+ycHZvQ7dYicPF4vGfmge7fq9Ntn0IbVNJL2+Ng+Nux9U4bj
	 j2d2WZj3WBcbQ==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 443C842C17;
	Fri,  8 Nov 2024 19:34:22 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>, Jason
 Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>, Joerg
 Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
 <kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, =?utf-8?B?SsOpcsO0bWU=?=
 Glisse
 <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
In-Reply-To: <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
References: <cover.1730298502.git.leon@kernel.org>
 <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
Date: Fri, 08 Nov 2024 12:34:21 -0700
Message-ID: <87ttchwmde.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Leon Romanovsky <leon@kernel.org> writes:

> From: Christoph Hellwig <hch@lst.de>
>
> Add an explanation of the newly added IOVA-based mapping API.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/core-api/dma-api.rst | 70 ++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
>
> diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
> index 8e3cce3d0a23..6095696a65a7 100644
> --- a/Documentation/core-api/dma-api.rst
> +++ b/Documentation/core-api/dma-api.rst
> @@ -530,6 +530,76 @@ routines, e.g.:::
>  		....
>  	}
>  
> +Part Ie - IOVA-based DMA mappings
> +---------------------------------
> +
> +These APIs allow a very efficient mapping when using an IOMMU.  They are an
> +optional path that requires extra code and are only recommended for drivers
> +where DMA mapping performance, or the space usage for storing the DMA addresses
> +matter.  All the consideration from the previous section apply here as well.
> +
> +::
> +
> +    bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
> +		phys_addr_t phys, size_t size);
> +
> +Is used to try to allocate IOVA space for mapping operation.  If it returns
> +false this API can't be used for the given device and the normal streaming
> +DMA mapping API should be used.  The ``struct dma_iova_state`` is allocated
> +by the driver and must be kept around until unmap time.

So, I see that you have nice kernel-doc comments for these; why not just
pull them in here with a kernel-doc directive rather than duplicating
the information?

Thanks,

jon

