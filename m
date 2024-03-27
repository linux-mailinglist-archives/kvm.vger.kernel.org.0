Return-Path: <kvm+bounces-12887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0923B88EC4F
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 743041F2DEB7
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E35142E9E;
	Wed, 27 Mar 2024 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VBiKMhfk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02DA13172F
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 17:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559714; cv=none; b=e+MoRrz3kbNag7sKk6NAO/+y3c8Kedac428MYQXfrDHclHEFZZCbrvoY39FioblS2gcfk1yhL/+sUDryT301Hpem+4SFZgdm1eBBARDFdl4ER7ym1IcPWJJGmOkZCqYB+sWol45LVj1jv8DpMhs+mvJVAjJJgFwJECkbj+Tspvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559714; c=relaxed/simple;
	bh=9tnsRuZ5G7QjnwFgOQWvg/3sPZordPoR8Q1151meHlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRxpodjs9FHlNVB1G9+NB5uWyq0DGLBI64TllqhpAITJM69nbifm71lULbsQyUYoH+QPlBz4lURRq91TtbVlAifIb7jZ/3Bv/2fJgiEocWNVLXhSgm30pGNW8oQlSk24rg70cQZEu5oF3gNW+Zrv0ryduFXuVJmhNVSV55NdsHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VBiKMhfk; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3c3d70191c7so59335b6e.2
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 10:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1711559712; x=1712164512; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MyfMHWP1Z5kFosJnJ/cLT9vrDNlc6F3RpHcMzwkJjx8=;
        b=VBiKMhfksZs2FoL+Oen+l4viEArx3fv0CeCL4ZN0MJMYAEWw8lwwAI62tJyGtfypKG
         YStnUcuL47P28tZ74VCODBd3XogFpKIFt2I1H5LDhwe8Pn2Odk4i6oMy7YlDpsAYlPTO
         D75ZkxizvkQm1VAXcB2fxNhtHu0Ea13T1ePeFq0wZgDd35QrbJ5cZ4EqSMqDWXsCsUKe
         11keU8SaMEgPeXAJlgGV0Cwn/tcHEdWQrseBmSzdTwvVXScPcjnQ2SynNChB5RzD6Ijn
         l1H2JUkGBxblVgZMs3yehBRxo1htITSlBHmahaCPeTld9P1JuWPi+Bj/28xi93o39xkl
         5ohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711559712; x=1712164512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyfMHWP1Z5kFosJnJ/cLT9vrDNlc6F3RpHcMzwkJjx8=;
        b=ONbkb1cnXYgNCtWIl4lsy226wGP8eDeQLBiXMVjmHn5+nONVXTZ6o+NQexmZaYL5oz
         vJOonmLfO4yIdoGeRq533r8pwrYkA/jvHyRlOYAag1GXoFEvh8NAigIrcC8Q8u9P7Zdu
         H3vkQfJ3rQbPKHQK0HjrOgpG3SGyU0RGCdJ5W8RSxqe6+d0NeCM5a7QywRbP0U+TFuX3
         E0LcFiXTvcznwAwaRvjTT4euGZXq+kMWvCG1SaC8laE2cP8ttCTRWeCbtDzfzwSNqrQW
         ng/6aGmDZTZjZYAX54YHlEhc+Htof7Mg7gwHLEHEMAWdQoqtYJfXTbG58C0OZMnrhUnx
         Xeig==
X-Forwarded-Encrypted: i=1; AJvYcCVvByvROXDMtpJ6rEckCQjx/+h8tTrhZFPROr6K8IiLKv/t6qFcf/cS+DpCPwWVxhri8JYCv5XIEMypqR+E21iucR7S
X-Gm-Message-State: AOJu0YzmD3+JX1C8QhqVoBSBnQ9gQnSjBvex8jU3YZH0e1WTg2jG1v8E
	0TSocFavvFMvAov5UlxIjNB0a0fD7pBZYCaOooiYe1v09jFjjM2TardmdKH+jKE=
X-Google-Smtp-Source: AGHT+IGQ+Fbz7qR1SW5qNkJYopwwdBYDjEYKQNSO/4NiABanB9dU3kXOL1kwvcUdEQ/e1ORbwkUJTQ==
X-Received: by 2002:a05:6808:64b:b0:3c3:d56d:a5dd with SMTP id z11-20020a056808064b00b003c3d56da5ddmr357972oih.18.1711559712027;
        Wed, 27 Mar 2024 10:15:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id kd9-20020a056214400900b00696b117a325sm499925qvb.108.2024.03.27.10.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 10:14:48 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rpWr2-005ajV-OE;
	Wed, 27 Mar 2024 14:14:24 -0300
Date: Wed, 27 Mar 2024 14:14:24 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: Leon Romanovsky <leon@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Message-ID: <20240327171424.GI8419@ziepe.ca>
References: <20240307000036.GP9225@ziepe.ca>
 <20240307150505.GA28978@lst.de>
 <20240307210116.GQ9225@ziepe.ca>
 <20240308164920.GA17991@lst.de>
 <20240308202342.GZ9225@ziepe.ca>
 <20240309161418.GA27113@lst.de>
 <20240319153620.GB66976@ziepe.ca>
 <20240321223910.GA22663@lst.de>
 <20240322184330.GL66976@ziepe.ca>
 <20240324232215.GC20765@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240324232215.GC20765@lst.de>

On Mon, Mar 25, 2024 at 12:22:15AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 22, 2024 at 03:43:30PM -0300, Jason Gunthorpe wrote:
> > If we are going to make caller provided uniformity a requirement, lets
> > imagine a formal memory type idea to help keep this a little
> > abstracted?
> > 
> >  DMA_MEMORY_TYPE_NORMAL
> >  DMA_MEMORY_TYPE_P2P_NOT_ACS
> >  DMA_MEMORY_TYPE_ENCRYPTED
> >  DMA_MEMORY_TYPE_BOUNCE_BUFFER  // ??
> > 
> > Then maybe the driver flow looks like:
> > 
> > 	if (transaction.memory_type == DMA_MEMORY_TYPE_NORMAL && dma_api_has_iommu(dev)) {
> 
> Add a nice helper to make this somewhat readable, but yes.
> 
> > 	} else if (transaction.memory_type == DMA_MEMORY_TYPE_P2P_NOT_ACS) {
> > 		num_hwsgls = transcation.num_sgls;
> > 		for_each_range(transaction, range) {
> > 			hwsgl[i].addr = dma_api_p2p_not_acs_map(range.start_physical, range.length, p2p_memory_provider);
> > 			hwsgl[i].len = range.size;
> > 		}
> > 	} else {
> > 		/* Must be DMA_MEMORY_TYPE_NORMAL, DMA_MEMORY_TYPE_ENCRYPTED, DMA_MEMORY_TYPE_BOUNCE_BUFFER? */
> > 		num_hwsgls = transcation.num_sgls;
> > 		for_each_range(transaction, range) {
> > 			hwsgl[i].addr = dma_api_map_cpu_page(range.start_page, range.length);
> > 			hwsgl[i].len = range.size;
> > 		}
> >
> 
> And these two are really the same except that we call a different map
> helper underneath.  So I think as far as the driver is concerned
> they should be the same, the DMA API just needs to key off the
> memory tap.

Yeah.. If the caller is going to have compute the memory type of the
range then lets pass it to the helper

dma_api_map_memory_type(transaction.memory_type, range.start_page, range.length);

Then we can just hide all the differences under the API without doing
duplicated work.

Function names need some work ...

> > > > So I take it as a requirement that RDMA MUST make single MR's out of a
> > > > hodgepodge of page types. RDMA MRs cannot be split. Multiple MR's are
> > > > not a functional replacement for a single MR.
> > > 
> > > But MRs consolidate multiple dma addresses anyway.
> > 
> > I'm not sure I understand this?
> 
> The RDMA MRs take a a list of PFNish address, (or SGLs with the
> enhanced MRs from Mellanox) and give you back a single rkey/lkey.

Yes, that is the desire.
 
> > To go back to my main thesis - I would like a high performance low
> > level DMA API that is capable enough that it could implement
> > scatterlist dma_map_sg() and thus also implement any future
> > scatterlist_v2, bio, hmm_range_fault or any other thing we come up
> > with on top of it. This is broadly what I thought we agreed to at LSF
> > last year.
> 
> I think the biggest underlying problem of the scatterlist based
> DMA implementation for IOMMUs is that it's trying to handle to much,
> that is magic coalescing even if the segments boundaries don't align
> with the IOMMU page size.  If we can get rid of that misfeature I
> think we'd greatly simply the API and implementation.

Yeah, that stuff is not easy at all and takes extra computation to
figure out. I always assumed it was there for block...

Leon & Chaitanya will make a RFC v2 along these lines, lets see how it
goes.

Thanks,
Jason

