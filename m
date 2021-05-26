Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A51939112A
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 09:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbhEZHGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 03:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbhEZHGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 03:06:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43C4C061756
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 00:04:49 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso12884976pjb.0
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 00:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9EnWzCrCjMkBA9yDDFJOkeJ9fcIzJ3+RLUTB4gLbZcg=;
        b=cgehxhl99cjGZQyweR9ri+4IHaenJsxSFUR85TvBKZq4WmukDc45ElIewp+VoUp80l
         +IhXOhEGlqnmpojVKEXeKrYODo00lM8FkBhuuv0KaZ8kbiezXYP2S4WgafEkBf2VCx4C
         w6m9jxUovt42R4IaqB1vS/jIC8E580v9nN7coHNRJsZqXZPrWFKz3mgbKFoyE2C/I5wF
         ckHHlR/0H2EjVukktONdiUVSPl2WBIctb4TDRQ1FLkLBDAC56nFRXH4azMVtfNo6TJJB
         WrsnJ1ANB/toDodAxwMwCG7l7QQahtf06aKhFqZau49Lym1Zhd2HyDDO3+v9qZNoIK4f
         6vIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9EnWzCrCjMkBA9yDDFJOkeJ9fcIzJ3+RLUTB4gLbZcg=;
        b=n2oBeTlAPlEr/uMWyGHK16MTYZ1DWRLsZTuFtzL80OHpWslfeRyZJ5658cUTkkfA3f
         r0UvDwYieUZ2qo13OA/MAwZPnRUIm9vt710HeqeJ1ITWAXkKb6S55trcpNiQ0plSmpLc
         jB8Gl1cix8fbWoWt6j7S1tR7d/YbWb2esvJPMEKYVdqV3D09aORIZfE+tVxbt9GOIOis
         0vB1pHjoog0zISo4x8hr1e6MM5vf2D0nuox3PhYFDKQmZ3hO3llPDZzBr14UOSwrFfNI
         IJJxGR85KdOSfdAdOCyJZ+EduQkZdUP577ZNYHjXKu+MmOKx6j7iijdWrO2ci2ceueDo
         Y96A==
X-Gm-Message-State: AOAM533a5566OUEhudNV8iHkACBl+4+yPXYrR9xrbExG9y5hPMamCwbh
        8UKjPr+pCMsMpE2yM6i0A93SpoZajUNJP4rWQRraIw==
X-Google-Smtp-Source: ABdhPJyOAoJ00XEnqH4r8aB6WS1NFX4IHuoS0DZpueYY1Z36KtN1KjazL8ggYd054SBzKdj8Xgq60ik5QOw1bMIusOU=
X-Received: by 2002:a17:90a:5288:: with SMTP id w8mr2475201pjh.170.1622012689272;
 Wed, 26 May 2021 00:04:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-18-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-18-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 26 May 2021 00:04:33 -0700
Message-ID: <CAAeT=Fw2zfvTkvCSuRqo6K1+L7LaPOpsSHHU1oGbUnUSDtELVQ@mail.gmail.com>
Subject: Re: [PATCH 17/43] KVM: x86: Open code necessary bits of
 kvm_lapic_set_base() at vCPU RESET
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 5:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Stuff vcpu->arch.apic_base and apic->base_address directly during APIC
> reset, as opposed to bouncing through kvm_set_apic_base() while fudging
> the ENABLE bit during creation to avoid the other, unwanted side effects.
>
> This is a step towards consolidating the APIC RESET logic across x86,
> VMX, and SVM.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index b088f6984b37..b1366df46d1d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2305,7 +2305,6 @@ EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
>  void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
> -       u64 msr_val;
>         int i;
>
>         if (!apic)
> @@ -2315,10 +2314,13 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>         hrtimer_cancel(&apic->lapic_timer.timer);
>
>         if (!init_event) {
> -               msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
> +               vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
> +                                      MSR_IA32_APICBASE_ENABLE;
>                 if (kvm_vcpu_is_reset_bsp(vcpu))
> -                       msr_val |= MSR_IA32_APICBASE_BSP;
> -               kvm_lapic_set_base(vcpu, msr_val);
> +                       vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
> +
> +               apic->base_address = MSR_IA32_APICBASE_ENABLE;

I think you wanted to make the code above set apic->base_address
to APIC_DEFAULT_PHYS_BASE (not MSR_IA32_APICBASE_ENABLE).

Thanks,
Reiji
