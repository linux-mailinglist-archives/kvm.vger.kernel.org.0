Return-Path: <kvm+bounces-21531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B037792FE69
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 18:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7CA41C226B6
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D625017622F;
	Fri, 12 Jul 2024 16:24:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9F916FF48;
	Fri, 12 Jul 2024 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720801459; cv=none; b=D188YgT4VhHlvCybpmtK9LlUP9T+CXqEgVIVHrnfA2vF//sl8dEZ2wV/3kUYq6cVyQ/QzgZvmzwRHqn55uzXodC0676KFKNbfSABxYoVO84xVHpZMkcj93XMwAAbh1OemGUiBxhcV5aPwaZqDfdrz238SmVcIc7vyxAf+7oMgIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720801459; c=relaxed/simple;
	bh=Anzdfp7CRnHjVZCyIJqbFKtWpwGjPGUPOCnzHZMzyuA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NRI0DRTbbyqqaJ5H0OL9jMI4DnaGtuASEJJri22sxDEnfOJESvSF4g0cBR3cWm2pNYAVc27x8A0Whhrydm0BQDLmSod3O39ur/FaCzZAPIDpInYQXeXfvvEUtD1sOlW9pMQehLgccZlytUHIpIljENOmTSr8vrRA4i5A1e2n9Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA25C32782;
	Fri, 12 Jul 2024 16:24:15 +0000 (UTC)
Date: Fri, 12 Jul 2024 12:24:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, Vineeth Remanan Pillai
 <vineeth@bitbyteword.org>, Sean Christopherson <seanjc@google.com>, Ben
 Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, Daniel Bristot
 de Oliveira <bristot@redhat.com>, Dave Hansen
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
Message-ID: <20240712122408.3f434cc5@rorschach.local.home>
In-Reply-To: <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
	<ZjJf27yn-vkdB32X@google.com>
	<CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
	<CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
	<66912820.050a0220.15d64.10f5@mx.google.com>
	<19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jul 2024 10:09:03 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > 
> > Steven Rostedt told me, what we instead need is a tracepoint callback in a
> > driver, that does the boosting.  
> 
> I utterly dislike changing the system behavior through tracepoints. They were
> designed to observe the system, not modify its behavior. If people start abusing
> them, then subsystem maintainers will stop adding them. Please don't do that.
> Add a notifier or think about integrating what you are planning to add into the
> driver instead.

I tend to agree that a notifier would be much better than using
tracepoints, but then I also think eBPF has already let that cat out of
the bag. :-p

All we need is a notifier that gets called at every VMEXIT.

The main issue that this is trying to solve is to boost the priority of
the guest without making the hypercall, so that it can quickly react
(lower the latency of reaction to an event). Now when the task is
unboosted, there's no avoiding of the hypercall as there's no other way
to tell the host that this vCPU should not be running at a higher
priority (the high priority may prevent schedules, or even checking the
new prio in the shared memory).

If there's a way to have a shared memory, via virtio or whatever, and
any notifier that gets called at any VMEXIT, then this is trivial to
implement.

-- Steve

