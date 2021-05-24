Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A08238F63B
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhEXX3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXX26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:28:58 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA466C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:27:28 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id c196so20400653oib.9
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ylvJopS/l/rN5DEH6G/12jUG9DpWnjSlaisS9jvs+G4=;
        b=lgstz3jciBwW2X0HSPQvsMDyCTtqshHiHf/lYAxk89w2gI0rIQJGq+GLQcgqJj2GEr
         ++ChNFHVdpGXUQIOyJfyNSZh7bj9S3HNbQO6GJDp0f6N/PFShuDT8gWjeRBuBZQLBjkS
         WbPBJ2mSg9cihRI8LR4QqYoWh8DZ07kg6b0FauB9jOtxGDoeqVOrnzRABH3NdfWfIwdP
         swabHzd/9I5UOZe/893pbmDKarpvXQqzdwrGIG6AgefpzI5E9I5tSOJXJHlAbiCrZ+Yf
         2BbkzcIqKXRA3UehzagkO8jg/YDaTh2/JFPaOifJl9fO4KPmgqldxRmxqEn35L48qcTo
         zfNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ylvJopS/l/rN5DEH6G/12jUG9DpWnjSlaisS9jvs+G4=;
        b=FgpE4SbDBqaiWrnNgJfR1ZAdWREN4JEISt9SOz41oZscWLKmMWkLAzXNr1S96179tv
         B6EsehhYn9O+l7Z7rCycKeK+obFVpXYAJnDEf0EoOkozgSNKoavrUwiM5VEJAB5aZspm
         cq7RiovfOlSCxijUD1aTl2gVOdkPp5jQ9KVSg8T0SCs+3Kvr0NHggim/jHS+nw8x8H6P
         Xp5cLtsEKiZTDCWvtxbJALPrZWiUEL6oKgOcKLHdDysznivlbvnxKJfMw+x0hepyZJWB
         jni78D8wd9P/l7DHF3Q3jzWTqYx4vux616ncQZyu3DDMuWbH3lDcTRAoB/SeX/74/Oct
         z/Jw==
X-Gm-Message-State: AOAM532c4+jeBdSpnXq1RhSfqUJH+5I8t3CN7stH+Kypa+OYtcC/vFrJ
        PwLWEOMuLOVfi8wMIT82XSQsRq/DZk0oawQ1w84ytA==
X-Google-Smtp-Source: ABdhPJzkezwoyhhlXzaVarBahVRhWS92F1TE0bP3XPj2sGBxOMdfuEeqU0wcU+o4c+6sQ4EdALp1ebuLCjKpIe4gARQ=
X-Received: by 2002:aca:1e07:: with SMTP id m7mr11942547oic.28.1621898847399;
 Mon, 24 May 2021 16:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com> <20210520230339.267445-8-jmattson@google.com>
 <YKw1FGuq5YzSiael@google.com>
In-Reply-To: <YKw1FGuq5YzSiael@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 16:27:16 -0700
Message-ID: <CALMp9eQikiZRzX+UtdTW4rHO+jT2uo5xmrtGGs1V96kEZAHh_A@mail.gmail.com>
Subject: Re: [PATCH 07/12] KVM: nVMX: Disable vmcs02 posted interrupts if
 vmcs12 PID isn't mappable
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 4:22 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, May 20, 2021, Jim Mattson wrote:
> > Don't allow posted interrupts to modify a stale posted interrupt
> > descriptor (including the initial value of 0).
> >
> > Empirical tests on real hardware reveal that a posted interrupt
> > descriptor referencing an unbacked address has PCI bus error semantics
> > (reads as all 1's; writes are ignored). However, kvm can't distinguish
> > unbacked addresses from device-backed (MMIO) addresses, so it should
> > really ask userspace for an MMIO completion. That's overly
> > complicated, so just punt with KVM_INTERNAL_ERROR.
> >
> > Don't return the error until the posted interrupt descriptor is
> > actually accessed. We don't want to break the existing kvm-unit-tests
> > that assume they can launch an L2 VM with a posted interrupt
> > descriptor that references MMIO space in L1.
> >
> > Fixes: 6beb7bd52e48 ("kvm: nVMX: Refactor nested_get_vmcs12_pages()")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 706c31821362..defd42201bb4 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3175,6 +3175,15 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> >                               offset_in_page(vmcs12->posted_intr_desc_addr));
> >                       vmcs_write64(POSTED_INTR_DESC_ADDR,
> >                                    pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
> > +             } else {
> > +                     /*
> > +                      * Defer the KVM_INTERNAL_ERROR exit until
> > +                      * someone tries to trigger posted interrupt
> > +                      * processing on this vCPU, to avoid breaking
> > +                      * existing kvm-unit-tests.
>
> Run the lines out to 80 chars.  Also, can we change the comment to tie it to
> CPU behavior in someway?  A few years down the road, "existing kvm-unit-tests"
> may not have any relevant meaning, and it's not like kvm-unit-tests is bug free
> either.  E.g. something like
>
>                         /*
>                          * Defer the KVM_INTERNAL_ERROR exit until posted
>                          * interrupt processing actually occurs on this vCPU.
>                          * Until that happens, the descriptor is not accessed,
>                          * and userspace can technically rely on that behavior.
>                          */
Okay...except for the fact that kvm will rather gratuitously process
posted interrupts in situations where hardware won't. That makes it
difficult to tie this to hardware behavior.
