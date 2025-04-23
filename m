Return-Path: <kvm+bounces-43907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2013DA98505
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F22C5A5E68
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 09:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275DB274FDA;
	Wed, 23 Apr 2025 09:06:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E6C269AFB;
	Wed, 23 Apr 2025 09:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745399161; cv=none; b=dHhAZ4T/pkrlxHz+IyIzp5SZFoab4/NKu3YzgyX7xQWb8uYQu5NSdlwxPVW7+OyD9LQpf/NjHzxVxZSelV4WPHEXI9qBJ8CbcPNLnnSV7o1HuYoIa3CvXpQYiIp0d6QuOhyvho/W35598RorK30aS8H1gV/GVFWprKnlhbpKQqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745399161; c=relaxed/simple;
	bh=yZ14u45nosFnORYpl+CjzdK4IPUWLeh5MUca7Ao0xuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=toAk8Qwy0Yc8J2hdl2I0X9vZWSXI+892xu3PsxCJxjvuerbc0zMfHKCmDp6ju0mBzjZGy5u3tkFrgfG555Xp/GDV8Cy+gaVneYMltWejNtonnhd9hcVUCsb98RF+2hGDnL3p+t7x01yQhDb4za332cJ7UD1b1CtCpxm2o52GyBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E400768AFE; Wed, 23 Apr 2025 11:05:52 +0200 (CEST)
Date: Wed, 23 Apr 2025 11:05:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
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
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v9 22/24] nvme-pci: use a better encoding for small prp
 pool allocations
Message-ID: <20250423090552.GA381@lst.de>
References: <cover.1745394536.git.leon@kernel.org> <973ed41249e12766383b3cedac799692f9bda3b8.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <973ed41249e12766383b3cedac799692f9bda3b8.1745394536.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 23, 2025 at 11:13:13AM +0300, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> There is plenty of unused space in the iod next to nr_descriptors.
> Add a separate flag to encode that the transfer is using the full
> page sized pool, and use a normal 0..n count for the number of
> descriptors.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Jens Axboe <axboe@kernel.dk>
> [ Leon: changed original bool variable to be flag as was proposed by Kanchan ]
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/nvme/host/pci.c | 93 ++++++++++++++++++++---------------------
>  1 file changed, 46 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 638e759b29ad..7e93536d01cb 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -44,6 +44,7 @@
>  #define NVME_MAX_SEGS	128
>  #define NVME_MAX_META_SEGS 15
>  #define NVME_MAX_NR_DESCRIPTORS	5
> +#define NVME_SMALL_DESCRIPTOR_SIZE 256
>  
>  static int use_threaded_interrupts;
>  module_param(use_threaded_interrupts, int, 0444);
> @@ -219,6 +220,10 @@ struct nvme_queue {
>  	struct completion delete_done;
>  };
>  
> +enum {
> +	IOD_LARGE_DESCRIPTORS = 1, /* uses the full page sized descriptor pool */

This is used as a ORable flag, I'd make that explicit:

	/* uses the full page sized descriptor pool */
	IOD_LARGE_DESCRIPTORS		= 1U << 0,

and similar for the next flag added in the next patch.

>  	struct nvme_request req;
>  	struct nvme_command cmd;
>  	bool aborted;
> -	/* # of PRP/SGL descriptors: (0 for small pool) */
> -	s8 nr_descriptors;
> +	u8 nr_descriptors;	/* # of PRP/SGL descriptors */
> +	unsigned int flags;

And this should be limited to a u16 to not bloat the structure.


