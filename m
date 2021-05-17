Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F048F383C90
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 20:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbhEQSoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 14:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbhEQSoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 14:44:38 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742FCC061756
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:43:21 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id f184so7406298oig.3
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BxvqsrFgd+zMtCRd69oHn28UvTzcbEEuRZRz15PKi7U=;
        b=XVzPZWUltbaoqBA2ZQvL4WiJi+iLKqWxauVJQqNEcDghVLSlvCcOrzyLw7bjwcjfy1
         hqgu1D+Ncghg2RIGUO4R9kIB/I/rm7mWSwHw5ZnbP7YpLoND3gYPrDiI7sFNxp6F00G9
         0wT2G5bIdfXYCC1amHDE2n4Pa1HP9FxJiuvxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BxvqsrFgd+zMtCRd69oHn28UvTzcbEEuRZRz15PKi7U=;
        b=mblUje75cpGNz7emkHWu99BBcpfK0dkk+a7YtkSNr6inEMbuCiuLVW+ofK+pNh+aEx
         bdjIRwhw4wl1+5AI93xK0iRf4dVpEceO+bEx5mX2CtRhWs4pDhKpLTwDX7Kap00BkdI7
         vALU9ujc3HOy6XuBUs1i/nQYTKz9jSINCyTMczyw3L7NoljUSPzU+bh2YSj+Om/8Xp70
         MvK1JedP9Zoa9wMwSdWtrAY6XVg0na6xKpj9AP3iMQlTSaDVzOns8+AXOM83Y4zNhVEm
         FZMtIOaQ9elHi3zT7H6dnIb0LUrI/RJvKtl05fR72putrx9B4vpiCaVrBPjLOl5wY+Vy
         KkmQ==
X-Gm-Message-State: AOAM531BL0t7VL0giTK99cfS0l1uKw50poOkADHVaInYf2l95H/uGEIe
        UIyLjEO97rz6gG1n7+FZlP3hpGTEXy7VHS0Jq2t0Hg==
X-Google-Smtp-Source: ABdhPJxtvu+wUUKtSE5d3Ll1DuAvUzIFUzUP9Vhcztl5S5WK2jFn11QU8wwFGOivQf7ox/HfXvH9UJBvh1P9rwzHuGI=
X-Received: by 2002:aca:c1d4:: with SMTP id r203mr397440oif.176.1621277000748;
 Mon, 17 May 2021 11:43:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-5-like.xu@linux.intel.com> <CAA0tLErUFPnZ=SL82bLe8Ddf5rFu2Pdv5xE0aq4A91mzn9=ABA@mail.gmail.com>
 <ead61a83-1534-a8a6-13ee-646898a6d1a9@intel.com> <YJvx4tr2iXo4bQ/d@google.com>
 <5ef2215b-1c43-fc8a-42ef-46c22e093f40@intel.com>
In-Reply-To: <5ef2215b-1c43-fc8a-42ef-46c22e093f40@intel.com>
From:   Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Mon, 17 May 2021 11:43:25 -0700
Message-ID: <CAA0tLErHZwyk_01jzy3u4Y+iGEM05zt-+inrhFXy4a5iw0X8-A@mail.gmail.com>
Subject: Re: [PATCH v6 04/16] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, Stephane Eranian <eranian@google.com>,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, Yao Yuan <yuan.yao@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 7:50 PM Xu, Like <like.xu@intel.com> wrote:
>
> On 2021/5/12 23:18, Sean Christopherson wrote:
> > On Wed, May 12, 2021, Xu, Like wrote:
> >> Hi Venkatesh Srinivas,
> >>
> >> On 2021/5/12 9:58, Venkatesh Srinivas wrote:
> >>> On 5/10/21, Like Xu <like.xu@linux.intel.com> wrote:
> >>>> On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
> >>>> detect whether the processor supports performance monitoring facility.
> >>>>
> >>>> It depends on the PMU is enabled for the guest, and a software write
> >>>> operation to this available bit will be ignored.
> >>> Is the behavior that writes to IA32_MISC_ENABLE[7] are ignored (rather than #GP)
> >>> documented someplace?
> >> The bit[7] behavior of the real hardware on the native host is quite
> >> suspicious.
> > Ugh.  Can you file an SDM bug to get the wording and accessibility updated?  The
> > current phrasing is a mess:
> >
> >    Performance Monitoring Available (R)
> >    1 = Performance monitoring enabled.
> >    0 = Performance monitoring disabled.
> >
> > The (R) is ambiguous because most other entries that are read-only use (RO), and
> > the "enabled vs. disabled" implies the bit is writable and really does control
> > the PMU.  But on my Haswell system, it's read-only.
>
> On your Haswell system, does it cause #GP or just silent if you change this
> bit ?
>
> > Assuming the bit is supposed
> > to be a read-only "PMU supported bit", the SDM should be:
> >
> >    Performance Monitoring Available (RO)
> >    1 = Performance monitoring supported.
> >    0 = Performance monitoring not supported.

Can't speak to Haswell, but on Apollo Lake/Goldmont, this bit is _not_
set natively
and we get a #GP when attempting to set it, even though the PMU is available.

Should this bit be conditional on the host having it set?

> >
> > And please update the changelog to explain the "why" of whatever the behavior
> > ends up being.  The "what" is obvious from the code.
>
> Thanks for your "why" comment.
>
> >
> >> To keep the semantics consistent and simple, we propose ignoring write
> >> operation in the virtualized world, since whether or not to expose PMU is
> >> configured by the hypervisor user space and not by the guest side.
> > Making up our own architectural behavior because it's convient is not a good
> > idea.
>
> Sometime we do change it.
>
> For example, the scope of some msrs may be "core level share"
> but we likely keep it as a "thread level" variable in the KVM out of
> convenience.
>
> >
> >>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> >>>> index 9efc1a6b8693..d9dbebe03cae 100644
> >>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
> >>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> >>>> @@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
> >>>>            if (!pmu->version)
> >>>>                    return;
> >>>>
> >>>> +  vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
> > Hmm, normally I would say overwriting the guest's value is a bad idea, but if
> > the bit really is a read-only "PMU supported" bit, then this is the correct
> > behavior, albeit weird if userspace does a late CPUID update (though that's
> > weird no matter what).
> >
> >>>>            perf_get_x86_pmu_capability(&x86_pmu);
> >>>>
> >>>>            pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
> >>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>>> index 5bd550eaf683..abe3ea69078c 100644
> >>>> --- a/arch/x86/kvm/x86.c
> >>>> +++ b/arch/x86/kvm/x86.c
> >>>> @@ -3211,6 +3211,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct
> >>>> msr_data *msr_info)
> >>>>                    }
> >>>>                    break;
> >>>>            case MSR_IA32_MISC_ENABLE:
> >>>> +          data &= ~MSR_IA32_MISC_ENABLE_EMON;
> > However, this is not.  If it's a read-only bit, then toggling the bit should
> > cause a #GP.
>
> The proposal here is trying to make it as an
> unchangeable bit and don't make it #GP if guest changes it.
>
> It may different from the host behavior but
> it doesn't cause potential issue if some guest code
> changes it during the use of performance monitoring.
>
> Does this make sense to you or do you want to
> keep it strictly the same as the host side?
>
> >
> >>>>                    if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
> >>>> &&
> >>>>                        ((vcpu->arch.ia32_misc_enable_msr ^ data) &
> >>>> MSR_IA32_MISC_ENABLE_MWAIT)) {
> >>>>                            if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
> >>>> --
>
