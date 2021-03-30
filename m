Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F6D34EE8C
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 18:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhC3Qzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 12:55:36 -0400
Received: from smtpout1.mo529.mail-out.ovh.net ([178.32.125.2]:36499 "EHLO
        smtpout1.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232465AbhC3QzU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 12:55:20 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2021 12:55:19 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.5])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 0C24695FAFE5;
        Tue, 30 Mar 2021 18:48:40 +0200 (CEST)
Received: from kaod.org (37.59.142.95) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 30 Mar
 2021 18:48:39 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-95G001bd890e8a-5603-4cd9-ae3a-6de793dac40e,
                    ACC3036D4A0BACA70991A0E48D5F19CB1CCAE693) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Tue, 30 Mar 2021 18:48:38 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
CC:     <paulus@samba.org>, <david@gibson.dropbear.id.au>,
        <mikey@neuling.org>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <mpe@ellerman.id.au>, <cohuck@redhat.com>, <qemu-devel@nongnu.org>,
        <qemu-ppc@nongnu.org>, <clg@kaod.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v3 3/3] ppc: Enable 2nd DAWR support on p10
Message-ID: <20210330184838.6b976c9d@bahia.lan>
In-Reply-To: <20210330095350.36309-4-ravi.bangoria@linux.ibm.com>
References: <20210330095350.36309-1-ravi.bangoria@linux.ibm.com>
        <20210330095350.36309-4-ravi.bangoria@linux.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.95]
X-ClientProxiedBy: DAG3EX2.mxp5.local (172.16.2.22) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: d6b3202d-d5f1-47b0-95d0-58487d14c8f2
X-Ovh-Tracer-Id: 6226226488220162552
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudeitddguddtiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgihesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepfedutdeijeejveehkeeileetgfelteekteehtedtieefffevhffflefftdefleejnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtoheptghlgheskhgrohgurdhorhhg
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Mar 2021 15:23:50 +0530
Ravi Bangoria <ravi.bangoria@linux.ibm.com> wrote:

> As per the PAPR, bit 0 of byte 64 in pa-features property indicates
> availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
> find whether kvm supports 2nd DAWR or not. If it's supported, allow
> user to set the pa-feature bit in guest DT using cap-dawr1 machine
> capability. Though, watchpoint on powerpc TCG guest is not supported
> and thus 2nd DAWR is not enabled for TCG mode.
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> ---

LGTM. A couple of remarks, see below.

>  hw/ppc/spapr.c                  | 11 ++++++++++-
>  hw/ppc/spapr_caps.c             | 32 ++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h          |  6 +++++-
>  target/ppc/cpu.h                |  2 ++
>  target/ppc/kvm.c                | 12 ++++++++++++
>  target/ppc/kvm_ppc.h            |  7 +++++++
>  target/ppc/translate_init.c.inc | 15 +++++++++++++++
>  7 files changed, 83 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index d56418ca29..4660ff9e6b 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -238,7 +238,7 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>          0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
>          /* 54: DecFP, 56: DecI, 58: SHA */
>          0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
> -        /* 60: NM atomic, 62: RNG */
> +        /* 60: NM atomic, 62: RNG, 64: DAWR1 (ISA 3.1) */
>          0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
>      };
>      uint8_t *pa_features = NULL;
> @@ -256,6 +256,10 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>          pa_features = pa_features_300;
>          pa_size = sizeof(pa_features_300);
>      }
> +    if (ppc_check_compat(cpu, CPU_POWERPC_LOGICAL_3_10, 0, cpu->compat_pvr)) {
> +        pa_features = pa_features_300;
> +        pa_size = sizeof(pa_features_300);
> +    }

This isn't strictly needed right now because a POWER10 processor has
PCR_COMPAT_3_00, so the previous ppc_check_compat() block sets
pa_features to pa_features300 already. I guess this will make sense
when/if POWER10 has its own pa_features_310 one day.

>      if (!pa_features) {
>          return;
>      }
> @@ -279,6 +283,9 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>           * in pa-features. So hide it from them. */
>          pa_features[40 + 2] &= ~0x80; /* Radix MMU */
>      }
> +    if (spapr_get_cap(spapr, SPAPR_CAP_DAWR1)) {
> +        pa_features[66] |= 0x80;
> +    }
>  
>      _FDT((fdt_setprop(fdt, offset, "ibm,pa-features", pa_features, pa_size)));
>  }
> @@ -2003,6 +2010,7 @@ static const VMStateDescription vmstate_spapr = {
>          &vmstate_spapr_cap_ccf_assist,
>          &vmstate_spapr_cap_fwnmi,
>          &vmstate_spapr_fwnmi,
> +        &vmstate_spapr_cap_dawr1,
>          NULL
>      }
>  };
> @@ -4539,6 +4547,7 @@ static void spapr_machine_class_init(ObjectClass *oc, void *data)
>      smc->default_caps.caps[SPAPR_CAP_LARGE_DECREMENTER] = SPAPR_CAP_ON;
>      smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] = SPAPR_CAP_ON;
>      smc->default_caps.caps[SPAPR_CAP_FWNMI] = SPAPR_CAP_ON;
> +    smc->default_caps.caps[SPAPR_CAP_DAWR1] = SPAPR_CAP_OFF;
>      spapr_caps_add_properties(smc);
>      smc->irq = &spapr_irq_dual;
>      smc->dr_phb_enabled = true;
> diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
> index 9ea7ddd1e9..9c39a211fd 100644
> --- a/hw/ppc/spapr_caps.c
> +++ b/hw/ppc/spapr_caps.c
> @@ -523,6 +523,27 @@ static void cap_fwnmi_apply(SpaprMachineState *spapr, uint8_t val,
>      }
>  }
>  
> +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
> +                               Error **errp)
> +{
> +    if (!val) {
> +        return; /* Disable by default */
> +    }
> +
> +    if (tcg_enabled()) {
> +        error_setg(errp,
> +                "DAWR1 not supported in TCG. Try appending -machine cap-dawr1=off");

Hints are best added with error_append_hint() because we don't want them
in QMP. Note that you'll need to use the ERRP_GUARD() macro.

See cap_htm_apply() for an example.

> +    } else if (kvm_enabled()) {
> +        if (!kvmppc_has_cap_dawr1()) {
> +            error_setg(errp,
> +                "DAWR1 not supported by KVM. Try appending -machine cap-dawr1=off");
> +        } else if (kvmppc_set_cap_dawr1(val) < 0) {
> +            error_setg(errp,
> +                "DAWR1 not supported by KVM. Try appending -machine cap-dawr1=off");
> +        }
> +    }
> +}
> +
>  SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
>      [SPAPR_CAP_HTM] = {
>          .name = "htm",
> @@ -631,6 +652,16 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
>          .type = "bool",
>          .apply = cap_fwnmi_apply,
>      },
> +    [SPAPR_CAP_DAWR1] = {
> +        .name = "dawr1",
> +        .description = "Allow DAWR1",

Maybe expand to "Allow 2nd Data Address Watchpoint Register (DAWR1)" to match
what is done for other caps.

> +        .index = SPAPR_CAP_DAWR1,
> +        .get = spapr_cap_get_bool,
> +        .set = spapr_cap_set_bool,
> +        .type = "bool",
> +        .apply = cap_dawr1_apply,
> +    },
> +
>  };
>  
>  static SpaprCapabilities default_caps_with_cpu(SpaprMachineState *spapr,
> @@ -771,6 +802,7 @@ SPAPR_CAP_MIG_STATE(nested_kvm_hv, SPAPR_CAP_NESTED_KVM_HV);
>  SPAPR_CAP_MIG_STATE(large_decr, SPAPR_CAP_LARGE_DECREMENTER);
>  SPAPR_CAP_MIG_STATE(ccf_assist, SPAPR_CAP_CCF_ASSIST);
>  SPAPR_CAP_MIG_STATE(fwnmi, SPAPR_CAP_FWNMI);
> +SPAPR_CAP_MIG_STATE(dawr1, SPAPR_CAP_DAWR1);
>  
>  void spapr_caps_init(SpaprMachineState *spapr)
>  {
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index b8985fab5b..00c8341acf 100644
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
>  
>  /*
>   * Capability Values
> @@ -366,6 +368,7 @@ struct SpaprMachineState {
>  #define H_SET_MODE_RESOURCE_SET_DAWR0           2
>  #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
>  #define H_SET_MODE_RESOURCE_LE                  4
> +#define H_SET_MODE_RESOURCE_SET_DAWR1           5
>  
>  /* Flags for H_SET_MODE_RESOURCE_LE */
>  #define H_SET_MODE_ENDIAN_BIG    0
> @@ -921,6 +924,7 @@ extern const VMStateDescription vmstate_spapr_cap_nested_kvm_hv;
>  extern const VMStateDescription vmstate_spapr_cap_large_decr;
>  extern const VMStateDescription vmstate_spapr_cap_ccf_assist;
>  extern const VMStateDescription vmstate_spapr_cap_fwnmi;
> +extern const VMStateDescription vmstate_spapr_cap_dawr1;
>  
>  static inline uint8_t spapr_get_cap(SpaprMachineState *spapr, int cap)
>  {
> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> index cd02d65303..6a60416559 100644
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
> index 298c1f882c..35daec2820 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -89,6 +89,7 @@ static int cap_ppc_count_cache_flush_assist;
>  static int cap_ppc_nested_kvm_hv;
>  static int cap_large_decr;
>  static int cap_fwnmi;
> +static int cap_dawr1;
>  
>  static uint32_t debug_inst_opcode;
>  
> @@ -138,6 +139,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      cap_ppc_nested_kvm_hv = kvm_vm_check_extension(s, KVM_CAP_PPC_NESTED_HV);
>      cap_large_decr = kvmppc_get_dec_bits();
>      cap_fwnmi = kvm_vm_check_extension(s, KVM_CAP_PPC_FWNMI);
> +    cap_dawr1 = kvm_vm_check_extension(s, KVM_CAP_PPC_DAWR1);
>      /*
>       * Note: setting it to false because there is not such capability
>       * in KVM at this moment.
> @@ -2078,6 +2080,16 @@ int kvmppc_set_fwnmi(PowerPCCPU *cpu)
>      return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
>  }
>  
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
> index 989f61ace0..b13e8abe0d 100644
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
>  
> +static inline bool kvmppc_has_cap_dawr1(void)
> +{
> +    return false;
> +}
> +

I'd rather also have a stub version of kvmppc_set_cap_dawr1() for
the sake of completeness. Probably doing abort() as I can't think
of a valid case to call this when KVM support isn't compiled in.

>  static inline int kvmppc_get_cap_safe_cache(void)
>  {
>      return 0;
> diff --git a/target/ppc/translate_init.c.inc b/target/ppc/translate_init.c.inc
> index 879e6df217..8b76e191f1 100644
> --- a/target/ppc/translate_init.c.inc
> +++ b/target/ppc/translate_init.c.inc
> @@ -7765,6 +7765,20 @@ static void gen_spr_book3s_207_dbg(CPUPPCState *env)
>                          KVM_REG_PPC_CIABR, 0x00000000);
>  }
>  
> +static void gen_spr_book3s_310_dbg(CPUPPCState *env)
> +{
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
> @@ -9142,6 +9156,7 @@ static void init_proc_POWER10(CPUPPCState *env)
>      /* Common Registers */
>      init_proc_book3s_common(env);
>      gen_spr_book3s_207_dbg(env);
> +    gen_spr_book3s_310_dbg(env);
>  
>      /* POWER8 Specific Registers */
>      gen_spr_book3s_ids(env);

