Return-Path: <kvm+bounces-44085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB419A9A43A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 862F11B63394
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E423623D2AB;
	Thu, 24 Apr 2025 07:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WoDzuOVN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A9F23C8C9;
	Thu, 24 Apr 2025 07:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745479359; cv=none; b=AhlMXb+Y0Bt4+AfrJbIfIlWnI45LNaLKWG5S0FhjDDx97EIKwXib03SW5NTx/xrwDbHtrov7jdLnEM4JADEp0GMIAQKr7bBxrA/iIW+WrYuyARb3p5PvO0kTARUVDR81nrl4XfCz8sz+6uzq3x3lmd3nbIzmxBLBFtuP25RTGsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745479359; c=relaxed/simple;
	bh=pkWE6sGGOL/lS7z2PofBZdgR94MWvVoyVMrCsfmGWMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tn371pCa+uNXeOei2I1d05TNxg5oHFLyoQ5SrTy8/cY+RLEAPZq1UlBmf8cGR1tYt5I/HhzZR+poBla+4zLOu2XB1uMkdFSAxx6Srus4X0wzwNcLHkxShgt0q7U4uPUjIqSy1VzV1skajGcdVBYXr3HJ6tikSsMWn+RZ2DYI+ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WoDzuOVN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D07BC4CEEC;
	Thu, 24 Apr 2025 07:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745479358;
	bh=pkWE6sGGOL/lS7z2PofBZdgR94MWvVoyVMrCsfmGWMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WoDzuOVNM5Th9/6MPQtwK/rt0LHybLoQmVej7xUL7pi/+grRTLzz3YO22zNR2UUpv
	 L0Bn1mEP+wHrMmXMnVi+xdnrx+pb56/i+NwcME8rl7+krJ8X06sAa4KiT0AJGFeGhO
	 zvG4gVJvRX6aT9o2FnS7IA1RJT+icqhZ42NzdhXqk+vXT48zoVpYbdHXg/hsIbpVVW
	 mb5tmX1IUQBMyuSJU93RCrakk1F6JJ/M7rFzDCbJQt3wrlrbWfV338F+OcjU+P+e3j
	 bzNLphJk97vP+hv977iF8cPx4g8hsnK1XXRSn4AkJbQ0zy97kvPiSWubQUhNoqskr/
	 o45akYSgJ5EsQ==
Date: Thu, 24 Apr 2025 10:22:34 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 11/24] mm/hmm: provide generic DMA managing logic
Message-ID: <20250424072234.GN48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <3abc42885831f841dd5dfe78d7c4e56c620670ea.1745394536.git.leon@kernel.org>
 <20250423172856.GM1213339@ziepe.ca>
 <20250424071545.GM48485@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424071545.GM48485@unreal>

On Thu, Apr 24, 2025 at 10:15:45AM +0300, Leon Romanovsky wrote:
> On Wed, Apr 23, 2025 at 02:28:56PM -0300, Jason Gunthorpe wrote:
> > On Wed, Apr 23, 2025 at 11:13:02AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>

<...>

> > > +bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx)
> > > +{
> > > +	struct dma_iova_state *state = &map->state;
> > > +	dma_addr_t *dma_addrs = map->dma_list;
> > > +	unsigned long *pfns = map->pfn_list;
> > > +	unsigned long attrs = 0;
> > > +
> > > +#define HMM_PFN_VALID_DMA (HMM_PFN_VALID | HMM_PFN_DMA_MAPPED)
> > > +	if ((pfns[idx] & HMM_PFN_VALID_DMA) != HMM_PFN_VALID_DMA)
> > > +		return false;
> > > +#undef HMM_PFN_VALID_DMA
> > 
> > If a v10 comes I'd put this in a const function level variable:
> > 
> >           const unsigned int HMM_PFN_VALID_DMA = HMM_PFN_VALID | HMM_PFN_DMA_MAPPED;

diff --git a/mm/hmm.c b/mm/hmm.c
index c0bee5aa00fc..a8bf097677f3 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -807,15 +807,14 @@ EXPORT_SYMBOL_GPL(hmm_dma_map_pfn);
  */
 bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx)
 {
+       const unsigned long valid_dma = HMM_PFN_VALID | HMM_PFN_DMA_MAPPED;
        struct dma_iova_state *state = &map->state;
        dma_addr_t *dma_addrs = map->dma_list;
        unsigned long *pfns = map->pfn_list;
        unsigned long attrs = 0;
 
-#define HMM_PFN_VALID_DMA (HMM_PFN_VALID | HMM_PFN_DMA_MAPPED)
-       if ((pfns[idx] & HMM_PFN_VALID_DMA) != HMM_PFN_VALID_DMA)
+       if ((pfns[idx] & valid_dma) != valid_dma)
                return false;
-#undef HMM_PFN_VALID_DMA
 
        if (pfns[idx] & HMM_PFN_P2PDMA_BUS)
                ; /* no need to unmap bus address P2P mappings */

