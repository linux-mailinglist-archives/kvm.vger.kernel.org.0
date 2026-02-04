Return-Path: <kvm+bounces-70206-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEmoONJcg2mJlQMAu9opvQ
	(envelope-from <kvm+bounces-70206-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 15:50:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ACC8E7763
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 15:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 11FF0302418A
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 14:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E31641B371;
	Wed,  4 Feb 2026 14:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="mi9xMhj7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sGJeihXB"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB79928B7EA;
	Wed,  4 Feb 2026 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216600; cv=none; b=XygRPuCKcST+os84CXP1XWyKQfMPs5oaQmkr585mPvlZ4PvtIEmiS34p2XawgpbmQccBYxqKDZakVxDo5nsdeTePfUx5xMTdrfxcbhofh6pCI2thQhxI/fmQSSTQRKanE84UZJKZkRFNqy8Fq7WG/8Y6SrrS70aLnsqT752GBpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216600; c=relaxed/simple;
	bh=Uu97du93QvY1MyDYyxaA4mS0MbX+m8Nh9GcfDI/ForE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SMiO7A0K9+xwh+z5jD53KQpWQZkGxZrNyhR5rtidnZfAJXozAehUZxP7LZLLsKghARIEh3Q9oZPfG+FIh5fuN5MQiIbbN1yD38WXXWXhHkRYIBhfbvy+fWs0abTiheDmAVcVjYOIU4x5GbxiGwxE8s4Dyz5ob/07HJzqbWF3yfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=mi9xMhj7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sGJeihXB; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 39ADB7A00DC;
	Wed,  4 Feb 2026 09:49:59 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 04 Feb 2026 09:50:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770216599;
	 x=1770302999; bh=QL9sSVQuHUyiqNNTJS1cRzIO660sEsNkmSlJpdQIa7o=; b=
	mi9xMhj7D7QVZHhZAiU9VKOtKQC8hfwKHEV1GYiUwJ/vKTw3MKybuvhpvocGWH8O
	ewf0IHP5WCIsCdkETSsxiawgbu8U8Ln3q8u5A6j0l1WpPHcVZqXUbf78d98CdUiM
	/IKqdJz2j5iWqpqDqhm4lV0r1z2yblKVWo/XKIIS48JRCN8WvWKd+9fo9YVCQRcl
	WDBefUZrDuUCw4YCvCRys6oeir7MzfGqsiCrzNNF+z9gUQxDdikdIgcVqQLVJJGA
	29vYJ4VhBWB9dOxWuTZALTQDzZMBUS6lPHTNaNL/TY+JA3Wi7AAhU2HH5Ycma9h2
	iZvPLo9ASafd4U5gTrgqJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770216599; x=
	1770302999; bh=QL9sSVQuHUyiqNNTJS1cRzIO660sEsNkmSlJpdQIa7o=; b=s
	GJeihXBk9DA4kr+BL+nNsg7zc5GMkdRCLjYJKk36zDGPac6Z7Moje8C4Gg96noVB
	fvzNyywNxA9I6qSs/ISvmhNult3u6YFp5A+Ak5O5WFOj4z5O9gjC6f0ph7vq3j/H
	nrd5wyg5KgPCM2bedm+0RVSCzt+R5z1nbbRxnE8jo4m4UXA748X6ZC52nPekwl5d
	hfOar7dY1pgUQWdNag+q5umeAcQEi9mIvXbo7DTN57R2xk3ZFNUvUKrf8rZmaJFl
	o6VAuTQcOkiTEpUlqQGmdX6f9sk7qvvXtn85KmfukgAViHuF50rkeqyEfQtmXkEf
	wB2zeq2JfVG/hI+46N9Kg==
X-ME-Sender: <xms:llyDaZJmYGMjYnUmYVdxhVEDlr_O47dRinUwU0f6dKEXQvoB64o4vA>
    <xme:llyDaXBAuXkvQLS0ogkdqBg_K1u8VpwbUoDJ8l2mawpsOazzq99eL5AEeW9c2GuAR
    S2c8GrwPKH-y-GC8HJG7cPQrzEmN_18FnYzPmuwtGjwyLKlTtfp>
X-ME-Received: <xmr:llyDaWVMxdX5QgxRsgefK1RHbav935eSzrLU1oHeIiUeob1gUxBD-IIfYUc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukedvjedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegudevhfejueefveduieeuueeifeettdekveekhffgvdetfeelueehgfdt
    heffhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepfeegpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehlvghonheskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheptghhrhhishhtihgrnhdrkhhovghnihhgsegrmhgurdgtohhmpdhrtghpthhtohep
    shhumhhithdrshgvmhifrghlsehlihhnrghrohdrohhrghdprhgtphhtthhopegrlhgvgi
    grnhguvghrrdguvghutghhvghrsegrmhgurdgtohhmpdhrtghpthhtoheprghirhhlihgv
    ugesghhmrghilhdrtghomhdprhgtphhtthhopehsihhmohhnrgesfhhffihllhdrtghhpd
    hrtghpthhtohepkhhrrgigvghlsehrvgguhhgrthdrtghomhdprhgtphhtthhopegumhhi
    thhrhidrohhsihhpvghnkhhosegtohhllhgrsghorhgrrdgtohhmpdhrtghpthhtohepgh
    hurhgthhgvthgrnhhsihhnghhhsegthhhrohhmihhumhdrohhrgh
X-ME-Proxy: <xmx:llyDaY6NKd7bDMPwzDMtrcrglA0Q7txOe9i2cEfBbUnJh4H99P3BMA>
    <xmx:llyDaQZPU4E4Fm9axqtBaX-WLMNA4ScJrvmFQpdDiyZJd9HNbYKoEA>
    <xmx:llyDaaqq_FW_PxGHRUdmctm9S2ljoFVq-NcIFh50bdZjLOoV2jrdcA>
    <xmx:llyDaXL7AZ2xV6n4J6obLGjlreHCThd-WQGNqX770JaImsW7wESD1Q>
    <xmx:l1yDaYhCjTqzR9iSEa4wxIeg-VejF46Npe8P2GPeeU0DmGS4kQ10LlGd>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Feb 2026 09:49:56 -0500 (EST)
Date: Wed, 4 Feb 2026 07:49:55 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
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
 Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Felix Kuehling <Felix.Kuehling@amd.com>,
 Ankit Agrawal <ankita@nvidia.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
Message-ID: <20260204074955.394a42e1@shazbot.org>
In-Reply-To: <20260204114751.GF6771@unreal>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
	<20260202160425.GO34749@unreal>
	<20260204081630.GA6771@unreal>
	<6d5c392b-596b-4341-9992-aa4b26001804@amd.com>
	<20260204114751.GF6771@unreal>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	FREEMAIL_CC(0.00)[amd.com,linaro.org,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70206-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,shazbot.org:mid,shazbot.org:dkim]
X-Rspamd-Queue-Id: 9ACC8E7763
X-Rspamd-Action: no action

On Wed, 4 Feb 2026 13:47:51 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> On Wed, Feb 04, 2026 at 09:54:13AM +0100, Christian K=C3=B6nig wrote:
> > On 2/4/26 09:16, Leon Romanovsky wrote: =20
> > > On Mon, Feb 02, 2026 at 06:04:25PM +0200, Leon Romanovsky wrote: =20
> > >> On Sat, Jan 31, 2026 at 07:34:10AM +0200, Leon Romanovsky wrote: =20
> > >>> Changelog:
> > >>> v7: =20
> > >>
> > >> <...>
> > >> =20
> > >>> Leon Romanovsky (8):
> > >>>       dma-buf: Rename .move_notify() callback to a clearer identifi=
er
> > >>>       dma-buf: Rename dma_buf_move_notify() to dma_buf_invalidate_m=
appings()
> > >>>       dma-buf: Always build with DMABUF_MOVE_NOTIFY
> > >>>       vfio: Wait for dma-buf invalidation to complete
> > >>>       dma-buf: Make .invalidate_mapping() truly optional
> > >>>       dma-buf: Add dma_buf_attach_revocable()
> > >>>       vfio: Permit VFIO to work with pinned importers
> > >>>       iommufd: Add dma_buf_pin()
> > >>>
> > >>>  drivers/dma-buf/Kconfig                     | 12 -----
> > >>>  drivers/dma-buf/dma-buf.c                   | 69 +++++++++++++++++=
+++-----
> > >>>  drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 ++---
> > >>>  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |  2 +-
> > >>>  drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
> > >>>  drivers/gpu/drm/virtio/virtgpu_prime.c      |  2 +-
> > >>>  drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  7 ++-
> > >>>  drivers/gpu/drm/xe/xe_bo.c                  |  2 +-
> > >>>  drivers/gpu/drm/xe/xe_dma_buf.c             | 14 ++---
> > >>>  drivers/infiniband/core/umem_dmabuf.c       | 13 -----
> > >>>  drivers/infiniband/hw/mlx5/mr.c             |  2 +-
> > >>>  drivers/iommu/iommufd/pages.c               | 11 +++-
> > >>>  drivers/iommu/iommufd/selftest.c            |  2 +-
> > >>>  drivers/vfio/pci/vfio_pci_dmabuf.c          | 80 +++++++++++++++++=
+++++-------
> > >>>  include/linux/dma-buf.h                     | 17 +++---
> > >>>  15 files changed, 153 insertions(+), 96 deletions(-) =20
> > >>
> > >> Christian,
> > >>
> > >> Given the ongoing discussion around patch v5, I'm a bit unclear on t=
he
> > >> current state. Is the series ready for merging, or do you need me to
> > >> rework anything further? =20
> > >=20
> > > Christian,
> > >=20
> > > Let's not miss the merge window for work that is already ready. =20
> >=20
> > Mhm, sounds like AMDs mail servers never send my last mail out.
> >=20
> > As far as I can see all patches have an reviewed-by, I also gave an rb =
on patch #6 (should that mail never got out as well). The discussion on pat=
ch v5 is just orthogonal I think, the handling was there even completely be=
fore this patch set.
> >=20
> > For upstreaming as long as the VFIO and infiniband folks don't object I=
 would like to take that through the drm-misc branch (like every other DMA-=
buf change). =20
>=20
> Infiniband folks don't object :).

No objection from vfio, I added one last R-b.  Thanks,

Alex

