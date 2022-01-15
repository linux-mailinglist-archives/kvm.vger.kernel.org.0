Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624DF48F422
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 02:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiAOB0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 20:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiAOB0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 20:26:31 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E4DC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 17:26:31 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id v10-20020a4a244a000000b002ddfb22ab49so2768970oov.0
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 17:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iGxhzdY+o8fZ08CLZJyGxW7d23UVHciFJHOknE38cZw=;
        b=iY7KJRBkntVU/rVadUv0PJdb2KFcPKF6PPUUe1IH2Di0GhGZ+a66TCmxaI27Sy6K+O
         xUleFpkSeSW8rDXQtCd/ZcIsHwxjTi2wj2abfIPaYDB0Gh1AdHQfRGa8ODwTfFypjeN3
         h+iS6UO4wJDhB41ypCxmNXU1ZILBnL8je6tDO+mAMWOcI4iz+mBvbNDCxL1PqEQexXgr
         p8ojIWbPPFqewMueT3lthQW2KLwMTqbaScL87wYoUadMGXTaUX4i7SDAfUTUQ0+I7Iv4
         c8bjM7BhMb7FrVn+cHVwma4ZPp1qBk1MbqcIlAiylmeRZelK0ikhu8JhhOd+ywqRpDEf
         Tf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iGxhzdY+o8fZ08CLZJyGxW7d23UVHciFJHOknE38cZw=;
        b=dLueQR2tXYGxVkLEI78eV8dg2YMnLfMSHGcdveFUlL80aKVxSlD4IcNp0eJFQIQkoS
         erHMUt7PTGlcJA6H+eoLIifMpyqRy75gziLSrUfqvA7nEg1vlIUN9FrFV0BIgqKzi1bU
         DFsVCU37aIJiwkJYL4es9aNqbJ1rUadrCNaEguTOQuUzHmI2AFa6l0TBsePnJCOBf/tb
         HFh4dmWHOLJbWMUB/Tw7nQHe8Y922H6zOPHiZ7ah56oiUyDVaOxbjE2WURI3nVlJLA0F
         PL1Y6l9+Rd+bc1LLCMiP1hBQONjK5MQLWg0sI5RbTAlQbB7Ceb/i+2u4PxfP3izFR6AV
         73Jw==
X-Gm-Message-State: AOAM531tvMjDne5k6ypx5lsDgGzlyi9i3twmrIp+49nxnMjcvMk4/vZ5
        Pm8H1QmIo9JZCr4lvR3GHNw7BbGp3Lu08IhjHGUwLHUbEJ0DbA==
X-Google-Smtp-Source: ABdhPJwnBXn26R+PGLexcGDygO0NDDlzWoHG9/A0kn5cgChrw7gacpCWI4kqdbckb+NpQsQn+2ru/m5TniKKnsyTS9U=
X-Received: by 2002:a4a:dc16:: with SMTP id p22mr8238076oov.85.1642209990389;
 Fri, 14 Jan 2022 17:26:30 -0800 (PST)
MIME-Version: 1.0
References: <20211117080304.38989-1-likexu@tencent.com> <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
In-Reply-To: <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 14 Jan 2022 17:26:19 -0800
Message-ID: <CALMp9eQCEFsQTbm7F9CqotirbP18OF_cQUySb7Q=dqiuiK1FMg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU virtualization
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 5:25 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/17/21 09:03, Like Xu wrote:
> > From: Like Xu <likexu@tencent.com>
> >
> > For Intel, the guest PMU can be disabled via clearing the PMU CPUID.
> > For AMD, all hw implementations support the base set of four
> > performance counters, with current mainstream hardware indicating
> > the presence of two additional counters via X86_FEATURE_PERFCTR_CORE.
> >
> > In the virtualized world, the AMD guest driver may detect
> > the presence of at least one counter MSR. Most hypervisor
> > vendors would introduce a module param (like lbrv for svm)
> > to disable PMU for all guests.
> >
> > Another control proposal per-VM is to pass PMU disable information
> > via MSR_IA32_PERF_CAPABILITIES or one bit in CPUID Fn4000_00[FF:00].
> > Both of methods require some guest-side changes, so a module
> > parameter may not be sufficiently granular, but practical enough.
> >
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > ---
> >   arch/x86/kvm/cpuid.c   |  2 +-
> >   arch/x86/kvm/svm/pmu.c |  4 ++++
> >   arch/x86/kvm/svm/svm.c | 11 +++++++++++
> >   arch/x86/kvm/svm/svm.h |  1 +
> >   4 files changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 2d70edb0f323..647af2a184ad 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -487,7 +487,7 @@ void kvm_set_cpu_caps(void)
> >               F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
> >               F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
> >               0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM) |
> > -             F(TOPOEXT) | F(PERFCTR_CORE)
> > +             F(TOPOEXT) | 0 /* PERFCTR_CORE */
> >       );
> >
> >       kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
> > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > index fdf587f19c5f..a0bcf0144664 100644
> > --- a/arch/x86/kvm/svm/pmu.c
> > +++ b/arch/x86/kvm/svm/pmu.c
> > @@ -16,6 +16,7 @@
> >   #include "cpuid.h"
> >   #include "lapic.h"
> >   #include "pmu.h"
> > +#include "svm.h"
> >
> >   enum pmu_type {
> >       PMU_TYPE_COUNTER = 0,
> > @@ -100,6 +101,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
> >   {
> >       struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> >
> > +     if (!pmuv)
> > +             return NULL;
> > +
> >       switch (msr) {
> >       case MSR_F15H_PERF_CTL0:
> >       case MSR_F15H_PERF_CTL1:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 21bb81710e0f..062e48c191ee 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -190,6 +190,10 @@ module_param(vgif, int, 0444);
> >   static int lbrv = true;
> >   module_param(lbrv, int, 0444);
> >
> > +/* enable/disable PMU virtualization */
> > +bool pmuv = true;
> > +module_param(pmuv, bool, 0444);
> > +
> >   static int tsc_scaling = true;
> >   module_param(tsc_scaling, int, 0444);
> >
> > @@ -952,6 +956,10 @@ static __init void svm_set_cpu_caps(void)
> >           boot_cpu_has(X86_FEATURE_AMD_SSBD))
> >               kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> >
> > +     /* AMD PMU PERFCTR_CORE CPUID */
> > +     if (pmuv && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
> > +             kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
> > +
> >       /* CPUID 0x8000001F (SME/SEV features) */
> >       sev_set_cpu_caps();
> >   }
> > @@ -1085,6 +1093,9 @@ static __init int svm_hardware_setup(void)
> >                       pr_info("LBR virtualization supported\n");
> >       }
> >
> > +     if (!pmuv)
> > +             pr_info("PMU virtualization is disabled\n");
> > +
> >       svm_set_cpu_caps();
> >
> >       /*
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 0d7bbe548ac3..08e1c19ffbdf 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -32,6 +32,7 @@
> >   extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> >   extern bool npt_enabled;
> >   extern bool intercept_smi;
> > +extern bool pmuv;
> >
> >   /*
> >    * Clean bits in VMCB.
> >
>
> Queued, thanks - just changed the parameter name to "pmu".

Whoops! The global 'pmu' is hidden by a local 'pmu' in get_gp_pmc_amd().
