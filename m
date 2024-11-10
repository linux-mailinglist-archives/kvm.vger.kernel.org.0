Return-Path: <kvm+bounces-31363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BEE9C31AA
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 11:41:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44A68281876
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 10:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33683155385;
	Sun, 10 Nov 2024 10:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JW8duPR4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D367142E7C;
	Sun, 10 Nov 2024 10:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731235298; cv=none; b=TZnUl+2jMH5+ry0rhEY8QcMtRNsMd2mYwDslnS8SlQCgY3/YwGGmsF+MsCPD8g4DHkmjCXrU1c3W71kXJckTmOEjS/KLvDUzkw+mZriIVkZ/LGNy1dS2EUBfww7RN3tm+WSONcrvbluncK+qx1QkXqZzsIfI5tC4aqimg8W5PMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731235298; c=relaxed/simple;
	bh=KJTVz52sJu2oQj0BOPzh46r/ng+VWSz4cJfy6f2DTow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rrjRRUscW6sF9gtF1X9gjp6Q+I7nc8kjMLZPgBtFLcGwpGfE8Gg+IIfTLigpkDs5F2KTOB91TKSKiDoD+3A1Y1fK707EhgsjdWVJhI70O49Kgen0CTfg8PgSYluf9kDtxqCo16iNqbpsl9SF52gNTfxTzwt7cv3Iw7FFM698Gnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JW8duPR4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A12DC4CECD;
	Sun, 10 Nov 2024 10:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731235297;
	bh=KJTVz52sJu2oQj0BOPzh46r/ng+VWSz4cJfy6f2DTow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JW8duPR4zgtshHYsGnyTHtlzUbI9C7VSu6DKWCkFGrApkoWJWSxhGLCw5xgUraK37
	 KyNCPb36UhLBki49PXkqcD2sBnsPb3pSEYoDPi+P4LFHLRa96gSHPosI6C7dqbYMip
	 vIVxA0qXAzTZEbJq1b7ufQuqLIfu45BQHuHyL9EX1PQY+YtgJ833g0BRQjd7iEAg3m
	 WndbNLaXlStjkG2lTw6sbX+1iBBO11XE41go4jd7Z15Ik1RN38Prs+eyzYb42sG812
	 MOTUu7mg3HBNZVbtRKgzK0VBiDj1HOzE5fnpSg4ms0Wa3VJ7O+NYsKsaWDPF/fo35+
	 lxhrXIwkV8nJA==
Date: Sun, 10 Nov 2024 12:41:30 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
Message-ID: <20241110104130.GA19265@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
 <87ttchwmde.fsf@trenco.lwn.net>
 <20241108200355.GC189042@unreal>
 <87h68hwkk8.fsf@trenco.lwn.net>
 <20241108202736.GD189042@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108202736.GD189042@unreal>

On Fri, Nov 08, 2024 at 10:27:36PM +0200, Leon Romanovsky wrote:
> On Fri, Nov 08, 2024 at 01:13:27PM -0700, Jonathan Corbet wrote:
> > Leon Romanovsky <leon@kernel.org> writes:
> > 
> > >> So, I see that you have nice kernel-doc comments for these; why not just
> > >> pull them in here with a kernel-doc directive rather than duplicating
> > >> the information?
> > >
> > > Can I you please point me to commit/lore link/documentation with example
> > > of such directive and I will do it?
> > 
> > Documentation/doc-guide/kernel-doc.rst has all the information you need.
> > It could be as simple as replacing your inline descriptions with:
> > 
> >   .. kernel-doc:: drivers/iommu/dma-iommu.c
> >      :export:
> > 
> > That will pull in documentation for other, unrelated functions, though;
> > assuming you don't want those, something like:
> > 
> >   .. kernel-doc:: drivers/iommu/dma-iommu.c
> >      :identifiers: dma_iova_try_alloc dma_iova_free ...
> > 
> > Then do a docs build and see the nice results you get :)
> 
> Thanks for the explanation, will change it.

Jonathan,

I tried this today and the output (HTML) in the new section looks
so different from the rest of dma-api.rst that I lean to leave
the current doc implementation as is.

Thanks

> 
> > 
> > Thanks,
> > 
> > jon
> 

