Return-Path: <kvm+bounces-43751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 759A0A95F4E
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 249A53B96D6
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 07:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3934323F412;
	Tue, 22 Apr 2025 07:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+kjxQ3D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53EE239567;
	Tue, 22 Apr 2025 07:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745306771; cv=none; b=AM57Yv6J5AvGTrPTgrDSDcgFyg+LI+eOdi4QOaDcB7dshdbObNQxrQFAQbJdIkJf5qpBC3cGqGbFCWWYxTwj13q3cMsfTOaZb5h2TgN7vggSBA3zdrr+mCsbl6O0BFb7JGR6LEd2zs7MOoPhbZ3JDgIf7/0npXXgnLWqLIsDd6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745306771; c=relaxed/simple;
	bh=xN+WXXtReip5UqyzmA8L0bQhenwCbDjSz9Q+yfqmAMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVaB2UlwTrVWY4XNGcFDOISDU82a9CcIMcDGB78jl3wJPP0JcgvPi0LtrMfbYB5IkCcUuucYOESMmbrD/KZst1hYRSd/G0Cfvw7N3Wy8GUzRwzx2Qzxxb8FyWXdcsv4vFucGqKbu0OjIkbIT/POcAgYWKNhjuIR7/taZa/yZtSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+kjxQ3D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2DEC4CEE9;
	Tue, 22 Apr 2025 07:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745306771;
	bh=xN+WXXtReip5UqyzmA8L0bQhenwCbDjSz9Q+yfqmAMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T+kjxQ3DEPfKwlnz4ZsUDQJrurgBpYIvnlrJCi1o7bGuhNceV40t7HE/1xO8wR9Yb
	 XqXYR6OJwsS92ouacGloivohWNsdc7yQTCXlieXHyMZSDeI4gKtISD5bdXJ7qypls6
	 6bZi9HB9VfNpBB8VY/FRmXpBsoECeH0PTBRIxfT9fPPKnqee23MIdkAqBcDi3rUZ+4
	 /BJqBQFefNqgzuto6SdwGElfoODTNQUBkGR4gebKND6VNauPo2sYytZqQICgsqeqij
	 kpC9oyp1tE0IjwFexsb18IzStSzuJpdjBQFiXvjt/3to/J7JYYIZd8gnhECeIAhlc7
	 0z3AdWi9XN8uA==
Date: Tue, 22 Apr 2025 10:26:06 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
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
Message-ID: <20250422072606.GC48485@unreal>
References: <cover.1744825142.git.leon@kernel.org>
 <f06a04098cb14e1051bddec8a7bdebe1c384d983.1744825142.git.leon@kernel.org>
 <20250422050050.GB28077@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422050050.GB28077@lst.de>

On Tue, Apr 22, 2025 at 07:00:50AM +0200, Christoph Hellwig wrote:
> > +	dma_len = min_t(u32, length, NVME_CTRL_PAGE_SIZE - (dma_addr & (NVME_CTRL_PAGE_SIZE - 1)));
> 
> And overly long line slipped in here during one of the rebases.
> 
> > +		/*
> > +		 * We are in this mode as IOVA path wasn't taken and DMA length
> > +		 * is morethan two sectors. In such case, mapping was perfoormed
> > +		 * per-NVME_CTRL_PAGE_SIZE, so unmap accordingly.
> > +		 */
> 
> Where does this comment come from?  Lots of spelling errors, and I
> also don't understand what it is talking about as setors are entirely
> irrelevant here.

I'm trying to say when this do {} while is taken and sector is a wrong
word to describe NVME_CTRL_PAGE_SIZE. Let's remove this comment.

> 
> > +	if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_state, iod->total_len)) {
> > +		if (iod->cmd.common.flags & NVME_CMD_SGL_METABUF)
> > +			nvme_free_sgls(dev, req);
> 
> With the addition of metadata SGL support this also needs to check
> NVME_CMD_SGL_METASEG.
> 
> The commit message should also really mentioned that someone
> significantly altered the patch for merging with latest upstream,
> as I as the nominal author can't recognize some of that code.

Someone :), I thought that adding my SOB is enough.

> 
> > +	unsigned int entries = req->nr_integrity_segments;
> >  	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> >  
> > +	if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_meta_state,
> > +			      iod->total_meta_len)) {
> > +		if (entries == 1) {
> > +			dma_unmap_page(dev->dev, iod->meta_dma,
> > +				       rq_integrity_vec(req).bv_len,
> > +				       rq_dma_dir(req));
> > +			return;
> >  		}
> >  	}
> >  
> > +	dma_pool_free(dev->prp_small_pool, iod->meta_list, iod->meta_dma);
> 
> This now doesn't unmap for entries > 1 in the non-IOVA case.

I forgot to unmap SGL metadata, in non-SGL, the metadata is the size of
one entry. There is no "entries > 1" for non-SGL path.

WDYT?

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a9c298a45bf1..73dbedd7daf6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -839,13 +839,21 @@ static __always_inline void nvme_unmap_metadata(struct nvme_dev *dev,
 {
        unsigned int entries = req->nr_integrity_segments;
        struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+       struct nvme_sgl_desc *sg_list = iod->meta_list;
+       enum dma_data_direction dir = rq_dma_dir(req);

        if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_meta_state,
                              iod->total_meta_len)) {
-               if (entries == 1) {
+               if (iod->cmd.common.flags & NVME_CMD_SGL_METASEG) {
+                       unsigned int i;
+
+                       for (i = 0; i < entries; i++)
+                               dma_unmap_page(dev->dev,
+                                      le64_to_cpu(sg_list[i].addr),
+                                      le32_to_cpu(sg_list[i].length), dir);
+               } else {
                        dma_unmap_page(dev->dev, iod->meta_dma,
-                                      rq_integrity_vec(req).bv_len,
-                                      rq_dma_dir(req));
+                                      rq_integrity_vec(req).bv_len, dir);
                        return;
                }
        }



> 

