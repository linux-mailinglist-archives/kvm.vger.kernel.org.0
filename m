Return-Path: <kvm+bounces-53613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE80B14A54
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 10:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9211716DAA9
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 08:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34BA285CB7;
	Tue, 29 Jul 2025 08:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtjx7aNo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25B31B0413;
	Tue, 29 Jul 2025 08:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753778733; cv=none; b=ugGKn9mvEliYu9d06okr9SnSCYPtg2Y2MlFJUei+c9ygXEMeEHteYMNNbtc0zimrI+uGbOsysEzH5qBIV1NMf4zmOU0PVLwmaL4lktKKo5c6cXb+bQwGcpbSKwIftxRaFL+4NkgVNIU2fb/LVu1UN6q9R857pwzFGuIAkQjoAYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753778733; c=relaxed/simple;
	bh=jkDZ+7UedrBceUBz8tlmLsJhxKV0IBvkz5SAqWUmQpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eSyLfRt0c8hE1t9B+hV6xNoBKru8QAJYCnrAr1opDkBvipcUWqBHKEq0cj4GJIVhz9KWV0w2dXnO9wolPNlydN0v/g9LAFIL3XnrQMJmge+vYvgmUWwDGQzmgoePW011XyDE7uwt6LIgJsR3TADJGYQrfWTG+oSEgtTMtg6jH1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtjx7aNo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFDBC4CEEF;
	Tue, 29 Jul 2025 08:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753778732;
	bh=jkDZ+7UedrBceUBz8tlmLsJhxKV0IBvkz5SAqWUmQpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mtjx7aNoJVq9DvGD4ORxhlZmNSbDYw4VpIt5G+1PbR6Rre8lAWRCRQDkAz4KTJ/bm
	 BxOO9PzCPjXSeWidky8QMCKZKV2QSFneK6+i7wXzmhFeCMmGPsUu+Uy8H23JTs1bR5
	 SBAPBVl6JzLSEXRQh+LZJX7ikFN585m8EXq0Nqd8+eigGIwYYpnp+T2AW9EPD5Qm2R
	 IQhv3G+CGzUj9jLEaAYGbBzjIi0YUwqQckxK9Csm1y+KGwG6KpqkBl4LHIvFc569cc
	 xXopr3S7OAVJSk8wPuanNo4rGMQEBZyFc3yISHfeC6xtoUaght3ICDAFyg47naXy+n
	 xTgrSU4QNB9rQ==
Date: Tue, 29 Jul 2025 11:45:27 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250729084527.GF402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <20250729075230.GB23823@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729075230.GB23823@lst.de>

On Tue, Jul 29, 2025 at 09:52:30AM +0200, Christoph Hellwig wrote:
> On Thu, Jul 24, 2025 at 11:13:21AM +0300, Leon Romanovsky wrote:
> > On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> > > On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Export the pci_p2pdma_map_type() function to allow external modules
> > > > and subsystems to determine the appropriate mapping type for P2PDMA
> > > > transfers between a provider and target device.
> > > 
> > > External modules have no business doing this.
> > 
> > VFIO PCI code is built as module. There is no way to access PCI p2p code
> > without exporting functions in it.
> 
> We never ever export anything for "external" modules, and you really
> should know that.

It is just a wrong word in commit message. I clearly need it for
vfio-pci module and nothing more.

"Never attribute to malice that which is adequately explained by stupidity." - Hanlon's razor.

Thanks

> 
> 

