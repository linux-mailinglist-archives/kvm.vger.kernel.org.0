Return-Path: <kvm+bounces-62363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B288C4195A
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 21:27:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 048B0189D673
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 20:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC48E18E1F;
	Fri,  7 Nov 2025 20:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnHfPvK9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90012F531F;
	Fri,  7 Nov 2025 20:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762547245; cv=none; b=WcOYnqBOuGpaPdElJyMhW07sw+Ub8jq39IYabUAJYP1/h/ddGiukazJlfnblRTHWqQpeeYpJ8kxvRrzl5YJSKrVxE+9PsWhXWlnxJ8n4M53aXnEYkpf3i8alxJ9wr5dbeKbcFQfx2jSOlN6Ki0wc2Wip3LPPEh4Y7uoP6WInGR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762547245; c=relaxed/simple;
	bh=VAySUlKP+gpY13ehfWvqZiKxHmLFx9bZKqh1eqOc7BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XWfQiFDvUuzrfuAtmfw6YeXOu6dccPLdyQbBqmToanqMvIo9XEuSa1l/rA2grUzH31rEHOPaG0iX0ileDYsFak1wL9ebQUdcxBgi6sQjHL4J1G/dTzL13aCG1Ft2u7TLc97I+MxtiS8BvS2vTYYMcVZetl7phVdRQx0hfwv4lsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnHfPvK9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836D6C4CEF5;
	Fri,  7 Nov 2025 20:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762547244;
	bh=VAySUlKP+gpY13ehfWvqZiKxHmLFx9bZKqh1eqOc7BU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GnHfPvK9RlbGueuO2dIzOFloCGUIJO+4STJ9acaeZ4mwoNgCLVysGF3G1CD2dslTO
	 J8xEeZg2TWQROLBRgu9cIRspJbvL0T9YEBkcbbcqYSRUqcnzE6UpSuE7s17MqR38od
	 k1auiNEzsLsrcn/e5bmLAUXdt14ph1onYr5+m4OBZiUnSghRHlS5cz0wreim7qkvti
	 AitNvNVxIXHxoXVVQZB1fuCmNeB+VUFl+qA0fr1ukYsVMffsErSLFPHEZkD3QhPl33
	 mZVBp/M5pmVMtLNk4jfzBFQR0vtiXMXgOHw2XwWQXqRS2kcJr3JwuXFYWK3abcXYgE
	 W34/n88w3YbCg==
Date: Fri, 7 Nov 2025 22:27:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v7 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251107202718.GE15456@unreal>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
 <135df7eb-9291-428b-9c86-d58c2e19e052@infradead.org>
 <20251107160120.GD15456@unreal>
 <0c265a9b-fdc5-40d7-845f-30910f1ac6ea@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c265a9b-fdc5-40d7-845f-30910f1ac6ea@infradead.org>

On Fri, Nov 07, 2025 at 10:58:27AM -0800, Randy Dunlap wrote:
> 	
> 
> On 11/7/25 8:01 AM, Leon Romanovsky wrote:
> > On Thu, Nov 06, 2025 at 10:15:07PM -0800, Randy Dunlap wrote:
> >>
> >>
> >> On 11/6/25 6:16 AM, Leon Romanovsky wrote:
> >>> From: Jason Gunthorpe <jgg@nvidia.com>
> >>>
> >>> Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> >>>
> >>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >>> ---
> >>>  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
> >>>  1 file changed, 72 insertions(+), 23 deletions(-)

<...>

> >>> -The second issue is that to make use of existing interfaces in Linux,
> >>> -memory that is used for P2P transactions needs to be backed by struct
> >>> -pages. However, PCI BARs are not typically cache coherent so there are
> >>> -a few corner case gotchas with these pages so developers need to
> >>> -be careful about what they do with them.
> >>> +For PCIe the routing of TLPs is well defined up until they reach a host bridge
> >>
> >> Define what TLP means?
> > 
> > In PCIe "world", TLP is very well-known and well-defined acronym, which
> > means Transaction Layer Packet.
> 
> It's your choice (or Bjorn's). I'm just reviewing...

Thanks a lot.

