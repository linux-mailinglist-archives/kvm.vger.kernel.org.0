Return-Path: <kvm+bounces-60518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D0799BF12C9
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 14:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7C68534C026
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1B431282E;
	Mon, 20 Oct 2025 12:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q8iqZtUQ"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6649824DCF9;
	Mon, 20 Oct 2025 12:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760963351; cv=none; b=G+dJdkASCutITnApcp0lEXN1Rmve0VMa/EyUrA4uy3xGZpz/ywJ6zlcF9xuGR7e5l26fTgVLdYigY+m3L295PDnus82cc0gJ/7038h5v3etbhwq8IT9xnmEcexLF6AdbuquB/IAfBVajvzcBzTDnvFTnomTpCIjeKrD3VmJLjtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760963351; c=relaxed/simple;
	bh=tW9kT30fJjt2lnO+MdOvpRK6pkxyM1YpqNv43k8Uuxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BfvN0eNVW4Il42Z1yMpzJGVCdEfI8PszXsk9sfOhrp/at8wsQ7jPFWbjx7G7vUEm2eerts83vna98u1bwA2XQsKSjMz6+I4R5K8JLoCdFyokJwt4hLEqUHSZcH3yXUMX2tl2FSa2exJfHVukEk3kXJhVvUjUjoXx23Ao1iDke2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q8iqZtUQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D2Kl2pqSvM/DwC65xqTX+wH7gL0SbGwP8PQ2xts6fnA=; b=q8iqZtUQMhHpWIU8trMyOMnPX3
	BZqhJjT2rj4YxZ+9D73G0Z+YCyz4jXlRjVJ4lNjBgB+0FK5YxXT42bnIWmrUvlkPLXRjcdFhbHoBB
	kFsZBpieGZtmo/cO2AmeIBYoggTgIhkLMHFgZ+De0ZWfyJFUbUlozwhj8XDQflAY7e4QFVaPMyrf+
	OfKOJzjfmWZ7MedU2Z5uSI0/WGgtgyyw+nKi7sc0uEUSOgNlGDQnCF0v01aztMT8zBXcZkgZnb9iw
	ZagOlv7l1/BMHvqxSRlvgGCW+ONU1nBe+emsYjFrL6+N7nySloF7g9v/Y48V2dOI6b3xoyUvWc4+l
	c5fu9esQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAp0c-0000000DQ8I-3O4V;
	Mon, 20 Oct 2025 12:29:06 +0000
Date: Mon, 20 Oct 2025 05:29:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 4/9] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <aPYrEroyWVOvAu-5@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <0fa715706e1adf5e26199dc3eaa3b1ff3b14db67.1760368250.git.leon@kernel.org>
 <aPHi2c2BQNB4eqm_@infradead.org>
 <20251017121447.GH3901471@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017121447.GH3901471@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 17, 2025 at 09:14:47AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 16, 2025 at 11:31:53PM -0700, Christoph Hellwig wrote:
> > 
> > Nacked-by: Christoph Hellwig <hch@lst.de>
> > 
> > As explained to you multiple times, pci_p2pdma_map_type is a low-level
> > helper that absolutely MUST be wrapper in proper accessors. 
> 
> You never responded to the discussion:
> 
> https://lore.kernel.org/all/20250727190252.GF7551@nvidia.com/
> 
> What is the plan here? Is the new DMA API unusable by modules? That
> seems a little challenging.

Yes.  These are only intended to be wrapped by subsystems.

> It looks like there is a simple enough solution here. I wanted to
> tackle this after, but maybe it is small enough to do it now.
> 
> dmabuf should gain some helpers like BIO has to manage its map/unmap
> flows, so lets put a start of some helpers in
> drivers/dma/dma-mapping.c (or whatever). dmabuf is a built in so it
> can call the function without exporting it just like block and hmm are
> doing.

Yes, that sounds much better.  And dmabuf in general could use some
deduplicating of their dma mapping patterns (and eventual fixing).


