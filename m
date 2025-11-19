Return-Path: <kvm+bounces-63738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 749B6C70424
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 17:56:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B74CD3C3EA8
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 16:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E57935FF76;
	Wed, 19 Nov 2025 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mafG8ZOF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530EE366DAF;
	Wed, 19 Nov 2025 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763570012; cv=none; b=U51JieKwrHARvUpu+V6rWx7tBOASc8FMgAWfzbfKWCIvx3z8QEpGBDCN9PyZS0W3jWsOtV8bYkskPRvbsb3MtLMve5VpK/XcO1ibYF+qqH5cURaHVNt43rqCO9K/O0XlHwunFa6xL/Qso1J2nZlz0oeKQzInhZuH+VzFaoE3Gxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763570012; c=relaxed/simple;
	bh=SQB43V1lcm01gCfrVBWXeZWkfWYzDLNLnZu9KWeWJcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWVcMbYRgRQ0OxvJt5Q2L1zzYl59np6SjBhwVxDw4WjuLxelLFVtRQzu3BbLVx0QMpzBE5Jc/EFv6pZgX+iBz1EzJhZqFRn6l+x4dAck7hnLLnG3J0Um6sX6K/qia/WLgO0SiV6gevGzh6cfZLjbc2PpuMeiTKWSqO6xFAIFIgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mafG8ZOF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D05C116B1;
	Wed, 19 Nov 2025 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763570012;
	bh=SQB43V1lcm01gCfrVBWXeZWkfWYzDLNLnZu9KWeWJcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mafG8ZOF8WzHpM0Ap0HV10HNQ+V26iii16RmNEh8xlVGt/3Fyif1MM/ooh0K/pfIz
	 szK/RWtsKgEJUAwJCF4Ei2amklh14ZMnM9irxppUQrCUJkvt/EZVFJcbPn28NcqEGY
	 H5mQcoOTZFTUtioKEvXhb//Hd+eC/e25r6Py2bHgQa/vmQ3b9ezpxZIBWcXV9ncmwt
	 7e2asxChIzWsMtQIBzyz1HCL0UngdmumU3R+J6sfLJMWs0oS7ZF4iSIBsph8VRgCK0
	 +t4iS375piSkus/kTsSOX82JCK0IrwbeeJvL9xKC8TF2BvGIttU+8sQ9kfioC2gTlg
	 KCxDuQf1gZvsw==
Date: Wed, 19 Nov 2025 18:33:26 +0200
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
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251119163326.GL18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119134245.GD18335@unreal>
 <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>
 <20251119145007.GJ18335@unreal>
 <26d7ecab-33ed-4aab-82d5-954b0d1d1718@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26d7ecab-33ed-4aab-82d5-954b0d1d1718@amd.com>

On Wed, Nov 19, 2025 at 03:53:30PM +0100, Christian König wrote:

<...>

> >>>>> +struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
> >>>>
> >>>> That is clearly not a good name for this function. We already have overloaded the term *mapping* with something completely different.
> >>>
> >>> This function performs DMA mapping, so what name do you suggest instead of dma_buf_map()?
> >>
> >> Something like dma_buf_phys_vec_to_sg_table(). I'm not good at naming either.
> > 
> > Can I call it simply dma_buf_mapping() as I plan to put that function in dma_buf_mapping.c
> > file per-your request.
> 
> No, just completely drop the term "mapping" here. This is about phys_vector to sg_table conversion and nothing else.

In order to progress, I renamed these functions to be
dma_buf_phys_vec_to_sgt() and dma_buf_free_sgt(), and put everything in dma_buf_mapping.c file.

Thanks

