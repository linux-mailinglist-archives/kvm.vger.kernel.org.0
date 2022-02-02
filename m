Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739DF4A6BDC
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 07:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244899AbiBBGww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 01:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235104AbiBBGwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 01:52:39 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFE0C06175C
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 22:16:49 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id i10so57861585ybt.10
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 22:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C3p2gN4tjLo8jQpCh7Gc8fZEVp5pXdYViSw97S0CJgg=;
        b=HlkVdkHTKAWdtrgBaBjhx/iJyD24xlqIyj8w7GX5qlf3NmXWt341lkdcCq5u7aSZ+Z
         9cA9gwfSrBAoqWDmcbpQ/T8EnMMQW3JVogTB2gin6oZuY/4Ku2UY019/Sr48WoyMOWkD
         TCESf4byBk9uedy9aZddJTeAjiXow3ta/B3z2jMe/y1/wGZZzXDqrIBrroWK6FYfK3TM
         w9R4e4i+/ygoPlFgTAoWFptOABLJAvPjb5uE/pBaCxff5n8HCMAWRMcqU3BsS+QygZ05
         VKfA4IZwwLAj/nN3VxYYGgj/VKu1mHye/m3YwlJJ8Xlblkdj7m3oA0Mfn4IMte2jKyfb
         HNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C3p2gN4tjLo8jQpCh7Gc8fZEVp5pXdYViSw97S0CJgg=;
        b=KlR6SSVejSO5n21N6/LHfQf2RPb+91Fcb6FkmRGOv6ZBFT9yu3PJvO1YgU2K/Rap9T
         eYKND4MMLzy+dh4+gl5yN9deciCZiGRm3Qdji1Tnh/Lz71aFij2ic7Sc9ypjRM7HBcSJ
         WS++zBwt7G2R4TVxTF1FXviFnZ+/F/wkWIL18OiXQBffU3fi5GQAi6ZwD0QtsC14nfaB
         NJJ8S4VmxAUI8HQ4hmdqG9trsrkDRLVMCBPE2GMCErV0iCuYvK7VSpqEWoaVX7/HytSn
         vup1pTFv2r+g+BzCV3qEuBmMko3e88kX0gLrk+HpGK8+MQSCtj5H3ql11/GnuR6MoZjf
         IN8g==
X-Gm-Message-State: AOAM530yu8ZjzNc2y5499v5gP+n5RpoePbecHXWLAIkWvJ6YKLTIlfGp
        eZorBRonBgpZtLb/PzohnnBMN6hGMbdt8E4vmlrgmE/kj34=
X-Google-Smtp-Source: ABdhPJxzanj+lNeSdg4KaYgrviOgBE3GkTnPSfzQ1qj/KBsBAJeeb2cP1KLJEOlYQ+bzXZbbNofgdIuwSvwweP7kD4U=
X-Received: by 2002:a5b:b84:: with SMTP id l4mr40689519ybq.665.1643782607589;
 Tue, 01 Feb 2022 22:16:47 -0800 (PST)
MIME-Version: 1.0
References: <20220117055703.52020-1-likexu@tencent.com> <20220202042838.6532-1-ravi.bangoria@amd.com>
 <CABPqkBQOSc=bwLdieBAX-sJ0Z+KwaxE=4PGXuuyzWyyZKf2ODg@mail.gmail.com> <4662f1dd-d7dc-ea19-82dc-f81e8f3dcf1a@amd.com>
In-Reply-To: <4662f1dd-d7dc-ea19-82dc-f81e8f3dcf1a@amd.com>
From:   Stephane Eranian <eranian@google.com>
Date:   Tue, 1 Feb 2022 22:16:36 -0800
Message-ID: <CABPqkBQXvkqArcrXKVweWCobcaQZBRV6t3AhFuW8X28MBRkqBg@mail.gmail.com>
Subject: Re: [PATCH] perf/amd: Implement errata #1292 workaround for F19h M00-0Fh
To:     Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     like.xu.linux@gmail.com, jmattson@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        peterz@infradead.org, mingo@redhat.com,
        alexander.shishkin@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 1, 2022 at 10:03 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>
> Hi Stephane,
>
> On 02-Feb-22 10:57 AM, Stephane Eranian wrote:
> > On Tue, Feb 1, 2022 at 8:29 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
> >>
> >> Perf counter may overcount for a list of Retire Based Events. Implement
> >> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
> >> Revision Guide[1]:
> >>
> >>   To count the non-FP affected PMC events correctly:
> >>     o Use Core::X86::Msr::PERF_CTL2 to count the events, and
> >>     o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
> >>     o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
> >>
> >> Above workaround suggests to clear PERF_CTL2[20], but that will disable
> >> sampling mode. Given the fact that, there is already a skew between
> >> actual counter overflow vs PMI hit, we are anyway not getting accurate
> >> count for sampling events. Also, using PMC2 with both bit43 and bit20
> >> set can result in additional issues. Hence Linux implementation of
> >> workaround uses non-PMC2 counter for sampling events.
> >>
> > Something is missing from your description here. If you are not
> > clearing bit[20] and
> > not setting bit[43], then how does running on CTL2 by itself improve
> > the count. Is that
> > enough to make the counter count correctly?
>
> Yes. For counting retire based events, we need PMC2[43] set and
> PMC2[20] clear so that it will not overcount.
>
Ok, I get that part now. You are forcing the bits in the
get_constraint() function.

> >
> > For sampling events, your patch makes CTL2 not available. That seems
> > to contradict the
> > workaround. Are you doing this to free CTL2 for counting mode events
> > instead? If you are
> > not using CTL2, then you are not correcting the count. Are you saying
> > this is okay in sampling mode
> > because of the skid, anyway?
>
> Correct. The constraint I am placing is to count retire events on
> PMC2 and sample retire events on other counters.
>
Why do you need to permanently exclude CTL2 for retired events given
you are forcing the bits
in the get_constraints() for counting events config only, i.e., as
opposed to in CTL2 itself.
If the sampling retired events are unconstrained, they can use any
counters. If a counting retired
event is added, it has a "stronger" constraints and will be scheduled
before the unconstrained events,
yield the same behavior you wanted, except on demand which is preferable.

> Thanks,
> Ravi
