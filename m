Return-Path: <kvm+bounces-35616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54DBBA132A4
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 06:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A72367A3D07
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 05:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FC3158558;
	Thu, 16 Jan 2025 05:33:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831C1374C4;
	Thu, 16 Jan 2025 05:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737005635; cv=none; b=t7VE5OKwoP89ksTx78oaAWeqZ8iB3rPVCKXLmAh2xDO6B5HjJ3Gh/aVm/vHsxJCm9re2Q4FUlSTV/tHoXXrENE1po6QfXaw0tbsgVLXREZtK4GC14imoisKtRK5kjC8T9ZQDUBFiYhduL+w1tz8z9m7yylCj1vG/QEikOmhTqTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737005635; c=relaxed/simple;
	bh=2Iwp2PEnAp1fiLDpaaX32VlLKlbYiqcty8V5MO3wh/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGy6+GOHbz3OaeCvgPugzylNbW4XYuPFA0hFD3EkHqR5nTOezVZbE4t8Kn7coj+POM40kpNwIv/d0MdZrAegcbGR4NKVKepbOAXPYdW69JFhp8FqINaQX/Aq3cVNz6od2dlJACmLkDKkiZ/+9NjIgu3MBhro95VOL1Zuz5GMp4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5BA3E68BEB; Thu, 16 Jan 2025 06:33:48 +0100 (CET)
Date: Thu, 16 Jan 2025 06:33:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Xu Yilun <yilun.xu@linux.intel.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce
 dma_buf_get_pfn_unlocked() kAPI
Message-ID: <20250116053348.GA24046@lst.de>
References: <Z37QaIDUgiygLh74@yilunxu-OptiPlex-7050> <58e97916-e6fd-41ef-84b4-bbf53ed0e8e4@amd.com> <Z38FCOPE7WPprYhx@yilunxu-OptiPlex-7050> <Z4F2X7Fu-5lprLrk@phenom.ffwll.local> <20250110203838.GL5556@nvidia.com> <Z4Z4NKqVG2Vbv98Q@phenom.ffwll.local> <20250114173103.GE5556@nvidia.com> <Z4d4AaLGrhRa5KLJ@phenom.ffwll.local> <20250115093234.GB6805@lst.de> <20250115133419.GN5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115133419.GN5556@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 15, 2025 at 09:34:19AM -0400, Jason Gunthorpe wrote:
> > Or do you mean some that don't have pages associated with them, and
> > thus have pfn_valid fail on them?  They still have a PFN, just not
> > one that is valid to use in most of the Linux MM.
> 
> He is talking about private interconnect hidden inside clusters of
> devices.
> 
> Ie the system may have many GPUs and those GPUs have their own private
> interconnect between them. It is not PCI, and packets don't transit
> through the CPU SOC at all, so the IOMMU is not involved.
> 
> DMA can happen on that private interconnect, but from a Linux
> perspective it is not DMA API DMA, and the addresses used to describe
> it are not part of the CPU address space. The initiating device will
> have a way to choose which path the DMA goes through when setting up
> the DMA.

So how is this in any way relevant to dma_buf which operates on
a dma_addr_t right now and thus by definition can't be used for
these?


