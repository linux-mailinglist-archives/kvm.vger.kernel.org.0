Return-Path: <kvm+bounces-33570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EC29EE1DF
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A0E0167528
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6693920E316;
	Thu, 12 Dec 2024 08:51:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B8920C499;
	Thu, 12 Dec 2024 08:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733993500; cv=none; b=H904vKbEvfQX05IfOeek2mZeELC6HfnOFGedHcm22lut07Q0Q9BOnFvV1evr1IrZ0G3MJ++VY5E41MnaIiya0rqqZSm0/A60JHZVpo1c4+I+k17sM6TIUBukNGervcANvZA9fhbdBV5vdM4QFT6f4mB6m5rUvnWUz4itHOH/HCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733993500; c=relaxed/simple;
	bh=iqBPjOHCYyKvzbs7HPUNqqYSdMIjZfsoY2MJDOOLROU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iac3n6VRe0tEzRSt3wRx7zCrhAxKaq+W4GYJJkuBTDB1H6IMe/eU9W3Ge9O/msI/HgF2iwqKMxnjS+hNenyYQhjRbeb/p0F8PzCyxZdpRzVZRaJJQTF5K6odShWnriBSWCnf6ttBouvdePjVcINypeVzKjor/CQ8sCPDwLSAvtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 96FF068D1F; Thu, 12 Dec 2024 09:51:31 +0100 (CET)
Date: Thu, 12 Dec 2024 09:51:31 +0100
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
Subject: Re: [PATCH v4 12/18] mm/hmm: provide generic DMA managing logic
Message-ID: <20241212085131.GF9376@lst.de>
References: <cover.1733398913.git.leon@kernel.org> <cc8a96bf19ca2dd404b55c20ac83fd1a600ad838.1733398913.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc8a96bf19ca2dd404b55c20ac83fd1a600ad838.1733398913.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
> +			   size_t idx, struct pci_p2pdma_map_state *p2pdma_state);

Please avoid the overly long line.


