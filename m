Return-Path: <kvm+bounces-68486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 850A6D3A262
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 10:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 458B33046F86
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 09:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4E7352F9B;
	Mon, 19 Jan 2026 09:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e33bUuuF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E772268690;
	Mon, 19 Jan 2026 09:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768813486; cv=none; b=dyyOpKoY0D0GxBc+ubDj78Ck7iGEUgscMyaKbo3XEfsNSJhpVo8HHZeY8UpRgsG8x2XboFM67AZ4+A+xhxc3wfGA8pHUzNwj2j/bxy7LczL6w2CjIXmgcNcdkwlxyUpSW4rHJjOM+t6qgJIqfmIpU9guOFHLWcdNfxOLmMuu56U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768813486; c=relaxed/simple;
	bh=9ibwmwir6DNuwcFVFVRMrnxNeKv3ejBMBmArbCsPm6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulNqcjZifh7FE+kgl4iklgsazgLEbHAgKrccydKsAp5ffL1n0QznoNIRbnLkqV2AuuQbNfXt7wTz/a1CUDKxbygQ4Ef6G3l7VxTdyS7lhWom046aX56xUW/D92XZ7ZGgzZwqo67ir5ZtpeINQuTCBVfwr5QieFvRI0doILUyrEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e33bUuuF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B57CC116C6;
	Mon, 19 Jan 2026 09:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768813486;
	bh=9ibwmwir6DNuwcFVFVRMrnxNeKv3ejBMBmArbCsPm6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e33bUuuFuYAfNmaAVBINTTMiHDitg3Ewo284Wv30/72Z5sl3bIG03XiqzmmtksV2N
	 E9d2cJoHjdjKYaYooTlSPB4iJpWVL91L1AN491690/uRHfcmT6wUBbopZdfCbx77Px
	 Q3HC1qDJGA9Pt3HYbxuqrUGdEozMHTi5LrmTjFyJYKE+R+M0iAaeaStvmIivkeGtTZ
	 mxhJNSrhHrd2zaHDTg7GSf/GrHIQaeet8ghZgUq43q6WrWChlkPf5q6E/9m4Skchfc
	 5l1Di/szMWkD2gAlw1okBT15wo+lo6dJX8Dgm6WcIx/IrIDWLVWHnzHUEXQ9299Wj5
	 PA/zo+uxfkTlQ==
Date: Mon, 19 Jan 2026 11:04:40 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
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
Message-ID: <20260119090440.GG13201@unreal>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-2-a03bb27c0875@nvidia.com>
 <8bc75706c18c410f9564805c487907aba0aab627.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bc75706c18c410f9564805c487907aba0aab627.camel@linux.intel.com>

On Sun, Jan 18, 2026 at 03:29:02PM +0100, Thomas Hellström wrote:
> On Sun, 2026-01-18 at 14:08 +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Document a DMA-buf revoke mechanism that allows an exporter to
> > explicitly
> > invalidate ("kill") a shared buffer after it has been handed out to
> > importers. Once revoked, all further CPU and device access is
> > blocked, and
> > importers consistently observe failure.
> 
> See previous comment WRT this.
> 
> > 
> > This requires both importers and exporters to honor the revoke
> > contract.
> > 
> > For importers, this means implementing .invalidate_mappings() and
> > calling
> > dma_buf_pin() after the DMA‑buf is attached to verify the exporter’s
> > support
> > for revocation.
> 
> Why would the importer want to verify the exporter's support for
> revocation? If the exporter doesn't support it, the only consequence
> would be that invalidate_mappings() would never be called, and that
> dma_buf_pin() is a NOP. Besides, dma_buf_pin() would not return an
> error if the exporter doesn't implement the pin() callback?

The idea is that both should do revoke and there is a need to indicate
that this exporter has some expectations from the importers. One of them
is that invalidate_mappings exists.

Thanks

> 
> Or perhaps I missed a prereq patch?
> 
> Thanks,
> Thomas
> 
> 

