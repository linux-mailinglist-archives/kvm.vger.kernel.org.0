Return-Path: <kvm+bounces-12518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1CD88721D
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE474283648
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5036026C;
	Fri, 22 Mar 2024 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHS5yTT4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B2E5FDDD;
	Fri, 22 Mar 2024 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711129581; cv=none; b=oHQQzj2pe6g0c89w0nZB+6tgP87sT3/zpcVGkG/2Du8ys3O16yuYdAwjeb4gxPo3fJK06eLFTHIsKiDIIeSZxQwmnsD4uaKIVNq84tLpgzIRoRa9KoRJZJYkDsTn9UJTPH6xYqT+pWtUrQhB77AYYUanjex9kc+JNp8Y1nYWzHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711129581; c=relaxed/simple;
	bh=tPnSfU7iDXbv5Aanu3qQZ/bdHhZW5HEkKrMaj/r/t3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t1fFWZ00mlSUzvKAV2Tn9hcnz8Hhk9dbnHULQI5Hs4Z3yauEUBxYICPy43tNMnRh7j0PLSM8RCDZI4N4DIvdTAzciqqvPetms2v/8nzV4IjiNj+ki2T+ou3zyNZHNryywghdwYmcNkLL5VHz8FzEK4vJzXD9/rdjt6Rb2NKYB3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHS5yTT4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06FDC43390;
	Fri, 22 Mar 2024 17:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711129581;
	bh=tPnSfU7iDXbv5Aanu3qQZ/bdHhZW5HEkKrMaj/r/t3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZHS5yTT4bbaMRlgftNPH4s3/BHy6Y/pMfuNyl8v8f5cbM9wT0nJywOThE9XO9o+Yo
	 sQrbBVvHpfJ/GkmHADMgsyejjED5TS3WA9xA7CAd8LGMMBj72qkOP6L4xJgAnibISZ
	 qNFyWWuGRtKqmNbYceSiJMbEfqG1Js9LGbaa9G2SXsAMGNlvbn99etRqhzGPHQquR2
	 /pbuuEEFXd6WzmZyO515+46vj9pZRkjqcnsndSlqoffLvES8FRzNSO3QY42zxkNADr
	 DC5hb9KvKEkeYTKUZ64FdwpBihsRuGbAw0oCeOVQ5Q/D7ca6clZI9B8s4YtiHLB9rj
	 nO/n9c2+vHn/w==
Date: Fri, 22 Mar 2024 19:46:17 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Message-ID: <20240322174617.GD14887@unreal>
References: <20240306221400.GA8663@lst.de>
 <20240307000036.GP9225@ziepe.ca>
 <20240307150505.GA28978@lst.de>
 <20240307210116.GQ9225@ziepe.ca>
 <20240308164920.GA17991@lst.de>
 <20240308202342.GZ9225@ziepe.ca>
 <20240309161418.GA27113@lst.de>
 <20240319153620.GB66976@ziepe.ca>
 <20240320085536.GA14887@unreal>
 <20240321224013.GB22663@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321224013.GB22663@lst.de>

On Thu, Mar 21, 2024 at 11:40:13PM +0100, Christoph Hellwig wrote:
> On Wed, Mar 20, 2024 at 10:55:36AM +0200, Leon Romanovsky wrote:
> > Something like this will do the trick.
> 
> As far as I can tell it totally misses the point.  Which is not to never
> return non-P2P if the flag is set, but to return either all P2P or non-P2
> P and not create a boundary in the single call.

You are treating FOLL_PCI_P2PDMA as a hint, but in iov_iter_extract_user_pages()
you set it only for p2p queues. I was under impression that you want only p2p pages
in these queues.

Anyway, I can prepare other patch that will return or p2p or non-p2p pages in one shot.

Thanks

