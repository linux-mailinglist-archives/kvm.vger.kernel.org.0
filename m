Return-Path: <kvm+bounces-21534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D91A92FE98
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 18:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBE0A1F23BC1
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D733C17624C;
	Fri, 12 Jul 2024 16:30:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDE086AFA;
	Fri, 12 Jul 2024 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720801825; cv=none; b=AWZGevE329kaZyX8BMrfYYDMo6OzCCdQk4gznDnmSRxHPIzuI7V7qnSDeXtZnHZbFkn7PblLzRVvA7ywTbGvzqy/whR5bIO9vM5HlW8txTiS4IrHjv6k8gYHOfAJVI9u8VPEVZoMKWY8EwtIoZ2FIvB5AKY5JsQ/BR7w5TxfW08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720801825; c=relaxed/simple;
	bh=XxX1D7RCSdsNOTUhnzm3yP6ZokstYTzafBYtIMm5PbM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JRhF5QHfrK/OQcfqz6SRu9nJEG3Xo6NC1ecuLsW983UP+U5fEiXSUFgxUV9r3JObawFa+y9ncvb/AA7mw7XGpPOTMhppXS460XRSFvtVmM4m88rCooSfKTjU0/mlL+KwLeCdfoTxSC1krRj769wZUvJ0S6bbUcFiZft8Da/DIAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03285C32782;
	Fri, 12 Jul 2024 16:30:20 +0000 (UTC)
Date: Fri, 12 Jul 2024 12:30:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sean Christopherson <seanjc@google.com>, Joel Fernandes
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
Message-ID: <20240712123019.7e18c67a@rorschach.local.home>
In-Reply-To: <01c3e7de-0c1a-45e0-aed6-c11e9fa763df@efficios.com>
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
	<ZjJf27yn-vkdB32X@google.com>
	<CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
	<CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
	<66912820.050a0220.15d64.10f5@mx.google.com>
	<19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
	<ZpFCKrRKluacu58x@google.com>
	<01c3e7de-0c1a-45e0-aed6-c11e9fa763df@efficios.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jul 2024 11:32:30 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> >>> I was looking at the rseq on request from the KVM call, however it does not
> >>> make sense to me yet how to expose the rseq area via the Guest VA to the host
> >>> kernel.  rseq is for userspace to kernel, not VM to kernel.  
> > 
> > Any memory that is exposed to host userspace can be exposed to the guest.  Things
> > like this are implemented via "overlay" pages, where the guest asks host userspace
> > to map the magic page (rseq in this case) at GPA 'x'.  Userspace then creates a
> > memslot that overlays guest RAM to map GPA 'x' to host VA 'y', where 'y' is the
> > address of the page containing the rseq structure associated with the vCPU (in
> > pretty much every modern VMM, each vCPU has a dedicated task/thread).
> > 
> > A that point, the vCPU can read/write the rseq structure directly.  

So basically, the vCPU thread can just create a virtio device that
exposes the rseq memory to the guest kernel?

One other issue we need to worry about is that IIUC rseq memory is
allocated by the guest/user, not the host kernel. This means it can be
swapped out. The code that handles this needs to be able to handle user
page faults.

> 
> This helps me understand what you are trying to achieve. I disagree with
> some aspects of the design you present above: mainly the lack of
> isolation between the guest kernel and the host task doing the KVM_RUN.
> We do not want to let the guest kernel store to rseq fields that would
> result in getting the host task killed (e.g. a bogus rseq_cs pointer).
> But this is something we can improve upon once we understand what we
> are trying to achieve.
> 
> > 
> > The reason us KVM folks are pushing y'all towards something like rseq is that
> > (again, in any modern VMM) vCPUs are just tasks, i.e. priority boosting a vCPU
> > is actually just priority boosting a task.  So rather than invent something
> > virtualization specific, invent a mechanism for priority boosting from userspace
> > without a syscall, and then extend it to the virtualization use case.
> >   
> [...]
> 
> OK, so how about we expose "offsets" tuning the base values ?
> 
> - The task doing KVM_RUN, just like any other task, has its "priority"
>    value as set by setpriority(2).
> 
> - We introduce two new fields in the per-thread struct rseq, which is
>    mapped in the host task doing KVM_RUN and readable from the scheduler:
> 
>    - __s32 prio_offset; /* Priority offset to apply on the current task priority. */
> 
>    - __u64 vcpu_sched;  /* Pointer to a struct vcpu_sched in user-space */
> 
>      vcpu_sched would be a userspace pointer to a new vcpu_sched structure,
>      which would be typically NULL except for tasks doing KVM_RUN. This would
>      sit in its own pages per vcpu, which takes care of isolation between guest
>      kernel and host process. Those would be RW by the guest kernel as
>      well and contain e.g.:

Hmm, maybe not make this only vcpu specific, but perhaps this can be
useful for user space tasks that want to dynamically change their
priority without a system call. It could do the same thing. Yeah, yeah,
I may be coming up with a solution in search of a problem ;-)

-- Steve

> 
>      struct vcpu_sched {
>          __u32 len;  /* Length of active fields. */
> 
>          __s32 prio_offset;
>          __s32 cpu_capacity_offset;
>          [...]
>      };
> 
> So when the host kernel try to calculate the effective priority of a task
> doing KVM_RUN, it would basically start from its current priority, and offset
> by (rseq->prio_offset + rseq->vcpu_sched->prio_offset).
> 
> The cpu_capacity_offset would be populated by the host kernel and read by the
> guest kernel scheduler for scheduling/migration decisions.
> 
> I'm certainly missing details about how priority offsets should be bounded for
> given tasks. This could be an extension to setrlimit(2).
> 
> Thoughts ?
> 
> Thanks,
> 
> Mathieu
> 


