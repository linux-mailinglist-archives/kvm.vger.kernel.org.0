Return-Path: <kvm+bounces-68446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E62B0D3982B
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 17:55:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BBDCD300AFCD
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 16:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666FF23F422;
	Sun, 18 Jan 2026 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGP2O6nH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F0E238D27;
	Sun, 18 Jan 2026 16:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768755298; cv=none; b=lHi/aqKldlycp6iaJd3EDTdIQ5NErcwdQ5JO4pWdC0K1OnZ32uIDUS31vyiu9bKDUJV7iaWJFbJkN6bZHII9uGHbRXyuXwl4MHOoYqCZpHH+fwvQ5I1fgMr9xqilAVkU6o/xTKu206ykyYxS0XCdxpgA0alxTm6WdWLjCXnTJS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768755298; c=relaxed/simple;
	bh=n2Vuoglr29P+Am665CpAVHFl07IdAZBI+QGtFaKFQjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJh8Z/wdv8uWKmYOu89xilotI102pCLOvQi22w8swq+wQvFC0I03huxSTVtGx+K3sBRi+mmiQiPI2KSO7vgUhBzOQYwvd+GFaA7MXRXSXZt3PVw1NZGto1cH2Hn1fNCwL5SCyoU2eB0V3MhM1g0BIj/QcpXG/zw9+NQmZFMqCKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGP2O6nH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5206AC116D0;
	Sun, 18 Jan 2026 16:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768755297;
	bh=n2Vuoglr29P+Am665CpAVHFl07IdAZBI+QGtFaKFQjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lGP2O6nHCIvn/gXeyAYUT7EKG1TfhEUbrCV3slk5fiufGNwRN/JlH1Nh9Rro1Eiot
	 uNSB7Gt/82lOM14VVAnolDjaioC/0LE+BMf7d49jjaWVGrCnJ5/721fcCqpJSJz5rf
	 pAxH4kqkmh7HCbKCqiQhD2tO5uoNHKzbS1iNOAIPKAOQ05YG7CNClfw3GiKG1//CvY
	 pCSDvXJ0eEH02bk04drzqjqr9bdxmiqJuCcKaylFhL3DwafW4Y2CdPWHygoiszQoPP
	 DiiUpBe1EQiC4k2UobSjFfZlBYywiipIpF+ra0uR+C87+ry46tWTyiIY+SKY2O9kP/
	 BTQYyeDz7IJmQ==
Date: Sun, 18 Jan 2026 18:54:53 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex@shazbot.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: types: reuse common =?utf-8?Q?phys=5Fv?=
 =?utf-8?Q?ec_type_instead_of_DMABUF_open=E2=80=91coded?= variant
Message-ID: <20260118165453.GB13201@unreal>
References: <20260107-convert-to-pvec-v1-1-6e3ab8079708@nvidia.com>
 <20260114121819.GB10680@unreal>
 <20260116101455.45e39650@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260116101455.45e39650@shazbot.org>

On Fri, Jan 16, 2026 at 10:14:55AM -0700, Alex Williamson wrote:
> On Wed, 14 Jan 2026 14:18:19 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > On Wed, Jan 07, 2026 at 11:14:14AM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > After commit fcf463b92a08 ("types: move phys_vec definition to common header"),
> > > we can use the shared phys_vec type instead of the DMABUF‑specific
> > > dma_buf_phys_vec, which duplicated the same structure and semantics.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > > Alex,
> > > 
> > > According to diffstat, VFIO is the subsystem with the largest set of changes,
> > > so it would be great if you could take it through your tree.
> > > 
> > > The series is based on the for-7.0/blk-pvec shared branch from Jens:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=for-7.0/blk-pvec
> > > 
> > > Thanks
> > > ---  
> > 
> > Alex,
> > 
> > Could you please move this patch forward? We have the RDMA series [1] that
> > depends on this rename, and I would like to base it on the shared branch.
> > 
> > [1] https://lore.kernel.org/all/20260108-dmabuf-export-v1-0-6d47d46580d3@nvidia.com/
> 
> I tried to ping Jens regarding why the branch with this code hasn't
> been merged into their for-next branch, maybe you have more traction.

It is in block/for-next now, commit df73d3c618b4 ("Merge branch
'for-7.0/blk-pvec' into for-7.0/block".

Thanks

> Thanks,
> 
> Alex
> 

