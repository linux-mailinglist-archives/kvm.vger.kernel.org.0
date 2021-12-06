Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E6746A313
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 18:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243276AbhLFRik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 12:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243207AbhLFRij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 12:38:39 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8657DC061746
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 09:35:10 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id e11so22297810ljo.13
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 09:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ObijjNNRXE6itlkJdDnoMy05ulET3J5ksrjco4dQA1c=;
        b=CLjXdyfnqAQMK6ExVkjomUn/HBbVGyHOP3vEp5iYRyMOQE3H1wp+Naco6XQH67BV3I
         WCZYxzsm0yUrrV+ml2Y2tSNPl+uss3Vj4fFX4i13TJ+6UM5EO3AePqtXU2/1zUE8Knxi
         XRd8m8wmdPGj5v7lXsHfWbstSAK91GbAG1hG8OXJtjJsZAV112nQWlAKw65wMQhE4fir
         nb5dkjEivBjsv7LgtcBq0kSvEWdVnvQxCEKAx3nBB+ByM9ZUUtJyt6ML6yOhoSGYBhDH
         zfCcD28QoD18jggyXJFcdUrVdbUdjFbdprl/yV5UOHGjNQNxfjRGSYoS32QmtvnFxXH5
         osRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ObijjNNRXE6itlkJdDnoMy05ulET3J5ksrjco4dQA1c=;
        b=I8Sfcn2loYqe51+8lbyLJECHTQRM+DBXhlWZ7EIyA9bAmit9910F4ALSDY+sQmr+lb
         Yh9iKbpX1gCkI05nzVGWTCB1GqB6BJCHrTB5k4CFMsV1bqE1GorGdZOTw1zcAVBNRJTj
         Yb+nsn7Y0whKAicFkwAJDZbtg3F4mYO0/2Dgq/Ockpg2LlPHoVOk52q8RHoZv/8wj/J/
         1tY2TOl4KaTx/CMfUg82DVj/t/tPA6DzZHAzhXHzF1KJfxAozpT9jXwkTxe45tAZRJGy
         DJLsu3s3C2NrGEMM1oRqfNLP7mfiJ0dzVt97qNnXgXKhGJIL3BrEAHkv3f+r6D4PfzEc
         1QjQ==
X-Gm-Message-State: AOAM531RIBtCJ64neZA5i6RFkL35Ng4ETKx7UV3N1nSYn541skrM0EVW
        xM/fpOa2EGUPLVsvLuI8Dtb38nM9LITVt+DLBvr1fQ==
X-Google-Smtp-Source: ABdhPJyhT32Rl+FOG0Vq4c2ude2auGlMTF31Nm+vwlDbCHQKWKZwUHRiHKNcqkJrleiFZPHODWHThMKl7Q7TNAB9Bmc=
X-Received: by 2002:a05:651c:a12:: with SMTP id k18mr38470379ljq.251.1638812108454;
 Mon, 06 Dec 2021 09:35:08 -0800 (PST)
MIME-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com> <20211123210109.1605642-5-oupton@google.com>
 <87r1azm4j1.wl-maz@kernel.org>
In-Reply-To: <87r1azm4j1.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 6 Dec 2021 11:34:57 -0600
Message-ID: <CAOQ_QsgUoA88GmWx4j3EWoELyEtWSgUw6tBB8BHivzBTaVon0g@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64: Emulate the OS Lock
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

Apologies for my delay in getting back to you, I was OOO for a while.

On Mon, Nov 29, 2021 at 8:16 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 23 Nov 2021 21:01:07 +0000,
> Oliver Upton <oupton@google.com> wrote:
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
>
> Skipping breakpoint instructions? I don't think you can do that, as
> the guest does rely on BRK always being effective. I also don't see
> where you do that...

Right, this comment in the commit message is stale. In the previous
iteration I had done this, but removed it per your suggestion. I'll
fix the msg in the next round.

> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  4 ++++
> >  arch/arm64/kvm/debug.c            | 27 +++++++++++++++++++++++----
> >  arch/arm64/kvm/sys_regs.c         |  6 +++---
> >  3 files changed, 30 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 53fc8a6eaf1c..e5a06ff1cba6 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -726,6 +726,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> > +
> > +#define kvm_vcpu_os_lock_enabled(vcpu)               \
> > +     (!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK))
> > +
> >  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> >                              struct kvm_device_attr *attr);
> >  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index db9361338b2a..7835c76347ce 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -53,6 +53,14 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
> >                               vcpu_read_sys_reg(vcpu, MDSCR_EL1));
> >  }
> >
> > +/*
> > + * Returns true if the host needs to use the debug registers.
> > + */
> > +static inline bool host_using_debug_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     return vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu);
>
> Just the name of the function has sent my head spinning. Even if the
> *effects* of the host debug and the OS Lock are vaguely similar from
> the guest PoV, they really are different things, and I'd rather not
> lob them together.
>
> > +}
> > +
> >  /**
> >   * kvm_arm_init_debug - grab what we need for debug
> >   *
> > @@ -105,9 +113,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
> >        *  - Userspace is using the hardware to debug the guest
> >        *  (KVM_GUESTDBG_USE_HW is set).
> >        *  - The guest is not using debug (KVM_ARM64_DEBUG_DIRTY is clear).
> > +      *  - The guest has enabled the OS Lock (debug exceptions are blocked).
> >        */
> >       if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
> > -         !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
> > +         !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY) ||
> > +         kvm_vcpu_os_lock_enabled(vcpu))
> >               vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
> >
> >       trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
> > @@ -160,8 +170,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >
> >       kvm_arm_setup_mdcr_el2(vcpu);
> >
> > -     /* Is Guest debugging in effect? */
> > -     if (vcpu->guest_debug) {
> > +     /*
> > +      * Check if we need to use the debug registers.
> > +      */
> > +     if (host_using_debug_regs(vcpu)) {
>
> I'd rather you expand the helper here and add the comment you have in
> the commit message explaining the machine-wide effect of the OS Lock.

Ack to here and the above comment. Thanks for the review!

--
Oliver
