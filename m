Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617C27B6420
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 10:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjJCIa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 04:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240591AbjJCIRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 04:17:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62B1DC;
        Tue,  3 Oct 2023 01:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=P9UQwUtX+gLOqFK5NmarCgjIZeBtBENgaGmXHWLN+/Q=; b=kLgLvz3Khu87+ZceWZ8FFN4txS
        RZriYnGghADsEKmQVDdO5wuSbE3UDmFwNjGjVML7auiE4PgMpFCDqwrswslt8kXbwGcQZO6o7KD74
        AAp5q95TyffMx9+kyLv6L+SX9VD2TKSRgzv2YrPqF2Q3TOa+fdb0x1uYCIp7e/kFoGeRMEHLZqSFs
        eXgVGzmPV0aYmdMq2MoEZChFg2M8AyB/WX11JBS9prB+q84nsxsJL/4wUInOLl3NnkmAUO0lj/j+y
        OdYV5gbCbutq5trM5xwmMrwfj77Pyd5e3H02zZ5ZDS90inOHvJLG6fJlBZK1kipKFEhRMRoUlVEgM
        /8vI1bUg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qnaZl-00Dwrv-8l; Tue, 03 Oct 2023 08:16:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id E854330036C; Tue,  3 Oct 2023 10:16:16 +0200 (CEST)
Date:   Tue, 3 Oct 2023 10:16:16 +0200
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
Message-ID: <20231003081616.GE27267@noisy.programming.kicks-ass.net>
References: <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com>
 <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com>
 <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRtmvLJFGfjcusQW@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023 at 05:56:28PM -0700, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, Peter Zijlstra wrote:

> > I'm not sure what you're suggesting here. It will have to save/restore
> > all those MSRs anyway. Suppose it switches between vCPUs.
> 
> The "when" is what's important.   If KVM took a literal interpretation of
> "exclude guest" for pass-through MSRs, then KVM would context switch all those
> MSRs twice for every VM-Exit=>VM-Enter roundtrip, even when the VM-Exit isn't a
> reschedule IRQ to schedule in a different task (or vCPU).  The overhead to save
> all the host/guest MSRs and load all of the guest/host MSRs *twice* for every
> VM-Exit would be a non-starter.  E.g. simple VM-Exits are completely handled in
> <1500 cycles, and "fastpath" exits are something like half that.  Switching all
> the MSRs is likely 1000+ cycles, if not double that.

See, you're the virt-nerd and I'm sure you know what you're talking
about, but I have no clue :-) I didn't know there were different levels
of vm-exit.

> FWIW, the primary use case we care about is for slice-of-hardware VMs, where each
> vCPU is pinned 1:1 with a host pCPU.

I've been given to understand that vm-exit is a bad word in this
scenario, any exit is a fail. They get MWAIT and all the other crap and
more or less pretend to be real hardware.

So why do you care about those MSRs so much? That should 'never' happen
in this scenario.

> > > Or at least, that was my reading of things.  Maybe it was just a
> > > misunderstanding because we didn't do a good job of defining the behavior.
> > 
> > This might be the case. I don't particularly care where the guest
> > boundary lies -- somewhere in the vCPU thread. Once the thread is gone,
> > PMU is usable again etc..
> 
> Well drat, that there would have saved a wee bit of frustration.  Better late
> than never though, that's for sure.
> 
> Just to double confirm: keeping guest PMU state loaded until the vCPU is scheduled
> out or KVM exits to userspace, would mean that host perf events won't be active
> for potentially large swaths of non-KVM code.  Any function calls or event/exception
> handlers that occur within the context of ioctl(KVM_RUN) would run with host
> perf events disabled.

Hurmph, that sounds sub-optimal, earlier you said <1500 cycles, this all
sounds like a ton more.

/me frobs around the kvm code some...

Are we talking about exit_fastpath loop in vcpu_enter_guest() ? That
seems to run with IRQs disabled, so at most you can trigger a #PF or
something, which will then trip an exception fixup because you can't run
#PF with IRQs disabled etc..

That seems fine. That is, a theoretical kvm_x86_handle_enter_irqoff()
coupled with the existing kvm_x86_handle_exit_irqoff() seems like
reasonable solution from where I'm sitting. That also more or less
matches the FPU state save/restore AFAICT.

Or are you talking about the whole of vcpu_run() ? That seems like a
massive amount of code, and doesn't look like anything I'd call a
fast-path. Also, much of that loop has preemption enabled...

> Are you ok with that approach?  Assuming we don't completely botch things, the
> interfaces are sane, we can come up with a clean solution for handling NMIs, etc.

Since you steal the whole PMU, can't you re-route the PMI to something
that's virt friendly too?

> > It also means ::exclude_guest should actually work -- it often does not
> > today -- the IBS thing for example totally ignores it.
> 
> Is that already an in-tree, or are you talking about Manali's proposed series to
> support virtualizing IBS?

The IBS code as is, it totally ignores ::exclude_guest. Manali was going
to add some of it. But I'm not at all sure about the state of the other
PMU drivers we have.

Just for giggles, P4 has VMX support... /me runs like crazy
