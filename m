Return-Path: <kvm+bounces-10143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B8586A1BB
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 22:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FCE9B2C38D
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 21:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899DE15B990;
	Tue, 27 Feb 2024 21:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gibson.dropbear.id.au header.i=@gibson.dropbear.id.au header.b="UDimkuNI"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63169159585
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 21:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709069123; cv=none; b=Cbka+7FPEhCm4cz838VoG++KiKME5kftQ7whG4FFwCj9WcUKlsXQlWpMIYGeDkjOTFK5oaRZu8GA7ClFI3bHUPL/XBIJrHXFVy5rBP6v5KNV2xXsA/6ykRUkQihsGjFnMjwmdi9qdEBNGkE4Bg3p3yinNvvddRyTWxWD74vYZF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709069123; c=relaxed/simple;
	bh=ojdL4K/evFKzYajU+XW13a9WZxEQO9Mt6Tb5v4YVe0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOyIZvZtOE60ZQcLBLOQ2GKkd8Xj9Zw96E90DQ5tX366sdlyJ2HWg+TkQvPrTdZTjIsXnKALCoMNLnG6A8RDuqhCeMO9/AOpHDSTg4zKekuiNNxaKIbpcUPMm5Dldoaagknj7N6s9wqYCqK9MU5Wxfy6mCpmLozIi9cI6L4c1hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gibson.dropbear.id.au; spf=pass smtp.mailfrom=gandalf.ozlabs.org; dkim=pass (2048-bit key) header.d=gibson.dropbear.id.au header.i=@gibson.dropbear.id.au header.b=UDimkuNI; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gibson.dropbear.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gandalf.ozlabs.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=gibson.dropbear.id.au; s=202312; t=1709069116;
	bh=JHjFaWBRAsJwtsx++RN4MujX8IaD5mSINGLiPX/1hnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UDimkuNIiCwChGLEiANjkgd743NGFF/yGx+v7yTQ0dLsa9PG94hxUwHjtGZkjAgHZ
	 9niSpOzA9Oarhk1I85AeqCQXlmc69bKNDw1aAHsiCHawwnbt+sUM6z3vN8GGvz7Iz+
	 7wtzYfvv1yYziRJdTtXBQuajlWVXPbQRIva6sVe4tva4jIMUjW2QMuJCISEhaDvgkO
	 yvug7uvy2JQRufqhK/Fp/V0ePAt19AE0L86nioTkXVoJmbzcPZeZbnbQhJH60BVsLt
	 0VUPkZgzy1bISjktiUGAlEZLCdmsxQJfxhcJ49npKuqCsiZZ3ZkRsBLr958FfQ6X90
	 FjMyh6jpei3BA==
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
	id 4Tkr9m2mlyz4wcD; Wed, 28 Feb 2024 08:25:16 +1100 (AEDT)
Date: Wed, 28 Feb 2024 07:52:52 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Shivaprasad G Bhat <sbhat@linux.ibm.com>, danielhb413@gmail.com,
	qemu-ppc@nongnu.org, harshpb@linux.ibm.com, clg@kaod.org,
	groug@kaod.org, pbonzini@redhat.com, kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v8 2/2] ppc: spapr: Enable 2nd DAWR on Power10 pSeries
 machine
Message-ID: <Zd5LpH-pPOT-MHiu@zatzit>
References: <170679876639.188422.11634974895844092362.stgit@ltc-boston1.aus.stglabs.ibm.com>
 <170679878985.188422.6745903342602285494.stgit@ltc-boston1.aus.stglabs.ibm.com>
 <CZFUVDPGK7OU.1CBJ2TIMJ719P@wheely>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JEGw3Rvi+yG/ufYO"
Content-Disposition: inline
In-Reply-To: <CZFUVDPGK7OU.1CBJ2TIMJ719P@wheely>


--JEGw3Rvi+yG/ufYO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 10:21:23PM +1000, Nicholas Piggin wrote:
> On Fri Feb 2, 2024 at 12:46 AM AEST, Shivaprasad G Bhat wrote:
> > As per the PAPR, bit 0 of byte 64 in pa-features property
> > indicates availability of 2nd DAWR registers. i.e. If this bit is set, =
2nd
> > DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to find
> > whether kvm supports 2nd DAWR or not. If it's supported, allow user to =
set
> > the pa-feature bit in guest DT using cap-dawr1 machine capability.
> >
> > Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> > Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> > ---
> >  hw/ppc/spapr.c         |    7 ++++++-
> >  hw/ppc/spapr_caps.c    |   36 ++++++++++++++++++++++++++++++++++++
> >  hw/ppc/spapr_hcall.c   |   25 ++++++++++++++++---------
> >  include/hw/ppc/spapr.h |    6 +++++-
> >  target/ppc/kvm.c       |   12 ++++++++++++
> >  target/ppc/kvm_ppc.h   |   12 ++++++++++++
> >  6 files changed, 87 insertions(+), 11 deletions(-)
> >
> > diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> > index e8dabc8614..91a97d72e7 100644
> > --- a/hw/ppc/spapr.c
> > +++ b/hw/ppc/spapr.c
> > @@ -262,7 +262,7 @@ static void spapr_dt_pa_features(SpaprMachineState =
*spapr,
> >          0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
> >          /* 54: DecFP, 56: DecI, 58: SHA */
> >          0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
> > -        /* 60: NM atomic, 62: RNG */
> > +        /* 60: NM atomic, 62: RNG, 64: DAWR1 (ISA 3.1) */
> >          0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
> >      };
> >      uint8_t *pa_features =3D NULL;
> > @@ -303,6 +303,9 @@ static void spapr_dt_pa_features(SpaprMachineState =
*spapr,
> >           * in pa-features. So hide it from them. */
> >          pa_features[40 + 2] &=3D ~0x80; /* Radix MMU */
> >      }
> > +    if (spapr_get_cap(spapr, SPAPR_CAP_DAWR1)) {
> > +        pa_features[66] |=3D 0x80;
> > +    }
> > =20
> >      _FDT((fdt_setprop(fdt, offset, "ibm,pa-features", pa_features, pa_=
size)));
> >  }
> > @@ -2138,6 +2141,7 @@ static const VMStateDescription vmstate_spapr =3D=
 {
> >          &vmstate_spapr_cap_fwnmi,
> >          &vmstate_spapr_fwnmi,
> >          &vmstate_spapr_cap_rpt_invalidate,
> > +        &vmstate_spapr_cap_dawr1,
> >          NULL
> >      }
> >  };
> > @@ -4717,6 +4721,7 @@ static void spapr_machine_class_init(ObjectClass =
*oc, void *data)
> >      smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] =3D SPAPR_CAP_ON;
> >      smc->default_caps.caps[SPAPR_CAP_FWNMI] =3D SPAPR_CAP_ON;
> >      smc->default_caps.caps[SPAPR_CAP_RPT_INVALIDATE] =3D SPAPR_CAP_OFF;
> > +    smc->default_caps.caps[SPAPR_CAP_DAWR1] =3D SPAPR_CAP_OFF;
> > =20
> >      /*
> >       * This cap specifies whether the AIL 3 mode for
> > diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
> > index e889244e52..677f17cea6 100644
> > --- a/hw/ppc/spapr_caps.c
> > +++ b/hw/ppc/spapr_caps.c
> > @@ -655,6 +655,32 @@ static void cap_ail_mode_3_apply(SpaprMachineState=
 *spapr,
> >      }
> >  }
> > =20
> > +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
> > +                               Error **errp)
> > +{
> > +    ERRP_GUARD();
> > +
> > +    if (!val) {
> > +        return; /* Disable by default */
> > +    }
> > +
> > +    if (!ppc_type_check_compat(MACHINE(spapr)->cpu_type,
> > +                               CPU_POWERPC_LOGICAL_3_10, 0,
> > +                               spapr->max_compat_pvr)) {
> > +        warn_report("DAWR1 supported only on POWER10 and later CPUs");
> > +    }
>=20
> Should this be an error?

Yes, it should.  If you can't supply the cap requested, you *must*
fail to start.  Near enough is not good enough when it comes to the
guest visible properties of the virtual machine, or you'll end up with
no end of migration headaches.

> Should the dawr1 cap be enabled by default for POWER10 machines?
>=20
> > +
> > +    if (kvm_enabled()) {
> > +        if (!kvmppc_has_cap_dawr1()) {
> > +            error_setg(errp, "DAWR1 not supported by KVM.");
> > +            error_append_hint(errp, "Try appending -machine cap-dawr1=
=3Doff");
> > +        } else if (kvmppc_set_cap_dawr1(val) < 0) {
> > +            error_setg(errp, "Error enabling cap-dawr1 with KVM.");
> > +            error_append_hint(errp, "Try appending -machine cap-dawr1=
=3Doff");
> > +        }
> > +    }
> > +}
> > +
> >  SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] =3D {
> >      [SPAPR_CAP_HTM] =3D {
> >          .name =3D "htm",
> > @@ -781,6 +807,15 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM=
] =3D {
> >          .type =3D "bool",
> >          .apply =3D cap_ail_mode_3_apply,
> >      },
> > +    [SPAPR_CAP_DAWR1] =3D {
> > +        .name =3D "dawr1",
> > +        .description =3D "Allow 2nd Data Address Watchpoint Register (=
DAWR1)",
> > +        .index =3D SPAPR_CAP_DAWR1,
> > +        .get =3D spapr_cap_get_bool,
> > +        .set =3D spapr_cap_set_bool,
> > +        .type =3D "bool",
> > +        .apply =3D cap_dawr1_apply,
> > +    },
> >  };
> > =20
> >  static SpaprCapabilities default_caps_with_cpu(SpaprMachineState *spap=
r,
> > @@ -923,6 +958,7 @@ SPAPR_CAP_MIG_STATE(large_decr, SPAPR_CAP_LARGE_DEC=
REMENTER);
> >  SPAPR_CAP_MIG_STATE(ccf_assist, SPAPR_CAP_CCF_ASSIST);
> >  SPAPR_CAP_MIG_STATE(fwnmi, SPAPR_CAP_FWNMI);
> >  SPAPR_CAP_MIG_STATE(rpt_invalidate, SPAPR_CAP_RPT_INVALIDATE);
> > +SPAPR_CAP_MIG_STATE(dawr1, SPAPR_CAP_DAWR1);
> > =20
> >  void spapr_caps_init(SpaprMachineState *spapr)
> >  {
> > diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
> > index fcefd1d1c7..34c1c77c95 100644
> > --- a/hw/ppc/spapr_hcall.c
> > +++ b/hw/ppc/spapr_hcall.c
> > @@ -814,11 +814,12 @@ static target_ulong h_set_mode_resource_set_ciabr=
(PowerPCCPU *cpu,
> >      return H_SUCCESS;
> >  }
> > =20
> > -static target_ulong h_set_mode_resource_set_dawr0(PowerPCCPU *cpu,
> > -                                                  SpaprMachineState *s=
papr,
> > -                                                  target_ulong mflags,
> > -                                                  target_ulong value1,
> > -                                                  target_ulong value2)
> > +static target_ulong h_set_mode_resource_set_dawr(PowerPCCPU *cpu,
> > +                                                     SpaprMachineState=
 *spapr,
> > +                                                     target_ulong mfla=
gs,
> > +                                                     target_ulong reso=
urce,
> > +                                                     target_ulong valu=
e1,
> > +                                                     target_ulong valu=
e2)
>=20
> Did the text alignment go wrong here?
>=20
> Aside from those things,
>=20
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
>=20
> Thanks,
> Nick
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--JEGw3Rvi+yG/ufYO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEO+dNsU4E3yXUXRK2zQJF27ox2GcFAmXeS4AACgkQzQJF27ox
2GfVzw//ak6l51KpjSiy/6K910UHxccgJrLCXCdqPYHTnPIOv+47AOUKH37F9Vma
/JZW1JdEukAp39BTbMaQ1jYFBGp2DmmxJnLUHnK4B6uC3FIyvjrLgBUJo8QX82Gl
90hLl8fpFhopK0Ui+wJSRwW0z0CyeRTzd+IhuLe+maz33pMQrc3tKBJWEecYq8pe
5qImdihO3Lv4O75Gy96d26QsjYKinzri9j2cQSutGaX0RGpAMkcQB58DZ5yESH0B
zwyNvLxk0F1ZKnAdHydbjxO8Dyqx4b33LIsV7flimD9eLFylmI2+igafz5kiM/as
Dn9R4ckFd0KGRPLZSpod3ApUc/U3Qwhg/wns5FfoQMeQ3qmLbbzCWTwPeW3CjyF4
UKOKo6yDHeQM7UKlOLqe253+oLExq5bIKtIEsTyrJy8H68qXJzdkjOq+Rkag41Cx
Nl6XXamyuddmw4n6G5ntzE4496LkfbhoDFQX1cb5XA3pJyzRc+ekFNnaReYc9kAn
gGRUTx1S/smZVEYfsyR88TGKNw7npRxMwSnYtYLP7sP4tOPGEQHUrzOfJhLHkouH
jTCR0C+VtJqiYbOIv2VDnO0ZZeiJ+M1bPYwsfG/huyj2hJD2LdsdSzVobdEYSyMo
xy+CjjyJWCdvOjd2x9i+/WCSuNYw/1SxpzG6ApB21WOT0CRMXIk=
=Gekm
-----END PGP SIGNATURE-----

--JEGw3Rvi+yG/ufYO--

