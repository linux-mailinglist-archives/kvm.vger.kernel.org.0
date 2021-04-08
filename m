Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F139357A81
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 04:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhDHCma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 22:42:30 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36563 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhDHCm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 22:42:29 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FG5Bx2Z98z9sWH; Thu,  8 Apr 2021 12:42:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1617849737;
        bh=bWvfEMRhjPVbBEeUASqTvqo6s71NbepMBWtxxnDVwoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c1Gii0WtH3/buqbpyY/FUY0LB4CpKP7K6sz25MJj2Esli9wx5HXV+82EkOk+zQFIB
         wUOpYbvp/gNd++Sy+i0f5Mu403tyExOUxn2D/4Dxqyr6zsM7ZAMxK/xnNkX4MayQdM
         4QFZya9Zc0z3xNeLzeCJmyFr6Cddsbx5FA+B25EA=
Date:   Thu, 8 Apr 2021 12:42:11 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Greg Kurz <groug@kaod.org>
Cc:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>, paulus@samba.org,
        mpe@ellerman.id.au, mikey@neuling.org, pbonzini@redhat.com,
        mst@redhat.com, clg@kaod.org, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v4 3/3] ppc: Enable 2nd DAWR support on p10
Message-ID: <YG5tg2aHNR1/5A6H@yekko.fritz.box>
References: <20210406053833.282907-1-ravi.bangoria@linux.ibm.com>
 <20210406053833.282907-4-ravi.bangoria@linux.ibm.com>
 <20210407101041.1a884af7@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YPCAeyqDQqWGqoS2"
Content-Disposition: inline
In-Reply-To: <20210407101041.1a884af7@bahia.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--YPCAeyqDQqWGqoS2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 07, 2021 at 10:10:41AM +0200, Greg Kurz wrote:
> On Tue,  6 Apr 2021 11:08:33 +0530
> Ravi Bangoria <ravi.bangoria@linux.ibm.com> wrote:
>=20
> > As per the PAPR, bit 0 of byte 64 in pa-features property indicates
> > availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
> > DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
> > find whether kvm supports 2nd DAWR or not. If it's supported, allow
> > user to set the pa-feature bit in guest DT using cap-dawr1 machine
> > capability. Though, watchpoint on powerpc TCG guest is not supported
> > and thus 2nd DAWR is not enabled for TCG mode.
> >=20
> > Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> > ---
> >  hw/ppc/spapr.c                  |  7 ++++++-
> >  hw/ppc/spapr_caps.c             | 32 ++++++++++++++++++++++++++++++++
> >  include/hw/ppc/spapr.h          |  6 +++++-
> >  target/ppc/cpu.h                |  2 ++
> >  target/ppc/kvm.c                | 12 ++++++++++++
> >  target/ppc/kvm_ppc.h            | 12 ++++++++++++
> >  target/ppc/translate_init.c.inc | 15 +++++++++++++++
> >  7 files changed, 84 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> > index 73a06df3b1..6317fad973 100644
> > --- a/hw/ppc/spapr.c
> > +++ b/hw/ppc/spapr.c
> > @@ -238,7 +238,7 @@ static void spapr_dt_pa_features(SpaprMachineState =
*spapr,
> >          0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
> >          /* 54: DecFP, 56: DecI, 58: SHA */
> >          0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
> > -        /* 60: NM atomic, 62: RNG */
> > +        /* 60: NM atomic, 62: RNG, 64: DAWR1 (ISA 3.1) */
> >          0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
> >      };
> >      uint8_t *pa_features =3D NULL;
> > @@ -279,6 +279,9 @@ static void spapr_dt_pa_features(SpaprMachineState =
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
> > @@ -2003,6 +2006,7 @@ static const VMStateDescription vmstate_spapr =3D=
 {
> >          &vmstate_spapr_cap_ccf_assist,
> >          &vmstate_spapr_cap_fwnmi,
> >          &vmstate_spapr_fwnmi,
> > +        &vmstate_spapr_cap_dawr1,
> >          NULL
> >      }
> >  };
> > @@ -4542,6 +4546,7 @@ static void spapr_machine_class_init(ObjectClass =
*oc, void *data)
> >      smc->default_caps.caps[SPAPR_CAP_LARGE_DECREMENTER] =3D SPAPR_CAP_=
ON;
> >      smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] =3D SPAPR_CAP_ON;
> >      smc->default_caps.caps[SPAPR_CAP_FWNMI] =3D SPAPR_CAP_ON;
> > +    smc->default_caps.caps[SPAPR_CAP_DAWR1] =3D SPAPR_CAP_OFF;
> >      spapr_caps_add_properties(smc);
> >      smc->irq =3D &spapr_irq_dual;
> >      smc->dr_phb_enabled =3D true;
> > diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
> > index 9ea7ddd1e9..b2770f73c5 100644
> > --- a/hw/ppc/spapr_caps.c
> > +++ b/hw/ppc/spapr_caps.c
> > @@ -523,6 +523,28 @@ static void cap_fwnmi_apply(SpaprMachineState *spa=
pr, uint8_t val,
> >      }
> >  }
> > =20
> > +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
> > +                               Error **errp)
> > +{
> > +    ERRP_GUARD();
> > +    if (!val) {
> > +        return; /* Disable by default */
> > +    }
> > +
> > +    if (tcg_enabled()) {
> > +        error_setg(errp, "DAWR1 not supported in TCG.");
> > +        error_append_hint(errp, "Try appending -machine cap-dawr1=3Dof=
f\n");
> > +    } else if (kvm_enabled()) {
> > +        if (!kvmppc_has_cap_dawr1()) {
> > +            error_setg(errp, "DAWR1 not supported by KVM.");
> > +            error_append_hint(errp, "Try appending -machine cap-dawr1=
=3Doff\n");
> > +        } else if (kvmppc_set_cap_dawr1(val) < 0) {
> > +            error_setg(errp, "DAWR1 not supported by KVM.");
>=20
> Well... technically KVM does support DAWR1 but something went wrong when
> trying to enable it. In case you need to repost, maybe change the error
> message in this path, e.g. like in cap_nested_kvm_hv_apply().

This won't be going in until 6.1 anyway, so please to update the
message.

I'd probably prefer to actually wait until the 6.1 tree opens to apply
this, rather than pre-queueing it in ppc-for-6.1, because there's a
fairly good chance the header update patch will conflict with someone
else's during the 6.1 merge flurry.

>=20
> Apart from that, LGTM.
>=20
> Reviewed-by: Greg Kurz <groug@kaod.org>
>=20
> > +            error_append_hint(errp, "Try appending -machine cap-dawr1=
=3Doff\n");
> > +        }
> > +    }
> > +}
> > +
> >  SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] =3D {
> >      [SPAPR_CAP_HTM] =3D {
> >          .name =3D "htm",
> > @@ -631,6 +653,15 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM=
] =3D {
> >          .type =3D "bool",
> >          .apply =3D cap_fwnmi_apply,
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
> > @@ -771,6 +802,7 @@ SPAPR_CAP_MIG_STATE(nested_kvm_hv, SPAPR_CAP_NESTED=
_KVM_HV);
> >  SPAPR_CAP_MIG_STATE(large_decr, SPAPR_CAP_LARGE_DECREMENTER);
> >  SPAPR_CAP_MIG_STATE(ccf_assist, SPAPR_CAP_CCF_ASSIST);
> >  SPAPR_CAP_MIG_STATE(fwnmi, SPAPR_CAP_FWNMI);
> > +SPAPR_CAP_MIG_STATE(dawr1, SPAPR_CAP_DAWR1);
> > =20
> >  void spapr_caps_init(SpaprMachineState *spapr)
> >  {
> > diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> > index 5f90bb26d5..51202b7c90 100644
> > --- a/include/hw/ppc/spapr.h
> > +++ b/include/hw/ppc/spapr.h
> > @@ -74,8 +74,10 @@ typedef enum {
> >  #define SPAPR_CAP_CCF_ASSIST            0x09
> >  /* Implements PAPR FWNMI option */
> >  #define SPAPR_CAP_FWNMI                 0x0A
> > +/* DAWR1 */
> > +#define SPAPR_CAP_DAWR1                 0x0B
> >  /* Num Caps */
> > -#define SPAPR_CAP_NUM                   (SPAPR_CAP_FWNMI + 1)
> > +#define SPAPR_CAP_NUM                   (SPAPR_CAP_DAWR1 + 1)
> > =20
> >  /*
> >   * Capability Values
> > @@ -366,6 +368,7 @@ struct SpaprMachineState {
> >  #define H_SET_MODE_RESOURCE_SET_DAWR0           2
> >  #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
> >  #define H_SET_MODE_RESOURCE_LE                  4
> > +#define H_SET_MODE_RESOURCE_SET_DAWR1           5
> > =20
> >  /* Flags for H_SET_MODE_RESOURCE_LE */
> >  #define H_SET_MODE_ENDIAN_BIG    0
> > @@ -921,6 +924,7 @@ extern const VMStateDescription vmstate_spapr_cap_n=
ested_kvm_hv;
> >  extern const VMStateDescription vmstate_spapr_cap_large_decr;
> >  extern const VMStateDescription vmstate_spapr_cap_ccf_assist;
> >  extern const VMStateDescription vmstate_spapr_cap_fwnmi;
> > +extern const VMStateDescription vmstate_spapr_cap_dawr1;
> > =20
> >  static inline uint8_t spapr_get_cap(SpaprMachineState *spapr, int cap)
> >  {
> > diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> > index cd02d65303..6a60416559 100644
> > --- a/target/ppc/cpu.h
> > +++ b/target/ppc/cpu.h
> > @@ -1460,9 +1460,11 @@ typedef PowerPCCPU ArchCPU;
> >  #define SPR_PSPB              (0x09F)
> >  #define SPR_DPDES             (0x0B0)
> >  #define SPR_DAWR0             (0x0B4)
> > +#define SPR_DAWR1             (0x0B5)
> >  #define SPR_RPR               (0x0BA)
> >  #define SPR_CIABR             (0x0BB)
> >  #define SPR_DAWRX0            (0x0BC)
> > +#define SPR_DAWRX1            (0x0BD)
> >  #define SPR_HFSCR             (0x0BE)
> >  #define SPR_VRSAVE            (0x100)
> >  #define SPR_USPRG0            (0x100)
> > diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> > index 104a308abb..fe3e8a13bb 100644
> > --- a/target/ppc/kvm.c
> > +++ b/target/ppc/kvm.c
> > @@ -89,6 +89,7 @@ static int cap_ppc_count_cache_flush_assist;
> >  static int cap_ppc_nested_kvm_hv;
> >  static int cap_large_decr;
> >  static int cap_fwnmi;
> > +static int cap_dawr1;
> > =20
> >  static uint32_t debug_inst_opcode;
> > =20
> > @@ -138,6 +139,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
> >      cap_ppc_nested_kvm_hv =3D kvm_vm_check_extension(s, KVM_CAP_PPC_NE=
STED_HV);
> >      cap_large_decr =3D kvmppc_get_dec_bits();
> >      cap_fwnmi =3D kvm_vm_check_extension(s, KVM_CAP_PPC_FWNMI);
> > +    cap_dawr1 =3D kvm_vm_check_extension(s, KVM_CAP_PPC_DAWR1);
> >      /*
> >       * Note: setting it to false because there is not such capability
> >       * in KVM at this moment.
> > @@ -2091,6 +2093,16 @@ int kvmppc_set_fwnmi(PowerPCCPU *cpu)
> >      return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
> >  }
> > =20
> > +bool kvmppc_has_cap_dawr1(void)
> > +{
> > +    return !!cap_dawr1;
> > +}
> > +
> > +int kvmppc_set_cap_dawr1(int enable)
> > +{
> > +    return kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_DAWR1, 0, enable);
> > +}
> > +
> >  int kvmppc_smt_threads(void)
> >  {
> >      return cap_ppc_smt ? cap_ppc_smt : 1;
> > diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> > index 989f61ace0..47248fbbfd 100644
> > --- a/target/ppc/kvm_ppc.h
> > +++ b/target/ppc/kvm_ppc.h
> > @@ -63,6 +63,8 @@ bool kvmppc_has_cap_htm(void);
> >  bool kvmppc_has_cap_mmu_radix(void);
> >  bool kvmppc_has_cap_mmu_hash_v3(void);
> >  bool kvmppc_has_cap_xive(void);
> > +bool kvmppc_has_cap_dawr1(void);
> > +int kvmppc_set_cap_dawr1(int enable);
> >  int kvmppc_get_cap_safe_cache(void);
> >  int kvmppc_get_cap_safe_bounds_check(void);
> >  int kvmppc_get_cap_safe_indirect_branch(void);
> > @@ -341,6 +343,16 @@ static inline bool kvmppc_has_cap_xive(void)
> >      return false;
> >  }
> > =20
> > +static inline bool kvmppc_has_cap_dawr1(void)
> > +{
> > +    return false;
> > +}
> > +
> > +static inline int kvmppc_set_cap_dawr1(int enable)
> > +{
> > +    abort();
> > +}
> > +
> >  static inline int kvmppc_get_cap_safe_cache(void)
> >  {
> >      return 0;
> > diff --git a/target/ppc/translate_init.c.inc b/target/ppc/translate_ini=
t.c.inc
> > index 879e6df217..8b76e191f1 100644
> > --- a/target/ppc/translate_init.c.inc
> > +++ b/target/ppc/translate_init.c.inc
> > @@ -7765,6 +7765,20 @@ static void gen_spr_book3s_207_dbg(CPUPPCState *=
env)
> >                          KVM_REG_PPC_CIABR, 0x00000000);
> >  }
> > =20
> > +static void gen_spr_book3s_310_dbg(CPUPPCState *env)
> > +{
> > +    spr_register_kvm_hv(env, SPR_DAWR1, "DAWR1",
> > +                        SPR_NOACCESS, SPR_NOACCESS,
> > +                        SPR_NOACCESS, SPR_NOACCESS,
> > +                        &spr_read_generic, &spr_write_generic,
> > +                        KVM_REG_PPC_DAWR1, 0x00000000);
> > +    spr_register_kvm_hv(env, SPR_DAWRX1, "DAWRX1",
> > +                        SPR_NOACCESS, SPR_NOACCESS,
> > +                        SPR_NOACCESS, SPR_NOACCESS,
> > +                        &spr_read_generic, &spr_write_generic,
> > +                        KVM_REG_PPC_DAWRX1, 0x00000000);
> > +}
> > +
> >  static void gen_spr_970_dbg(CPUPPCState *env)
> >  {
> >      /* Breakpoints */
> > @@ -9142,6 +9156,7 @@ static void init_proc_POWER10(CPUPPCState *env)
> >      /* Common Registers */
> >      init_proc_book3s_common(env);
> >      gen_spr_book3s_207_dbg(env);
> > +    gen_spr_book3s_310_dbg(env);
> > =20
> >      /* POWER8 Specific Registers */
> >      gen_spr_book3s_ids(env);
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--YPCAeyqDQqWGqoS2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBubYMACgkQbDjKyiDZ
s5LZ7Q/8DvaVPVDjVhaOX2WERm/MRcssbQGRi4jF+5xwmPC8XIHEgt4cvV1NXH60
usor9rehTvT/MQ+Qw+AbwkUN2QdkdM95BoLIXp1XeXPcACxmXmwFxZFUAAIMbDfm
zBckd4Nhpt+NkubEgSKr2Dt3NSaHo+Z0kMpv4Vn/hy1b6sZMhBLfpfFwS733Jwtv
HVrMrqSjPfp5S1+g54nQcl7pny9dYRamJBfVBhrhDv0TgB2LgU3IAlV+X9Bb9SoY
NTZN12mK/dg6n036jyMdswFsaC/XMqtQYvHFM7fboFDAULigWUXmhnyjb0A4MgDX
cptXRzHSg7zbrE89nUzX1Szd8pIh3Bca4HkpKQT3LKdsZ8jZja/cFlxP51G4poLr
qKUhQBoVvog+Uz8SmQP6tzZ2a2U+pXEjWJGdqGlH5waH9N1vatEnsizJ1NJh/7Ep
3PLL3Wb8h2LwQ0UFq0ZpTigajbEy3PGos9qMQoubWxDcpm1U3bKr4lQ3Zru68L7H
TMDEpdGrmUOz1VGFJ54LEYAEQ0Rt8eFh9sCjaMHPn2/W+PPGB2z6MYSybu8j8lYH
vQiAip4o957ulZgmLEw7NzeVQj7YTa2+DCTbsLj3x50NPfUUQwKWUt8xuIdrCNo0
aYGZrIjw5pMl5VXy8mKeX9Ex5Z7KNGzdpBygHfUFj0PDfyTKSXw=
=xsOj
-----END PGP SIGNATURE-----

--YPCAeyqDQqWGqoS2--
