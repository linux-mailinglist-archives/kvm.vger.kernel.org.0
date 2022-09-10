Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF6B5B43F3
	for <lists+kvm@lfdr.de>; Sat, 10 Sep 2022 06:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiIJENS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 00:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiIJENQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 00:13:16 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6BE13EBE
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 21:13:14 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id c3so3641024vsc.6
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 21:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bT+lvXkm6Qe6+nTGGZtBv81BtvgBawrDwZvucM+h94M=;
        b=Yys0KwKHTO+vzTZHw3AkKTcwnUZvMyJM+/WUxQmJjsT87vwqfEWFuN3IyPDJ8gPx3a
         NqQi0USCw1ZfeJkzhhFJqaxYFKW8KP5mvIMwBxp3xs0Ax/mlVLTnW74LrtYjlISyP6Nu
         Qmdv71WFERQ9fnzJbq4556HnCJkVvBESHXxXk9W7J+iVMSukzqttWwGjnwoEpQ8ThYAt
         WGwU0sCuMBPWjPYQ8EL8Ldn12lXjDxgA7dQ4g8pmMM8zi8rBiCk5PAS/RnTseO3ggzMD
         ICjcHCnGCHRLdFBfhynEOmkL76h+RA0CoSV3nSLQ88rdhD6P/GMybofb2ADNE6Ehkpmz
         V/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bT+lvXkm6Qe6+nTGGZtBv81BtvgBawrDwZvucM+h94M=;
        b=15S+/zM2O3h5h7hJAlvhpmfq7rdoaq3mShJ9z0jPom86GMAW85HXXLp6EMzLfrLtOP
         679kTcycAtz/DrHiBPJRg0B3rR5CGWyQgkrKsEsMwEN5yc3DazsWYC7vdpimu6yuzsF0
         x6pr8LT9+xR5ShYLzvYbT26wTkYnkrux6jMNbHnfbAl8zaeD8ZMVx5EzRszJxFz+RUh2
         v7GASOY7wQS0RHPSH2dGJFV7a0Z0LSobVUu4CLSEuBpi1cjDxNNyNR8cG1a7ysTw5qSd
         e1z+MG9PTb1P5E/j+s4fGfGf2BeeGWFrrploLwtYchN5dP+tWR2OfvlE98JPs01n3WWy
         n+fg==
X-Gm-Message-State: ACgBeo2mqG5eSs66OJmHkuFJamzVCyg515yDmwsyVhmXLRBKn4yFxejs
        i/40RvYPVlt3LtUtBxp6wEMl3J797fJEtgyXm0f32Q==
X-Google-Smtp-Source: AA6agR5RrXixyzKCzUB/EJrVm8Zhg8tpR3LDBgWYAO15rG9c2TCzDy3dx942O9xqMNTbp/kZRLU6ckHffxtUmgIfS6w=
X-Received: by 2002:a67:c00b:0:b0:390:8e1f:594a with SMTP id
 v11-20020a67c00b000000b003908e1f594amr6206352vsi.80.1662783193547; Fri, 09
 Sep 2022 21:13:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com> <20220909044636.1997755-2-reijiw@google.com>
 <87bkrora8b.wl-maz@kernel.org>
In-Reply-To: <87bkrora8b.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 9 Sep 2022 21:12:57 -0700
Message-ID: <CAAeT=Fz2hU8V8kYZsirjxr01ZH-Q2abkFOHteOac1LfRWus6Rg@mail.gmail.com>
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

On Fri, Sep 9, 2022 at 5:41 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Reiji,
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
>
> For my own enlightenment, could you describe a sequence of events that
> leads to this issue?

Here is an example of the sequences.

 [Usersace]
  | - ioctl(SET_GUEST_DEBUG)
  | - ioctl(KVM_RUN) (vCPU PC==X)
  v
 [KVM]
  | - *vcpu_cpsr(vcpu) |= SPSR_SS;
  | - mdscr |= DBG_MDSCR_SS;
  | - VM Entry
  v
 [Guest] vCPU PC==X
  | - Execute an instruction at PC==X.
  |   PC is updated with X+4, and PSTATE.SS is cleared.
  |
  | !! Asynchronous exception !!
  v
 [KVM] vCPU PC==X+4
  | - The kernel processes the async exception.
  | - handle_exit() returns 1 (don't return to userspace)
  | - *vcpu_cpsr(vcpu) |= SPSR_SS;
  | - mdscr |= DBG_MDSCR_SS;
  | - VM Entry
  v
 [Guest] vCPU PC==X+4
  | - Execute an instruction at PC==X+4.
  |   PC is updated with X+8, PSTATE.SS is cleared.
  |
  | !! Software Step Exception !!
  v
 [KVM] vCPU PC==X+8
  | - run->exit_reason = KVM_EXIT_DEBUG;
  | - Return to userspace
  v
 [Userspace]
    - Userspace sees PC==X+8 (Userspace didn't see PC==X+4).


> > Fix this by not setting PSTATE.SS on guest entry if the Software
> > Step state at the last exit was Active-pending.
> >
> > Fixes: 337b99bf7edf ("KVM: arm64: guest debug, add support for single-step")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
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
>
> I guess my confusion stems from my (probably wrong) interpretation if
> the SS state is A+P, there is no harm in making it pending again
> (setting the SS bit in PSTATE).

Setting the SS bit in PSTATE (with MDSCR_EL1.SS=1) makes the state
Active-not-pending (not Active-pending) if my interpretation of
the spec is correct.

> > +
> >                       mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> >                       mdscr |= DBG_MDSCR_SS;
>
> But it looks like the *pending* state is actually stored in MDSCR
> instead? The spec only mentions this for the A+P state, so this is
> quite likely a bug indeed.

MDSCR_EL1.SS is set even in Active-not-pending state (not just
Active-pending state).  (Or do you mean the state is stored in
some other field in MDSCR ??)


> Now, where does the asynchronous exception comes into play? I found
> this intriguing remark in the ARM ARM:
>
> <quote>
> The Software Step exception has higher priority than all other types
> of synchronous exception. However, the prioritization of this
> exception with respect to any unmasked pending asynchronous exception
> is not defined by the architecture.
> </quote>
>
> Is this what you were referring to in the commit message? I think you
> need to spell it out for us, as I don't fully understand what you are
> fixing nor do I understand the gory details of single-stepping...

Yes, that is what I was referring to.
In "Figure D2-3 Software step state machine" in Arm ARM (DDI 0487I.a),
since KVM currently sets PSTATE.SS to 1 on every Guest Entry (when
single-step is enabled by userspace), KVM always has the CPU in
"Inactive" (the second inactive state from the top) transition to
"Active-not-pending" on the Guest Entry.  With this patch, KVM
have the CPU transitions to "Active-pending" if the state before
"Inactive" was "Active-pending", which indicates the step completed
but Software Step exception is not taken yet, so that Software
Step exception is taken before further single-step is executed.

I'm sorry for the unclear explanation, and
I hope my comments clarify the problem I'm trying to fix.

Thank you,
Reiji
