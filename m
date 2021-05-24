Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850F538F672
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhEXXrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhEXXrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:47:06 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31ABC061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:45:35 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c12so10554914pfl.3
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LrFCaE4ws9tZKOYM6YBLVMi6hRmeNqHhYOSM/UPEs6s=;
        b=NoD/UcGKGQuGp0nBEQUmRj4Thal2UtNy+ClGYEC9UXmbadHX8AsIAM0oqgsxbtbbL4
         d68VLAA48N63vW+QUPE2v0Iq3ON5EH9gf0NrQs92YpdFbXj86Elv36al/bdRncBvCNfX
         z/gEK17gNUqQfUeD1QD24yoad5wHE4HaPUcwTOHtm34InfOypeLXYnGX4uxXUM1x8Nsk
         MZOXpUEddQoq0u71yDYdCycmVqkJpP2VUlkzPvzrze0BMCtX2qxK7PmC1QbF8s3HOAXi
         W/W7tZPBLOX3x8casoiEkm5BRG2fKgmqONjDKlE52+0VCZ0Lff1/fsfeYmaw8eBzeqrC
         /Kug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LrFCaE4ws9tZKOYM6YBLVMi6hRmeNqHhYOSM/UPEs6s=;
        b=lGuFlh6P7EFtEqvK6mP1yxqbGPoif69rs85pF6DXhqXUabjb2C5k295PTK3k+b3RDz
         J2kEogucVMi6Uf3LrQTvWdkJ38t3jFsK4zkQT4DQhdyGTS6665EGjvVYjwAkiNylgGiL
         FQc1+wNqfrzMkHJK7cn2q05RcM/n7EKDv1zWNeLMgfzKNV/EwEH0VDpBZl/DHaTZHxnk
         1nYukJtLoOTIquH8AGbrl+4hunTEJwAfqJlOz1LzAbrNElKyt17+mhiAsFgSuDnTJPYb
         W29kZj+Jjm+nDiGDKCjfik821KPuSKvHCKcy1Rmuyrxwos//rTwJdoza8JYqfdB7H+Td
         XhCA==
X-Gm-Message-State: AOAM530OwKTFZ3L6MtZ9GgejTxSUW9ofCxoUlI7Syu/lkVGZl6VtpDwr
        DztZn8swVL42KIm/awlOKzhMsQ==
X-Google-Smtp-Source: ABdhPJxDJTseKVy3jphs9YqxOPY85UwWFH7WKK/o4nsfEcrRZF/+WD78yfj9wE4+Y5MQZlATZpi1sQ==
X-Received: by 2002:a65:5a08:: with SMTP id y8mr11598162pgs.199.1621899935076;
        Mon, 24 May 2021 16:45:35 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 204sm11646761pfy.56.2021.05.24.16.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:45:34 -0700 (PDT)
Date:   Mon, 24 May 2021 23:45:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/12] KVM: nVMX: Disable vmcs02 posted interrupts if
 vmcs12 PID isn't mappable
Message-ID: <YKw6mpWe3UFY2Gnp@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
 <20210520230339.267445-8-jmattson@google.com>
 <YKw1FGuq5YzSiael@google.com>
 <CALMp9eQikiZRzX+UtdTW4rHO+jT2uo5xmrtGGs1V96kEZAHh_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQikiZRzX+UtdTW4rHO+jT2uo5xmrtGGs1V96kEZAHh_A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Jim Mattson wrote:
> On Mon, May 24, 2021 at 4:22 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, May 20, 2021, Jim Mattson wrote:
> > > Don't allow posted interrupts to modify a stale posted interrupt
> > > descriptor (including the initial value of 0).
> > >
> > > Empirical tests on real hardware reveal that a posted interrupt
> > > descriptor referencing an unbacked address has PCI bus error semantics
> > > (reads as all 1's; writes are ignored). However, kvm can't distinguish
> > > unbacked addresses from device-backed (MMIO) addresses, so it should
> > > really ask userspace for an MMIO completion. That's overly
> > > complicated, so just punt with KVM_INTERNAL_ERROR.
> > >
> > > Don't return the error until the posted interrupt descriptor is
> > > actually accessed. We don't want to break the existing kvm-unit-tests
> > > that assume they can launch an L2 VM with a posted interrupt
> > > descriptor that references MMIO space in L1.
> > >
> > > Fixes: 6beb7bd52e48 ("kvm: nVMX: Refactor nested_get_vmcs12_pages()")
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 15 ++++++++++++++-
> > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 706c31821362..defd42201bb4 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3175,6 +3175,15 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > >                               offset_in_page(vmcs12->posted_intr_desc_addr));
> > >                       vmcs_write64(POSTED_INTR_DESC_ADDR,
> > >                                    pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
> > > +             } else {
> > > +                     /*
> > > +                      * Defer the KVM_INTERNAL_ERROR exit until
> > > +                      * someone tries to trigger posted interrupt
> > > +                      * processing on this vCPU, to avoid breaking
> > > +                      * existing kvm-unit-tests.
> >
> > Run the lines out to 80 chars.  Also, can we change the comment to tie it to
> > CPU behavior in someway?  A few years down the road, "existing kvm-unit-tests"
> > may not have any relevant meaning, and it's not like kvm-unit-tests is bug free
> > either.  E.g. something like
> >
> >                         /*
> >                          * Defer the KVM_INTERNAL_ERROR exit until posted
> >                          * interrupt processing actually occurs on this vCPU.
> >                          * Until that happens, the descriptor is not accessed,
> >                          * and userspace can technically rely on that behavior.
> >                          */
> Okay...except for the fact that kvm will rather gratuitously process
> posted interrupts in situations where hardware won't. That makes it
> difficult to tie this to hardware behavior.

Hrm, true, but we can at say that KVM won't bail if there's zero chance of posted
interrupts being processed.  I hope?
