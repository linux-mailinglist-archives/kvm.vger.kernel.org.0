Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7D67ADCFA
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 18:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjIYQWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 12:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjIYQWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 12:22:50 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5073CE
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 09:22:43 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1dcead29b3eso2103788fac.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 09:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695658963; x=1696263763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qGAC6HVwPjNMFGu5r+6tMEdR6TTPhbLuj1N6QdoHjJg=;
        b=LqccLP9WwJNTBTWzN1wqGiFPVhej1JShecn4BvKk9r2fHvMdpXHeZbckKnE7CbLHsk
         qpsjuiZyxh6kDb5F2hDEqOBqhw5L7dkQXaXYIRGyUnJEkdTCdI88XRgm0n0audf3v+J5
         aIvbveUHAbosfzQwWtHdoJHEb9YhEhARNPB6Gx1MHU6BXtNmf7kUajjP+no15YwLAc+c
         4g9hfrJCx8NZGIe4xtrtRV/PLyPFCn6rFohfDTmYNaQRSZGDhfRtL+If2jVgWgBTKR6M
         d1s8jsrRq+hdYf8ymWaW/gMXfrlqyyEqGR88EwldxXCLPnEG23pvlJWUqzGpT+dFMEP5
         tdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695658963; x=1696263763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qGAC6HVwPjNMFGu5r+6tMEdR6TTPhbLuj1N6QdoHjJg=;
        b=p92rlD6M0+xGaadz+VvNx2MtfF0weRW8TRwFa+OEhaHrd7m3T4XWlSoCMXmXk7xKaM
         N9h48aBuPFhuUin/6rNHKfsLMxsTirWITzqpAuU1bjhSQ7GyRFAvIcDWG1hthCp3q9Zc
         x448ONkHTSL9XKinDTfcHbsIUAz6XHTt0Od5a3RA0Z8imC2cAZpMSOY7CL+1rDovcbss
         zAHFIHOedzPRcfQeBbd9Hwh7dWQAXwDR6N5W6yJhMVi5Ksap3xSeQU7AqRWsPcKRNKaR
         mAYY113XPXNmpHkBoDdXArTeDmySzm2cJS5IAmaIsQaM98GEYjrCQJSk4mslwYhWCaOZ
         3JaA==
X-Gm-Message-State: AOJu0YwE3OXX1W4pXu3pZcMvx97BEMgvj/F9fY8aH1gT6Kb/hBNf86/c
        e5Sz29AFXlYlzjFvk09e01WWi+rRZCm+zvd/eFuhEg==
X-Google-Smtp-Source: AGHT+IEfIhOm+Zcsn5syMr7vn8IMRXEkpdkqFrizvKSqee1ZqMnqa2u3GTm2KmJUFDrav73FIU/ISHFbdRWvre80i/s=
X-Received: by 2002:a05:6870:d1d2:b0:1d5:b2ba:bc90 with SMTP id
 b18-20020a056870d1d200b001d5b2babc90mr7570104oac.59.1695658962908; Mon, 25
 Sep 2023 09:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com> <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
 <ZQ4BvCsFjLmnSxhd@google.com> <CAL715WLuqxN5JvcrZ7vcFpmTwuAi_EqKERtvj9BLoT9QVM0Ekw@mail.gmail.com>
 <ZQ4ch3GqM7WH34qv@google.com> <CAL715WLB-3iRrCOxuVNa=NJvGkVaY7K=+i3J7RnxAta81jef0Q@mail.gmail.com>
In-Reply-To: <CAL715WLB-3iRrCOxuVNa=NJvGkVaY7K=+i3J7RnxAta81jef0Q@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 25 Sep 2023 09:22:06 -0700
Message-ID: <CAL715WKjYP0tq1Ls5G0v2Myfhp6SAhqsZhfLZUbSue3mJv2byA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 24, 2023 at 11:09=E2=80=AFPM Mingwei Zhang <mizhang@google.com>=
 wrote:
>
> Hi Sean,
>
> On Fri, Sep 22, 2023 at 4:00=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > > So yes, they could be put together and they could be put separately.
> > > But I don't see why they _cannot_ be together or cause confusion.
> >
> > Because they don't need to be put together.  Roman's patch kinda sorta =
overlaps
> > with the prev_counter mess, but Jim's fixes are entirely orthogonal.
> >
> > If one person initially posted such a series with everything together I=
 probably
> > wouldn't care *too* much, but combining patches and/or series that aren=
't tightly
> > coupled or dependent in some way usually does more harm than good.  E.g=
. if a
> > maintainer has complaints against only one or two patches in series of =
unrelated
> > patches, then grabbing the "good" patches is unnecessarily difficult.  =
It's not
> > truly hard on the maintainer's end, but little bits of avoidable fricti=
on in the
> > process adds up across hundreds and thousands of patches.
> >
> > FWIW, my plan is to apply Roman's patch pretty much as-is, grab v2 from=
 Jim, and
> > post my cleanups as a separate series on top (maybe two series, really =
haven't
> > thought about it yet).  The only reason I have them all in a single bra=
nch is
> > because there are code conflicts and I know I will apply the patches fr=
om Roman
> > and Jim first, i.e. I didn't want to develop on a base that I knew woul=
d become
> > stale.
> >
> > > So, I would like to put them together in the same context with a cove=
r letter
> > > fully describing the details.
> >
> > I certainly won't object to a thorough bug report/analysis, but I'd pre=
fer that
> > Jim's series be posted separately (though I don't care if it's you or J=
im that
> > posts it).
>
> Thanks for agreeing to put things together. In fact, everything
> together means all relevant fix patches for the same bug need to be
> together. But I will put my patch explicitly as _optional_ mentioned
> in the cover letter.
>
> If the series causes inconvenience, please accept my apology. For the
> sense of responsibility, I think I could just use this opportunity to
> send my updated version with your comment fixed. I will also use this
> chance to update your fix to Jim's patches.
>
> One last thing, breaking the kvm-unit-test/pmu still surprises me.
> Please test it again when you have a chance. Maybe adding more fixes
> on top. With the series sent, I will hand it over to you.
>

Never, this is a test failure that we already solved internally.
Applying the following fix to kvm-unit-tests/pmu remove the failures:

diff --git a/x86/pmu.c b/x86/pmu.c
index 0def2869..667e6233 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -68,6 +68,7 @@ volatile uint64_t irq_received;
 static void cnt_overflow(isr_regs_t *regs)
 {
        irq_received++;
+       apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
        apic_write(APIC_EOI, 0);
 }

Since KVM vPMU adds a mask when injecting the PMI, it is the
responsibility of the guest PMI handler to remove the mask and allow
subsequent PMIs delivered.

We should upstream the above fix some time.

Thanks.
-Mingwei
