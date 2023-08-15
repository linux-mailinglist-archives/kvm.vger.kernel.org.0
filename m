Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C989677D52F
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbjHOVfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240274AbjHOVfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:35:05 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0269619A5
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:03 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b9cf2b1309so68475101fa.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135301; x=1692740101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ad780UI0JA1WGhvn8Xuci6P9OczAbUeWHD+1T7FoBFc=;
        b=OSXswstwzdzz12lq9y/imEoy129bcbBkcjmEpttRTIeontizaKONz97Q57SHjAkqfl
         ztKNcaapr/LKLuQ8N41yvIajra1ojrFjWYMqoluNz3pWr7Ji076Zw9i0MxlXo8bd2T1q
         T0EoGKd1NG0sQ+F4j4HLLgTfoaRyR9njRtNvCMbmANoOKqcl5sx6RGffBS2IZF05oSeP
         91GssB0js57b6U5xzShYjMAXJAT5xqZsaGhj/XikWYKM87PADMVdA4aGmeysEncWbkoy
         UhqpMmzcu8h+HPc0Cjrr/hrlhuDChLU76s8f/OxtDJR67t2WdbyKdwMoH2XeBhc8WPDU
         W4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135301; x=1692740101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ad780UI0JA1WGhvn8Xuci6P9OczAbUeWHD+1T7FoBFc=;
        b=gbxHg5SO3bVYVjKnamQJbRYxBFXqsC0RLTBURJYQ5YSF/anoTKchOyT4v5LbigXAQQ
         IDOycYaqP55NIpV1BTR+uCYZkf0sxiZb7E34hqmUI9LBY6QAjvFqQgzBAzP1MfCv+jSL
         nkoBT7CVkf9GD3VJKQTqStYW3oO51gupWaTIr+/wDNF5ndO6xXKJoRGYpsunhtHIx0aC
         Tvywuu4p8aT0+9nKrmSZNsO4Z6ewMDXGcm5Hv8wzqQokeE1tdJqrcsEB6riHOR2OBOkP
         U9tyug+MTy3tFNr507ga00Nrhj+2KecUJlX+rmVYLz4i2jTLurmdddyOwxQtB8n8pxO5
         sNXg==
X-Gm-Message-State: AOJu0YyI8yPDEuc9CYcDQ1D/2NvG90BDmf7/hy0mZ3fwGmR9il+jeeqw
        F6zXBjnxi7cUD8oKuGDnnPjJl8Jj3Js1y36PM3L29g==
X-Google-Smtp-Source: AGHT+IFj4O92TLBBa7a6M1EWvSxzTgifdKHoirjA3N6k1JiUMqgdMBPGihu+r2wkgJEoj0yKwtBR/yLGequrjvA0TxM=
X-Received: by 2002:a2e:91d1:0:b0:2b6:d0fa:7023 with SMTP id
 u17-20020a2e91d1000000b002b6d0fa7023mr59400ljg.24.1692135301078; Tue, 15 Aug
 2023 14:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-15-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-15-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 14:34:48 -0700
Message-ID: <CAAdAUtjbYsOW1w2ub3zky-z9LDSKOLan6i3K4HmvL1TywFs0GQ@mail.gmail.com>
Subject: Re: [PATCH v4 14/28] KVM: arm64: nv: Add trap forwarding infrastructure
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> A significant part of what a NV hypervisor needs to do is to decide
> whether a trap from a L2+ guest has to be forwarded to a L1 guest
> or handled locally. This is done by checking for the trap bits that
> the guest hypervisor has set and acting accordingly, as described by
> the architecture.
>
> A previous approach was to sprinkle a bunch of checks in all the
> system register accessors, but this is pretty error prone and doesn't
> help getting an overview of what is happening.
>
> Instead, implement a set of global tables that describe a trap bit,
> combinations of trap bits, behaviours on trap, and what bits must
> be evaluated on a system register trap.
>
> Although this is painful to describe, this allows to specify each
> and every control bit in a static manner. To make it efficient,
> the table is inserted in an xarray that is global to the system,
> and checked each time we trap a system register while running
> a L2 guest.
>
> Add the basic infrastructure for now, while additional patches will
> implement configuration registers.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h   |   1 +
>  arch/arm64/include/asm/kvm_nested.h |   2 +
>  arch/arm64/kvm/emulate-nested.c     | 282 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c           |   6 +
>  arch/arm64/kvm/trace_arm.h          |  26 +++
>  5 files changed, 317 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 721680da1011..cb1c5c54cedd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -988,6 +988,7 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
>  void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
>
>  int __init kvm_sys_reg_table_init(void);
> +int __init populate_nv_trap_config(void);
>
>  bool lock_all_vcpus(struct kvm *kvm);
>  void unlock_all_vcpus(struct kvm *kvm);
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm=
/kvm_nested.h
> index 8fb67f032fd1..fa23cc9c2adc 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -11,6 +11,8 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *v=
cpu)
>                 test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
>  }
>
> +extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
> +
>  struct sys_reg_params;
>  struct sys_reg_desc;
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index b96662029fb1..d5837ed0077c 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -14,6 +14,288 @@
>
>  #include "trace.h"
>
> +enum trap_behaviour {
> +       BEHAVE_HANDLE_LOCALLY   =3D 0,
> +       BEHAVE_FORWARD_READ     =3D BIT(0),
> +       BEHAVE_FORWARD_WRITE    =3D BIT(1),
> +       BEHAVE_FORWARD_ANY      =3D BEHAVE_FORWARD_READ | BEHAVE_FORWARD_=
WRITE,
> +};
> +
> +struct trap_bits {
> +       const enum vcpu_sysreg          index;
> +       const enum trap_behaviour       behaviour;
> +       const u64                       value;
> +       const u64                       mask;
> +};
> +
> +/* Coarse Grained Trap definitions */
> +enum cgt_group_id {
> +       /* Indicates no coarse trap control */
> +       __RESERVED__,
> +
> +       /*
> +        * The first batch of IDs denote coarse trapping that are used
> +        * on their own instead of being part of a combination of
> +        * trap controls.
> +        */
> +
> +       /*
> +        * Anything after this point is a combination of coarse trap
> +        * controls, which must all be evaluated to decide what to do.
> +        */
> +       __MULTIPLE_CONTROL_BITS__,
> +
> +       /*
> +        * Anything after this point requires a callback evaluating a
> +        * complex trap condition. Hopefully we'll never need this...
> +        */
> +       __COMPLEX_CONDITIONS__,
> +
> +       /* Must be last */
> +       __NR_CGT_GROUP_IDS__
> +};
> +
> +static const struct trap_bits coarse_trap_bits[] =3D {
> +};
> +
> +#define MCB(id, ...)                                           \
> +       [id - __MULTIPLE_CONTROL_BITS__]        =3D               \
> +               (const enum cgt_group_id[]){                    \
> +               __VA_ARGS__, __RESERVED__                       \
> +               }
> +
> +static const enum cgt_group_id *coarse_control_combo[] =3D {
> +};
> +
> +typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *=
);
> +
> +#define CCC(id, fn)                            \
> +       [id - __COMPLEX_CONDITIONS__] =3D fn
> +
> +static const complex_condition_check ccc[] =3D {
> +};
> +
> +/*
> + * Bit assignment for the trap controls. We use a 64bit word with the
> + * following layout for each trapped sysreg:
> + *
> + * [9:0]       enum cgt_group_id (10 bits)
> + * [62:10]     Unused (53 bits)
> + * [63]                RES0 - Must be zero, as lost on insertion in the =
xarray
> + */
> +#define TC_CGT_BITS    10
> +
> +union trap_config {
> +       u64     val;
> +       struct {
> +               unsigned long   cgt:TC_CGT_BITS; /* Coarse Grained Trap i=
d */
> +               unsigned long   unused:53;       /* Unused, should be zer=
o */
> +               unsigned long   mbz:1;           /* Must Be Zero */
> +       };
> +};
> +
> +struct encoding_to_trap_config {
> +       const u32                       encoding;
> +       const u32                       end;
> +       const union trap_config         tc;
> +       const unsigned int              line;
> +};
> +
> +#define SR_RANGE_TRAP(sr_start, sr_end, trap_id)                       \
> +       {                                                               \
> +               .encoding       =3D sr_start,                            =
 \
> +               .end            =3D sr_end,                              =
 \
> +               .tc             =3D {                                    =
 \
> +                       .cgt            =3D trap_id,                     =
 \
> +               },                                                      \
> +               .line =3D __LINE__,                                      =
 \
> +       }
> +
> +#define SR_TRAP(sr, trap_id)           SR_RANGE_TRAP(sr, sr, trap_id)
> +
> +/*
> + * Map encoding to trap bits for exception reported with EC=3D0x18.
> + * These must only be evaluated when running a nested hypervisor, but
> + * that the current context is not a hypervisor context. When the
> + * trapped access matches one of the trap controls, the exception is
> + * re-injected in the nested hypervisor.
> + */
> +static const struct encoding_to_trap_config encoding_to_cgt[] __initcons=
t =3D {
> +};
> +
> +static DEFINE_XARRAY(sr_forward_xa);
> +
> +static union trap_config get_trap_config(u32 sysreg)
> +{
> +       return (union trap_config) {
> +               .val =3D xa_to_value(xa_load(&sr_forward_xa, sysreg)),
> +       };
> +}
> +
> +static __init void print_nv_trap_error(const struct encoding_to_trap_con=
fig *tc,
> +                                      const char *type, int err)
> +{
> +       kvm_err("%s line %d encoding range "
> +               "(%d, %d, %d, %d, %d) - (%d, %d, %d, %d, %d) (err=3D%d)\n=
",
> +               type, tc->line,
> +               sys_reg_Op0(tc->encoding), sys_reg_Op1(tc->encoding),
> +               sys_reg_CRn(tc->encoding), sys_reg_CRm(tc->encoding),
> +               sys_reg_Op2(tc->encoding),
> +               sys_reg_Op0(tc->end), sys_reg_Op1(tc->end),
> +               sys_reg_CRn(tc->end), sys_reg_CRm(tc->end),
> +               sys_reg_Op2(tc->end),
> +               err);
> +}
> +
> +int __init populate_nv_trap_config(void)
> +{
> +       int ret =3D 0;
> +
> +       BUILD_BUG_ON(sizeof(union trap_config) !=3D sizeof(void *));
> +       BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
> +
> +       for (int i =3D 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
> +               const struct encoding_to_trap_config *cgt =3D &encoding_t=
o_cgt[i];
> +               void *prev;
> +
> +               if (cgt->tc.val & BIT(63)) {
> +                       kvm_err("CGT[%d] has MBZ bit set\n", i);
> +                       ret =3D -EINVAL;
> +               }
> +
> +               if (cgt->encoding !=3D cgt->end) {
> +                       prev =3D xa_store_range(&sr_forward_xa,
> +                                             cgt->encoding, cgt->end,
> +                                             xa_mk_value(cgt->tc.val),
> +                                             GFP_KERNEL);
> +               } else {
> +                       prev =3D xa_store(&sr_forward_xa, cgt->encoding,
> +                                       xa_mk_value(cgt->tc.val), GFP_KER=
NEL);
> +                       if (prev && !xa_is_err(prev)) {
> +                               ret =3D -EINVAL;
> +                               print_nv_trap_error(cgt, "Duplicate CGT",=
 ret);
> +                       }
> +               }
> +
> +               if (xa_is_err(prev)) {
> +                       ret =3D xa_err(prev);
> +                       print_nv_trap_error(cgt, "Failed CGT insertion", =
ret);
> +               }
> +       }
> +
> +       kvm_info("nv: %ld coarse grained trap handlers\n",
> +                ARRAY_SIZE(encoding_to_cgt));
> +
> +       for (int id =3D __MULTIPLE_CONTROL_BITS__; id < __COMPLEX_CONDITI=
ONS__; id++) {
> +               const enum cgt_group_id *cgids;
> +
> +               cgids =3D coarse_control_combo[id - __MULTIPLE_CONTROL_BI=
TS__];
> +
> +               for (int i =3D 0; cgids[i] !=3D __RESERVED__; i++) {
> +                       if (cgids[i] >=3D __MULTIPLE_CONTROL_BITS__) {
> +                               kvm_err("Recursive MCB %d/%d\n", id, cgid=
s[i]);
> +                               ret =3D -EINVAL;
> +                       }
> +               }
> +       }
> +
> +       if (ret)
> +               xa_destroy(&sr_forward_xa);
> +
> +       return ret;
> +}
> +
> +static enum trap_behaviour get_behaviour(struct kvm_vcpu *vcpu,
> +                                        const struct trap_bits *tb)
> +{
> +       enum trap_behaviour b =3D BEHAVE_HANDLE_LOCALLY;
> +       u64 val;
> +
> +       val =3D __vcpu_sys_reg(vcpu, tb->index);
> +       if ((val & tb->mask) =3D=3D tb->value)
> +               b |=3D tb->behaviour;
> +
> +       return b;
> +}
> +
> +static enum trap_behaviour __compute_trap_behaviour(struct kvm_vcpu *vcp=
u,
> +                                                   const enum cgt_group_=
id id,
> +                                                   enum trap_behaviour b=
)
> +{
> +       switch (id) {
> +               const enum cgt_group_id *cgids;
> +
> +       case __RESERVED__ ... __MULTIPLE_CONTROL_BITS__ - 1:
> +               if (likely(id !=3D __RESERVED__))
> +                       b |=3D get_behaviour(vcpu, &coarse_trap_bits[id])=
;
> +               break;
> +       case __MULTIPLE_CONTROL_BITS__ ... __COMPLEX_CONDITIONS__ - 1:
> +               /* Yes, this is recursive. Don't do anything stupid. */
> +               cgids =3D coarse_control_combo[id - __MULTIPLE_CONTROL_BI=
TS__];
> +               for (int i =3D 0; cgids[i] !=3D __RESERVED__; i++)
> +                       b |=3D __compute_trap_behaviour(vcpu, cgids[i], b=
);
> +               break;
> +       default:
> +               if (ARRAY_SIZE(ccc))
> +                       b |=3D ccc[id -  __COMPLEX_CONDITIONS__](vcpu);
> +               break;
> +       }
> +
> +       return b;
> +}
> +
> +static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
> +                                                 const union trap_config=
 tc)
> +{
> +       enum trap_behaviour b =3D BEHAVE_HANDLE_LOCALLY;
> +
> +       return __compute_trap_behaviour(vcpu, tc.cgt, b);
> +}
> +
> +bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
> +{
> +       union trap_config tc;
> +       enum trap_behaviour b;
> +       bool is_read;
> +       u32 sysreg;
> +       u64 esr;
> +
> +       if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +               return false;
> +
> +       esr =3D kvm_vcpu_get_esr(vcpu);
> +       sysreg =3D esr_sys64_to_sysreg(esr);
> +       is_read =3D (esr & ESR_ELx_SYS64_ISS_DIR_MASK) =3D=3D ESR_ELx_SYS=
64_ISS_DIR_READ;
> +
> +       tc =3D get_trap_config(sysreg);
> +
> +       /*
> +        * A value of 0 for the whole entry means that we know nothing
> +        * for this sysreg, and that it cannot be re-injected into the
> +        * nested hypervisor. In this situation, let's cut it short.
> +        *
> +        * Note that ultimately, we could also make use of the xarray
> +        * to store the index of the sysreg in the local descriptor
> +        * array, avoiding another search... Hint, hint...
> +        */
> +       if (!tc.val)
> +               return false;
> +
> +       b =3D compute_trap_behaviour(vcpu, tc);
> +
> +       if (((b & BEHAVE_FORWARD_READ) && is_read) ||
> +           ((b & BEHAVE_FORWARD_WRITE) && !is_read))
> +               goto inject;
> +
> +       return false;
> +
> +inject:
> +       trace_kvm_forward_sysreg_trap(vcpu, sysreg, is_read);
> +
> +       kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +       return true;
> +}
> +
>  static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64=
 spsr)
>  {
>         u64 mode =3D spsr & PSR_MODE_MASK;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f5baaa508926..9556896311db 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3177,6 +3177,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>
>         trace_kvm_handle_sys_reg(esr);
>
> +       if (__check_nv_sr_forward(vcpu))
> +               return 1;
> +
>         params =3D esr_sys64_to_params(esr);
>         params.regval =3D vcpu_get_reg(vcpu, Rt);
>
> @@ -3594,5 +3597,8 @@ int __init kvm_sys_reg_table_init(void)
>         if (!first_idreg)
>                 return -EINVAL;
>
> +       if (kvm_get_mode() =3D=3D KVM_MODE_NV)
> +               return populate_nv_trap_config();
> +
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 6ce5c025218d..8ad53104934d 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -364,6 +364,32 @@ TRACE_EVENT(kvm_inject_nested_exception,
>                   __entry->hcr_el2)
>  );
>
> +TRACE_EVENT(kvm_forward_sysreg_trap,
> +           TP_PROTO(struct kvm_vcpu *vcpu, u32 sysreg, bool is_read),
> +           TP_ARGS(vcpu, sysreg, is_read),
> +
> +           TP_STRUCT__entry(
> +               __field(u64,    pc)
> +               __field(u32,    sysreg)
> +               __field(bool,   is_read)
> +           ),
> +
> +           TP_fast_assign(
> +               __entry->pc =3D *vcpu_pc(vcpu);
> +               __entry->sysreg =3D sysreg;
> +               __entry->is_read =3D is_read;
> +           ),
> +
> +           TP_printk("%llx %c (%d,%d,%d,%d,%d)",
> +                     __entry->pc,
> +                     __entry->is_read ? 'R' : 'W',
> +                     sys_reg_Op0(__entry->sysreg),
> +                     sys_reg_Op1(__entry->sysreg),
> +                     sys_reg_CRn(__entry->sysreg),
> +                     sys_reg_CRm(__entry->sysreg),
> +                     sys_reg_Op2(__entry->sysreg))
> +);
> +
>  #endif /* _TRACE_ARM_ARM64_KVM_H */
>
>  #undef TRACE_INCLUDE_PATH
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
