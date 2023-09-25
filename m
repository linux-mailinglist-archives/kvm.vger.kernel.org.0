Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC7A7AE24B
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 01:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbjIYXcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 19:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbjIYXcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 19:32:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5544B10A
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 16:32:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d8943298013so2600614276.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 16:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695684720; x=1696289520; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eJxrMaSceLhoHUwbSBQFNIWRaTVumnsiZsfe8eDrUVE=;
        b=mCtQHIkxCWdPRJCpfXNxlDtHqd5VzC4UAbNobaAoCz+dNJLfU6+PkKf9wdOGEgZzkn
         A5cpxXemND6MbXna7ivH4ur2DoIXkIZKQJhjshrNGuZ/PLcCYJMO2dhqyxWycKTtsaoM
         gGcc/x7pEzLpMa5koTkdp4KGDnKlnXOHRXhpRAbeW80Qkb5tYxeRVdy6IXX0EtVSQLkK
         bYkuAaR4s+pIK3Sa7X/CIbGelyNIQE31Yrms8YTF7lh3/MC5XMJ6/WjZDVxPcjqPGCJ3
         fJRYiM1T9RPirFMGdP/JIRXeVXXJ8xc2pbLMQPr4PbvkLbdyjTcG6/3moJHKdQeJ4uNP
         W+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695684720; x=1696289520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eJxrMaSceLhoHUwbSBQFNIWRaTVumnsiZsfe8eDrUVE=;
        b=LPsDVLuwMOnwSAbTRNzCZ349QvPsytNQFlOMAMzdPJOlyr+ROyBhW2Sn3/nR+4rVZf
         x6A38sKezSp+uLUi9kFdxFsd2gykyQxZaZjsG9Dvf/iPabhU04Q3HvuJOEqjH+UDZG6N
         U1j9KonZ3KsmICi6o4Gmhc7U/a0qS8s206ENzAGENNttS3XrHof5B/4Pn+gyv1EI7PZC
         2YT7QvNJCXRvIoRhnrsi6OoEJ9uyn5QlB47QL2o7tbMkWuiN0dq4GskxwjVtyRgNcKwQ
         s2KwLjx+l5HlMDuVzgKeWflZSOPuoagIWuiGW6MvvroTMGrMA+MJZAoYrfZaY+6mZEDq
         b4LA==
X-Gm-Message-State: AOJu0Yz00fu3Y0ncRiOVFM04eu7zf39wFRvm+cI91D0Utp52q5KOCt91
        djsr1/eytwJQz5HpQ41gYRiWBzcyDys=
X-Google-Smtp-Source: AGHT+IFTqVuabA4IX6I79lZE8Po3HLmVzOgwsHJv/8IxUVryjzy3Tnr/aVhfQOI5OAp5xFG794veSUT8RFE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:50ce:0:b0:d74:93a1:70a2 with SMTP id
 e197-20020a2550ce000000b00d7493a170a2mr83729ybb.5.1695684720550; Mon, 25 Sep
 2023 16:32:00 -0700 (PDT)
Date:   Mon, 25 Sep 2023 16:31:58 -0700
In-Reply-To: <6ee140c9-ccd5-9569-db17-a542a7e28d5c@gmail.com>
Mime-Version: 1.0
References: <20230407085646.24809-1-likexu@tencent.com> <ZDA4nsyAku9B2/58@google.com>
 <6ee140c9-ccd5-9569-db17-a542a7e28d5c@gmail.com>
Message-ID: <ZRIYbu4wSVW9a+8i@google.com>
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

On Thu, Sep 14, 2023, Like Xu wrote:
> On 7/4/2023 11:37 pm, Sean Christopherson wrote:
> > On Fri, Apr 07, 2023, Like Xu wrote:
> /*
>  * The guest vPMU counter emulation depends on the EVENTSEL_GUESTONLY bit.
>  * If this bit is present on the host, the host needs to support at least
> the PERFCTR_CORE.
>  */

...

> > 	/*
> > 	 * KVM requires guest-only event support in order to isolate guest PMCs
> > 	 * from host PMCs.  SVM doesn't provide a way to atomically load MSRs
> > 	 * on VMRUN, and manually adjusting counts before/after VMRUN is not
> > 	 * accurate enough to properly virtualize a PMU.
> > 	 */
> > 
> > But now I'm really confused, because if I'm reading the code correctly, perf
> > invokes amd_core_hw_config() for legacy PMUs, i.e. even if PERFCTR_CORE isn't
> > supported.  And the APM documents the host/guest bits only for "Core Performance
> > Event-Select Registers".
> > 
> > So either (a) GUESTONLY isn't supported on legacy CPUs and perf is relying on AMD
> > CPUs ignoring reserved bits or (b) GUESTONLY _is_ supported on legacy PMUs and
> > pmu_has_guestonly_mode() is checking the wrong MSR when running on older CPUs.
> > 
> > And if (a) is true, then how on earth does KVM support vPMU when running on a
> > legacy PMU?  Is vPMU on AMD just wildly broken?  Am I missing something?
> > 
> 
> (a) It's true and AMD guest vPMU have only been implemented accurately with
> the help of this GUESTONLY bit.
> 
> There are two other scenarios worth discussing here: one is support L2 vPMU
> on the PERFCTR_CORE+ host and this proposal is disabling it; and the other
> case is to support AMD legacy vPMU on the PERFCTR_CORE+ host.

Oooh, so the really problematic case is when PERFCTR_CORE+ is supported but
GUESTONLY is not, in which case KVM+perf *think* they can use GUESTONLY (and
HOSTONLY).

That's a straight up KVM (as L0) bug, no?  I don't see anything in the APM that
suggests those bits are optional, i.e. KVM is blatantly violating AMD's architecture
by ignoring those bits.

I would rather fix KVM (as L0).  It doesn't seem _that_ hard to support, e.g.
modify reprogram_counter() to disable the counter if it's supposed to be silent
for the current mode, and reprogram all counters if EFER.SVME is toggled, and on
all nested transitions.
