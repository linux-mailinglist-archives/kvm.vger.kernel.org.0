Return-Path: <kvm+bounces-33568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E98F9EE1C5
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2FFC1887FEC
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD4020E6E7;
	Thu, 12 Dec 2024 08:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJsH8iSL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C667B20CCF7;
	Thu, 12 Dec 2024 08:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733993246; cv=none; b=dWuDIUT0liOHsWSCrZs68V7OjndVE4Sylj8MemmGHddY17LLn3GiE6j0g7w0KCwaJXA/FG56A9jwi6nSOZmnFbY3uoaFqD2IFtVSAuT65SUPDv3s2uD27tpJNTcExA0jKHpN1xWtqOyicRBUN1cnbPQZPOLL5mOXAfuTj0m4TOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733993246; c=relaxed/simple;
	bh=ReOcuWziWEQFCCJQAUurQfV5neoF3l/FqcJT0j3aqF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CXAhVl0zr5rO+EstLnwK/Z0T1S2AytF/XeuXJkYEnu4wJX1u5KxZhQFrZfaj5sBk9u3a2FY/W4XgtcjceFQwULNIz8ETzVlzOs/cgIXaNEkUtzcDOQlZvC8kbjiIHU2Y8wmy3NfOzoUQQHEsOcFi0zhgexKddmXt5WWy5SZQnhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJsH8iSL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD098C4CECE;
	Thu, 12 Dec 2024 08:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733993246;
	bh=ReOcuWziWEQFCCJQAUurQfV5neoF3l/FqcJT0j3aqF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PJsH8iSLtYHP8paIZEP4nJ8nTDKr+RtFEDNTXjVNpPCq42ZMvoqqJvcpOfszhO4+2
	 5q+56DuWg4SGme3LxI0sBsdYw0j/x32/u0c/gWkJfPUk3sl4nRpHe1PXPf31cktN6C
	 ycJ7bYP1Dw9zQAeddLZhw7WIZ2LfeuPVgl8LORlnkJaVEgJdPeDEnlle2whXBTTqRq
	 ayDuf0vzWweUJC34kQDFaAIuOSnAN7cRVoxR7StJNTRNATxu9LxOExmd8ebhsHoM6O
	 UISY6so5QpmKtPUDrtYL4yyt3DEQVTWhA3MIrNyFAdOxmdoEnPoky4HtSJHNdc0edv
	 zEy13QGAmAO8w==
Date: Thu, 12 Dec 2024 10:47:21 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
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
Subject: Re: [PATCH v4 06/18] dma: Provide an interface to allow allocate IOVA
Message-ID: <20241212084721.GH1245331@unreal>
References: <cover.1733398913.git.leon@kernel.org>
 <e562e9a5c5107fae2345150e550e9e850dbe3c0c.1733398913.git.leon@kernel.org>
 <20241212084206.GC9376@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212084206.GC9376@lst.de>

On Thu, Dec 12, 2024 at 09:42:06AM +0100, Christoph Hellwig wrote:
> s/dma/dma-mapping/ in the subject.
> 
> > function call per API call used in datapath as well as a lot of boilerplate
> 
> Please trim commit messages to 73 characters so that they still look good
> in git show output.
> 
> > +bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
> > +		phys_addr_t phys, size_t size)
> > +{
> > +	memset(state, 0, sizeof(*state));
> > +	if (!use_dma_iommu(dev))
> > +		return false;
> > +	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
> > +	    iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
> > +		return false;
> > +	return iommu_dma_iova_alloc(dev, state, phys, size);
> > +}
> 
> Now that dma_iova_try_alloc is the only caller of iommu_dma_iova_alloc,
> maybe merge the two?

Sure, will do

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks a lot.

