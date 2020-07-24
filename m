Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD28222BD58
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 07:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgGXFJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 01:09:57 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33757 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgGXFJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 01:09:56 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BCchM0pTPz9sSn; Fri, 24 Jul 2020 15:09:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595567395;
        bh=krR4IXYLuHabOUY3BMiLq7i+ulR4X0AT75KotwhH2HQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGwSKQMvrQYofLmspNmi480TSJ1kCHG0TOcPgAmkLHjmT3aEegk7i5SklBC0CLQaF
         Fle8vEmaeAydo1ItdklSSqfiQOWpOIUxJmTm+Ky66gc5c2Mbuj0VDOLTVyfjl5bA/J
         6Y3HT2oocEpUjkz0mRk+8Hwp9cFA/cE8h0QrHlhc=
Date:   Fri, 24 Jul 2020 14:56:13 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     mpe@ellerman.id.au, paulus@samba.org, mikey@neuling.org,
        npiggin@gmail.com, pbonzini@redhat.com, christophe.leroy@c-s.fr,
        jniethe5@gmail.com, pedromfc@br.ibm.com, rogealve@br.ibm.com,
        cohuck@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] ppc: Enable 2nd DAWR support on p10
Message-ID: <20200724045613.GA8983@umbus.fritz.box>
References: <20200723104220.314671-1-ravi.bangoria@linux.ibm.com>
 <20200723104220.314671-3-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20200723104220.314671-3-ravi.bangoria@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2020 at 04:12:20PM +0530, Ravi Bangoria wrote:
> As per the PAPR, bit 0 of byte 64 in pa-features property indicates
> availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
> find whether kvm supports 2nd DAWR or nor. If it's supported, set
> the pa-feature bit in guest DT so the guest kernel can support 2nd
> DAWR.
>=20
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> ---
>  hw/ppc/spapr.c                  | 33 +++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h          |  1 +
>  linux-headers/asm-powerpc/kvm.h |  4 ++++
>  linux-headers/linux/kvm.h       |  1 +
>  target/ppc/cpu.h                |  2 ++
>  target/ppc/kvm.c                |  7 +++++++
>  target/ppc/kvm_ppc.h            |  6 ++++++
>  target/ppc/translate_init.inc.c | 17 ++++++++++++++++-
>  8 files changed, 70 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index 0ae293ec94..4416319363 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -252,6 +252,31 @@ static void spapr_dt_pa_features(SpaprMachineState *=
spapr,
>          /* 60: NM atomic, 62: RNG */
>          0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
>      };
> +    uint8_t pa_features_310[] =3D { 66, 0,
> +        /* 0: MMU|FPU|SLB|RUN|DABR|NX, 1: fri[nzpm]|DABRX|SPRG3|SLB0|PP1=
10 */
> +        /* 2: VPM|DS205|PPR|DS202|DS206, 3: LSD|URG, SSO, 5: LE|CFAR|EB|=
LSQ */
> +        0xf6, 0x1f, 0xc7, 0xc0, 0x80, 0xf0, /* 0 - 5 */
> +        /* 6: DS207 */
> +        0x80, 0x00, 0x00, 0x00, 0x00, 0x00, /* 6 - 11 */
> +        /* 16: Vector */
> +        0x00, 0x00, 0x00, 0x00, 0x80, 0x00, /* 12 - 17 */
> +        /* 18: Vec. Scalar, 20: Vec. XOR, 22: HTM */
> +        0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 18 - 23 */
> +        /* 24: Ext. Dec, 26: 64 bit ftrs, 28: PM ftrs */
> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 24 - 29 */
> +        /* 30: MMR, 32: LE atomic, 34: EBB + ext EBB */
> +        0x80, 0x00, 0x80, 0x00, 0xC0, 0x00, /* 30 - 35 */
> +        /* 36: SPR SO, 38: Copy/Paste, 40: Radix MMU */
> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 36 - 41 */
> +        /* 42: PM, 44: PC RA, 46: SC vec'd */
> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 42 - 47 */
> +        /* 48: SIMD, 50: QP BFP, 52: String */
> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
> +        /* 54: DecFP, 56: DecI, 58: SHA */
> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
> +        /* 60: NM atomic, 62: RNG, 64: DAWR1 */
> +        0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
> +    };
>      uint8_t *pa_features =3D NULL;
>      size_t pa_size;
> =20
> @@ -267,6 +292,10 @@ static void spapr_dt_pa_features(SpaprMachineState *=
spapr,
>          pa_features =3D pa_features_300;
>          pa_size =3D sizeof(pa_features_300);
>      }
> +    if (ppc_check_compat(cpu, CPU_POWERPC_LOGICAL_3_10, 0, cpu->compat_p=
vr)) {
> +        pa_features =3D pa_features_310;
> +        pa_size =3D sizeof(pa_features_310);
> +    }
>      if (!pa_features) {
>          return;
>      }
> @@ -291,6 +320,10 @@ static void spapr_dt_pa_features(SpaprMachineState *=
spapr,
>          pa_features[40 + 2] &=3D ~0x80; /* Radix MMU */
>      }
> =20
> +    if (kvm_enabled() && kvmppc_has_cap_dawr1()) {
> +        pa_features[66] |=3D 0x80;
> +    }

Nack.  The guest visible platform must not depend on host capabilities
because it makes a complete mess of migration.  The machine type and
properties of other devices need to define what the guest environment
will be, then qemu can either provide it, or fail outright if KVM
doesn't have the neccessary support.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl8aaesACgkQbDjKyiDZ
s5KFuBAAgA/6qyCnJFK/OeujSjvdernralmgH+KVxxVPiNmFIBPePIDqIulT961C
dO1mb3MmMhiPgJRqW40VH3lAPs3izOKz1gFAPrad3CVEKaKxtvallziOWSRTotAd
wz5Scc5ch6ev5VAws8bfXTYpng12KmdHVxL1SioScgKZoIfzAZ7VhnP+POZix6fw
DwCC/mNKsluW7NWeKrK5DJ9A+azX69A2PYvD1SWUpF4JOYfmxKrIKgLDsFXPRyUX
bxwZV9RZ3qXoviNDwxAwcSPYiVIb2GZtN9CLoAJnfsvFHBlpRVlVNz2F5o/yndqQ
tpOO1ee7OQXXJZvj1WnaD4UOUzrVEo+TzdfsseGqjZGusJQiQ+foSLJ+bcc6XUE3
ASvRIR5grY7ggp6vHE/rkbjoOf3nw+5GW43BaMmWu10ol+QnsB7rtmm9TwfPhiF8
6YPErgnPcS2GI5sr5yhL8SlbBL2d3f5OPluiMQqa8UtHj5RbQEbvynZcYNc1O29o
diisn+kpOWA9sQL631u7rxYYNe5wtij83CmHLV0lQCW0F4OHuJ0nhWdt4sVoDW6D
auELJeVAJFDDlfsQrQwvo3WDOxpOXlMjJbNnQZE0QEUBNTVgYdozMpKJSmZT/OLV
YRWKyeJERYr6L4MWhKRHocWhlMuPlFLm1CUEntHznfA6mTCVrTg=
=nSJ3
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
