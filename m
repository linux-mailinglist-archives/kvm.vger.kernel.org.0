Return-Path: <kvm+bounces-6155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42DF682C586
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 19:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C34C42846EC
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 18:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D2C15AD9;
	Fri, 12 Jan 2024 18:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="lEHZYuf1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EAE14F7B
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 18:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4279b73b5feso41879921cf.3
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 10:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1705084659; x=1705689459; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sXPF+GJwWlxVUGqIrI+FF3iXQIPfphfOcegcyI8wUZc=;
        b=lEHZYuf1UpUKNIOe5R1mxv2EBe89H5gMzzMrj96TlEAyiCSwBRkSg2nJPGAeMJYDb2
         v6kqJUhFW/h55wzG4u201LmKYBc47cko2GznEbk6J1JTEPhzfKTwSOYzmHBlr0+F2FlU
         v9e6d+WSB75NT7VKHUMiUO7zIumxkJQtzYR34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705084659; x=1705689459;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sXPF+GJwWlxVUGqIrI+FF3iXQIPfphfOcegcyI8wUZc=;
        b=N7g4Iw+7f/q03PXR2yEHvIEo4cg/rtrm81MdGIFAAz7IBkbjZYc717z77tCPaJDrbH
         6RSubw8dEX5N61vtxBlB0641d02pRAwHOjUAst1DZ55bv37Rmi/nY9dP9RckX1oix7We
         6s02Qo0owgc0CQVGELES9TD8Kdc/5639Pq4N5GydBxfpXNZKuj3FyfPWJvxGw4xxgPA7
         leZbcBgMED4qaXQWhvIkpbPHrJ9wzHjNcVRZzlu5rf+B7exjnaVsWZTs2rpQbFrRNN1a
         AhtH8T6vY9fdhdXxm3Pi8TLQp2csD3zJo+KlfEAWxbcBxuifogBbw7TeQhopxOs2WSv5
         VI2g==
X-Gm-Message-State: AOJu0Yw49RSkVa6PRz3rJVN3V9EMccFTN+V23FWNfdZSN4SGt26KSEpY
	5h7YZvc8Mlus/TJxMGhFNWTmcVY6Q/WEkQ==
X-Google-Smtp-Source: AGHT+IHEBI3StujPO1gEeMK+FHELDwzAlGRHty8nS4QVxQ52YW7MA/nMHNzVh/59kcSsosfuPm95Lg==
X-Received: by 2002:a05:622a:243:b0:429:aee6:ba49 with SMTP id c3-20020a05622a024300b00429aee6ba49mr2205786qtx.32.1705084658621;
        Fri, 12 Jan 2024 10:37:38 -0800 (PST)
Received: from localhost (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id ch7-20020a05622a40c700b00429970654b6sm1582376qtb.33.2024.01.12.10.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 10:37:37 -0800 (PST)
Message-ID: <65a186f1.050a0220.867e0.8696@mx.google.com>
X-Google-Original-Message-ID: <20240112183736.GA1379@JoelBox.>
Date: Fri, 12 Jan 2024 13:37:36 -0500
From: Joel Fernandes <joel@joelfernandes.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Vineeth Remanan Pillai <vineeth@bitbyteword.org>,
	Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>,
	Barret Rhoden <brho@google.com>, David Vernet <dvernet@meta.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com>
 <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com>
 <CAEXW_YTfgemRBKRv2UNjsOLhokxvvmHbVVj1JLtVmhywKtqeHA@mail.gmail.com>
 <ZXyA-Me-DSmCWr7x@google.com>
 <CAEXW_YQ6hVwWrRe-Fgk8bU6BcbwVYoX5ARB8eR+ERZuTuE-wug@mail.gmail.com>
 <ZXzMqiGFVe4sepaw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZXzMqiGFVe4sepaw@google.com>

Hi Sean,

Happy new year. Just back from holidays, thanks for the discussions. I
replied below:

On Fri, Dec 15, 2023 at 02:01:14PM -0800, Sean Christopherson wrote:
> On Fri, Dec 15, 2023, Joel Fernandes wrote:
> > On Fri, Dec 15, 2023 at 11:38 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Dec 15, 2023, Joel Fernandes wrote:
> > > > Hi Sean,
> > > > Nice to see your quick response to the RFC, thanks. I wanted to
> > > > clarify some points below:
> > > >
> > > > On Thu, Dec 14, 2023 at 3:13 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Thu, Dec 14, 2023, Vineeth Remanan Pillai wrote:
> > > > > > On Thu, Dec 14, 2023 at 11:38 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > > > Now when I think about it, the implementation seems to
> > > > > > suggest that we are putting policies in kvm. Ideally, the goal is:
> > > > > > - guest scheduler communicates the priority requirements of the workload
> > > > > > - kvm applies the priority to the vcpu task.
> > > > >
> > > > > Why?  Tasks are tasks, why does KVM need to get involved?  E.g. if the problem
> > > > > is that userspace doesn't have the right knobs to adjust the priority of a task
> > > > > quickly and efficiently, then wouldn't it be better to solve that problem in a
> > > > > generic way?
> > > >
> > > > No, it is not only about tasks. We are boosting anything RT or above
> > > > such as softirq, irq etc as well.
> > >
> > > I was talking about the host side of things.  A vCPU is a task, full stop.  KVM
> > > *may* have some information that is useful to the scheduler, but KVM does not
> > > *need* to initiate adjustments to a vCPU's priority.
> > 
> > Sorry I thought you were referring to guest tasks. You are right, KVM
> > does not *need* to change priority. But a vCPU is a container of tasks
> > who's priority dynamically changes. Still, I see your point of view
> > and that's also why we offer the capability to be selectively enabled
> > or disabled per-guest by the VMM (Vineeth will make it default off and
> > opt-in in the next series).
> > 
> > > > Could you please see the other patches?
> > >
> > > I already have, see my comments about boosting vCPUs that have received
> > > NMIs and IRQs not necessarily being desirable.
> > 
> > Ah, I was not on CC for that email. Seeing it now. I think I don't
> > fully buy that argument, hard IRQs are always high priority IMHO.
> 
> They most definitely are not, and there are undoubtedly tiers of priority, e.g.
> tiers are part and parcel of the APIC architecture.  I agree that *most* IRQs are
> high-ish priority, but that is not the same that *all* IRQs are high priority.
> It only takes one example to disprove the latter, and I can think of several off
> the top of my head.
> 
> Nested virtualization is the easy one to demonstrate.
> 
> On AMD, which doesn't have an equivalent to the VMX preemption timer, KVM uses a
> self-IPI to wrest control back from the guest immediately after VMRUN in some
> situations (mostly to inject events into L2 while honoring the architectural
> priority of events).  If the guest is running a nested workload, the resulting
> IRQ in L1 is not at all interesting or high priority, as the L2 workload hasn't
> suddenly become high priority just because KVM wants to inject an event.

Ok I see your point of view and tend to agree with you. I think I was mostly
going by my experience which has predominantly been on embedded systems. One
counter argument I would make is that just because an IRQ event turned out
not to be high priority, doesn't mean it would never be. For instance, if the
guest was running something important and not just a nested workload, then
perhaps the self-IPI in your example would be important. As another example,
the scheduling clock interrupt may be a useless a lot of times but those
times that it does become useful make it worth prioritizing highly (example,
preempting a task after it exhausts slice, invoking RCU core to service
callbacks, etc).

But I see your point of view and tend to agree with it too!

> 
> Anyways, I didn't mean to start a debate over the priority of handling IRQs and
> NMIs, quite the opposite actually.  The point I'm trying to make is that under
> no circumstance do I want KVM to be making decisions about whether or not such
> things are high priority.  I have no objection to KVM making information available
> to whatever entity is making the actual decisions, it's having policy in KVM that
> I am staunchly opposed to.

Ok makes sense, I think we have converged on this now and I agree it seems
wrong to bake the type of policy we were attempting into KVM, which may not
work for everyone and makes it inflexible to experiment. So back to the
drawing board on that..

> > If an hrtimer expires on a CPU running a low priority workload, that
> > hrtimer might itself wake up a high priority thread. If we don't boost
> > the hrtimer interrupt handler, then that will delay the wakeup as
> > well. It is always a chain of events and it has to be boosted from the
> > first event. If a system does not wish to give an interrupt a high
> > priority, then the typical way is to use threaded IRQs and lower the
> > priority of the thread. That will give the interrupt handler lower
> > priority and the guest is free to do that. We had many POCs before
> > where we don't boost at all for interrupts and they all fall apart.
> > This is the only POC that works without any issues as far as we know
> > (we've been trying to do this for a long time :P).
> 
> In *your* environment.  The fact that it took multiple months to get a stable,
> functional set of patches for one use case is *exactly* why I am pushing back on
> this.  Change any number of things about the setup and odds are good that the
> result would need different tuning.  E.g. the ratio of vCPUs to pCPUs, the number
> of VMs, the number of vCPUs per VM, whether or not the host kernel is preemptible,
> whether or not the guest kernel is preemptible, the tick rate of the host and
> guest kernels, the workload of the VM, the affinity of tasks within the VM, and
> and so on and so forth.
> 
> It's a catch-22 of sorts.  Anything that is generic enough to land upstream is
> likely going to be too coarse grained to be universally applicable.

Ok, agreed.

> > Regarding perf, I similarly disagree. I think a PMU event is super
> > important (example, some versions of the kernel watchdog that depend
> > on PMU fail without it). But if some VM does not want this to be
> > prioritized, they could just not opt-in for the feature IMO. I can see
> > your point of view that not all VMs may want this behavior though.
> 
> Or a VM may want it conditionally, e.g. only for select tasks.

Got it.

> > > > At the moment, the only ABI is a shared memory structure and a custom
> > > > MSR. This is no different from the existing steal time accounting
> > > > where a shared structure is similarly shared between host and guest,
> > > > we could perhaps augment that structure with other fields instead of
> > > > adding a new one?
> > >
> > > I'm not concerned about the number of structures/fields, it's the amount/type of
> > > information and the behavior of KVM that is problematic.  E.g. boosting the priority
> > > of a vCPU that has a pending NMI is dubious.
> > 
> > I think NMIs have to be treated as high priority, the perf profiling
> > interrupt for instance works well on x86 (unlike ARM) because it can
> > interrupt any context (other than NMI and possibly the machine check
> > ones). On ARM on the other hand, because the perf interrupt is a
> > regular non-NMI interrupt, you cannot profile hardirq and IRQ-disable
> > regions (this could have changed since pseudo-NMI features). So making
> > the NMI a higher priority than IRQ is not dubious AFAICS, it is a
> > requirement in many cases IMHO.
> 
> Again, many, but not all.  A large part of KVM's success is that KVM has very few
> "opinions" of its own.  Outside of the MMU and a few paravirt paths, KVM mostly
> just emulates/virtualizes hardware according to the desires of userspace.  This
> has allowed a fairly large variety of use cases to spring up with relatively few
> changes to KVM.
> 
> What I want to avoid is (a) adding something that only works for one use case
> and (b) turning KVM into a scheduler of any kind.

Ok. Makes sense.

> > > Which illustrates one of the points I'm trying to make is kind of my point.
> > > Upstream will never accept anything that's wildly complex or specific because such
> > > a thing is unlikely to be maintainable.
> > 
> > TBH, it is not that complex though. 
> 
> Yet.  Your use case is happy with relatively simple, coarse-grained hooks.  Use
> cases that want to squeeze out maximum performance, e.g. because shaving N% off
> the runtime saves $$$, are likely willing to take on far more complexity, or may
> just want to make decisions at a slightly different granularity.

Ok.

> > But let us know which parts, if any, can be further simplified (I saw your
> > suggestions for next steps in the reply to Vineeth, those look good to me and
> > we'll plan accordingly).
> 
> It's not a matter of simplifying things, it's a matter of KVM (a) not defining
> policy of any kind and (b) KVM not defining a guest/host ABI.

Ok.

> > > > We have to intervene *before* the scheduler takes the vCPU thread off the
> > > > CPU.
> > >
> > > If the host scheduler is directly involved in the paravirt shenanigans, then
> > > there is no need to hook KVM's VM-Exit path because the scheduler already has the
> > > information needed to make an informed decision.
> > 
> > Just to clarify, we're not making any "decisions" in the VM exit path,
> 
> Yes, you are.

Ok sure, I see what you mean. We're making decisions about the "when to
boost" thing. Having worked on the scheduler for a few years, I was more
referring to "decisions that the scheduler makes such as where to place a
task during wakeup, load balance, whether to migrate, etc" due to my bias.
Those are complex decisions that even with these patches, it is upto the
scheduler. But I see you were referring to a different type of decision
making, so agreed with you.

> > we're just giving the scheduler enough information (via the
> > setscheduler call). The scheduler may just as well "decide" it wants
> > to still preempt the vCPU thread -- that's Ok in fact required some
> > times. We're just arming it with more information, specifically that
> > this is an important thread. We can find another way to pass this
> > information along (BPF etc) but I just wanted to mention that KVM is
> > not really replacing the functionality or decision-making of the
> > scheduler even with this POC.
> 
> Yes, it is.  kvm_vcpu_kick_boost() *directly* adjusts the priority of the task.
> KVM is not just passing a message, KVM is defining a scheduling policy of "boost
> vCPUs with pending IRQs, NMIs, SMIs, and PV unhalt events".

Fair enough.

> The VM-Exit path also makes those same decisions by boosting a vCPU if the guest
> has requested boost *or* the vCPU has a pending event (but oddly, not pending
> NMIs, SMIs, or PV unhalt events):
> 
> 	bool pending_event = kvm_cpu_has_pending_timer(vcpu) || kvm_cpu_has_interrupt(vcpu);
> 
> 	/*
> 	 * vcpu needs a boost if
> 	 * - A lazy boost request active or a pending latency sensitive event, and
> 	 * - Preemption disabled duration on this vcpu has not crossed the threshold.
> 	 */
> 	return ((schedinfo.boost_req == VCPU_REQ_BOOST || pending_event) &&
> 			!kvm_vcpu_exceeds_preempt_disabled_duration(&vcpu->arch));
> 
> 
> Which, by the by is suboptimal.  Detecting for pending events isn't free, so you
> ideally want to check for pending events if and only if the guest hasn't requested
> a boost.

That sounds like a worthwhile optimization! Agreed that the whole
boosting-a-pending-event can also be looked at as policy..

> > > > Similarly, in the case of an interrupt injected into the guest, we have
> > > > to boost the vCPU before the "vCPU run" stage -- anything later might be too
> > > > late.
> > >
> > > Except that this RFC doesn't actually do this.  KVM's relevant function names suck
> > > and aren't helping you, but these patches boost vCPUs when events are *pended*,
> > > not when they are actually injected.
> > 
> > We are doing the injection bit in:
> > https://lore.kernel.org/all/20231214024727.3503870-5-vineeth@bitbyteword.org/
> > 
> > For instance, in:
> > 
> >  kvm_set_msi ->
> >   kvm_irq_delivery_to_apic ->
> >      kvm_apic_set_irq ->
> >        __apic_accept_irq ->
> >             kvm_vcpu_kick_boost();
> > 
> > The patch is a bit out of order because patch 4 depends on 3. Patch 3
> > does what you're referring to, which is checking for pending events.
> > 
> > Did we miss something? If there is some path that we are missing, your
> > help is much appreciated as you're likely much more versed with this
> > code than me.  But doing the boosting at injection time is what has
> > made all the difference (for instance with cyclictest latencies).
> 
> That accepts in IRQ into the vCPU's local APIC, it does not *inject* the IRQ into
> the vCPU proper.  The actual injection is done by kvm_check_and_inject_events().
> A pending IRQ is _usually_ delivered/injected fairly quickly, but not always.
> 
> E.g. if the guest has IRQs disabled (RFLAGS.IF=0), KVM can't immediately inject
> the IRQ (without violating x86 architecture).  In that case, KVM will twiddle
> VMCS/VMCB knobs to detect an IRQ window, i.e. to cause a VM-Exit when IRQs are
> no longer blocked in the guest.
> 
> Your PoC actually (mostly) handles this (see above) by keeping the vCPU boosted
> after EXIT_REASON_INTERRUPT_WINDOW (because the IRQ will obviously still be pending).

Ah got it now, thanks for the detailed description of the implementation and
what we might be missing. Will dig further.

Thanks Sean!

 - Joel


