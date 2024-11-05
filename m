Return-Path: <kvm+bounces-30806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5018A9BD629
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D615F1F2360E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58078214432;
	Tue,  5 Nov 2024 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="cCnrWGzn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7391212EF8
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730836442; cv=none; b=tUEnBfyn65e6BmZZjP0kvgFDFU6Ed48qs3BoXYoWWHHHbRe9W2JPPQFSeyXO0wsIfmz7r96YbRjSGzYXyGFf/Ra4URxWxKFwSaxndUkg6ydAjccEtGjRnKWWNJlZT7hMoSpmG4glPhBhnqRMlWbkhdT/ZBU9L2ie4PPg/spOzJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730836442; c=relaxed/simple;
	bh=q3kRFS0aC9llW2hXigplm+6X6nuxwR5TAuU7KtMvtNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxYTggPtyT4ob9b4UrovckKlxfR/Aoyv7u9Y3Ru1UKHl7PdD4inVrW09RF1Ro+y8MjTvXAnKQNFP4HEPSZZCYsWuYyKr0AtZqHFLNkpp1E3rCN2vqAm66Xjnd17ubJiSWarniuNdGJ4NGiwpKGJfig0lwphe3O0LYT/LULoNxyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=cCnrWGzn; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-460a23ad00eso1473351cf.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1730836439; x=1731441239; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+fX00798BJ3ATWBHAwavTUTImd2ssZMf/WzAfMHnat0=;
        b=cCnrWGznqeSBxBybSIX9KF2jm+YHihlVV6QSsqvER5HCYWOvEMYWGMMrUPl6GATwiZ
         srLlBdBWXyC4dDZ9YWe3VWgJGOBPRvDEFxnahCiNSoGSK8bsmnQxtRiboeppWUadKGCS
         P0/6mWuTEfwnZ1pXQCym0DsT+gHAJHBeVYSJiwS3/eJ6vh4YNHNi7skohTpFGvza6lWl
         fkKSEpvQfMWtstvuZMSaGHptv80S6FNKODFfEMfpGP7fRaQ/eU4VJbTXyRIKbK2qiPC3
         5qsFAaTWTC9aUfiNVu8c4B7nPODBl1MRoHORCscuhmjiWPpV8Au1arDi3GEwmKgoOGUS
         NoAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730836439; x=1731441239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fX00798BJ3ATWBHAwavTUTImd2ssZMf/WzAfMHnat0=;
        b=vaz0B06Ei3Z7hcufdzO7GKJuybuQOuGoP577iJABoRoFMhnHURp68PivnM+YOhXpmh
         uI8gzWfmPel9wu1asum5g77u/gbDCtVsDUaV6w02URyp51tPh2VFugR/1qdSVwo8mVdq
         VvIooxtDVaOB9Dvq7+bYu3gWWz0LcpHjRRaQKjlex8Um1WaajV1YdoONrd/boBCxQ5uV
         BimlMFL6UHWMcvdXXT1sJuPerWCAt5O/hr6tyEG5ZhbwyVNpPPoEoObu1AO62ya+Hu/9
         mUkqbMgoPR/nnrgCq8ACZqvmn8MRdXRrYtynuYNdotu51vc50xGRqzuwVf9EIGV/UzFx
         oD5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTtZ4rjfNvfaWWZvXlQnH2Szr6VTHNrzvdrd4x+nlNuOuR9p9379z4A9qcPeVyIIynX2E=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb7kERSkQBUU05hqaqSpnbq7+mwUnvAEMOUbBlaux5iB3iDVRS
	QnK2PrT/kKf7JP5cJVh0w7LvbwFSMPI/A60TMAkZTYHF4hnko5UVg1h2lhAnLYw=
X-Google-Smtp-Source: AGHT+IEaav3D7n+muLVYjXAvVqOfQiyB3KvOcn2o5SW6dcKTwKh96GbO3Tfnssa4/aNZfrPdV+MQVQ==
X-Received: by 2002:ad4:4eeb:0:b0:6cb:ed27:145c with SMTP id 6a1803df08f44-6d35b9510a3mr302739006d6.19.1730836438787;
        Tue, 05 Nov 2024 11:53:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d35415a62asm63870536d6.80.2024.11.05.11.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2024 11:53:58 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1t8Pcj-000000023mq-1vDZ;
	Tue, 05 Nov 2024 15:53:57 -0400
Date: Tue, 5 Nov 2024 15:53:57 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>, Leon Romanovsky <leon@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
Message-ID: <20241105195357.GI35848@ziepe.ca>
References: <cover.1730298502.git.leon@kernel.org>
 <3567312e-5942-4037-93dc-587f25f0778c@arm.com>
 <20241104095831.GA28751@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104095831.GA28751@lst.de>

On Mon, Nov 04, 2024 at 10:58:31AM +0100, Christoph Hellwig wrote:
> On Thu, Oct 31, 2024 at 09:17:45PM +0000, Robin Murphy wrote:
> > The hilarious amount of work that iommu_dma_map_sg() does is pretty much 
> > entirely for the benefit of v4l2 and dma-buf importers who *depend* on 
> > being able to linearise a scatterlist in DMA address space. TBH I doubt 
> > there are many actual scatter-gather-capable devices with significant 
> > enough limitations to meaningfully benefit from DMA segment combining these 
> > days - I've often thought that by now it might be a good idea to turn that 
> > behaviour off by default and add an attribute for callers to explicitly 
> > request it.
> 
> Even when devices are not limited they often perform significantly better
> when IOVA space is not completely fragmented.  While the dma_map_sg code
> is a bit gross due to the fact that it has to deal with unaligned segments,
> the coalescing itself often is a big win.

RDMA is like this too, Almost all the MR HW gets big wins if the
entire scatter list is IOVA contiguous. One of the future steps I'd
like to see on top of this is to fine tune the IOVA allocation backing
MRs to exactly match the HW needs. Having proper alignment and
contiguity can be huge reduction in device overhead, like a 100MB MR
may need to store 200K of mapping information on-device, but with a
properly aligned IOVA this can be reduced to only 16 bytes.

Avoiding a double translation tax when the iommu HW is enabled is
potentially significant. We have some RDMA workloads with VMs where
the NIC is holding ~1GB of memory just for translations, but the iommu
is active as the S2. ie we are paying a double tax on translation.

It could be a very interesting trade off to reduce the NIC side to
nothing and rely on the CPU IOMMU with nested translation instead.

> Note that dma_map_sg also has two other very useful features:  batching
> of the iotlb flushing, and support for P2P, which to be efficient also
> requires batching the lookups.

This is the main point, and I think, is the uniqueness Leon is talking
about. We don't get those properties through any other API and this
one series preserves them.

In fact I would say that is the entire point of this series: preserve
everything special about dma_map_sg() compared to dma_map_page() but
don't require a scatterlist.

> >> Several approaches have been explored to expand the DMA API with additional
> >> scatterlist-like structures (BIO, rlist), instead split up the DMA API
> >> to allow callers to bring their own data structure.
> >
> > And this line of reasoning is still "2 + 2 = Thursday" - what is to say 
> > those two notions in any way related? We literally already have one generic 
> > DMA operation which doesn't operate on struct page, yet needed nothing 
> > "split up" to be possible.
> 
> Yeah, I don't really get the struct page argument.  In fact if we look
> at the nitty-gritty details of dma_map_page it doesn't really need a
> page at all. 

Today, if you want to map a P2P address you must have a struct page,
because page->pgmap is the only source of information on the P2P
topology.

So the logic is, to get P2P without struct page we need a way to have
all the features of dma_map_sg() but without a mandatory scatterlist
because we cannot remove struct page from scatterlist.

This series gets to the first step - no scatterlist. There will need
to be another series to provide an alternative to page->pgmap to get
the P2P information. Then we really won't have struct page dependence
in the DMA API.

I actually once looked at how to enhance dma_map_resource() to support
P2P and it was not very nice, the unmap side became quite complex. I
think this is a more elgant solution than what I was sketching.

> >>      for the device. Instead of allocating a scatter list entry per allocated
> >>      page it can just allocate an array of 'struct page *', saving a large
> >>      amount of memory.
> >
> > VFIO already assumes a coherent device with (realistically) an IOMMU which 
> > it explicitly manages - why is it even pretending to need a generic DMA 
> > API?
> 
> AFAIK that does isn't really vfio as we know it but the control device
> for live migration.  But Leon or Jason might fill in more.

Yes, this is the control side of the VFIO live migration driver that
needs rather a lot of memory to store the migration blob. There is
definitely an iommu, and the VF function is definitely translating,
but it doesn't mean the PF function is using dma-iommu.c, it is often
in iommu passthrough/identity and using DMA direct.

It was done as an alternative example on how to use the API. Again
there are more improvements possible there, the driver does not take
advantage of contiguity or alignment when programming the HW.

> Because we only need to preallocate the tiny constant sized dma_iova_state
> as part of the request instead of an additional scatterlist that requires
> sizeof(struct page *) + sizeof(dma_addr_t) + 3 * sizeof(unsigned int)
> per segment, including a memory allocation per I/O for that.

Right, eliminating scatterlist entirely on fast paths is a big
point. I recall Chuck was keen on the same thing for NFSoRDMA as well.

> At least for the block code we have a nice little core wrapper that is
> very easy to use, and provides a great reduction of memory use and
> allocations.  The HMM use case I'll let others talk about.

I saw the Intel XE team make a complicated integration with the DMA
API that wasn't so good. They were looking at an earlier version of
this and I think the feedback was positive. It should make a big
difference, but we will need to see what they come up and possibly
tweak things.

Jason

