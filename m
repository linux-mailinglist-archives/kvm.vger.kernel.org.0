Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9908445F77
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 06:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhKEFj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 01:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhKEFj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 01:39:26 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A721AC061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 22:36:47 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id g29so2416001lfv.4
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 22:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Le5Akq/lLNHfW+ACWvF/lDzejDp+WOssI/Klk1stMA=;
        b=OgQLhazLrEPYEDYrelueE2X8jJx+zu4fuCkHALRCPejgs1CpaggSdEXEgHypuwb4VV
         IMxR8yZ6H/Mwdd3PLdL+DDU6QCVLAp89GfqMxK3AXc/tCb61yW+Q9JRL+lYTidew4VOV
         uwyEEh4Gwei+J9krQwGqe9hXSamizJG7/34871VA242B1qLqkFCwJTjZOoN5KDv438h1
         63WVF7bqoknA9qybq7EecyKKk7r0OqPN+fxGUNnmLVYwlm+XT98b0I9H2hnQAqzczj0N
         IWfC4INooR51z83b2QmXsdxV/h8tDZNzYA3gPTDfU9YlfVB1raXjuziX8v2m+adlAh/8
         23bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Le5Akq/lLNHfW+ACWvF/lDzejDp+WOssI/Klk1stMA=;
        b=RZxmLRyclq73mzxVhBlJ5GAcIsl3mTtO2MJwg32IUgY4GlCUsLQUJi/iEZ3e+KZPV0
         I4jL8bEs2MhtqonIAmaWDLdwDQCKRQRNpcEqIHAjvj9FWh9ek+ahIwIcspfD1x6n6DZI
         iXV8IkOnKI//Kr2ypjakKTd2ov1fA0eWKyMm0jTCWhAPEOq+kPB//AKXcxsJJyHnhN8E
         T8IdkaIpPkLlTpoi7pNiPzoiyV7Wl0cDLpzHYVaeMFqAPxdAiLgLyPokrpP37R7Yg0R0
         SNoDbJmt01jia8H4X2645Nn/4vZX+yd3TstoTPUADV0mN8UmsM0w/Fgg/XaHWEufvhgP
         ptWQ==
X-Gm-Message-State: AOAM530VNS07+cugH6yQo/2b3ejw2dVR1r4YQcpqdLc1/kiZvG8Xydmr
        0o08Kgrm0+nJSB3VDkLhfOY12I9sV3Yrat4zW6YNPQ==
X-Google-Smtp-Source: ABdhPJyNUuISSdEPBd3M4w6ZjW+jtk9a314Xeh6niI4f9CO4Jdi23JUL/bOS8pQ1DFehgvxl9D6sizD87Y+0y+M0SYM=
X-Received: by 2002:a05:6512:3d90:: with SMTP id k16mr4911113lfv.361.1636090605698;
 Thu, 04 Nov 2021 22:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com> <20211102094651.2071532-5-oupton@google.com>
 <CAAeT=FwKJLaxNU+2BGWZh=HdTY=NWBzGdN=cTDPKv3x6cG2UsA@mail.gmail.com>
In-Reply-To: <CAAeT=FwKJLaxNU+2BGWZh=HdTY=NWBzGdN=cTDPKv3x6cG2UsA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 4 Nov 2021 22:36:34 -0700
Message-ID: <CAOQ_QshXAzRkKXJjp5Q6KEHQ8vFkc1hVnktEj82nBLN8+=_42w@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Emulate the OS Lock
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 4, 2021 at 8:56 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Oliver,
>
> On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
> >
> > The OS lock blocks all debug exceptions at every EL. To date, KVM has
> > not implemented the OS lock for its guests, despite the fact that it is
> > mandatory per the architecture. Simple context switching between the
> > guest and host is not appropriate, as its effects are not constrained to
> > the guest context.
> >
> > Emulate the OS Lock by clearing MDE and SS in MDSCR_EL1, thereby
> > blocking all but software breakpoint instructions. To handle breakpoint
> > instructions, trap debug exceptions to EL2 and skip the instruction.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  4 ++++
> >  arch/arm64/kvm/debug.c            | 20 +++++++++++++++-----
> >  arch/arm64/kvm/handle_exit.c      |  8 ++++++++
> >  arch/arm64/kvm/sys_regs.c         |  6 +++---
> >  4 files changed, 30 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index c98f65c4a1f7..f13b8b79b06d 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -724,6 +724,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> > +
> > +#define kvm_vcpu_os_lock_enabled(vcpu)         \
> > +       (__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK)
>
> I would think the name of this macro might sound like it generates
> a code that is evaluated as bool :)

Hey! Nobody ever said this would coerce the returned value into a bool :-P

In all seriousness, good point. I agree that the statement should
obviously evaluate to a bool, given the naming of the macro.

>
> > +
> >  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> >                                struct kvm_device_attr *attr);
> >  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index db9361338b2a..5690a9c99c89 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -95,8 +95,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
> >                                 MDCR_EL2_TDRA |
> >                                 MDCR_EL2_TDOSA);
> >
> > -       /* Is the VM being debugged by userspace? */
> > -       if (vcpu->guest_debug)
> > +       /*
> > +        * Check if the VM is being debugged by userspace or the guest has
> > +        * enabled the OS lock.
> > +        */
> > +       if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu))
>
> IMHO, it might be nicer to create a macro or function that abstracts the
> condition that needs save_guest_debug_regs/restore_guest_debug_regs.
> (rather than putting those conditions in each part of codes where they
> are needed)
>

I completely agree, and it comes with the added benefit that the
macro/function can be named something informative so as to suggest the
purpose for saving guest registers.

Thanks for the review!

--
Oliver
