Return-Path: <kvm+bounces-29962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1B39B4FC2
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 17:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B87E0B22297
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 16:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822031DB375;
	Tue, 29 Oct 2024 16:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyHYnWW1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B3F1D7989;
	Tue, 29 Oct 2024 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730220528; cv=none; b=MHRqg2uEpqIbl4p2Wv6rZngMb/39o5fNLK5uBOlvFPvoe5GgOb6Lku17miW+JL1492Gu8MA3/ONZRh/CSnuPJubXvScOBKe6K9hYvmTXpAYU4bVAn5q+3xRFbBEdbC4OqBKhPoG2jmvTh5zV8CrmctqA/XWk/OP6JHFKpezvg9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730220528; c=relaxed/simple;
	bh=UHUCi4vpc9NsIGRx2NWApkLxNhg8anztoSGFsyKXm3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGsDdLX4nLb/kOKikq2yJcuI2As+8u57c+YsrpN/FsVoDNvHJTmTiA3l/y84OMf9DhvRfrs5oS0EAid1NSQUPLnayDdbalOp7GfT2vqaDIu51hwbHNC5W2LjHgmCCzcWXyNY1C86wa182Xlt/m21v0wtQxsETNbWC7FkF5UAe8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyHYnWW1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB9EC4CEE7;
	Tue, 29 Oct 2024 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730220528;
	bh=UHUCi4vpc9NsIGRx2NWApkLxNhg8anztoSGFsyKXm3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OyHYnWW1pjm6Aj8Kkcd/dadQl9cdDWv80O4cGEbK301k/HKDeMTCHwvXC+cwoVNue
	 We6HnodpvPrTnrRZK2G3lOYDParD9rcxcFpCDPsScBhny2/aGDhYpHfyMfzYn2V5i2
	 8vIqKiSqrbDs8K9LAxdas5kt/hXTScdnJlrcx6hI16sgOa8vSRzptDpr4ytKHcn6JC
	 2K+J092fr8qm+NMl8fhV653EwxDOStqEih+f09slsAjOAG/FjJ16ZGRrUEa75cPx7F
	 SRKR/Kt8/jRcBo0e6P4sI47wJZ5jEmWK0WEOf/k+ExW9WR6qRlyhSZXoppq6fNCTC3
	 iAO+F3XpPWYrQ==
Date: Tue, 29 Oct 2024 18:48:43 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
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
Subject: Re: [PATCH 01/18] PCI/P2PDMA: refactor the p2pdma mapping helpers
Message-ID: <20241029164843.GO1615717@unreal>
References: <a4d93ca45f7ad09105a1cf347e6b6d6b6fb7e303.1730037276.git.leon@kernel.org>
 <20241028205902.GA1114413@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028205902.GA1114413@bhelgaas>

On Mon, Oct 28, 2024 at 03:59:02PM -0500, Bjorn Helgaas wrote:
> Prefer subject capitalization in drivers/pci:
> 
>   PCI/P2PDMA: Refactor ...
> 
> On Sun, Oct 27, 2024 at 04:21:01PM +0200, Leon Romanovsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > The current scheme with a single helper to determine the P2P status
> > and map a scatterlist segment force users to always use the map_sg
> > helper to DMA map, which we're trying to get away from because they
> > are very cache inefficient.
> > ...
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> A couple minor nits below.

I'll fix, thanks

