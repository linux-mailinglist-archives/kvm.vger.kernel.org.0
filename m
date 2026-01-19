Return-Path: <kvm+bounces-68479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE89D3A0F3
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 09:04:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD0C230088B1
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 08:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99BC433B6D9;
	Mon, 19 Jan 2026 08:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDgV12G7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C256D3370E5;
	Mon, 19 Jan 2026 08:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768809850; cv=none; b=Z18jE2VKlB6pWWisVbCTnBObVia055/d0vbKYD7tDxULRXsqrFF0GPLVUpryXZXYu/eAt/OxOgSx5+uihDzwbiDAqbKYYtAwT5SPVpOkyWoXrb9AeRSLycyYlDx0jG5gEFy6FR0CCCFzt8d29iV56T+t0KBjLyU+rfRDWNhNQXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768809850; c=relaxed/simple;
	bh=HRBEt4RF/jLlwOJnYEYMNWDtdCxSUN5YasBH6jxxKIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6urBFqensCv5nhhtqSnaTzg4da2aWwTnARKRaubWeMJLxz9JhXw7wxAilCwIq1Cm6QUvB+2KYmgtCW8FqKymdYGQD7Cya8Ec8ojf31f4V7qUDdBqEDPZHxqJIypaeb+WbT15hypO9MlE3l/pwPcKSoStQdIyIt+6I/x7MIHH9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDgV12G7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7CAC116C6;
	Mon, 19 Jan 2026 08:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768809850;
	bh=HRBEt4RF/jLlwOJnYEYMNWDtdCxSUN5YasBH6jxxKIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BDgV12G7l5a1sp8yv1MAiOTY/L1jkmyTQZGAh3jpU9VjkGMv9/T3jgHh2lE5LuXTK
	 Q0XiE0/v6mTCIL++UG0OUkE3zwpNkiDWjOwRxhFFIi2wh+H4hSil6YHS5SELsgqCDn
	 WeDdVnUzfPkFP37afqzkaFH2kBs5cZ3OkLmqvQ8WC6xPHnyiZoM6tCbAr4Rpggc7r2
	 +twjbWsZJSrJk1zeM7aeq7DGnmBtEQc4wcipZGljnLygNxxBENIhR7XiKP9tHHgxTC
	 bG2/CJQU8uA+pwflgnBuItu8+MXhQXRs68HQNRr/vZQQeXMAP3G3vwl+sklL/3KSsp
	 iWYoOtPON0K+w==
Date: Mon, 19 Jan 2026 10:04:04 +0200
From: Leon Romanovsky <leon@kernel.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] dma-buf: Document revoke semantics
Message-ID: <20260119080404.GF13201@unreal>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-2-a03bb27c0875@nvidia.com>
 <d41d08e3-6a86-40a4-925c-6a3172670079@nvidia.com>
 <20260119072524.GD13201@unreal>
 <3380a80a-7574-4dbf-87cb-0735fb20cd15@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3380a80a-7574-4dbf-87cb-0735fb20cd15@nvidia.com>

On Sun, Jan 18, 2026 at 11:32:20PM -0800, John Hubbard wrote:
> On 1/18/26 11:25 PM, Leon Romanovsky wrote:
> > On Sun, Jan 18, 2026 at 01:40:11PM -0800, John Hubbard wrote:
> > > On 1/18/26 4:08 AM, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > ...
> > > > +/**
> > > > + * dma_buf_attachment_is_revoke - check if a DMA-buf importer implements
> > > > + * revoke semantics.
> > > > + * @attach: the DMA-buf attachment to check
> > > > + *
> > > > + * Returns true if DMA-buf importer honors revoke semantics, which is
> > > > + * negotiated with the exporter, by making sure that importer implements
> > > > + * .invalidate_mappings() callback and calls to dma_buf_pin() after
> > > > + * DMA-buf attach.
> > > > + */
> > > > +static inline bool
> > > > +dma_buf_attachment_is_revoke(struct dma_buf_attachment *attach)
> > > 
> > > Maybe a slight rename, to dma_buf_attachment_is_revocable()?
> > 
> > I can do that. The issue is that even "dma_buf_attachment_is_revoke"
> > is already too long. :)
> > 
> 
> If you're really pressed for space for some reason,

Mainly aesthetics.

> maybe dma_buf_attach_revocable() ?
> 
> Just trying to hang on to the "revocable" part of the name, as
> I think it's an improvement.

Sure

> 
> thanks,
> -- 
> John Hubbard
> 
> 

