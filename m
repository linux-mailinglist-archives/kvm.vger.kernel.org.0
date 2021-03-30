Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59DB34F546
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 02:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhCaAEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 20:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbhCaAEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 20:04:14 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85142C061762
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 17:04:13 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4F96490vkJz9sf9; Wed, 31 Mar 2021 11:04:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1617149049;
        bh=MruHxoLsakrIAApvg6aBjLJVnp1sezG+PXps80LqGHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q3o0lfftwfYW8VGEMjLTU2cYMfeNhHRYNDn+MweOjJMdou7cq6gQ+cmWyJJaxgW6J
         Kdecn6JZqPSGtAiUvCC4Ee1GMonecgAjk3r1vL6leEiPOw++EM715hjKud7DOb0qHG
         C6zqytmWFPRkptfr8VjRUjsE4aBM6txgGM5IXHAE=
Date:   Wed, 31 Mar 2021 10:36:50 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Greg Kurz <groug@kaod.org>
Cc:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>, paulus@samba.org,
        mikey@neuling.org, kvm@vger.kernel.org, mst@redhat.com,
        mpe@ellerman.id.au, cohuck@redhat.com, qemu-devel@nongnu.org,
        qemu-ppc@nongnu.org, clg@kaod.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 3/3] ppc: Enable 2nd DAWR support on p10
Message-ID: <YGO2Eug243hXZgNd@yekko.fritz.box>
References: <20210330095350.36309-1-ravi.bangoria@linux.ibm.com>
 <20210330095350.36309-4-ravi.bangoria@linux.ibm.com>
 <20210330184838.6b976c9d@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7EyGBPB3CNPDmvLW"
Content-Disposition: inline
In-Reply-To: <20210330184838.6b976c9d@bahia.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--7EyGBPB3CNPDmvLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 30, 2021 at 06:48:38PM +0200, Greg Kurz wrote:
> On Tue, 30 Mar 2021 15:23:50 +0530
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
>=20
> LGTM. A couple of remarks, see below.
>=20
> >  hw/ppc/spapr.c                  | 11 ++++++++++-
> >  hw/ppc/spapr_caps.c             | 32 ++++++++++++++++++++++++++++++++
> >  include/hw/ppc/spapr.h          |  6 +++++-
> >  target/ppc/cpu.h                |  2 ++
> >  target/ppc/kvm.c                | 12 ++++++++++++
> >  target/ppc/kvm_ppc.h            |  7 +++++++
> >  target/ppc/translate_init.c.inc | 15 +++++++++++++++
> >  7 files changed, 83 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> > index d56418ca29..4660ff9e6b 100644
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
> > @@ -256,6 +256,10 @@ static void spapr_dt_pa_features(SpaprMachineState=
 *spapr,
> >          pa_features =3D pa_features_300;
> >          pa_size =3D sizeof(pa_features_300);
> >      }
> > +    if (ppc_check_compat(cpu, CPU_POWERPC_LOGICAL_3_10, 0, cpu->compat=
_pvr)) {
> > +        pa_features =3D pa_features_300;
> > +        pa_size =3D sizeof(pa_features_300);
> > +    }
>=20
> This isn't strictly needed right now because a POWER10 processor has
> PCR_COMPAT_3_00, so the previous ppc_check_compat() block sets
> pa_features to pa_features300 already. I guess this will make sense
> when/if POWER10 has its own pa_features_310 one day.

This should be removed for now.  We're definitely too late for
qemu-6.0 at this point, so might as well polish this.

The rest of Greg's comments look like they're good, too.


>=20
> >      if (!pa_features) {
> >          return;
> >      }
> > @@ -279,6 +283,9 @@ static void spapr_dt_pa_features(SpaprMachineState =
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
> > @@ -2003,6 +2010,7 @@ static const VMStateDescription vmstate_spapr =3D=
 {
> >          &vmstate_spapr_cap_ccf_assist,
> >          &vmstate_spapr_cap_fwnmi,
> >          &vmstate_spapr_fwnmi,
> > +        &vmstate_spapr_cap_dawr1,
> >          NULL
> >      }
> >  };
> > @@ -4539,6 +4547,7 @@ static void spapr_machine_class_init(ObjectClass =
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
> > index 9ea7ddd1e9..9c39a211fd 100644
> > --- a/hw/ppc/spapr_caps.c
> > +++ b/hw/ppc/spapr_caps.c
> > @@ -523,6 +523,27 @@ static void cap_fwnmi_apply(SpaprMachineState *spa=
pr, uint8_t val,
> >      }
> >  }
> > =20
> > +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
> > +                               Error **errp)
> > +{
> > +    if (!val) {
> > +        return; /* Disable by default */
> > +    }
> > +
> > +    if (tcg_enabled()) {
> > +        error_setg(errp,
> > +                "DAWR1 not supported in TCG. Try appending -machine ca=
p-dawr1=3Doff");
>=20
> Hints are best added with error_append_hint() because we don't want them
> in QMP. Note that you'll need to use the ERRP_GUARD() macro.
>=20
> See cap_htm_apply() for an example.
>=20
> > +    } else if (kvm_enabled()) {
> > +        if (!kvmppc_has_cap_dawr1()) {
> > +            error_setg(errp,
> > +                "DAWR1 not supported by KVM. Try appending -machine ca=
p-dawr1=3Doff");
> > +        } else if (kvmppc_set_cap_dawr1(val) < 0) {
> > +            error_setg(errp,
> > +                "DAWR1 not supported by KVM. Try appending -machine ca=
p-dawr1=3Doff");
> > +        }
> > +    }
> > +}
> > +
> >  SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] =3D {
> >      [SPAPR_CAP_HTM] =3D {
> >          .name =3D "htm",
> > @@ -631,6 +652,16 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM=
] =3D {
> >          .type =3D "bool",
> >          .apply =3D cap_fwnmi_apply,
> >      },
> > +    [SPAPR_CAP_DAWR1] =3D {
> > +        .name =3D "dawr1",
> > +        .description =3D "Allow DAWR1",
>=20
> Maybe expand to "Allow 2nd Data Address Watchpoint Register (DAWR1)" to m=
atch
> what is done for other caps.
>=20
> > +        .index =3D SPAPR_CAP_DAWR1,
> > +        .get =3D spapr_cap_get_bool,
> > +        .set =3D spapr_cap_set_bool,
> > +        .type =3D "bool",
> > +        .apply =3D cap_dawr1_apply,
> > +    },
> > +
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
> > index b8985fab5b..00c8341acf 100644
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
> > index 298c1f882c..35daec2820 100644
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
> > @@ -2078,6 +2080,16 @@ int kvmppc_set_fwnmi(PowerPCCPU *cpu)
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
> > index 989f61ace0..b13e8abe0d 100644
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
> > @@ -341,6 +343,11 @@ static inline bool kvmppc_has_cap_xive(void)
> >      return false;
> >  }
> > =20
> > +static inline bool kvmppc_has_cap_dawr1(void)
> > +{
> > +    return false;
> > +}
> > +
>=20
> I'd rather also have a stub version of kvmppc_set_cap_dawr1() for
> the sake of completeness. Probably doing abort() as I can't think
> of a valid case to call this when KVM support isn't compiled in.
>=20
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

--7EyGBPB3CNPDmvLW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBjthIACgkQbDjKyiDZ
s5Iajw//dbOVBiwXmZdr7Oxuyg2m0bTXzZyDnk9EI2pI0xGY2KFd8/mWu2KOrAEq
cLOfcHtuIAphQ2n8c56yMskLqpFyeM8Tdx9RYUch99d7c9QIq6usZ+JAIafV6f8Z
+Tc6JjVT8X8NPm9FRntb3ZIwEjyERkwlMsp0toqLizUi1TiPAVd40SvgiLqb601m
YBzQdGp79p+01e6ap42lmeF/CTvsw61lmZ/FGqrkjqwkimJMZmnTTidkPyMqfmct
RBp/giQrKVEwmZXRLOEdMJ9TxGWq/p/kgqFCwb5rNtyHKJpKR3ieFszXrg1RYd3r
WQDk2UbXii3rpTAM6zJhw53nFjhvApQYSyC855cqfnrpJTg87uq1dyZ3E0d8S4ao
VfX3uxEB/YPNMXC/lo0xTP6OPnis4XhBTokU9uD+MMFObXwQT3nGmhwYWG6milKD
NQlehkoSZnHN0iqgjlIle0QKygpa/s1hXGD1mTJ+dsBF7WNDT8jXqxTNjIvyaPaP
Y2viQQeow3BBSF2tJZi546uolXXK5VSJwL/1+YLHOM+6QvgvnKekQrU9RVQirb04
wh0Pm93PUu+J26ha/paqgiviU6gKFWxV6NTLxOzZwXlGGujahTm08OZ23SpzS2Av
bj6z6x25F5IkFMzr9zit3ru5cA2q6hEYURBtw+um3AYjp8mNIaw=
=IaRN
-----END PGP SIGNATURE-----

--7EyGBPB3CNPDmvLW--
