Return-Path: <kvm+bounces-43755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57DD1A95FC1
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1EDB169340
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 07:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314191EBA07;
	Tue, 22 Apr 2025 07:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWT8zpQs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AFD1AA7BF;
	Tue, 22 Apr 2025 07:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745307865; cv=none; b=cO17jTsCO7oSyOR3r1LNStvi1N5Jk7hq6pOjo5R30LiL787IV+AmwzaADxGIhXBECqNdb4On6GCDRAQRaxAkWOh/AOCmO3yFzMxjEzzYAEeT7mJEPFr747hNBAzQyKPt4XTJvuNKO814Hf6FshZ93AaxNjwtUAeVV1OVbIGzWDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745307865; c=relaxed/simple;
	bh=IkpCJe6iK3e0zmgzu4HOe7msfQx4RRcdkVXQ/zE59nM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghuAmtZq9agKJWtBtrJ4QVSApCurcl/OHo3VzjYE3LoRXfQG064ckH44pn10T8cDP8YjSj/cvjZHRe295IHPKvm1pg8zus3fP2TIEdC+WrLT/eoPByVru5ZdFOTa9VLdEtVC5sYMQZ4bVrMISbblcpHSwltQwnANaZKMvGgpeUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWT8zpQs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1566FC4CEE9;
	Tue, 22 Apr 2025 07:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745307865;
	bh=IkpCJe6iK3e0zmgzu4HOe7msfQx4RRcdkVXQ/zE59nM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UWT8zpQsdCGRmAI20Z+3AYlApwN36Cmhj6cwB5IbEbE/IARvNVu0tWdo4mIoQ7tla
	 jNP/ANqauZjnvPJUDWeJ8zADeaD5f36aQ2RWsAs+HUooXKhuTuo6yu/E07zazBROX6
	 xznqv+BPsU6Ncghg2SNTxJe37syfeyaxQcr9WAF/Foen5407hErRIFOLLYGI7pgvGN
	 CyJIqFICxTnqDUBmc1sGRXnHfviqEbMmgDyblOZ2xNZJFl02u19GY6Nbpt7EgtHA8c
	 CrDGpNwLguDhhfqO7ogHBVTsHjC7XaO9VuKIwQLJaY5iHytN6aNXhIGafF6/jV6lt1
	 HqZxDZY2NWy3Q==
Date: Tue, 22 Apr 2025 10:44:19 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
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
Message-ID: <20250422074419.GD48485@unreal>
References: <cover.1744825142.git.leon@kernel.org>
 <670389227a033bd5b7c5aa55191aac9943244028.1744825142.git.leon@kernel.org>
 <20250422043955.GA28077@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422043955.GA28077@lst.de>

On Tue, Apr 22, 2025 at 06:39:56AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 18, 2025 at 09:47:54AM +0300, Leon Romanovsky wrote:
> > From: Kanchan Joshi <joshi.k@samsung.com>
> > 
> > blk_rq_dma_map API is costly for single-segment requests.
> > Avoid using it and map the bio_vec directly.
> 
> This needs to be folded into the earlier patches or split prep patches
> instead of undoing work done earlier, preferably combined with a bit
> of code movement so that the new nvme_try_setup_prp_simple stays in
> the same place as before and the diff shows it reusing code.
> 
> E.g. change
> 
> "nvme-pci: use a better encoding for small prp pool allocations" to
> already use the flags instead of my boolean, and maybe include 
> abort in the flags instead of using a separate bool so that we
> don't increase hte iod size.
> 
> Slot in a new patch after that that dropping the single SGL segment
> fastpath if we think we don't need that, although if we need the PRP
> one I suspect that one would still be very helpful as well.
> 
> Add a patch if we want the try_ version of, although when keeping
> the optimization for SGLs as well that are will look a bit different.
> 
> I'm happy to give away my patch authorship credits if that helps with
> the folding.

I used this patch separation for two reasons:
1. Your conversion patch is absolutely correct and this patch is an
optimization.
2. Wanted to make sure that I'll post to the ML the code exactly as it
was tested.

I'll try to split/fold this patch now.

Thanks

