Return-Path: <kvm+bounces-11956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6378387D8C8
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 05:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEFC228283B
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 04:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E426ED2EE;
	Sat, 16 Mar 2024 04:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="p9Xcw31l"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A2D9460;
	Sat, 16 Mar 2024 04:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710564603; cv=none; b=d6ivrsbjJsyVXoEq7pCzJcdvG3+orZ9KVlvcp45Cp2EQhd5dLtH0jWRSvLu6ASOUQml/qSCpnFYIHjUSpxdAaEG5Vb8NXlPK3aAYGWUuBLhBnJXa9Yx1BRXb6DCZ7sFQDBk59Ht6vEnpmHPoRhML2tn47JzgG2fyxAkxVE8/Lv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710564603; c=relaxed/simple;
	bh=dPSwwZ6Iwvp6jRWiJnju5ETNE2DnOwcwDZpt/mHWUcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLTiO43JYyPNLNFnNp0yJApfdYZy2mcuVNGyiqdaT+j0QBtFHmDE580lqGlMP0Ntkmof8S7IDNSEntgRR4AIrLvs2xIXUnkFzADCaI65G13dMrZBv5uzaODYgdSqXvATNuGt5+VqcxHrT5HQZYF+qOUHXvBYkSMps5hVRIVCNIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=p9Xcw31l; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1710564597;
	bh=SG8BQwRlZlj/5HtTLk6Dg+Q9Y6/N7rvpi85moJFhF/g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p9Xcw31lx3tkXB2wYza6UQZIYZQSgMu3U5F5GKlplYYXuY9eo/Oz5d6gl/Od/n9fc
	 RHRxUfCLSQG4WMxkdmtZuBVyyoWlWJ3F2DWZWK9pfTUxBx7vQ4lzOtSUHwq3HaZHo7
	 oHeqo5wU3Pf6TMQScYjDoCyy0P98V1X2SbEBtMJIQGw+tmehS5z6uPWQlnLmGFasFR
	 czv+KKY6pkzUvJYN9hmqaDSNMXGbXWtVDT6dJNGVyQdC7Ac4xwITCqoF8woCO9UJ8t
	 1MYV7UREZ6Wg7k1eHQPNVgn4wzpQwRSrJSHGerboCclWMlNMoB4K10XneGaUbmRgzr
	 +A8OP6VnKSf0g==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TxTDz5SQjz4wcT;
	Sat, 16 Mar 2024 15:49:55 +1100 (AEDT)
Date: Sat, 16 Mar 2024 15:49:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas
 <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Will Deacon
 <will@kernel.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Joey
 Gouly <joey.gouly@arm.com>, Christoffer Dall <cdall@cs.columbia.edu>
Subject: Re: [GIT PULL] KVM changes for Linux 6.9 merge window
Message-ID: <20240316154942.700ca013@canb.auug.org.au>
In-Reply-To: <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
References: <20240315174939.2530483-1-pbonzini@redhat.com>
	<CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1RjDiGEdh3ebFoN9tfKiZhs";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/1RjDiGEdh3ebFoN9tfKiZhs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Fri, 15 Mar 2024 15:28:29 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Fri, 15 Mar 2024 at 10:49, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> >   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus =20
>=20
> Argh.
>=20
> This causes my arm64 build to fail, but since I don't do that between
> every pull, I didn't notice until after I had already pushed things
> out.
>=20
> I get a failure on arch/arm64/kvm/check-res-bits.h (line 60):
>=20
>         BUILD_BUG_ON(ID_AA64DFR1_EL1_RES0       !=3D (GENMASK_ULL(63, 0))=
);

https://lore.kernel.org/linux-next/20240222220349.1889c728@canb.auug.org.au/

--=20
Cheers,
Stephen Rothwell

--Sig_/1RjDiGEdh3ebFoN9tfKiZhs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmX1JOcACgkQAVBC80lX
0GywgAgAnVPGH5WR28Q+y8x8ntv8nDQ0emR7khEcXXgLXCo/OYytPXwKSI+fpllo
fvbYtHNlr1JD2swC0PC8p8f3NUbCzvEwSo71N5gzBa1RVgS51ibrTlLbPbEi/Tlf
cAn0Rjbrqk3Uj6gfWjfh7FtEUgfXlYQW6V3z6aOnxPg5p8xejF+eEqNKTX/dHWuY
Kw1yqUd4H+VRhFCITvHeNh4vBs7RXMjCMAjt1r26EXcL6eFNGVPV0Sa9bL/Yc8Eb
HCUs1ENGsExGZfhnUIDBgMWGAw0NpDcryejr1C66zP03wpzRF32OapCk8Qj2nYdI
opCU2Tps0FZxhOzzFhU8Zte3D/ew8w==
=j5JE
-----END PGP SIGNATURE-----

--Sig_/1RjDiGEdh3ebFoN9tfKiZhs--

