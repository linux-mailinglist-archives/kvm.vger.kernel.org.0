Return-Path: <kvm+bounces-33564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B5BB9EE15C
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74F4C283E6B
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C5020DD71;
	Thu, 12 Dec 2024 08:35:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777E0181334;
	Thu, 12 Dec 2024 08:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733992506; cv=none; b=e3bBSZgcRlzsaiT3O+c6dSd0KVTkHIZh17ZrXBy1pFkGzz3HGRRPoPqNyHndxsKW8LVAA49U4AZrWVlOXHiFYS6PgXMnvj7eRblMrvYZnJu8Api33hHHfLA/5Fkz0oe2OsrWIUJ8qqaNdZB+Hen6NB0WzCJqhhA665782nebdhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733992506; c=relaxed/simple;
	bh=rrBYBkbHZcn5I1aF3U8lL3NmmSK4aCBmuavcvGmQk1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2wEGGQBSNYY54z64MEUblfnnLxnI6rARNViD04pk+x4xzmwlDJ2SYc67TdikV3Rsok+QjR4EKjGPDOhJI80Yn26QU3bBWoS9zjIuDcfZ1T3isEBDbh1rg+nnhLl8FD0eQzWPbeTi51j2AQPjW84gRznfp7MfcHo4p/zRz96qwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AE9AF68D12; Thu, 12 Dec 2024 09:34:59 +0100 (CET)
Date: Thu, 12 Dec 2024 09:34:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Leon Romanovsky <leonro@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v4 05/18] dma-mapping: Add check if IOVA can be used
Message-ID: <20241212083459.GB9376@lst.de>
References: <cover.1733398913.git.leon@kernel.org> <b23a1e29f00f31f31641479c90f2471aee27fac5.1733398913.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b23a1e29f00f31f31641479c90f2471aee27fac5.1733398913.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 05, 2024 at 03:21:04PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> This patch adds a check if IOVA can be used for the specific
> transaction.
> 
> In the new API a DMA mapping transaction is identified by a
> struct dma_iova_state, which holds some recomputed information
> for the transaction which does not change for each page being
> mapped.

While the content of the patch here looks fine, the super fine
grained patch split look really odd and makes sensible review
hard.  Was this a request on one of the earlier versions?


