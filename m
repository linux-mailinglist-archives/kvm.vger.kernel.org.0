Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D2316BB53
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 08:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbgBYHze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 02:55:34 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40221 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgBYHze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 02:55:34 -0500
Received: by mail-oi1-f195.google.com with SMTP id a142so11684126oii.7;
        Mon, 24 Feb 2020 23:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDTNmuWjuAHtvuVbjdMd3VLuF/qKiWw9E7XEtWsc/5E=;
        b=m70wOcNTGxbblYPvO5tT6VYYHlU5Fy/HWUhb7ItZhaCTCBjaZApb/9e6oIOdnuxwzF
         kt/tStmjYohgve5ADUmeQ+T/bVHOSPUFUia1CxHuNRTKUZRL69Bv0f/qCfACVOSKuvVS
         IjjGAtQ80wn8d9O9jbpMcHJX5LW+dEflPmzyEZ02lIuot72DtKES5jAjZZ+EXpZzybzD
         yN9WGAvMd2EekPscMzOx4OULdlrtZg/x6VOpWs+eBDN2o8toLcVtv+z812bwtBIP4I0U
         0kShLU1lIabMdISrzvPtdJjVbeiVmxm4ZyuvKFUMA8Ok5IArhmRez9FsdjrjbZQgy4cr
         qJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDTNmuWjuAHtvuVbjdMd3VLuF/qKiWw9E7XEtWsc/5E=;
        b=rszsOt8LGlr80dtSDe3CVDSwSM7osIs8KiH1Zm1u2K62FIr25CH531jlBiIxstlwZM
         ALVAMNhyds5cPS3hYcfhoTfAVQoJKj/xwvJ8xigx6ePFohBbH8oA2FmHTNsId2CZIJUN
         tRRaycD6OiKKkmTzqKlE0aQlsP3bV2btyKB9H7vwoZ8+vEzB39ORhLtVj0amkPc13DPV
         8fsf11HfRkSgd+NuzvGnsMF1hPHJC57ag3OoN13v7dA00A3fbGwjMeTDCtNQjL4JvnBj
         /co910C6vxS3nWJEyRnlhNpkyJYmpglpL6PuhnHa0CKRQ+CMNqKwBMNKIhhm8orySyhu
         CCKQ==
X-Gm-Message-State: APjAAAVOv3is8/+0HHzzU5bDQcXWgitRpSN7gKoquqwyClut3n2nU3hd
        XeCLdaKMQQoTSx53Qp1uX+K3O27ldY4mK6If4E+uc3ZP
X-Google-Smtp-Source: APXvYqzj21h0ZL8pb+IscgvCYutp8SLIikMEv5yDF7wzQtTtYz0/RXLNbHjhBPxX0S+5sbh5rp1RAQpDs7mS5zG80fw=
X-Received: by 2002:aca:44d7:: with SMTP id r206mr2474277oia.33.1582617331043;
 Mon, 24 Feb 2020 23:55:31 -0800 (PST)
MIME-Version: 1.0
References: <1582022829-27032-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1582022829-27032-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 25 Feb 2020 15:55:20 +0800
Message-ID: <CANRm+CxyWGExs=OxD13vJcZS2NUBEXt2ppUrcLX=h0O-RpJRgg@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Recalculate apic map in batch
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping,
On Tue, 18 Feb 2020 at 18:49, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> In the vCPU reset and set APIC_BASE MSR path, the apic map will be recalculated
> several times, each time it will consume 10+ us observed by ftrace in my
> non-overcommit environment since the expensive memory allocate/mutex/rcu etc
> operations. This patch optimizes it by recaluating apic map in batch, I hope
> this can benefit the serverless scenario which can frequently create/destroy
> VMs.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 74 ++++++++++++++++++++++++++++++++++------------------
>  arch/x86/kvm/lapic.h |  3 ++-
>  arch/x86/kvm/x86.c   |  3 ++-
>  3 files changed, 53 insertions(+), 27 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index afcd30d..71f843a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -164,7 +164,7 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
>         kvfree(map);
>  }
>
> -static void recalculate_apic_map(struct kvm *kvm)
> +void kvm_recalculate_apic_map(struct kvm *kvm)
>  {
>         struct kvm_apic_map *new, *old = NULL;
>         struct kvm_vcpu *vcpu;
> @@ -244,9 +244,10 @@ static void recalculate_apic_map(struct kvm *kvm)
>         kvm_make_scan_ioapic_request(kvm);
>  }
>
> -static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
> +static inline bool apic_set_spiv(struct kvm_lapic *apic, u32 val)
>  {
>         bool enabled = val & APIC_SPIV_APIC_ENABLED;
> +       bool need_recal = false;
>
>         kvm_lapic_set_reg(apic, APIC_SPIV, val);
>
> @@ -257,20 +258,20 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
>                 else
>                         static_key_slow_inc(&apic_sw_disabled.key);
>
> -               recalculate_apic_map(apic->vcpu->kvm);
> +               need_recal = true;
>         }
> +
> +       return need_recal;
>  }
>
>  static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
>  {
>         kvm_lapic_set_reg(apic, APIC_ID, id << 24);
> -       recalculate_apic_map(apic->vcpu->kvm);
>  }
>
>  static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
>  {
>         kvm_lapic_set_reg(apic, APIC_LDR, id);
> -       recalculate_apic_map(apic->vcpu->kvm);
>  }
>
>  static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
> @@ -286,7 +287,6 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
>
>         kvm_lapic_set_reg(apic, APIC_ID, id);
>         kvm_lapic_set_reg(apic, APIC_LDR, ldr);
> -       recalculate_apic_map(apic->vcpu->kvm);
>  }
>
>  static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
> @@ -1882,14 +1882,16 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
>  int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  {
>         int ret = 0;
> +       bool need_recal = false;
>
>         trace_kvm_apic_write(reg, val);
>
>         switch (reg) {
>         case APIC_ID:           /* Local APIC ID */
> -               if (!apic_x2apic_mode(apic))
> +               if (!apic_x2apic_mode(apic)) {
>                         kvm_apic_set_xapic_id(apic, val >> 24);
> -               else
> +                       need_recal = true;
> +               } else
>                         ret = 1;
>                 break;
>
> @@ -1903,16 +1905,17 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>                 break;
>
>         case APIC_LDR:
> -               if (!apic_x2apic_mode(apic))
> +               if (!apic_x2apic_mode(apic)) {
>                         kvm_apic_set_ldr(apic, val & APIC_LDR_MASK);
> -               else
> +                       need_recal = true;
> +               } else
>                         ret = 1;
>                 break;
>
>         case APIC_DFR:
>                 if (!apic_x2apic_mode(apic)) {
>                         kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
> -                       recalculate_apic_map(apic->vcpu->kvm);
> +                       need_recal = true;
>                 } else
>                         ret = 1;
>                 break;
> @@ -1921,7 +1924,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>                 u32 mask = 0x3ff;
>                 if (kvm_lapic_get_reg(apic, APIC_LVR) & APIC_LVR_DIRECTED_EOI)
>                         mask |= APIC_SPIV_DIRECTED_EOI;
> -               apic_set_spiv(apic, val & mask);
> +               if (apic_set_spiv(apic, val & mask))
> +                       need_recal = true;
>                 if (!(val & APIC_SPIV_APIC_ENABLED)) {
>                         int i;
>                         u32 lvt_val;
> @@ -2018,6 +2022,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>                 break;
>         }
>
> +       if (need_recal)
> +               kvm_recalculate_apic_map(apic->vcpu->kvm);
> +
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_lapic_reg_write);
> @@ -2143,10 +2150,11 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
>         return (tpr & 0xf0) >> 4;
>  }
>
> -void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
> +bool kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  {
>         u64 old_value = vcpu->arch.apic_base;
>         struct kvm_lapic *apic = vcpu->arch.apic;
> +       bool need_recal = false;
>
>         if (!apic)
>                 value |= MSR_IA32_APICBASE_BSP;
> @@ -2157,7 +2165,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>                 kvm_update_cpuid(vcpu);
>
>         if (!apic)
> -               return;
> +               return need_recal;
>
>         /* update jump label if enable bit changes */
>         if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE) {
> @@ -2166,12 +2174,14 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>                         static_key_slow_dec_deferred(&apic_hw_disabled);
>                 } else {
>                         static_key_slow_inc(&apic_hw_disabled.key);
> -                       recalculate_apic_map(vcpu->kvm);
>                 }
> +               need_recal = true;
>         }
>
> -       if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
> +       if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
>                 kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> +               need_recal = true;
> +       }
>
>         if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
>                 kvm_x86_ops->set_virtual_apic_mode(vcpu);
> @@ -2182,6 +2192,8 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>         if ((value & MSR_IA32_APICBASE_ENABLE) &&
>              apic->base_address != APIC_DEFAULT_PHYS_BASE)
>                 pr_warn_once("APIC base relocation is unsupported by KVM");
> +
> +       return need_recal;
>  }
>
>  void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
> @@ -2203,6 +2215,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
>         int i;
> +       bool need_recal = false;
>
>         if (!apic)
>                 return;
> @@ -2214,6 +2227,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>                 kvm_lapic_set_base(vcpu, APIC_DEFAULT_PHYS_BASE |
>                                          MSR_IA32_APICBASE_ENABLE);
>                 kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
> +               need_recal = true;
>         }
>         kvm_apic_set_version(apic->vcpu);
>
> @@ -2227,10 +2241,13 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>         apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>
>         kvm_lapic_set_reg(apic, APIC_DFR, 0xffffffffU);
> -       apic_set_spiv(apic, 0xff);
> +       if (apic_set_spiv(apic, 0xff))
> +               need_recal = true;
>         kvm_lapic_set_reg(apic, APIC_TASKPRI, 0);
> -       if (!apic_x2apic_mode(apic))
> +       if (!apic_x2apic_mode(apic)) {
>                 kvm_apic_set_ldr(apic, 0);
> +               need_recal = true;
> +       }
>         kvm_lapic_set_reg(apic, APIC_ESR, 0);
>         kvm_lapic_set_reg(apic, APIC_ICR, 0);
>         kvm_lapic_set_reg(apic, APIC_ICR2, 0);
> @@ -2246,8 +2263,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>         update_divide_count(apic);
>         atomic_set(&apic->lapic_timer.pending, 0);
>         if (kvm_vcpu_is_bsp(vcpu))
> -               kvm_lapic_set_base(vcpu,
> -                               vcpu->arch.apic_base | MSR_IA32_APICBASE_BSP);
> +               need_recal = kvm_lapic_set_base(vcpu,
> +                                       vcpu->arch.apic_base | MSR_IA32_APICBASE_BSP);
>         vcpu->arch.pv_eoi.msr_val = 0;
>         apic_update_ppr(apic);
>         if (vcpu->arch.apicv_active) {
> @@ -2258,6 +2275,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>
>         vcpu->arch.apic_arb_prio = 0;
>         vcpu->arch.apic_attention = 0;
> +
> +       if (need_recal)
> +               kvm_recalculate_apic_map(vcpu->kvm);
>  }
>
>  /*
> @@ -2478,18 +2498,22 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
>         int r;
> +       bool need_recal = false;
>
> -
> -       kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
> +       need_recal = kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
>         /* set SPIV separately to get count of SW disabled APICs right */
> -       apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
> +       if (apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV))))
> +               need_recal = true;
>
>         r = kvm_apic_state_fixup(vcpu, s, true);
> -       if (r)
> +       if (r) {
> +               if (need_recal)
> +                       kvm_recalculate_apic_map(vcpu->kvm);
>                 return r;
> +       }
>         memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
>
> -       recalculate_apic_map(vcpu->kvm);
> +       kvm_recalculate_apic_map(vcpu->kvm);
>         kvm_apic_set_version(vcpu);
>
>         apic_update_ppr(apic);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index ec6fbfe..58c07ad 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -76,8 +76,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
>  u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
>  void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
>  void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
> -void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
> +bool kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
>  u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
> +void kvm_recalculate_apic_map(struct kvm *kvm);
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu);
>  int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val);
>  int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 79bc995..e961e65 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -349,7 +349,8 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                         return 1;
>         }
>
> -       kvm_lapic_set_base(vcpu, msr_info->data);
> +       if (kvm_lapic_set_base(vcpu, msr_info->data))
> +               kvm_recalculate_apic_map(vcpu->kvm);
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_apic_base);
> --
> 2.7.4
>
