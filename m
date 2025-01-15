Return-Path: <kvm+bounces-35521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3817BA11E1C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 10:35:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E43B316A399
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 09:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF15F231A49;
	Wed, 15 Jan 2025 09:32:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F011D6188;
	Wed, 15 Jan 2025 09:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736933564; cv=none; b=oyct1JlBg+HlybCSx/4bxdbU30Mykal8pjHv+x8fceAo/Ra4x9MrYtFcxZySoYBRYnWj63ya3Aetk2MYaUPEGWfZu+8vICcvfpOemStLO0kwhpzQAFvdCT1BIiQb0qzDUJtIvg0pr017acrOpMHnKZ+EYDwZSXTWggpjFfrhZkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736933564; c=relaxed/simple;
	bh=jHTr4l+GfYpQ900zoIOPA3z9pFXgvPekOvlSz0Srfj0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iD6F3/D0SmN+w6puJDAvaHJJ+Vrhon0FzSM2LvmTByOcc1KdbK3nzBgDtTWRQUfZZgnWJKn1aMSHN3Km8KMeBrUiB/y5OYkZFIMwxN7Nqf9gn48VUIMCbJ9w+JIPfJ7aIzBcMN2EBTw4lb/UGLAU/B3f3WHCmrQ4qu48nrNHzAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ACB1968B05; Wed, 15 Jan 2025 10:32:34 +0100 (CET)
Date: Wed, 15 Jan 2025 10:32:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leonro@nvidia.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, pbonzini@redhat.com, seanjc@google.com,
	alex.williamson@redhat.com, vivek.kasireddy@intel.com,
	dan.j.williams@intel.com, aik@amd.com, yilun.xu@intel.com,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	lukas@wunner.de, yan.y.zhao@intel.com, leon@kernel.org,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce
 dma_buf_get_pfn_unlocked() kAPI
Message-ID: <20250115093234.GB6805@lst.de>
References: <20250108162227.GT5556@nvidia.com> <Z37HpvHAfB0g9OQ-@phenom.ffwll.local> <Z37QaIDUgiygLh74@yilunxu-OptiPlex-7050> <58e97916-e6fd-41ef-84b4-bbf53ed0e8e4@amd.com> <Z38FCOPE7WPprYhx@yilunxu-OptiPlex-7050> <Z4F2X7Fu-5lprLrk@phenom.ffwll.local> <20250110203838.GL5556@nvidia.com> <Z4Z4NKqVG2Vbv98Q@phenom.ffwll.local> <20250114173103.GE5556@nvidia.com> <Z4d4AaLGrhRa5KLJ@phenom.ffwll.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4d4AaLGrhRa5KLJ@phenom.ffwll.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 15, 2025 at 09:55:29AM +0100, Simona Vetter wrote:
> I think for 90% of exporters pfn would fit, but there's some really funny
> ones where you cannot get a cpu pfn by design. So we need to keep the
> pfn-less interfaces around. But ideally for the pfn-capable exporters we'd
> have helpers/common code that just implements all the other interfaces.

There is no way to have dma address without a PFN in Linux right now.
How would you generate them?  That implies you have an IOMMU that can
generate IOVAs for something that doesn't have a physical address at
all.

Or do you mean some that don't have pages associated with them, and
thus have pfn_valid fail on them?  They still have a PFN, just not
one that is valid to use in most of the Linux MM.

