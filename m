Return-Path: <kvm+bounces-31875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2374A9C9039
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:55:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18E58B30828
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AED18628F;
	Thu, 14 Nov 2024 16:36:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16861166F25;
	Thu, 14 Nov 2024 16:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731602189; cv=none; b=BLdVIDr3vsW5vyxJVJMOgJKfiXu04oPeiCbMVLgeYRpjfjDVv5QD95uGse4rnC+mG+2f4DP9iKH0to4dy2UGzQgFqTs2PJXIP6NaqE6xtmPTTEtdvf2z6INtGSJc6hA7jdt67CZAVB+4yTAwDo2rsK9kVHurmI71OlHY/JWzlmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731602189; c=relaxed/simple;
	bh=9CnMQTj/kx8j380p/9NSdXuITEG2atOw34vAty/glmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vt3f9L/oC7wuGidpebDtDDo+LCgOdrmQOSgxvbQZdL/2B2UgSX2E02enk7rm5lwn3fTnrwmJZCPSxgIz2RosxKnhmlESAfX1Fwmz+DZNMjw8lNGM29ER3z6Sw73KdNLA6yQtrzQqpGTDE7Vu20kSF3aTfvZuNfDm2zoWkMtBB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A019B68C7B; Thu, 14 Nov 2024 17:36:22 +0100 (CET)
Date: Thu, 14 Nov 2024 17:36:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, ill Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
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
Subject: Re: [PATCH v3 00/17] Provide a new two step DMA mapping API
Message-ID: <20241114163622.GA3121@lst.de>
References: <cover.1731244445.git.leon@kernel.org> <20241112072040.GG71181@unreal> <20241114133011.GA606631@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114133011.GA606631@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 14, 2024 at 03:30:11PM +0200, Leon Romanovsky wrote:
> > All technical concerns were handled and this series is ready to be merged.
> > 
> > Robin, can you please Ack the dma-iommu patches?
> 
> I don't see any response, so my assumption is that this series is ready
> to be merged. Let's do it this cycle and save from us the burden of
> having dependencies between subsystems.

Slow down, please.  Nothing of this complexity is going to get merged
half a week before a release.

No changs to dma-iommu.c are going to get merged without an explicit
ACK from Robin, and while there is no 100% for the core dma-mapping
code I will also not merge anything that hasn't been resolved with
my most trusted reviewer first, not even code I wrote myself.


