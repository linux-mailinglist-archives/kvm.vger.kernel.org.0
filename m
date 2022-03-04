Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D5F4CDD21
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiCDTHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiCDTHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:07:12 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6691EC986
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 11:06:20 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id l25-20020a9d7a99000000b005af173a2875so8183017otn.2
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 11:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ltKgi/b1r6yAxpmHxcCWTc/P1+26ye9tRdej8H8cXjs=;
        b=Mxecmohhv0kmsf7C0gnjBHSBoFcTtvYhyc8u+H5KbPJ556QuypU/WtrZebNVmuBLFg
         bg/RMTXk1ZY31givcLvvjNc9BZNwQPSUdLMlgw4PH6JfrgidQsZePqvdSCp0N/G04Jh+
         hTcq7G4WTGqnygIk1C8U1Hc8qIcOlW3zlsZ1i6w9/WozmZ7M4NkW2ev7VpfoiDk+NuH+
         hkHgTxIxJ7oG98BRDFvI0jQaCSQp3uhyUFabkQtPQa9YqnnXZwAovC0Nh+DdTGcwGOgj
         tYBH3wOMWzMjCRevR6Nix1UVpl7+msKD2kFxyJRrJFe9vl66rui+LM9Dha47i8sWNTak
         bFhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ltKgi/b1r6yAxpmHxcCWTc/P1+26ye9tRdej8H8cXjs=;
        b=rorEn+lJqeILVNoDN+hNTvfoLRlwF5k9U+j4w4n8+gSqVHRuaPfr2LaHD1t4lCHUOP
         yXK7dyH8Q2wXpt1HZeqt8T0vJ2qhy9Dpd/pArPC6kqgUoxrsSIeF9whhe2+Xk6auup8r
         jnhkCwkvvI/5lBywp77EromGHGcXijeAfgfW2Pdo5UgVaRfrZ4kkuWz4lEnUwucf7KMP
         F5ArARC5IBlprOUMwRDPPEBe/GMurS2psl6jqZVn8aU6btAfZNFExs9IpycE0OJ7itFJ
         j75MsJDyZbYig14ARnwXcdhFgu/PuATVKB6mIwOwWn364TgIOwCaMsKIK+jua/Rm5J3o
         BX0Q==
X-Gm-Message-State: AOAM53320fxUP6wr8Ant7cx7KtdMCDTt5/YuqPsvW39uqavV+WubaNYN
        mAhIFS2YVgex27NvFqB+6xavUYNkXIY6+ld8R2Zx6w==
X-Google-Smtp-Source: ABdhPJw6oME2pndJPvk7aqHxPXdAoH7daK5Xu6tWA8SbgYsz5I4PKJSvh7obHOa/Cj+PxSur0Lm9EPp/P5EYQxjT3KM=
X-Received: by 2002:a9d:8b5:0:b0:5a4:9db6:92b4 with SMTP id
 50-20020a9d08b5000000b005a49db692b4mr97683otf.14.1646420779509; Fri, 04 Mar
 2022 11:06:19 -0800 (PST)
MIME-Version: 1.0
References: <20220302111334.12689-1-likexu@tencent.com> <20220302111334.12689-13-likexu@tencent.com>
 <CALMp9eT1N_HeipXjpyqrXs_WmBEip2vchy4d1GffpwrEd+444w@mail.gmail.com> <273a7631-188b-a7a9-a551-4e577dcdd8d1@gmail.com>
In-Reply-To: <273a7631-188b-a7a9-a551-4e577dcdd8d1@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 4 Mar 2022 11:06:08 -0800
Message-ID: <CALMp9eRM9kTxmyHr2k1r=VSjFyDy=Dyvek5gdgZ8bHHrmPL5gQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] KVM: x86/pmu: Clear reserved bit PERF_CTL2[43]
 for AMD erratum 1292
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 4, 2022 at 1:47 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 3/3/2022 1:52 am, Jim Mattson wrote:
> > On Wed, Mar 2, 2022 at 3:14 AM Like Xu <like.xu.linux@gmail.com> wrote:
> >>
> >> From: Like Xu <likexu@tencent.com>
> >>
> >> The AMD Family 19h Models 00h-0Fh Processors may experience sampling
> >> inaccuracies that cause the following performance counters to overcount
> >> retire-based events. To count the non-FP affected PMC events correctly,
> >> a patched guest with a target vCPU model would:
> >>
> >>      - Use Core::X86::Msr::PERF_CTL2 to count the events, and
> >>      - Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
> >>      - Program Core::X86::Msr::PERF_CTL2[20] to 0b.
> >>
> >> To support this use of AMD guests, KVM should not reserve bit 43
> >> only for counter #2. Treatment of other cases remains unchanged.
> >>
> >> AMD hardware team clarified that the conditions under which the
> >> overcounting can happen, is quite rare. This change may make those
> >> PMU driver developers who have read errata #1292 less disappointed.
> >>
> >> Reported-by: Jim Mattson <jmattson@google.com>
> >> Signed-off-by: Like Xu <likexu@tencent.com>
> >
> > This seems unnecessarily convoluted. As I've said previously, KVM
> > should not ever synthesize a #GP for any value written to a
> > PerfEvtSeln MSR when emulating an AMD CPU.
>
> IMO, we should "never synthesize a #GP" for all AMD MSRs,
> not just for AMD PMU msrs, or keep the status quo.

Then, why are you proposing this change? :-)

We should continue to synthesize a #GP for an attempt to set "must be
zero" bits or for rule violations, like "address must be canonical."
However, we have absolutely no business making up our own hardware
specification. This is a bug, and it should be fixed, like any other
bug.

> I agree with you on this AMD #GP transition, but we need at least one
> kernel cycle to make a more radical change and we don't know Paolo's
> attitude and more, we haven't received a tidal wave of user complaints.

Again, if this is your stance, why are you proposing this change? :-)

If you wait until you have a tidal wave of user complaints, you have
waited too long. It's much better to be proactive than reactive.
