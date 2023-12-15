Return-Path: <kvm+bounces-4587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6747E814F80
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 19:10:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D05E61F23F2C
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 18:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2744A41868;
	Fri, 15 Dec 2023 18:10:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78657405FF;
	Fri, 15 Dec 2023 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=manifault.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-77f42ee9370so63432485a.2;
        Fri, 15 Dec 2023 10:10:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702663819; x=1703268619;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H1zqirXTVa12/6H82R2b8lUo2qSAjH5NjhR9uP4Mqk4=;
        b=uBRq/a70Gw9AxnxqEyFoe43HPp9ZqWd9NbAVUTsN7+lxrpBf7dnWGRuPOIfXg2eoMn
         EcazhnMVb1kMvM1yg5R0gRQpYQpSuihLl3Vp9FGLEF2BubulO/3F+IDwBqIqmCw+EMN1
         94rxX1PWosww8zMxTXSuc/ksmXVQ9vcnaF7j0kkaijHXux7QQm9h26gvsyTlTbbkYrfL
         BlkMAdu73j7Y0eb1JebTW5w9nHantPlNRWZznQpNMyJpULyoIbmeTivLWcSYXNZB7PUv
         dGpwypLTrjLpQwXbNpcK/ibDAwHXMIM9Hacdl41m/zHHXpkyB23eluCeBkm8/t69aAWr
         SAfw==
X-Gm-Message-State: AOJu0Ywwat9mKA+rZiX9ztvz8MaD9dsORgingMLhz6zh096i4u33l/RP
	6x8b/0Drdr+NR4Ip9I/bylc=
X-Google-Smtp-Source: AGHT+IFDag/H8j+phtDZ/rid8lizokP7FCIkdyNmVUopSrNwl8b5GnrNB7Z8BsAGaO+59B8WakCW5Q==
X-Received: by 2002:a37:e218:0:b0:77e:fba4:3a14 with SMTP id g24-20020a37e218000000b0077efba43a14mr13697816qki.106.1702663819227;
        Fri, 15 Dec 2023 10:10:19 -0800 (PST)
Received: from maniforge (c-24-1-27-177.hsd1.il.comcast.net. [24.1.27.177])
        by smtp.gmail.com with ESMTPSA id qt6-20020a05620a8a0600b0077d8622ee6csm6268427qkn.81.2023.12.15.10.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 10:10:18 -0800 (PST)
Date: Fri, 15 Dec 2023 12:10:14 -0600
From: David Vernet <void@manifault.com>
To: Sean Christopherson <seanjc@google.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
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
	jean-pierre.lozi@inria.fr, ast@kernel.org
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
Message-ID: <20231215181014.GB2853@maniforge>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Rpw1utlia7Ob6CNM"
Content-Disposition: inline
In-Reply-To: <ZXsvl7mabUuNkWcY@google.com>
User-Agent: Mutt/2.2.12 (2023-09-09)


--Rpw1utlia7Ob6CNM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 08:38:47AM -0800, Sean Christopherson wrote:
> +sched_ext folks

Thanks for the cc.

>=20
> On Wed, Dec 13, 2023, Vineeth Pillai (Google) wrote:
> > Double scheduling is a concern with virtualization hosts where the host
> > schedules vcpus without knowing whats run by the vcpu and guest schedul=
es
> > tasks without knowing where the vcpu is physically running. This causes
> > issues related to latencies, power consumption, resource utilization
> > etc. An ideal solution would be to have a cooperative scheduling
> > framework where the guest and host shares scheduling related information
> > and makes an educated scheduling decision to optimally handle the
> > workloads. As a first step, we are taking a stab at reducing latencies
> > for latency sensitive workloads in the guest.
> >=20
> > This series of patches aims to implement a framework for dynamically
> > managing the priority of vcpu threads based on the needs of the workload
> > running on the vcpu. Latency sensitive workloads (nmi, irq, softirq,
> > critcal sections, RT tasks etc) will get a boost from the host so as to
> > minimize the latency.
> >=20
> > The host can proactively boost the vcpu threads when it has enough
> > information about what is going to run on the vcpu - fo eg: injecting
> > interrupts. For rest of the case, guest can request boost if the vcpu is
> > not already boosted. The guest can subsequently request unboost after
> > the latency sensitive workloads completes. Guest can also request a
> > boost if needed.
> >=20
> > A shared memory region is used to communicate the scheduling informatio=
n.
> > Guest shares its needs for priority boosting and host shares the boosti=
ng
> > status of the vcpu. Guest sets a flag when it needs a boost and continu=
es
> > running. Host reads this on next VMEXIT and boosts the vcpu thread. For
> > unboosting, it is done synchronously so that host workloads can fairly
> > compete with guests when guest is not running any latency sensitive
> > workload.
>=20
> Big thumbs down on my end.  Nothing in this RFC explains why this should =
be done
> in KVM.  In general, I am very opposed to putting policy of any kind into=
 KVM,
> and this puts a _lot_ of unmaintainable policy into KVM by deciding when =
to
> start/stop boosting a vCPU.

I have to agree, not least of which is because in addition to imposing a
severe maintenance tax, these policies are far from exhaustive in terms
of what you may want to do for cooperative paravirt scheduling. I think
something like sched_ext would give you the best of all worlds: no
maintenance burden on the KVM maintainers, more options for implementing
various types of policies, performant, safe to run on the host, no need
to reboot when trying a new policy, etc. More on this below.

> Concretely, boosting vCPUs for most events is far too coarse grained.  E.=
g. boosting
> a vCPU that is running a low priority workload just because the vCPU trig=
gered
> an NMI due to PMU counter overflow doesn't make sense.  Ditto for if a gu=
est's
> hrtimer expires on a vCPU running a low priority workload.
>
> And as evidenced by patch 8/8, boosting vCPUs based on when an event is _=
pending_
> is not maintainable.  As hardware virtualizes more and more functionality=
, KVM's
> visilibity into the guest effectively decreases, e.g. Intel and AMD both =
support
> with IPI virtualization.
>=20
> Boosting the target of a PV spinlock kick is similarly flawed.  In that c=
ase, KVM
> only gets involved _after_ there is a problem, i.e. after a lock is conte=
nded so
> heavily that a vCPU stops spinning and instead decided to HLT.  It's not =
hard to
> imagine scenarios where a guest would want to communicate to the host tha=
t it's
> acquiring a spinlock for a latency sensitive path and so shouldn't be sch=
eduled
> out.  And of course that's predicated on the assumption that all vCPUs ar=
e subject
> to CPU overcommit.
>=20
> Initiating a boost from the host is also flawed in the sense that it reli=
es on
> the guest to be on the same page as to when it should stop boosting.  E.g=
=2E if
> KVM boosts a vCPU because an IRQ is pending, but the guest doesn't want t=
o boost
> IRQs on that vCPU and thus doesn't stop boosting at the end of the IRQ ha=
ndler,
> then the vCPU could end up being boosted long after its done with the IRQ.
>=20
> Throw nested virtualization into the mix and then all of this becomes nigh
> impossible to sort out in KVM.  E.g. if an L1 vCPU is a running an L2 vCP=
U, i.e.
> a nested guest, and L2 is spamming interrupts for whatever reason, KVM wi=
ll end
> repeatedly boosting the L1 vCPU regardless of the priority of the L2 work=
load.
>=20
> For things that aren't clearly in KVM's domain, I don't think we should i=
mplement
> KVM-specific functionality until every other option has been tried (and f=
ailed).
> I don't see any reason why KVM needs to get involved in scheduling, beyon=
d maybe
> providing *input* regarding event injection, emphasis on *input* because =
KVM
> providing information to userspace or some other entity is wildly differe=
nt than
> KVM making scheduling decisions based on that information.
>=20
> Pushing the scheduling policies to host userspace would allow for far mor=
e control
> and flexibility.  E.g. a heavily paravirtualized environment where host u=
serspace
> knows *exactly* what workloads are being run could have wildly different =
policies
> than an environment where the guest is a fairly vanilla Linux VM that has=
 received
> a small amount of enlightment.
>=20
> Lastly, if the concern/argument is that userspace doesn't have the right =
knobs
> to (quickly) boost vCPU tasks, then the proposed sched_ext functionality =
seems
> tailor made for the problems you are trying to solve.
>
> https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org

I very much agree. There are some features missing from BPF that we'd
need to add to enable this, but they're on the roadmap, and I don't
think they'd be especially difficult to implement.

The main building block that I was considering is a new kptr [0] and set
of kfuncs [1] that would allow a BPF program to have one or more R/W
shared memory regions with a guest. This could enable a wide swath of
BPF paravirt use cases that are not limited to scheduling, but in terms
of sched_ext, the BPF scheduler could communicate with the guest
scheduler over this shared memory region in whatever manner was required
for that use case.

[0]: https://lwn.net/Articles/900749/
[1]: https://lwn.net/Articles/856005/

For example, the guest could communicate scheduling intention such as:

- "Don't preempt me and/or boost me (because I'm holding a spinlock, in an
  NMI region, running some low-latency task, etc)".
- "VCPU x prefers to be on a P core", and then later, "Now it prefers an
  E core". Note that this doesn't require pinning or anything like that.
  It's just the VCPU requesting some best-effort placement, and allowing
  that policy to change dynamically depending on what the guest is
  doing.
- "Try to give these VCPUs their own fully idle cores if possible, but
  these other VCPUs should ideally be run as hypertwins as they're
  expected to have good cache locality", etc.

In general, some of these policies might be silly and not work well,
others might work very well for some workloads / architectures and not
as well on others, etc. sched_ext would make it easy to try things out
and see what works well, without having to worry about rebooting or
crashing the host, and ultimately without having to implement and
maintain some scheduling policy directly in KVM. As Sean said, the host
knows exactly what workloads are being run and could have very targeted
and bespoke policies that wouldn't be appropriate for a vanilla Linux
VM.

Finally, while it's not necessarily related to paravirt scheduling
specifically, I think it's maybe worth mentioning that sched_ext would
have allowed us to implement a core-sched-like policy when L1TF first
hit us. It was inevitable that we'd need a core-sched policy build into
the core kernel as well, but we could have used sched_ext as a solution
until core sched was merged. Tejun implemented something similar in an
example scheduler where only tasks in the same cgroup are ever allowed
to run as hypertwins [3]. The point is, you can do basically anything
you want with sched_ext. For paravirt, I think there are a ton of
interesting possibilities, and I think those possibilities are better
explored and implemented with sched_ext rather than implementing
policies directly in KVM.

[3]: https://lore.kernel.org/lkml/20231111024835.2164816-27-tj@kernel.org/

--Rpw1utlia7Ob6CNM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQRBxU1So5MTLwphjdFZ5LhpZcTzZAUCZXyWhQAKCRBZ5LhpZcTz
ZFVUAQD3XUPclbBsH9uENyL7MKc5Muk1mRQ/bnZe9dtn1ln3DAD+LuHMpeE0QXXi
EOqGN2b24F3/mYhswdXW+5Di4GutzQM=
=dfLq
-----END PGP SIGNATURE-----

--Rpw1utlia7Ob6CNM--

