Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796EF41F1DE
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 18:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhJAQMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 12:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhJAQML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 12:12:11 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E39FC061775
        for <kvm@vger.kernel.org>; Fri,  1 Oct 2021 09:10:27 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x27so40780726lfu.5
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 09:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AOjdVs0gLzgwiu5uLvm60KP3Mb7LDeQaYun407G8UYQ=;
        b=QOQt7xquMrri75hr+imb6/l8b9yxLVWyvzdFTCV3kBQpUZFH76Kl0MhtBP9IRq9Kht
         TfHFJxRAqzYiM//zRd4rKptDVQ0V2Qk5Lq+2+B4RwI4A+AaIiEEJ+9RjQhGHo8ROPpmO
         cp0Rbql5jMhnzgdFrRwGN1azeecrigwFwNlCVMdK+vkWwwqrhpEq8CfgqQkdGclvE9Z9
         QkpqZ3jO0oD7WJOYkrgqOrkrP4rpqmDni8U1zb+rWTz7sy5Ic+y9gppw+9dQFVMfrT7z
         hzLgurXI1N0QRvG1h2+B1qLnU7mD6seEB7cJZwBMW1OPukWuZVh7QbYaqPc1DVSkEClE
         SWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AOjdVs0gLzgwiu5uLvm60KP3Mb7LDeQaYun407G8UYQ=;
        b=lJMIJqwW9z9wqHl0Mx1bor32Zz9uVjFbq/uT8foJjtjouMPZjHIiCjziZGTwfa8bmZ
         mb8Nfu80OEBQuyQ24gFybKc5XhZfqiJCDBgaaNXGAQI16HLCNY4uMcNhRhbaHVAJDXKH
         pEJnPrehYW/WXQTcDIHy0A6LSvZk/aoaazmtvEJbmxl3xM49yk1QLDDNjP/rhLtYAK98
         oDQNyJvFraCPKmJIEO7l0ZIBlosHNvZG8H0/1dP/1XDnWOlzORXHZA38euE8B1zVq8zp
         wqprSBNBFcgo3dyITlvG32+WeEJ1oVixo+lv2CqKcAHJ81o+IYnslGawWhqjTSff8+IK
         j96g==
X-Gm-Message-State: AOAM531jJ9org73dm4yV3/voIZCF+NxH8kewAALYVXIKI1PKuoZy+g8l
        8nzlPGgJaw3qLVzskKI+ku+rb7KOaj8kuIr8FE9MLw==
X-Google-Smtp-Source: ABdhPJxmcZrlAnqTaxaqtK7S3tGDT1MORYk1ITq+wYAf6E76frJZ61t721fneGrclV0Yf3qXB9NhlV9UtDXstD5epgI=
X-Received: by 2002:ac2:4a6e:: with SMTP id q14mr6360221lfp.685.1633104625244;
 Fri, 01 Oct 2021 09:10:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-4-oupton@google.com>
 <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
In-Reply-To: <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 1 Oct 2021 09:10:14 -0700
Message-ID: <CAOQ_QshHDWWEw5BEu-uudFttP1pfJcKuQ-0D_xAkoHJRqYLq8Q@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in a
 helper function
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 11:05 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
> >
> > In its implementation of the PSCI function, KVM needs to request that a
> > target vCPU resets before its next entry into the guest. Wrap the logic
> > for requesting a reset in a function for later use by other implemented
> > PSCI calls.
> >
> > No functional change intended.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
> >  1 file changed, 35 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index 310b9cb2b32b..bb59b692998b 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
> >         return !(affinity & ~MPIDR_HWID_BITMASK);
> >  }
> >
> > -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> > +                                       unsigned long entry_addr,
> > +                                       unsigned long context_id,
> > +                                       bool big_endian)
> >  {
> >         struct vcpu_reset_state *reset_state;
> > +
> > +       lockdep_assert_held(&vcpu->kvm->lock);
> > +
> > +       reset_state = &vcpu->arch.reset_state;
> > +       reset_state->pc = entry_addr;
> > +
> > +       /* Propagate caller endianness */
> > +       reset_state->be = big_endian;
> > +
> > +       /*
> > +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > +        * the general purpose registers are undefined upon CPU_ON.
> > +        */
> > +       reset_state->r0 = context_id;
> > +
> > +       WRITE_ONCE(reset_state->reset, true);
> > +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > +
> > +       /*
> > +        * Make sure the reset request is observed if the change to
> > +        * power_state is observed.
> > +        */
> > +       smp_wmb();
> > +       vcpu->arch.power_off = false;
> > +}
> > +
> > +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > +{
> >         struct kvm *kvm = source_vcpu->kvm;
> >         struct kvm_vcpu *vcpu = NULL;
> >         unsigned long cpu_id;
> > @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >                         return PSCI_RET_INVALID_PARAMS;
> >         }
> >
> > -       reset_state = &vcpu->arch.reset_state;
> > -
> > -       reset_state->pc = smccc_get_arg2(source_vcpu);
> > -
> > -       /* Propagate caller endianness */
> > -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> > -
> > -       /*
> > -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > -        * the general purpose registers are undefined upon CPU_ON.
> > -        */
> > -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> > -
> > -       WRITE_ONCE(reset_state->reset, true);
> > -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > -
> > -       /*
> > -        * Make sure the reset request is observed if the change to
> > -        * power_state is observed.
> > -        */
> > -       smp_wmb();
> > -
> > -       vcpu->arch.power_off = false;
> > +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> > +                                   smccc_get_arg3(source_vcpu),
> > +                                   kvm_vcpu_is_be(source_vcpu));
> >         kvm_vcpu_wake_up(vcpu);
> >
> >         return PSCI_RET_SUCCESS;
> > --
> > 2.33.0.685.g46640cef36-goog
>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
>
> Not directly related to the patch, but the (original) code doesn't
> do any sanity checking for the entry address although the PSCI spec says:
>
> "INVALID_ADDRESS is returned when the entry point address is known
> by the implementation to be invalid, because it is in a range that
> is known not to be available to the caller."

Right, I had noticed the same but was a tad too lazy to address in
this series :) Thanks for the review, Reji!

--
Best,
Oliver
