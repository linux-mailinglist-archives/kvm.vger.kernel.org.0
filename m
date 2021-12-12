Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12902471851
	for <lists+kvm@lfdr.de>; Sun, 12 Dec 2021 06:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhLLE4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 23:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhLLE4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 23:56:54 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9A7C061751
        for <kvm@vger.kernel.org>; Sat, 11 Dec 2021 20:56:54 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso13886612otj.11
        for <kvm@vger.kernel.org>; Sat, 11 Dec 2021 20:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxiNtCo8FAmPT/CsvWMylrg0lFIpjinzhe3T8bV2cL8=;
        b=gvFZd3OhcizPGf47jqdiayAzdIF4bROxr9hIGS2bcbovtpyqm1PiMVw0th9OYksido
         FqNyeSHzMVf3fy96fNlo27IwEtaoPSwKCKyjniQ0kSw6as33XV64nYJz1B56cme4ufB6
         4dKxowOEQMJqXhOIAN+wnYlQ0hPBdpUZCqdEhfywWXuTmV827DaqtqsreA5VY9GICkgq
         TrFIPyqUz7Nh6bH6k9HO/iWUzMn7sI6EicaqQ4qfje2nBlEUHpp/VJG8AuDLOQ7D4/n0
         orZwsmlgNvHxG0ais+S7e8Deb1tDzd98Yl7RhhkMl/m/yCkEtxt/c57ruCLDlxFH6Mxq
         vtWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OxiNtCo8FAmPT/CsvWMylrg0lFIpjinzhe3T8bV2cL8=;
        b=DzAPk6qCzwOX3D/klClWw7a8YYiXa+AUjsuga/6UV7DhFshUSwDbXTcyMSPXfKFDNE
         m2LGDZ/mDz4lOw9USjpAOEl4KUm2PEUXp0ibuIG1gmg/TZjM4S7kRWUBdWMDIftZp/5Z
         l7a5f/3Vj81xkiwsfm5KJuGXklw1FCYzoTTRwdvj0+UqXmtC7izzPuHSsB+9DwaJ/qtD
         NUJbC1A6iU/z6JRPQfKrnZglJXXhQV+660PNm4lK/1zkd2pCxf6FlTvP8NIxYL3z3t/k
         ZnMOkXOSHtboO+/4HTjporZEyGMNZ9iL6pv+CrZecOQ7gqPV8NFnIt2orsaxEFgbEXTr
         3sRQ==
X-Gm-Message-State: AOAM532UbHtcotIMkRwaTomnoSxjNIxANEcuwQ4Y4nB/Xe9Isos7PNjV
        b1Fn3RuE7SoEmZovsYCRiU27LsdhIOesmRQGA/thfA==
X-Google-Smtp-Source: ABdhPJwPa3OmsdnUlkIn8H++jGaQIhTDXfkvAYFE7G9HjThGT5fk8FT3u+lJSXmlBKtEb9we1oIgTCRrgPS3dqY0tfk=
X-Received: by 2002:a05:6830:601:: with SMTP id w1mr18332359oti.267.1639285013242;
 Sat, 11 Dec 2021 20:56:53 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-5-likexu@tencent.com>
 <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com>
 <0ca44f61-f7f1-0440-e1e1-8d5e8aa9b540@gmail.com> <CALMp9eTtsMuEsimONp7TOjJ-uskwJBD-52kZzOefSKXeCwn_5A@mail.gmail.com>
 <b6c1eb18-9237-f604-9a96-9e6ca397121c@redhat.com> <CALMp9eRy==yu1uQriqbeezeQ+mtFyfyP_iy9HdDiSZ27SnEfFg@mail.gmail.com>
 <c381aa2c-beb5-480f-1f24-a14de693e78f@redhat.com> <CALMp9eTKrQVCQPm=hcA50JSUCctPaGLEP19biVbGAtBN54dQfA@mail.gmail.com>
In-Reply-To: <CALMp9eTKrQVCQPm=hcA50JSUCctPaGLEP19biVbGAtBN54dQfA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 11 Dec 2021 20:56:42 -0800
Message-ID: <CALMp9eS8xDgdbfJTbzMmek3RcXKwkLdGMW-uMkJR3eJZ6sf0GA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021 at 3:31 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Dec 10, 2021 at 2:59 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 12/10/21 23:55, Jim Mattson wrote:
> > >>
> > >> Even for tracing the SDM says "Like the value returned by RDTSC, TSC
> > >> packets will include these adjustments, but other timing packets (such
> > >> as MTC, CYC, and CBR) are not impacted".  Considering that "stand-alone
> > >> TSC packets are typically generated only when generation of other timing
> > >> packets (MTCs and CYCs) has ceased for a period of time", I'm not even
> > >> sure it's a good thing that the values in TSC packets are scaled and offset.
> > >>
> > >> Back to the PMU, for non-architectural counters it's not really possible
> > >> to know if they count in cycles or not.  So it may not be a good idea to
> > >> special case the architectural counters.
> > >
> > > In that case, what we're doing with the guest PMU is not
> > > virtualization. I don't know what it is, but it's not virtualization.
> >
> > It is virtualization even if it is incompatible with live migration to a
> > different SKU (where, as you point out below, multiple TSC frequencies
> > might also count as multiple SKUs).  But yeah, it's virtualization with
> > more caveats than usual.
>
> It's not virtualization if the counters don't count at the rate the
> guest expects them to count.

Per the SDM, unhalted reference cycles count at "a fixed frequency."
If the frequency changes on migration, then the value of this event is
questionable at best. For unhalted core cycles, on the other hand, the
SDM says, "The performance counter for this event counts across
performance state transitions using different core clock frequencies."
That does seem to permit frequency changes on migration, but I suspect
that software expects the event to count at a fixed frequency if
INVARIANT_TSC is set.

I'm not sure that I buy your argument regarding consistency. In
general, I would expect the hypervisor to exclude non-architected
events from the allow-list for any VM instances running in a
heterogeneous migration pool. Certainly, those events could be allowed
in a heterogeneous migration pool consisting of multiple SKUs of the
same microarchitecture running at different clock frequencies, but
that seems like a niche case.


> > > Exposing non-architectural events is questionable with live migration,
> > > and TSC scaling is unnecessary without live migration. I suppose you
> > > could have a migration pool with different SKUs of the same generation
> > > with 'seemingly compatible' PMU events but different TSC frequencies,
> > > in which case it might be reasonable to expose non-architectural
> > > events, but I would argue that any of those 'seemingly compatible'
> > > events are actually not compatible if they count in cycles.
> > I agree.  Support for marshaling/unmarshaling PMU state exists but it's
> > more useful for intra-host updates than for actual live migration, since
> > these days most live migration will use TSC scaling on the destination.
> >
> > Paolo
> >
> > >
> > > Unless, of course, Like is right, and the PMU counters do count fractionally.
> > >
> >
