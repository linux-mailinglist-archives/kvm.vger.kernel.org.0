Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E94B3A0687
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhFHWBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 18:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhFHWBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 18:01:18 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BD7C061574
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 14:59:09 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id d2so24853839ljj.11
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ZFSAFUoZhRjqmcFD1X1AF3Fs3bEfXF1+VtTxZPdYN4=;
        b=LRuc+x3duDo1MSzlf0phtIM80YhY4IBNDC1DzyBLF7rqK1jKodyzRlLlTPkulLdeyT
         R1ujGzq6TZBEzDZj7EMP8hz78Qn3Doarg1GlGhcSDk4qk4HAr9amEN1qGUWYMEcmBlZS
         5XktSkjCHlZp8ysYCRaix3DF2PKeG0X3WANtHL0NJXF8IRwwKGpJwJLD2gbayAxjtqjp
         0wkeDf5sxTc6dzMwsrHqYnPLw49fkiJIk08+qU6zgb9Bp5sLderb+SW+ZPyHLOrE1zfF
         7Jc6ZC3UjHRIfZGJ72w9Ta2LAsl1qKbQI0jl54Po/oIpjNWDZ8E28Q15iE8d0kZPkcsQ
         uF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ZFSAFUoZhRjqmcFD1X1AF3Fs3bEfXF1+VtTxZPdYN4=;
        b=fiXJPqot0f5xAkdPxmLlgXGe8h+/CmSyjZ0dlpD0YKyP6APEd2HLBFSsAAScrm3jxj
         CIeElsyIvMG3smcFe9ZUr4riY7txfrClOof7xGK0igdpUiVTxFufq9g5+1UwT+ZQC/Fv
         MtR3OyWV3AFGATKtBn0/8VDWF7s6r/YgqiF5alEYbuXutb+9qNK9AFGzXQPnzFbKSaj/
         tkHmjRyznimYioDo2+EAoylF+yqonALAeQk2JQ7hYgbcP1oDB5YbDYz/A3qFS7k7lfZ1
         1PWBDNEShcv3usI/HbO50gHZQNySqPCqEw0mqX4ztPcM9+McQISuI5qjXN5HnbwK+5jr
         M9ng==
X-Gm-Message-State: AOAM5330NSG0i3BuUaQ3fJ8SuNdiHjKSJoZUuRj+jIRmiMH9Mi9I9D1e
        FHL7u1FXLnAuWrS0nWXuuiCBKk5/Wa7iOZHlPTjJrrsax+Q=
X-Google-Smtp-Source: ABdhPJwq6HY3eatbSUSnOMj0+yapEs130c7m1vNBcOWvVOh2Jo2SyJ6OjBBFtcm8q5oc35OwbWFNUPWOajp2MPykQXA=
X-Received: by 2002:a05:651c:304:: with SMTP id a4mr19888649ljp.331.1623189546629;
 Tue, 08 Jun 2021 14:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com> <20210608214742.1897483-5-oupton@google.com>
In-Reply-To: <20210608214742.1897483-5-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 8 Jun 2021 16:58:55 -0500
Message-ID: <CAOQ_QsiEwERCbFp3La1ZFtfR=O2-tArCkgPKmbmdDWx3x0rT5A@mail.gmail.com>
Subject: Re: [PATCH 04/10] KVM: arm64: Add userspace control of the guest's
 physical counter
To:     kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 8, 2021 at 4:48 PM Oliver Upton <oupton@google.com> wrote:
>
> ARMv8.6 adds an extension to the architecture providing hypervisors with
> more extensive controls of the guest's counters. A particularly
> interesting control is CNTPOFF_EL2, a fixed offset subtracted from the
> physical counter value to derive the guest's value. VMMs that live
> migrate their guests may be particularly interested in this feature in
> order to provide a consistent view of the physical counter across live
> migrations.
>
> In the interim, KVM can emulate this behavior by simply enabling traps
> on CNTPCT_EL0 and subtracting an offset.
>
> Add a new field to kvm_system_counter_state allowing a VMM to request an
> offset to the physical counter. If this offset is nonzero, enable traps
> on CNTPCT_EL0. Emulate guest reads to the register in the fast path to
> keep counter reads reasonably performant, avoiding a full exit from the
> guest.
>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  1 +
>  arch/arm64/include/asm/sysreg.h         |  1 +
>  arch/arm64/include/uapi/asm/kvm.h       |  9 +++-
>  arch/arm64/kvm/arch_timer.c             | 66 +++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 31 ++++++++++++
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c      | 16 ++++--
>  6 files changed, 117 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 31107d5e61af..a3abafcea328 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -200,6 +200,7 @@ enum vcpu_sysreg {
>         SP_EL1,
>         SPSR_EL1,
>
> +       CNTPOFF_EL2,
>         CNTVOFF_EL2,
>         CNTV_CVAL_EL0,
>         CNTV_CTL_EL0,
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 65d15700a168..193da426690a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -505,6 +505,7 @@
>  #define SYS_AMEVCNTR0_MEM_STALL                SYS_AMEVCNTR0_EL0(3)
>
>  #define SYS_CNTFRQ_EL0                 sys_reg(3, 3, 14, 0, 0)
> +#define SYS_CNTPCT_EL0                 sys_reg(3, 3, 14, 0, 1)
>
>  #define SYS_CNTP_TVAL_EL0              sys_reg(3, 3, 14, 2, 0)
>  #define SYS_CNTP_CTL_EL0               sys_reg(3, 3, 14, 2, 1)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index d3987089c524..ee709e2f0292 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -184,6 +184,8 @@ struct kvm_vcpu_events {
>         __u32 reserved[12];
>  };
>
> +#define KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET   (1ul << 0)
> +
>  /* for KVM_{GET,SET}_SYSTEM_COUNTER_STATE */
>  struct kvm_system_counter_state {
>         /* indicates what fields are valid in the structure */
> @@ -191,7 +193,12 @@ struct kvm_system_counter_state {
>         __u32 pad;
>         /* guest counter-timer offset, relative to host cntpct_el0 */
>         __u64 cntvoff;
> -       __u64 rsvd[7];
> +       /*
> +        * Guest physical counter-timer offset, relative to host cntpct_el0.
> +        * Valid when KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET is set.
> +        */
> +       __u64 cntpoff;
> +       __u64 rsvd[6];
>  };
>
>  /* If you need to interpret the index values, here is the key: */
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 955a7a183362..a74642d1515f 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -50,6 +50,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
>  static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>                               struct arch_timer_context *timer,
>                               enum kvm_arch_timer_regs treg);
> +static bool kvm_timer_emulation_required(struct arch_timer_context *ctx);
>
>  u32 timer_get_ctl(struct arch_timer_context *ctxt)
>  {
> @@ -86,6 +87,8 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
>         struct kvm_vcpu *vcpu = ctxt->vcpu;
>
>         switch(arch_timer_ctx_index(ctxt)) {
> +       case TIMER_PTIMER:
> +               return __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
>         case TIMER_VTIMER:
>                 return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
>         default:
> @@ -130,6 +133,9 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>         struct kvm_vcpu *vcpu = ctxt->vcpu;
>
>         switch(arch_timer_ctx_index(ctxt)) {
> +       case TIMER_PTIMER:
> +               __vcpu_sys_reg(vcpu, CNTPOFF_EL2) = offset;
> +               break;
>         case TIMER_VTIMER:
>                 __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
>                 break;
> @@ -145,7 +151,7 @@ u64 kvm_phys_timer_read(void)
>
>  static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
>  {
> -       if (has_vhe()) {
> +       if (has_vhe() && !kvm_timer_emulation_required(vcpu_ptimer(vcpu))) {
>                 map->direct_vtimer = vcpu_vtimer(vcpu);
>                 map->direct_ptimer = vcpu_ptimer(vcpu);
>                 map->emul_ptimer = NULL;
> @@ -746,6 +752,30 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>         return 0;
>  }
>
> +bool kvm_timer_emulation_required(struct arch_timer_context *ctx)
> +{
> +       int idx = arch_timer_ctx_index(ctx);
> +
> +       switch (idx) {
> +       /*
> +        * hardware doesn't support offsetting of the physical counter/timer.
> +        * If offsetting is requested, enable emulation of the physical
> +        * counter/timer.
> +        */
> +       case TIMER_PTIMER:
> +               return timer_get_offset(ctx);
> +       /*
> +        * Conversely, hardware does support offsetting of the virtual
> +        * counter/timer.
> +        */
> +       case TIMER_VTIMER:
> +               return false;
> +       default:
> +               WARN_ON(1);
> +               return false;
> +       }
> +}
> +
>  /* Make the updates of cntvoff for all vtimer contexts atomic */
>  static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
>  {
> @@ -1184,6 +1214,24 @@ void kvm_timer_init_vhe(void)
>         write_sysreg(val, cnthctl_el2);
>  }
>
> +static void kvm_timer_update_traps_vhe(struct kvm_vcpu *vcpu)
> +{
> +       u32 cnthctl_shift = 10;
> +       u64 val;
> +
> +       if (!kvm_timer_emulation_required(vcpu_ptimer(vcpu)))
> +               return;
> +
> +       /*
> +        * We must trap accesses to the physical counter/timer to emulate the
> +        * nonzero offset.
> +        */
> +       val = read_sysreg(cnthctl_el2);
> +       val &= ~(CNTHCTL_EL1PCEN << cnthctl_shift);
> +       val &= ~(CNTHCTL_EL1PCTEN << cnthctl_shift);
> +       write_sysreg(val, cnthctl_el2);
> +}
> +
>  static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
>  {
>         struct kvm_vcpu *vcpu;
> @@ -1260,24 +1308,36 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>         return -ENXIO;
>  }
>
> +#define KVM_SYSTEM_COUNTER_STATE_VALID_FLAG_BITS       \
> +               (KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET)
> +
>  int kvm_arm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
>                                           struct kvm_system_counter_state *state)
>  {
> -       if (state->flags)
> +       if (state->flags & ~KVM_SYSTEM_COUNTER_STATE_VALID_FLAG_BITS)
>                 return -EINVAL;
>
>         state->cntvoff = timer_get_offset(vcpu_vtimer(vcpu));
>
> +       if (state->flags & KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET)
> +               state->cntpoff = timer_get_offset(vcpu_ptimer(vcpu));
> +
>         return 0;
>  }
>
>  int kvm_arm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
>                                           struct kvm_system_counter_state *state)
>  {
> -       if (state->flags)
> +       if (state->flags & ~KVM_SYSTEM_COUNTER_STATE_VALID_FLAG_BITS)
>                 return -EINVAL;
>
>         timer_set_offset(vcpu_vtimer(vcpu), state->cntvoff);
>
> +       if (state->flags & KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET)
> +               timer_set_offset(vcpu_ptimer(vcpu), state->cntpoff);
> +
> +       if (has_vhe())
> +               kvm_timer_update_traps_vhe(vcpu);
> +
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e4a2f295a394..12ada31e12e2 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -287,6 +287,30 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>         return true;
>  }
>
> +static inline u64 __hyp_read_cntpct(struct kvm_vcpu *vcpu)
> +{
> +       return read_sysreg(cntpct_el0) - __vcpu_sys_reg(vcpu, CNTPOFF_EL2);

Question for those with much more experience on the ARM side: is there
any decent way to infer the counter bit-width to properly emulate
here? This code is problematic when migrating a narrower guest (i.e.
56-bit counter) to a wider host (say an 8.6 implementation with a
64-bit counter). Otherwise, it would seem that userspace needs to
explicitly request a counter width.

--
Thanks,
Oliver

> +}
> +
> +static inline bool __hyp_handle_counter(struct kvm_vcpu *vcpu)
> +{
> +       u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
> +       int rt = kvm_vcpu_sys_get_rt(vcpu);
> +       u64 rv;
> +
> +       switch (sysreg) {
> +       case SYS_CNTPCT_EL0:
> +               rv = __hyp_read_cntpct(vcpu);
> +               break;
> +       default:
> +               return false;
> +       }
> +
> +       vcpu_set_reg(vcpu, rt, rv);
> +       __kvm_skip_instr(vcpu);
> +       return true;
> +}
> +
>  static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
>  {
>         u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
> @@ -439,6 +463,13 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>         if (*exit_code != ARM_EXCEPTION_TRAP)
>                 goto exit;
>
> +       /*
> +        * We trap acesses to the physical counter value register (CNTPCT_EL0)
> +        * if userspace has requested a physical counter offset.
> +        */
> +       if (__hyp_handle_counter(vcpu))
> +               goto guest;
> +
>         if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
>             kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
>             handle_tx2_tvm(vcpu))
> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> index 9072e71693ba..1b8e6e47a4ea 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> @@ -35,14 +35,24 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu)
>   */
>  void __timer_enable_traps(struct kvm_vcpu *vcpu)
>  {
> -       u64 val;
> +       u64 val, cntpoff;
> +
> +       cntpoff = __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
>
>         /*
>          * Disallow physical timer access for the guest
> -        * Physical counter access is allowed
>          */
>         val = read_sysreg(cnthctl_el2);
>         val &= ~CNTHCTL_EL1PCEN;
> -       val |= CNTHCTL_EL1PCTEN;
> +
> +       /*
> +        * Disallow physical counter access for the guest if offsetting is
> +        * requested.
> +        */
> +       if (cntpoff)
> +               val &= ~CNTHCTL_EL1PCTEN;
> +       else
> +               val |= CNTHCTL_EL1PCTEN;
> +
>         write_sysreg(val, cnthctl_el2);
>  }
> --
> 2.32.0.rc1.229.g3e70b5a671-goog
>
