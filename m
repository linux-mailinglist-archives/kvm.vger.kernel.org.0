Return-Path: <kvm+bounces-63707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 66C75C6EDF1
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3766F3A33CE
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF2735C1BA;
	Wed, 19 Nov 2025 13:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHF1Aqwk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F3335C1BB;
	Wed, 19 Nov 2025 13:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763558000; cv=none; b=Z+WaE6J4xKUtN5DkTozAOLT3sx1owQKO/bFMp+mWfX6KT9Yy/nMvZPftIjTny3SI7L7XmQnYO5CUVOqGyTbPkwJ9/b7K0dKVzQ6yH1tGryTDBXyAXyHA/GsTov31Ntmd+1D0z2uJYyolhjThdNLfSO7BINrpZz9JRHPOw+glaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763558000; c=relaxed/simple;
	bh=0Xx39uDqzjZbL4y1fEwlUfWXemPTGRgOd4dvOT2DUMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vn+QyVPKXwAKznWMTL67o089QdbUrxD1HJaq2SF1lKDYcWNNkkuH931aP3P/bCMipImF+2Nkl3fxOPhdmuM2LQZd84UoU/Qunx8WFVEHKiRtgFOACx33lc8NHI7e7inunGO6kY5e1ndbtvmMPPRv5PrpJFRYuL/H2lnL6JaMtwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHF1Aqwk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4F4C113D0;
	Wed, 19 Nov 2025 13:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763557998;
	bh=0Xx39uDqzjZbL4y1fEwlUfWXemPTGRgOd4dvOT2DUMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GHF1Aqwk7stwCyykVPT1YGqLL0q2EFkbo6kN9EUrvLJCQ171txGNyAbhz/88FHaZv
	 9Rhg1BgJ1o6pwk5sbN0PfEDJwC3hklbr2bavfyxMzT01HhF0wF93D31LJijcoJ6gLx
	 RRFCtGxIX1DwUcuBAwzEstv8DSzzM37P+t2zpedyyLBnUf7WSsyc8s20B6dfTtZtYP
	 n3SeovgFnfzZ6hZLrcxPGnzG7gO49j5G0yZ+xF76uYa69LzleVp3n0yOevVQXsxKub
	 cmKcRZl2oO6LkMOz/QRS9gfCL6+6UFT9W06hc6fG68egCXsf1a6inlsq6trLGvRe00
	 zTHjfAjfnTUJQ==
Date: Wed, 19 Nov 2025 15:13:13 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v8 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251119131313.GA18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-5-fd9aa5df478f@nvidia.com>
 <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>

On Wed, Nov 19, 2025 at 10:18:08AM +0100, Christian König wrote:
> 
> 
> On 11/11/25 10:57, Leon Romanovsky wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
> >  1 file changed, 72 insertions(+), 23 deletions(-)

<...>

> > These MMIO pages have no struct page, and
> 
> Well please drop "pages" here. Just say MMIO addresses.
> 
> > +if used with mmap() must create special PTEs. As such there are very few
> > +kernel uAPIs that can accept pointers to them; in particular they cannot be used
> > +with read()/write(), including O_DIRECT.

<...>

> > +DMABUF provides an alternative to the above struct page-based
> > +client/provider/orchestrator system. In this mode the exporting driver will wrap
> > +some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
> > +
> > +Userspace can then pass the FD to an importing driver which will ask the
> > +exporting driver to map it.
> 
> "to map it to the importer".

No problem, changed.

> 
> Regards,
> Christian.
> 
> > +
> > +In this case the initiator and target pci_devices are known and the P2P subsystem
> > +is used to determine the mapping type. The phys_addr_t-based DMA API is used to
> > +establish the dma_addr_t.
> > +
> > +Lifecycle is controlled by DMABUF move_notify(). When the exporting driver wants
> > +to remove() it must deliver an invalidation shutdown to all DMABUF importing
> > +drivers through move_notify() and synchronously DMA unmap all the MMIO.
> > +
> > +No importing driver can continue to have a DMA map to the MMIO after the
> > +exporting driver has destroyed its p2p_provider.
> >  
> >  
> >  P2P DMA Support Library
> > 
> 

