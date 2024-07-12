Return-Path: <kvm+bounces-21532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80BF792FE6A
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 18:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3891C283CA6
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D094A176242;
	Fri, 12 Jul 2024 16:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="hZbMgb/V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABF7176222
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720801485; cv=none; b=BmR3MAWe9UavpQ69b4O7tW6u1NGuMGoHRwNK0jCdYbDZMxsfiYdv6vh4fDk3k3dmpo48RFMnPp6Y7KogNl6lvW5noRz6TUOi2NrUjYoaKyojJ/E1hqG6XMFj+4/LWP5tveICpXE7rV5W8CK+sNxGarmpy+WcdIkpx3MJTUMJhTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720801485; c=relaxed/simple;
	bh=eG2h1wf1TFEiWSPh9EdPzDrruIV5y1r2B426i/gnRBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K2dex4mmG7LOKk9dgo5mKXZLvmdVLsdMmA5/I1auT8WlZPcq6wTXNR6pdgcI6nfU9Asp40hUBk2N+k6YnRtV4aXmccnARM3JkIGU43bsrgg9F56l4ZxwAeYe69bQZfX8jYVvykrbwLNyTnQXlLi01XpXsN9HgSv+J2839RON/dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org; spf=pass smtp.mailfrom=joelfernandes.org; dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b=hZbMgb/V; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ebe40673e8so29905601fa.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 09:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1720801481; x=1721406281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B1SCEXL7m409mgdEhz113iPiFu7MKkY9LBrkPgvCZAU=;
        b=hZbMgb/VbGmSxO6vS4R+eaL3ORjc698xVoJRBkaT8Ck7cByL/nglW0ayOhEHvTLSWH
         +KBGhSgeD3xpWDk1DwQYpLJm6tMDSqQMoEUvR0p+C7yA5I9Qx7wx+BVQtqAwYhiqicJq
         qN7sxtZAJ3ekf6AIVeCO/GfA48JqWuEFtIjh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720801481; x=1721406281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B1SCEXL7m409mgdEhz113iPiFu7MKkY9LBrkPgvCZAU=;
        b=sd1EC3L4LhgG55gVBZ2IGzxEKfDeN6fsj74ezeXjt5YXhKgZqf9VNnM1wn3EiuezBx
         MfAN9DYedS5RDNZRc/mqosBOHshU+6M+skUAPhcWA4cDmWNI0/qsJKf2uFS9HDi225GL
         0ZS7hNzVMsnGAExVIGey2BtNbKniPRbNapkBlbhXKPcJgdm1Lk6NxvOXk/wK5SD9+/FH
         32poN+UUv4eB/s7eZFFE5+dvdPMkkhgBuyYsomukHQaJ0DTmrbdx92NCeJvf4t5RVJA5
         ecQ9sy2qwOtluitaoCT6xL1s2C6BZ4mPGBBDVlYdiASzdx1pvydnHWGmm68cCD6n71m2
         2xDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVEBxB63NVzgUgEIcQF2h14NReOLnuJuVwD5HPI1uWdYCMd0eIwjwPbIQkBc15ztokrbE1AUeyNieXXitiGUuUnz0j
X-Gm-Message-State: AOJu0Ywc6CoKj5IPnPmJfR9Jr4e2bkckRC3z/6qDUijYdFrJYxUmbQYA
	VG201E7sNHNYSqLuXoBpYe+9bjem2w41hR8v0lCgqSm8evdx454PfNCyV3UaqRFhvpMgaWXJrdQ
	DCpDABa3ozIAfYZcVoukduiz1Ai74Eyny/ItgTA==
X-Google-Smtp-Source: AGHT+IGlSO87Bo7uNXOMKQpx5nCroCN+tAZoOdFx62GddXCJPp7q0aGE7JWv5DPpAqmjrytfBmmRc4MT2aOC1wPAam8=
X-Received: by 2002:a2e:8081:0:b0:2ec:522f:6443 with SMTP id
 38308e7fff4ca-2eeb318282emr75009181fa.33.1720801481132; Fri, 12 Jul 2024
 09:24:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com> <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com> <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
In-Reply-To: <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Fri, 12 Jul 2024 12:24:28 -0400
Message-ID: <CAEXW_YRBNs30ZC1e+U3mco22=XxaCfhPO_5wEHe+wFJjAbbSvA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vineeth Remanan Pillai <vineeth@bitbyteword.org>, Sean Christopherson <seanjc@google.com>, 
	Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, graf@amazon.com, 
	drjunior.org@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2024 at 10:09=E2=80=AFAM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> On 2024-07-12 08:57, Joel Fernandes wrote:
> > On Mon, Jun 24, 2024 at 07:01:19AM -0400, Vineeth Remanan Pillai wrote:
> [...]
> >> Existing use cases
> >> -------------------------
> >>
> >> - A latency sensitive workload on the guest might need more than one
> >> time slice to complete, but should not block any higher priority task
> >> in the host. In our design, the latency sensitive workload shares its
> >> priority requirements to host(RT priority, cfs nice value etc). Host
> >> implementation of the protocol sets the priority of the vcpu task
> >> accordingly so that the host scheduler can make an educated decision
> >> on the next task to run. This makes sure that host processes and vcpu
> >> tasks compete fairly for the cpu resource.
>
> AFAIU, the information you need to convey to achieve this is the priority
> of the task within the guest. This information need to reach the host
> scheduler to make informed decision.
>
> One thing that is unclear about this is what is the acceptable
> overhead/latency to push this information from guest to host ?
> Is an hypercall OK or does it need to be exchanged over a memory
> mapping shared between guest and host ?

Shared memory for the boost (Can do it later during host preemption).
But for unboost, we possibly need a hypercall in addition to it as
well.

>
> Hypercalls provide simple ABIs across guest/host, and they allow
> the guest to immediately notify the host (similar to an interrupt).
>
> Shared memory mapping will require a carefully crafted ABI layout,
> and will only allow the host to use the information provided when
> the host runs. Therefore, if the choice is to share this information
> only through shared memory, the host scheduler will only be able to
> read it when it runs, so in hypercall, interrupt, and so on.

The initial idea was to handle the details/format/allocation of the
shared memory out-of-band in a driver, but then later the rseq idea
came up.

> >> - Guest should be able to notify the host that it is running a lower
> >> priority task so that the host can reschedule it if needed. As
> >> mentioned before, the guest shares the priority with the host and the
> >> host takes a better scheduling decision.
>
> It is unclear to me whether this information needs to be "pushed"
> from guest to host (e.g. hypercall) in a way that allows the host
> to immediately act on this information, or if it is OK to have the
> host read this information when its scheduler happens to run.

For boosting, there is no need to immediately push. Only on preemption.

> >> - Proactive vcpu boosting for events like interrupt injection.
> >> Depending on the guest for boost request might be too late as the vcpu
> >> might not be scheduled to run even after interrupt injection. Host
> >> implementation of the protocol boosts the vcpu tasks priority so that
> >> it gets a better chance of immediately being scheduled and guest can
> >> handle the interrupt with minimal latency. Once the guest is done
> >> handling the interrupt, it can notify the host and lower the priority
> >> of the vcpu task.
>
> This appears to be a scenario where the host sets a "high priority", and
> the guest clears it when it is done with the irq handler. I guess it can
> be done either ways (hypercall or shared memory), but the choice would
> depend on the parameters identified above: acceptable overhead vs accepta=
ble
> latency to inform the host scheduler.

Yes, we have found ways to reduce/make fewer hypercalls on unboost.

> >> - Guests which assign specialized tasks to specific vcpus can share
> >> that information with the host so that host can try to avoid
> >> colocation of those cpus in a single physical cpu. for eg: there are
> >> interrupt pinning use cases where specific cpus are chosen to handle
> >> critical interrupts and passing this information to the host could be
> >> useful.
>
> How frequently is this topology expected to change ? Is it something that
> is set once when the guest starts and then is fixed ? How often it change=
s
> will likely affect the tradeoffs here.

Yes, will be fixed.

> >> - Another use case is the sharing of cpu capacity details between
> >> guest and host. Sharing the host cpu's load with the guest will enable
> >> the guest to schedule latency sensitive tasks on the best possible
> >> vcpu. This could be partially achievable by steal time, but steal time
> >> is more apparent on busy vcpus. There are workloads which are mostly
> >> sleepers, but wake up intermittently to serve short latency sensitive
> >> workloads. input event handlers in chrome is one such example.
>
> OK so for this use-case information goes the other way around: from host
> to guest. Here the shared mapping seems better than polling the state
> through an hypercall.

Yes, FWIW this particular part is for future and not initially required per=
-se.

> >> Data from the prototype implementation shows promising improvement in
> >> reducing latencies. Data was shared in the v1 cover letter. We have
> >> not implemented the capacity based placement policies yet, but plan to
> >> do that soon and have some real numbers to share.
> >>
> >> Ideas brought up during offlist discussion
> >> -------------------------------------------------------
> >>
> >> 1. rseq based timeslice extension mechanism[1]
> >>
> >> While the rseq based mechanism helps in giving the vcpu task one more
> >> time slice, it will not help in the other use cases. We had a chat
> >> with Steve and the rseq mechanism was mainly for improving lock
> >> contention and would not work best with vcpu boosting considering all
> >> the use cases above. RT or high priority tasks in the VM would often
> >> need more than one time slice to complete its work and at the same,
> >> should not be hurting the host workloads. The goal for the above use
> >> cases is not requesting an extra slice, but to modify the priority in
> >> such a way that host processes and guest processes get a fair way to
> >> compete for cpu resources. This also means that vcpu task can request
> >> a lower priority when it is running lower priority tasks in the VM.
> >
> > I was looking at the rseq on request from the KVM call, however it does=
 not
> > make sense to me yet how to expose the rseq area via the Guest VA to th=
e host
> > kernel.  rseq is for userspace to kernel, not VM to kernel.
> >
> > Steven Rostedt said as much as well, thoughts? Add Mathieu as well.
>
> I'm not sure that rseq would help at all here, but I think we may want to
> borrow concepts of data sitting in shared memory across privilege levels
> and apply them to VMs.
>
> If some of the ideas end up being useful *outside* of the context of VMs,
> then I'd be willing to consider adding fields to rseq. But as long as it =
is
> VM-specific, I suspect you'd be better with dedicated per-vcpu pages whic=
h
> you can safely share across host/guest kernels.

Yes, this was the initial plan. I also feel rseq cannot be applied here.

> > This idea seems to suffer from the same vDSO over-engineering below, rs=
eq
> > does not seem to fit.
> >
> > Steven Rostedt told me, what we instead need is a tracepoint callback i=
n a
> > driver, that does the boosting.
>
> I utterly dislike changing the system behavior through tracepoints. They =
were
> designed to observe the system, not modify its behavior. If people start =
abusing
> them, then subsystem maintainers will stop adding them. Please don't do t=
hat.
> Add a notifier or think about integrating what you are planning to add in=
to the
> driver instead.

Well, we do have "raw" tracepoints not accessible from userspace, so
you're saying even those are off limits for adding callbacks?

 - Joel

