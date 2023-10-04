Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B447B8DAD
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 21:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243857AbjJDTwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 15:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbjJDTwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 15:52:21 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B69AD
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 12:52:16 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-65cff6a6878so847276d6.1
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 12:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696449135; x=1697053935; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gZi2ZOT0/NwNNMK0bLNpJXByeH26vbZhIwZdTT4NO8=;
        b=3M0L3PIYrMzUqHkxWsOQwpQ+upp/YX0EgqX61tQLtTHsovZv3+KnVcBI74h00zmAUn
         MR1TDO6zEhnbrNKhLSC4k8DZZRNQw8i5s7zpP4mx5g7A4Jrai6VcB+Z5fdkFS4Re6Re4
         bX4OPebVkLG/TZPf+8/ii+EaZVUBEalbiJqNe0JXwZQe55YH48iKdrUXhag5M5WnAnXu
         SdRJfjk/W3RfnI0THf5BgZmpR/1otJgBgyo/7Fi6x80m3iwqZdVL9Iz3+aFuGVwf9Kq9
         4gjHcQ8p66IPPtim81z1bZ360uqXkZYeX7uUG3ylfJe6BZL0uYsFXNSHuIrSnoaJCkKV
         6HZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696449135; x=1697053935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3gZi2ZOT0/NwNNMK0bLNpJXByeH26vbZhIwZdTT4NO8=;
        b=ZzU2oklC0EfQI9hzfJwMwHZ4auSN6GtL8JMJZCo+gktmw4dBLtnOGVXsyQhXcrZzhm
         ozXrxISOX21L07aeZ3gQDhakmfArpD3ipBHDI6M5rc6BR2JycP/k+dIFr9m3yzp1A0bA
         RsH0HRvqlDBbJUBvZ+bcWKy4TBCJ12uip7kLuEknahCVcZLIT51azWplNJTzzcP4vSIC
         jfM1alZcF2KecGFW3Ekz0pCo6xYFouoGM4X5F6Q6wMxbMzqbLzv3ROZNlK2stuDyg0mg
         hFjiQdVpNUphOWy4lQU71I45kBvfA20/GOdlYm9CT0LXc4hTRolIo300DqZC5QAMrrEQ
         R4lg==
X-Gm-Message-State: AOJu0YzW3uDdI4vTFApPPAPT1HIjcpe2o3Ke7pFz0noCzxZaNVb84Wz+
        14ifbrK1JwMFLBVSWtQWsDXp5ogC9wuitOPp3G/sIw==
X-Google-Smtp-Source: AGHT+IEt+Xdag0I75gqVyQP7uCJ8LKCpq5edlCsZiVtt+OzGNFKVcDn72QWLExmI+hwVkBRer/pZKNsSbifUyQquWbk=
X-Received: by 2002:a0c:e34c:0:b0:64f:3bec:9b29 with SMTP id
 a12-20020a0ce34c000000b0064f3bec9b29mr3446437qvm.39.1696449135216; Wed, 04
 Oct 2023 12:52:15 -0700 (PDT)
MIME-Version: 1.0
References: <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com> <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net> <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net> <ZRwx7gcY7x1x3a5y@google.com>
 <20231004112152.GA5947@noisy.programming.kicks-ass.net>
In-Reply-To: <20231004112152.GA5947@noisy.programming.kicks-ass.net>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Wed, 4 Oct 2023 12:51:38 -0700
Message-ID: <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 4, 2023 at 4:22=E2=80=AFAM Peter Zijlstra <peterz@infradead.org=
> wrote:
>
> On Tue, Oct 03, 2023 at 08:23:26AM -0700, Sean Christopherson wrote:
> > On Tue, Oct 03, 2023, Peter Zijlstra wrote:
> > > On Mon, Oct 02, 2023 at 05:56:28PM -0700, Sean Christopherson wrote:
>
> > > > Well drat, that there would have saved a wee bit of frustration.  B=
etter late
> > > > than never though, that's for sure.
> > > >
> > > > Just to double confirm: keeping guest PMU state loaded until the vC=
PU is scheduled
> > > > out or KVM exits to userspace, would mean that host perf events won=
't be active
> > > > for potentially large swaths of non-KVM code.  Any function calls o=
r event/exception
> > > > handlers that occur within the context of ioctl(KVM_RUN) would run =
with host
> > > > perf events disabled.
> > >
> > > Hurmph, that sounds sub-optimal, earlier you said <1500 cycles, this =
all
> > > sounds like a ton more.
> > >
> > > /me frobs around the kvm code some...
> > >
> > > Are we talking about exit_fastpath loop in vcpu_enter_guest() ? That
> > > seems to run with IRQs disabled, so at most you can trigger a #PF or
> > > something, which will then trip an exception fixup because you can't =
run
> > > #PF with IRQs disabled etc..
> > >
> > > That seems fine. That is, a theoretical kvm_x86_handle_enter_irqoff()
> > > coupled with the existing kvm_x86_handle_exit_irqoff() seems like
> > > reasonable solution from where I'm sitting. That also more or less
> > > matches the FPU state save/restore AFAICT.
> > >
> > > Or are you talking about the whole of vcpu_run() ? That seems like a
> > > massive amount of code, and doesn't look like anything I'd call a
> > > fast-path. Also, much of that loop has preemption enabled...
> >
> > The whole of vcpu_run().  And yes, much of it runs with preemption enab=
led.  KVM
> > uses preempt notifiers to context switch state if the vCPU task is sche=
duled
> > out/in, we'd use those hooks to swap PMU state.
> >
> > Jumping back to the exception analogy, not all exits are equal.  For "s=
imple" exits
> > that KVM can handle internally, the roundtrip is <1500.   The exit_fast=
path loop is
> > roughly half that.
> >
> > But for exits that are more complex, e.g. if the guest hits the equival=
ent of a
> > page fault, the cost of handling the page fault can vary significantly.=
  It might
> > be <1500, but it might also be 10x that if handling the page fault requ=
ires faulting
> > in a new page in the host.
> >
> > We don't want to get too aggressive with moving stuff into the exit_fas=
tpath loop,
> > because doing too much work with IRQs disabled can cause latency proble=
ms for the
> > host.  This isn't much of a concern for slice-of-hardware setups, but w=
ould be
> > quite problematic for other use cases.
> >
> > And except for obviously slow paths (from the guest's perspective), ext=
ra latency
> > on any exit can be problematic.  E.g. even if we got to the point where=
 KVM handles
> > 99% of exits the fastpath (may or may not be feasible), a not-fastpath =
exit at an
> > inopportune time could throw off the guest's profiling results, introdu=
ce unacceptable
> > jitter, etc.
>
> I'm confused... the PMU must not be running after vm-exit. It must not
> be able to profile the host. So what jitter are you talking about?
>
> Even if we persist the MSR contents, the PMU itself must be disabled on
> vm-exit and enabled on vm-enter. If not by hardware then by software
> poking at the global ctrl msr.
>
> I also don't buy the latency argument, we already do full and complete
> PMU rewrites with IRQs disabled in the context switch path. And as
> mentioned elsewhere, the whole AMX thing has an 8k copy stuck in the FPU
> save/restore.
>
> I would much prefer we keep the PMU swizzle inside the IRQ disabled
> region of vcpu_enter_guest(). That's already a ton better than you have
> today.

Peter, I think the jitter Sean was talking about is the potential
issue in pass-through implementation. If KVM follows the perf
subsystem requirement, then after VMEXIT, any perf_event with
exclude_guest=3D1 (and higher priority ?) should start counting. Because
the guest VM exclusively owns the PMU with all counters at that point,
the gigantic msr save/restore is needed which requires a whole bunch
of wrmsrs. That will be a performance disaster since VMEXIT could
happen at a very high frequency.

In comparison, if we are talking about the existing non-pass-through
implementation, then the PMU context switch immediately becomes
simple: only global ctrl tweak is needed at VM boundary (to stop
exclude_host events and start exclude_guest events in one shot), since
the guest VM and host perf subsystem share the hardware PMU counters.

Peter, that latency argument in pass-through implementation is
something that we hope you could buy. This should be relatively easy
to prove. I can provide some data if you need.

To cope with that, KVM might need to defer that msr save/restore for
PMU to a later point in pass-through implementation. But that will be
conflicting with the support of the perf_event with exclude_guest=3D1.
So, I guess that's why Sean mentioned this: "If y'all are willing to
let KVM redefined exclude_guest to be KVM's outer run loop, then I'm
all for exploring that option."

Note that the situation is similar to AMX, i.e., when guest VMEXIT to
host, the FPU should be switched to the host FPU as well, but because
AMX is too big and thus too slow, KVM defers that to a very late
point.

Hope this explains a little bit and sorry if this might be an
injection of noise.

Thanks.
-Mingwei


>
