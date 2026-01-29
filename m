Return-Path: <kvm+bounces-69604-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOevN2nLe2lHIgIAu9opvQ
	(envelope-from <kvm+bounces-69604-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:04:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADCCB46F8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:04:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52B403026AAA
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF38235BDC7;
	Thu, 29 Jan 2026 21:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="uXXdJzKn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VEWQR+tr"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A1B33C194;
	Thu, 29 Jan 2026 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769720651; cv=none; b=rePuviEqnubMeYbSsfQcQrcuWPJWG22hfHuZ4wfv7azm9E+5/wkShDVviQwB4km2S6GiE00xmPQWwXucOOr5bd4eStC4O8RbLWMQUdSePb1nC2nFKhI6iAElOA538R4O4WiejtGWGjVGosahtyWS7tp9LFZWD9AdXAEGGoNI/FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769720651; c=relaxed/simple;
	bh=W/8KWWqEczjAbp77tUe4fFfPqcczRjOXcHavbskHEX4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TZ9JTfsr29jRkcSo3xnYzPpchhcGDwKsBYZRUo13ARXe6hGg5AVmQAM1b0/R2Qv1q7sArypXiYLTAsBbJIHhtck9pfZGMs7AIbdQLOJE5EYS8PV2DizC706MzQl0SJa4O9HPxDKuk6bgvXYKuibBWA/wDIn9nrLN19QwBd25tYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=uXXdJzKn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VEWQR+tr; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id DFD3E1400182;
	Thu, 29 Jan 2026 16:04:06 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 29 Jan 2026 16:04:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1769720646;
	 x=1769807046; bh=rfxL9trrLaaEV4htdtVg7LrHJEuF1NTVmjAkBCaqU44=; b=
	uXXdJzKnDnKXqOsAXDX1Ulz9zAZCRVuMW2iBfNo6F22pCrJP7TssZnsVX85wHZgi
	CjAPTuuNzIcBIffg+sc5+7poyeUx9HONBJuFwTxdXA6S0MUIJdFunoAMayCoW3Zl
	3RHNBEWp1w0rYVW1UBPxhYLES4nrc/RaJSbX2DDBfhn7tekUy2ue1MRDcug9AMvp
	rYS/JpigTohauL/NK+8FGl/I3jpkU8J6dnqq0eECiWyZZ23KhMvmh1o9P8M4oZi7
	cq5EVt1EIdzB0LzqS2DgbrZZEPiaJKQma6G74gZAgiC8huuyCWXuU16AhgQisQs5
	36YV+TVHmjf9M5KGKl8/Xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1769720646; x=
	1769807046; bh=rfxL9trrLaaEV4htdtVg7LrHJEuF1NTVmjAkBCaqU44=; b=V
	EWQR+tr/hjolr8Z4b9ZwfMetAixTfio4tWGaWAL6tvbzWqM4l0boL8V7tMvDO9SB
	DckSKkOJRQHbFAXeKNCLaCYQtqUIQUPNpatb4KLdtzv6fWgPFvB8+LFkh6CRH9WG
	nLcxVQWsybr0dVy/cQeoV4VdI7nF7jSI/FbdXY3VU52kpBn/xlcKAs896nlsjTZX
	oqDoegH3B3FqdbAcrKEcV7hWp69ovcH86Odehr2mB3Qbjq3tSBv/ALR9bUGjo1v6
	BHXT5NmpvNlzFieif3v76r3gbZj0zuj0j5PaGBxHs8bmgXRjJrQKdlUT5RxrJNpy
	1wxejI2154humc49AGJew==
X-ME-Sender: <xms:Rct7aYs357rtjI1NvUBjnJZIzqYpQ5pvF86tn-SYya6Z5FB3FMm69A>
    <xme:Rct7aXs0wgsC9SJjq2X3tgwQjaSHfDH0zmu9-ymBz9bstekVmlNNsuqXiZ4mV0jxZ
    w7Es_YNz9iAOXcKYaU_TKaZVrafkugv_EMUZtxhPff39eo0VNzhqA>
X-ME-Received: <xmr:Rct7aT35eaZALWJYoiR_CZqmjQCqIGjRZHby9U40msnxiyMVFGgB4Eshmxk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieejvddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegudevhfejueefveduieeuueeifeettdekveekhffgvdetfeelueehgfdt
    heffhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepfeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehlvghonheskhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghpthhtohepjhhgghes
    iihivghpvgdrtggrpdhrtghpthhtohepphhrrggrnhesghhoohhglhgvrdgtohhmpdhrtg
    hpthhtohepshhumhhithdrshgvmhifrghlsehlihhnrghrohdrohhrghdprhgtphhtthho
    pegthhhrihhsthhirghnrdhkohgvnhhighesrghmugdrtghomhdprhgtphhtthhopegrlh
    gvgigrnhguvghrrdguvghutghhvghrsegrmhgurdgtohhmpdhrtghpthhtoheprghirhhl
    ihgvugesghhmrghilhdrtghomhdprhgtphhtthhopehsihhmohhnrgesfhhffihllhdrtg
    hh
X-ME-Proxy: <xmx:Rct7aULzyE4y8BBhF3rdyaujcyzLfNTpE5wkyl1zdMedbzWYseOxSw>
    <xmx:Rct7ad8mYAbff79eu_rQjj8k4aznx6xrr4gA7oIU8bAKqKYlTz4CXA>
    <xmx:Rct7aTjSGVf_bD02xJhBm-h3mmSTeYrDnT-VdUguQYYGG7x8DOokYQ>
    <xmx:Rct7acz74UJJaNHeoVQGCHpVqWwxJG1YKIfmqo-nHxPN542x9btgXw>
    <xmx:Rst7aWf08CIB6FZukk4C-_5suSJ-3FNwBXWYHyloosGjmPepGYe1DWly>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jan 2026 16:04:03 -0500 (EST)
Date: Thu, 29 Jan 2026 14:04:01 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Pranjal Shrivastava <praan@google.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
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
 "Vivi, Rodrigo" <rodrigo.vivi@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Felix Kuehling <Felix.Kuehling@amd.com>,
 Ankit Agrawal <ankita@nvidia.com>, "Kasireddy,
 Vivek" <vivek.kasireddy@intel.com>,
 "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
 "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
 "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 4/8] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260129140401.52245b63@shazbot.org>
In-Reply-To: <20260129084156.GC10992@unreal>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
	<20260124-dmabuf-revoke-v5-4-f98fca917e96@nvidia.com>
	<aXfUZcSEr9N18o6w@google.com>
	<20260127085835.GQ13967@unreal>
	<20260127162754.GH1641016@ziepe.ca>
	<BN9PR11MB5276B99D4E8C6496B0C447888C9EA@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20260129073331.GB10992@unreal>
	<BN9PR11MB52766EA91FEB08876DA474888C9EA@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20260129084156.GC10992@unreal>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[35];
	FREEMAIL_CC(0.00)[intel.com,ziepe.ca,google.com,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,8bytes.org,arm.com,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-69604-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,shazbot.org:email,shazbot.org:dkim,shazbot.org:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,ziepe.ca:email]
X-Rspamd-Queue-Id: 8ADCCB46F8
X-Rspamd-Action: no action

On Thu, 29 Jan 2026 10:41:56 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> On Thu, Jan 29, 2026 at 08:13:18AM +0000, Tian, Kevin wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Thursday, January 29, 2026 3:34 PM
> > >=20
> > > On Thu, Jan 29, 2026 at 07:06:37AM +0000, Tian, Kevin wrote: =20
> > > > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > > > Sent: Wednesday, January 28, 2026 12:28 AM
> > > > >
> > > > > On Tue, Jan 27, 2026 at 10:58:35AM +0200, Leon Romanovsky wrote: =
=20
> > > > > > > > @@ -333,7 +359,37 @@ void vfio_pci_dma_buf_move(struct =20
> > > > > vfio_pci_core_device *vdev, bool revoked) =20
> > > > > > > >  			dma_resv_lock(priv->dmabuf->resv, NULL);
> > > > > > > >  			priv->revoked =3D revoked;
> > > > > > > >  			dma_buf_invalidate_mappings(priv- =20
> > > >dmabuf); =20
> > > > > > > > +			dma_resv_wait_timeout(priv->dmabuf->resv,
> > > > > > > > + =20
> > > DMA_RESV_USAGE_BOOKKEEP, =20
> > > > > false, =20
> > > > > > > > + =20
> > > MAX_SCHEDULE_TIMEOUT); =20
> > > > > > > >  			dma_resv_unlock(priv->dmabuf->resv);
> > > > > > > > +			if (revoked) {
> > > > > > > > +				kref_put(&priv->kref, =20
> > > > > vfio_pci_dma_buf_done); =20
> > > > > > > > +				/* Let's wait till all DMA unmap are =20
> > > > > completed. */ =20
> > > > > > > > +				wait =3D wait_for_completion_timeout(
> > > > > > > > +					&priv->comp, =20
> > > secs_to_jiffies(1)); =20
> > > > > > >
> > > > > > > Is the 1-second constant sufficient for all hardware, or shou=
ld the
> > > > > > > invalidate_mappings() contract require the callback to block =
until
> > > > > > > speculative reads are strictly fenced? I'm wondering about a =
case =20
> > > where =20
> > > > > > > a device's firmware has a high response latency, perhaps due =
to =20
> > > internal =20
> > > > > > > management tasks like error recovery or thermal and it exceed=
s the =20
> > > 1s =20
> > > > > > > timeout.
> > > > > > >
> > > > > > > If the device is in the middle of a large DMA burst and the f=
irmware is
> > > > > > > slow to flush the internal pipelines to a fully "quiesced"
> > > > > > > read-and-discard state, reclaiming the memory at exactly 1.00=
1 =20
> > > seconds =20
> > > > > > > risks triggering platform-level faults..
> > > > > > >
> > > > > > > Since the wen explicitly permit these speculative reads until=
 unmap is
> > > > > > > complete, relying on a hardcoded timeout in the exporter seem=
s to
> > > > > > > introduce a hardware-dependent race condition that could =20
> > > compromise =20
> > > > > > > system stability via IOMMU errors or AER faults.
> > > > > > >
> > > > > > > Should the importer instead be required to guarantee that all
> > > > > > > speculative access has ceased before the invalidation call re=
turns? =20
> > > > > >
> > > > > > It is guaranteed by the dma_resv_wait_timeout() call above. Tha=
t call =20
> > > > > ensures =20
> > > > > > that the hardware has completed all pending operations. The 1=
=E2=80=91second =20
> > > > > delay is =20
> > > > > > meant to catch cases where an in-kernel DMA unmap call is missi=
ng, =20
> > > which =20
> > > > > should =20
> > > > > > not trigger any DMA activity at that point. =20
> > > > >
> > > > > Christian may know actual examples, but my general feeling is he =
was
> > > > > worrying about drivers that have pushed the DMABUF to visibility =
on
> > > > > the GPU and the move notify & fences only shoot down some access.=
 So
> > > > > it has to wait until the DMABUF is finally unmapped.
> > > > >
> > > > > Pranjal's example should be covered by the driver adding a fence =
and
> > > > > then the unbounded fence wait will complete it.
> > > > > =20
> > > >
> > > > Bear me if it's an ignorant question.
> > > >
> > > > The commit msg of patch6 says that VFIO doesn't tolerate unbounded
> > > > wait, which is the reason behind the 2nd timeout wait here. =20
> > >=20
> > > It is not accurate. A second timeout is present both in the
> > > description of patch 6 and in VFIO implementation. The difference is
> > > that the timeout is enforced within VFIO.
> > >  =20
> > > >
> > > > Then why is "the unbounded fence wait" not a problem in the same
> > > > code path? the use of MAX_SCHEDULE_TIMEOUT imply a worst-case
> > > > timeout in hundreds of years... =20
> > >=20
> > > "An unbounded fence wait" is a different class of wait. It indicates =
broken
> > > hardware that continues to issue DMA transactions even after it has b=
een
> > > told to
> > > stop.
> > >=20
> > > The second wait exists to catch software bugs or misuse, where the dm=
a-buf
> > > importer has misrepresented its capabilities.
> > >  =20
> >=20
> > Okay I see.
> >  =20
> > > >
> > > > and it'd be helpful to put some words in the code based on what's
> > > > discussed here. =20
> > >=20
> > > We've documented as much as we can in dma_buf_attach_revocable() and
> > > dma_buf_invalidate_mappings(). Do you have any suggestions on what el=
se
> > > should be added here?
> > >  =20
> >=20
> > the selection of 1s? =20
>=20
> It is indirectly written in description of WARN_ON(), but let's add
> more. What about the following?
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_p=
ci_dmabuf.c
> index 93795ad2e025..948ba75288c6 100644
> --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> @@ -357,7 +357,13 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_devi=
ce *vdev, bool revoked)
>                         dma_resv_unlock(priv->dmabuf->resv);
>                         if (revoked) {
>                                 kref_put(&priv->kref, vfio_pci_dma_buf_do=
ne);
> -                               /* Let's wait till all DMA unmap are comp=
leted. */
> +                               /*
> +                                * Let's wait for 1 second till all DMA u=
nmap
> +                                * are completed. It is supposed to catch=
 dma-buf
> +                                * importers which lied about their suppo=
rt
> +                                * of dmabuf revoke. See dma_buf_invalida=
te_mappings()
> +                                * for the expected behaviour,
> +                                */
>                                 wait =3D wait_for_completion_timeout(
>                                         &priv->comp, secs_to_jiffies(1));
>                                 /*
>=20
> >=20
> > then,
> >=20
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com> =20

Reviewed-by: Alex Williamson <alex@shazbot.org>

