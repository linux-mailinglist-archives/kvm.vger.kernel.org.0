Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2961953D2CD
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 22:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348160AbiFCU1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 16:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240215AbiFCU1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 16:27:05 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756E2DE8
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 13:26:53 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id o15so9573954ljp.10
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 13:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcvcGCdo3atSRleIEYn8GV8DF1zjVp9ue+AGaGOprF4=;
        b=Oo0XXSGXmARxDF0URIr3txJLZa5wrCUfaQoFU/qqiDxoBYA+DFuZUp3b5BWfIfNVrR
         wK50IWSX0CYXoqZYvh/8AqncjOskImCOrqD0C6AQVoE2R+/rJys9IS0ydHCFycHms4H2
         RntAYu64/5X9EiIY9xkExeHtJ7vny6Q7HnxH9d7Bjt8rACfswCjYeG/8GdCsuUTsTMnZ
         FazBqbSL303HRocJOxBMXp3Sz/qVHfkhdobCtkpyUAf/B6ckNPpeaEENqeMl40SUJblt
         1KWIz4sMGZ0fbA2cymhwJVdyviTG1gOl0fdJH+VsRkzOp+iyiW3wWOtOQ/zHhMbU0/Vb
         l7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcvcGCdo3atSRleIEYn8GV8DF1zjVp9ue+AGaGOprF4=;
        b=uhvVS6QBk0N/NgPlsMmsFx4D6CtoXejQw/zMXYISCVv+mYgWu3F5JR8fTb5X+UswRU
         E3+eGd9hs82XjcCZtV/gC8peqoy2h2/ilc2x8pmbBMDoIbV1qUdJpyrjploTapMHsmEJ
         5xN/82vcetZRKqaplKSXO9Jn4QOi7GRpT8J/lQOB6cH1md848YspnVRRWaUffxKKUwC3
         gVxaqxuqGr4cV9NkykgBrbibpqlMQiCjzWkaWIUFphIhUQ65X7SF9gwiA+lP2He2dY4W
         eojabrnmMrz5bGEBCahIaPNvpN1vYse/j4MHe3qfPl1hq/fhkUorzNOS+yAFyMpicxR7
         eBVw==
X-Gm-Message-State: AOAM531mSHe8L6RPNWNaEhu/BOfageM8OMkFirrP8O3qxOhw67TZjbwp
        l1ERejpwbmAlq2wL54U8I9CEx+7bosvUJPRZ0byEmg==
X-Google-Smtp-Source: ABdhPJzz3vZrda2FwtR2nRxz6Ky3Tu0QRIh9pBOdemXRavpGtSDe7Jzx+1mi8XmH2tJBcPQKsq2nVy6ON1Pz7L3AG9s=
X-Received: by 2002:a2e:84cd:0:b0:255:4f69:db36 with SMTP id
 q13-20020a2e84cd000000b002554f69db36mr15354080ljh.223.1654288011373; Fri, 03
 Jun 2022 13:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220520173638.94324-1-juew@google.com> <20220520173638.94324-5-juew@google.com>
In-Reply-To: <20220520173638.94324-5-juew@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 3 Jun 2022 13:26:24 -0700
Message-ID: <CALzav=eUWqzxp9OhXXuPUbGErZxCUf3ZZKfMkgSCanDyMsJGdA@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] KVM: x86: Add Corrected Machine Check Interrupt
 (CMCI) emulation to lapic.
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 10:36 AM Jue Wang <juew@google.com> wrote:
>
> This patch adds the handling of APIC_LVTCMCI, conditioned on whether the
> vCPU has set MCG_CMCI_P in MCG_CAP register.
>
> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/lapic.c | 40 +++++++++++++++++++++++++++++++++-------
>  arch/x86/kvm/lapic.h |  3 ++-
>  2 files changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index db12d2ef1aef..e2186a7c0eed 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -27,6 +27,7 @@
>  #include <linux/math64.h>
>  #include <linux/slab.h>
>  #include <asm/processor.h>
> +#include <asm/mce.h>
>  #include <asm/msr.h>
>  #include <asm/page.h>
>  #include <asm/current.h>
> @@ -398,14 +399,26 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
>         return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
>  }
>
> +static inline bool kvm_is_cmci_supported(struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.mcg_cap & MCG_CMCI_P;
> +}
> +
> +static inline int kvm_apic_get_nr_lvt_entries(struct kvm_lapic *apic)
> +{
> +       return KVM_APIC_MAX_NR_LVT_ENTRIES - !kvm_is_cmci_supported(apic->vcpu);
> +}

Suggesting computing the number of LVT entries once as part of
KVM_X86_SETUP_MCE and storing it in struct kvm_lapic (e.g.
apic->nr_lvt_entries).

I would also suggest replacing kvm_is_cmci_supported() with
kvm_lapic_lvt_cmci_supported(), which checks if the local APIC
supports the LVT CMCI register, rather than looking at mcg_cap. I
think that will result in more readable code because it more directly
checks that the local APIC supports the LVT entry we care about.

> +
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
> -       u32 v = APIC_VERSION | ((KVM_APIC_MAX_NR_LVT_ENTRIES - 1) << 16);
> +       u32 v = 0;
>
>         if (!lapic_in_kernel(vcpu))
>                 return;
>
> +       v = APIC_VERSION | ((kvm_apic_get_nr_lvt_entries(apic) - 1) << 16);
> +
>         /*
>          * KVM emulates 82093AA datasheet (with in-kernel IOAPIC implementation)
>          * which doesn't have EOI register; Some buggy OSes (e.g. Windows with
> @@ -425,7 +438,8 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
>         [LVT_PERFORMANCE_COUNTER] = LVT_MASK | APIC_MODE_MASK,
>         [LVT_LINT0] = LINT_MASK,
>         [LVT_LINT1] = LINT_MASK,
> -       [LVT_ERROR] = LVT_MASK
> +       [LVT_ERROR] = LVT_MASK,
> +       [LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
>  };
>
>  static int find_highest_vector(void *bitmap)
> @@ -1445,6 +1459,9 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>                 APIC_REG_MASK(APIC_TMCCT) |
>                 APIC_REG_MASK(APIC_TDCR);
>
> +       if (kvm_is_cmci_supported(apic->vcpu))
> +               valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
> +
>         /*
>          * ARBPRI and ICR2 are not valid in x2APIC mode.  WARN if KVM reads ICR
>          * in x2APIC mode as it's an 8-byte register in x2APIC and needs to be
> @@ -2083,12 +2100,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>                 apic_set_spiv(apic, val & mask);
>                 if (!(val & APIC_SPIV_APIC_ENABLED)) {
>                         int i;
> -                       u32 lvt_val;
>
> -                       for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
> -                               lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
> +                       for (i = 0; i < kvm_apic_get_nr_lvt_entries(apic); i++) {
>                                 kvm_lapic_set_reg(apic, APIC_LVTx(i),
> -                                            lvt_val | APIC_LVT_MASKED);
> +                                       kvm_lapic_get_reg(apic, APIC_LVTx(i)) | APIC_LVT_MASKED);
>                         }
>                         apic_update_lvtt(apic);
>                         atomic_set(&apic->lapic_timer.pending, 0);
> @@ -2140,6 +2155,17 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>                 apic_update_lvtt(apic);
>                 break;
>
> +       case APIC_LVTCMCI:
> +               if (!kvm_is_cmci_supported(apic->vcpu)) {
> +                       ret = 1;
> +                       break;
> +               }
> +               if (!kvm_apic_sw_enabled(apic))
> +                       val |= APIC_LVT_MASKED;
> +               val &= apic_lvt_mask[LVT_CMCI];
> +               kvm_lapic_set_reg(apic, APIC_LVTCMCI, val);

This should be folded into the handling of the other LVT registers.
The code is basically the same. Then you can also drop the
kvm_is_cmci_supported() and replace it with a more generic check that
checks if the LVT entry is supported.

> +               break;
> +
>         case APIC_TMICT:
>                 if (apic_lvtt_tscdeadline(apic))
>                         break;
> @@ -2383,7 +2409,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>                 kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
>         kvm_apic_set_version(apic->vcpu);
>
> -       for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
> +       for (i = 0; i < kvm_apic_get_nr_lvt_entries(apic); i++)
>                 kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
>         apic_update_lvtt(apic);
>         if (kvm_vcpu_is_reset_bsp(vcpu) &&
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 2d197ed0b8ce..16298bcb2abf 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -35,11 +35,12 @@ enum lapic_lvt_entry {
>         LVT_LINT0,
>         LVT_LINT1,
>         LVT_ERROR,
> +       LVT_CMCI,
>
>         KVM_APIC_MAX_NR_LVT_ENTRIES,
>  };
>
> -#define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))
> +#define APIC_LVTx(x) ((x) == LVT_CMCI ? APIC_LVTCMCI : APIC_LVTT + 0x10 * (x))
>
>  struct kvm_timer {
>         struct hrtimer timer;
> --
> 2.36.1.124.g0e6072fb45-goog
>
