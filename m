Return-Path: <kvm+bounces-21529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C9D92FE49
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 18:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AEB11C22606
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215D8176240;
	Fri, 12 Jul 2024 16:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dqZHI5IF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD492175560
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720800896; cv=none; b=Q2KZCruY3NA4S+7CLjhXjVz2tAFO3HLBcxdO/q9qAvi0HJfMDpnZQH55D+BATgm8PXQahN4PWdoLj/DpjX7puaRsM5tQMltSO6SQb9ci6OMWW+gZRgrhZSQ7qqQJsg3GMDYba1kTqvGYJnUzX6mmk6jYJurk//fd7Y013tyq/Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720800896; c=relaxed/simple;
	bh=p1lmG7ltAHwJhAZLEgFrTfyfMpGEVZZ3n8Rf3ABa7zc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CzwUjs+/KrhXGxuYopxyEayF7qaU3YNjt/YSxBFgE7Nisdare3NrinQUNuYOzsD3ushMh/aQ7mbzl1Vm9f/2ka7zB8agW6FBX1DYlCuWWfGNvXkVEjVuC/Kn55h//DBNeJ9XUxOkoZMhTdSfrjWP2cULTHn+I/oGtCgfPlbqhGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dqZHI5IF; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-778702b9f8fso1277249a12.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 09:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720800894; x=1721405694; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gB4u9bt/bh9aRFaB/JsA58Kq1eCv0VzbEYAMSceJb4g=;
        b=dqZHI5IFeeJ2cC1JCmpI2ocmQM0F9+58WT8ipWuypiZbFeC3lzJb220h/wPRbPwk2g
         pVq9rY7u8OEdWlF1LQ8ZU2RR7FbU+DM0OqeY1Sr3Y1Fz9S9+WHBRRKhSRSvtPmTmidXD
         ihRNSkmtMXt/uyXuuM4P5ZYBIG70WMdFqt3XNUc4c8RufHBHjKK+QHTFylohLdjElX4S
         GpywnAVybEL6pxVCTN+RTJ1G3V8nGIQIbP4baittBhcMVfJfSQ6KbyAOzRZ7sQuKZGEM
         RCeSUfus1ZYgrsZ/V3XjW629qkrzViXgSDAeS+bpfF+uMh65Bzi+Qte0vAiUh7HO3B6s
         4EmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720800894; x=1721405694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gB4u9bt/bh9aRFaB/JsA58Kq1eCv0VzbEYAMSceJb4g=;
        b=TMNsfaphox3tb4rgkEjl2IWTm5+8xLhG3aBWsWIAwA5ktYqkQhqqpk3SF2AN+KGEhe
         rfs83iAlquD1YfgShZp/dTHD/f3/mdmA+dsNVKrhIOhWKnISY9PrRtLdLrUyC7zEzYrR
         m8uRkeRWg7fV3/Jd8cdaqVSJj7QYJhi7ieKlhJ1dYJC2ofTP+4csZtdRlAvN2rfYLJ64
         Wp3b8w3NLx8uysTx8mno9UfJa+A2qzwCNOGGSqMb3Yi7MYNm0niu8VFoYosyzmvXdlub
         awa9STUeBfynCIgeYwgtZ07AmIVwZLtgtfYBIjuYvtD/N5rrUNP9udhNdX9up8fIeMJl
         hwfA==
X-Forwarded-Encrypted: i=1; AJvYcCW59uMttSyMM93Wc+lh677DhfW/cAXtNPWpLf6eQIl/dCvPZcRrPM9lo7fR2FzQz8vHCM+PBn2r4TPnNpGk11BcpelC
X-Gm-Message-State: AOJu0YzASg3nyTRUVOaNoK3s32ZOWrATxQaCFuBdcHJmkjxAiLeNJ0i0
	WELhkHgVQkpZvbr0VQlFyFdUtrsjtqUA3c09TNoMDbvdaSbtADCulA49g4c7dTWQw1zywA9Ujbx
	CcQ==
X-Google-Smtp-Source: AGHT+IE+wlrq8NNMT9gs1Pf9jxtrG9TYS0jNRBfBtlBAcZDIQ+qEw02RaWvfjxmYmAvSRWpPNSyDZfoJZEk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:593:b0:701:d445:c8f7 with SMTP id
 41be03b00d2f7-78a0c2b0006mr6680a12.3.1720800893990; Fri, 12 Jul 2024 09:14:53
 -0700 (PDT)
Date: Fri, 12 Jul 2024 09:14:52 -0700
In-Reply-To: <01c3e7de-0c1a-45e0-aed6-c11e9fa763df@efficios.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com> <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com> <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <ZpFCKrRKluacu58x@google.com> <01c3e7de-0c1a-45e0-aed6-c11e9fa763df@efficios.com>
Message-ID: <ZpFWfInsXQdPJC0V@google.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
From: Sean Christopherson <seanjc@google.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, 
	Vineeth Remanan Pillai <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, 
	Borislav Petkov <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, graf@amazon.com, 
	drjunior.org@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 12, 2024, Mathieu Desnoyers wrote:
> On 2024-07-12 10:48, Sean Christopherson wrote:
> > > > I was looking at the rseq on request from the KVM call, however it does not
> > > > make sense to me yet how to expose the rseq area via the Guest VA to the host
> > > > kernel.  rseq is for userspace to kernel, not VM to kernel.
> > 
> > Any memory that is exposed to host userspace can be exposed to the guest.  Things
> > like this are implemented via "overlay" pages, where the guest asks host userspace
> > to map the magic page (rseq in this case) at GPA 'x'.  Userspace then creates a
> > memslot that overlays guest RAM to map GPA 'x' to host VA 'y', where 'y' is the
> > address of the page containing the rseq structure associated with the vCPU (in
> > pretty much every modern VMM, each vCPU has a dedicated task/thread).
> > 
> > A that point, the vCPU can read/write the rseq structure directly.
> 
> This helps me understand what you are trying to achieve. I disagree with
> some aspects of the design you present above: mainly the lack of
> isolation between the guest kernel and the host task doing the KVM_RUN.
> We do not want to let the guest kernel store to rseq fields that would
> result in getting the host task killed (e.g. a bogus rseq_cs pointer).

Yeah, exposing the full rseq structure to the guest is probably a terrible idea.
The above isn't intended to be a design, the goal is just to illustrate how an
rseq-like mechanism can be extended to the guest without needing virtualization
specific ABI and without needing new KVM functionality.

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
>   value as set by setpriority(2).
> 
> - We introduce two new fields in the per-thread struct rseq, which is
>   mapped in the host task doing KVM_RUN and readable from the scheduler:
> 
>   - __s32 prio_offset; /* Priority offset to apply on the current task priority. */
> 
>   - __u64 vcpu_sched;  /* Pointer to a struct vcpu_sched in user-space */

Ideally, there won't be a virtualization specific structure.  A vCPU specific
field might make sense (or it might not), but I really want to avoid defining a
structure that is unique to virtualization.  E.g. a userspace doing M:N scheduling
can likely benefit from any capacity hooks/information that would benefit a guest
scheduler.  I.e. rather than a vcpu_sched structure, have a user_sched structure
(or whatever name makes sense), and then have two struct pointers in rseq.

Though I'm skeptical that having two structs in play would be necessary or sane.
E.g. if both userspace and guest can adjust priority, then they'll need to coordinate
in order to avoid unexpected results.  I can definitely see wanting to let the
userspace VMM bound the priority of a vCPU, but that should be a relatively static
decision, i.e. can be done via syscall or something similarly "slow".

>     vcpu_sched would be a userspace pointer to a new vcpu_sched structure,
>     which would be typically NULL except for tasks doing KVM_RUN. This would
>     sit in its own pages per vcpu, which takes care of isolation between guest
>     kernel and host process. Those would be RW by the guest kernel as
>     well and contain e.g.:
> 
>     struct vcpu_sched {
>         __u32 len;  /* Length of active fields. */
> 
>         __s32 prio_offset;
>         __s32 cpu_capacity_offset;
>         [...]
>     };
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
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com
> 

