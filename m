Return-Path: <kvm+bounces-68030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7990D1EB85
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 13:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E067E30C26A7
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 12:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04ECB397ACC;
	Wed, 14 Jan 2026 12:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtHY2A2P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7632397AA2;
	Wed, 14 Jan 2026 12:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768393103; cv=none; b=TZPyuo2bjuwUqyrXwvRu76yWaC3K4ANpMK3lRK4WORNlrBbwht9pVg5qtJWhMZB/Fa5Jsiq8fY/MuK8A1ien6HqF884v8ZQWkco9WQQbCYwTVr9qSpvnuL7ZibKhQlcONbfeAxux+yLGuKRi1stGg/0dWi88l24NdFDlHxaJPQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768393103; c=relaxed/simple;
	bh=kphkpO43U3xs8Hu/vDSQXNFGwyRGtpggdrrNZNCgHek=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+tQyeJLbQmjnfEM444gv8oNXUghf3nIl/2Xpjy0ue56Q9sbLj/Yg11rEdQGBj9IBSSB4q4qTWvzefnLiKS/yBdSMjdzB7X9QFYuUIIMGDrZmYH8NJF25PQ4Abh3CUeyHpw0r13ULk854vpXLcDg9p/UJZXxa6Q4w6Rxy3OQJxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtHY2A2P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3159C16AAE;
	Wed, 14 Jan 2026 12:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768393102;
	bh=kphkpO43U3xs8Hu/vDSQXNFGwyRGtpggdrrNZNCgHek=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=VtHY2A2PoHXvJAI3LMSsL+HyLEeHCtSGgKPp6a+dXtGF+CLsybGNKbmvKBUBWia3N
	 WzDOaC8LZwddJrTiwDuAvztJ2Cj6lbzW1QhIsPa2Yj7gshUYGiE+UnyC+TOrtdMm/g
	 w1z2AAwKhhUC2jnihuALXEURtgZdp20+biBdG4c3/EUMr7V2orcFxiAsimeIxtOnKS
	 fLsmHd7cMnVsC8ycZcOC8GfU+l75TBXsIJOO7clPXSbuJAuxBDrzz2EjRR1ts6eoAt
	 WlTQrxGaNTudz8vRy+m7KhkdV2QM6ewUI891wPgHouxLWeGmg1Hv3j8OlX/YjyDn48
	 v0y4wibp7fC8w==
Date: Wed, 14 Jan 2026 14:18:19 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: types: reuse common =?utf-8?Q?phys=5Fv?=
 =?utf-8?Q?ec_type_instead_of_DMABUF_open=E2=80=91coded?= variant
Message-ID: <20260114121819.GB10680@unreal>
References: <20260107-convert-to-pvec-v1-1-6e3ab8079708@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260107-convert-to-pvec-v1-1-6e3ab8079708@nvidia.com>

On Wed, Jan 07, 2026 at 11:14:14AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> After commit fcf463b92a08 ("types: move phys_vec definition to common header"),
> we can use the shared phys_vec type instead of the DMABUF‑specific
> dma_buf_phys_vec, which duplicated the same structure and semantics.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Alex,
> 
> According to diffstat, VFIO is the subsystem with the largest set of changes,
> so it would be great if you could take it through your tree.
> 
> The series is based on the for-7.0/blk-pvec shared branch from Jens:
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=for-7.0/blk-pvec
> 
> Thanks
> ---

Alex,

Could you please move this patch forward? We have the RDMA series [1] that
depends on this rename, and I would like to base it on the shared branch.

[1] https://lore.kernel.org/all/20260108-dmabuf-export-v1-0-6d47d46580d3@nvidia.com/

Thanks

