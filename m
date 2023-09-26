Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47747AEFDF
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 17:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbjIZPon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 11:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjIZPol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 11:44:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213CF116
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 08:44:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d848694462aso13712251276.3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 08:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695743073; x=1696347873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dUqxLY2nTBwa9TznKkTTvHje90znBvp6KBryn5bkyvU=;
        b=zrnFlS6O3Q/Uf1lgaA7OEby+ESk7FU/X4I2aqgg6RW384xfQNSiF/q0b4VFU9axZfu
         WYcyY8OO3ee2HZ9VDCq1JUHrl3iUqXZvUOBVm6McNzCIK4/jjtrQJRLFgY/BkL80ejZw
         YFVCqzf+72WbpSQDg6pnjSyxbkM3aiyD3TxLZWQZzf7h75jk5Cc8SVCxZpLtmP4nWlxE
         ssFzE8OuD9lIzFHqwvX9YAmtd4UnJsgfkuMy3ns+S7egO19Tl4jCdINCWfVzgbEz++KM
         50szg3qBkspaXBrGUbgttOTToHfYps2x4su4lDAaxOxBIsAy7nitpaJ/xWGO4ua6IGCP
         z56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695743073; x=1696347873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dUqxLY2nTBwa9TznKkTTvHje90znBvp6KBryn5bkyvU=;
        b=sU6OIzzi1xH2+5cfsoYx91aqQr29nvPbGTwWNZKXsdte9RomF++ZaBRXjFAWxLOMAN
         dXQGnyWKKdh9nBmkY8h5gK3+smGDvzXaOLZZPxBHtLd88VO+wVIGYAw4hsXlcH/yFzUX
         5zoR8U8tE0nnSMvNmlPs7bXxRiLc+nUxrXRvVCEmTqsQYAcUxzyauVqEyJ/WLxUOf3nv
         KXW8s9VxopjJC+CwGx4ovRZQi7YJAmB/g/mzGaEFg2nIOCv7wtXPxMa7Vdfbtq2l+OcO
         SpYPRtuU+TALopNhbYfPTpTH8hhGTa3ZzUJ2puzo5HSaoI7S4UfZVR7xJ0zZF1GmLY29
         voEw==
X-Gm-Message-State: AOJu0Yyl+SOF++GHoyW2mv2/SBUdCo5E2TOOy9Ppi0jEqbNvRBA4kQjl
        qAE8e7sXZHl38b2wXtwRYHL+9Dr7I8g=
X-Google-Smtp-Source: AGHT+IGme/vBiUuM/J3y+xMji41rNGS2G4ms8AQla0qKpMBJJt6otcitWzAieqjeVbUWwrD7XMmD/9I+6No=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8c02:0:b0:d81:43c7:61ed with SMTP id
 k2-20020a258c02000000b00d8143c761edmr104033ybl.5.1695743073295; Tue, 26 Sep
 2023 08:44:33 -0700 (PDT)
Date:   Tue, 26 Sep 2023 08:44:31 -0700
In-Reply-To: <90dd2e2e-71ae-d8c4-5d3b-9628e7710337@gmail.com>
Mime-Version: 1.0
References: <20230407085646.24809-1-likexu@tencent.com> <ZDA4nsyAku9B2/58@google.com>
 <6ee140c9-ccd5-9569-db17-a542a7e28d5c@gmail.com> <ZRIYbu4wSVW9a+8i@google.com>
 <90dd2e2e-71ae-d8c4-5d3b-9628e7710337@gmail.com>
Message-ID: <ZRL8X74x2jnD2Mue@google.com>
Subject: Re: [PATCH V2] KVM: x86/pmu: Disable vPMU if EVENTSEL_GUESTONLY bit
 doesn't exist
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Manali Shukla <manali.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023, Like Xu wrote:
> On 26/9/2023 7:31 am, Sean Christopherson wrote:
> > On Thu, Sep 14, 2023, Like Xu wrote:
> > > On 7/4/2023 11:37 pm, Sean Christopherson wrote:
> > > > On Fri, Apr 07, 2023, Like Xu wrote:
> > > /*
> > >   * The guest vPMU counter emulation depends on the EVENTSEL_GUESTONLY bit.
> > >   * If this bit is present on the host, the host needs to support at least
> > > the PERFCTR_CORE.
> > >   */
> > 
> > ...
> > 
> > > > 	/*
> > > > 	 * KVM requires guest-only event support in order to isolate guest PMCs
> > > > 	 * from host PMCs.  SVM doesn't provide a way to atomically load MSRs
> > > > 	 * on VMRUN, and manually adjusting counts before/after VMRUN is not
> > > > 	 * accurate enough to properly virtualize a PMU.
> > > > 	 */
> > > > 
> > > > But now I'm really confused, because if I'm reading the code correctly, perf
> > > > invokes amd_core_hw_config() for legacy PMUs, i.e. even if PERFCTR_CORE isn't
> > > > supported.  And the APM documents the host/guest bits only for "Core Performance
> > > > Event-Select Registers".
> > > > 
> > > > So either (a) GUESTONLY isn't supported on legacy CPUs and perf is relying on AMD
> > > > CPUs ignoring reserved bits or (b) GUESTONLY _is_ supported on legacy PMUs and
> > > > pmu_has_guestonly_mode() is checking the wrong MSR when running on older CPUs.
> > > > 
> > > > And if (a) is true, then how on earth does KVM support vPMU when running on a
> > > > legacy PMU?  Is vPMU on AMD just wildly broken?  Am I missing something?
> > > > 
> > > 
> > > (a) It's true and AMD guest vPMU have only been implemented accurately with
> > > the help of this GUESTONLY bit.
> > > 
> > > There are two other scenarios worth discussing here: one is support L2 vPMU
> > > on the PERFCTR_CORE+ host and this proposal is disabling it; and the other
> > > case is to support AMD legacy vPMU on the PERFCTR_CORE+ host.
> > 
> > Oooh, so the really problematic case is when PERFCTR_CORE+ is supported but
> > GUESTONLY is not, in which case KVM+perf *think* they can use GUESTONLY (and
> > HOSTONLY).
> > 
> > That's a straight up KVM (as L0) bug, no?  I don't see anything in the APM that
> > suggests those bits are optional, i.e. KVM is blatantly violating AMD's architecture
> > by ignoring those bits.
> 
> For L2 guest, it often doesn't see all the cpu features corresponding to the
> cpu model because KVM and VMM filter some of the capabilities. We can't say
> that the absence of these features violates spec, can we ?

Yes, KVM hides features via architectural means.  This is enumerating a feature,
PERFCTR_CORE, and not providing all its functionalality.  The two things are
distinctly different.

> I treat it as a KVM flaw or a lack of emulation capability.

A.k.a. a bug.

> > I would rather fix KVM (as L0).  It doesn't seem _that_ hard to support, e.g.
> > modify reprogram_counter() to disable the counter if it's supposed to be silent
> > for the current mode, and reprogram all counters if EFER.SVME is toggled, and on
> > all nested transitions.
> 
> I thought about that too, setting up EFER.SVME and VMRUN is still a little
> bit far away, and more micro-testing is needed to correct the behavior
> of the emulation here, considering KVM also has to support emulated ins.
> 
> It's safe to say that there are no real user scenarios using vPMU in a nested
> guest, so I'm more inclined to disable it provisionally (for the sake of more
> stable tree users), enabling this feature is honestly at the end of my to-do list.

I don't see a way to do that without violating AMD's architecture while still
exposing the PMU to L1.
