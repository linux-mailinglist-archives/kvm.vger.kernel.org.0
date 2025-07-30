Return-Path: <kvm+bounces-53721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2808B15A26
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 10:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A5FD3A8C6A
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 08:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF499264FBB;
	Wed, 30 Jul 2025 08:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Phq6ne8j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA7D1D5AC6;
	Wed, 30 Jul 2025 08:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753862604; cv=none; b=jviImF74GiapGvAs8Fbapl946Bu0iEPZrGXJyXynQc1ZDe2X8WjXZCoA5Ozd+Nzy3mdj5QsQ0mgN9ugmyBjvgKsoSe32mqgagapsV9vpz06yi4JX1NH9bCe9f04aqMqB7qFBH/xUpB/9FByPulWMX1Axk2SaFX4zf6+qy6kzm/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753862604; c=relaxed/simple;
	bh=HEgPRodovJalgZ/g1kb94tmKLk2QtGEpj7zW37uzKec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Peyl2xsLGon5YcrfgY8l/khWyYWW5Rd71BduZ4ixczHnGave63Dd5jd6a8sHk3se5KzCpOOklZrX6r3gM1OhDa3XMQaH+HDTDs6z0FluAiEfBlgym4iXBGouTqugX+t2UokHhfvGUQclmhTjQBNyiM5WYKqHMdcCLHOvZPEhq6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Phq6ne8j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C439C4CEE7;
	Wed, 30 Jul 2025 08:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753862603;
	bh=HEgPRodovJalgZ/g1kb94tmKLk2QtGEpj7zW37uzKec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Phq6ne8jeiHRh+g/jyaIbVu24BslXtOFr5jlNeVkeq5Pd4JP4IP/urevgfTH7y8Ng
	 IM4N1EVTTw6lIyVWLMQ5K0tdY5QpmQj79Qaao8gIoOMRohyP/vZ3M9ekEqXib6GZL+
	 Vd2t51G/uWQd6oD58QoSzV0VWLuJ8QqSIDQStXuXWQ5G8gEHsTZDXx81LTTpzH1daZ
	 ezVZXuukAwl9TGk23btBxOterY1GjPt8BN4i8ULPTxzKhdnMZ1IhejtxHnXHMC5Wo6
	 rXCmw6UrvY7ectigm1BvmYyiZfOF9dlvJf0mlr92yHUxxT/i06Xv2nhdtuZ9olDn3p
	 c3RNuuUGIqBAg==
Date: Wed, 30 Jul 2025 11:03:17 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250730080317.GO402218@unreal>
References: <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
 <20250727190514.GG7551@nvidia.com>
 <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
 <20250728164136.GD402218@unreal>
 <d3c8c573-f201-4450-9400-cc3ccafd2c04@deltatee.com>
 <20250728231107.GE36037@nvidia.com>
 <f332e2b9-151f-49ca-ac0c-8c9494c38027@deltatee.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f332e2b9-151f-49ca-ac0c-8c9494c38027@deltatee.com>

On Tue, Jul 29, 2025 at 02:54:13PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2025-07-28 17:11, Jason Gunthorpe wrote:
> >> If the dma mapping for P2P memory doesn't need to create an iommu
> >> mapping then that's fine. But it should be the dma-iommu layer to decide
> >> that.
> > 
> > So above, we can't use dma-iommu.c, it might not be compiled into the
> > kernel but the dma_map_phys() path is still valid.
> 
> This is an easily solved problem. I did a very rough sketch below to say
> it's really not that hard. (Note it has some rough edges that could be
> cleaned up and I based it off Leon's git repo which appears to not be
> the same as what was posted, but the core concept is sound).

I started to prepare v2, this is why posted version is slightly
different from dmabuf-vfio branch.

In addition to what Jason wrote. there is an extra complexity with using
state. The wrappers which operate on dma_iova_state assume that all memory,
which is going to be mapped, is the same type: or p2p or not.

This is not the cased for HMM/RDMA users, there you create state in
advance and get mixed type of pages.

Thanks

