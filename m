Return-Path: <kvm+bounces-70192-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YNgOEzA5g2ngjwMAu9opvQ
	(envelope-from <kvm+bounces-70192-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 13:18:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDC42E5B67
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 13:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 317CA30BA316
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 12:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCB73EDAB6;
	Wed,  4 Feb 2026 12:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LV84L5rh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A451D90DD;
	Wed,  4 Feb 2026 12:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770207238; cv=none; b=mKnNwpN9/ebVkeu2k3C7YR41ElljOxl5URjyUU86HWopK56kAmY/a6CeG5KfiAvpxpRhjGWK8rIbUBS1yNc+KZRCErXCaFsSfdbuObrziwnYV9T3PPVBovYPDJBIyH+rdbvSABnjo24Fkdr6rocfxiuUEqjMhqZnZ6Q5F1pM1wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770207238; c=relaxed/simple;
	bh=PZHrTZPzbZ6arfFhy+afxuMZOXoXu5wAWL9YpUMQk14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mD2EcaFEAMCCa6XfXAAfP3I31XYNnsaJsh+Gu1EOLCegiXN3PZKvA0s5U5LmxNS9YUnicwhOdaJyhWvHDeMqR1m4EMnIi26TyYnSL7ZVqgfPv7HcT0l7915Qf3GNWF7D5ynkrt0HGMwap/SZfi+ptSv4FmLevJhXR0vRSZDKY/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LV84L5rh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E4BC4CEF7;
	Wed,  4 Feb 2026 12:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770207237;
	bh=PZHrTZPzbZ6arfFhy+afxuMZOXoXu5wAWL9YpUMQk14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LV84L5rh75yCoasR1VnSBc+2hi6DtcVWEDtP2zHMQELQ0qNI0DL/xaOQzsowshrw0
	 NFom2n0EilWMhnBfRtU/Xa+qQbLOL7GJGtUHTNwXfgVd0eUUUwWtnsLKVfQr5Ru8P/
	 MztLXFDO5BQGvmsTbhJhuwoK03rEyM9ZFa2zHY98jB2IT0IOnFE2Lg7dW1/bkaYHfx
	 itzndO+8N7k3KgkG+OnzDAYcJ7Fa/7igwxoA6nxGI3LchEay0YnI2sQi26tfPB2ItY
	 651FuP8cwAlOJqsUVdIaLEN5T0Vtf7/KCElbjvpskd/ZE/eCkeWILemJSlDKm8nc9i
	 ou62pRivj9g/w==
Date: Wed, 4 Feb 2026 14:13:54 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Maxime Ripard <mripard@kernel.org>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
Message-ID: <20260204121354.GH6771@unreal>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260202160425.GO34749@unreal>
 <20260204081630.GA6771@unreal>
 <20260204-icy-classic-crayfish-68da6d@houat>
 <20260204115212.GG6771@unreal>
 <20260204-clever-butterfly-of-mastery-0cdc19@houat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204-clever-butterfly-of-mastery-0cdc19@houat>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70192-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[amd.com,linaro.org,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,ziepe.ca,8bytes.org,kernel.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DDC42E5B67
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 01:01:54PM +0100, Maxime Ripard wrote:
> On Wed, Feb 04, 2026 at 01:52:12PM +0200, Leon Romanovsky wrote:
> > On Wed, Feb 04, 2026 at 09:56:08AM +0100, Maxime Ripard wrote:
> > > On Wed, Feb 04, 2026 at 10:16:30AM +0200, Leon Romanovsky wrote:
> > > > On Mon, Feb 02, 2026 at 06:04:25PM +0200, Leon Romanovsky wrote:
> > > > > On Sat, Jan 31, 2026 at 07:34:10AM +0200, Leon Romanovsky wrote:
> > > > > > Changelog:
> > > > > > v7:
> > > > > 
> > > > > <...>
> > > > > 
> > > > > > Leon Romanovsky (8):
> > > > > >       dma-buf: Rename .move_notify() callback to a clearer identifier
> > > > > >       dma-buf: Rename dma_buf_move_notify() to dma_buf_invalidate_mappings()
> > > > > >       dma-buf: Always build with DMABUF_MOVE_NOTIFY
> > > > > >       vfio: Wait for dma-buf invalidation to complete
> > > > > >       dma-buf: Make .invalidate_mapping() truly optional
> > > > > >       dma-buf: Add dma_buf_attach_revocable()
> > > > > >       vfio: Permit VFIO to work with pinned importers
> > > > > >       iommufd: Add dma_buf_pin()
> > > > > > 
> > > > > >  drivers/dma-buf/Kconfig                     | 12 -----
> > > > > >  drivers/dma-buf/dma-buf.c                   | 69 ++++++++++++++++++++-----
> > > > > >  drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 ++---
> > > > > >  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |  2 +-
> > > > > >  drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
> > > > > >  drivers/gpu/drm/virtio/virtgpu_prime.c      |  2 +-
> > > > > >  drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  7 ++-
> > > > > >  drivers/gpu/drm/xe/xe_bo.c                  |  2 +-
> > > > > >  drivers/gpu/drm/xe/xe_dma_buf.c             | 14 ++---
> > > > > >  drivers/infiniband/core/umem_dmabuf.c       | 13 -----
> > > > > >  drivers/infiniband/hw/mlx5/mr.c             |  2 +-
> > > > > >  drivers/iommu/iommufd/pages.c               | 11 +++-
> > > > > >  drivers/iommu/iommufd/selftest.c            |  2 +-
> > > > > >  drivers/vfio/pci/vfio_pci_dmabuf.c          | 80 ++++++++++++++++++++++-------
> > > > > >  include/linux/dma-buf.h                     | 17 +++---
> > > > > >  15 files changed, 153 insertions(+), 96 deletions(-)
> > > > > 
> > > > > Christian,
> > > > > 
> > > > > Given the ongoing discussion around patch v5, I'm a bit unclear on the
> > > > > current state. Is the series ready for merging, or do you need me to
> > > > > rework anything further?
> > > > 
> > > > Christian,
> > > > 
> > > > Let's not miss the merge window for work that is already ready.
> > > 
> > > The cutoff date for the merge window was on 25/1, so it was already
> > > missed by the time you sent your series.
> > 
> > The primary goal of this series is to update dma-buf. The changes in
> > drivers/gpu/drm are limited to straightforward renames.
> 
> And yet, dma-buf is maintained through drm.
> 
> Also, it's a general rule Linus has, it's nothing specific to DRM.

Can you point me to that general rule?

From what I have seen, subsystems such as netdev, the block layer, and RDMA continue
to accept code that is ready for merging, especially when it has been thoroughly
reviewed by multiple maintainers across different subsystems.

Thanks

> 
> Maxime



