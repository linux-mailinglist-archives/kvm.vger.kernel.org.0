Return-Path: <kvm+bounces-44491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33CB0A9E063
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67F5C17DB5A
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 07:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854D2247287;
	Sun, 27 Apr 2025 07:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1xqE+mq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823868BE7;
	Sun, 27 Apr 2025 07:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745738712; cv=none; b=m8A1ONpjtDWfN/06FtimLX3dQUc+seGSV4cjYLxQVMBr3T10zSz6OFjQoOxNo/vvC/XrBxC/VSFYdJYooEj1qdTGZdCYZN3CrKSgR54MQePw8lkspeS2n/Jnn/ZuLwa0lyrVnwE8mdxNfpDTLCqEjBGEkNq8nzuP/d7gQXe6Yaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745738712; c=relaxed/simple;
	bh=bERqNoVKbx4P/SwDDUOXyFXrxjwzNnYFUoDcCNKCVfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cje/cKoF1gV8pQ6CBVfcjehbzOMIoEQZAq5pRKC5DnsU0sjL+HkCw1AJ2j5bQTYwXwMbRQx64JkMHr+CcWJL8pOCh/7WtryWX/aZesAYAJdMRHKZ/YjOtGyq3Fj1m5c3cLNk95Cwpq1xI76PEdDKquujyhEuzRooHD6IzJX/PFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O1xqE+mq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40495C4CEE3;
	Sun, 27 Apr 2025 07:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745738712;
	bh=bERqNoVKbx4P/SwDDUOXyFXrxjwzNnYFUoDcCNKCVfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O1xqE+mqwh8U+55fROspjUrKNzRVSIzJfDGM+Ls83njMJYStvF3kCZtrxDGnS8SVT
	 FH2Y3/4QmPSaIrhVwSXIBJfNKQb2jOqg/0R9XOlNO+8e0XTTOVDsgTNzItS/cuPjFL
	 PJCX+bYuGxOwMqFXAxDt9oJubodYIurQ+knbiSyXMkoJmOUGIl6AyOiN49LQkcuXwW
	 lX4Zt8yUC+E7ZRN3ptmo7qa1Dn9p3RQqNw+5yoy5YM9m0zO7K7IBGHJkXHsUDSieM4
	 qCQegX3jtiPkdIH87I9vQ2L9GafYOjlgT1bfZh8UZrFfu8pXhN2WP2XoeZGCszveQ5
	 tJLYM5tBLk6AQ==
Date: Sun, 27 Apr 2025 10:25:07 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
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
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 01/24] PCI/P2PDMA: Refactor the p2pdma mapping helpers
Message-ID: <20250427072507.GB5848@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <3a962f9039f0265de939f4c81924ee8208fc93a6.1745394536.git.leon@kernel.org>
 <aAwnJwLeOs7rfkHL@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAwnJwLeOs7rfkHL@bombadil.infradead.org>

On Fri, Apr 25, 2025 at 05:21:59PM -0700, Luis Chamberlain wrote:
> On Wed, Apr 23, 2025 at 11:12:52AM +0300, Leon Romanovsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > The current scheme with a single helper to determine the P2P status
> > and map a scatterlist segment force users to always use the map_sg
> > helper to DMA map, which we're trying to get away from because they
> > are very cache inefficient.
> > 
> > Refactor the code so that there is a single helper that checks the P2P
> > state for a page, including the result that it is not a P2P page to
> > simplify the callers, and a second one to perform the address translation
> > for a bus mapped P2P transfer that does not depend on the scatterlist
> > structure.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > Tested-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Might make it easier for patch review to split off adding
> __pci_p2pdma_update_state() in a seprate patch first.

Original code __pci_p2pdma_update_state() had this code and was
dependent on SG, which we are removing in this patch.

       if (state->map == PCI_P2PDMA_MAP_BUS_ADDR) {
               sg->dma_address = sg_phys(sg) + state->bus_off;
               sg_dma_len(sg) = sg->length;
               sg_dma_mark_bus_address(sg);
       }

So to split, we would need to introduce new version of __pci_p2pdma_update_state(),
rename existing one to something like __pci_p2pdma_update_state2() and
remove it in next patch. Such pattern of adding and immediately deleting
code is not welcomed.

> Other than that, looks good.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kenrel.org>

Thanks

> 
>   Luis

