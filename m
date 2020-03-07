Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF28217CAB6
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 03:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCGCSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 21:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCGCSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 21:18:43 -0500
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1645820709
        for <kvm@vger.kernel.org>; Sat,  7 Mar 2020 02:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583547522;
        bh=LD5TNVEtYaLoCx/BaR3Mk/MEi35w8LGZoBqe2Phq/ds=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0rCG9u/tpC080Brd9MXL4+E9z5Z2d89F1j7dbUxkbsWp2fwYBl0+0KlhXwGFlP6A4
         J2xKTQG+d4/1sTmXD3KsfE6oppbZQHJEA+8/eL/VQitWsWHBfZxyts4eA340zXyB9u
         4nGR7I5209ZQs+Vr8B8lSbvQH9QfS7jbKJBS890g=
Received: by mail-wr1-f42.google.com with SMTP id v4so4496108wrs.8
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 18:18:42 -0800 (PST)
X-Gm-Message-State: ANhLgQ2uZ3Hb6V3eZguufb/oiVSXi+eU7REjldzUQLRgBDvuqlbVxUl0
        UckuNhf7VnCqpOL6yJSFv5gFDzFQkHBbrA8F9tbd5g==
X-Google-Smtp-Source: ADFU+vsjb4zKftUR4vtLGPovffJ+OzIAfu2BgiM+vB84Sn9gxhvA+f70iTKhepqarxCFxT17nwfii670vWGUt4oH0pQ=
X-Received: by 2002:a05:6000:1ca:: with SMTP id t10mr6704405wrx.75.1583547520346;
 Fri, 06 Mar 2020 18:18:40 -0800 (PST)
MIME-Version: 1.0
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de>
In-Reply-To: <20200307000259.448059232@linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 6 Mar 2020 18:18:28 -0800
X-Gmail-Original-Message-ID: <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com>
Message-ID: <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Mar 6, 2020, at 4:12 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> =EF=BB=BFWhile working on the entry consolidation I stumbled over the KVM=
 async page
> fault handler and kvm_async_pf_task_wait() in particular. It took me a
> while to realize that the randomly sprinkled around rcu_irq_enter()/exit(=
)
> invocations are just cargo cult programming. Several patches "fixed" RCU
> splats by curing the symptoms without noticing that the code is flawed
> from a design perspective.
>
> The main problem is that this async injection is not based on a proper
> handshake mechanism and only respects the minimal requirement, i.e. the
> guest is not in a state where it has interrupts disabled.
>
> Aside of that the actual code is a convoluted one fits it all swiss army
> knife. It is invoked from different places with different RCU constraints=
:
>
> 1) Host side:
>
>   vcpu_enter_guest()
>     kvm_x86_ops->handle_exit()
>       kvm_handle_page_fault()
>         kvm_async_pf_task_wait()
>
>   The invocation happens from fully preemptible context.

I=E2=80=99m a bit baffled as to why the host uses this code at all instead =
of
just sleeping the old fashioned way when the guest takes a (host) page
fault.  Oh well.

> +
> +/*
> + * kvm_async_pf_task_wait_schedule - Wait for pagefault to be handled
> + * @token:    Token to identify the sleep node entry
> + *
> + * Invoked from the async pagefault handling code or from the VM exit pa=
ge
> + * fault handler. In both cases RCU is watching.
> + */
> +void kvm_async_pf_task_wait_schedule(u32 token)
> +{
> +    struct kvm_task_sleep_node n;
> +    DECLARE_SWAITQUEUE(wait);
> +
> +    lockdep_assert_irqs_disabled();
> +
> +    if (!kvm_async_pf_queue_task(token, false, &n))
>      return;
> +
> +    for (;;) {
> +        prepare_to_swait_exclusive(&n.wq, &wait, TASK_UNINTERRUPTIBLE);
> +        if (hlist_unhashed(&n.link))
> +            break;
> +
> +        local_irq_enable();
> +        schedule();
> +        local_irq_disable();
>  }
> +    finish_swait(&n.wq, &wait);
> +}
> +EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait_schedule);
>
> -    n.token =3D token;
> -    n.cpu =3D smp_processor_id();
> -    n.halted =3D is_idle_task(current) ||
> -           (IS_ENABLED(CONFIG_PREEMPT_COUNT)
> -            ? preempt_count() > 1 || rcu_preempt_depth()
> -            : interrupt_kernel);
> -    init_swait_queue_head(&n.wq);
> -    hlist_add_head(&n.link, &b->list);
> -    raw_spin_unlock(&b->lock);
> +/*
> + * Invoked from the async page fault handler.
> + */
> +static void kvm_async_pf_task_wait_halt(u32 token)
> +{
> +    struct kvm_task_sleep_node n;
> +
> +    if (!kvm_async_pf_queue_task(token, true, &n))
> +        return;
>
>  for (;;) {
> -        if (!n.halted)
> -            prepare_to_swait_exclusive(&n.wq, &wait, TASK_UNINTERRUPTIBL=
E);
>      if (hlist_unhashed(&n.link))
>          break;
> +        /*
> +         * No point in doing anything about RCU here. Any RCU read
> +         * side critical section or RCU watching section can be
> +         * interrupted by VMEXITs and the host is free to keep the
> +         * vCPU scheduled out as long as it sees fit. This is not
> +         * any different just because of the halt induced voluntary
> +         * VMEXIT.
> +         *
> +         * Also the async page fault could have interrupted any RCU
> +         * watching context, so invoking rcu_irq_exit()/enter()
> +         * around this is not gaining anything.
> +         */
> +        native_safe_halt();
> +        local_irq_disable();

What=E2=80=99s the local_irq_disable() here for? I would believe a
lockdep_assert_irqs_disabled() somewhere in here would make sense.
(Yes, I see you copied this from the old code. It=E2=80=99s still nonsense.=
)

I also find it truly bizarre that hlt actually works in this context.
Does KVM in fact wake a HLTed guest that HLTed with IRQs off when a
pending async pf is satisfied?  This would make sense if the wake
event were an interrupt, but it=E2=80=99s not according to Paolo.

All this being said, the only remotely sane case is when regs->flags
has IF=3D=3D1. Perhaps this code should actually do:

WARN_ON(!(regs->flags & X86_EFLAGS_IF));

while (the page isn=E2=80=99t ready) {
 local_irq_enable();
 native_safe_halt();
 local_irq_disable();
}

with some provision to survive the case where the warning fires so we
at least get logs.

In any event, I just sent a patch to disable async page faults that
happen in kernel mode.  Perhaps this patch should actually just have
some warnings to sanity check the async page faults and not even try
to handle all these nasty sub-cases.

Paolo, is there any way to test this async page faults?
