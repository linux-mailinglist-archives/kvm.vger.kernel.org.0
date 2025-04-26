Return-Path: <kvm+bounces-44390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFDFEA9D6EA
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 03:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3EED4C4DA7
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 01:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40851F63F9;
	Sat, 26 Apr 2025 01:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxqczATS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E861DF972;
	Sat, 26 Apr 2025 01:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745629860; cv=none; b=rnm+XnOZmFqnX49n9POQ4Ui3iQj6hayscAODZONu9oyixkagG/KJWUnyyjVklk5wnBNbYKuC7hppnJuo8gpfmvj2JznCZ6qyNPiKuq/Ex8VYNK6Q8AKLbilaJGPbY7G5r2hAVAMkBOX59uHCg9uRo0bNovu7uz5lyhAJkTEWuLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745629860; c=relaxed/simple;
	bh=GUs6TKtXii+/XXjYUhm5P6PA6lNQdKk+Fhn0VAcFzCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlV49BPg5AbvvmVpdsltbncxGcjkbmeRhzWc0Tna3jpoR2D6s9KmuuBenEsJ5BGIJzt27CxWimhNP1jTNABr2kgaXMsopVF2uTNx5ETff931RGbLG91aaCmn27fb+mpnEeICHeWftbNMECjZee59eUVx7wGUsRdL5G97UlKQUI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxqczATS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F060C4CEE4;
	Sat, 26 Apr 2025 01:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745629859;
	bh=GUs6TKtXii+/XXjYUhm5P6PA6lNQdKk+Fhn0VAcFzCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KxqczATSjba7r4EOiuW4Y78kxeaOmUn3hrN1Qeb61Bk1IEG5UNMQYfKkJP6rYhrV7
	 8AmTGD/13GYjzSccgNMwsaqeRlpmwPv5meAChJXDj5Q06hhFENBCp7oBqxPzuc9ZO0
	 pGKSNgygnGuSGADjucID9fOYBRhKR7ry0z4g2sDjEkMTeG3qIIFlI5culzVUuXi3wA
	 bC8BOIqRt8uMC02v1ZmTGzq2dYb7qx2Xfv5q8Rxtr63FLkVeFvfiizkWxan0m4YeBl
	 KHc2CWUVFGRL3C1kNb40DgyDJqN6VrFEUEYi9ZwapTJakiV2SfEKCIjtwm38N6h5V5
	 f3X4MpEQ8rQEw==
Date: Fri, 25 Apr 2025 18:10:57 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 05/24] dma-mapping: Provide an interface to allow
 allocate IOVA
Message-ID: <aAwyoXHzhU42P06W@bombadil.infradead.org>
References: <cover.1745394536.git.leon@kernel.org>
 <f08e12b1539b73c9ae27c06afbfe4f0ee3b85609.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f08e12b1539b73c9ae27c06afbfe4f0ee3b85609.1745394536.git.leon@kernel.org>

The subject reads odd, how about:

dma-mapping: Provide an interface to allocate IOVA

> +/**
> + * dma_iova_free - Free an IOVA space
> + * @dev: Device to free the IOVA space for
> + * @state: IOVA state
> + *
> + * Undoes a successful dma_try_iova_alloc().
> + *
> + * Note that all dma_iova_link() calls need to be undone first.  For callers
> + * that never call dma_iova_unlink(), dma_iova_destroy() can be used instead
> + * which unlinks all ranges and frees the IOVA space in a single efficient
> + * operation.
> + */

Probably does't matter but dma_iova_destroy() doesn't exist yet here.

Other than that:

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

