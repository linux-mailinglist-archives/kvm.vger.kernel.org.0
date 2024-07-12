Return-Path: <kvm+bounces-21568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1824A92FF47
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 474ED1C22C80
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD4F6178CD6;
	Fri, 12 Jul 2024 17:12:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56032176ABE;
	Fri, 12 Jul 2024 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804357; cv=none; b=fUi41yPlwvZ+NxbqxjPs3AgCbgM72YTfWRjaoYLC6akWoYjIBcr+OWAYNXw6AHFh3Ecus0YZr03Arvqn37RQexuT+5foOkReHqkacsR0mi2x0e8M3Mc/SE9vI79zoV73u6tS3rC2eWt0qScaWtv0UxE0JZtlsvv/qXbk0ur9Zv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804357; c=relaxed/simple;
	bh=2NzRlsDEUq3xDdPCYo9Tq+ccMaGcZ0cnDb0kuJ9hwY8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HGot2Y/mIZSvy6Jm3KsCPUoYK/MXNiKPzaPn+TAq7ByEOLfq6yUgpt/WZ4YL9l0w6bAyw8jIeDSvd2kk+LxCHR4tXJgoj6oJr99phChT04bcgci/VgCEr83hPcB1tjD3kGn7HP3OfmvKRxeln9trWvmpg6CUyLEMWSO07iFnYDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69B0C32782;
	Fri, 12 Jul 2024 17:12:33 +0000 (UTC)
Date: Fri, 12 Jul 2024 13:12:32 -0400
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
Message-ID: <20240712131232.6d77947b@rorschach.local.home>
In-Reply-To: <ZpFdYFNfWcnq5yJM@google.com>
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
	<ZjJf27yn-vkdB32X@google.com>
	<CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
	<CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
	<66912820.050a0220.15d64.10f5@mx.google.com>
	<19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
	<20240712122408.3f434cc5@rorschach.local.home>
	<ZpFdYFNfWcnq5yJM@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jul 2024 09:44:16 -0700
Sean Christopherson <seanjc@google.com> wrote:

> > All we need is a notifier that gets called at every VMEXIT.  
> 
> Why?  The only argument I've seen for needing to hook VM-Exit is so that the
> host can speculatively boost the priority of the vCPU when deliverying an IRQ,
> but (a) I'm unconvinced that is necessary, i.e. that the vCPU needs to be boosted
> _before_ the guest IRQ handler is invoked and (b) it has almost no benefit on
> modern hardware that supports posted interrupts and IPI virtualization, i.e. for
> which there will be no VM-Exit.

No. The speculatively boost was for something else, but slightly
related. I guess the ideal there was to have the interrupt coming in
boost the vCPU because the interrupt could be waking an RT task. It may
still be something needed, but that's not what I'm talking about here.

The idea here is when an RT task is scheduled in on the guest, we want
to lazily boost it. As long as the vCPU is running on the CPU, we do
not need to do anything. If the RT task is scheduled for a very short
time, it should not need to call any hypercall. It would set the shared
memory to the new priority when the RT task is scheduled, and then put
back the lower priority when it is scheduled out and a SCHED_OTHER task
is scheduled in.

Now if the vCPU gets preempted, it is this moment that we need the host
kernel to look at the current priority of the task thread running on
the vCPU. If it is an RT task, we need to boost the vCPU to that
priority, so that a lower priority host thread does not interrupt it.

The host should also set a bit in the shared memory to tell the guest
that it was boosted. Then when the vCPU schedules a lower priority task
than what is in shared memory, and the bit is set that tells the guest
the host boosted the vCPU, it needs to make a hypercall to tell the
host that it can lower its priority again.

The incoming irq is to handle the race between the event that wakes the
RT task, and the RT task getting a chance to run. If the preemption
happens there, the vCPU may never have a chance to notify the host that
it wants to run an RT task.

-- Steve

