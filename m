Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB5B38F6D9
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 02:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhEYANE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 20:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhEYANC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 20:13:02 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52021C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:11:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id kr9so7738991pjb.5
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V5CMfQYbAV5VO3NrrDVm5CeDJYXJetIV6QW6GbuyGjQ=;
        b=f0mxZC6d1OqMiOYlBse+lD10I753Ccwu6KUGRGcI7tZT2Q2y96LcyIs62eX323tR+E
         gDO66uKPmb9XESZMVAqqViMTpjoW4hjAgc/rir8513FVfzJI4srvt0akyedGRO5n7tLf
         QBodTwuMopL70IjBifSqVwkOl2sC/2IcHCtag4IbiUoG3iWp183VaehBsw/Hw2YHtkQC
         /0Yu2jv8obx6yfvQUbOLGGmgXqaLYbv8iC+uB/0dzSLqlKGK/yrlqweHPqEVZg6ViX7U
         Vjtd2k40XF1kgD8HvkNx0wdoAGHaJnoCAhdGal/k+mnKHk5y2Tb8mC+lPVxCArlLR9HE
         4I5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V5CMfQYbAV5VO3NrrDVm5CeDJYXJetIV6QW6GbuyGjQ=;
        b=I9W4Tf60yIQ1CFCoQuHMMxjt6+0FLlvCNlN6sgwWH7YW85HTRp6ebF5S3vBdBhuxgL
         Gx/MtvDoI3rdtkE5ohTH93I/ESYzsGW3IqoBjcyMf7r9acHu/XFjBLs7i86S0cbz8cE9
         sbAdOocZTWeaHdbjKcAutYqtj4JBe6Sf/k29jxv5qWvGOBTHenQmPG0MRIz2u2eS4psR
         eVDNMHN1V5axT2IRs+XB8wVvE2w4mh1MEyKNB4oNEyz6+JnCxwsVKF1AZpEOXoVTL54P
         Xyynyptb0YDVqKRxW8RQbPVGiD+cop9SEiv5ZqFiEygoZsEjzJ7gDo+qUubSlJTgZdn+
         wHEg==
X-Gm-Message-State: AOAM5314SD6p84LJ1v1ud6r2VY47lNDLl+2YFUD5g18q51dvQeWShNe9
        Mi0QZzaNkJBVQqoR2KC8lvrMbg==
X-Google-Smtp-Source: ABdhPJx8KUMzrwtdFl4P8LeaRniGHi63vAEcXRafgfXHFCAirNOglu32EOlNpluApLo40Ep3TSwELw==
X-Received: by 2002:a17:90a:986:: with SMTP id 6mr24106869pjo.139.1621901493664;
        Mon, 24 May 2021 17:11:33 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id gn4sm611533pjb.16.2021.05.24.17.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 17:11:33 -0700 (PDT)
Date:   Tue, 25 May 2021 00:11:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/12] KVM: nVMX: Disable vmcs02 posted interrupts if
 vmcs12 PID isn't mappable
Message-ID: <YKxAsZzO1uQx7sf8@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
 <20210520230339.267445-8-jmattson@google.com>
 <YKw1FGuq5YzSiael@google.com>
 <CALMp9eQikiZRzX+UtdTW4rHO+jT2uo5xmrtGGs1V96kEZAHh_A@mail.gmail.com>
 <YKw6mpWe3UFY2Gnp@google.com>
 <CALMp9eQy=JhQDzk_LYwrOpbv3hhhi_BT=5rwjHpfTuTQShzkww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQy=JhQDzk_LYwrOpbv3hhhi_BT=5rwjHpfTuTQShzkww@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Jim Mattson wrote:
> On Mon, May 24, 2021 at 4:45 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, May 24, 2021, Jim Mattson wrote:
> > > On Mon, May 24, 2021 at 4:22 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Thu, May 20, 2021, Jim Mattson wrote:
> > > > > Don't allow posted interrupts to modify a stale posted interrupt
> > > > > descriptor (including the initial value of 0).
> > > > >
> > > > > Empirical tests on real hardware reveal that a posted interrupt
> > > > > descriptor referencing an unbacked address has PCI bus error semantics
> > > > > (reads as all 1's; writes are ignored). However, kvm can't distinguish
> > > > > unbacked addresses from device-backed (MMIO) addresses, so it should
> > > > > really ask userspace for an MMIO completion. That's overly
> > > > > complicated, so just punt with KVM_INTERNAL_ERROR.
> > > > >
> > > > > Don't return the error until the posted interrupt descriptor is
> > > > > actually accessed. We don't want to break the existing kvm-unit-tests
> > > > > that assume they can launch an L2 VM with a posted interrupt
> > > > > descriptor that references MMIO space in L1.
> > > > >
> > > > > Fixes: 6beb7bd52e48 ("kvm: nVMX: Refactor nested_get_vmcs12_pages()")
> > > > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > > ---
> > > > >  arch/x86/kvm/vmx/nested.c | 15 ++++++++++++++-
> > > > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > > index 706c31821362..defd42201bb4 100644
> > > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > > @@ -3175,6 +3175,15 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > > > >                               offset_in_page(vmcs12->posted_intr_desc_addr));
> > > > >                       vmcs_write64(POSTED_INTR_DESC_ADDR,
> > > > >                                    pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
> > > > > +             } else {
> > > > > +                     /*
> > > > > +                      * Defer the KVM_INTERNAL_ERROR exit until
> > > > > +                      * someone tries to trigger posted interrupt
> > > > > +                      * processing on this vCPU, to avoid breaking
> > > > > +                      * existing kvm-unit-tests.
> > > >
> > > > Run the lines out to 80 chars.  Also, can we change the comment to tie it to
> > > > CPU behavior in someway?  A few years down the road, "existing kvm-unit-tests"
> > > > may not have any relevant meaning, and it's not like kvm-unit-tests is bug free
> > > > either.  E.g. something like
> > > >
> > > >                         /*
> > > >                          * Defer the KVM_INTERNAL_ERROR exit until posted
> > > >                          * interrupt processing actually occurs on this vCPU.
> > > >                          * Until that happens, the descriptor is not accessed,
> > > >                          * and userspace can technically rely on that behavior.
> > > >                          */
> > > Okay...except for the fact that kvm will rather gratuitously process
> > > posted interrupts in situations where hardware won't. That makes it
> > > difficult to tie this to hardware behavior.
> >
> > Hrm, true, but we can at say that KVM won't bail if there's zero chance of posted
> > interrupts being processed.  I hope?
> Zero chance in KVM, or zero chance on hardware?

I was hoping hardware...

> For instance, set TPR high enough to block the posted interrupt vector
> from being delivered, and there is zero chance of posted interrupts
> being processed by hardware. However, if another L1 vCPU sends that
> vector by IPI, there is a 100% chance that KVM will bail, because it
> ignores TPR for processing posted interrupts.

Can we instead word it along the lines of:

  Defer the KVM_INTERNAL_EXIT until KVM actually attempts to consume the posted
  interrupt descriptor on behalf of the vCPU.  Note, KVM may process posted
  interrupts when it architecturally should not.  Bugs aside, userspace can at
  least rely on KVM to not process posted interrupts if there is no (posted?)
  interrupt activity whatsoever.
				 
