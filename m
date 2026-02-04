Return-Path: <kvm+bounces-70196-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2sd2MYFNg2mClAMAu9opvQ
	(envelope-from <kvm+bounces-70196-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:45:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E536E69D4
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 47A2A300D9CB
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 13:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E4E40B6EF;
	Wed,  4 Feb 2026 13:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRrsKnvR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2B93D333A;
	Wed,  4 Feb 2026 13:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770212686; cv=none; b=E1XFH8i7RmcWBv3AJ5ABzD68UtfhEQl3LRpHOcxEVXLE25oseqceCKQX8g1NJT1DmGdurJQDplqt+obwUmeyioQq+7doTNijX3hzQQ2+eA4x5fEkzuBowwiKrL+xFRvbZkDB3K3cFY/oufR7SjiSmF80+sewA0dNQOONFcYENTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770212686; c=relaxed/simple;
	bh=Dyc6QtrdtjDlD83Qzie+D8JQ8LWsKDR5MXLqpqkVovQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPqEh5opAKADV7kJZd2sSZuua41KWAafhCte9pnTisUsbnIkvnNCKGkEZuyvEM/LvfyywFPkyaAnL4ZByn78v68jkQ1pxmmYeTVIX86nk+Jb6q2n6ExmH01Fp9meDfGu2ST+3ICWzbOujQe2pzbLkUCfZse4IxQApYFYmvAZHGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRrsKnvR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001D6C4CEF7;
	Wed,  4 Feb 2026 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770212685;
	bh=Dyc6QtrdtjDlD83Qzie+D8JQ8LWsKDR5MXLqpqkVovQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QRrsKnvRdqKdZATXY6+5DepvbKibqh32QzaOqBkKLED5rSOW+W1SSMQ7GtroaGTWN
	 bTqvZm63QrYiq1cAxaqfLMLVlZ6R78Nf/Rz9I+zOM3S0VViSV3JKgGza+pEdNx8Tru
	 cV3QXA6p/a60qAO0JiK2roWgipETHpe8EovTlOb1+xCPB5YDtepsm64yiyM1wrWGtp
	 AZeVzMAQOAZQ5DUiYKOKl3w+bH9Oi3atxQBrkyrCQ0cWADXPcpWnuZj4HC+BYnXCZP
	 v0XvbnvjoIUKhhpsPXnCKi8MN/sDza76R9G1fwLlsQj1FRVqBabasNoyf09ZzFJM3m
	 2IKIdP8n1QxPg==
Date: Wed, 4 Feb 2026 14:44:42 +0100
From: Maxime Ripard <mripard@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Alex Deucher <alexander.deucher@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Gerd Hoffmann <kraxel@redhat.com>, Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
	Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu <olvaffe@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Felix Kuehling <Felix.Kuehling@amd.com>, 
	Alex Williamson <alex@shazbot.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
Message-ID: <20260204-bloodhound-of-major-realization-9852ab@houat>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260202160425.GO34749@unreal>
 <20260204081630.GA6771@unreal>
 <20260204-icy-classic-crayfish-68da6d@houat>
 <20260204115212.GG6771@unreal>
 <20260204-clever-butterfly-of-mastery-0cdc19@houat>
 <20260204121354.GH6771@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="g57nfe3564yf6hls"
Content-Disposition: inline
In-Reply-To: <20260204121354.GH6771@unreal>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-3.76 / 15.00];
	SIGNED_PGP(-2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70196-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[amd.com,linaro.org,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,ziepe.ca,8bytes.org,kernel.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mripard@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6E536E69D4
X-Rspamd-Action: no action


--g57nfe3564yf6hls
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
MIME-Version: 1.0

On Wed, Feb 04, 2026 at 02:13:54PM +0200, Leon Romanovsky wrote:
> On Wed, Feb 04, 2026 at 01:01:54PM +0100, Maxime Ripard wrote:
> > On Wed, Feb 04, 2026 at 01:52:12PM +0200, Leon Romanovsky wrote:
> > > On Wed, Feb 04, 2026 at 09:56:08AM +0100, Maxime Ripard wrote:
> > > > On Wed, Feb 04, 2026 at 10:16:30AM +0200, Leon Romanovsky wrote:
> > > > > On Mon, Feb 02, 2026 at 06:04:25PM +0200, Leon Romanovsky wrote:
> > > > > > On Sat, Jan 31, 2026 at 07:34:10AM +0200, Leon Romanovsky wrote:
> > > > > > > Changelog:
> > > > > > > v7:
> > > > > >=20
> > > > > > <...>
> > > > > >=20
> > > > > > > Leon Romanovsky (8):
> > > > > > >       dma-buf: Rename .move_notify() callback to a clearer id=
entifier
> > > > > > >       dma-buf: Rename dma_buf_move_notify() to dma_buf_invali=
date_mappings()
> > > > > > >       dma-buf: Always build with DMABUF_MOVE_NOTIFY
> > > > > > >       vfio: Wait for dma-buf invalidation to complete
> > > > > > >       dma-buf: Make .invalidate_mapping() truly optional
> > > > > > >       dma-buf: Add dma_buf_attach_revocable()
> > > > > > >       vfio: Permit VFIO to work with pinned importers
> > > > > > >       iommufd: Add dma_buf_pin()
> > > > > > >=20
> > > > > > >  drivers/dma-buf/Kconfig                     | 12 -----
> > > > > > >  drivers/dma-buf/dma-buf.c                   | 69 +++++++++++=
+++++++++-----
> > > > > > >  drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 ++---
> > > > > > >  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |  2 +-
> > > > > > >  drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
> > > > > > >  drivers/gpu/drm/virtio/virtgpu_prime.c      |  2 +-
> > > > > > >  drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  7 ++-
> > > > > > >  drivers/gpu/drm/xe/xe_bo.c                  |  2 +-
> > > > > > >  drivers/gpu/drm/xe/xe_dma_buf.c             | 14 ++---
> > > > > > >  drivers/infiniband/core/umem_dmabuf.c       | 13 -----
> > > > > > >  drivers/infiniband/hw/mlx5/mr.c             |  2 +-
> > > > > > >  drivers/iommu/iommufd/pages.c               | 11 +++-
> > > > > > >  drivers/iommu/iommufd/selftest.c            |  2 +-
> > > > > > >  drivers/vfio/pci/vfio_pci_dmabuf.c          | 80 +++++++++++=
+++++++++++-------
> > > > > > >  include/linux/dma-buf.h                     | 17 +++---
> > > > > > >  15 files changed, 153 insertions(+), 96 deletions(-)
> > > > > >=20
> > > > > > Christian,
> > > > > >=20
> > > > > > Given the ongoing discussion around patch v5, I'm a bit unclear=
 on the
> > > > > > current state. Is the series ready for merging, or do you need =
me to
> > > > > > rework anything further?
> > > > >=20
> > > > > Christian,
> > > > >=20
> > > > > Let's not miss the merge window for work that is already ready.
> > > >=20
> > > > The cutoff date for the merge window was on 25/1, so it was already
> > > > missed by the time you sent your series.
> > >=20
> > > The primary goal of this series is to update dma-buf. The changes in
> > > drivers/gpu/drm are limited to straightforward renames.
> >=20
> > And yet, dma-buf is maintained through drm.
> >=20
> > Also, it's a general rule Linus has, it's nothing specific to DRM.
>=20
> Can you point me to that general rule?
>=20
> From what I have seen, subsystems such as netdev, the block layer, and RD=
MA continue
> to accept code that is ready for merging, especially when it has been tho=
roughly
> reviewed by multiple maintainers across different subsystems.

He said it multiple times, but here's one of such examples:

https://lore.kernel.org/all/CA+55aFwdd30eBsnMLB=3DncExY0-P=3DeAsxkn_O6ir10J=
UyVSYdhA@mail.gmail.com/

And quoting:

> In particular, if you cannot follow the simple merge window rules
> (this whole two-week merge window and linux-next process has been in
> place over a decade), at least make the end result look good. Make it
> all look easy and problem-free.
>
> [...]
>
> Next merge window I will not accept anything even remotely like that.
> Things that haven't been in linux-next will be rejected

So, yeah, we can make exceptions. But you should ask and justify for
one, instead of expecting us to pick up a patch submission that was
already late.

Maxime

--g57nfe3564yf6hls
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaYNNRQAKCRAnX84Zoj2+
dmuQAYCiMJtoHGQb2aOEW2qSDKa03ZKmNzMoqgOSNMG7EToE3xlSy2KmWs0Yi5qs
kqNhz7cBf20n8wxYB3DUANuC5PqYiFatABkIC9y0sRBwvKCN7+kvTj7IGiJzDnEy
jpWCTHJODw==
=cYsD
-----END PGP SIGNATURE-----

--g57nfe3564yf6hls--

