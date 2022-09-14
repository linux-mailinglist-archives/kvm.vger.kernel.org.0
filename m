Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D534A5B8169
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 08:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiINGNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 02:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiINGNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 02:13:23 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD5571736
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 23:13:21 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id j7so9396557vsr.13
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 23:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3Nj3leCSwB1mG6UETzR179fDDWSWD2vq8HNpdWGZN90=;
        b=ehy0egZci05ylvswS7cjrgJ+nSu4gnTHEY52CE6r0WR26HvYVCShI1KLxYsxcCOvaM
         mQ4Y0FZkqwO/CZd4uOUlj0Uw7kwq8aTs+uBuFlzkT5z+yJRa9AoQ3XsDIY4LU5mlYQCM
         BJfDwTg7LM8gNIF5oKe0+i4yYsLMjQRhohqmpyo3uIMelUdRN3/yjRX9fLhfQcqX9DSa
         Eqi6Te0GXWqE7MWkVFigDDcc7GHxGAv4IwSyMQN0JjsAiUuK0TlJVLDChulWHEiEE+vE
         dpxR3XCiaVe4Uo8DhusWpZRVkPPvDSnzgBfPQ43Pf5nrv8X4CiGyLlAhl+cBw5U0vAGT
         wDjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3Nj3leCSwB1mG6UETzR179fDDWSWD2vq8HNpdWGZN90=;
        b=2O0FCoYU+za8yAtSWax1PgbO004eGUorVf/MtFc5SKKvRDYqsoidtfNiElt0f7/+nK
         FVWWSJKlvLPzdx8lX77B2sAwW9DDOe4kLpKV+BzkuD0iMcVWsA+GRdxkqOC1Oz2jBhJ1
         IFp/ODkd2u9dghZvv9P6uoJvvrlM34cZ7Dbgzg/FYnhAIF69DGiAFwgyH+1OGKE2kRhs
         e2DJKdk007J/rzRKUM5UjKQ46Bd9UJCLV6qjZ0u7xPyH3RCRIf1y65DaJEpjvawJP/t0
         p1B3IbxLkGWJ80V8unGUSizOjc3N7eV5O4spnLbU6BodDUUyoUXQbfjUiBqURXs3J4L7
         YntA==
X-Gm-Message-State: ACgBeo3BrkUA+jLAtHoFmFjcX3ANuB2eQtD66N3HtMWKwp41mlP1a3YA
        /kIUvZc9LWJVidZc33mWpTnQwz1HCIDlEySUf5JOqg==
X-Google-Smtp-Source: AA6agR4JUNqOVng4uk2DdELeIypGajswDTkl+EO+sfZtKXSS7J9di0ND1TC1heExvdipyjW4oYwqFodRgI+LKKfiEgM=
X-Received: by 2002:a67:fdd0:0:b0:397:c028:db6a with SMTP id
 l16-20020a67fdd0000000b00397c028db6amr11548134vsq.58.1663136000321; Tue, 13
 Sep 2022 23:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com> <20220909044636.1997755-2-reijiw@google.com>
 <875yhvqzxn.wl-maz@kernel.org>
In-Reply-To: <875yhvqzxn.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 13 Sep 2022 23:13:04 -0700
Message-ID: <CAAeT=Fx5nLCqoNG+gnAZSbWvc9FotWOaQepNLqBZ2Xx_hxcxsw@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't set PSTATE.SS when Software Step
 state is Active-pending
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Thank you for the review!

On Sat, Sep 10, 2022 at 3:36 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 09 Sep 2022 05:46:34 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Currently, PSTATE.SS is set on every guest entry if single-step is
> > enabled for the vCPU by userspace.  However, it could cause extra
> > single-step execution without returning to userspace, which shouldn't
> > be performed, if the Software Step state at the last guest exit was
> > Active-pending (i.e. the last exit was not triggered by Software Step
> > exception, but by an asynchronous exception after the single-step
> > execution is performed).
> >
> > Fix this by not setting PSTATE.SS on guest entry if the Software
> > Step state at the last exit was Active-pending.
> >
> > Fixes: 337b99bf7edf ("KVM: arm64: guest debug, add support for single-step")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
>
> Now that I'm a bit more clued about what the architecture actually
> mandates, I can try and review this patch.
>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  3 +++
> >  arch/arm64/kvm/debug.c            | 19 ++++++++++++++++++-
> >  arch/arm64/kvm/guest.c            |  1 +
> >  arch/arm64/kvm/handle_exit.c      |  2 ++
> >  4 files changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index e9c9388ccc02..4cf6eef02565 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -535,6 +535,9 @@ struct kvm_vcpu_arch {
> >  #define IN_WFIT                      __vcpu_single_flag(sflags, BIT(3))
> >  /* vcpu system registers loaded on physical CPU */
> >  #define SYSREGS_ON_CPU               __vcpu_single_flag(sflags, BIT(4))
> > +/* Software step state is Active-pending */
> > +#define DBG_SS_ACTIVE_PENDING        __vcpu_single_flag(sflags, BIT(5))
> > +
> >
> >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> >  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +   \
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index 0b28d7db7c76..125cfb94b4ad 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -188,7 +188,16 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >                * debugging the system.
> >                */
> >               if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> > -                     *vcpu_cpsr(vcpu) |=  DBG_SPSR_SS;
> > +                     /*
> > +                      * If the software step state at the last guest exit
> > +                      * was Active-pending, we don't set DBG_SPSR_SS so
> > +                      * that the state is maintained (to not run another
> > +                      * single-step until the pending Software Step
> > +                      * exception is taken).
> > +                      */
> > +                     if (!vcpu_get_flag(vcpu, DBG_SS_ACTIVE_PENDING))
> > +                             *vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
> > +
> >                       mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> >                       mdscr |= DBG_MDSCR_SS;
> >                       vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
> > @@ -279,6 +288,14 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
> >                                               &vcpu->arch.debug_ptr->dbg_wcr[0],
> >                                               &vcpu->arch.debug_ptr->dbg_wvr[0]);
> >               }
> > +
> > +             if ((vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) &&
> > +                 !(*vcpu_cpsr(vcpu) & DBG_SPSR_SS))
> > +                     /*
> > +                      * Mark the vcpu as ACTIVE_PENDING
> > +                      * until Software Step exception is confirmed.
>
> s/confirmed/taken/? This would match the comment in the previous hunk.

Yes, I will fix that.

>
> > +                      */
> > +                     vcpu_set_flag(vcpu, DBG_SS_ACTIVE_PENDING);
> >       }
> >  }
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index f802a3b3f8db..2ff13a3f8479 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -937,6 +937,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >       } else {
> >               /* If not enabled clear all flags */
> >               vcpu->guest_debug = 0;
> > +             vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
> >       }
> >
> >  out:
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index bbe5b393d689..8e43b2668d67 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -154,6 +154,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
> >
> >       if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
> >               run->debug.arch.far = vcpu->arch.fault.far_el2;
> > +     else if (ESR_ELx_EC(esr) == ESR_ELx_EC_SOFTSTP_LOW)
> > +             vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
>
> Can we write this as a switch/case statement?

Sure, I will change this to switch/case statement.


>
> >
> >       return 0;
> >  }
>
> I think we also need to do something if userspace decides to write to
> PSTATE as a result of a non-debug exit (such as a signal) when this
> DBG_SS_ACTIVE_PENDING is set. I came up with the following
> complicated, but not impossible scenario:
>
> - guest single step, PSTATE.SS=0
> - exit due to interrupt
> - DBG_SS_ACTIVE_PENDING set
> - reenter guest
> - exit again due to another interrupt
> - exit to userspace due to signal pending
> - userspace writes PSTATE.SS=1 for no good reason
> - we now have an inconsistent state between PSTATE.SS and the vcpu flags
>
> My gut feeling is that we need something like the vcpu flag being set
> to !PSTATE.SS if written while debug is enabled.
>
> Thoughts?

Ah, that's a good point.
Values that KVM is going to set in debug registers (e.g. MDSCR_EL1,
dbg_bcr, etc) at guest-entry cannot be changed by userspace via
SET_ONE_REG when debug is enabled.  I'm inclined to apply the same
for PSTATE.SS (clear PSTATE.SS if the vcpu flag is set on guest entry,
and set PSTATE.SS to 1 otherwise). Since  MDSCR_EL1 value that KVM is
going to set is not visible from userspace, changing Software-step
state when userspace updates PSTATE.SS might be a bit odd IMHO
(something odd anyway though).

Related to the above scenario, I found another bug (I think).
After guest exits with Active-not-pending (PSTATE.SS==1) due to an
interrupt, and then KVM exits to userspace due to signal pending,
if userspace disables single-step, PSTATE.SS will remain 1 on
subsequent guest entries (or it might have been originally 1, and
KVM might clear it.  Most of the time it doesn't matter, and when the
guest is also using single-step, things will go wrong anyway though).

Considering those, I am thinking of changing the patch as follows,
 - Change kvm_arm_setup_debug() to clear PSTATE.SS if the vcpu flag
   (DBG_SS_ACTIVE_PENDING) is set, and set PSTATE.SS to 1 otherwise.
 - Change save_guest_debug_regs()/restore_guest_debug_regs() to
   save/restore the guest value of PSTATE.SS
   (Add a new field in kvm_vcpu_arch.guest_debug_preserved to save
    the guest value of PSTATE.SS)
keeping the other changes in the patch below.
 - Clear DBG_SS_ACTIVE_PENDING in kvm_handle_guest_debug()
 - Clear DBG_SS_ACTIVE_PENDING when userspace disables single-step

With this, PSTATE.SS value that KVM is going to set on guest-entry
won't be exposed to userspace, and PSTATE.SS value that is set by
userspace will not be used for the guest until single-step is
disabled (similar to MDSCR_EL1).

What do you think ?

Thank you,
Reiji
