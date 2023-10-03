Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBAF7B70B8
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 20:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbjJCSWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 14:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjJCSWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 14:22:07 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4B7E1
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 11:22:04 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-536ef8a7dcdso1887a12.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 11:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696357322; x=1696962122; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZzDVAIPhXLJ6H1shwPpB3BGM89tyFHmwziem7st5rSo=;
        b=TgVhFHcFAduEbhIum9Mp4yAbeKnTaqN4to1/9vWoiU85/AG++ekR/SqCACPdYBZZBe
         304e98qF99dBS6pdFjycQVlnqHUP5i5cQgxQ5h0UfzrM233mUwSC8NCvdgCTEB/OsQE4
         bn1xgaG+ocl7/0nb9Y8+oWfVd4oeEcTzoMMClpI9SRGp/myD5SWvPMpJzpBJM7vVSBid
         mXiQWAlBpPxBvhfbcHIv1X7XiukZI/9zgz4CmhA6wm0CY3yWh0fFUHG0DvK28ly8GbXl
         CHIpmfb98TEboBicU1UYQBNMFxgfCSeKZD+NCSFYujjqea1Bo3rvikmodXSe81w9yPd9
         LU/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696357322; x=1696962122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzDVAIPhXLJ6H1shwPpB3BGM89tyFHmwziem7st5rSo=;
        b=bGXcbB8KpTZu44RXENPXo7HQyehsD54ijQ0CV0tHjFYgsswQJnrEhPxA27tndMrrYa
         64H5wcNyW63OrYllotCBiVRcc4bggfZLmq6WAsmA9+tk//Hjrt3vGbE2p4q396khQKmp
         98Y5VuhD7rh5NGupltJjEiOElY32OeznModMs0pM+GBHfrebh6WK2PhSVPjGrLd3B9Db
         J8A43bgWKklUNn9YAaao8qUmtVk4xZflIhnW8YgRb+WRLgCT5SqQ1tRXbdmQQQ1xKN1b
         biaCi6KfDjg2mtI03F3UafW/iuE+QNZIzY72fh2PAXXwsucBWo7r7pOGS8B6USfHF/Rl
         1KIw==
X-Gm-Message-State: AOJu0YyByMXcSUzDAWtdcy9TMsKI6txir5S1B7o5DAjgaFUtr9MNXa4s
        R09SL401SsdHVPIL+YJKAhC7LwVf7PwUGe9TyKVlcw==
X-Google-Smtp-Source: AGHT+IGb9CYZGu8cbBF7awQbfHN/Mx0+nZAGWzRoDR4sTfbQfyrrJAptct4IAx1conqsVl07uBYIRMys1qmt5L/H62U=
X-Received: by 2002:a50:d61e:0:b0:519:7d2:e256 with SMTP id
 x30-20020a50d61e000000b0051907d2e256mr10452edi.0.1696357322423; Tue, 03 Oct
 2023 11:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com> <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net> <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net> <ZRwx7gcY7x1x3a5y@google.com>
In-Reply-To: <ZRwx7gcY7x1x3a5y@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 3 Oct 2023 11:21:46 -0700
Message-ID: <CALMp9eRew1+-gDy36m3qWy9D9TQP+mkzPQg=xowKcaG+NpbX0w@mail.gmail.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
To:     Sean Christopherson <seanjc@google.com>
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
        David Dunn <daviddunn@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 3, 2023 at 8:23=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Oct 03, 2023, Peter Zijlstra wrote:
> > On Mon, Oct 02, 2023 at 05:56:28PM -0700, Sean Christopherson wrote:
> > > On Mon, Oct 02, 2023, Peter Zijlstra wrote:
> >
> > > > I'm not sure what you're suggesting here. It will have to save/rest=
ore
> > > > all those MSRs anyway. Suppose it switches between vCPUs.
> > >
> > > The "when" is what's important.   If KVM took a literal interpretatio=
n of
> > > "exclude guest" for pass-through MSRs, then KVM would context switch =
all those
> > > MSRs twice for every VM-Exit=3D>VM-Enter roundtrip, even when the VM-=
Exit isn't a
> > > reschedule IRQ to schedule in a different task (or vCPU).  The overhe=
ad to save
> > > all the host/guest MSRs and load all of the guest/host MSRs *twice* f=
or every
> > > VM-Exit would be a non-starter.  E.g. simple VM-Exits are completely =
handled in
> > > <1500 cycles, and "fastpath" exits are something like half that.  Swi=
tching all
> > > the MSRs is likely 1000+ cycles, if not double that.
> >
> > See, you're the virt-nerd and I'm sure you know what you're talking
> > about, but I have no clue :-) I didn't know there were different levels
> > of vm-exit.
>
> An exit is essentially a fancy exception/event.  The hardware transition =
from
> guest=3D>host is the exception itself (VM-Exit), and the transition back =
to guest
> is analagous to the IRET (VM-Enter).
>
> In between, software will do some amount of work, and the amount of work =
that is
> done can vary quite significantly depending on what caused the exit.
>
> > > FWIW, the primary use case we care about is for slice-of-hardware VMs=
, where each
> > > vCPU is pinned 1:1 with a host pCPU.
> >
> > I've been given to understand that vm-exit is a bad word in this
> > scenario, any exit is a fail. They get MWAIT and all the other crap and
> > more or less pretend to be real hardware.
> >
> > So why do you care about those MSRs so much? That should 'never' happen
> > in this scenario.
>
> It's not feasible to completely avoid exits, as current/upcoming hardware=
 doesn't
> (yet) virtualize a few important things.  Off the top of my head, the two=
 most
> relevant flows are:
>
>   - APIC_LVTPC entry and PMU counters.  If a PMU counter overflows, the N=
MI that
>     is generated will trigger a hardware level NMI and cause an exit.  An=
d sadly,
>     the guest's NMI handler (assuming the guest is also using NMIs for PM=
Is) will
>     trigger another exit when it clears the mask bit in its LVTPC entry.

In addition, when the guest PMI handler writes to
IA32_PERF_GLOBAL_CTRL to disable all counters (and again later to
re-enable the counters), KVM has to intercept that as well, with
today's implementation. Similarly, on each guest timer tick, when
guest perf is multiplexing PMCs, KVM has to intercept writes to
IA32_PERF_GLOBAL _CTRL.

Furthermore, in some cases, Linux perf seems to double-disable
counters, using both the individual enable bits in each PerfEvtSel, as
well as the bits in PERF_GLOBAL_CTRL.  KVM has to intercept writes to
the PerfEvtSels as well. Off-topic, but I'd like to request that Linux
perf *only* use the enable  bits in IA32_PERF_GLOBAL_CTRL on
architectures where that is supported. Just leave the enable bits set
in the PrfEvtSels, to avoid unnecessary VM-exits. :)

>   - Timer related IRQs, both in the guest and host.  These are the bigges=
t source
>     of exits on modern hardware.  Neither AMD nor Intel provide a virtual=
 APIC
>     timer, and so KVM must trap and emulate writes to TSC_DEADLINE (or to=
 APIC_TMICT),
>     and the subsequent IRQ will also cause an exit.
>
> The cumulative cost of all exits is important, but the latency of each in=
dividual
> exit is even more critical, especially for PMU related stuff.  E.g. if th=
e guest
> is trying to use perf/PMU to profile a workload, adding a few thousand cy=
cles to
> each exit will introduce too much noise into the results.
>
> > > > > Or at least, that was my reading of things.  Maybe it was just a
> > > > > misunderstanding because we didn't do a good job of defining the =
behavior.
> > > >
> > > > This might be the case. I don't particularly care where the guest
> > > > boundary lies -- somewhere in the vCPU thread. Once the thread is g=
one,
> > > > PMU is usable again etc..
> > >
> > > Well drat, that there would have saved a wee bit of frustration.  Bet=
ter late
> > > than never though, that's for sure.
> > >
> > > Just to double confirm: keeping guest PMU state loaded until the vCPU=
 is scheduled
> > > out or KVM exits to userspace, would mean that host perf events won't=
 be active
> > > for potentially large swaths of non-KVM code.  Any function calls or =
event/exception
> > > handlers that occur within the context of ioctl(KVM_RUN) would run wi=
th host
> > > perf events disabled.
> >
> > Hurmph, that sounds sub-optimal, earlier you said <1500 cycles, this al=
l
> > sounds like a ton more.
> >
> > /me frobs around the kvm code some...
> >
> > Are we talking about exit_fastpath loop in vcpu_enter_guest() ? That
> > seems to run with IRQs disabled, so at most you can trigger a #PF or
> > something, which will then trip an exception fixup because you can't ru=
n
> > #PF with IRQs disabled etc..
> >
> > That seems fine. That is, a theoretical kvm_x86_handle_enter_irqoff()
> > coupled with the existing kvm_x86_handle_exit_irqoff() seems like
> > reasonable solution from where I'm sitting. That also more or less
> > matches the FPU state save/restore AFAICT.
> >
> > Or are you talking about the whole of vcpu_run() ? That seems like a
> > massive amount of code, and doesn't look like anything I'd call a
> > fast-path. Also, much of that loop has preemption enabled...
>
> The whole of vcpu_run().  And yes, much of it runs with preemption enable=
d.  KVM
> uses preempt notifiers to context switch state if the vCPU task is schedu=
led
> out/in, we'd use those hooks to swap PMU state.
>
> Jumping back to the exception analogy, not all exits are equal.  For "sim=
ple" exits
> that KVM can handle internally, the roundtrip is <1500.   The exit_fastpa=
th loop is
> roughly half that.
>
> But for exits that are more complex, e.g. if the guest hits the equivalen=
t of a
> page fault, the cost of handling the page fault can vary significantly.  =
It might
> be <1500, but it might also be 10x that if handling the page fault requir=
es faulting
> in a new page in the host.
>
> We don't want to get too aggressive with moving stuff into the exit_fastp=
ath loop,
> because doing too much work with IRQs disabled can cause latency problems=
 for the
> host.  This isn't much of a concern for slice-of-hardware setups, but wou=
ld be
> quite problematic for other use cases.
>
> And except for obviously slow paths (from the guest's perspective), extra=
 latency
> on any exit can be problematic.  E.g. even if we got to the point where K=
VM handles
> 99% of exits the fastpath (may or may not be feasible), a not-fastpath ex=
it at an
> inopportune time could throw off the guest's profiling results, introduce=
 unacceptable
> jitter, etc.
>
> > > Are you ok with that approach?  Assuming we don't completely botch th=
ings, the
> > > interfaces are sane, we can come up with a clean solution for handlin=
g NMIs, etc.
> >
> > Since you steal the whole PMU, can't you re-route the PMI to something
> > that's virt friendly too?
>
> Hmm, actually, we probably could.  It would require modifying the host's =
APIC_LVTPC
> entry when context switching the PMU, e.g. to replace the NMI with a dedi=
cated IRQ
> vector.  As gross as that sounds, it might actually be cleaner overall th=
an
> deciphering whether an NMI belongs to the host or guest, and it would alm=
ost
> certainly yield lower latency for guest PMIs.

Ugh.  Can't KVM just install its own NMI handler? Either way, it's
possible for late PMIs to arrive in the wrong context.
