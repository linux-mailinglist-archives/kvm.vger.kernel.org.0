Return-Path: <kvm+bounces-63827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 58D7DC7361B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 11:07:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0DCBA346340
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 10:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA80293B75;
	Thu, 20 Nov 2025 10:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+hY+OMB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E582882D7;
	Thu, 20 Nov 2025 10:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763632998; cv=none; b=UHB8sytnn18+I0cYSpYryeP5F9EUBSfhyaIwet1aoc5oTZpcfsJS3vdP5ANYHlqCFJkJ7YJY/g6j2obUkbIXGfcJCWTq6gyE9p2vEQVy04w2vEUHmOnWNTuExqzKOv9R7xjElwa2xGI1kq29zrYldIWATV/K1N7ocXXiqAVceLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763632998; c=relaxed/simple;
	bh=nN18XypDEK4Xp2Uwyzn2CyI2CYU2LLHnqRbvcxN/MOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkZKsxbjmzwFFsnCamzc3TQTNZcIWHIod9adUL8u3eAAIPMVgvjhbnuoBzAjwDVwJdaVwsgNT3AHq5+tPZab6YHJ9fRsLwXo2dQ4g48+vI55UCHla69HfynkA5o/DKyBUTv0OxP1Us5yF5Oft+fm8gtiiTBqiyNBqLQ6ffXguNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+hY+OMB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB98C4CEF1;
	Thu, 20 Nov 2025 10:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763632997;
	bh=nN18XypDEK4Xp2Uwyzn2CyI2CYU2LLHnqRbvcxN/MOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G+hY+OMBFwxjvW/rHz3D9U5weCHQooOgK8MHfyA01kVMMV+A3AkZ438UHthcqeE9M
	 /W8sa0sQXGzt/hW+GZKYO9qCVhuYOSwzWyvXmoHLLLXKCC71ccQychOWgBEc9/N4WR
	 B4hzYRwhJYWOy/XMG9Ee6J/fv3T7TqpQvxDZRmSFypghKchjL3PUHlMTtC4LoafHEg
	 8gc9esBn2NM5CJ6c+XmHXAeq018QsYls0PqZAWftuB8E+D1BJ3lzNPMBBHus01EitA
	 yHaQJeOXigJlJYANOS70kHWQFawRWzvBrKbuTNC8S71WbHRGEk1IfIpBp5grsDiqGo
	 BP3n3eU4f4VgA==
Date: Thu, 20 Nov 2025 12:03:12 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
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
	linux-hardening@vger.kernel.org, Nicolin Chen <nicolinc@nvidia.com>,
	Alex Mastro <amastro@fb.com>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v9 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <20251120100312.GV18335@unreal>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-6-d7f71607f371@nvidia.com>
 <57b8876f-1399-4e4d-a44b-1177787aa17d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57b8876f-1399-4e4d-a44b-1177787aa17d@amd.com>

On Thu, Nov 20, 2025 at 10:33:36AM +0100, Christian König wrote:
> On 11/20/25 10:28, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Add dma_buf_phys_vec_to_sgt() and dma_buf_free_sgt() helpers to convert
> > an array of MMIO physical address ranges into scatter-gather tables with
> > proper DMA mapping.

<...>

> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Alex Mastro <amastro@fb.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Could be that this will backfire at some point, but I think we will never know without trying.
> 
> Acked-by: Christian König <christian.koenig@amd.com>

Thanks a lot.

