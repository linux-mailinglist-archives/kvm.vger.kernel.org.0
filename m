Return-Path: <kvm+bounces-30160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB999B7782
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:29:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79867B2573C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3782B195F17;
	Thu, 31 Oct 2024 09:29:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF73188599;
	Thu, 31 Oct 2024 09:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730366959; cv=none; b=q7ofCePxn49QDRdYuKH1QDHPIJ3N/p4atW6V+HmyY1FyThlt+xJ3X+lTkccs6AYPQaQjKR/OiZBDvUBsFKw3LwXAauomwk9yZm8bMQKAyd5z9DmC3td3CGyPqTh/dDsgkqGrGOnnCtKcj90cIDCtmVcVoOXkPOCHa/vvD56D1Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730366959; c=relaxed/simple;
	bh=dZHxgnrIkdMO2LldTpzDLOjBpT2bck5vMllRHMoj9aE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGdN975s6lLsgRr5pj2lIBInFqIUPl+Sw1HYSnyOX0mGGJ/Eql8Ke/Y4qnY4BYAX0r8PSX98vmZqcXHBWbWxeSslzIybmpaf03ELJngZLWuDU6Xj/R4fV46MAgcU28uicyGKaMYWGHRNSp1ZcftJloPhJ1DHze1vjIoS6uQOWtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0872F68B05; Thu, 31 Oct 2024 10:21:14 +0100 (CET)
Date: Thu, 31 Oct 2024 10:21:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
Message-ID: <20241031092113.GA1791@lst.de>
References: <cover.1730298502.git.leon@kernel.org> <3144b6e7-5c80-46d2-8ddc-a71af3c23072@kernel.dk> <20241031083450.GA30625@lst.de> <20241031090530.GC7473@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031090530.GC7473@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 31, 2024 at 11:05:30AM +0200, Leon Romanovsky wrote:
> This series is a subset of the series you tested and doesn't include the
> block layer changes which most likely were the cause of the performance
> regression.
> 
> This is why I separated the block layer changes from the rest of the series
> and marked them as RFC.
> 
> The current patch set is viable for HMM and VFIO. Can you please retest
> only this series and leave the block layer changes for later till Christoph
> finds the answer for the performance regression?

As the subset doesn't touch block code or code called by block I don't
think we need Jens to benchmark it, unless he really wants to.


