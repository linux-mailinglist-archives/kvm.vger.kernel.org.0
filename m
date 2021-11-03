Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0F2443A70
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 01:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhKCAiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 20:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbhKCAiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 20:38:01 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E77DC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 17:35:25 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id o18so1761267lfu.13
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 17:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V94qvjxMLufwlhWujeoVBKTAsogN9P3sQB42Th9nIWw=;
        b=CZfEvO0B7n1QJHbZO1N/yIm8HTZyZASgIYUj8XqtTJouwI9fN0nhARowUNimsNo2xZ
         tcCQoqCB0FXSkmST3P436+huOXyTcSytKAYgy/VID+rZjd0fAF/Q8VRv84Pw7rRiUq4r
         FR5NtRFVqcUn4P1cp53ZuBLqLFDmQSdrsbWwaCn2C63cy8Vg70p5JB4UXhmRWyT0kJMl
         HQyyqH6wHNHwAJLJVhSoeGcB7zi7E09e51dPaeXnus7BOE/pUY4MSEbrfNLdkrbRzcwk
         Kda0jJnMQmuLGTDHilkBHuilWEzJoCWHap1UlmyBaGo4s25vAS42+Imlv0DieJ1f2dHp
         aTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V94qvjxMLufwlhWujeoVBKTAsogN9P3sQB42Th9nIWw=;
        b=75Hxb/1nObFxsoIFD13IrCaEpWK6aA/RTRlGrbQtc+HMg3EpxNEjimC5qMgUT4QACL
         tjG6I6Re0ZI/Bn1bzk3zgB4kdDvU5lxpAHNU2NJyuXyOG19s63TgFs6VDHhHK0zBqNgE
         KojksL/V6nTibCGHeT6+7Bn/ap+gMMs/RwwC3D1IZFHmyhwtLzk7GDOV5NrGSCunm28d
         FI+LBs5C/bORuIaWDGd7QpaijXdMuIRn5CsCwyjoy//zYSy5LW2emZrbE7gAoIcCuKGX
         MYGRW/JJ2ntKsXsP8SoiBNkKAVHlGf6qs7cM9SdldqnSQo1pJDXIFTJuMGQwFvXbv8V6
         OUlw==
X-Gm-Message-State: AOAM531uF9uiRDkGKXAXNo5cDlyZ1JyK/EZRjLsFEr7gjhzfBBsf2zG2
        8tPPek/ht8T6CgPJoMdw8JdGahVXgOetd8AdcRM8yg==
X-Google-Smtp-Source: ABdhPJzqc1hfgB/5HL3f/KE77uRD6B0N539NFPzfBc8qpON8SsYig+1gw0DaeYdAdLsbr2YnbrTxzXGinF0tNweibms=
X-Received: by 2002:a05:6512:96f:: with SMTP id v15mr24529197lft.669.1635899723752;
 Tue, 02 Nov 2021 17:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com> <20211102094651.2071532-5-oupton@google.com>
 <YYHNLt1rlwuXkk7e@google.com>
In-Reply-To: <YYHNLt1rlwuXkk7e@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 2 Nov 2021 17:35:12 -0700
Message-ID: <CAOQ_Qsgq9YjX0gosaAMfgX5oQxatVhNK=gfN2BfjQ=ps7T4=mQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Emulate the OS Lock
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Tue, Nov 2, 2021 at 4:45 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Tue, Nov 02, 2021 at 09:46:49AM +0000, Oliver Upton wrote:
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
> > +#define kvm_vcpu_os_lock_enabled(vcpu)               \
> > +     (__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK)
> > +
> >  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> >                              struct kvm_device_attr *attr);
> >  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index db9361338b2a..5690a9c99c89 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -95,8 +95,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
> >                               MDCR_EL2_TDRA |
> >                               MDCR_EL2_TDOSA);
> >
> > -     /* Is the VM being debugged by userspace? */
> > -     if (vcpu->guest_debug)
> > +     /*
> > +      * Check if the VM is being debugged by userspace or the guest has
> > +      * enabled the OS lock.
> > +      */
> > +     if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu))
> >               /* Route all software debug exceptions to EL2 */
> >               vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
> >
> > @@ -160,8 +163,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >
> >       kvm_arm_setup_mdcr_el2(vcpu);
> >
> > -     /* Is Guest debugging in effect? */
> > -     if (vcpu->guest_debug) {
> > +     /*
> > +      * Check if the guest is being debugged or if the guest has enabled the
> > +      * OS lock.
> > +      */
> > +     if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
> >               /* Save guest debug state */
> >               save_guest_debug_regs(vcpu);
> >
> > @@ -223,6 +229,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >                       trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
> >                                               &vcpu->arch.debug_ptr->dbg_wcr[0],
> >                                               &vcpu->arch.debug_ptr->dbg_wvr[0]);
> > +             } else if (kvm_vcpu_os_lock_enabled(vcpu)) {
> > +                     mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> > +                     mdscr &= ~DBG_MDSCR_MDE;
> > +                     vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
>
> I think this is missing the case where the guest is being debugged by
> userspace _and_ from inside (the guest) at the same time. In this
> situation, the vmm gets a KVM_EXIT_DEBUG and if it doesn't know what to
> do with it, it injects the exception into the guest (1). With this "else
> if", the guest would still get the debug exception when the os lock is
> enabled.
>
> (1) kvm_arm_handle_debug() is the one doing this in QEMU source code.

I wonder if this is a problem that KVM should even handle. KVM doesn't
do anything to help userspace inject the debug exception into the
guest, and from reading kvm_arm_handle_debug() it would seem that QEMU
is manually injecting the exception to EL1 and setting the PC to the
appropriate vector.

There is an issue, though, with migration: older KVM will not show
OSLSR_EL1 on KVM_GET_REG_LIST. However, in order to provide an
architectural OS Lock, its reset value must be 1 (enabled). This would
all have the effect of discarding the guest's OS lock value and
blocking all debug exceptions intended for the guest until the next
reboot.

So it would seem that userspace needs to know about the OSLK bit to
correctly inject debug exceptions and migrate guests. If opt-in is
heavyweight, we could cure the migration issue by explicitly
documenting the OS lock being disabled out of reset as an erratum of
KVM. Doing so would be consistent with all prior versions of KVM. Of
course, adopting nonarchitected behavior in perpetuity seems a bit
unsavory :-)

--
Oliver
