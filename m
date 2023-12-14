Return-Path: <kvm+bounces-4533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B90813AB4
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 20:25:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC44F1C209BF
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 19:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1411B6979C;
	Thu, 14 Dec 2023 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="VdVhvKO9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B69969790
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 19:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1fb9a22b4a7so5066387fac.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 11:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702581911; x=1703186711; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JwXVK8YsyVLmc2yBDAeX97qZitBh++UFD7dC4Hziebg=;
        b=VdVhvKO9sctnKqXHSz4/ySoIAzpe89B8c9/M5uFEyb8+5Zy08RtvxGWrGbywfYd4QJ
         UaNLm/ROlt6A7hVWfNobsPDT6uGp/wrnonCwBN+pedVbnAyzFcwcZ17cUM/4fSKBGPOt
         xE8HC9uDjNG2+Wm3e9BbmeFXmmD17i3ByvShds1GlAl4QIhmRKb6NsNBVmRCdrAva5We
         a09Xlz47RGKxvDkaIHC8rOEY/jmixYYKY0VWFhcUA5afKR5HK7uY4rgsrfD2cZNgY+G8
         mL1ejFUh8S3mZyTleMHM7U0Wo4l0HcPVOAzX0DR99pLtYNH8t/cRP1ELKKn0sKR1sJBB
         E8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702581911; x=1703186711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JwXVK8YsyVLmc2yBDAeX97qZitBh++UFD7dC4Hziebg=;
        b=RE6+enlIsN7zBxVC7cSDYBvZ75Wh0lEf691yi+b1ZIicPWNQLlUYt3VuNl63iUaP/Z
         09llwI9IKPdJDua8izLEDQxpW+8Tkxo/5qfihe32wQsMhiIQ+Ryz2LQg6Arw99BKCyKW
         ltu4vnLD+C2vYJEWRdIb3ZVx4Edx3dJNgBVWOgSOxI0XgB03AvxZ+SKzbgauslOUaO/r
         ajayD5O1UXoUfbuQsB8016ZKz9jVH1gSmHUb8Yd4W2vmgprKZqS/6ZuH6NnlUvD182NR
         T3bMUVa2vSHiyqtmzFkoKd7IsFRac7p0Aa2dccbyVmBX8Zyaoq1fID17+h1Cqs/Yy3hG
         Oygw==
X-Gm-Message-State: AOJu0Yygq7HzhtQ4EUc7NbyA+dylD7bkczMV1XGIgM/v1wKqoDuuncN2
	AdtMxk1QXKrM26lXNA788Q4b46RHWN6gMy2+F1MGcg==
X-Google-Smtp-Source: AGHT+IH3G1TwNH1i/u30wxM0ViP2JcHCzdgBU1KULniy/qBA6V05JFTRAJqrED3PWzIUkv3l1XZDc4QGM8133tI0sTw=
X-Received: by 2002:a05:6870:7013:b0:203:40a0:b786 with SMTP id
 u19-20020a056870701300b0020340a0b786mr2122394oae.63.1702581910907; Thu, 14
 Dec 2023 11:25:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org> <ZXsvl7mabUuNkWcY@google.com>
In-Reply-To: <ZXsvl7mabUuNkWcY@google.com>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Thu, 14 Dec 2023 14:25:00 -0500
Message-ID: <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
To: Sean Christopherson <seanjc@google.com>
Cc: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, David Vernet <dvernet@meta.com>, 
	Joel Fernandes <joel@joelfernandes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 11:38=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> +sched_ext folks
>
> On Wed, Dec 13, 2023, Vineeth Pillai (Google) wrote:
> > Double scheduling is a concern with virtualization hosts where the host
> > schedules vcpus without knowing whats run by the vcpu and guest schedul=
es
> > tasks without knowing where the vcpu is physically running. This causes
> > issues related to latencies, power consumption, resource utilization
> > etc. An ideal solution would be to have a cooperative scheduling
> > framework where the guest and host shares scheduling related informatio=
n
> > and makes an educated scheduling decision to optimally handle the
> > workloads. As a first step, we are taking a stab at reducing latencies
> > for latency sensitive workloads in the guest.
> >
> > This series of patches aims to implement a framework for dynamically
> > managing the priority of vcpu threads based on the needs of the workloa=
d
> > running on the vcpu. Latency sensitive workloads (nmi, irq, softirq,
> > critcal sections, RT tasks etc) will get a boost from the host so as to
> > minimize the latency.
> >
> > The host can proactively boost the vcpu threads when it has enough
> > information about what is going to run on the vcpu - fo eg: injecting
> > interrupts. For rest of the case, guest can request boost if the vcpu i=
s
> > not already boosted. The guest can subsequently request unboost after
> > the latency sensitive workloads completes. Guest can also request a
> > boost if needed.
> >
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
>
> Big thumbs down on my end.  Nothing in this RFC explains why this should =
be done
> in KVM.  In general, I am very opposed to putting policy of any kind into=
 KVM,
> and this puts a _lot_ of unmaintainable policy into KVM by deciding when =
to
> start/stop boosting a vCPU.
>
I am sorry for not clearly explaining the goal. The intent was not to
have scheduling policies implemented in kvm, but to have a mechanism
for guest and host schedulers to communicate so that guest workloads
get a fair treatment from host scheduler while competing with host
workloads. Now when I think about it, the implementation seems to
suggest that we are putting policies in kvm. Ideally, the goal is:
- guest scheduler communicates the priority requirements of the workload
- kvm applies the priority to the vcpu task.
- Now that vcpu is appropriately prioritized, host scheduler can make
the right choice of picking the next best task.

We have an exception of proactive boosting for interrupts/nmis. I
don't expect these proactive boosting cases to grow. And I think this
also to be controlled by the guest where the guest can say what
scenarios would it like to be proactive boosted.

That would make kvm just a medium to communicate the scheduler
requirements from guest to host and not house any policies.  What do
you think?

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
> visibility into the guest effectively decreases, e.g. Intel and AMD both =
support
> with IPI virtualization.
>
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
>
> Initiating a boost from the host is also flawed in the sense that it reli=
es on
> the guest to be on the same page as to when it should stop boosting.  E.g=
. if
> KVM boosts a vCPU because an IRQ is pending, but the guest doesn't want t=
o boost
> IRQs on that vCPU and thus doesn't stop boosting at the end of the IRQ ha=
ndler,
> then the vCPU could end up being boosted long after its done with the IRQ=
.
>
> Throw nested virtualization into the mix and then all of this becomes nig=
h
> impossible to sort out in KVM.  E.g. if an L1 vCPU is a running an L2 vCP=
U, i.e.
> a nested guest, and L2 is spamming interrupts for whatever reason, KVM wi=
ll end
> repeatedly boosting the L1 vCPU regardless of the priority of the L2 work=
load.
>
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
>
Agreed with all the points above and it doesn't make sense to have
policies in kvm. But if kvm can act as a medium to communicate
scheduling requirements between guest and host and not make any
decisions, would that be more reasonable?

> Pushing the scheduling policies to host userspace would allow for far mor=
e control
> and flexibility.  E.g. a heavily paravirtualized environment where host u=
serspace
> knows *exactly* what workloads are being run could have wildly different =
policies
> than an environment where the guest is a fairly vanilla Linux VM that has=
 received
> a small amount of enlightment.
>
> Lastly, if the concern/argument is that userspace doesn't have the right =
knobs
> to (quickly) boost vCPU tasks, then the proposed sched_ext functionality =
seems
> tailor made for the problems you are trying to solve.
>
> https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org
>
You are right, sched_ext is a good choice to have policies
implemented. In our case, we would need a communication mechanism as
well and hence we thought kvm would work best to be a medium between
the guest and the host. The policies could be in the guest and the
guest shall communicate its priority requirements(based on policy) to
the host via kvm and then the host scheduler takes action based on
that.

Please let me know.

Thanks,
Vineeth

