Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651F846C1FD
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 18:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240130AbhLGRqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 12:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240125AbhLGRqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 12:46:05 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D0BC061746
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 09:42:34 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso19069428ota.5
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 09:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZyOSLRD+OOns9+yyRtcdOOhQIxKcBFv5MAHI5qU57h8=;
        b=kI6zf53RuzrPprRdot2VD1lXiadsOrPCq3R7Y+R+e3Hnszjo8W/y248q9/MbDGTWPk
         FE+3aCmxmwzYPfl64a3shrWHXn/Fw26u5gAnRKHQ1ynkXZdxIIbB7TY92ghtO83wMBRT
         1f78bu534VolDVq/oibdoEjcIVSptazGW8Tr0VV6v4V+BopvbNe+1G4xhHVnk49xvLoq
         5mwsi+sbo3tqWnTRx3O2ZgbJ4DGKSXuYSypCiUEGk0VMPTWcu0VLGTikqox/wFySGx8j
         2LxprfiwiaH9gr61x7XQ3KPc+Xg96xeAXvqZJhpZga1hulxqhvV3Fs9CFm4x3DksOoUS
         jj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZyOSLRD+OOns9+yyRtcdOOhQIxKcBFv5MAHI5qU57h8=;
        b=IRgMo1mMjMwlA88z4c0ZUl+vRfgdf/niU/Eg0wwlBhLhUue7xnEFNI4s94yDgWyat2
         65NnofSe2VlwTSCqgx6ITQivdkLlB3/rqZrxtK9rlj2IILeBGSpS+DArK1X5K9B6Isl2
         3FYtSTxGbeQh5dH8IfiZ1kCtVfezpgCLwiKCMz1VdjXSOi0Wlc3TQmZuUBa31JzRVbwb
         O7gLS3/YPPtanwLsKJmWEckOJTHsykvh5KsBLIKWEgCZhpR3EZ8mDYt8tMpfF1irfoho
         h9IqTao3J79XlySL9yLJs5aYmYLYMxO92Sbj8ig9fQNwnotNfh9fNBOurlJjvUMEwuTk
         tglQ==
X-Gm-Message-State: AOAM531j/VQGrB+ZRGJavSVCIcx7MwoJr5zTAPK/T9+jCAEEcH1FvFNL
        HeT4PJkKlgwbPV1IWS/jpNdKHZ0w+7kIOMyQczzGFRwvntGxcg==
X-Google-Smtp-Source: ABdhPJwfBTn/IIYq01dVF804dzDnEe9hyh//gCAkH89rt4NSjhn675lKQ68LLKYKu00DJJJKgr2dW8Id55pdchBOwHA=
X-Received: by 2002:a05:6830:601:: with SMTP id w1mr35698440oti.267.1638898953399;
 Tue, 07 Dec 2021 09:42:33 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-2-likexu@tencent.com>
 <CALMp9eTq8H_bJOVKwi_7j3Kum9RvW6o-G3zCLUFco1A1cvNrkQ@mail.gmail.com> <7ca8ffcb-eb45-a47c-f91b-6dbd35ea8893@gmail.com>
In-Reply-To: <7ca8ffcb-eb45-a47c-f91b-6dbd35ea8893@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 7 Dec 2021 09:42:21 -0800
Message-ID: <CALMp9eSucAtacT-4pR2Du8b_aHtFeSSLGqsZMMQnOE+XVSgK0g@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 6, 2021 at 10:08 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 7/12/2021 3:50 am, Jim Mattson wrote:
> > On Mon, Nov 29, 2021 at 11:42 PM Like Xu <like.xu.linux@gmail.com> wrote:
> >
> >> From: Like Xu <likexu@tencent.com>
> >>
> >> The current pmc->eventsel for fixed counter is underutilised. The
> >> pmc->eventsel can be setup for all known available fixed counters
> >> since we have mapping between fixed pmc index and
> >> the intel_arch_events array.
> >>
> >> Either gp or fixed counter, it will simplify the later checks for
> >> consistency between eventsel and perf_hw_id.
> >>
> >> Signed-off-by: Like Xu <likexu@tencent.com>
> >> ---
> >>   arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++++++++
> >>   1 file changed, 16 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> >> index 1b7456b2177b..b7ab5fd03681 100644
> >> --- a/arch/x86/kvm/vmx/pmu_intel.c
> >> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> >> @@ -459,6 +459,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu,
> >> struct msr_data *msr_info)
> >>          return 1;
> >>   }
> >>
> >> +static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
> >> +{
> >> +       size_t size = ARRAY_SIZE(fixed_pmc_events);
> >> +       struct kvm_pmc *pmc;
> >> +       u32 event;
> >> +       int i;
> >> +
> >> +       for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> >> +               pmc = &pmu->fixed_counters[i];
> >> +               event = fixed_pmc_events[array_index_nospec(i, size)];
> >>
> >
> > How do we know that i < size? For example, Ice Lake supports 4
> > fixed counters, but fixed_pmc_events only has three entries.
>
> With the help of macro MAX_FIXED_COUNTERS,
> the fourth or more fixed counter is currently not supported in KVM.

Thanks for the hint. I see it now.

> If the user space sets a super set of CPUID supported by KVM,
> any pmu emulation failure is to be expected, right ?

Actually, I would expect a misconfigured VM to elicit an error. I
don't see the advantage of mis-emulating an unsupported configuration.
But maybe that's just me.

> Waiting for more comments from you on this patch set.

I'll try to get to them this week. Thanks for following up while I was
on holiday.

> >
> >
> >> +               pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
> >> +                       intel_arch_events[event].eventsel;
> >> +       }
> >> +}
> >> +
> >>
> >>
> >>
> >
