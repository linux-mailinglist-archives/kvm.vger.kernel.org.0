Return-Path: <kvm+bounces-21744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DED49334B3
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 02:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72AE51C2206B
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 00:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12AFEC7;
	Wed, 17 Jul 2024 00:13:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4379D628;
	Wed, 17 Jul 2024 00:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721175210; cv=none; b=fZIJQFM5giu3NysumYgP9xQdvZICNrxeZmHqcUrNW6Z9gUJHwH4XqP/xjsA+0awBNT8irRsXfwMMr26MVn9Ei8Qv1MnZO1yfk5ITtgvo6EeOrTWr3ZECFlAHiIxZDexxKsYd2LayjmbCW6MZDEnBwiYF9rYCpGGJtnpfFLYSwPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721175210; c=relaxed/simple;
	bh=H7RC8OBnXHwAAaYFt7l6yBqpFoUw3yPVMg/87dcKlbw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ghKuAMhrFKwWkPOXblHcOeTxrw19b1i2qIP7G11si2nyntM7fltKd/rVibVRT5z6ubTTfMsUPpXAk846O98tL/DOTJP4ocaYCDxB42G1IP0FLn4SC4PGlOdWufqLA+3eWcSuVobD6qgpvepbxkes/6ryr5XGIDsPXgG34YTrAJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CC6C116B1;
	Wed, 17 Jul 2024 00:13:26 +0000 (UTC)
Date: Tue, 16 Jul 2024 20:13:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Joel Fernandes
 <joel@joelfernandes.org>, Vineeth Remanan Pillai <vineeth@bitbyteword.org>,
 Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, Daniel
 Bristot de Oliveira <bristot@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri
 Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Valentin
 Schneider <vschneid@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 graf@amazon.com, drjunior.org@gmail.com
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority
 management)
Message-ID: <20240716201326.5fb7e895@gandalf.local.home>
In-Reply-To: <ZpcFxd_oyInfggXJ@google.com>
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
	<ZjJf27yn-vkdB32X@google.com>
	<CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
	<CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
	<66912820.050a0220.15d64.10f5@mx.google.com>
	<19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
	<20240712122408.3f434cc5@rorschach.local.home>
	<ZpFdYFNfWcnq5yJM@google.com>
	<20240712131232.6d77947b@rorschach.local.home>
	<ZpcFxd_oyInfggXJ@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 Jul 2024 16:44:05 -0700
Sean Christopherson <seanjc@google.com> wrote:
> > 
> > Now if the vCPU gets preempted, it is this moment that we need the host
> > kernel to look at the current priority of the task thread running on
> > the vCPU. If it is an RT task, we need to boost the vCPU to that
> > priority, so that a lower priority host thread does not interrupt it.  
> 
> I got all that, but I still don't see any need to hook VM-Exit.  If the vCPU gets
> preempted, the host scheduler is already getting "notified", otherwise the vCPU
> would still be scheduled in, i.e. wouldn't have been preempted.

The guest wants to lazily up its priority when needed. So, it changes its
priority on this shared memory, but the host doesn't know about the raised
priority, and decides to preempt it (where it would not if it knew the
priority was raised). Then it exits into the host via VMEXIT. When else is
the host going to know of this priority changed?

> 
> > The host should also set a bit in the shared memory to tell the guest
> > that it was boosted. Then when the vCPU schedules a lower priority task
> > than what is in shared memory, and the bit is set that tells the guest
> > the host boosted the vCPU, it needs to make a hypercall to tell the
> > host that it can lower its priority again.  
> 
> Which again doesn't _need_ a dedicated/manual VM-Exit.  E.g. why force the host
> to reasses the priority instead of simply waiting until the next reschedule?  If
> the host is running tickless, then presumably there is a scheduling entity running
> on a different pCPU, i.e. that can react to vCPU priority changes without needing
> a VM-Exit.

This is done in a shared memory location. The guest can raise and lower its
priority via writing into the shared memory. It may raise and lower it back
without the host ever knowing. No hypercall needed.

But if it raises its priority, and the host decides to schedule it because
the host is unaware of its raised priority, it will preempt it. Then when
it exits into the host (via VMEXIT) this is the first time the host will
know that its priority was raised, and then we can call something like
rt_mutex_setprio() to lazily change its priority. It would then also set a
bit to inform the guest that the host knows of the change, and when the
guest lowers its priority, it will now need to make a hypercall to tell the
kernel its priority is low again, and it's OK to preempt it normally.

This is similar to how some architectures do lazy irq disabling. Where they
only set some memory that says interrupts are disabled. But interrupts only
get disabled if an interrupt goes off and the code sees it's "soft
disabled", and then will disable interrupts. When the interrupts are
enabled again, it then calls the interrupt handler.

What are you suggesting to do for this fast way of increasing and
decreasing the priority of tasks?

-- Steve

