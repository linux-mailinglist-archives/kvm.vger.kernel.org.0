Return-Path: <kvm+bounces-11717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A21B87A3BE
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 08:46:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 448B8282F06
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 07:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B368617998;
	Wed, 13 Mar 2024 07:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LhEelchk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C245B168A4;
	Wed, 13 Mar 2024 07:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710316002; cv=none; b=oUwc19y3TeOYw6Yz20UJ6ZoIP+uXcMsbzyW3rFc+14q/EqC+z3e6ZBAyUhnjX7hnXXDRv78eXvD5qxy+tyS945obQrvRyft8oAUpn3uGRIpWXwWrepS/NalFAd5pU94H8JY3HF1uzD9kW9UdRJN2M9rFBRyT1kO4UBsQtsAY3LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710316002; c=relaxed/simple;
	bh=Kr6b9zwRiK0qe/FQtkWwwcr3AdM/iJQ3Tm5R/ItJ+kI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzzKYY6tdF986EFgY6aY8gXblb3HNNoadhdOnu2oRQ5GQ9fU95kmn5Xs/iuLlfcb5ow+69HBdBgG13Q+Y5CDGkDqQD9XYAsEvyIdKmKgQdDbjnwKAhvL51/P07Px3TStrYUAjGmUSIowENfClE/QrapjkFdF41UeguhEUW8PCRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LhEelchk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F8EC433C7;
	Wed, 13 Mar 2024 07:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710316001;
	bh=Kr6b9zwRiK0qe/FQtkWwwcr3AdM/iJQ3Tm5R/ItJ+kI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LhEelchk241d2G+Q3NZ+eugtycNa64C11tlGZNDKxCvzTX75Q00BDeucxxI33dSuA
	 4+eCRt8kMMEc5PKj3RKm6EMledYaAfqv5JZuQB7Y+lqGf4dv4bsr9x0TpKJG1q4wXj
	 5wL8HqXvVMagJHMFg5lnkHWIqzUSGVvjZwviYWQ8IepvQMcWBnKkAG8KoyC2Qj/Dk9
	 zhjs+9wAPOXEebb1i/MdTgpoDqE40AetcQZI0F5BBxVL9DwWbmHiXrd3y6wILhONqN
	 9PPx8kGlpLaHCN3ApgnEaZsraA27U8tPpWQjwzmxyOAzAxTPkrSjUTlSjBaxCZCGej
	 iazuJwD6oD4iQ==
Date: Wed, 13 Mar 2024 09:46:36 +0200
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
Message-ID: <20240313074636.GV12921@unreal>
References: <20240306174456.GO9225@ziepe.ca>
 <20240306221400.GA8663@lst.de>
 <20240307000036.GP9225@ziepe.ca>
 <20240307150505.GA28978@lst.de>
 <20240307210116.GQ9225@ziepe.ca>
 <20240308164920.GA17991@lst.de>
 <20240308202342.GZ9225@ziepe.ca>
 <20240309161418.GA27113@lst.de>
 <20240310093513.GB12921@unreal>
 <20240312212844.GA3018@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312212844.GA3018@lst.de>

On Tue, Mar 12, 2024 at 10:28:44PM +0100, Christoph Hellwig wrote:
> On Sun, Mar 10, 2024 at 11:35:13AM +0200, Leon Romanovsky wrote:
> > And you will need to have a way to instruct that pin_user_pages() variant
> > to continue anyway, because you asked for FOLL_PCI_P2PDMA. Without that
> > force, you will have !FOLL_PCI_P2PDMA behaviour.
> 
> I don't understand what you mean.

Jason talked about the need to call to pin_user_pages(..., gup_flags | FOLL_PCI_P2PDMA, ...),
but in your proposal this call won't be possible anymore.

> 
> > When you say "simplify the overall interface", which interface do you mean?
> 
> Primarily the dma mapping interface.  Secondarily also everything around
> it.

OK, thanks

