Return-Path: <kvm+bounces-5692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0D4D824AE8
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 23:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BBB3281D77
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69742CCA2;
	Thu,  4 Jan 2024 22:34:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E462C6B7;
	Thu,  4 Jan 2024 22:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=manifault.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-680b1335af6so276986d6.1;
        Thu, 04 Jan 2024 14:34:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704407655; x=1705012455;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9y7yAqpfJ4UMheGLsuG2Iw5x0+iCX4HWPndErCWny80=;
        b=ka4OyOwVGRQfVnGuHLXzfekNkragYr88eH8xBhpbAwQr6vvtM6cd+r4DCmx7A7kEEN
         6Hgk8F8UZHDietMhhuPYsAThaAlCzN4SL+0kmX/xUiJnNk+QO74mWCqcx4nbA7iE5x3F
         G6sBpVvuMJPq80kIfkrJdV+6xBud5Qty5h6fft8N5sQ7Ftec8xlSSG6QrzrFAdnBs1i+
         1Zm5uO3S2hNB0zbPeFduKSeGPwrdQoI6A3Pm/ncYpcwMjSm1Jo2gfDeHUi3V/ZNVyHnB
         1hIWPvBRkdTzgyoIAZ+2f0SHv2+9Jt75Joo5wZzubJuqLbfj2wmnRYv+pgrLr5SJisl5
         yzkw==
X-Gm-Message-State: AOJu0YxOfkpHUru8WR3id3SDgr3VUP+5J0SrTUYyQdiW34De3kBQHrcX
	0cBbXozeYNkt/O+yTtY+pI0=
X-Google-Smtp-Source: AGHT+IFrCzdGwLWQr6KFX0ghpTMiJ3VoduiF2YPyI4VaUlgs0erjxAc5tp8LdG2Cl/ygxfyCTJjuYQ==
X-Received: by 2002:a05:6214:c83:b0:680:ce23:cb45 with SMTP id r3-20020a0562140c8300b00680ce23cb45mr1957732qvr.15.1704407654812;
        Thu, 04 Jan 2024 14:34:14 -0800 (PST)
Received: from maniforge (c-24-1-27-177.hsd1.il.comcast.net. [24.1.27.177])
        by smtp.gmail.com with ESMTPSA id i8-20020a056214030800b0067ffcfb0b51sm131161qvu.139.2024.01.04.14.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 14:34:14 -0800 (PST)
Date: Thu, 4 Jan 2024 16:34:10 -0600
From: David Vernet <void@manifault.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Sean Christopherson <seanjc@google.com>,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
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
	Barret Rhoden <brho@google.com>, David Dunn <daviddunn@google.com>,
	julia.lawall@inria.fr, himadrispandya@gmail.com,
	jean-pierre.lozi@inria.fr, ast@kernel.org, paulmck@kernel.org
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
Message-ID: <20240104223410.GE303539@maniforge>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com>
 <20231215181014.GB2853@maniforge>
 <6595bee6.e90a0220.57b35.76e9@mx.google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="c0OHFIbsmEu88mf0"
Content-Disposition: inline
In-Reply-To: <6595bee6.e90a0220.57b35.76e9@mx.google.com>
User-Agent: Mutt/2.2.12 (2023-09-09)


--c0OHFIbsmEu88mf0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 03, 2024 at 03:09:07PM -0500, Joel Fernandes wrote:
> Hi David,
>=20
> On Fri, Dec 15, 2023 at 12:10:14PM -0600, David Vernet wrote:
> > On Thu, Dec 14, 2023 at 08:38:47AM -0800, Sean Christopherson wrote:
> > > +sched_ext folks
> >=20
> > Thanks for the cc.
>=20
> Just back from holidays, sorry for the late reply. But it was a good brea=
k to
> go over your email in more detail ;-).

Hi Joel,

No worries at all, and happy new year!

> > > On Wed, Dec 13, 2023, Vineeth Pillai (Google) wrote:
> > > > Double scheduling is a concern with virtualization hosts where the =
host
> > > > schedules vcpus without knowing whats run by the vcpu and guest sch=
edules
> > > > tasks without knowing where the vcpu is physically running. This ca=
uses
> > > > issues related to latencies, power consumption, resource utilization
> > > > etc. An ideal solution would be to have a cooperative scheduling
> > > > framework where the guest and host shares scheduling related inform=
ation
> > > > and makes an educated scheduling decision to optimally handle the
> > > > workloads. As a first step, we are taking a stab at reducing latenc=
ies
> > > > for latency sensitive workloads in the guest.
> > > >=20
> > > > This series of patches aims to implement a framework for dynamically
> > > > managing the priority of vcpu threads based on the needs of the wor=
kload
> > > > running on the vcpu. Latency sensitive workloads (nmi, irq, softirq,
> > > > critcal sections, RT tasks etc) will get a boost from the host so a=
s to
> > > > minimize the latency.
> > > >=20
> > > > The host can proactively boost the vcpu threads when it has enough
> > > > information about what is going to run on the vcpu - fo eg: injecti=
ng
> > > > interrupts. For rest of the case, guest can request boost if the vc=
pu is
> > > > not already boosted. The guest can subsequently request unboost aft=
er
> > > > the latency sensitive workloads completes. Guest can also request a
> > > > boost if needed.
> > > >=20
> > > > A shared memory region is used to communicate the scheduling inform=
ation.
> > > > Guest shares its needs for priority boosting and host shares the bo=
osting
> > > > status of the vcpu. Guest sets a flag when it needs a boost and con=
tinues
> > > > running. Host reads this on next VMEXIT and boosts the vcpu thread.=
 For
> > > > unboosting, it is done synchronously so that host workloads can fai=
rly
> > > > compete with guests when guest is not running any latency sensitive
> > > > workload.
> > >=20
> > > Big thumbs down on my end.  Nothing in this RFC explains why this sho=
uld be done
> > > in KVM.  In general, I am very opposed to putting policy of any kind =
into KVM,
> > > and this puts a _lot_ of unmaintainable policy into KVM by deciding w=
hen to
> > > start/stop boosting a vCPU.
> >=20
> > I have to agree, not least of which is because in addition to imposing a
> > severe maintenance tax, these policies are far from exhaustive in terms
> > of what you may want to do for cooperative paravirt scheduling.
>=20
> Just to clarify the 'policy' we are discussing here, it is not about 'how=
 to
> schedule' but rather 'how/when to boost/unboost'. We want the existing
> scheduler (or whatever it might be in the future) to make the actual deci=
sion
> about how to schedule.

Thanks for clarifying. I think we're on the same page. I didn't mean to
imply that KVM is actually in the scheduler making decisions about what
task to run next, but that wasn't really my concern. My concern is that
this patch set makes KVM responsible for all of the possible paravirt
policies by encoding it in KVM UAPI, and is ultimately responsible for
being aware of and communicating those policies between the guest to the
host scheduler.

Say that we wanted to add some other paravirt related policy like "these
VCPUs may benefit from being co-located", or, "this VCPU just grabbed a
critical spinlock so please pin me for a moment". That would require
updating struct guest_schedinfo UAPI in kvm_para.h, adding getters and
setters to kvm_host.h to set those policies for the VCPU (though your
idea to use a BPF hook on VMEXIT may help with that onme), setting the
state from the guest, etc.

KVM isn't making scheduling decisions, but it's the arbiter of what data
is available to the scheduler to consume. As it relates to a VCPU, it
seems like this patch set makes KVM as much invested in the scheduling
decision that's eventually made as the actual scheduler. Also worth
considering is that it ties KVM UAPI to sched/core.c, which seems
undesirable from the perspective of both subsystems.

> In that sense, I agree with Sean that we are probably forcing a singular
> policy on when and how to boost which might not work for everybody (in th=
eory
> anyway). And I am perfectly OK with the BPF route as I mentioned in the o=
ther

FWIW, I don't think it's just that boosting may not work well in every
context (though I do think there's an argument to be made for that, as
Sean pointed out r.e. hard IRQs in nested context). The problem is also
that boosting is just one example of a paravirt policy that you may want
to enable, as I alluded to above, and that comes with complexity and
maintainership costs.

> email. So perhaps we can use a tracepoint in the VMEXIT path to run a BPF
> program (?). And we still have to figure out how to run BPF programs in t=
he
> interrupt injections patch (I am currently studying those paths more also
> thanks to Sean's email describing them).

If I understand correctly, based on your question below, the idea is to
call sched_setscheduler() from a kfunc in this VMEXIT BPF tracepoint?
Please let me know if that's correct -- I'll respond to this below where
you ask the question.

As an aside, even if we called a BPF tracepoint prog on the VMEXIT path,
AFAIU it would still require UAPI changes given that we'd still need to
make all the same changes in the guest, right? I see why having a BPF
hook here would be useful to avoid some of the logic on the host that
implements the boosting, and to give more flexibility as to when to
apply that boosting, but in my mind it seems like the UAPI concerns are
the most relevant.

> > I think
> > something like sched_ext would give you the best of all worlds: no
> > maintenance burden on the KVM maintainers, more options for implementing
> > various types of policies, performant, safe to run on the host, no need
> > to reboot when trying a new policy, etc. More on this below.
>=20
> I think switching to sched_ext just for this is overkill, we don't want
> to change the scheduler yet which is a much more invasive/involved change=
d.
> For instance, we want the features of this patchset to work for ARM as we=
ll
> which heavily depends on EAS/cpufreq.

Fair enough, I see your point in that you just want to adjust prio and
policy. I agree that's not the same thing as writing an entirely new
scheduler, but I think we have to approach this from the perspective of
what's the right long-term design. The cost of having to plumb all of
this through KVM UAPI (as well as hard-code where the paravirt policies
are applied in the guest, such as in sched/core.c) is pretty steep, and
using BPF seems like a way to broadly enable paravirt scheduling without
having to take on the complexity or maintenance burden of adding these
paravirt UAPI changes at all.

> [...]
> > > Concretely, boosting vCPUs for most events is far too coarse grained.=
  E.g. boosting
> > > a vCPU that is running a low priority workload just because the vCPU =
triggered
> > > an NMI due to PMU counter overflow doesn't make sense.  Ditto for if =
a guest's
> > > hrtimer expires on a vCPU running a low priority workload.
> > >
> > > And as evidenced by patch 8/8, boosting vCPUs based on when an event =
is _pending_
> > > is not maintainable.  As hardware virtualizes more and more functiona=
lity, KVM's
> > > visilibity into the guest effectively decreases, e.g. Intel and AMD b=
oth support
> > > with IPI virtualization.
> > >=20
> > > Boosting the target of a PV spinlock kick is similarly flawed.  In th=
at case, KVM
> > > only gets involved _after_ there is a problem, i.e. after a lock is c=
ontended so
> > > heavily that a vCPU stops spinning and instead decided to HLT.  It's =
not hard to
> > > imagine scenarios where a guest would want to communicate to the host=
 that it's
> > > acquiring a spinlock for a latency sensitive path and so shouldn't be=
 scheduled
> > > out.  And of course that's predicated on the assumption that all vCPU=
s are subject
> > > to CPU overcommit.
> > >=20
> > > Initiating a boost from the host is also flawed in the sense that it =
relies on
> > > the guest to be on the same page as to when it should stop boosting. =
 E.g. if
> > > KVM boosts a vCPU because an IRQ is pending, but the guest doesn't wa=
nt to boost
> > > IRQs on that vCPU and thus doesn't stop boosting at the end of the IR=
Q handler,
> > > then the vCPU could end up being boosted long after its done with the=
 IRQ.
> > >=20
> > > Throw nested virtualization into the mix and then all of this becomes=
 nigh
> > > impossible to sort out in KVM.  E.g. if an L1 vCPU is a running an L2=
 vCPU, i.e.
> > > a nested guest, and L2 is spamming interrupts for whatever reason, KV=
M will end
> > > repeatedly boosting the L1 vCPU regardless of the priority of the L2 =
workload.
> > >=20
> > > For things that aren't clearly in KVM's domain, I don't think we shou=
ld implement
> > > KVM-specific functionality until every other option has been tried (a=
nd failed).
> > > I don't see any reason why KVM needs to get involved in scheduling, b=
eyond maybe
> > > providing *input* regarding event injection, emphasis on *input* beca=
use KVM
> > > providing information to userspace or some other entity is wildly dif=
ferent than
> > > KVM making scheduling decisions based on that information.
> > >=20
> > > Pushing the scheduling policies to host userspace would allow for far=
 more control
> > > and flexibility.  E.g. a heavily paravirtualized environment where ho=
st userspace
> > > knows *exactly* what workloads are being run could have wildly differ=
ent policies
> > > than an environment where the guest is a fairly vanilla Linux VM that=
 has received
> > > a small amount of enlightment.
> > >=20
> > > Lastly, if the concern/argument is that userspace doesn't have the ri=
ght knobs
> > > to (quickly) boost vCPU tasks, then the proposed sched_ext functional=
ity seems
> > > tailor made for the problems you are trying to solve.
> > >
> > > https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org
> >=20
> > I very much agree. There are some features missing from BPF that we'd
> > need to add to enable this, but they're on the roadmap, and I don't
> > think they'd be especially difficult to implement.
> >=20
> > The main building block that I was considering is a new kptr [0] and set
> > of kfuncs [1] that would allow a BPF program to have one or more R/W
> > shared memory regions with a guest.
>=20
> I really like your ideas around sharing memory across virt boundary using
> BPF. The one concern I would have is that, this does require loading a BPF
> program from the guest userspace, versus just having a guest kernel that
> 'does the right thing'.

Yeah, that's a fair concern. The problem is that I'm not sure how we get
around that if we want to avoid tying up every scheduling paravirt
policy into a KVM UAPI. Putting everything into UAPI just really doesn't
seem scalable. I'd be curious to hear Sean's thoughts on this. Note that
I'm not just talking about scheduling paravirt here -- one could imagine
many possible examples, e.g. relating to I/O, MM, etc.

It seems much more scalable to instead have KVM be responsible for
plumbing mappings between guest and host BPF programs (I haven't thought
through the design or interface for that at _all_, just thinking in
high-level terms here), and then those BPF programs could decide on
paravirt interfaces that don't have to be in UAPI. Having KVM be
responsible for setting up opaque communication channels between the
guest and host feels likes a more natural building block than having it
actually be aware of the policies being implemented over those
communication channels.

> On the host, I would have no problem loading a BPF program as a one-time
> thing, but on the guest it may be more complex as we don't always control=
 the
> guest userspace and their BPF loading mechanisms. Example, an Android gue=
st
> needs to have its userspace modified to load BPF progs, etc. Not hard
> problems, but flexibility comes with more cost. Last I recall, Android do=
es
> not use a lot of the BPF features that come with the libbpf library becau=
se
> they write their own userspace from scratch (due to licensing). OTOH, if =
this
> was an Android kernel-only change, that would simplify a lot.

That is true, but the cost is double-sided. On the one hand, we have the
complexity and maintenance costs of plumbing all of this through KVM and
making it UAPI. On the other, we have the cost of needing to update a
user space framework to accommodate loading and managing BPF programs.
At this point BPF is fully supported on aarch64, so Android should have
everything it needs to use it. It sounds like it will require some
(maybe even a lot of) work to accommodate that, but that seems
preferable to compensating for gaps in a user space framework by adding
complexity to the kernel, no?

> Still there is a lot of merit to sharing memory with BPF and let BPF deci=
de
> the format of the shared memory, than baking it into the kernel... so tha=
nks
> for bringing this up! Lets talk more about it... Oh, and there's my LSFMM=
BPF
> invitiation request ;-) ;-).

Discussing this BPF feature at LSFMMBPF is a great idea -- I'll submit a
proposal for it and cc you. I looked and couldn't seem to find the
thread for your LSFMMBPF proposal. Would you mind please sending a link?

> > This could enable a wide swath of
> > BPF paravirt use cases that are not limited to scheduling, but in terms
> > of sched_ext, the BPF scheduler could communicate with the guest
> > scheduler over this shared memory region in whatever manner was required
> > for that use case.
> >=20
> > [0]: https://lwn.net/Articles/900749/
> > [1]: https://lwn.net/Articles/856005/
>=20
> Thanks, I had no idea about these. I have a question -- would it be possi=
ble
> to call the sched_setscheduler() function in core.c via a kfunc? Then we =
can
> trigger the boost from a BPF program on the host side. We could start sim=
ple
> from there.

There's nothing stopping us from adding a kfunc that calls
sched_setscheduler(). The questions are how other scheduler folks feel
about that, and whether that's the appropriate general solution to the
problem. It does seem odd to me to have a random KVM tracepoint be
entitled to set a generic task's scheduling policy and priority.

> I agree on the rest below. I just wanted to emphasize though that this pa=
tch
> series does not care about what the scheduler does. It merely hints the
> scheduler via a priority setting that something is an important task. Tha=
t's
> a far cry from how to actually schedule and the spirit here is to use
> whatever scheduler the user has to decide how to actually schedule.

Yep, I don't disagree with you at all on that point. To me this really
comes down to a question of the costs and long-term design choices, as
we discussed above:

1. What is the long-term maintenance cost to KVM and the scheduler to
   land paravirt scheduling in this form?

Even assuming that we go with the BPF hook on VMEXIT approach, unless
I'm missing something, I think we'd still need to make UAPI changes to
kvm_para.h, and update the guest to set the relevant paravirt state in
the guest scheduler. That's not a huge amount of code for just boosting
and deboosting, but it sets the precedent that any and all future
scheduling paravirt logic will need to go through UAPI, and that the
core scheduler will need to accommodate that paravirt when and where
appropriate.

I may be being overly pessimistic, but I feel that could open up a
rather scary can of worms; both in terms of the potential long-term
complexity in the kernel itself, and in terms of the maintenance burden
that may eventually be imposed to properly support it. It also imposes a
very high bar on being able to add and experiment with new paravirt
policies.

2. What is the cost we're imposing on users if we force paravirt to be
   done through BPF? Is this prohibitively high?

There is certainly a nonzero cost. As you pointed out, right now Android
apparently doesn't use much BPF, and adding the requisite logic to use
and manage BPF programs is not insigificant.

Is that cost prohibitively high? I would say no. BPF should be fully
supported on aarch64 at this point, so it's really a user space problem.
Managing the system is what user space does best, and many other
ecosystems have managed to integrate BPF to great effect. So while the
cost is cetainly nonzero, I think there's a reasonable argument to be
made that it's not prohibitively high.

Thanks,
David

--c0OHFIbsmEu88mf0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQRBxU1So5MTLwphjdFZ5LhpZcTzZAUCZZcyYgAKCRBZ5LhpZcTz
ZOpeAQC6geniMugfoO1Zve914AJRuT5QVQdbxpBl1N1hLkIjCwD+OfzRHGY1cl4L
arVoWErV13ZSgLs+Zpx/AQbp76d2kwY=
=22n2
-----END PGP SIGNATURE-----

--c0OHFIbsmEu88mf0--

