Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C627B96AF
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 23:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244141AbjJDVuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 17:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244099AbjJDVux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 17:50:53 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428FDC6
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 14:50:48 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-27731a5b94dso216249a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 14:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696456247; x=1697061047; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kiSgfZM7ECGdOQlszNQDUnAmB/N1bBj0T6OcTzs1AbE=;
        b=rCkLhUPDkLNBdANwdb7ts4sZCV+YYhPq4xEDFcDYK9DiAWLG8XZI2fv9av19JKXoUQ
         2TcUTqsqZ2reaYtXaf7h6hX2iGQY1/xrsjMof0cElbubv+T9wgiESlvlV82IG1VXyeFN
         vUVoGupTdOiHQhTL9CD/mcdWiuqFw8yphrkx34E92qi6l3pf4qgZMeDzbMqkTIwlp2DR
         VXYuC1Ypp08F/eLDrpPbFBwpH0v42OP05m8Dh5c/79950fpx6DhQ48y6iOVElyOPdB0U
         VY2n5mA5nUOHGVzyp9OzAOu8ym3/2pv3Amnivtvx5M+kAr+HH5DE/AT/xLMiWLXF6Qjn
         6M+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696456247; x=1697061047;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kiSgfZM7ECGdOQlszNQDUnAmB/N1bBj0T6OcTzs1AbE=;
        b=JjnCE1HE6J0ma9f4e9bhPdYaQ+xo6InM6zPsvw0UI+jUjvoypthLD0digMJ1bifAUR
         EpM1c5fniGznuC1xkShGToZkLNY1siwREpCjszohz58Lo+LaWVcF7kBKopKFFXPoW3Dp
         LWDKcbeH6v+II1Uz78lzCWwL+yt6TpB3hxuB/eEfRhAL/s+i7XOIW+T9yNET5wxYSIe9
         csRng9U93J2xlZdfGcB6L2kv0DIY/OmCM6UlR8WWyDQDc/Z76vxwqVpnIjSqbdh0HiqN
         fT9gF1pFgzkkWEKC9HzHx8yVS5m84HRmobiovtk/FZsNpqiv6+3JR9EBxQg6jin2gEHc
         X20A==
X-Gm-Message-State: AOJu0Yy4o6EsrBcgfle0/V8ERQffO1pLmfC3K8Ne5PBxN/Yrb2yuuXsi
        7/BvWMr/W4qw+ngn12OkybqGR3xc1CM=
X-Google-Smtp-Source: AGHT+IHvX+GcIWTwOfpy+LfFgXqBWlgRQ102fPNel0QDAdjIf8o+RQzBWAS9/U++GVyXjfT6IAXRlyalq8k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:894:b0:277:78c:ae8c with SMTP id
 bj20-20020a17090b089400b00277078cae8cmr57505pjb.6.1696456247624; Wed, 04 Oct
 2023 14:50:47 -0700 (PDT)
Date:   Wed, 4 Oct 2023 14:50:46 -0700
In-Reply-To: <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
Mime-Version: 1.0
References: <ZRbxb15Opa2_AusF@google.com> <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net> <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net> <ZRwx7gcY7x1x3a5y@google.com>
 <20231004112152.GA5947@noisy.programming.kicks-ass.net> <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
Message-ID: <ZR3eNtP5IVAHeFNC@google.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023, Mingwei Zhang wrote:
> On Wed, Oct 4, 2023 at 4:22=E2=80=AFAM Peter Zijlstra <peterz@infradead.o=
rg> wrote:
> > > > Or are you talking about the whole of vcpu_run() ? That seems like =
a
> > > > massive amount of code, and doesn't look like anything I'd call a
> > > > fast-path. Also, much of that loop has preemption enabled...
> > >
> > > The whole of vcpu_run().  And yes, much of it runs with preemption en=
abled.  KVM
> > > uses preempt notifiers to context switch state if the vCPU task is sc=
heduled
> > > out/in, we'd use those hooks to swap PMU state.
> > >
> > > Jumping back to the exception analogy, not all exits are equal.  For =
"simple" exits
> > > that KVM can handle internally, the roundtrip is <1500.   The exit_fa=
stpath loop is
> > > roughly half that.
> > >
> > > But for exits that are more complex, e.g. if the guest hits the equiv=
alent of a
> > > page fault, the cost of handling the page fault can vary significantl=
y.  It might
> > > be <1500, but it might also be 10x that if handling the page fault re=
quires faulting
> > > in a new page in the host.
> > >
> > > We don't want to get too aggressive with moving stuff into the exit_f=
astpath loop,
> > > because doing too much work with IRQs disabled can cause latency prob=
lems for the
> > > host.  This isn't much of a concern for slice-of-hardware setups, but=
 would be
> > > quite problematic for other use cases.
> > >
> > > And except for obviously slow paths (from the guest's perspective), e=
xtra latency
> > > on any exit can be problematic.  E.g. even if we got to the point whe=
re KVM handles
> > > 99% of exits the fastpath (may or may not be feasible), a not-fastpat=
h exit at an
> > > inopportune time could throw off the guest's profiling results, intro=
duce unacceptable
> > > jitter, etc.
> >
> > I'm confused... the PMU must not be running after vm-exit. It must not
> > be able to profile the host. So what jitter are you talking about?
> >
> > Even if we persist the MSR contents, the PMU itself must be disabled on
> > vm-exit and enabled on vm-enter. If not by hardware then by software
> > poking at the global ctrl msr.
> >
> > I also don't buy the latency argument, we already do full and complete
> > PMU rewrites with IRQs disabled in the context switch path. And as
> > mentioned elsewhere, the whole AMX thing has an 8k copy stuck in the FP=
U
> > save/restore.
> >
> > I would much prefer we keep the PMU swizzle inside the IRQ disabled
> > region of vcpu_enter_guest(). That's already a ton better than you have
> > today.

...

> Peter, that latency argument in pass-through implementation is
> something that we hope you could buy. This should be relatively easy
> to prove. I can provide some data if you need.

You and Peter are talking about is two different latencies.  Or rather, how=
 the
latency impacts two different things.

Peter is talking about is the latency impact on the host, specifically how =
much
work is done with IRQs disabled.

You are talking about is the latency impact on the guest, i.e. how much gue=
st
performance is affected if KVM swaps MSRs on every exit.=20

Peter is contending that swapping PMU MSRs with IRQs disabled isn't a big d=
eal,
because the kernel already does as much during a context switch.  I agree, =
*if*
we're talking about only adding the PMU MSRs.

You (and I) are contending that the latency impact on the guest will be too=
 high
if KVM swaps in the inner VM-Exit loop.  This is not analogous to host cont=
ext
switches, as VM-Exits can occur at a much higher frequency than context swi=
tches,
and can be triggered by events that have nothing to do with the guest.

There's some confusion here though because of what I said earlier:

  We don't want to get too aggressive with moving stuff into the exit_fastp=
ath
  loop, because doing too much work with IRQs disabled can cause latency pr=
oblems
  for the host.=20

By "stuff" I wasn't talking about PMU MSRs, I was referring to all exit han=
dling
that KVM *could* move into the IRQs disabled section in order to mitigate t=
he
concerns that we have about the latency impacts on the guest.  E.g. if most=
 exits
are handled in the IRQs disabled section, then KVM could handle most exits =
without
swapping PMU state and thus limit the impact on guest performance, and not =
cause
to much host perf "downtime" that I mentioned in the other thread[*].

However, my concern is that handling most exits with IRQs disabled would re=
sult
in KVM doing too much work with IRQs disabled, i.e. would impact the host l=
atency
that Peter is talking about.  And I'm more than a bit terrified of calling =
into
code that doesn't expect to be called with IRQs disabled.

Thinking about this more, what if we do a blend of KVM's FPU swapping and d=
ebug
register swapping?

  A. Load guest PMU state in vcpu_enter_guest() after IRQs are disabled
  B. Put guest PMU state (and load host state) in vcpu_enter_guest() before=
 IRQs
     are enabled, *if and only if* the current CPU has one or perf events t=
hat
     wants to use the hardware PMU
  C. Put guest PMU state at vcpu_put()
  D. Add a perf callback that is invoked from IRQ context when perf wants t=
o
     configure a new PMU-based events, *before* actually programming the MS=
Rs,
     and have KVM's callback put the guest PMU state

If there are host perf events that want to use the PMU, then KVM will swap =
fairly
aggressively and the "downtime" of the host perf events will be limited to =
the
small window around VM-Enter/VM-Exit.

If there are no such host events, KVM will swap on the first entry to the g=
uest,
and keep the guest PMU loaded until the vCPU is put.

The perf callback in (D) would allow perf to program system-wide events on =
all
CPUs without clobbering guest PMU state.

I think that would make everyone happy.  As long as our hosts don't create =
perf
events, then we get the "swap as little as possible" behavior without signi=
ficantly
impacting the host's ability to utilize perf.  If our host screws up and cr=
eates
perf events on CPUs that are running vCPUs, then the degraded vCPU performa=
nce is
on us.

Rough sketch below, minus the perf callback or any of actual swapping logic=
.

[*] https://lore.kernel.org/all/ZR3Ohk50rSofAnSL@google.com

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7d9ba301c090..86699d310224 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -41,6 +41,30 @@ struct kvm_pmu_ops {
=20
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
=20
+static inline void kvm_load_guest_pmu(struct kvm_vcpu *vcpu)
+{
+       struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
+
+       lockdep_assert_irqs_disabled();
+
+       if (vcpu->pmu->guest_state_loaded)
+               return;
+
+       <swap state>
+       vcpu->pmu->guest_state_loaded =3D true;
+}
+
+static inline void kvm_put_guest_pmu(struct kvm_vcpu *vcpu)
+{
+       lockdep_assert_irqs_disabled();
+
+       if (!vcpu->pmu->guest_state_loaded)
+               return;
+
+       <swap state>
+       vcpu->pmu->guest_state_loaded =3D false;
+}
+
 static inline bool kvm_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 {
        /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1e645f5b1e2c..93a8f268c37b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4903,8 +4903,20 @@ static void kvm_steal_time_set_preempted(struct kvm_=
vcpu *vcpu)
=20
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+       unsigned long flags;
        int idx;
=20
+       /*
+        * This can get false positives, but not false negatives, i.e. KVM =
will
+        * never fail to put the PMU, but may unnecessarily disable IRQs to
+        * safely check if the PMU is still loaded.
+        */
+       if (kvm_is_guest_pmu_loaded(vcpu)) {
+               local_irq_save(flags);
+               kvm_put_guest_pmu(vcpu);
+               local_irq_restore(flags);
+       }
+
        if (vcpu->preempted) {
                if (!vcpu->arch.guest_state_protected)
                        vcpu->arch.preempted_in_kernel =3D !static_call(kvm=
_x86_get_cpl)(vcpu);
@@ -10759,6 +10771,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
                set_debugreg(0, 7);
        }
=20
+       kvm_load_guest_pmu(vcpu);
+
        guest_timing_enter_irqoff();
=20
        for (;;) {
@@ -10810,6 +10824,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
        if (hw_breakpoint_active())
                hw_breakpoint_restore();
=20
+       if (perf_has_hw_events())
+               kvm_put_guest_pmu(vcpu);
+
        vcpu->arch.last_vmentry_cpu =3D vcpu->cpu;
        vcpu->arch.last_guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
=20

