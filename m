Return-Path: <kvm+bounces-4594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7674081533B
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 23:09:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D58E5B25302
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 22:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6ED65EBC;
	Fri, 15 Dec 2023 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="coibmiha"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C70675D8
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 22:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbcc50db48cso1262816276.0
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 14:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702677676; x=1703282476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q/XgF9D+ghWHUEkU0/9EFhe8biuUdcjJQbYRys6RmOs=;
        b=coibmiha3XGJaH/fO8bYZr4hVK5r9xdV3z08WKvum2hAT5+M4TSGw+Zy//kFyPMeCu
         gll1VtNF6lhQ4jwhKrp5rCma0WPdXbQNm1+5iVFi1WJLVuVqtbq/8wdoJQj1vbNppaXJ
         pK9cbt+TUmLRAITxC+z/IJYmztuRBccbpLu51QvgiGKbEEbxc25VeQpOFa+XMyOhROrw
         AGgwjAFmU6QGtsOeNKUZJHOKcXkWruDVLyYxUXhASnR6jyQaf+ADPHy9ZtMYtS1NLHu2
         +yp6n6Fq3wFnYMRSCxuA0SfKtA0duI8Xgj+vzJ+uSgA7RyeSZFKXdQwtlBTNnJLyOCMe
         GDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702677676; x=1703282476;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q/XgF9D+ghWHUEkU0/9EFhe8biuUdcjJQbYRys6RmOs=;
        b=sl3EqVMhgG2Inc3fvn0crTgTKOm+atWFsP5VCX7Zctxd1S1TUoWm+F7ytg1HZmfKrd
         gVUIf6/5kLjSjKwV83ZSlNGfqnkBSnYGH0FUj19liL2+cj3jekb3SHB04dW4OXcU6GwE
         FLC58SY2KJolc8Uv/IxQpiTrPlfWtido6vvvJtRBtWmkpCTFvvYUDAiPV6/42R5EbLe0
         QmF1lO5cVUCX0pRV+uOS1JtqnvvL6+SNRfvt8wtJ7WayIOb9XhNAssc2cskfA8SInCqi
         qhZB4sXy08cIGbROwqlPDH6qS2x5ZI8CMTd+IPVobRV2HG9lnNrFsi1AkU4A4q1cKIcl
         YHAg==
X-Gm-Message-State: AOJu0YzfftsevQ9O+ku7T+hdPLBIueagtOpTrl8mpyYUHUARCP3CyYuO
	dq5rJr4WtFO9vFkxUoofvx68FkzFoYo=
X-Google-Smtp-Source: AGHT+IFRfifySHfu+x7zocgmttDsEC9d4gRnsz7xikVQGrFLGy2SKg/qdoWft9GPsjmIJAKpi++YUen43Z4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:134a:b0:dbd:2f0:c763 with SMTP id
 g10-20020a056902134a00b00dbd02f0c763mr9605ybu.1.1702677675842; Fri, 15 Dec
 2023 14:01:15 -0800 (PST)
Date: Fri, 15 Dec 2023 14:01:14 -0800
In-Reply-To: <CAEXW_YQ6hVwWrRe-Fgk8bU6BcbwVYoX5ARB8eR+ERZuTuE-wug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com> <CAEXW_YTfgemRBKRv2UNjsOLhokxvvmHbVVj1JLtVmhywKtqeHA@mail.gmail.com>
 <ZXyA-Me-DSmCWr7x@google.com> <CAEXW_YQ6hVwWrRe-Fgk8bU6BcbwVYoX5ARB8eR+ERZuTuE-wug@mail.gmail.com>
Message-ID: <ZXzMqiGFVe4sepaw@google.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
From: Sean Christopherson <seanjc@google.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Vineeth Remanan Pillai <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, 
	Borislav Petkov <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, David Vernet <dvernet@meta.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023, Joel Fernandes wrote:
> On Fri, Dec 15, 2023 at 11:38=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Fri, Dec 15, 2023, Joel Fernandes wrote:
> > > Hi Sean,
> > > Nice to see your quick response to the RFC, thanks. I wanted to
> > > clarify some points below:
> > >
> > > On Thu, Dec 14, 2023 at 3:13=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > On Thu, Dec 14, 2023, Vineeth Remanan Pillai wrote:
> > > > > On Thu, Dec 14, 2023 at 11:38=E2=80=AFAM Sean Christopherson <sea=
njc@google.com> wrote:
> > > > > Now when I think about it, the implementation seems to
> > > > > suggest that we are putting policies in kvm. Ideally, the goal is=
:
> > > > > - guest scheduler communicates the priority requirements of the w=
orkload
> > > > > - kvm applies the priority to the vcpu task.
> > > >
> > > > Why?  Tasks are tasks, why does KVM need to get involved?  E.g. if =
the problem
> > > > is that userspace doesn't have the right knobs to adjust the priori=
ty of a task
> > > > quickly and efficiently, then wouldn't it be better to solve that p=
roblem in a
> > > > generic way?
> > >
> > > No, it is not only about tasks. We are boosting anything RT or above
> > > such as softirq, irq etc as well.
> >
> > I was talking about the host side of things.  A vCPU is a task, full st=
op.  KVM
> > *may* have some information that is useful to the scheduler, but KVM do=
es not
> > *need* to initiate adjustments to a vCPU's priority.
>=20
> Sorry I thought you were referring to guest tasks. You are right, KVM
> does not *need* to change priority. But a vCPU is a container of tasks
> who's priority dynamically changes. Still, I see your point of view
> and that's also why we offer the capability to be selectively enabled
> or disabled per-guest by the VMM (Vineeth will make it default off and
> opt-in in the next series).
>=20
> > > Could you please see the other patches?
> >
> > I already have, see my comments about boosting vCPUs that have received
> > NMIs and IRQs not necessarily being desirable.
>=20
> Ah, I was not on CC for that email. Seeing it now. I think I don't
> fully buy that argument, hard IRQs are always high priority IMHO.

They most definitely are not, and there are undoubtedly tiers of priority, =
e.g.
tiers are part and parcel of the APIC architecture.  I agree that *most* IR=
Qs are
high-ish priority, but that is not the same that *all* IRQs are high priori=
ty.
It only takes one example to disprove the latter, and I can think of severa=
l off
the top of my head.

Nested virtualization is the easy one to demonstrate.

On AMD, which doesn't have an equivalent to the VMX preemption timer, KVM u=
ses a
self-IPI to wrest control back from the guest immediately after VMRUN in so=
me
situations (mostly to inject events into L2 while honoring the architectura=
l
priority of events).  If the guest is running a nested workload, the result=
ing
IRQ in L1 is not at all interesting or high priority, as the L2 workload ha=
sn't
suddenly become high priority just because KVM wants to inject an event.

Anyways, I didn't mean to start a debate over the priority of handling IRQs=
 and
NMIs, quite the opposite actually.  The point I'm trying to make is that un=
der
no circumstance do I want KVM to be making decisions about whether or not s=
uch
things are high priority.  I have no objection to KVM making information av=
ailable
to whatever entity is making the actual decisions, it's having policy in KV=
M that
I am staunchly opposed to.

> If an hrtimer expires on a CPU running a low priority workload, that
> hrtimer might itself wake up a high priority thread. If we don't boost
> the hrtimer interrupt handler, then that will delay the wakeup as
> well. It is always a chain of events and it has to be boosted from the
> first event. If a system does not wish to give an interrupt a high
> priority, then the typical way is to use threaded IRQs and lower the
> priority of the thread. That will give the interrupt handler lower
> priority and the guest is free to do that. We had many POCs before
> where we don't boost at all for interrupts and they all fall apart.
> This is the only POC that works without any issues as far as we know
> (we've been trying to do this for a long time :P).

In *your* environment.  The fact that it took multiple months to get a stab=
le,
functional set of patches for one use case is *exactly* why I am pushing ba=
ck on
this.  Change any number of things about the setup and odds are good that t=
he
result would need different tuning.  E.g. the ratio of vCPUs to pCPUs, the =
number
of VMs, the number of vCPUs per VM, whether or not the host kernel is preem=
ptible,
whether or not the guest kernel is preemptible, the tick rate of the host a=
nd
guest kernels, the workload of the VM, the affinity of tasks within the VM,=
 and
and so on and so forth.

It's a catch-22 of sorts.  Anything that is generic enough to land upstream=
 is
likely going to be too coarse grained to be universally applicable.

> Regarding perf, I similarly disagree. I think a PMU event is super
> important (example, some versions of the kernel watchdog that depend
> on PMU fail without it). But if some VM does not want this to be
> prioritized, they could just not opt-in for the feature IMO. I can see
> your point of view that not all VMs may want this behavior though.

Or a VM may want it conditionally, e.g. only for select tasks.

> > > At the moment, the only ABI is a shared memory structure and a custom
> > > MSR. This is no different from the existing steal time accounting
> > > where a shared structure is similarly shared between host and guest,
> > > we could perhaps augment that structure with other fields instead of
> > > adding a new one?
> >
> > I'm not concerned about the number of structures/fields, it's the amoun=
t/type of
> > information and the behavior of KVM that is problematic.  E.g. boosting=
 the priority
> > of a vCPU that has a pending NMI is dubious.
>=20
> I think NMIs have to be treated as high priority, the perf profiling
> interrupt for instance works well on x86 (unlike ARM) because it can
> interrupt any context (other than NMI and possibly the machine check
> ones). On ARM on the other hand, because the perf interrupt is a
> regular non-NMI interrupt, you cannot profile hardirq and IRQ-disable
> regions (this could have changed since pseudo-NMI features). So making
> the NMI a higher priority than IRQ is not dubious AFAICS, it is a
> requirement in many cases IMHO.

Again, many, but not all.  A large part of KVM's success is that KVM has ve=
ry few
"opinions" of its own.  Outside of the MMU and a few paravirt paths, KVM mo=
stly
just emulates/virtualizes hardware according to the desires of userspace.  =
This
has allowed a fairly large variety of use cases to spring up with relativel=
y few
changes to KVM.

What I want to avoid is (a) adding something that only works for one use ca=
se
and (b) turning KVM into a scheduler of any kind.

> > Which illustrates one of the points I'm trying to make is kind of my po=
int.
> > Upstream will never accept anything that's wildly complex or specific b=
ecause such
> > a thing is unlikely to be maintainable.
>=20
> TBH, it is not that complex though.=20

Yet.  Your use case is happy with relatively simple, coarse-grained hooks. =
 Use
cases that want to squeeze out maximum performance, e.g. because shaving N%=
 off
the runtime saves $$$, are likely willing to take on far more complexity, o=
r may
just want to make decisions at a slightly different granularity.

> But let us know which parts, if any, can be further simplified (I saw you=
r
> suggestions for next steps in the reply to Vineeth, those look good to me=
 and
> we'll plan accordingly).

It's not a matter of simplifying things, it's a matter of KVM (a) not defin=
ing
policy of any kind and (b) KVM not defining a guest/host ABI.

> > > We have to intervene *before* the scheduler takes the vCPU thread off=
 the
> > > CPU.
> >
> > If the host scheduler is directly involved in the paravirt shenanigans,=
 then
> > there is no need to hook KVM's VM-Exit path because the scheduler alrea=
dy has the
> > information needed to make an informed decision.
>=20
> Just to clarify, we're not making any "decisions" in the VM exit path,

Yes, you are.

> we're just giving the scheduler enough information (via the
> setscheduler call). The scheduler may just as well "decide" it wants
> to still preempt the vCPU thread -- that's Ok in fact required some
> times. We're just arming it with more information, specifically that
> this is an important thread. We can find another way to pass this
> information along (BPF etc) but I just wanted to mention that KVM is
> not really replacing the functionality or decision-making of the
> scheduler even with this POC.

Yes, it is.  kvm_vcpu_kick_boost() *directly* adjusts the priority of the t=
ask.
KVM is not just passing a message, KVM is defining a scheduling policy of "=
boost
vCPUs with pending IRQs, NMIs, SMIs, and PV unhalt events".

The VM-Exit path also makes those same decisions by boosting a vCPU if the =
guest
has requested boost *or* the vCPU has a pending event (but oddly, not pendi=
ng
NMIs, SMIs, or PV unhalt events):

	bool pending_event =3D kvm_cpu_has_pending_timer(vcpu) || kvm_cpu_has_inte=
rrupt(vcpu);

	/*
	 * vcpu needs a boost if
	 * - A lazy boost request active or a pending latency sensitive event, and
	 * - Preemption disabled duration on this vcpu has not crossed the thresho=
ld.
	 */
	return ((schedinfo.boost_req =3D=3D VCPU_REQ_BOOST || pending_event) &&
			!kvm_vcpu_exceeds_preempt_disabled_duration(&vcpu->arch));


Which, by the by is suboptimal.  Detecting for pending events isn't free, s=
o you
ideally want to check for pending events if and only if the guest hasn't re=
quested
a boost.

> > > Similarly, in the case of an interrupt injected into the guest, we ha=
ve
> > > to boost the vCPU before the "vCPU run" stage -- anything later might=
 be too
> > > late.
> >
> > Except that this RFC doesn't actually do this.  KVM's relevant function=
 names suck
> > and aren't helping you, but these patches boost vCPUs when events are *=
pended*,
> > not when they are actually injected.
>=20
> We are doing the injection bit in:
> https://lore.kernel.org/all/20231214024727.3503870-5-vineeth@bitbyteword.=
org/
>=20
> For instance, in:
>=20
>  kvm_set_msi ->
>   kvm_irq_delivery_to_apic ->
>      kvm_apic_set_irq ->
>        __apic_accept_irq ->
>             kvm_vcpu_kick_boost();
>=20
> The patch is a bit out of order because patch 4 depends on 3. Patch 3
> does what you're referring to, which is checking for pending events.
>=20
> Did we miss something? If there is some path that we are missing, your
> help is much appreciated as you're likely much more versed with this
> code than me.  But doing the boosting at injection time is what has
> made all the difference (for instance with cyclictest latencies).

That accepts in IRQ into the vCPU's local APIC, it does not *inject* the IR=
Q into
the vCPU proper.  The actual injection is done by kvm_check_and_inject_even=
ts().
A pending IRQ is _usually_ delivered/injected fairly quickly, but not alway=
s.

E.g. if the guest has IRQs disabled (RFLAGS.IF=3D0), KVM can't immediately =
inject
the IRQ (without violating x86 architecture).  In that case, KVM will twidd=
le
VMCS/VMCB knobs to detect an IRQ window, i.e. to cause a VM-Exit when IRQs =
are
no longer blocked in the guest.

Your PoC actually (mostly) handles this (see above) by keeping the vCPU boo=
sted
after EXIT_REASON_INTERRUPT_WINDOW (because the IRQ will obviously still be=
 pending).

> > Boosting the priority of vCPUs at semi-arbitrary points is going to be =
much more
> > difficult for KVM to "get right".  E.g. why boost the priority of a vCP=
U that has
> > a pending IRQ, but not a vCPU that is running with IRQs disabled?
>=20
> I was actually wanting to boost preempted vCPU threads that were
> preempted in IRQ disabled regions as well. In fact, that is on our
> TODO.. we just haven't done it yet as we notice that usually IRQ is
> disabled while preemption was already disabled and just boosting
> preempt-disabled gets us most of the way there.
>=20
> > The potential for endless twiddling to try and tune KVM's de facto
> > scheduling logic so that it's universally "correct" is what terrifies m=
e.
>=20
> Yes, we can certainly look into BPF to make it a bit more generic for
> our usecase (while getting enough information from the kernel).
>=20
> By the way, one other usecase for this patch series is RCU.  I am one
> of the RCU maintainers and I am looking into improving RCU in VMs. For
> instance, boosting preempted RCU readers to RT (CONFIG_RCU_BOOST) does
> not usually work because the vCPU thread on the host is not RT.
> Similarly, other RCU threads which have RT priority don't get to run
> causing issues.
>=20
> Thanks!
>=20
>  - Joel

