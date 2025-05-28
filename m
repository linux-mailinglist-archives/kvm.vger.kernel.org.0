Return-Path: <kvm+bounces-47847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE9EAC6250
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 08:47:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1A8CA20A8C
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 06:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A869D2580FF;
	Wed, 28 May 2025 06:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="r8EFuGRB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1AF24678D;
	Wed, 28 May 2025 06:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748414655; cv=none; b=T1NsgWfwXRrxcRJeOJmzGyV2rF2R2HDtOQNT8EG5MoY2uZeHr0kZJRSeR1fBCvznALDuqk+UPPU3t40FZBxscJG03DCx0+nHN16TJgYnIxb/hTG7BAPZuut/2W582rhA4DrYdSfktodIPb/jLqkJKTOcUw+xk6Y337BaMsVugyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748414655; c=relaxed/simple;
	bh=i/IPBsRRQzA/LSTE9msuNs7+guqvJN7NuTau9LEEuis=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=llS7Ycq+YPadKlltYKzR+VoZ/IreqYpKgfs85P9xG7dqdD23Y2lOX67oxCmC237s6ZkMJwWsUITomSi7j3rgQ+lQb320CYg1vWuIyADU31uK/ouOTvew8XKY1aVluci2Uir9nWMw6bsSHwa1T74YbzCUiKEK7MVl6V6+4CraZjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=r8EFuGRB; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1748414648;
	bh=WvPbx51UEfdYoAoEDuqVeZqZrLagzgnwzW0OdKATt9E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=r8EFuGRBg5Lg4KLSqw677Yk2Rm3v/LggXuyUr5cknbdyxjGCAR/I4EK8taXpbgfSO
	 UUZ6XXqOR4Yov+RWB1KJnXzkXzhs49toVPhJe4oGohuPrUsCDfsFov0dtnIWBIOsAP
	 cbHpNC/2liziQbUnU9m//QBrrunZKhaEDnpaSYZQjNe1/Y0JqWYQJLXdzeYgRlRYTl
	 W1N2zR4xP6Hp6DYmMGuUE0AxgJBP5cTHrU83E7HclHIKTpIFygylIm9f+2fS6EB7fF
	 KjSL+KRHvx2eWTg+AKHS6hZ9Q0bvV+c3nt5hEzZ8t0nyqP/uU1B+IT20aagSFCNVpP
	 7IGZtvQtoftKQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4b6g2c41Hwz4x8Z;
	Wed, 28 May 2025 16:44:08 +1000 (AEST)
Date: Wed, 28 May 2025 16:44:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>,
 KVM <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <20250528164407.1d8d3948@canb.auug.org.au>
In-Reply-To: <CABgObfbCg1wiZJmnXFihmRLvPiJq2bCQH3MNVMfiUJphz4JW3g@mail.gmail.com>
References: <20250528152832.3ce43330@canb.auug.org.au>
	<CABgObfbCg1wiZJmnXFihmRLvPiJq2bCQH3MNVMfiUJphz4JW3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RZdYClXNIns397zIJYDIAX7";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/RZdYClXNIns397zIJYDIAX7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

On Wed, 28 May 2025 07:37:57 +0200 Paolo Bonzini <pbonzini@redhat.com> wrot=
e:
>
> On Wed, May 28, 2025 at 7:28=E2=80=AFAM Stephen Rothwell <sfr@canb.auug.o=
rg.au> wrote:
> >
> > After merging the kvm tree, today's linux-next build (x86_64 allmodconf=
ig)
> > failed like this:
> >
> > error[E0425]: cannot find function `mutex_trylock` in crate `bindings` =
=20
> >    --> rust/kernel/sync/lock/mutex.rs:129:41 =20
> >     |
> > 129 |         let result =3D unsafe { bindings::mutex_trylock(ptr) };
> >     |                                         ^^^^^^^^^^^^^ help: a fun=
ction with a similar name exists: `mutex_lock`
> >     |
> >    ::: /home/sfr/next/x86_64_allmodconfig/rust/bindings/bindings_helper=
s_generated.rs:265:5
> >     |
> > 265 |     pub fn mutex_lock(lock: *mut mutex);
> >     |     ------------------------------------ similarly named function=
 `mutex_lock` defined here
> >
> > error: aborting due to 1 previous error =20
>=20
> I thought that since Rust failures wouldn't have to be fixed by
> non-Rust maintainers, they wouldn't block merging of non-Rust trees in
> linux-next?

I am sorry, but I am not sure how that is supposed to work.  (Do I
disable RUST in my builds - thereby possibly missing other build
problems?)  In this case you can probably not even do an allmodconfig
build of the kvm tree alone if you have rustc etc installed, right?

BTW, the only bit of the kvm tree not merged into linux-next today is
the kvm-lockdep-common topic branch that was merged overnight (my time).

> In this case it's not a problem to fix it up at all (I'll send a patch
> to Miguel as soon as I've taken the little guy to school); it's just
> to understand what's to expect.

That patch needs to go into your tree (with Miguel's Ack if necessary)
otherwise as soon as Linus merges your tree, his allmodconfig build
will be broken and he will (probably) unmerge your tree and let you
know (and wonder why I didn't pick it up).

I don't know what to tell you about expectations, sorry.
--=20
Cheers,
Stephen Rothwell

--Sig_/RZdYClXNIns397zIJYDIAX7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmg2sLcACgkQAVBC80lX
0GzLRwgAmeVTbPm1XBE0JnDMQuwmj6lX0bnhI0YU9CFzbEwCYJ7S8TQiqhAqnbpi
a3pkfykkmATvcA7M2lrGa3nmRmDgoH0soOIkotGO1ZHA14IdvXaFWvRBUOqL8wOn
Y3IVV0GYrfZA++KR5MT1oqOics71su/nL2Us93ig97yQLhqv6BaR913NDY1HPW+1
6ZQeu+0ZycPQ4ExZFZS3Jj8NC6pd5ezR/r9lcgvITWtIy8eQBBIPMbw6/6zbRUTv
nnpE4eYNtoaIkTDxhjPE4kPJOjSFu6SBQzF27DmnCdLZqCkVSzWTJfnmBTLbZdUh
qxb9PbqpliB0c13ZOZySNZGpq4biaQ==
=HZKP
-----END PGP SIGNATURE-----

--Sig_/RZdYClXNIns397zIJYDIAX7--

