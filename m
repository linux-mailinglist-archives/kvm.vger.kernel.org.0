Return-Path: <kvm+bounces-4593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C28668150FB
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 21:18:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33CA01F24549
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 20:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1932445C0E;
	Fri, 15 Dec 2023 20:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="RMJCQD/6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C43A4187A
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 20:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2cc3647bf06so11625731fa.2
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 12:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1702671513; x=1703276313; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1iQKTJgbCz5BO8Tz3qnfKksMf7YlJ59LwaYRWahk0s=;
        b=RMJCQD/6wkxPLj+S6oSrBFW8ByTTPUS0N0cb8p/QmZ2+v/KkPpG4xYNPulDfIXSXIC
         Z7O3a1TTbrngFz678bcBKfEVklTfIs2LezFfq1EFNzYpyalLT5BpQ0H6sl1hJ6e7wI13
         g/KiM7gSI9SUc3anJ2h2p20028EJeOZmMPOh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702671513; x=1703276313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1iQKTJgbCz5BO8Tz3qnfKksMf7YlJ59LwaYRWahk0s=;
        b=vpcGEoSbNue1rK7XdLohMtGRi1vaZG0TBkQsbAt9U3X8VXSTUBQ8X/4sDn7QnxXcvd
         09NJg4UkPOP+gso1JlW3QclVkmYCyPWGde3J+fqOM9kCt7XI4abBoijd+1R165YNp7wu
         SsDQ55Q246mEoHbBh9WDt5O+mGax8VmTsqOFfRSP+5T2dmNbCGdDSzL23RPrspzKRLJo
         HA7BZJ+3S8OAL35qvJyEcgHxFevUVIm8Yhir19+peibUQZrsewqItyBv9ZvS8aJIPgpB
         /o9ViQzXIRzTv93cKetFtPwN1bEeLkqXASr4KsYmv0gRK2Z4k0DPFhg+uci+oYwcpbmf
         3m5Q==
X-Gm-Message-State: AOJu0Yz8YxU85bn9uGzVXi2N5RfaheVM0Zq9927y/IgeIrHgESe4I43I
	eUtVMPH3dTSByjGjkdK/JK9nSeE1LWt7rmWiEvERjg==
X-Google-Smtp-Source: AGHT+IEz1a82jWQhUAfQHht//yOUQ4Syec4/v7J6DdgkjCIOCWR9r7KnlSETZKI+wvlp34Vm0/PPzkTDETysYBvUGe0=
X-Received: by 2002:a2e:a178:0:b0:2c9:fa32:4261 with SMTP id
 u24-20020a2ea178000000b002c9fa324261mr3688100ljl.60.1702671513032; Fri, 15
 Dec 2023 12:18:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com> <CAEXW_YTfgemRBKRv2UNjsOLhokxvvmHbVVj1JLtVmhywKtqeHA@mail.gmail.com>
 <ZXyA-Me-DSmCWr7x@google.com>
In-Reply-To: <ZXyA-Me-DSmCWr7x@google.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Fri, 15 Dec 2023 15:18:21 -0500
Message-ID: <CAEXW_YQ6hVwWrRe-Fgk8bU6BcbwVYoX5ARB8eR+ERZuTuE-wug@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 11:38=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Dec 15, 2023, Joel Fernandes wrote:
> > Hi Sean,
> > Nice to see your quick response to the RFC, thanks. I wanted to
> > clarify some points below:
> >
> > On Thu, Dec 14, 2023 at 3:13=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Thu, Dec 14, 2023, Vineeth Remanan Pillai wrote:
> > > > On Thu, Dec 14, 2023 at 11:38=E2=80=AFAM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > Now when I think about it, the implementation seems to
> > > > suggest that we are putting policies in kvm. Ideally, the goal is:
> > > > - guest scheduler communicates the priority requirements of the wor=
kload
> > > > - kvm applies the priority to the vcpu task.
> > >
> > > Why?  Tasks are tasks, why does KVM need to get involved?  E.g. if th=
e problem
> > > is that userspace doesn't have the right knobs to adjust the priority=
 of a task
> > > quickly and efficiently, then wouldn't it be better to solve that pro=
blem in a
> > > generic way?
> >
> > No, it is not only about tasks. We are boosting anything RT or above
> > such as softirq, irq etc as well.
>
> I was talking about the host side of things.  A vCPU is a task, full stop=
.  KVM
> *may* have some information that is useful to the scheduler, but KVM does=
 not
> *need* to initiate adjustments to a vCPU's priority.

Sorry I thought you were referring to guest tasks. You are right, KVM
does not *need* to change priority. But a vCPU is a container of tasks
who's priority dynamically changes. Still, I see your point of view
and that's also why we offer the capability to be selectively enabled
or disabled per-guest by the VMM (Vineeth will make it default off and
opt-in in the next series).

> > Could you please see the other patches?
>
> I already have, see my comments about boosting vCPUs that have received N=
MIs and
> IRQs not necessarily being desirable.

Ah, I was not on CC for that email. Seeing it now. I think I don't
fully buy that argument, hard IRQs are always high priority IMHO. If
an hrtimer expires on a CPU running a low priority workload, that
hrtimer might itself wake up a high priority thread. If we don't boost
the hrtimer interrupt handler, then that will delay the wakeup as
well. It is always a chain of events and it has to be boosted from the
first event. If a system does not wish to give an interrupt a high
priority, then the typical way is to use threaded IRQs and lower the
priority of the thread. That will give the interrupt handler lower
priority and the guest is free to do that. We had many POCs before
where we don't boost at all for interrupts and they all fall apart.
This is the only POC that works without any issues as far as we know
(we've been trying to do this for a long time :P).

Regarding perf, I similarly disagree. I think a PMU event is super
important (example, some versions of the kernel watchdog that depend
on PMU fail without it). But if some VM does not want this to be
prioritized, they could just not opt-in for the feature IMO. I can see
your point of view that not all VMs may want this behavior though.

> > > > > Pushing the scheduling policies to host userspace would allow for=
 far more control
> > > > > and flexibility.  E.g. a heavily paravirtualized environment wher=
e host userspace
> > > > > knows *exactly* what workloads are being run could have wildly di=
fferent policies
> > > > > than an environment where the guest is a fairly vanilla Linux VM =
that has received
> > > > > a small amount of enlightment.
> > > > >
> > > > > Lastly, if the concern/argument is that userspace doesn't have th=
e right knobs
> > > > > to (quickly) boost vCPU tasks, then the proposed sched_ext functi=
onality seems
> > > > > tailor made for the problems you are trying to solve.
> > > > >
> > > > > https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.or=
g
> > > > >
> > > > You are right, sched_ext is a good choice to have policies
> > > > implemented. In our case, we would need a communication mechanism a=
s
> > > > well and hence we thought kvm would work best to be a medium betwee=
n
> > > > the guest and the host.
> > >
> > > Making KVM be the medium may be convenient and the quickest way to ge=
t a PoC
> > > out the door, but effectively making KVM a middle-man is going to be =
a huge net
> > > negative in the long term.  Userspace can communicate with the guest =
just as
> > > easily as KVM, and if you make KVM the middle-man, then you effective=
ly *must*
> > > define a relatively rigid guest/host ABI.
> >
> > At the moment, the only ABI is a shared memory structure and a custom
> > MSR. This is no different from the existing steal time accounting
> > where a shared structure is similarly shared between host and guest,
> > we could perhaps augment that structure with other fields instead of
> > adding a new one?
>
> I'm not concerned about the number of structures/fields, it's the amount/=
type of
> information and the behavior of KVM that is problematic.  E.g. boosting t=
he priority
> of a vCPU that has a pending NMI is dubious.

I think NMIs have to be treated as high priority, the perf profiling
interrupt for instance works well on x86 (unlike ARM) because it can
interrupt any context (other than NMI and possibly the machine check
ones). On ARM on the other hand, because the perf interrupt is a
regular non-NMI interrupt, you cannot profile hardirq and IRQ-disable
regions (this could have changed since pseudo-NMI features). So making
the NMI a higher priority than IRQ is not dubious AFAICS, it is a
requirement in many cases IMHO.

> This RFC has baked in a large
> number of assumptions that (mostly) fit your specific use case, but do no=
t
> necessarily apply to all use cases.

Yes, agreed. We'll make it more generic.

> I'm not even remotely convinced that what's prosed here is optimal for yo=
ur use case either.

We have a data-driven approach. We've tested this with lots of use
cases and collected metrics with both real and synthetic workloads
(not just us but many other teams we work with). It might not be
optimal, but definitely is a step forward IMO. As you can see the
several-fold reduction in latencies, audio glitches etc. We did wait a
long time for RFC however that was because we did not want to push out
something broken. In hind-sight, we should be posting this work
upstream more quickly (but in our defense, we did present this work at
2 other conferences this year ;-)).

> > On the ABI point, we have deliberately tried to keep it simple (for exa=
mple,
> > a few months ago we had hypercalls and we went to great lengths to elim=
inate
> > those).
>
> Which illustrates one of the points I'm trying to make is kind of my poin=
t.
> Upstream will never accept anything that's wildly complex or specific bec=
ause such
> a thing is unlikely to be maintainable.

TBH, it is not that complex though. But let us know which parts, if
any, can be further simplified (I saw your suggestions for next steps
in the reply to Vineeth, those look good to me and we'll plan
accordingly).

> > > If instead the contract is between host userspace and the guest, the =
ABI can be
> > > much more fluid, e.g. if you (or any setup) can control at least some=
 amount of
> > > code that runs in the guest
> >
> > I see your point of view. One way to achieve this is to have a BPF
> > program run to implement the boosting part, in the VMEXIT path. KVM
> > then just calls a hook. Would that alleviate some of your concerns?
>
> Yes, it absolutely would!  I would *love* to build a rich set of BPF util=
ities
> and whatnot for KVM[1].

Nice to see it! Definitely interested in this work.

> I have zero objections to KVM making data available to
> BPF programs, i.e. to host userspace, quite the opposite.  What I am stea=
dfastedly
> against is KVM make decisions that are not obviously the "right" decision=
s in all
> situations.  And I do not want to end up in a world where KVM has a big p=
ile of
> knobs to let userspace control those decisions points, i.e. I don't want =
to make
> KVM a de facto paravirt scheduler.
>
> I think there is far more potential for this direction.  KVM already has =
hooks
> for VM-Exit and VM-Entry, they likely just need to be enhanced to make th=
em more
> useful for BPF programs.  And adding hooks in other paths shouldn't be to=
o
> contentious, e.g. in addition to what you've done in this RFC, adding a h=
ook to
> kvm_vcpu_on_spin() could be quite interesting as I would not be at all su=
rprised
> if userspace could make far better decisions when selecting the vCPU to y=
ield to.
>
> And there are other use cases for KVM making "interesting" data available=
 to
> userspace, e.g. there's (very early) work[2] to allow userspace to poll()=
 on vCPUs,
> which likely needs much of the same information that paravirt scheduling =
would
> find useful, e.g. whether or not the vCPU has pending events.
>
> [1] https://lore.kernel.org/all/ZRIf1OPjKV66Y17%2F@google.com
> [2] https://lore.kernel.org/all/ZR9gATE2NSOOhedQ@google.com

The polling work seems interesting too for what we're doing, shall
look further as well. Thank you!

> > > then the contract between the guest and host doesn't
> > > even need to be formally defined, it could simply be a matter of bund=
ling host
> > > and guest code appropriately.
> > >
> > > If you want to land support for a given contract in upstream reposito=
ries, e.g.
> > > to broadly enable paravirt scheduling support across a variety of use=
rsepace VMMs
> > > and/or guests, then yeah, you'll need a formal ABI.  But that's still=
 not a good
> > > reason to have KVM define the ABI.  Doing it in KVM might be a wee bi=
t easier because
> > > it's largely just a matter of writing code, and LKML provides a centr=
alized channel
> > > for getting buyin from all parties.  But defining an ABI that's indep=
endent of the
> > > kernel is absolutely doable, e.g. see the many virtio specs.
> > >
> > > I'm not saying KVM can't help, e.g. if there is information that is k=
nown only
> > > to KVM, but the vast majority of the contract doesn't need to be defi=
ned by KVM.
> >
> > The key to making this working of the patch is VMEXIT path, that is
> > only available to KVM. If we do anything later, then it might be too
> > late.
>
> Strictly speaking, no, it's not.  It's key if and only if *KVM* boosts th=
e priority
> of the task/vCPU (or if KVM provides a hook for a BPF program to do its t=
hing).

Ok, agreed.

> > We have to intervene *before* the scheduler takes the vCPU thread off t=
he
> > CPU.
>
> If the host scheduler is directly involved in the paravirt shenanigans, t=
hen
> there is no need to hook KVM's VM-Exit path because the scheduler already=
 has the
> information needed to make an informed decision.

Just to clarify, we're not making any "decisions" in the VM exit path,
we're just giving the scheduler enough information (via the
setscheduler call). The scheduler may just as well "decide" it wants
to still preempt the vCPU thread -- that's Ok in fact required some
times. We're just arming it with more information, specifically that
this is an important thread. We can find another way to pass this
information along (BPF etc) but I just wanted to mention that KVM is
not really replacing the functionality or decision-making of the
scheduler even with this POC.

> > Similarly, in the case of an interrupt injected into the guest, we have
> > to boost the vCPU before the "vCPU run" stage -- anything later might b=
e too
> > late.
>
> Except that this RFC doesn't actually do this.  KVM's relevant function n=
ames suck
> and aren't helping you, but these patches boost vCPUs when events are *pe=
nded*,
> not when they are actually injected.

We are doing the injection bit in:
https://lore.kernel.org/all/20231214024727.3503870-5-vineeth@bitbyteword.or=
g/

For instance, in:

 kvm_set_msi ->
  kvm_irq_delivery_to_apic ->
     kvm_apic_set_irq ->
       __apic_accept_irq ->
            kvm_vcpu_kick_boost();

The patch is a bit out of order because patch 4 depends on 3. Patch 3
does what you're referring to, which is checking for pending events.

Did we miss something? If there is some path that we are missing, your
help is much appreciated as you're likely much more versed with this
code than me.  But doing the boosting at injection time is what has
made all the difference (for instance with cyclictest latencies).

> Boosting the priority of vCPUs at semi-arbitrary points is going to be mu=
ch more
> difficult for KVM to "get right".  E.g. why boost the priority of a vCPU =
that has
> a pending IRQ, but not a vCPU that is running with IRQs disabled?

I was actually wanting to boost preempted vCPU threads that were
preempted in IRQ disabled regions as well. In fact, that is on our
TODO.. we just haven't done it yet as we notice that usually IRQ is
disabled while preemption was already disabled and just boosting
preempt-disabled gets us most of the way there.

> The potential
> for endless twiddling to try and tune KVM's de facto scheduling logic so =
that it's
> universally "correct" is what terrifies me.

Yes, we can certainly look into BPF to make it a bit more generic for
our usecase (while getting enough information from the kernel).

By the way, one other usecase for this patch series is RCU.  I am one
of the RCU maintainers and I am looking into improving RCU in VMs. For
instance, boosting preempted RCU readers to RT (CONFIG_RCU_BOOST) does
not usually work because the vCPU thread on the host is not RT.
Similarly, other RCU threads which have RT priority don't get to run
causing issues.

Thanks!

 - Joel

