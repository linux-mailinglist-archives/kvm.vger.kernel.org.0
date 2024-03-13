Return-Path: <kvm+bounces-11771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C599287B3B7
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 22:44:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BB621F210F4
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 21:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D610B56B86;
	Wed, 13 Mar 2024 21:44:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8863C53E07;
	Wed, 13 Mar 2024 21:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710366273; cv=none; b=Zp5ZBt5d1sKsBcn7AmDBluPf+bbW5sofsIvO3QDNsLWWwXB2M1PoZwbym8rp7wFY9grFwA8RA3pwR7jGx9eWY4bWxptERXLcUsgliHcrK+WoyNuQ9CQQCa8Gfwm77/T+DbRdFas66nP/HhYZTflWMEA1Jl3FL+BiCorWFbWWytU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710366273; c=relaxed/simple;
	bh=fHUHblIM4Ym+Lz04JBq2RDtEh1L4l5ZqXeh2B8Xe0mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6/KMea9e6puisxxWLSPC/vJeVAu6/QbaBvaLFyDp+9FvF8E77U3FX9yKud80Yi86BqU5raNoF8yXfI7GwRWJ5Vyz5CL+QJl3xfNZYCMKxeBjgiGUCyUK42fIpGjUlTAvQUho1sycFZboeV+4eN6F0611KjQ2vVJUI0gj5wAA2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8161568BFE; Wed, 13 Mar 2024 22:44:18 +0100 (CET)
Date: Wed, 13 Mar 2024 22:44:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
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
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
 steps
Message-ID: <20240313214418.GA9129@lst.de>
References: <20240306221400.GA8663@lst.de> <20240307000036.GP9225@ziepe.ca> <20240307150505.GA28978@lst.de> <20240307210116.GQ9225@ziepe.ca> <20240308164920.GA17991@lst.de> <20240308202342.GZ9225@ziepe.ca> <20240309161418.GA27113@lst.de> <20240310093513.GB12921@unreal> <20240312212844.GA3018@lst.de> <20240313074636.GV12921@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240313074636.GV12921@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 13, 2024 at 09:46:36AM +0200, Leon Romanovsky wrote:
> On Tue, Mar 12, 2024 at 10:28:44PM +0100, Christoph Hellwig wrote:
> > On Sun, Mar 10, 2024 at 11:35:13AM +0200, Leon Romanovsky wrote:
> > > And you will need to have a way to instruct that pin_user_pages() variant
> > > to continue anyway, because you asked for FOLL_PCI_P2PDMA. Without that
> > > force, you will have !FOLL_PCI_P2PDMA behaviour.
> > 
> > I don't understand what you mean.
> 
> Jason talked about the need to call to pin_user_pages(..., gup_flags | FOLL_PCI_P2PDMA, ...),
> but in your proposal this call won't be possible anymore.

Why?


