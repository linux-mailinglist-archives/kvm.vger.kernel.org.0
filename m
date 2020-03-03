Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AE3176AB4
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 03:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCCCoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 21:44:06 -0500
Received: from ozlabs.org ([203.11.71.1]:48135 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgCCCoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 21:44:06 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 48WhD34rSfz9sSL; Tue,  3 Mar 2020 13:44:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1583203443;
        bh=BaltiYEh6lHSqfGvxVak8CgajS73EwyljG1wWU8xKFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bpg019NP1/sr+bU2jd6N3G2DWbNDjZga2Xv4qcsJKPatGmoolYczcmns/S2x7ZYKy
         SU5AAPy0vqT2jjMdc0PnSR+C8I6553ZVJXKa5dgbKSkQY5RtroRdo7Khsovjeq+2Eu
         YUoI/POLQdhKqOonC7hXW5rgGHRL1MrsCm3Uwv3k=
Date:   Tue, 3 Mar 2020 13:39:32 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Wayne Li <waynli329@gmail.com>, kvm-devel <kvm@vger.kernel.org>,
        kvm-ppc <kvm-ppc@vger.kernel.org>,
        qemu-ppc <qemu-ppc@nongnu.org>,
        QEMU Developers <qemu-devel@nongnu.org>
Subject: Re: Problem with virtual to physical memory translation when KVM is
 enabled.
Message-ID: <20200303023932.GC35885@umbus.fritz.box>
References: <CAM2K0nreUP-zW2pJaH7tWSHHQn7WWeUDoeH_HM99wysgOHANXw@mail.gmail.com>
 <CAFEAcA84xCMzUNfYNBNR8ShA58aor_rbYTq7jnmsLQqhvbOH8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <CAFEAcA84xCMzUNfYNBNR8ShA58aor_rbYTq7jnmsLQqhvbOH8w@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2020 at 04:16:43PM +0000, Peter Maydell wrote:
> On Tue, 25 Feb 2020 at 16:10, Wayne Li <waynli329@gmail.com> wrote:
> > So what could be causing this problem?  I=E2=80=99m guessing it has som=
ething
> > to do with the translation lookaside buffers (TLBs)?  But the
> > translation between virtual and physical memory clearly works when KVM
> > isn=E2=80=99t enabled.  So what could cause this to stop working when K=
VM is
> > enabled?
>=20
> When you're not using KVM, virtual-to-physical lookups are
> done using QEMU's emulation code that emulates the MMU.
> When you are using KVM, virtual-to-physical lookups
> are done entirely using the host CPU (except for corner
> cases like when we come out of the kernel and the user
> does things with the gdb debug stub). So all the page
> tables and other guest setup of the MMU had better match
> what the host CPU expects. (I don't know how big the
> differences between e5500 and e6500 MMU are or whether
> the PPC architecture/KVM supports emulating the one on
> the other: some PPC expert will probably be able to tell you.)

Well, sort of.  Including things like KVM-PR, things get complicated.
But in any case, the resposibility for translation lies somewhere
between the cpu itself and the KVM code - qemu is not involved.

Depending on exactly what the host's MMU looks like and what it has in
the way of virtualization features, that might make it impossible to
run a guest expecting a substantially different cpu model from the
host's.

Unfortunately, I'm not really at all familiar with the Freescale
parts, and even less with the KVM implementation for them.  It doesn't
surprise me that there are substantial bugs there, but I wouldn't
realy now where to begin to fix them.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl5dw2IACgkQbDjKyiDZ
s5IK7g//dSOwpQdEGi2arNEycf3azjajh4sBmMPEOHpTQ73sPD3ChSQ0+PnCNfbJ
ApnfemamUHGfKX5FaOn8+NnSXnUAe7xYXWOojZAX8k5F2deBJifphPkxIKAKHldd
GWusFDgTixZmc0OthSk3dXYQVCgG8LPU2ImVzUkgTlsWR76/i/w8OY8/hoY65ZQU
erh6wAph3YzkW6VLr+SsEWlrerb/GyC7fhZUklwfBZ98ZjuBl5I6v5S6xbbQJ/Bm
OHLnbVyMNu5OQoY4IH1tgo+wu2t0QiD1ZvYMCkrgKTtcqdEr1k3U2UWEglh/RgfC
QcsUt93llEX8mZV0W/hrC4b3YOxBkQ83beDJE3LN8UKKmBaqEAE9FsN/tcM10teI
AH4XqXwbOM1vOFEuEh0bJYy/2Zs/drigbXEH4KrCZsgkU6uqcxJ179m2cnLoNSu0
mvO4+MDg9krXBI449J4rpAyM+uVQnn0xZzXSTh/ntaeP14XDcI3i2BwGlPjM7SMM
A37rngxrQMokeHqsr3PIgJDXwWwP5VjQcjC+HcKMIdzUvkHM09eDJ1Njvzbn5A4/
UU8QU1UHZJLiw6ZC8qT/vZQYreH8jVBG+epfl3W1d/Ze1TN2yyBsDsP9lEdvtwII
I/+FgsvNexcG4gTAprXV7UQnW+KGWV8dIQWcz/RP4s14mmp+nZE=
=/Qev
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
