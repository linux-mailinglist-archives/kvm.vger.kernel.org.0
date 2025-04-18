Return-Path: <kvm+bounces-43650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADD90A9366E
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 13:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1EB5466E0F
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 11:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF922749DC;
	Fri, 18 Apr 2025 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdeyXvfa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9DF21ABCD;
	Fri, 18 Apr 2025 11:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744975194; cv=none; b=IztiSLjtRc0wn/APQmZWN9B0GnoefTe8qxKYlHrFfkwdHhcQGE2JPBdZ4kpVADNcAc/FLO0DL6HvqynE3rlBKqcVjLtYwMDVXJ/ufqnmx9NKFTSeSxeJSa+O8XGrGP4N7ZTlSgLtMkvc2F7ZFxGSxWFH+ZDvWZwL4HqNO8M20us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744975194; c=relaxed/simple;
	bh=A7wvqwnqYa5lljVCih9QNkNHMM3IhtbdB0k5O3y2uik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djqoGW4snnrFHThfuV7Db7gvZo0gGCZrPJNtGrH2/exH7Zc0nkY69vBuiaIwtGeStfgP3rpxaOhf9Oi9/rQHBTHfCrkhj0e1BwBVXImlsI3bi9/pN/E77v5p7eOl4gSWy9lAm4vDP+4sJ6e6f+ZVp9vxmxgjsRBdUEjX2vHbgJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdeyXvfa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E2DC4CEE2;
	Fri, 18 Apr 2025 11:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744975193;
	bh=A7wvqwnqYa5lljVCih9QNkNHMM3IhtbdB0k5O3y2uik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WdeyXvfarIVDZXIlsrZR6q+ZWN3+pN643rg0mOwmYV5A6pKmeRqB/JWY/8ObUAnJi
	 Y1EqzpJAMsZxftxRUhP7InpbxA68zM7a6DddpAF30J+LhDbBYnrB+4R7SOQ7Z46AGH
	 mSi5EInuDvbHAH3PcbwmhGvxSQxVx4wSnWHM7vjrcR9bDC4KkeIuhcfdENyorCWU9U
	 438m+H5AQfvv/rBCcHLE3C4f92y96s5caeLMC+3sz+c/1NNlmdYlYVYpkbEWVlcolR
	 bcqe1xg8mMIU5XVaCBr+Sxo15YaqwuuASTpzG37swqcijwKEEM/LYAGrbVM4ttt8Qo
	 U7pz/uTfDL03g==
Date: Fri, 18 Apr 2025 14:19:49 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
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
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v8 24/24] nvme-pci: optimize single-segment handling
Message-ID: <20250418111949.GC199604@unreal>
References: <cover.1744825142.git.leon@kernel.org>
 <670389227a033bd5b7c5aa55191aac9943244028.1744825142.git.leon@kernel.org>
 <1284adf3-7e93-4530-9921-408c5eaeb337@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284adf3-7e93-4530-9921-408c5eaeb337@kernel.org>

On Fri, Apr 18, 2025 at 05:02:38PM +0900, Damien Le Moal wrote:
> On 4/18/25 15:47, Leon Romanovsky wrote:
> > From: Kanchan Joshi <joshi.k@samsung.com>
> > 
> > blk_rq_dma_map API is costly for single-segment requests.
> > Avoid using it and map the bio_vec directly.
> > 
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/nvme/host/pci.c | 65 +++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 60 insertions(+), 5 deletions(-)

<...>

> >  static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
> >  {
> >  	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> > +	unsigned int nr_segments = blk_rq_nr_phys_segments(req);
> > +	dma_addr_t dma_addr;
> > +
> > +	if (nr_segments == 1 && (iod->flags & IOD_SINGLE_SEGMENT)) {
> 
> nvme_pci_setup_prps() calls nvme_try_setup_prp_simple() which sets
> IOD_SINGLE_SEGMENT if and only if the req has a single phys segment. So why do
> you need to count the segments again here ? Looking at the flag only should be
> enough, no ?

Yes, you are right. There is no need in extra check of nr_segments and
it is enough to rely on IOD_SINGLE_SEGMENT.

Thanks

