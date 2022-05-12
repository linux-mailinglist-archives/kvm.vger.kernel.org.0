Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA03525440
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 19:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357265AbiELR5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 13:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357066AbiELR5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 13:57:37 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB1CC5E51
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:57:36 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id e144so3057973vke.9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tJtXcuM3V9enKbs0nCaiFIJtH7Y2DfmKCe9XfC0hyFE=;
        b=YAOAWptAh0bkbtmnNRA1UH3C57/gBrHU3l3D3iqYy4/HNuwDRRN6wf6crvIgDD598S
         +61X466pM5bWqKiV5Tf4zsc0LYwKuUXjVddvIssCDGYjAUWdPiY2A8wqsTK5Hv5aH1bN
         9DeFnpy2O7N5K8JqcJXgC73uHNLnlMnfsowa52KzBnnJ9H2eP2lrSVZD1nJ5XGxbzuTD
         r7Uft8TkQvIukP8PUeI75G4H1ge3lqM57YfvxTVjhp+eDBsCWACZjbqUu6k4LnU52i1x
         Cgi0s995IKEmGNn6QraMedSAEWMf5qHwumZR/h6T27t3/ThO0WOPWzDi61Qc9WLJb/GK
         QLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tJtXcuM3V9enKbs0nCaiFIJtH7Y2DfmKCe9XfC0hyFE=;
        b=CmW3PNtFOHj92691ls0mZ0QNYNid1tDUZhPOIKxfO1tQE5uJa5x9KqIBr9PetHjrpV
         wNCh4iuaWba61mqFaByiZUTWTP4+dpjDpfYjLIIpQJ1R8JLb2IfWjjDJPmx1vCscG/1U
         6GBWTy+w7Vn4R2FI6QupfKPJCIUiNw3LmVCkCcik7r18rKi4FZ6+B/eCCo2jSKVHAMAw
         ZMUD+AFDVJLQ2K50OsYXJuQZ1rH3Ev6y8GAgJ3UE5MbnVJpX7d3nQoQwisl4UUavLQ2N
         OC5mHJGBNhymkEXFtAIwEyiua8gUDeb5kzB/5yUXwzjhQNPU7xpn74SW1d47ScEBZ+fp
         7OOw==
X-Gm-Message-State: AOAM530gMLpMqRMVjtz5XsThugbvIZr6x3zzty8E9rWoFPfMN5D3uyxs
        LM8si9moBx+CLSduWatabuk97GdEsh/QVov27QPgVA==
X-Google-Smtp-Source: ABdhPJzZo8j5Wr79OB9mvq3+/k46mqbTy9urd0DfILR0Wk0c23nubwdm4eLvnFphVpssrOjjTMGJBNgIhc4+OrpieXE=
X-Received: by 2002:a1f:3451:0:b0:352:8b1f:5d11 with SMTP id
 b78-20020a1f3451000000b003528b1f5d11mr740692vka.20.1652378255627; Thu, 12 May
 2022 10:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220412223134.1736547-1-juew@google.com> <20220412223134.1736547-2-juew@google.com>
 <Ynv0h9r8F+oRQ76y@google.com>
In-Reply-To: <Ynv0h9r8F+oRQ76y@google.com>
From:   Jue Wang <juew@google.com>
Date:   Thu, 12 May 2022 10:57:24 -0700
Message-ID: <CAPcxDJ6nmj3_5ugjONDz85byY6PmcQ03CtCn+4fWAh_f9A9vOQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: Clean up KVM APIC LVT logic.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org
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

Thanks a lot, Sean!


On Wed, May 11, 2022 at 10:38 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 12, 2022, Jue Wang wrote:
> > This is in preparation to add APIC_LVTCMCI support.
>
> There is not nearly enough information in this changelog.  Same goes for all other
> patches in the series.  And when you start writing changelogs to explain what is
> being done and why, I suspect you'll find that this should be further broken up
> into multiple patches.
I realized the general lack of enough information and background in
the changelog and I am working to rewrite it with necessary
background.

>
>  1. Make APIC_VERSION capture only the magic 0x14UL
>  2. Fill apic_lvt_mask with enums / explicit entries.
>  3. Add APIC_LVTx() macro
>
> And proper upstream etiquette would be to add
>
>   Suggested-by: Sean Christopherson <seanjc@google.com>
>
> for #2 and #3.  I don't care much about the attribution (though that's nice too),
> but more importantly it provides a bit of context for others that get involved
> later in the series (sometimes unwillingly).  E.g. if someone encounters a bug
> with a patch, the Suggested-by gives them one more person to loop into the
> discussion.  Ditto for other reviewers, e.g. if someone starts reviewing the
> series at v3 or whatever, it provides some background on how the series got to
> v3 without them having to actually look at v1 or v2.

Thanks, for walking me through this process and practices. I am
breaking this patch into 3 and adding "Suggested-by: Sean
Christopherson ...." to them. Is it OK that I add you as
"Suggested-by" to the later patches in this series?


>
> > Signed-off-by: Jue Wang <juew@google.com>
> > ---
> >  arch/x86/kvm/lapic.c | 33 +++++++++++++++++++--------------
> >  arch/x86/kvm/lapic.h | 19 ++++++++++++++++++-
> >  2 files changed, 37 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 9322e6340a74..2c770e4c0e6c 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -54,7 +54,7 @@
> >  #define PRIo64 "o"
> >
> >  /* 14 is the version for Xeon and Pentium 8.4.8*/
> > -#define APIC_VERSION                 (0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
> > +#define APIC_VERSION                 0x14UL
> >  #define LAPIC_MMIO_LENGTH            (1 << 12)
> >  /* followed define is not in apicdef.h */
> >  #define MAX_APIC_VECTOR                      256
> > @@ -364,10 +364,15 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
> >       return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
> >  }
> >
> > +static inline int kvm_apic_get_nr_lvt_entries(struct kvm_vcpu *vcpu)
> > +{
> > +     return KVM_APIC_MAX_NR_LVT_ENTRIES;
> > +}
>
> I think it makes sense to introduce this helper with the CMCI patch.  Until then,
> requiring @vcpu to get the max number of entries is misleading and unnecessary.
>
> Case in point, this patch is broken in that the APIC_SPIV path in kvm_lapic_reg_write()
> uses the #define directly, which necessitates fixup in the CMCI patch to use this
> helper.
>
Ack, will incorporate this and comment below into V3.
> > +
> >  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_lapic *apic = vcpu->arch.apic;
> > -     u32 v = APIC_VERSION;
> > +     u32 v = APIC_VERSION | ((kvm_apic_get_nr_lvt_entries(vcpu) - 1) << 16);
> >
> >       if (!lapic_in_kernel(vcpu))
> >               return;
> > @@ -385,12 +390,13 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
> >       kvm_lapic_set_reg(apic, APIC_LVR, v);
> >  }
> >
> > -static const unsigned int apic_lvt_mask[KVM_APIC_LVT_NUM] = {
> > -     LVT_MASK ,      /* part LVTT mask, timer mode mask added at runtime */
> > -     LVT_MASK | APIC_MODE_MASK,      /* LVTTHMR */
> > -     LVT_MASK | APIC_MODE_MASK,      /* LVTPC */
> > -     LINT_MASK, LINT_MASK,   /* LVT0-1 */
> > -     LVT_MASK                /* LVTERR */
> > +static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
> > +     [LVT_TIMER] = LVT_MASK,      /* timer mode mask added at runtime */
> > +     [LVT_THERMAL_MONITOR] = LVT_MASK | APIC_MODE_MASK,
> > +     [LVT_PERFORMANCE_COUNTER] = LVT_MASK | APIC_MODE_MASK,
> > +     [LVT_LINT0] = LINT_MASK,
> > +     [LVT_LINT1] = LINT_MASK,
> > +     [LVT_ERROR] = LVT_MASK
> >  };
> >
> >  static int find_highest_vector(void *bitmap)
> > @@ -2039,10 +2045,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> >                       int i;
> >                       u32 lvt_val;
> >
> > -                     for (i = 0; i < KVM_APIC_LVT_NUM; i++) {
> > -                             lvt_val = kvm_lapic_get_reg(apic,
> > -                                                    APIC_LVTT + 0x10 * i);
> > -                             kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i,
> > +                     for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
> > +                             lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
> > +                             kvm_lapic_set_reg(apic, APIC_LVTx(i),
> >                                            lvt_val | APIC_LVT_MASKED);
> >                       }
> >                       apic_update_lvtt(apic);
> > @@ -2341,8 +2346,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
> >               kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
> >       kvm_apic_set_version(apic->vcpu);
> >
> > -     for (i = 0; i < KVM_APIC_LVT_NUM; i++)
> > -             kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
> > +     for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
> > +             kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
> >       apic_update_lvtt(apic);
> >       if (kvm_vcpu_is_reset_bsp(vcpu) &&
> >           kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_LINT0_REENABLED))
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index 2b44e533fc8d..5666441d5d1b 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -10,7 +10,6 @@
> >
> >  #define KVM_APIC_INIT                0
> >  #define KVM_APIC_SIPI                1
> > -#define KVM_APIC_LVT_NUM     6
> >
> >  #define APIC_SHORT_MASK                      0xc0000
> >  #define APIC_DEST_NOSHORT            0x0
> > @@ -29,6 +28,24 @@ enum lapic_mode {
> >       LAPIC_MODE_X2APIC = MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE,
> >  };
> >
> > +enum lapic_lvt_entry {
> > +     LVT_TIMER,
> > +     LVT_THERMAL_MONITOR,
> > +     LVT_PERFORMANCE_COUNTER,
> > +     LVT_LINT0,
> > +     LVT_LINT1,
> > +     LVT_ERROR,
> > +
> > +     KVM_APIC_MAX_NR_LVT_ENTRIES,
> > +};
> > +
> > +
> > +#define APIC_LVTx(x)                                                    \
> > +({                                                                      \
> > +     int __apic_reg = APIC_LVTT + 0x10 * (x);                        \
>
> An intermediate variable is completely unnecessary.  This should do just fine.
>
>   #define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))
>
> Yes, the macro _may_ eventually becomes a multi-line beast with a variable when
> CMCI support is added, but again that belongs in the CMCI patch.  That way this
> patch doesn't need to change if we decide that even the CMCI-aware version can
> just be:
>
>   #define APIC_LVTx(x) ((x) == LVT_CMCI ? APIC_LVTCMCI : APIC_LVTT + 0x10 * (x))
>
>
> > +     __apic_reg;                                                     \
> > +})
> > +
> >  struct kvm_timer {
> >       struct hrtimer timer;
> >       s64 period;                             /* unit: ns */
> > --
> > 2.35.1.1178.g4f1659d476-goog
> >
