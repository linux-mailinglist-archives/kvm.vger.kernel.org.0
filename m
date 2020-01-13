Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E13B138C3A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 08:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgAMHRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 02:17:22 -0500
Received: from ozlabs.org ([203.11.71.1]:39785 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbgAMHRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 02:17:22 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 47x4fS2FYbz9sPn; Mon, 13 Jan 2020 18:17:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1578899840;
        bh=aaWWOD+aHSxJEi2O2Vs9dFgm1buPigAQBFB1/1ut62Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W71Totl//cINFjtMhIVRW6WMNQdvRrfxqhdWTzrYsJxfbAzzNzvD4PvtMsoMFIKl/
         MI9mVhwOiw3rboglPy3O6t/L/rI2O37XWGyvdWRH+bsw70W9/tM1Vlp/ancQQqskw+
         CgBVkElofU9uX4u2vscodtQKhBozqp39VCk/tApg=
Date:   Mon, 13 Jan 2020 17:16:48 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Greg Kurz <groug@kaod.org>
Cc:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>, qemu-ppc@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm@nongnu.org, Alistair Francis <alistair.francis@wdc.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [PATCH 04/15] hw/ppc/spapr_rtas: Restrict variables scope to
 single switch case
Message-ID: <20200113071648.GF19995@umbus>
References: <20200109152133.23649-1-philmd@redhat.com>
 <20200109152133.23649-5-philmd@redhat.com>
 <20200109184349.1aefa074@bahia.lan>
 <9870f8ed-3fa0-1deb-860d-7481cb3db556@redhat.com>
 <20200110105055.3e72ddf4@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XIiC+We3v3zHqZ6Z"
Content-Disposition: inline
In-Reply-To: <20200110105055.3e72ddf4@bahia.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--XIiC+We3v3zHqZ6Z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2020 at 10:50:55AM +0100, Greg Kurz wrote:
> On Fri, 10 Jan 2020 10:34:07 +0100
> Philippe Mathieu-Daud=E9 <philmd@redhat.com> wrote:
>=20
> > On 1/9/20 6:43 PM, Greg Kurz wrote:
> > > On Thu,  9 Jan 2020 16:21:22 +0100
> > > Philippe Mathieu-Daud=E9 <philmd@redhat.com> wrote:
> > >=20
> > >> We only access these variables in RTAS_SYSPARM_SPLPAR_CHARACTERISTICS
> > >> case, restrict their scope to avoid unnecessary initialization.
> > >>
> > >=20
> > > I guess a decent compiler can be smart enough detect that the initial=
ization
> > > isn't needed outside of the RTAS_SYSPARM_SPLPAR_CHARACTERISTICS branc=
h...
> > > Anyway, reducing scope isn't bad. The only hitch I could see is that =
some
> > > people do prefer to have all variables declared upfront, but there's =
a nested
> > > param_val variable already so I guess it's okay.
> >=20
> > I don't want to outsmart compilers :)
> >=20
> > The MACHINE() macro is not a simple cast, it does object introspection=
=20
> > with OBJECT_CHECK(), thus is not free. Since=20
>=20
> Sure, I understand the motivation in avoiding an unneeded call
> to calling object_dynamic_cast_assert().
>=20
> > object_dynamic_cast_assert() argument is not const, I'm not sure the=20
> > compiler can remove the call.
> >=20
>=20
> Not remove the call, but delay it to the branch that uses it,
> ie. parameter =3D=3D RTAS_SYSPARM_SPLPAR_CHARACTERISTICS.

I think any performance consideration here is a red herring.  This
particular RTAS call is a handful-of-times-per-boot thing, and only
AFAIK used by AIX guests.

I'm in favour of the change on the grounds of code locality and
readability.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--XIiC+We3v3zHqZ6Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl4cGWAACgkQbDjKyiDZ
s5IRhxAAgjwTfn6oDce64WmxrtSzdp5v8NnkSL1fO3d3+2xEQyjHrPoCNGPjgsqG
s05hIyZ+0BwiAKsdwmFtqnxsMdtwpNWDgzESv9t7aY3qRy3hZWj7b12sVkhio7nv
5LZ5VI0Brp0fGRv6Kw6/4KczI/rvWUKYYchMv027IyOdnK01hBLL0Le06RY4gUo4
ouZOKyF3NolvtBSxotq72UDJzlUeCACieg/xQuYo3DB2KT3HeerdYv4ijsF/vXpe
yHgxJleALbk8XXfVGM2iXODKOuhbPE0Q1xovdzLZtw8Gc6LyRHlqS0PB4QVqu2pN
2W2ykFzPV52O5apL+Ythb03YgsbA15V02thgPWJgs8h3MEWaUOkkwuwmguJuZQnH
4jYeXOIY58Lwksts5+N8TiyuSAuepQiFTXFvysM9GUjt7aSDqW05Gg0b+heDyzyJ
C00cQD+AzUJzFeRR75A8/bBzoeA2xTG8N2+CH2uinY2H3CBMHfy9V2DnzJChDwEL
zkPr/tk2KT00dioTwNJFTyVivvZOzTWR8GbHxsM6+uOBiF/UwvyOQiJEHYcj2g/4
KFl9FaakjOqsjd3+tEOwyTmmIxlNNBBpphHYt+8ZKoYu344+Qp/E7brigCvhpC6+
x/YqfPajq/dqVh2mWqGNfEZyepvxWhQO2OglVhpd5WdTGP1x99U=
=x52C
-----END PGP SIGNATURE-----

--XIiC+We3v3zHqZ6Z--
