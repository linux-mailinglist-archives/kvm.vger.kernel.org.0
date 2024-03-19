Return-Path: <kvm+bounces-12170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34CC18803FC
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 18:54:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A03CAB23B0B
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0992A2BAF0;
	Tue, 19 Mar 2024 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="fiSQBkCC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6423023772
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 17:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710870870; cv=none; b=A73KCqSEYJ3EvJFQscqWVgyyVXHt2PwqEfiiqsDCkHDhZW8KFZ9/x2Vtv/8PiapE3uEpn1uhL3ZyYrWvTR8pcFcOzvwVtVD6Nft066qhE1HDMfptjofXmWGNQIdF15Ji7q/x1F3jsg3EkcriHsjWbUiigN4Mkg9umyJs+zZxl0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710870870; c=relaxed/simple;
	bh=Ao9hwGJl4g/w2wap7dwa291kK0JPcDjzl89BAK46zVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rlcqCx4Z6NjIOcR2RdkzbZwJaLmG/XKopeq+Auo9ht3wIKFSh6zed9sX9iR9pUeftQG9bWCvXObaTMxQWCaREHPUt8+Sd/q5I8324fgtKu+LHSdfrBcnTPYzr7HeRIecDfVwWoEkmVjPPKt5xU6WHHNVc2w6w9DbnB3MND4jTDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=fiSQBkCC; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-221830f6643so3100426fac.2
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 10:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1710870867; x=1711475667; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D7H3WfkclcieHpBg89GTkZxaS3r7II1qq9xezXi0hVM=;
        b=fiSQBkCCoYVMvJ7hKOIWrIUIQtWnudcxCwuRJ3SDAmfcoUJ3LKW/OSOt0XJv0ppBom
         r1b7EUVzGEU34UNgXl0Xub2wg6VFMC2Ly8xIcAY78NHYVcXijpAahLq3KrnWiEfepI+P
         K3bumXlIk6qPY69qQGjZxTur6D4Xb2RFW85NT0G9m4KZ2ko8G/knkqvxD72SooihwK+Z
         WaMPr00ehDA2unHvbCRW9HCn68HsloTpQ5rMYa4Uyj9mIfkuCzQfSnPQejaSEhgNZfAo
         vO51olQglynGFY2d82cFKRUtHCtTWvMs7dccTYup7df0Q48rdZL147340AdvneF3HcRw
         D7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710870867; x=1711475667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D7H3WfkclcieHpBg89GTkZxaS3r7II1qq9xezXi0hVM=;
        b=UvH+1OTVj016lRDA0KD+VWYo6QB7CONJZJeJ3DUZHAXMNx6pjdeTl6ooGFvEE/3IST
         4T3FoV3v90t+S+Rrmb/drUUcW3IucSck/2PgHZNlHAR5nBGxopqBtqjMTn1CQVng4F4s
         G30u1HPqesxb/0uJjBBkwVsWZQQQ3MpGkja9Ig76F65ICNH5hew7HEeRDC6XSTmH+puV
         a+j5S35tgqmdQdgdCrJ2Z7Z7gIz0hugejvYnb1vaCQ9iE7TwsFIvY0WgFu3U59jGeBHO
         1dlPuwmOso29sDAzv1WLqiYbHiaRdEf6ztxS4G+tTLquxWvTGQ5bN+DOLpX6TQFvl1yo
         +Z1w==
X-Forwarded-Encrypted: i=1; AJvYcCXM2UnAFeTUzHRxKQMlsMIJKRb9tBaDnX++meof7hWW2G1Im6jnQROOO6vAKVVMAqjH+mOyXGFp+qG06cxE8nbSBXkK
X-Gm-Message-State: AOJu0Yw9gp2m3zyU9G6Ze0MaOz+nokMy3Gb3iyHgnmTsO9S74uu9OJz1
	dcG8AxEKcDI8OfEYbZ1XL4OI0E8SM+v/pGWmnCjhDZYwvV7otLE4I2P3SiLXU1U=
X-Google-Smtp-Source: AGHT+IFEKHu8FJxVRb4YxsELWM46dNSxNuN3njm0tBeD+R+fEyp1j8c0yaDa2gTZMCaYT5fxKBzgBQ==
X-Received: by 2002:a05:6870:d20e:b0:222:99cb:2215 with SMTP id g14-20020a056870d20e00b0022299cb2215mr3580439oac.28.1710870867581;
        Tue, 19 Mar 2024 10:54:27 -0700 (PDT)
Received: from ziepe.ca ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id gh11-20020a056638698b00b00477716fcbb8sm2429986jab.40.2024.03.19.10.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 10:54:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rmbVk-001elO-4L;
	Tue, 19 Mar 2024 12:36:20 -0300
Date: Tue, 19 Mar 2024 12:36:20 -0300
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
Message-ID: <20240319153620.GB66976@ziepe.ca>
References: <20240306154328.GM9225@ziepe.ca>
 <20240306162022.GB28427@lst.de>
 <20240306174456.GO9225@ziepe.ca>
 <20240306221400.GA8663@lst.de>
 <20240307000036.GP9225@ziepe.ca>
 <20240307150505.GA28978@lst.de>
 <20240307210116.GQ9225@ziepe.ca>
 <20240308164920.GA17991@lst.de>
 <20240308202342.GZ9225@ziepe.ca>
 <20240309161418.GA27113@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309161418.GA27113@lst.de>

On Sat, Mar 09, 2024 at 05:14:18PM +0100, Christoph Hellwig wrote:
> On Fri, Mar 08, 2024 at 04:23:42PM -0400, Jason Gunthorpe wrote:
> > > The DMA API callers really need to know what is P2P or not for
> > > various reasons.  And they should generally have that information
> > > available, either from pin_user_pages that needs to special case
> > > it or from the in-kernel I/O submitter that build it from P2P and
> > > normal memory.
> > 
> > I think that is a BIO thing. RDMA just calls with FOLL_PCI_P2PDMA and
> > shoves the resulting page list into in a scattertable. It never checks
> > if any returned page is P2P - it has no reason to care. dma_map_sg()
> > does all the work.
> 
> Right now it does, but that's not really a good interface.  If we have
> a pin_user_pages variant that only pins until the next relevant P2P
> boundary and tells you about we can significantly simplify the overall
> interface.

Sorry for the delay, I was away..

I kind of understand your thinking on the DMA side, but I don't see
how this is good for users of the API beyond BIO.

How will this make RDMA better? We have one MR, the MR has pages, the
HW doesn't care about the SW distinction of p2p, swiotlb, direct,
encrypted, iommu, etc. It needs to create one HW page list for
whatever user VA range was given.

Or worse, whatever thing is inside a DMABUF from a DRM
driver. DMABUF's can have a (dynamic!) mixture of P2P and regular
AFAIK based on the GPU's migration behavior.

Or triple worse, ODP can dynamically change on a page by page basis
the type depending on what hmm_range_fault() returns.

So I take it as a requirement that RDMA MUST make single MR's out of a
hodgepodge of page types. RDMA MRs cannot be split. Multiple MR's are
not a functional replacement for a single MR.

Go back to the start of what are we trying to do here:
 1) Make a DMA API that can support hmm_range_fault() users in a
    sensible and performant way
 2) Make a DMA API that can support RDMA MR's backed by DMABUF's, and
    user VA's without restriction
 3) Allow to remove scatterlist from BIO paths
 4) Provide a DMABUF API that is not scatterlist that can feed into
    the new DMA API - again supporting DMABUF's hodgepodge of types.

I'd like to do all of these things. I know 3 is your highest priority,
but it is my lowest :)

So, if the new API can only do uniformity I immediately loose #1 -
hmm_range_fault() can't guarentee anything, so it looses the IOVA
optimization that Leon's patches illustrate.

For uniformity #2 probably needs multiple DMA API "transactions". This
is doable, but it is less performant than one "transaction".

#3 is perfectly happy because BIO already creates uniformity

#4 is like #2, there is not guarenteed uniformity inside DMABUF so
every DMABUF importer needs to take some complexity to deal with
it. There are many DMABUF importers so this feels like a poor API
abstraction if we force everyone there to take on complexity.

So I'm just not seeing why this would be better. I think Leon's series
shows the cost of non-uniformity support is actually pretty
small. Still, we could do better, if the caller can optionally
indicate it knows it has uniformity then that can be optimized futher.

I'd like to find something that works well for all of the above, and I
think abstracting non-uniformity at the API level is important for the
above reasons.

Can we tweak what Leon has done to keep the hmm_range_fault support
and non-uniformity for RDMA but add a uniformity optimized flow for
BIO?

Jason

