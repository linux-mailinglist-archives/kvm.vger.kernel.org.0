Return-Path: <kvm+bounces-53349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D2FF2B102EC
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 10:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F3637BADBA
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 08:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 439212741B3;
	Thu, 24 Jul 2025 08:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VOsjIIeI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41938223327;
	Thu, 24 Jul 2025 08:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344472; cv=none; b=G1j0/t5jEowrosZWfMfyRzUS5oRwDNGVkupyS6qgq5dWhmQqSlZxMEO/0CKG0hn30RNND34dYV2AUtYGtNLominL6xx8257NEwjtsScxFT8ErdYTPzDE3yAtkaBPFHFsqlMOdLghNmTHI2cuEvAJilvSjFgr3SuxKQpbig45mBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344472; c=relaxed/simple;
	bh=1SX+zcqB99cjjB9BCfDjf9tPWG4xWING89rNVeEpf+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEc2CXreFimCiai0AUKj72A8kloPuMbZIbExRzOikPmC3lCt2EWuyXHVzsnPS++QQKovGCmRUeKqfLXHRU3Lx2Q47nYbwwdqRKXpBUprq/ZUv66bt8Re2WDvU3P3YQQ3ftlbbXS/qt4foA4Y9F6BMtASAjxoC4Zt+nwoQKK9Smw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VOsjIIeI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0172DC4CEF1;
	Thu, 24 Jul 2025 08:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753344471;
	bh=1SX+zcqB99cjjB9BCfDjf9tPWG4xWING89rNVeEpf+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VOsjIIeIH9Rm+A+TaQ0V7RH51KmQgYil3OHypDB1K75Vw6Q633ZWqyufs6mpXmjgy
	 8LsZTfLRMqu8Q3aUECPmaK6fz118qRgZxsQo52X8A22JJasuxKIhK8eiezk8hp9SAc
	 jHnyZT944fThfEGK02iapsKBQc2GMyceVPsI5Ej6hFz/7GB9hjU2rY3MhXnDmg0Af3
	 EmVL68MOlWu5/WtcynPwwwXn3gv5bFT1ONKBqH4E10CypSHNangIwHPWApThEuqWtj
	 gZXy/mzxhxENu2F+hWSPwgeJkrW8aD7ChboSZ9kiIUCIRjgkp5GFEhH5TMyS7SGjaO
	 J/E2lr1sMS9Pg==
Date: Thu, 24 Jul 2025 11:07:47 +0300
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
Subject: Re: [PATCH 02/10] PCI/P2PDMA: Introduce p2pdma_provider structure
 for cleaner abstraction
Message-ID: <20250724080747.GS402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
 <20250724075145.GB30590@lst.de>
 <20250724075533.GR402218@unreal>
 <20250724075922.GD30590@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724075922.GD30590@lst.de>

On Thu, Jul 24, 2025 at 09:59:22AM +0200, Christoph Hellwig wrote:
> On Thu, Jul 24, 2025 at 10:55:33AM +0300, Leon Romanovsky wrote:
> > Please, see last patch in the series https://lore.kernel.org/all/aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com
> > It gives me a way to call p2p code with stable pointer for whole BAR.
> > 
> 
> That simply can't work.  So I guess you're trying to do the same stupid
> things shut down before again?  I might as well not waste my time
> reviewing this.

I'm not aware of anything that is not acceptable in this series.

This series focused on replacing dma_map_resource() call from v3
https://lore.kernel.org/all/20250307052248.405803-4-vivek.kasireddy@intel.com/
to proper API.

   92         if (!state) { 
   93                 addr = pci_p2pdma_bus_addr_map(provider, phys_vec->paddr); 
   94         } else if (dma_use_iova(state)) {                                 
   95                 ret = dma_iova_link(attachment->dev, state, phys_vec->paddr, 0,
   96                                     phys_vec->len, dir, DMA_ATTR_SKIP_CPU_SYNC); 
   97                 if (ret)                                                        
   98                         goto err_free_table;                                   
   99                                                                               
  100                 ret = dma_iova_sync(attachment->dev, state, 0, phys_vec->len);
  101                 if (ret)                                                     
  102                         goto err_unmap_dma;                                 
  103                                                                            
  104                 addr = state->addr;                                       
  105         } else {                                                         
  106                 addr = dma_map_phys(attachment->dev, phys_vec->paddr,   
  107                                     phys_vec->len, dir, DMA_ATTR_SKIP_CPU_SYNC);
  108                 ret = dma_mapping_error(attachment->dev, addr);                
  109                 if (ret)                                                      
  110                         goto err_free_table;                                 
  111         }            

Thanks

> 
> 

