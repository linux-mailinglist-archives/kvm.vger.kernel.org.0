Return-Path: <kvm+bounces-43753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA4E6A95F81
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:33:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 693AC7A9CE7
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 07:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FBBC1EDA3E;
	Tue, 22 Apr 2025 07:32:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197C01EB5F6;
	Tue, 22 Apr 2025 07:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745307150; cv=none; b=cQXYnRLy2uwAOzQU3Em4Wx5JQiO6H1j6Z3w1thoQj9qhJ3kjIvPwI+HZ+PvjfckoJlzRlQlaUQTaUD2YnxGLRqvbiZ73QB0s4yO3NaxVoSareKk2nYY7L4hKN5JOcllqqqdOqR50ze7t8GH9NA6FsqSLU3fyrXDymJ+jCX6I+WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745307150; c=relaxed/simple;
	bh=Keqxor1ODBLPmVawW5vsbj3/9Z2VBK6VDWsYSbORC00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/OWHgbjwX6015ma4TJHRG4iXwD28vIrqfbTa0RTThOjCXqnnypfqPxbYMSM8HWNzFZhEkOE9zG11nKL7ydX3/ZYf/4iLLpSS/Vy8aOxKZJVEkR1c5Z3cWcQOqE1uEOGW9paN5tdxU5btC+ImZ9cshZBoHid/aZxnyNjLDXF9NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0CE9D68AA6; Tue, 22 Apr 2025 09:32:22 +0200 (CEST)
Date: Tue, 22 Apr 2025 09:32:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
Subject: Re: [PATCH v8 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <20250422073221.GA31688@lst.de>
References: <cover.1744825142.git.leon@kernel.org> <f06a04098cb14e1051bddec8a7bdebe1c384d983.1744825142.git.leon@kernel.org> <20250422050050.GB28077@lst.de> <20250422072606.GC48485@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422072606.GC48485@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 22, 2025 at 10:26:06AM +0300, Leon Romanovsky wrote:
> On Tue, Apr 22, 2025 at 07:00:50AM +0200, Christoph Hellwig wrote:
> > > +	dma_len = min_t(u32, length, NVME_CTRL_PAGE_SIZE - (dma_addr & (NVME_CTRL_PAGE_SIZE - 1)));
> > 
> > And overly long line slipped in here during one of the rebases.
> > 
> > > +		/*
> > > +		 * We are in this mode as IOVA path wasn't taken and DMA length
> > > +		 * is morethan two sectors. In such case, mapping was perfoormed
> > > +		 * per-NVME_CTRL_PAGE_SIZE, so unmap accordingly.
> > > +		 */
> > 
> > Where does this comment come from?  Lots of spelling errors, and I
> > also don't understand what it is talking about as setors are entirely
> > irrelevant here.
> 
> I'm trying to say when this do {} while is taken and sector is a wrong
> word to describe NVME_CTRL_PAGE_SIZE. Let's remove this comment.

Yes, I'd say drop it.

> > With the addition of metadata SGL support this also needs to check
> > NVME_CMD_SGL_METASEG.
> > 
> > The commit message should also really mentioned that someone
> > significantly altered the patch for merging with latest upstream,
> > as I as the nominal author can't recognize some of that code.
> 
> Someone :), I thought that adding my SOB is enough.

Well, it also has Chaitanya's, so it must have passed through both of
you at least.  Usually you want to add a little line explaining what you
changed for non-trivial changes when changing it.

>         if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_meta_state,
>                               iod->total_meta_len)) {
> -               if (entries == 1) {
> +               if (iod->cmd.common.flags & NVME_CMD_SGL_METASEG) {
> +                       unsigned int i;
> +
> +                       for (i = 0; i < entries; i++)
> +                               dma_unmap_page(dev->dev,
> +                                      le64_to_cpu(sg_list[i].addr),
> +                                      le32_to_cpu(sg_list[i].length), dir);
> +               } else {
>                         dma_unmap_page(dev->dev, iod->meta_dma,
> -                                      rq_integrity_vec(req).bv_len,
> -                                      rq_dma_dir(req));
> +                                      rq_integrity_vec(req).bv_len, dir);
>                         return;

It would be nice if we could share a bit of code with the data
mapping, but I'm not sure that's possible.  I'll try to look into
it and review things more carefully once I've reduced my backlog.


