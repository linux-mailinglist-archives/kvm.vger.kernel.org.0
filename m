Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286C3611BBC
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 22:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJ1UsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 16:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJ1UsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 16:48:10 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8ABD23AB5E
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 13:48:09 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id t4so3879862wmj.5
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 13:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ia+Ezvbp5KM775ScfRUFiPDwhlNlSnYM0zeKrcuYss=;
        b=Hgk9Ba9mXyrGt+VF/I8vDJk37zea5mcWNtXIdvPW6dfwcjZkZlmOiS0kkecH/ICleu
         FRtoK/V5cKFezomkkbRKIQpyVLIxid8a9qph2+/7dzI8i1WIMPKNIso+I9DJypZztJmq
         71hcy+11w+6jvqA6be1/anHUbF8n2+MPGEAHuFFGeeGtl1WX86TsstlNEM0idfouds/m
         IjHB7CdbKHNxbP+zjGnR5gzz+QZNWq011VzqBb92GENTG4p9QXMpuX31MX92fHCT8bN4
         vEo53Yk40gTZSxnAL92iEX72pig661rxAxXrxB8FxuDhLQwtpwnKG/6EgjlwXdEoDAmO
         5t7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Ia+Ezvbp5KM775ScfRUFiPDwhlNlSnYM0zeKrcuYss=;
        b=dOGPHLIKNw05SVOAM5KhLWc+7K5kSbGk/6dVkD8Sik4C83ulx0u8NG8bSAIvWG8Sw3
         f8bML0OJ6/BwkuQZfGwOuvCTxSP0Di3jkPUL8s/aNelbUPvHEp0bm0fVUUxvXFfk33eK
         o4AmArGC7OuTKUb8B92NTtp92KDj/dGA3khKzdo/vlS1T/nBy68NLwrhPpyyxjBwyX9c
         RdpVqpMwUPJh/4zyczVqB/kTpB9XQ75deqAzH9ihXgkTyadJPGw1jLcyfSgrxuOUUZIk
         VuH9Q+8CASRISyXJYeCg19te3v8z5FnzbLcKbnPU16QY+0QJQ1LKnyxgEfkz1RD25bsl
         mnbg==
X-Gm-Message-State: ACrzQf2j4LtprqXCc9cKODc43werkwIPEHeJT1styV3sBFqyr1OBGte5
        /UV8NLzZiQFzJcVT2ZyLX3yr0fMlB0FTmgT3ylCKnA==
X-Google-Smtp-Source: AMsMyM45/AkG/ddDvuBZie5EyGj/h1k339+R4gNXroLF+dmn9LIahnWe2ztYqcO+/NvKlrASM0t32rLYEGWs4wyXLM0=
X-Received: by 2002:a7b:cb8b:0:b0:3c5:9825:6f01 with SMTP id
 m11-20020a7bcb8b000000b003c598256f01mr10951133wmi.156.1666990088257; Fri, 28
 Oct 2022 13:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221028130035.1550068-1-aaronlewis@google.com> <Y1wCqAzJwvz4s8OR@google.com>
In-Reply-To: <Y1wCqAzJwvz4s8OR@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 28 Oct 2022 20:47:56 +0000
Message-ID: <CAAAPnDEda-FBz+3suqtA868Szwp-YCoLEmK1c=UynibTWCU1hw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix a stall when KVM_SET_MSRS is called on the
 pmu counters
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 28, 2022 at 4:26 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 28, 2022, Aaron Lewis wrote:
> > A stall in this situation could have an impact on live migration. So,
> > to avoid that disable the print if the write is initiated by the host.
>
> ...
>
> > Fixes: 5753785fa977 ("KVM: do not #GP on perf MSR writes when vPMU is disabled")
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> > arch/x86/kvm/x86.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9cf1ba865562..a3b842467bd2 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3778,7 +3778,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >
> >    case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> >    case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> > -       pr = true;
> > +       pr = !msr_info->host_initiated;
>
> Wasting guest cycles isn't any better, and there are plenty more MSRs that don't
> honor report_ignored_msrs, i.e. you'll be playing whack-a-mole.
>
> My first choice would be to delete all MSR printks, but since that's probably not
> an option...
>
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 28 Oct 2022 09:20:03 -0700
> Subject: [PATCH] KVM: x86: Gate all "unimplemented MSR" prints on
> report_ignored_msrs
>
> Add helpers to print unimplemented MSR accesses and condition all such
> prints on report_ignored_msrs, i.e. honor userspace's request to not
> print unimplemented MSRs. Even though vcpu_unimpl() is ratelimited,
> printing can still be problematic, e.g. if a print gets stalled when host
> userspace is writing MSRs during live migration, an effective stall can
> result in very noticeable disruption in the guest.
>

Yeah, I like this approach better.

> @@ -3778,16 +3775,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>
>     case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
>     case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> -        pr = true;
> -        fallthrough;
>     case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
>     case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
>         if (kvm_pmu_is_valid_msr(vcpu, msr))
>             return kvm_pmu_set_msr(vcpu, msr_info);
>
> -        if (pr || data != 0)
> -            vcpu_unimpl(vcpu, "disabled perfctr wrmsr: "
> -                  "0x%x data 0x%llx\n", msr, data);
> +        if (data)
> +            kvm_pr_unimpl_wrmsr(vcpu, msr, data);

Any reason to keep the check for 'data' around?  Now that it's
checking for 'report_ignored_msrs' maybe we don't need that check as
well.  I'm not sure what the harm is in removing it, and with this
change we are additionally restricting pmu counter == 0 from printing.
If there's nothing special about it, let them both print.

>         break;
>     case MSR_K7_CLK_CTL:
>         /*
> @@ -3814,9 +3808,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>         /* Drop writes to this legacy MSR -- see rdmsr
>         * counterpart for further detail.
>         */
> -        if (report_ignored_msrs)
> -            vcpu_unimpl(vcpu, "ignored wrmsr: 0x%x data 0x%llx\n",
> -                msr, data);
> +        kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>         break;
>     case MSR_AMD64_OSVW_ID_LENGTH:
>         if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 829d3134c1eb..4921a0774bf7 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -330,6 +330,18 @@ extern bool report_ignored_msrs;
>
