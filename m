Return-Path: <kvm+bounces-44104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39994A9A6BE
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:49:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3932D3AD3C8
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC29022156E;
	Thu, 24 Apr 2025 08:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uSR+lBTu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19071F75A9;
	Thu, 24 Apr 2025 08:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745484392; cv=none; b=pL9DsDAkCX/fxLcXEJxof8o9OgwUfHfuBYY6ZPZS4okvKofoHWnXxbbTudwOx9yKStz+nl/1B/bnLPyTqiXPECu/YLMiVoet7M61JIeA5a+fxiMzuhItLS366x1L8moLq3kNNXI/9srDg5U8ENc2K2HCwM+D1xBlyxp77Fnc8Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745484392; c=relaxed/simple;
	bh=ki3q6dIyPVLY9OlwYT9gx2mvHOve0ih8UQqOIXQy4sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jwQxNc/ZuT3VuulgzV2KYPEtABJ4/9dQc8PpG6UTr1vR0kb0kMiATqo2p3awTQc/Lj1BdgDs5Zc6nTeeDU+WbrtfK5NK8Ui8Wc3i9tx6jmv3oiUNM/5ZS1H5bvCWjH+LYA+dq+1zbZJVB2IN/BC6oHREtYldPLccPYer0w+CZ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uSR+lBTu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4A0C4CEED;
	Thu, 24 Apr 2025 08:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745484392;
	bh=ki3q6dIyPVLY9OlwYT9gx2mvHOve0ih8UQqOIXQy4sw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uSR+lBTuzs9lAfUp6ETUwd/e83HDQBPN+bi2x6d+WcXRuXqISLxR1KnZmPcANDNPl
	 XcusVwWrcgl5ZwxaQMTClZZp6wv04VyBadsXr0ChBep2yGTn0yT6aRBkv0qe3YHnsu
	 Xbfy/GOWPkZiF5ouAX9EAiGXmE23jYsBtArkcpCT8edU46pm2SHyttUmmiowtlF9le
	 jBdsLZ0dV8tCc+abgC1OkQo4yqWtl296bgiFLL3P131EcMwOFukXU6T1YRIKWY0DCS
	 vfhRiecYS5EGzJ47VScGPAGcWrDrAIXqhECCrbNzQ/i5dx+Y8dYPFcg8gKvkI2s3k1
	 MO9hwaOX8jurQ==
Date: Thu, 24 Apr 2025 11:46:26 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
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
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 10/24] mm/hmm: let users to tag specific PFN with DMA
 mapped bit
Message-ID: <20250424084626.GQ48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org>
 <7185c055-fc9e-4510-a9bf-6245673f2f92@redhat.com>
 <20250423181706.GT1213339@ziepe.ca>
 <36891b0e-d5fa-4cf8-a181-599a20af1da3@redhat.com>
 <20250423233335.GW1213339@ziepe.ca>
 <20250424080744.GP48485@unreal>
 <20250424081101.GA22989@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424081101.GA22989@lst.de>

On Thu, Apr 24, 2025 at 10:11:01AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 24, 2025 at 11:07:44AM +0300, Leon Romanovsky wrote:
> > > I see, so yes order occupies 5 bits [-4,-5,-6,-7,-8] and the
> > > DMA_MAPPED overlaps, it should be 9 not 7 because of the backwardness.
> > 
> > Thanks for the fix.
> 
> Maybe we can use the chance to make the scheme less fragile?  i.e.
> put flags in the high bits and derive the first valid bit from the
> pfn order?
> 

It can be done too. This is what I got:

   38 enum hmm_pfn_flags {
   39         /* Output fields and flags */
   40         HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
   41         HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
   42         HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
   43         /*
   44          * Sticky flags, carried from input to output,
   45          * don't forget to update HMM_PFN_INOUT_FLAGS
   46          */
   47         HMM_PFN_DMA_MAPPED = 1UL << (BITS_PER_LONG - 4),
   48         HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
   49         HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
   50
   51         HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
   52
   53         /* Input flags */
   54         HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
   55         HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
   56
   57         HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
   58 };

So now, we just need to move HMM_PFN_ORDER_SHIFT if we add new flags
and HMM_PFN_FLAGS will be updated automatically.

Thanks

