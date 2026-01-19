Return-Path: <kvm+bounces-68475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F28D39FAD
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 08:26:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FE293015A83
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 07:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E6862F28EF;
	Mon, 19 Jan 2026 07:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOYMTqRr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA362ECEBC;
	Mon, 19 Jan 2026 07:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768807530; cv=none; b=OuHXytQ86L/KH+3Dtv9dOoCPaUc1F31ST1v1DN96UKjhZCDEdcdO2NmHOdTp++bAa5p1clTbHFMBDayfSeIscnx5fJAVvgxEUs9XTtAOTN1BJA+I2a4rblz0Nu7NrT2pe55uElkSuKA491TcFlsl0fBLe1Cc0WS0d7p/MdRKpmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768807530; c=relaxed/simple;
	bh=Sy0oZJNxE3l4wUF1ShDJYtcIYRfebTgMszB/pVPpbG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOfW4tFtiriY1ZiK2/bGyt3daSlU1Vl+ivPyCDUAAC3B8rKr2UNC7L7I8QUdEe0Kzasl8kYCEAcZdSjblRyC/cawum2pYeVyTgAHCIPaqheXtr1k6heaUrWkS52S7O5pRUU5+b8Mx5Q+M9fA/YenmwYeuNhrrcQj8CFj6txmS/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOYMTqRr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F96C116C6;
	Mon, 19 Jan 2026 07:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768807529;
	bh=Sy0oZJNxE3l4wUF1ShDJYtcIYRfebTgMszB/pVPpbG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OOYMTqRrGNEs2jAmSYlM686r10g9BCiY0dH1nHfSd9wBLODRb8DM164wJPnvPjUZJ
	 icgeXWdtQ7Oia1ErMzqcQuhf52/tfn7nc5Db0Pgu4mF4oKXHNz7EAU6VPQm5fLTGmH
	 dpWD45Ghuyew+XIW6NcIv4QphDm7ZCu0u2N2glr45RlAuFFKTsiYSKNgep1eD0k+ze
	 DGHBEAu/8vNU8SRkbYapnqC57ld4+aZRHd6cB3kj5nGczjtxNRKaQQAT7M5FarOcTS
	 +AznVeitmh0vPl0biNbAXazx0fJsZPdtNy+ZzqhsViFUZFhUJS6vri3NJErSen8Aar
	 zIN3x/bF6bUXQ==
Date: Mon, 19 Jan 2026 09:25:24 +0200
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
Message-ID: <20260119072524.GD13201@unreal>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-2-a03bb27c0875@nvidia.com>
 <d41d08e3-6a86-40a4-925c-6a3172670079@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d41d08e3-6a86-40a4-925c-6a3172670079@nvidia.com>

On Sun, Jan 18, 2026 at 01:40:11PM -0800, John Hubbard wrote:
> On 1/18/26 4:08 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> ...
> > +/**
> > + * dma_buf_attachment_is_revoke - check if a DMA-buf importer implements
> > + * revoke semantics.
> > + * @attach: the DMA-buf attachment to check
> > + *
> > + * Returns true if DMA-buf importer honors revoke semantics, which is
> > + * negotiated with the exporter, by making sure that importer implements
> > + * .invalidate_mappings() callback and calls to dma_buf_pin() after
> > + * DMA-buf attach.
> > + */
> > +static inline bool
> > +dma_buf_attachment_is_revoke(struct dma_buf_attachment *attach)
> 
> Maybe a slight rename, to dma_buf_attachment_is_revocable()?

I can do that. The issue is that even "dma_buf_attachment_is_revoke"
is already too long. :)

Thanks

> 
> 
> thanks,
> -- 
> John Hubbard
> 

