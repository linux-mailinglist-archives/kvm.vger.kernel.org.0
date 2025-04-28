Return-Path: <kvm+bounces-44590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F60FA9F733
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 19:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 261E3173076
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5C328F517;
	Mon, 28 Apr 2025 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dCCvX7rC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C39D279910;
	Mon, 28 Apr 2025 17:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745860950; cv=none; b=gUyOmlk4Uj/ySsCrH/VQj/GQKbeBCx/foxE7VeQ0gPdGXmLCjMERHGAN6ekt0ZBiADEiHbisz1Pjpz6KIIEHRlsLU96muRymOF6n4BWEWudKjlX8lhhTspX6iPjaeBOAf11/QSc/oMLnOib2dyZDngHwV2drLI6mCeoUkLd6p1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745860950; c=relaxed/simple;
	bh=gYg74JiB5JakFxosXZhQLQiNqGZNU3mPT/z4lhxtdMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mEmsibjKtx+1Qnhf40+wLyRI/iYiLSMuCM3rZkASxAMif/EoJiPoGhVrtTFRbq1cacP8SSWz7NSz9WXd2SjzicE0rk+qTtgTpRm8R65nFow7U83aCWNTjgp9koH+Bcnx7aszzNDK5hQBqNirT/jCr4XKqLCQ7IkJqbN1ZN8JhEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dCCvX7rC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8E4C4CEE4;
	Mon, 28 Apr 2025 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745860949;
	bh=gYg74JiB5JakFxosXZhQLQiNqGZNU3mPT/z4lhxtdMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dCCvX7rC72JWr7s0YvTI7g9kE+dAdbJ9qPCeyBTmld4lQ3lxym1bm5n7CK23ZbPA3
	 4ZspxkotQfcA+i0UwXLwN+ARCHDhSheR12H/DrKO3QMjiR9Ix5T+qkG3Wq7c95k8Tz
	 ocl6oT61kcsd5Tad4FjMD4Pn4uru4Gg4+Eu1WtxWXOO184jGJ4GXBgm5SoZb6Op0pi
	 QZXhP9YFwutRlAOVwL49o6dg7f+L4Eee5j6ByGmpfbcxHXRKiLSTIAztxNr7Di0lAf
	 zRT0ZI+MoU0PfyQuo6YBGUoloJs2gfsBYCL/17f3Mc9Ve1W2QoJQtDaZJQRRe0I+AR
	 DNToLbBLnWQGA==
Date: Mon, 28 Apr 2025 20:22:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
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
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v10 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <20250428172225.GG5848@unreal>
References: <cover.1745831017.git.leon@kernel.org>
 <007e00134d49160d5edab94a72c35b7b91429b09.1745831017.git.leon@kernel.org>
 <aA-w20gOKus5hyAV@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aA-w20gOKus5hyAV@kbusch-mbp.dhcp.thefacebook.com>

On Mon, Apr 28, 2025 at 10:46:19AM -0600, Keith Busch wrote:
> On Mon, Apr 28, 2025 at 12:22:29PM +0300, Leon Romanovsky wrote:
> > +	do {
> > +		if (WARN_ON_ONCE(mapped == entries)) {
> > +			iter.status = BLK_STS_IOERR;
> > +			break;
> > +		}
> > +		nvme_pci_sgl_set_data(&sg_list[mapped++], &iter);
> 
> I think this should say "++mapped" so that the data blocks start at
> index 1 (continued below...)
> 
> > +		iod->total_len += iter.len;
> > +	} while (blk_rq_dma_map_iter_next(req, dev->dev, &iod->dma_meta_state,
> > +				 &iter));
> >  
> > -out_unmap_sg:
> > -	dma_unmap_sgtable(dev->dev, &iod->meta_sgt, rq_dma_dir(req), 0);
> > -out_free_sg:
> > -	mempool_free(iod->meta_sgt.sgl, dev->iod_meta_mempool);
> > -	return BLK_STS_RESOURCE;
> > +	nvme_pci_sgl_set_seg(sg_list, sgl_dma, mapped);
> 
> because this here is setting sg_list index 0 to be the segment
> descriptor.
> 
> And you also need to increment sgl_dma to point to the element after
> sg_list, otherwise it's pointing right back to itself, creating a looped
> list.

Thanks for pointing to the difference between data_map and metadata_map,
I see it now:
        sgl_dma += sizeof(*sg_list);
	nvme_pci_sgl_set_seg(sg_list, sgl_dma, entries);
	for_each_sg(sgl, sg, entries, i)
	        nvme_pci_sgl_set_data(&sg_list[i + 1], sg);

Thanks

> 
> > +	if (unlikely(iter.status))
> > +		nvme_unmap_metadata(dev, req);
> > +	return iter.status;
> >  }

