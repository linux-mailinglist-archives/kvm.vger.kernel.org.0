Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F811470E3F
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 23:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243322AbhLJW7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 17:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhLJW7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 17:59:04 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9A2C061A32
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 14:55:28 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z6so9706056pfe.7
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 14:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OEoq/UZ7+zbPbIcjZ/lLhyqMz9grmq4kvskbdq+Ssgc=;
        b=OPrit17Wnl9n/cn3qrK+iBdRQtYDJv0PHSNI35mcaRSTuTZWzChyUcMPXJPFMld2d7
         4m5kRXP55RiYxokMGhhFSF0q6XPk+vbmwvWIxVZl3HFxtGBtp5mJlfk5GHt+s6YksDZI
         0TMP26gP5gSMXPN292kCv9JOpuEzEFw4VjjUFoTcctywLkBvvn7Eql8Adv0ItuBAZKcx
         n7c1XNy4VnL/FLWXEEqfHu9AvrJdC8z6YQ9sN9sQi1+I0Pn5ULIdKjNb2LFjxQAiqhEB
         2pmeW0NolvkLVrUhFKp8Msz4W9WTxarRR8a2dTuHlaKMzf6YJ7iVG3ljUfyNqycyFVPr
         joDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OEoq/UZ7+zbPbIcjZ/lLhyqMz9grmq4kvskbdq+Ssgc=;
        b=WooDA7k8w8+12LfiL6krr2WeFlzbWedqnZA2NJV0YUu179hkszA2UR2xfKYsOLkLtu
         1e5A+A8IAi2Dwcfpd6GZToLNeI2cxIax9LInxhAO4uapDynvFI0KU3WdUjXACJkGneHa
         mtzBdP0qpGQBwe+6hx0h0hfsGJWehq7jc9Vf310rLbibUJyhg6Bp/j7PGnj8yFYqGzqw
         CHFAEW6rorTmYxbDYC5m8RVylDttaH0f49w31aybDoF9LVgrWGYCAXPcXjvl9+GGFIZw
         keFnZ89MD0Bsj98ZWz2fepzo9xhdvigHJ59Yv1DdneMGWJIv8t+fNowLIUC6sL4ISmTx
         YhEg==
X-Gm-Message-State: AOAM532KxSJbIGBNR2315eCQZXMFeTnrc0+XrUwO6vh1kv7LoSrsZNQR
        eFYkGcAQab7Lh0DvXcDC6z4X7HhKqMiXlOUAoz9fPQ==
X-Google-Smtp-Source: ABdhPJwDux8N5f0eFlFASHAeIKXzMGf2bK9aq9h7H0EpuP6hQmjVRDM1E5CMjydzNFBtppILTf+lVcmbk4rORZsLM7U=
X-Received: by 2002:a63:784:: with SMTP id 126mr202955pgh.530.1639176927727;
 Fri, 10 Dec 2021 14:55:27 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-5-likexu@tencent.com>
 <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com>
 <0ca44f61-f7f1-0440-e1e1-8d5e8aa9b540@gmail.com> <CALMp9eTtsMuEsimONp7TOjJ-uskwJBD-52kZzOefSKXeCwn_5A@mail.gmail.com>
 <b6c1eb18-9237-f604-9a96-9e6ca397121c@redhat.com>
In-Reply-To: <b6c1eb18-9237-f604-9a96-9e6ca397121c@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 10 Dec 2021 14:55:16 -0800
Message-ID: <CALMp9eRy==yu1uQriqbeezeQ+mtFyfyP_iy9HdDiSZ27SnEfFg@mail.gmail.com>
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

On Fri, Dec 10, 2021 at 1:35 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/10/21 01:54, Jim Mattson wrote:
> > On Thu, Dec 9, 2021 at 12:28 AM Like Xu <like.xu.linux@gmail.com> wrote:
> >>
> >> On 9/12/2021 12:25 pm, Jim Mattson wrote:
> >>>
> >>> Not your change, but if the event is counting anything based on
> >>> cycles, and the guest TSC is scaled to run at a different rate from
> >>> the host TSC, doesn't the initial value of the underlying hardware
> >>> counter have to be adjusted as well, so that the interrupt arrives
> >>> when the guest's counter overflows rather than when the host's counter
> >>> overflows?
> >>
> >> I've thought about this issue too and at least the Intel Specification
> >> did not let me down on this detail:
> >>
> >>          "The counter changes in the VMX non-root mode will follow
> >>          VMM's use of the TSC offset or TSC scaling VMX controls"
> >
> > Where do you see this? I see similar text regarding TSC packets in the
> > section on Intel Processor Trace, but nothing about PMU counters
> > advancing at a scaled TSC frequency.
>
> Indeed it seems quite unlikely that PMU counters can count fractionally.
>
> Even for tracing the SDM says "Like the value returned by RDTSC, TSC
> packets will include these adjustments, but other timing packets (such
> as MTC, CYC, and CBR) are not impacted".  Considering that "stand-alone
> TSC packets are typically generated only when generation of other timing
> packets (MTCs and CYCs) has ceased for a period of time", I'm not even
> sure it's a good thing that the values in TSC packets are scaled and offset.
>
> Back to the PMU, for non-architectural counters it's not really possible
> to know if they count in cycles or not.  So it may not be a good idea to
> special case the architectural counters.

In that case, what we're doing with the guest PMU is not
virtualization. I don't know what it is, but it's not virtualization.

Exposing non-architectural events is questionable with live migration,
and TSC scaling is unnecessary without live migration. I suppose you
could have a migration pool with different SKUs of the same generation
with 'seemingly compatible' PMU events but different TSC frequencies,
in which case it might be reasonable to expose non-architectural
events, but I would argue that any of those 'seemingly compatible'
events are actually not compatible if they count in cycles.

Unless, of course, Like is right, and the PMU counters do count fractionally.
