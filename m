Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79397B31C3
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 13:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbjI2Lya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 07:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjI2Ly2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 07:54:28 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161341B5;
        Fri, 29 Sep 2023 04:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qKq2NzIPOMbXiw7EuwrhFYULUyJIGa2dMNFAahKM20Q=; b=BOJ60tkND/iuUdClWCA0nH3gUS
        q9vz1KHPtQ2+lkb3uSJrd/2nvBwEy4M+CQky0AG+X/mANa/2ocLCW1PlYTOhcgVr2qJcY4FBxwjB1
        pdkjp2wdi2eGh+Qhtrq+5MKYqhE80PZYuQHg0v6tyuCCCdWV2usaWsgClJx6E2ltMWXB6gFEAhwtq
        AA/1O45BPaHv9C+bHsgVFBKrXV1MOJnJGlvVpjxi8bcD2h45g2j/847Qq7cTqNLoQtEyHVYd2yD7v
        sRn9tMGvMoZCBRUpo9cfq1oZ73x+QY1kXfTLMxFrbMVBJFVi49UhMz8Fcf4vtbOUOU9HVwkEozM+/
        8ozEJVFQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qmC3z-0067fO-31;
        Fri, 29 Sep 2023 11:53:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0DFD930030F; Fri, 29 Sep 2023 13:53:45 +0200 (CEST)
Date:   Fri, 29 Sep 2023 13:53:44 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dapeng Mi <dapeng1.mi@linux.intel.com>,
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
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
Message-ID: <20230929115344.GE6282@noisy.programming.kicks-ass.net>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRRl6y1GL-7RM63x@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 10:27:07AM -0700, Sean Christopherson wrote:

> I don't think it does work, at least not without a very, very carefully crafted
> setup and a host userspace that knows it must not use certain aspects of perf.
> E.g. for PEBS, if the guest virtual counters don't map 1:1 to the "real" counters
> in hardware, KVM+perf simply disables the counter.

I have distinct memories of there being patches to rewrite the PEBS
buffer, but I really can't remember what we ended up doing. Like I said,
I can't operate KVM in any meaningful way -- it's a monster :-(

> And for top-down slots, getting anything remotely accurate requires pinning vCPUs
> 1:1 with pCPUs and enumerating an accurate toplogy to the guest:
> 
>   The count is distributed among unhalted logical processors (hyper-threads) who
>   share the same physical core, in processors that support Intel Hyper-Threading
>   Technology.

So IIRC slots is per logical CPU, it counts the actual pipeline stages
going towards that logical CPU, this is required to make it work on SMT
at all -- even for native.

But it's been a long while since that was explained -- and because it
was a call, I can't very well read it back, god how I hate calls :-(

> Jumping the gun a bit (we're in the *super* early stages of scraping together a
> rough PoC), but I think we should effectively put KVM's current vPMU support into
> maintenance-only mode, i.e. stop adding new features unless they are *very* simple
> to enable, and instead pursue an implementation that (a) lets userspace (and/or
> the kernel builder) completely disable host perf (or possibly just host perf usage
> of the hardware PMU) and (b) let KVM passthrough the entire hardware PMU when it
> has been turned off in the host.

I don't think you need to go that far, host can use PMU just fine as
long as it doesn't overlap with a vCPU. Basically, if you force
perf_attr::exclude_guest on everything your vCPU can haz the full thing.

> Hardware vendors are pushing us in the direction whether we like it or not, e.g.
> SNP and TDX want to disallow profiling the guest from the host, 

Yeah, sekjoerity model etc.. bah.

> ARM has an upcoming PMU model where (IIUC) it can't be virtualized
> without a passthrough approach,

:-(

> Intel's hybrid CPUs are a complete trainwreck unless vCPUs are pinned,

Anybodies hybrid things are a clusterfuck, hybrid vs virt doesn't work
sanely on ARM either AFAIU.

I intensely dislike hybrid (and virt ofc), but alas we get to live with
that mess :/ And it's only going to get worse I fear..

At least (for now) AMD hybrid is committed to identical ISA, including
PMUs with their Zen4+Zen4c things. We'll have to wait and see how
that'll end up.

> and virtualizing things like top-down slots, PEBS, and LBRs in the shared model
> requires an absurd amount of complexity throughout the kernel and userspace.

I'm not sure about top-down, the other two, for sure.

My main beef with top-down is the ludicrously bad hardware interface we
have on big cores, I like the atom interface a *ton* better.

> Note, a similar idea was floated and rejected in the past[*], but that failed
> proposal tried to retain host perf+PMU functionality by making the behavior dynamic,
> which I agree would create an awful ABI for the host.  If we make the "knob" a
> Kconfig 

Must not be Kconfig, distros would have no sane choice.

> or kernel param, i.e. require the platform owner to opt-out of using perf
> no later than at boot time, then I think we can provide a sane ABI, keep the
> implementation simple, all without breaking existing users that utilize perf in
> the host to profile guests.

It's a shit choice to have to make. At the same time I'm not sure I have
a better proposal.

It does mean a host cannot profile one guest and have pass-through on the
other. Eg. have a development and production guest on the same box. This
is pretty crap.

Making it a guest-boot-option would allow that, but then the host gets
complicated again. I think I can make it trivially work for per-task
events, simply error the creation of events without exclude_guest for
affected vCPU tasks. But the CPU events are tricky.


I will firmly reject anything that takes the PMU away from the host
entirely through.

Also, NMI watchdog needs a solution.. Ideally hardware grows a second
per-CPU timer we can program to NMI.


