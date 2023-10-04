Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162467B7E16
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 13:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242223AbjJDLWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 07:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbjJDLWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 07:22:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DBCA1;
        Wed,  4 Oct 2023 04:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TVbqbO3tLvT6hwA1RZc7HpSzY4IxE6YOiikjeQbfNIE=; b=TGctT1NvnNfm5OkdPnq/PXMR9U
        0PhIm8AndGbNhHlbJH23STcBHZTPVlewU/9H+lUeti6KGb71iiMWfsg4B8OFpuwe0ia0ybfBcxfGa
        JUndiUUl44LLjIevd6+pmUzGzAzgzTA261p6sP6InwIzJZO+vpsPEueZ3KGKQgwegH8QFJLAT4Kga
        bON31WXhohd3qofmVuP/OlvCJUtRiS3v94eizCt0mhrr4K6wANQ663LL32vDZu+GYSbRm+5IEs3p4
        HhHRVxvR6Jt4dBxYPjy9AZ5Jn/b0VxNVPLKCbMEnKTM+ahqaqg2od74YfR1gru61JIX+XenfkEMYa
        2y5NYD5g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qnzwv-0035Dg-35; Wed, 04 Oct 2023 11:21:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id B78F6300392; Wed,  4 Oct 2023 13:21:52 +0200 (CEST)
Date:   Wed, 4 Oct 2023 13:21:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
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
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
Message-ID: <20231004112152.GA5947@noisy.programming.kicks-ass.net>
References: <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com>
 <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com>
 <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net>
 <ZRwx7gcY7x1x3a5y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRwx7gcY7x1x3a5y@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023 at 08:23:26AM -0700, Sean Christopherson wrote:
> On Tue, Oct 03, 2023, Peter Zijlstra wrote:
> > On Mon, Oct 02, 2023 at 05:56:28PM -0700, Sean Christopherson wrote:

> > > Well drat, that there would have saved a wee bit of frustration.  Better late
> > > than never though, that's for sure.
> > > 
> > > Just to double confirm: keeping guest PMU state loaded until the vCPU is scheduled
> > > out or KVM exits to userspace, would mean that host perf events won't be active
> > > for potentially large swaths of non-KVM code.  Any function calls or event/exception
> > > handlers that occur within the context of ioctl(KVM_RUN) would run with host
> > > perf events disabled.
> > 
> > Hurmph, that sounds sub-optimal, earlier you said <1500 cycles, this all
> > sounds like a ton more.
> > 
> > /me frobs around the kvm code some...
> > 
> > Are we talking about exit_fastpath loop in vcpu_enter_guest() ? That
> > seems to run with IRQs disabled, so at most you can trigger a #PF or
> > something, which will then trip an exception fixup because you can't run
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
> The whole of vcpu_run().  And yes, much of it runs with preemption enabled.  KVM
> uses preempt notifiers to context switch state if the vCPU task is scheduled
> out/in, we'd use those hooks to swap PMU state.
> 
> Jumping back to the exception analogy, not all exits are equal.  For "simple" exits
> that KVM can handle internally, the roundtrip is <1500.   The exit_fastpath loop is
> roughly half that.
> 
> But for exits that are more complex, e.g. if the guest hits the equivalent of a
> page fault, the cost of handling the page fault can vary significantly.  It might
> be <1500, but it might also be 10x that if handling the page fault requires faulting
> in a new page in the host.
> 
> We don't want to get too aggressive with moving stuff into the exit_fastpath loop,
> because doing too much work with IRQs disabled can cause latency problems for the
> host.  This isn't much of a concern for slice-of-hardware setups, but would be
> quite problematic for other use cases.
> 
> And except for obviously slow paths (from the guest's perspective), extra latency
> on any exit can be problematic.  E.g. even if we got to the point where KVM handles
> 99% of exits the fastpath (may or may not be feasible), a not-fastpath exit at an
> inopportune time could throw off the guest's profiling results, introduce unacceptable
> jitter, etc.

I'm confused... the PMU must not be running after vm-exit. It must not
be able to profile the host. So what jitter are you talking about?

Even if we persist the MSR contents, the PMU itself must be disabled on
vm-exit and enabled on vm-enter. If not by hardware then by software
poking at the global ctrl msr.

I also don't buy the latency argument, we already do full and complete
PMU rewrites with IRQs disabled in the context switch path. And as
mentioned elsewhere, the whole AMX thing has an 8k copy stuck in the FPU
save/restore.

I would much prefer we keep the PMU swizzle inside the IRQ disabled
region of vcpu_enter_guest(). That's already a ton better than you have
today.

