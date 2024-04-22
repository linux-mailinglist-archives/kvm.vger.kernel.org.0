Return-Path: <kvm+bounces-15500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB4598ACDA0
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95B33281BE1
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24ADD14F135;
	Mon, 22 Apr 2024 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cmg/OjHR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADCC14A0A5
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 13:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713790843; cv=none; b=l7fNKTgp7ha5DwXh/CK00SPvgmrsNKxezZXnnFTuZYC9etg0pvUh/xlaPLzm9FvrbV2yYKg65PdRaeGAAZDdx67iPv2ciJg2TzLjIUssatPKZt8c6swPpnoPfYZgp2raYrLOGEoiZS9HVGQKAQ8sZFh63R6vQaeOylUddexvWNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713790843; c=relaxed/simple;
	bh=SDxNTBSTL9jCN8hAO973y/hKD0LsH3tdFBWk8ED5n6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNUmDwPXdiMcKMFuX10f3BKuT/XtkEvZs6sJPGk3cTYEW1yWc1+Q0gdRemT/J/9qnA4j5bl4nM+1A8dpv9iC+ZLqAc8XkoHaqFDI6lQteD143YNaG23eVIlHl2p3a8RjkjmRr6pW1eYviP3XiXQaf5NSTPWEWo8r86ljWN1GP50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cmg/OjHR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713790840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G10E+2rDdWDG1Uk1Q5OYi9q5kLjqZHfV9ll1BpGSLpA=;
	b=cmg/OjHRD7feEmIlmGzduWXI5i1HLsB7ZQ+xc5pMV5zDcFU5TwF8Oe8bVZuyg7KyATwXnq
	R+X60K2/T9KOWclkoExRgpKIc4D7w+oKoZO9Cyzfg1HlL4fl9+urET2R6AkUq5Q4Eu40Y+
	eguQBbMmmODx9mSTY14aXP5VP0UwZOI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-4dxWiTLTNDOYGNZvn7IlWQ-1; Mon, 22 Apr 2024 09:00:34 -0400
X-MC-Unique: 4dxWiTLTNDOYGNZvn7IlWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 151F68021A5;
	Mon, 22 Apr 2024 13:00:34 +0000 (UTC)
Received: from localhost (unknown [10.39.195.50])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D4B93100A841;
	Mon, 22 Apr 2024 13:00:32 +0000 (UTC)
Date: Mon, 22 Apr 2024 09:00:31 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Jeongjun Park <aha310510@gmail.com>
Cc: mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, sgarzare@redhat.com,
	syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev,
	Arseny Krasnov <arseny.krasnov@kaspersky.com>
Subject: Re: [PATCH virt] virt: fix uninit-value in vhost_vsock_dev_open
Message-ID: <20240422130031.GA77895@fedora>
References: <20240420060450-mutt-send-email-mst@kernel.org>
 <20240421030606.80385-1-aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="fbjDzR1gbQWxLtRv"
Content-Disposition: inline
In-Reply-To: <20240421030606.80385-1-aha310510@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3


--fbjDzR1gbQWxLtRv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 21, 2024 at 12:06:06PM +0900, Jeongjun Park wrote:
> static bool vhost_transport_seqpacket_allow(u32 remote_cid)
> {
> ....
> 	vsock =3D vhost_vsock_get(remote_cid);
>=20
> 	if (vsock)
> 		seqpacket_allow =3D vsock->seqpacket_allow;
> ....
> }
>=20
> I think this is due to reading a previously created uninitialized=20
> vsock->seqpacket_allow inside vhost_transport_seqpacket_allow(),=20
> which is executed by the function pointer present in the if statement.

CCing Arseny, author of commit ced7b713711f ("vhost/vsock: support
SEQPACKET for transport").

Looks like a genuine bug in the commit. vhost_vsock_set_features() sets
seqpacket_allow to true when the feature is negotiated. The assumption
is that the field defaults to false.

The rest of the vhost_vsock.ko code is written to initialize the
vhost_vsock fields, so you could argue seqpacket_allow should just be
explicitly initialized to false.

However, eliminating this class of errors by zeroing seems reasonable in
this code path. vhost_vsock_dev_open() is not performance-critical.

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--fbjDzR1gbQWxLtRv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmYmX24ACgkQnKSrs4Gr
c8g0xgf9GAsOG1fK6cXKiusz/7vFucJOezY6SjiRsy4zMiPpUTRRsDAiaA6akyQ6
5Bnmnr1HjGGwXOeROMJfGWohjhlMCsKKCSiWT8rnPOOIQsw5yc6tgd2aqmtmbD3q
APFtGlvHmQwlRE/6/aAvkoUoTMQuS3pL3pKQqKNDgboo+lJAdKp97SiOypeLxiZ1
dYYtujTVn46aivjD/Sdm731fGFRadB/1cBPLlDioac/22TmBckx2cpOhxC3Ggoo3
tYXRtVSMb0ICOBe2Krf2sE+TqAr96/JF8DFWlag5040Bp1VfoO54OfbnvPDtu3bG
gQF5MIPjdLy7jk1A50VuhR7p7ILV6A==
=pV2Q
-----END PGP SIGNATURE-----

--fbjDzR1gbQWxLtRv--


