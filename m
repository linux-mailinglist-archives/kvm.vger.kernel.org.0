Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC873DBAA6
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 16:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhG3Odl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 10:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239042AbhG3Odk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 10:33:40 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3F2C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 07:33:35 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id q2so12666497ljq.5
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 07:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQGtz4NxA/KCcb2UkEKczuSorFz82jXK+AMOuFhIpSY=;
        b=RDXh6xhSHzVcHoLlZtkJY8rwf+9yeKe0yYYIuU3JvH6YO4ghrz6ojczlapHQhwLmCd
         Fe+TAjzwdXYjAv06/eyWHH3Q10DkSfI9d/AfMDP7wA867e2ePSETc1r6V984B2jOSxuf
         amMOK/ZmyhihhEhZ8f/Sa3NU/ODRr5XPRXRIR9lvPBR3s9csTgQ1WHhVYHwGmlpeK9IT
         dDVZYTaWI9Vc59rDlXVpmgnW6t6/qB7KFS8XKcZdocIlK2yLURmYOJJfjNhhBnZ5DHFd
         FjPTbYr5RJa7XU4gvoi6v4QJy5l1V9kf7uESMvX+FkIFC6dNkaxHkyQDRuwJkGyuXETd
         ziGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQGtz4NxA/KCcb2UkEKczuSorFz82jXK+AMOuFhIpSY=;
        b=CwYcWwGEZGcNPWhlk6+B8k9SaAO7XJssNje3FdyDNEKGkvy+qgx16FwpeKtNrSO/NZ
         Inq7kB1MRt/WoOdcscLkOrxJTnkwP5+9NKFKxcUfj0289qjBii5u10TqRt3UhFuwVt0e
         yYPEtw5dYfgac23gaey7R4KzJV9KLAN7CvaNLio60RwsRDd4erPEcZIMi+Rpbfdta7OG
         kG4C76GTJPQuWtfJzUE+7AOWEsVfPBnhKwmtYhc73Br/mIEDNcqieFVE5Tkt+rdXbVrl
         esTCXfKWRr4Vo4EXKgNc0Rl4i+2/X8AofMo1KHvu2F2/cJFIy9W6vFnHwWP9JJ4bzrWR
         7tcQ==
X-Gm-Message-State: AOAM533hzpQE9BgmM9NiRaI+JKheRAKj3L3rNUzWaS9c8Z9tiETN5Bjc
        6vb0Jn2V2Pv7HyCcJ0Bu/15wMfMYqxsTJ9TO3OR9kA==
X-Google-Smtp-Source: ABdhPJzgGnVq10vXKLaHBZpfgLUJ0afJNvNbZo+mH2b7grVgG96TtjH9fn8FrBCfPY3RGRFW6+8Q94qxjfL1Nl+Zq/g=
X-Received: by 2002:a2e:a68f:: with SMTP id q15mr1890524lje.314.1627655612988;
 Fri, 30 Jul 2021 07:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210729220916.1672875-1-oupton@google.com> <20210729220916.1672875-4-oupton@google.com>
 <878s1o2l6j.wl-maz@kernel.org>
In-Reply-To: <878s1o2l6j.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 30 Jul 2021 07:33:21 -0700
Message-ID: <CAOQ_QsjFzdjYgYSxNLH=8O84FJB+O8KtH0VnzdQ9HnLZwxwpNQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Use generic KVM xfer to guest work function
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc,

On Fri, Jul 30, 2021 at 2:41 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Thu, 29 Jul 2021 23:09:16 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Clean up handling of checks for pending work by switching to the generic
> > infrastructure to do so.
> >
> > We pick up handling for TIF_NOTIFY_RESUME from this switch, meaning that
> > task work will be correctly handled.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/Kconfig |  1 +
> >  arch/arm64/kvm/arm.c   | 27 ++++++++++++++-------------
> >  2 files changed, 15 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index a4eba0908bfa..8bc1fac5fa26 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -26,6 +26,7 @@ menuconfig KVM
> >       select HAVE_KVM_ARCH_TLB_FLUSH_ALL
> >       select KVM_MMIO
> >       select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > +     select KVM_XFER_TO_GUEST_WORK
> >       select SRCU
> >       select KVM_VFIO
> >       select HAVE_KVM_EVENTFD
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 60d0a546d7fd..9762e2129813 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -6,6 +6,7 @@
> >
> >  #include <linux/bug.h>
> >  #include <linux/cpu_pm.h>
> > +#include <linux/entry-kvm.h>
> >  #include <linux/errno.h>
> >  #include <linux/err.h>
> >  #include <linux/kvm_host.h>
> > @@ -714,6 +715,13 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
> >               static_branch_unlikely(&arm64_mismatched_32bit_el0);
> >  }
> >
> > +static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
> > +{
> > +     return kvm_request_pending(vcpu) ||
> > +                     need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
> > +                     xfer_to_guest_mode_work_pending();
>
> Here's what xfer_to_guest_mode_work_pending() says:
>
> <quote>
>  * Has to be invoked with interrupts disabled before the transition to
>  * guest mode.
> </quote>
>
> At the point where you call this, we already are in guest mode, at
> least in the KVM sense.

I believe the comment is suggestive of guest mode in the hardware
sense, not KVM's vcpu->mode designation. I got this from
arch/x86/kvm/x86.c:vcpu_enter_guest() to infer the author's
intentions.

>
> > +}
> > +
> >  /**
> >   * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
> >   * @vcpu:    The VCPU pointer
> > @@ -757,7 +765,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >               /*
> >                * Check conditions before entering the guest
> >                */
> > -             cond_resched();
> > +             if (__xfer_to_guest_mode_work_pending()) {
> > +                     ret = xfer_to_guest_mode_handle_work(vcpu);
>
> xfer_to_guest_mode_handle_work() already does the exact equivalent of
> __xfer_to_guest_mode_work_pending(). Why do we need to do it twice?

Right, there's no need to do the check twice.

>
> > +                     if (!ret)
> > +                             ret = 1;
> > +             }
> >
> >               update_vmid(&vcpu->arch.hw_mmu->vmid);
> >
> > @@ -776,16 +788,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >
> >               kvm_vgic_flush_hwstate(vcpu);
> >
> > -             /*
> > -              * Exit if we have a signal pending so that we can deliver the
> > -              * signal to user space.
> > -              */
> > -             if (signal_pending(current)) {
> > -                     ret = -EINTR;
> > -                     run->exit_reason = KVM_EXIT_INTR;
> > -                     ++vcpu->stat.signal_exits;
> > -             }
> > -
> >               /*
> >                * If we're using a userspace irqchip, then check if we need
> >                * to tell a userspace irqchip about timer or PMU level
> > @@ -809,8 +811,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                */
> >               smp_store_mb(vcpu->mode, IN_GUEST_MODE);
> >
> > -             if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
> > -                 kvm_request_pending(vcpu)) {
> > +             if (ret <= 0 || kvm_vcpu_exit_request(vcpu)) {
>
> If you are doing this, please move the userspace irqchip handling into
> the helper as well, so that we have a single function dealing with
> collecting exit reasons.

Sure thing.

Thanks for the quick review, Marc!

--
Best,
Oliver
