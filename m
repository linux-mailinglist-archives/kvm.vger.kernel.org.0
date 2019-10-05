Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D536CC940
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2019 12:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfJEKKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Oct 2019 06:10:04 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55003 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727680AbfJEKKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Oct 2019 06:10:04 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 46ljCs0wkZz9sPv; Sat,  5 Oct 2019 20:10:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1570270201;
        bh=z6u80WE2/aUJ5KYn/oZDv9ajpD5GRfyL+G3a3DKJUxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lu0p49xoY9xNLpyE0I2YUdwoqfa/zQxihtFMz0u/2W4PzBHKY/JdLyjjXF0h9JvNz
         eD2kk7ZILzxI6koR1mHwbnEb3zHPnsdhihjnIt6S81G6LWmBSeU2vL52220E6+HHEM
         PHMIjaTv1I4W+lQP6CLYArB0g/zpkNZKbVTTHtG4=
Date:   Sat, 5 Oct 2019 18:11:22 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     lvivier@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, rkrcmar@redhat.com
Subject: Re: [PATCH] powerpc: Fix up RTAS invocation for new qemu versions
Message-ID: <20191005081122.GB29310@umbus.fritz.box>
References: <20191004103844.32590-1-david@gibson.dropbear.id.au>
 <a384c5e2-472a-32e5-2ee1-65c40da29840@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <a384c5e2-472a-32e5-2ee1-65c40da29840@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 04, 2019 at 01:54:35PM +0200, Paolo Bonzini wrote:
> On 04/10/19 12:38, David Gibson wrote:
> > In order to call RTAS functions on powerpc kvm-unit-tests relies on the
> > RTAS blob supplied by qemu.  But new versions of qemu don't supply an R=
TAS
> > blob: since the normal way for guests to get RTAS is to call the guest
> > firmware's instantiate-rtas function, we now rely on that guest firmware
> > to provide the RTAS code itself.
> >=20
> > But qemu-kvm-tests bypasses the usual guest firmware to just run itself,
> > so we can't get the rtas blob from SLOF.
> >=20
> > But.. in fact the RTAS blob under qemu is a bit of a sham anyway - it's
> > a tiny wrapper that forwards the RTAS call to a hypercall.  So, we can
> > just invoke that hypercall directly.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
>=20
> Would it be hard to call instantiate-rtas?

Fairly.  First, we'd have to not use -bios to replace the normal SLOF
firmware - that could significantly slow down tests, since SLOF itself
takes a little while to start up.  Then we'd need to get the unit
tests to boot out of slof which is a different interface from the raw
one we're using now.  Then we'd need to get it to use the OF client
interface to call instantiate-rtas - we currently don't ever call OF
(obviously, since we don't even load it).

> I'm not sure if you have any
> interest in running kvm-unit-tests on hypervisors that might have a
> different way to process RTAS calls.

Probably not..?

>=20
> Paolo
>=20
> > ---
> >  lib/powerpc/asm/hcall.h |  3 +++
> >  lib/powerpc/rtas.c      |  6 +++---
> >  powerpc/cstart64.S      | 20 ++++++++++++++++----
> >  3 files changed, 22 insertions(+), 7 deletions(-)
> >=20
> > So.. "new versions of qemu" in this case means ones that incorporate
> > the pull request I just sent today.
> >=20
> > diff --git a/lib/powerpc/asm/hcall.h b/lib/powerpc/asm/hcall.h
> > index a8bd7e3..1173fea 100644
> > --- a/lib/powerpc/asm/hcall.h
> > +++ b/lib/powerpc/asm/hcall.h
> > @@ -24,6 +24,9 @@
> >  #define H_RANDOM		0x300
> >  #define H_SET_MODE		0x31C
> > =20
> > +#define KVMPPC_HCALL_BASE	0xf000
> > +#define KVMPPC_H_RTAS		(KVMPPC_HCALL_BASE + 0x0)
> > +
> >  #ifndef __ASSEMBLY__
> >  /*
> >   * hcall_have_broken_sc1 checks if we're on a host with a broken sc1.
> > diff --git a/lib/powerpc/rtas.c b/lib/powerpc/rtas.c
> > index 2e7e0da..41c0a24 100644
> > --- a/lib/powerpc/rtas.c
> > +++ b/lib/powerpc/rtas.c
> > @@ -46,9 +46,9 @@ void rtas_init(void)
> >  	prop =3D fdt_get_property(dt_fdt(), node,
> >  				"linux,rtas-entry", &len);
> >  	if (!prop) {
> > -		printf("%s: /rtas/linux,rtas-entry: %s\n",
> > -				__func__, fdt_strerror(len));
> > -		abort();
> > +		/* We don't have a qemu provided RTAS blob, enter_rtas
> > +		 * will use H_RTAS directly */
> > +		return;
> >  	}
> >  	data =3D (u32 *)prop->data;
> >  	rtas_entry =3D (unsigned long)fdt32_to_cpu(*data);
> > diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> > index ec673b3..972851f 100644
> > --- a/powerpc/cstart64.S
> > +++ b/powerpc/cstart64.S
> > @@ -121,13 +121,25 @@ halt:
> > =20
> >  .globl enter_rtas
> >  enter_rtas:
> > +	LOAD_REG_ADDR(r11, rtas_entry)
> > +	ld	r10, 0(r11)
> > +
> > +	cmpdi	r10,0
> > +	bne	external_rtas
> > +
> > +	/* Use H_RTAS directly */
> > +	mr	r4,r3
> > +	lis	r3,KVMPPC_H_RTAS@h
> > +	ori	r3,r3,KVMPPC_H_RTAS@l
> > +	b	hcall
> > +
> > +external_rtas:
> > +	/* Use external RTAS blob */
> >  	mflr	r0
> >  	std	r0, 16(r1)
> > =20
> > -	LOAD_REG_ADDR(r10, rtas_return_loc)
> > -	mtlr	r10
> > -	LOAD_REG_ADDR(r11, rtas_entry)
> > -	ld	r10, 0(r11)
> > +	LOAD_REG_ADDR(r11, rtas_return_loc)
> > +	mtlr	r11
> > =20
> >  	mfmsr	r11
> >  	LOAD_REG_IMMEDIATE(r9, RTAS_MSR_MASK)
> >=20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl2YUCgACgkQbDjKyiDZ
s5LggQ/9GM809BxsdcsvygokChq+O0y/eSrEinwHt5UU9IbSj1NTveDBuVuOe3Mm
XHpdt97wx0awXgJ4UCv+c6FwBFbg53gMS0xl+9myRyUzSDTfxYSiUp3/yiFRWHVb
HrvO2jmOr/0JqGqe5rieKmjQUq2zqH+tgNWtvZ44gwQhuQ5lNvVXKBFKdFDBDJqk
PtVYmRtHUPpAC9htbhApOyf119t8sFHfyUj92Bz45ySVjdnxWb0ealkUaOiK8+OY
W/ooxLJW6/Ji3sUWPgEw6TCXbPGsZxBEYeNIBTLp4PJIwOMveMwad/k2hnVWvVvn
Y/cOjQtiT4XHbSctySHG2rSZe66fxNOd1vRn4Hu+VJA6chvFLRSWTSDIvZslAehu
AoVZ9HWzwucUdiu46Go1/FBYOVwe8SDEUtQZaTdqpLlXQ7xWceaCCgaEuzu45Lya
zJ5XNp+Z06Y12vCmnrnnQqkzZVg/DAwUeIubukj3PoHPB0Sxu7ip2LBQA7+D5hwx
xGAGUjxWjeJix8RErDcZszCiFhtIG0vOttAyzTU3xz/zETkW8+8ad6LhfJNCK//P
BhGzbddL0zXa7Ppo640MSPY+RMGpPHchXBuwj05Ofc5GPkU8N/Uz/6U0TdmH5ZvN
A5cf1F5sKioKCwrfJH4aIBngRscJOC+UQcOtvYKH0mIt2+maIfs=
=xQf7
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
