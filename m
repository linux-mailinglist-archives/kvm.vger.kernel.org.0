Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EC9422D49
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 18:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbhJEQFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 12:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhJEQE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 12:04:58 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54F0C061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 09:03:07 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j5so83329499lfg.8
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 09:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p69qa2kAJAykM/M886WL/Uvvf9BzxoYSD30sYnSVKEk=;
        b=r6U8lbhtewKh5bUdkO8YAKGHtgBlpoMV2HBGIj4uX4+9YnRA8wsjj/WV3YDOngShJI
         qW0cr7U617H4uiP4rvLarJKBwM3s1byV8H8to0uXhPUVkwGoOgphiZisLrpGQJyh2tYX
         w8cKqKshStXfKZbCi8f+CLOqdCeZmKv5gyrxRJgQB9xn6ClHkhuvQHgE76DEC6AU105k
         lukJwJUT2zJWGv/Wk0VIRVWlf0Ups3V0x51+dn3T3PxXJp5Y07aeKQx5mei/3nSjaQ+n
         J0zJxYnMQfdoLq3ZSWFAsPC3DlHesFI5mVlu2pVjftzdtqzAdTf8LAu5lD9a+Pbvzi3E
         5maw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p69qa2kAJAykM/M886WL/Uvvf9BzxoYSD30sYnSVKEk=;
        b=1zdioJeRBcUxy43IV8z31TZkj3murtNbyI+Jfi3gCL0f0Z7AzzRzbhcV8leUW69WDJ
         SOzQFED+xES1i2B6jfZ22WM88wyYNKOj1MhilJ5q7Rjmh9sCZrtJbKOAuO+67cQWQVd0
         ubV1BXj/UQV5AEDsr7z8xha9qeHpfNhyrIVWzEhH68yIU4RmqIS6nNwueW6cFXyalv4l
         wVaF4wUjDpSH8I9e/1YMMdnd6gkeqNb8KpRXjbc/4Rjoi5P9jIGGr3vsNs5R7zZ5WtwN
         r+14Y/e7phXh6pmQ/M7cI3qQD+c6CUMEaB/jrs2PPa88gUVgahgQunyOlXFg6aMpGZ1w
         dRzg==
X-Gm-Message-State: AOAM530t2qz/9WJhYc2dBv1r2D50TLoT7ytsdVuiLYYLkcJ0OmL125sH
        ug3g7nkxMdiPnKQ1oTdc+4MTiWChkpPoUA6gSthcPg==
X-Google-Smtp-Source: ABdhPJw6QeEfLb//nY4PDgrjw9Ndh+4tmAzO5+1QLuyUYeurGKY4/EjAVBSICgDpDrc13tpgwY24tQzk9bXzz7aLtGo=
X-Received: by 2002:ac2:4c50:: with SMTP id o16mr4164401lfk.286.1633449782971;
 Tue, 05 Oct 2021 09:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-7-oupton@google.com>
 <877deytfes.wl-maz@kernel.org>
In-Reply-To: <877deytfes.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 5 Oct 2021 09:02:48 -0700
Message-ID: <CAOQ_QsjegjqOftkgyMtGKthTkCwimRyf1gncY-3nbVceQ-Ts4g@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] KVM: arm64: Add support for SYSTEM_SUSPEND PSCI call
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Thu, Sep 30, 2021 at 5:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Thu, 23 Sep 2021 20:16:05 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > ARM DEN0022D 5.19 "SYSTEM_SUSPEND" describes a PSCI call that may be
> > used to request a system be suspended. This is optional for PSCI v1.0
> > and to date KVM has elected to not implement the call. However, a
> > VMM/operator may wish to provide their guests with the ability to
> > suspend/resume, necessitating this PSCI call.
> >
> > Implement support for SYSTEM_SUSPEND according to the prescribed
> > behavior in the specification. Add a new system event exit type,
> > KVM_SYSTEM_EVENT_SUSPEND, to notify userspace when a VM has requested a
> > system suspend. Make KVM_MP_STATE_HALTED a valid state on arm64.
>
> KVM_MP_STATE_HALTED is a per-CPU state on x86 (it denotes HLT). Does
> it make really sense to hijack this for something that is more of a
> VM-wide state? I can see that it is tempting to do so as we're using
> the WFI semantics (which are close to HLT's, in a twisted kind of
> way), but I'm also painfully aware that gluing x86 expectations on
> arm64 rarely leads to a palatable result.
>
> > Userspace can set this to request an in-kernel emulation of the suspend.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst    |  6 ++++
> >  arch/arm64/include/asm/kvm_host.h |  3 ++
> >  arch/arm64/kvm/arm.c              |  8 +++++
> >  arch/arm64/kvm/psci.c             | 60 +++++++++++++++++++++++++++++++
> >  include/uapi/linux/kvm.h          |  2 ++
> >  5 files changed, 79 insertions(+)
>
> This patch needs splitting. PSCI interface in one, mpstate stuff in
> another, userspace management last.
>

I agree that the MP state could be spun off into a new patch, but I
think the PSCI interface and UAPI are tightly bound. Explanation
below.

<snip>

> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index f1a375648e25..d875d3bcf3c5 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -101,6 +101,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >               }
> >               mutex_unlock(&kvm->lock);
> >               break;
> > +     case KVM_CAP_ARM_SYSTEM_SUSPEND:
> > +             r = 0;
> > +             kvm->arch.suspend_enabled = true;
>
> I don't really fancy adding another control here. Given that we now
> have the PSCI version being controlled by a firmware pseudo-register,
> I'd rather have that there.
>

I would generally agree, but I believe we need a default-off switch
for this new UAPI. Otherwise, I can see this change blowing up old
VMMs that are clueless about KVM_EXIT_SYSTEM_SUSPEND.

Parallel to this, it is my understanding that firmware
pseudo-registers should default to the maximum value, such that
userspace can discover what features are available on KVM and old VMMs
can provide new KVM features to its guests.

> And if we do that, I wonder whether there would be any benefit in
> bumping the PSCI version to 1.1.
>

I mean, we already do implement PSCI v1.1, we just don't pick up any
of the optional functions added to the spec. IMO, the reported PSCI
version should have some relation to the spirit of a particular
revision (such as the optional functions).

To that end, since the SYSTEM_SUSPEND PSCI call is 1.0, I didn't think
bumping the FW register was the right call.

> > +             break;
> >       default:
> >               r = -EINVAL;
> >               break;
> > @@ -215,6 +219,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >       case KVM_CAP_SET_GUEST_DEBUG:
> >       case KVM_CAP_VCPU_ATTRIBUTES:
> >       case KVM_CAP_PTP_KVM:
> > +     case KVM_CAP_ARM_SYSTEM_SUSPEND:
> >               r = 1;
> >               break;
> >       case KVM_CAP_SET_GUEST_DEBUG2:
> > @@ -470,6 +475,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >       int ret = 0;
> >
> >       switch (mp_state->mp_state) {
> > +     case KVM_MP_STATE_HALTED:
> > +             kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > +             fallthrough;
> >       case KVM_MP_STATE_RUNNABLE:
> >               vcpu->arch.power_off = false;
> >               break;
>
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index d453666ddb83..cf869f1f8615 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -203,6 +203,46 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
> >       kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
> >  }
> >
> > +static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
> > +{
> > +     unsigned long entry_addr, context_id;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     unsigned long psci_ret = 0;
> > +     struct kvm_vcpu *tmp;
> > +     int ret = 0;
> > +     int i;
> > +
> > +     /*
> > +      * The SYSTEM_SUSPEND PSCI call requires that all vCPUs (except the
> > +      * calling vCPU) be in an OFF state, as determined by the
> > +      * implementation.
> > +      *
> > +      * See ARM DEN0022D, 5.19 "SYSTEM_SUSPEND" for more details.
> > +      */
> > +     mutex_lock(&kvm->lock);
> > +     kvm_for_each_vcpu(i, tmp, kvm) {
> > +             if (tmp != vcpu && !tmp->arch.power_off) {
> > +                     psci_ret = PSCI_RET_DENIED;
> > +                     ret = 1;
> > +                     goto out;
> > +             }
> > +     }
> > +
> > +     entry_addr = smccc_get_arg1(vcpu);
> > +     context_id = smccc_get_arg2(vcpu);
> > +
> > +     kvm_psci_vcpu_request_reset(vcpu, entry_addr, context_id,
> > +                                 kvm_vcpu_is_be(vcpu));
>
> So even if userspace doesn't want to honor the suspend request, the
> CPU ends up resetting? That's not wrong, but maybe a bit surprising.
>

I think it's the only consistent state that we can really put the vCPU
in. If, by default, we refuse the guest's request (returning
INTERNAL_ERROR), then we must also stash the reset context for later
use on the next KVM_RUN if userspace honors the guest. Then we are in
the weird state where vcpu->arch.reset_state is valid, but
KVM_REQ_RESET is not set. In this case, if userspace were to save the
vCPU, the reset context is lost, missing the check from commit
6826c6849b46 ("KVM: arm64: Handle PSCI resets before userspace touches
vCPU state").

Sorry if this is a bit too drawn out, but wanted to share the thought
process behind it in case you had any other ideas.

--
Thanks,
Oliver
