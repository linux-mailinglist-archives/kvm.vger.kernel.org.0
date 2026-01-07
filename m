Return-Path: <kvm+bounces-67247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4681CFF387
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 18:55:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B0320341F2A5
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B391039B494;
	Wed,  7 Jan 2026 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVAD+xdD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BFB387573
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767803411; cv=none; b=DcMnfk4liy31dDoLheHQjIPYDy0Pygxv82qbGIRowcwEjYFqbUC5njc24b+9XB6/aU4HqyicBro7c1JMC16Vtrwn5OMgjwr8MedFzslEFJ/mLu/akdwpln4yhIyJ8PVzra0qqda5D8WpxRVngc0buLm0VlBGNL7S8PqXfnTRIiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767803411; c=relaxed/simple;
	bh=0oAhWnNUCvoYJlR8h3KsHoUFJ6kTwCI1fBKauISCjvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k5IagDc1/JQvvyfBbA+oxQyl52Zu+Ejz87zfnUJCV4t6Q0flLQdwValIVvcrPOaAytQhqlsLVvK+tvqw8sWJcz2JEplm7xyPBQ357CfgNmhp/nZWM/8iDTpzpEu5ZxOgvR0IPxr4nxYzk/tRDoW8DQzNW9DCGqQDe2J5Vsg5OYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UVAD+xdD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767803392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c8hcqhJufBn494ZuyCMGepJhpX1rw4g16WnIwLV2/F4=;
	b=UVAD+xdD3hgimZlCz8oTbP5jAqn5pUwrQwYSuHamAPK4A6XLDNesKWyhrBvPVfOPf9nx7d
	xjN6fdeNCu8l0MPe1PcB7JaIoWuo77B9Kkv1gnYnYt1ocTBfiureZ6ORbNsAyy0pxLUUL6
	0JyVaqEM8A/TD3ZnJsNpUCYj1+9B2t0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-p-o-fWEJMiC85iH2n2Af0Q-1; Wed,
 07 Jan 2026 11:29:49 -0500
X-MC-Unique: p-o-fWEJMiC85iH2n2Af0Q-1
X-Mimecast-MFC-AGG-ID: p-o-fWEJMiC85iH2n2Af0Q_1767803386
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F17CC1954B21;
	Wed,  7 Jan 2026 16:29:44 +0000 (UTC)
Received: from localhost (unknown [10.2.17.77])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4386B30002D1;
	Wed,  7 Jan 2026 16:29:41 +0000 (UTC)
Date: Wed, 7 Jan 2026 11:29:39 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 10/15] virtio_scsi: fix DMA cacheline issues for events
Message-ID: <20260107162939.GA193868@fedora>
References: <cover.1767601130.git.mst@redhat.com>
 <8801aeef7576a155299f19b6887682dd3a272aba.1767601130.git.mst@redhat.com>
 <20260105181939.GA59391@fedora>
 <20260106094824-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qt5XKVxNjAL6wL8U"
Content-Disposition: inline
In-Reply-To: <20260106094824-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


--qt5XKVxNjAL6wL8U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2026 at 09:50:00AM -0500, Michael S. Tsirkin wrote:
> On Mon, Jan 05, 2026 at 01:19:39PM -0500, Stefan Hajnoczi wrote:
> > On Mon, Jan 05, 2026 at 03:23:29AM -0500, Michael S. Tsirkin wrote:
> > > @@ -61,7 +62,7 @@ struct virtio_scsi_cmd {
> > > =20
> > >  struct virtio_scsi_event_node {
> > >  	struct virtio_scsi *vscsi;
> > > -	struct virtio_scsi_event event;
> > > +	struct virtio_scsi_event *event;
> > >  	struct work_struct work;
> > >  };
> > > =20
> > > @@ -89,6 +90,11 @@ struct virtio_scsi {
> > > =20
> > >  	struct virtio_scsi_vq ctrl_vq;
> > >  	struct virtio_scsi_vq event_vq;
> > > +
> > > +	__dma_from_device_group_begin();
> > > +	struct virtio_scsi_event events[VIRTIO_SCSI_EVENT_LEN];
> > > +	__dma_from_device_group_end();
> >=20
> > If the device emits two events in rapid succession, could the CPU see
> > stale data for the second event because it already holds the cache line
> > for reading the first event?
>=20
> No because virtio does unmap and syncs the cache line.
>=20
> In other words, CPU reads cause no issues.
>=20
> The issues are exclusively around CPU writes dirtying the
> cache and writeback overwriting DMA data.

I see. In that case I'm happy with the virtio-scsi change:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--qt5XKVxNjAL6wL8U
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmleifMACgkQnKSrs4Gr
c8hcVAf/WNemA8s8X2IEi5T6b93Oq3H7yBSOTyvJIsAVGGG0HMv002nCDfd6Jx88
M5+0cLDN09kY62wqd/Awd8juPCIv0q5bmyWB0WYeHA93QHK4tEHgGv2+hPw4zdDT
cfBFbv3nRkHZ/Vmb9qtclA1N93XULyvUn0gLkT2cUms2ZdK+vpqxvGgdZQ/R3pmK
8TgFK8lq1kcUx8mlizEQ4TDb85DBcSr5yB6jrfgMgttm+41mDmOVhJNkkRuLissy
z4K/d8xZqWMXCv7p3/l3rrhwOm8kVasQtbKe9LO//3qd8R3Yy+8X7ZORuVW5aPbs
HeDfkWgBMGt/hmqL9Fk+OLB7vJqqmQ==
=FfpF
-----END PGP SIGNATURE-----

--qt5XKVxNjAL6wL8U--


