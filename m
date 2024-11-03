Return-Path: <kvm+bounces-30425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 852399BA65D
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 16:20:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30D181F214DD
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 15:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC9718784C;
	Sun,  3 Nov 2024 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5cWNoE8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE70D2628C;
	Sun,  3 Nov 2024 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730647196; cv=none; b=rcbtKQaV/6iv/P5TABUG7MOFuim+8DbFEk6VSB8KpqQyLkRAbg+nBVAlNUOAP+h1/PNEyCSpoujolKXfn+JL+LMxyjiMdNHCFAFVy9N8Su1qyPYG4TUloRdDeWw/jbvCAAvgKDJM1/jyKLbA/nxEqbev7UGgue9HgVBjMSodU0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730647196; c=relaxed/simple;
	bh=SfCXMZbNHN7ZBHtRMXT8dYyPlDizsgfBlczM/Izb1OA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IeYkaGo2GHw/aPhPye38XuY3lCcRm80pT4R75Ul6PR0Qir1oJ5eTqenLCUjxzfh1qRv7Xlpaiwg3Mny1/MlLSQVCVv0xuOtz/jDJs9iJHh8pu97KHenXtpCcRCy0YLRw1jqABdLE78DyX0a5ACycRansuMIbUiiQ3dGsfXzZyA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5cWNoE8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D95DC4CECD;
	Sun,  3 Nov 2024 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730647195;
	bh=SfCXMZbNHN7ZBHtRMXT8dYyPlDizsgfBlczM/Izb1OA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j5cWNoE8etENxU7IbfrBszJT10f6EWlfJqpPGvOpaZLTiWI1AidHTPWSL24msep+k
	 At1fyHSehamOum/Kpf4tDMLVsWjyCbFVB1L3+uJPROcdL+JtfpRWtGbmTmmXws4+mU
	 6Tax5d+Pem6waJZPuDXZsKSMbCUFxwDHGiatqmjanHAiNyMOnFy3GO/14wUoY9qDlK
	 mafUcrdLGbf/qNYnEXemxmwc/kgO13ERQSBD0Q59NhZKcEgGCMs/Jsfq3Fei7V6xWc
	 KS0Si/iP8Vl1pnx/fUh5aIOdBMiN7U2MYN4bxu2bUCfSI0yrbv2ocwZ0+G5O8IPgHi
	 San3mdWHVOs/A==
Date: Sun, 3 Nov 2024 17:19:46 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
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
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/7] block: don't merge different kinds of P2P
 transfers in a single bio
Message-ID: <20241103151946.GA99170@unreal>
References: <cover.1730037261.git.leon@kernel.org>
 <34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org>
 <f80e7b54-b897-4df2-a49d-bc6012640a8a@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f80e7b54-b897-4df2-a49d-bc6012640a8a@linux.dev>

On Sat, Nov 02, 2024 at 08:39:35AM +0100, Zhu Yanjun wrote:
> 在 2024/10/27 15:21, Leon Romanovsky 写道:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > To get out of the dma mapping helpers having to check every segment for
> > it's P2P status, ensure that bios either contain P2P transfers or non-P2P
> > transfers, and that a P2P bio only contains ranges from a single device.
> > 
> > This means we do the page zone access in the bio add path where it should
> > be still page hot, and will only have do the fairly expensive P2P topology
> > lookup once per bio down in the dma mapping path, and only for already
> > marked bios.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   block/bio.c               | 36 +++++++++++++++++++++++++++++-------
> >   block/blk-map.c           | 32 ++++++++++++++++++++++++--------
> >   include/linux/blk_types.h |  2 ++
> >   3 files changed, 55 insertions(+), 15 deletions(-)

<...>

> > @@ -410,6 +411,7 @@ enum req_flag_bits {
> >   #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
> >   #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
> >   #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
> > +#define REQ_P2PDMA	(__force blk_opf_t)(1ULL << __REQ_P2PDMA)
> 
> #define REQ_P2PDMA	(__force blk_opf_t)BIT_ULL(__REQ_P2PDMA)
> 
> Use BIT_ULL instead of direct left shit.

We keep coding style consistent and all defines above aren't implemented
with BIT_ULL().

Thanks

> 
> Zhu Yanjun
> 
> >   #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
> 

