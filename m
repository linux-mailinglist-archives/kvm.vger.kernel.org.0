Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6949334C2BF
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 07:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhC2FEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 01:04:48 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42545 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhC2FE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 01:04:26 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4F80qV5wZVz9sVq; Mon, 29 Mar 2021 16:04:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1616994262;
        bh=H5I+J4KGbJxiwcim8u64TntfYYcffEWFUtH+sIUE7hA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lTTP+f02Z3s+WO/5Z+NFPXpCxZE1YbYcvqV2uwNsQnQsZlcPkF2Jw8byNjDldNgtG
         MQf2QKB6F9kKLCl9DynHPI4OkHF6yoGGNdj7ErW8B5WZs7JQ2NZD2W450Czl/5YOuy
         CXZLWswwJKmmgZlA3k+/0YmN5oYFplPEcGj2n/2o=
Date:   Mon, 29 Mar 2021 16:04:17 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     paulus@samba.org, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Subject: Re: [PATCH v2 3/3] ppc: Enable 2nd DAWR support on p10
Message-ID: <YGFf0WxO+LRU1ysI@yekko.fritz.box>
References: <20210329041906.213991-1-ravi.bangoria@linux.ibm.com>
 <20210329041906.213991-4-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Acz6h5E9xHSXvR53"
Content-Disposition: inline
In-Reply-To: <20210329041906.213991-4-ravi.bangoria@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Acz6h5E9xHSXvR53
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 29, 2021 at 09:49:06AM +0530, Ravi Bangoria wrote:
> As per the PAPR, bit 0 of byte 64 in pa-features property indicates
> availability of 2nd DAWR registers. i.e. If this bit is set, 2nd=20
> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
> find whether kvm supports 2nd DAWR or not. If it's supported, allow
> user to set the pa-feature bit in guest DT using cap-dawr1 machine
> capability.
>=20
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> ---
>  hw/ppc/spapr.c                  | 34 ++++++++++++++++++++++++++++++++++
>  hw/ppc/spapr_caps.c             | 32 ++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h          |  6 +++++-
>  target/ppc/cpu.h                |  2 ++
>  target/ppc/kvm.c                | 12 ++++++++++++
>  target/ppc/kvm_ppc.h            |  7 +++++++
>  target/ppc/translate_init.c.inc | 17 ++++++++++++++++-
>  7 files changed, 108 insertions(+), 2 deletions(-)
>=20
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index d56418c..4df0a37 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -241,6 +241,31 @@ static void spapr_dt_pa_features(SpaprMachineState *=
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

I don't see any point adding pa_features_310: it's identical to
pa_features_300, AFAICT.

>      uint8_t *pa_features =3D NULL;
>      size_t pa_size;
> =20
> @@ -256,6 +281,10 @@ static void spapr_dt_pa_features(SpaprMachineState *=
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
> @@ -279,6 +308,9 @@ static void spapr_dt_pa_features(SpaprMachineState *s=
papr,
>           * in pa-features. So hide it from them. */
>          pa_features[40 + 2] &=3D ~0x80; /* Radix MMU */
>      }
> +    if (spapr_get_cap(spapr, SPAPR_CAP_DAWR1)) {
> +        pa_features[66] |=3D 0x80;
> +    }
> =20
>      _FDT((fdt_setprop(fdt, offset, "ibm,pa-features", pa_features, pa_si=
ze)));
>  }
> @@ -2003,6 +2035,7 @@ static const VMStateDescription vmstate_spapr =3D {
>          &vmstate_spapr_cap_ccf_assist,
>          &vmstate_spapr_cap_fwnmi,
>          &vmstate_spapr_fwnmi,
> +        &vmstate_spapr_cap_dawr1,
>          NULL
>      }
>  };
> @@ -4539,6 +4572,7 @@ static void spapr_machine_class_init(ObjectClass *o=
c, void *data)
>      smc->default_caps.caps[SPAPR_CAP_LARGE_DECREMENTER] =3D SPAPR_CAP_ON;
>      smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] =3D SPAPR_CAP_ON;
>      smc->default_caps.caps[SPAPR_CAP_FWNMI] =3D SPAPR_CAP_ON;
> +    smc->default_caps.caps[SPAPR_CAP_DAWR1] =3D SPAPR_CAP_OFF;
>      spapr_caps_add_properties(smc);
>      smc->irq =3D &spapr_irq_dual;
>      smc->dr_phb_enabled =3D true;
> diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
> index 9ea7ddd..9c39a21 100644
> --- a/hw/ppc/spapr_caps.c
> +++ b/hw/ppc/spapr_caps.c
> @@ -523,6 +523,27 @@ static void cap_fwnmi_apply(SpaprMachineState *spapr=
, uint8_t val,
>      }
>  }
> =20
> +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
> +                               Error **errp)
> +{
> +    if (!val) {
> +        return; /* Disable by default */
> +    }
> +
> +    if (tcg_enabled()) {
> +        error_setg(errp,
> +                "DAWR1 not supported in TCG. Try appending -machine cap-=
dawr1=3Doff");

I don't love this.  Is anyone working on DAWR1 emulation for POWER10?

> +    } else if (kvm_enabled()) {
> +        if (!kvmppc_has_cap_dawr1()) {
> +            error_setg(errp,
> +                "DAWR1 not supported by KVM. Try appending -machine cap-=
dawr1=3Doff");
> +        } else if (kvmppc_set_cap_dawr1(val) < 0) {
> +            error_setg(errp,
> +                "DAWR1 not supported by KVM. Try appending -machine cap-=
dawr1=3Doff");
> +        }
> +    }
> +}
> +
>  SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] =3D {
>      [SPAPR_CAP_HTM] =3D {
>          .name =3D "htm",
> @@ -631,6 +652,16 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] =
=3D {
>          .type =3D "bool",
>          .apply =3D cap_fwnmi_apply,
>      },
> +    [SPAPR_CAP_DAWR1] =3D {
> +        .name =3D "dawr1",
> +        .description =3D "Allow DAWR1",
> +        .index =3D SPAPR_CAP_DAWR1,
> +        .get =3D spapr_cap_get_bool,
> +        .set =3D spapr_cap_set_bool,
> +        .type =3D "bool",
> +        .apply =3D cap_dawr1_apply,
> +    },
> +
>  };
> =20
>  static SpaprCapabilities default_caps_with_cpu(SpaprMachineState *spapr,
> @@ -771,6 +802,7 @@ SPAPR_CAP_MIG_STATE(nested_kvm_hv, SPAPR_CAP_NESTED_K=
VM_HV);
>  SPAPR_CAP_MIG_STATE(large_decr, SPAPR_CAP_LARGE_DECREMENTER);
>  SPAPR_CAP_MIG_STATE(ccf_assist, SPAPR_CAP_CCF_ASSIST);
>  SPAPR_CAP_MIG_STATE(fwnmi, SPAPR_CAP_FWNMI);
> +SPAPR_CAP_MIG_STATE(dawr1, SPAPR_CAP_DAWR1);
> =20
>  void spapr_caps_init(SpaprMachineState *spapr)
>  {
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index b8985fa..00c8341 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -74,8 +74,10 @@ typedef enum {
>  #define SPAPR_CAP_CCF_ASSIST            0x09
>  /* Implements PAPR FWNMI option */
>  #define SPAPR_CAP_FWNMI                 0x0A
> +/* DAWR1 */
> +#define SPAPR_CAP_DAWR1                 0x0B
>  /* Num Caps */
> -#define SPAPR_CAP_NUM                   (SPAPR_CAP_FWNMI + 1)
> +#define SPAPR_CAP_NUM                   (SPAPR_CAP_DAWR1 + 1)
> =20
>  /*
>   * Capability Values
> @@ -366,6 +368,7 @@ struct SpaprMachineState {
>  #define H_SET_MODE_RESOURCE_SET_DAWR0           2
>  #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
>  #define H_SET_MODE_RESOURCE_LE                  4
> +#define H_SET_MODE_RESOURCE_SET_DAWR1           5
> =20
>  /* Flags for H_SET_MODE_RESOURCE_LE */
>  #define H_SET_MODE_ENDIAN_BIG    0
> @@ -921,6 +924,7 @@ extern const VMStateDescription vmstate_spapr_cap_nes=
ted_kvm_hv;
>  extern const VMStateDescription vmstate_spapr_cap_large_decr;
>  extern const VMStateDescription vmstate_spapr_cap_ccf_assist;
>  extern const VMStateDescription vmstate_spapr_cap_fwnmi;
> +extern const VMStateDescription vmstate_spapr_cap_dawr1;
> =20
>  static inline uint8_t spapr_get_cap(SpaprMachineState *spapr, int cap)
>  {
> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> index cd02d65..6a60416 100644
> --- a/target/ppc/cpu.h
> +++ b/target/ppc/cpu.h
> @@ -1460,9 +1460,11 @@ typedef PowerPCCPU ArchCPU;
>  #define SPR_PSPB              (0x09F)
>  #define SPR_DPDES             (0x0B0)
>  #define SPR_DAWR0             (0x0B4)
> +#define SPR_DAWR1             (0x0B5)
>  #define SPR_RPR               (0x0BA)
>  #define SPR_CIABR             (0x0BB)
>  #define SPR_DAWRX0            (0x0BC)
> +#define SPR_DAWRX1            (0x0BD)
>  #define SPR_HFSCR             (0x0BE)
>  #define SPR_VRSAVE            (0x100)
>  #define SPR_USPRG0            (0x100)
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 298c1f8..35daec2 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -89,6 +89,7 @@ static int cap_ppc_count_cache_flush_assist;
>  static int cap_ppc_nested_kvm_hv;
>  static int cap_large_decr;
>  static int cap_fwnmi;
> +static int cap_dawr1;
> =20
>  static uint32_t debug_inst_opcode;
> =20
> @@ -138,6 +139,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      cap_ppc_nested_kvm_hv =3D kvm_vm_check_extension(s, KVM_CAP_PPC_NEST=
ED_HV);
>      cap_large_decr =3D kvmppc_get_dec_bits();
>      cap_fwnmi =3D kvm_vm_check_extension(s, KVM_CAP_PPC_FWNMI);
> +    cap_dawr1 =3D kvm_vm_check_extension(s, KVM_CAP_PPC_DAWR1);
>      /*
>       * Note: setting it to false because there is not such capability
>       * in KVM at this moment.
> @@ -2078,6 +2080,16 @@ int kvmppc_set_fwnmi(PowerPCCPU *cpu)
>      return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
>  }
> =20
> +bool kvmppc_has_cap_dawr1(void)
> +{
> +    return !!cap_dawr1;
> +}
> +
> +int kvmppc_set_cap_dawr1(int enable)
> +{
> +    return kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_DAWR1, 0, enable);
> +}
> +
>  int kvmppc_smt_threads(void)
>  {
>      return cap_ppc_smt ? cap_ppc_smt : 1;
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index 989f61a..b13e8ab 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -63,6 +63,8 @@ bool kvmppc_has_cap_htm(void);
>  bool kvmppc_has_cap_mmu_radix(void);
>  bool kvmppc_has_cap_mmu_hash_v3(void);
>  bool kvmppc_has_cap_xive(void);
> +bool kvmppc_has_cap_dawr1(void);
> +int kvmppc_set_cap_dawr1(int enable);
>  int kvmppc_get_cap_safe_cache(void);
>  int kvmppc_get_cap_safe_bounds_check(void);
>  int kvmppc_get_cap_safe_indirect_branch(void);
> @@ -341,6 +343,11 @@ static inline bool kvmppc_has_cap_xive(void)
>      return false;
>  }
> =20
> +static inline bool kvmppc_has_cap_dawr1(void)
> +{
> +    return false;
> +}
> +
>  static inline int kvmppc_get_cap_safe_cache(void)
>  {
>      return 0;
> diff --git a/target/ppc/translate_init.c.inc b/target/ppc/translate_init.=
c.inc
> index 879e6df..93937ee 100644
> --- a/target/ppc/translate_init.c.inc
> +++ b/target/ppc/translate_init.c.inc
> @@ -7765,6 +7765,21 @@ static void gen_spr_book3s_207_dbg(CPUPPCState *en=
v)
>                          KVM_REG_PPC_CIABR, 0x00000000);
>  }
> =20
> +static void gen_spr_book3s_310_dbg(CPUPPCState *env)
> +{
> +    gen_spr_book3s_207_dbg(env);
> +    spr_register_kvm_hv(env, SPR_DAWR1, "DAWR1",
> +                        SPR_NOACCESS, SPR_NOACCESS,
> +                        SPR_NOACCESS, SPR_NOACCESS,
> +                        &spr_read_generic, &spr_write_generic,
> +                        KVM_REG_PPC_DAWR1, 0x00000000);
> +    spr_register_kvm_hv(env, SPR_DAWRX1, "DAWRX1",
> +                        SPR_NOACCESS, SPR_NOACCESS,
> +                        SPR_NOACCESS, SPR_NOACCESS,
> +                        &spr_read_generic, &spr_write_generic,
> +                        KVM_REG_PPC_DAWRX1, 0x00000000);
> +}
> +
>  static void gen_spr_970_dbg(CPUPPCState *env)
>  {
>      /* Breakpoints */
> @@ -8727,7 +8742,7 @@ static void init_proc_POWER8(CPUPPCState *env)
>      /* Common Registers */
>      init_proc_book3s_common(env);
>      gen_spr_sdr1(env);
> -    gen_spr_book3s_207_dbg(env);
> +    gen_spr_book3s_310_dbg(env);

This should surely be in init_proc_POWER10, not init_proc_POWER8.

> =20
>      /* POWER8 Specific Registers */
>      gen_spr_book3s_ids(env);

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Acz6h5E9xHSXvR53
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBhX88ACgkQbDjKyiDZ
s5KIjA//a8ij2SUnxDhbUBxJR8FcAbXlUzsLyVNtin/jn18/8l1cETJyrbJ6ZIg2
YPue2ZPMivDezwn1oTRdEpYwJlR6vC2Uqtn2Djz8BFlrLDoCHpwwJcytPi5ZsqSv
FR3JOhu64RYB1L5RXL74P0vmoF04k0s46u2N9curWbLved/lpYfcq72bMJKe0LSH
35b/CsScfgIwi4byTEK5Bpvxf/lmcJSOPjmVCrSnkHOxmuowwb2NflOuAQuQj1Vu
jdPUo1lF8ZIOI1IM8TZsYX0YYHb6NJI3xsg4/P/M2vpLKSQKCvswUUsyqo4pPhL4
f1Lr5NnWgasAMFkIqp/xjyWJQ0efST0U4VSZsljIjBfLOmWrgiyNjnNl2zJOX51q
OykhZ8sb+KdvXWALJ+DCR0+Lkf7GkabXYa9ZXFROs/r47jBs9XFONr8UNFhd9NEx
TU5t80wUBiEVU5TduObhJLwmin+bvkTIkcp2FA9ZaySghSF1+JFOSVjPvkVfRVOy
BtQDIK9vEC1UO88BM/D306VJgN9NRufVXPMJIGNneIgs+EJMHCWvX7RkmV3A74T4
+4l3vNjjgq6IQwGGZFDJI7sUwoUVJyjflZMliGKsPmWKr1CLuBW2YQgcDdmoNrbt
V+OCobxn1KixFVGr2v9MYFnaxfEsNJYF+7Stkl06eijcCI3WMfY=
=Qv1W
-----END PGP SIGNATURE-----

--Acz6h5E9xHSXvR53--
