Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3658138F6C5
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 02:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhEYAGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 20:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhEYAF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 20:05:58 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2B6C06135A
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:04:01 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id z3so28655056oib.5
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pEoq10BsxMRuM2WTvWSRXQ9cA8Vnp+Fa+RnoSfCphgI=;
        b=cTCJ1dLMO67d1IHNSrQZBYAQs7cuzD83O/nHjtc2ZQPCUnhiOEjtJdZWVIYvv0XjJ6
         MKN+twdRYeojrHFrwTARKAkRKwg0DdvC7V7BnP1OoiU+w4bhciuhyWXKeFpJpv+jl61B
         RXREnAstub21camjVlq2Om09IZHkWTh72HVpezOG6UDklzZLF6Cflr3UdiTFjDWXeY1I
         cLYbbmwxyvJCf1GCS+hFvRG0f9q0i8kewSnDWyfqA+7WbwBBnpwiRNesOdScQ1F8nQQ/
         4TAJABrxUZlKSN9L3vCLDheyAbmDNHAoPP315s2nj1pSK5AHH04b7y9zBU3OtlB8YFLU
         Kbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pEoq10BsxMRuM2WTvWSRXQ9cA8Vnp+Fa+RnoSfCphgI=;
        b=RHdxYnOspBHNJ/ql06nsVFSEgc2mhlTgwgi4phwlbliWAYZg8jD2ZCVhMtN9P4+cl1
         h8vW7JQYd/RX1Ub5j+FdaUwV+fJeR532Zl2YozhKmR7NUJ15ks5Z/cx7A/tjEtX3a6ws
         EiwPtHjWDK+w9s7s0dEQbymX8m0Q90OqFCiivUeFD1nxMrEAMGvYp+dylvaXgaVlTaXL
         /8gdB6aZv8xF77mnlUoOutlf/cz9hEG5RqLtJfz1xyTZ+EIehb4mEtpmnrf8zw+kcW8x
         Zlx398jCxpLzg6di9Hhl4DPbLjp8KsRg6KEBqrbUbj5ZKIjonKqx+yyKXYHLCtqSgx70
         oA5g==
X-Gm-Message-State: AOAM533vt+aBIJIjYh3vMuMNpDJegMV3rNicQ3//3R2Cj0m4MYMlVQN5
        oivhrNuTc0LdYrdOQKTGrSKgG/UJ2PwygcW0Gp+FMqbogeM=
X-Google-Smtp-Source: ABdhPJzE+ioA61reGimanwlkKtB5oIxpTryTMr7yr7LEcU0X/Hc9lkV1Oqp74FdL9yrV1gnBvvAaxFy5M1jrBilI618=
X-Received: by 2002:aca:1e07:: with SMTP id m7mr12013060oic.28.1621901040698;
 Mon, 24 May 2021 17:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com> <20210520230339.267445-8-jmattson@google.com>
 <YKw1FGuq5YzSiael@google.com> <CALMp9eQikiZRzX+UtdTW4rHO+jT2uo5xmrtGGs1V96kEZAHh_A@mail.gmail.com>
 <YKw6mpWe3UFY2Gnp@google.com>
In-Reply-To: <YKw6mpWe3UFY2Gnp@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 17:03:49 -0700
Message-ID: <CALMp9eQy=JhQDzk_LYwrOpbv3hhhi_BT=5rwjHpfTuTQShzkww@mail.gmail.com>
Subject: Re: [PATCH 07/12] KVM: nVMX: Disable vmcs02 posted interrupts if
 vmcs12 PID isn't mappable
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 4:45 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 24, 2021, Jim Mattson wrote:
> > On Mon, May 24, 2021 at 4:22 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Thu, May 20, 2021, Jim Mattson wrote:
> > > > Don't allow posted interrupts to modify a stale posted interrupt
> > > > descriptor (including the initial value of 0).
> > > >
> > > > Empirical tests on real hardware reveal that a posted interrupt
> > > > descriptor referencing an unbacked address has PCI bus error semantics
> > > > (reads as all 1's; writes are ignored). However, kvm can't distinguish
> > > > unbacked addresses from device-backed (MMIO) addresses, so it should
> > > > really ask userspace for an MMIO completion. That's overly
> > > > complicated, so just punt with KVM_INTERNAL_ERROR.
> > > >
> > > > Don't return the error until the posted interrupt descriptor is
> > > > actually accessed. We don't want to break the existing kvm-unit-tests
> > > > that assume they can launch an L2 VM with a posted interrupt
> > > > descriptor that references MMIO space in L1.
> > > >
> > > > Fixes: 6beb7bd52e48 ("kvm: nVMX: Refactor nested_get_vmcs12_pages()")
> > > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/nested.c | 15 ++++++++++++++-
> > > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index 706c31821362..defd42201bb4 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -3175,6 +3175,15 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > > >                               offset_in_page(vmcs12->posted_intr_desc_addr));
> > > >                       vmcs_write64(POSTED_INTR_DESC_ADDR,
> > > >                                    pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
> > > > +             } else {
> > > > +                     /*
> > > > +                      * Defer the KVM_INTERNAL_ERROR exit until
> > > > +                      * someone tries to trigger posted interrupt
> > > > +                      * processing on this vCPU, to avoid breaking
> > > > +                      * existing kvm-unit-tests.
> > >
> > > Run the lines out to 80 chars.  Also, can we change the comment to tie it to
> > > CPU behavior in someway?  A few years down the road, "existing kvm-unit-tests"
> > > may not have any relevant meaning, and it's not like kvm-unit-tests is bug free
> > > either.  E.g. something like
> > >
> > >                         /*
> > >                          * Defer the KVM_INTERNAL_ERROR exit until posted
> > >                          * interrupt processing actually occurs on this vCPU.
> > >                          * Until that happens, the descriptor is not accessed,
> > >                          * and userspace can technically rely on that behavior.
> > >                          */
> > Okay...except for the fact that kvm will rather gratuitously process
> > posted interrupts in situations where hardware won't. That makes it
> > difficult to tie this to hardware behavior.
>
> Hrm, true, but we can at say that KVM won't bail if there's zero chance of posted
> interrupts being processed.  I hope?
Zero chance in KVM, or zero chance on hardware?

For instance, set TPR high enough to block the posted interrupt vector
from being delivered, and there is zero chance of posted interrupts
being processed by hardware. However, if another L1 vCPU sends that
vector by IPI, there is a 100% chance that KVM will bail, because it
ignores TPR for processing posted interrupts.
