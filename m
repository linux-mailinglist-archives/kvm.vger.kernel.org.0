Return-Path: <kvm+bounces-44591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42CCBA9F75D
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 19:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1D421A85205
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524372949E6;
	Mon, 28 Apr 2025 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFNCyztK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E50153808;
	Mon, 28 Apr 2025 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745861439; cv=none; b=JKVMCE2OP921/4Gzo3q/K5uW380QulmKutpljMGRc8EgITNC7kUsIt8RP2WdvdOFs0EYn/o4R4HXUj2ST0okwtUZQJhLiaSW/fAgTYyH5M+Ocfa/lWMGMlWDysw70lKqm008PJ3MGEvzcJWuyKTcqdvYwHJen9IiOD+PwwNQth4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745861439; c=relaxed/simple;
	bh=ab2ae8e/65ivTF8ecHo7+deewxqwGOGmR1WVeufmqHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c6vQSr+KFjAhqKUIaFEe3o1YiqKQNQXIUEeefYK8tKgcb/PcdqglhuRcXZCBXRVqM+ZV7V7QuF0vHQNiwcqBQuj8u5P7WqWDS0U/n34v9XzLQH9k4azIG7ABXVfObK0wN1Zoe5ncZz0mnVYuKXIFC4T8OyzAOd4NfrysDGkbK4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFNCyztK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78575C4CEE4;
	Mon, 28 Apr 2025 17:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745861438;
	bh=ab2ae8e/65ivTF8ecHo7+deewxqwGOGmR1WVeufmqHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EFNCyztKW7+/Evx7uEJGPtK2SefAgYmqtED4ANsvGmvDwBuQlhn5S/nOmqu3WBR1z
	 +VFQyVwyP+0O2cMp8wyAXepn0PBELCi0ksp0PKLJBKlMwsEdig7AFEj4wICYu3fAJQ
	 /zZeikIV4GSdae/Y2/DwH4bks++gRwmwp9dpfRTMH4Z1ZCpPgQcQmi4pOO08SmuMpb
	 PTiv7J0eh/bS37eMFbiD7C8K8hWZiVIArkSUuuY+DzvZ8SoAg2vgkigVBG4ZUgJkdE
	 7Vrm2LUXRrJhMi9MPNfGblL+7IObYzGv0HZAEJnZAxGsJP7ubWBtZWh1DwAjICEoUP
	 0fglvd90xB7zw==
Date: Mon, 28 Apr 2025 11:30:34 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
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
Message-ID: <aA-7Oh4T-mDGvLXh@kbusch-mbp.dhcp.thefacebook.com>
References: <cover.1745831017.git.leon@kernel.org>
 <007e00134d49160d5edab94a72c35b7b91429b09.1745831017.git.leon@kernel.org>
 <aA-w20gOKus5hyAV@kbusch-mbp.dhcp.thefacebook.com>
 <20250428172225.GG5848@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428172225.GG5848@unreal>

On Mon, Apr 28, 2025 at 08:22:25PM +0300, Leon Romanovsky wrote:
> On Mon, Apr 28, 2025 at 10:46:19AM -0600, Keith Busch wrote:
> > On Mon, Apr 28, 2025 at 12:22:29PM +0300, Leon Romanovsky wrote:
> > > +	do {
> > > +		if (WARN_ON_ONCE(mapped == entries)) {
> > > +			iter.status = BLK_STS_IOERR;
> > > +			break;
> > > +		}
> > > +		nvme_pci_sgl_set_data(&sg_list[mapped++], &iter);
> > 
> > I think this should say "++mapped" so that the data blocks start at
> > index 1 (continued below...)
> > 
> > > +		iod->total_len += iter.len;
> > > +	} while (blk_rq_dma_map_iter_next(req, dev->dev, &iod->dma_meta_state,
> > > +				 &iter));
> > >  
> > > -out_unmap_sg:
> > > -	dma_unmap_sgtable(dev->dev, &iod->meta_sgt, rq_dma_dir(req), 0);
> > > -out_free_sg:
> > > -	mempool_free(iod->meta_sgt.sgl, dev->iod_meta_mempool);
> > > -	return BLK_STS_RESOURCE;
> > > +	nvme_pci_sgl_set_seg(sg_list, sgl_dma, mapped);
> > 
> > because this here is setting sg_list index 0 to be the segment
> > descriptor.
> > 
> > And you also need to increment sgl_dma to point to the element after
> > sg_list, otherwise it's pointing right back to itself, creating a looped
> > list.
> 
> Thanks for pointing to the difference between data_map and metadata_map,

Yeah, They're different because the SQE has 16 bytes available for the
data map, so the command can fit an SGL descriptor directly in its
submission entry. The metadata field only has 8 bytes in the SQE, so we
have to set it to the address of an external SGL segment descriptor.

