Return-Path: <kvm+bounces-4583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D8C814EC3
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 18:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98FDC1F25971
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 17:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D794D34CDC;
	Fri, 15 Dec 2023 17:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="IKn9mPIl";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+kWi05ef"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DCE30103;
	Fri, 15 Dec 2023 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1702661212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VYZRdTrUfLSjIbMuwr8q2hB5IoUOm77UOIngwqn7iJU=;
	b=IKn9mPIlQGHLdLYlt72NR+6gXNAd57/ptU/wmG/+bXyc75gESDFrSFuhOKC+Fd3eSrWNco
	/mkGCExYeIF5nNf8Acaqio4f5rKehxBjL9KjOZSH2PSru2oCd/58B0jnkppKR64LFFLiFd
	wxSczyy8IQqz4cHwp2NcbTfegKR2uCzQgqM2ene3gCxZ0PmTNOozw0YEMJORi7XC5lF6tF
	b3t0OGE29QZSq+RNJXVceX0vOZAp/Vw1jFqLIRGq7ty8G06cYVs4jhiNSeVxQ9+g1f/PjS
	V6e9iQYPQthSHBGOMC2OzRmP108pPenk6X4RoHbi2mYjSaAsAc1SzBJqltqqZw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1702661212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VYZRdTrUfLSjIbMuwr8q2hB5IoUOm77UOIngwqn7iJU=;
	b=+kWi05ef+R91pM1ddNPnVDIOyZmI5bJhC1nemoVwP66Q+Y3daQdLyWxmXjB1BpSmsvh97o
	t1lywhsYkDEFZLBQ==
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>, Ben Segall
 <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, Daniel Bristot de
 Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, Steven
 Rostedt <rostedt@goodmis.org>, Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>, Suleiman Souhlal
 <suleiman@google.com>, Masami Hiramatsu <mhiramat@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Joel
 Fernandes <joel@joelfernandes.org>
Subject: Re: [RFC PATCH 8/8] irq: boost/unboost in irq/nmi entry/exit and
 softirq
In-Reply-To: <20231214024727.3503870-9-vineeth@bitbyteword.org>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <20231214024727.3503870-9-vineeth@bitbyteword.org>
Date: Fri, 15 Dec 2023 18:26:51 +0100
Message-ID: <87zfybml5w.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Dec 13 2023 at 21:47, Vineeth Pillai (Google) wrote:
> The host proactively boosts the VCPU threads during irq/nmi injection.
> However, the host is unaware of posted interrupts, and therefore, the
> guest should request a boost if it has not already been boosted.
>
> Similarly, guest should request an unboost on irq/nmi/softirq exit if
> the vcpu doesn't need the boost any more.

That's giving a hint but no context for someone who is not familiar with
the problem which is tried to be solved here.

> @@ -327,6 +327,13 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
>  		.exit_rcu = false,
>  	};
>  
> +#ifdef CONFIG_PARAVIRT_SCHED
> +	instrumentation_begin();

Slapping instrumentation_begin() at it silences the objtool checker, but
that does not make it correct in any way.

You _cannot_ call random code _before_ the kernel has established
context. It's clearly documented:

  https://www.kernel.org/doc/html/latest/core-api/entry.html

No?

> +	if (pv_sched_enabled())
> +		pv_sched_boost_vcpu_lazy();
> +	instrumentation_end();
> +#endif
> +
>  	if (user_mode(regs)) {
>  		irqentry_enter_from_user_mode(regs);
>  		return ret;
> @@ -452,6 +459,18 @@ noinstr void irqentry_exit(struct pt_regs *regs, irqentry_state_t state)
>  		if (state.exit_rcu)
>  			ct_irq_exit();
>  	}
> +
> +#ifdef CONFIG_PARAVIRT_SCHED
> +	instrumentation_begin();

Broken too

> +	/*
> +	 * On irq exit, request a deboost from hypervisor if no softirq pending
> +	 * and current task is not RT and !need_resched.
> +	 */
> +	if (pv_sched_enabled() && !local_softirq_pending() &&
> +			!need_resched() && !task_is_realtime(current))
> +		pv_sched_unboost_vcpu();
> +	instrumentation_end();
> +#endif
>  }
>  
>  irqentry_state_t noinstr irqentry_nmi_enter(struct pt_regs *regs)
> @@ -469,6 +488,11 @@ irqentry_state_t noinstr irqentry_nmi_enter(struct pt_regs *regs)
>  	kmsan_unpoison_entry_regs(regs);
>  	trace_hardirqs_off_finish();
>  	ftrace_nmi_enter();
> +
> +#ifdef CONFIG_PARAVIRT_SCHED
> +	if (pv_sched_enabled())
> +		pv_sched_boost_vcpu_lazy();
> +#endif
>  	instrumentation_end();
>  
>  	return irq_state;
> @@ -482,6 +506,12 @@ void noinstr irqentry_nmi_exit(struct pt_regs *regs, irqentry_state_t irq_state)
>  		trace_hardirqs_on_prepare();
>  		lockdep_hardirqs_on_prepare();
>  	}
> +
> +#ifdef CONFIG_PARAVIRT_SCHED
> +	if (pv_sched_enabled() && !in_hardirq() && !local_softirq_pending() &&
> +			!need_resched() && !task_is_realtime(current))
> +		pv_sched_unboost_vcpu();
> +#endif

Symmetry is overrated. Just pick a spot and slap your hackery in.

Aside of that this whole #ifdeffery is tasteless at best.

>  	instrumentation_end();

> +#ifdef CONFIG_PARAVIRT_SCHED
> +	if (pv_sched_enabled())
> +		pv_sched_boost_vcpu_lazy();
> +#endif

But what's worse is that this is just another approach of sprinkling
random hints all over the place and see what sticks.

Abusing KVM as the man in the middle to communicate between guest and
host scheduler is creative, but ill defined.

From the host scheduler POV the vCPU is just a user space thread and
making the guest special is just the wrong approach.

The kernel has no proper general interface to convey information from a
user space task to the scheduler.

So instead of adding some ad-hoc KVM hackery the right thing is to solve
this problem from ground up in a generic way and KVM can just utilize
that instead of having the special snow-flake hackery which is just a
maintainability nightmare.

Thanks,

        tglx

