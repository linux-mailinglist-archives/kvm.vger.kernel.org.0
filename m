Return-Path: <kvm+bounces-21037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B1ED892819E
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 08:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3994AB231B8
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 06:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDBB142624;
	Fri,  5 Jul 2024 06:00:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC1633C7;
	Fri,  5 Jul 2024 06:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720159216; cv=none; b=WfWfUTocPHqFp7o74lMhfob4r7KrKR8NP5p+ZYnYvNl4m3xRm9AEMOQ7E3Q3QXA1L+3TEqvJ8U4fbkbCN/jwQS1Cuydxy6xHwHph3+5G4u9EdVto8xnT1tbt67X4bQGPMMVTJbNVgm17gHE29LAwTKcIQ4s7ehpKOj9IQd2uqu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720159216; c=relaxed/simple;
	bh=bEiKWiIp+ak8oCw0ZIw72JufsSiXsBq+5pZdmrPzKzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlEW/I1LxegJokM1tdub2RD4lQa0e6zkIbiqMTlb9OdFiwc/PrScA4kLzU5bRQRq2bkN++nvct4V++bYLDbWwR8hYqP8nFQsssK31XfztiEfonaaYl5kpD6yfxMWj//scUR9R6K4EM/H93LfHcusUdB7QNaHoMcHiwqiUU7cXhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC81268AA6; Fri,  5 Jul 2024 08:00:04 +0200 (CEST)
Date: Fri, 5 Jul 2024 08:00:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>, "Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240705060003.GB11885@lst.de>
References: <cover.1719909395.git.leon@kernel.org> <20240703054238.GA25366@lst.de> <20240703105253.GA95824@unreal> <20240703143530.GA30857@lst.de> <20240703155114.GB95824@unreal> <20240704074855.GA26913@lst.de> <20240704131839.GD95824@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240704131839.GD95824@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 04, 2024 at 04:18:39PM +0300, Leon Romanovsky wrote:
> > 2) The amount of seemingly unrelated global headers pulled into other
> > global headers.  Some of this might just be sloppiness, e.g. I can't
> > see why dma-mapping.h would actually need iommu.h to start with,
> > but pci.h in dma-map-ops.h is a no-go.
> 
> pci.h was pulled because I needed to call to pci_p2pdma_map_type()
> in dma_can_use_iova().

No, that's not the reason.  The reason is actually that whole
dev_use_swiotlb mess which shouldn't exist in this form.

