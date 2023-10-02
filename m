Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8702C7B5C2E
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 22:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjJBUlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 16:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjJBUlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 16:41:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A881CBF;
        Mon,  2 Oct 2023 13:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D9z9Ycun3skp9uu2bWe7bRffFOXdNOCLhKEREdc4+so=; b=WCsi3JMuKEt8aPWgRq+2D4XJSk
        Ze1IL9zufDxVyvdlwRd3iPGHJDo6A5el4AD9aEDAYpUk39DGd1qwO2PSiS7stoYB1XqT8DKXgzoaG
        Y8ipWxmvG7AhPz0mJgl6s+pi4n4v5zYGTFPpN0zuEj+dBDTSAZNERYUww3+XKFeKDVlEgwMSBw7LL
        sgvBAesRwhsBb+b1oNJrTp9Gy6bpj5I8FNjCdtZ83iNbJsYI5zmUTk/o24u22Ii9/QYcV9E+IiF+n
        QO8bZYxL2+1vTjtQgy6oqErf/DSXz1EzshRNH7ez2JQyF+2MfsBSffx4F9nqJot82+enpO0viEuw6
        0BcVzxIA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qnPiC-009HeX-1l;
        Mon, 02 Oct 2023 20:40:20 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id A39EF300410; Mon,  2 Oct 2023 22:40:17 +0200 (CEST)
Date:   Mon, 2 Oct 2023 22:40:17 +0200
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
Message-ID: <20231002204017.GB27267@noisy.programming.kicks-ass.net>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com>
 <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com>
 <ZRroQg6flyGBtZTG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRroQg6flyGBtZTG@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023 at 08:56:50AM -0700, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, Sep 29, 2023 at 03:46:55PM +0000, Sean Christopherson wrote:
> > > 
> > > > > I will firmly reject anything that takes the PMU away from the host
> > > > > entirely through.
> > > > 
> > > > Why?  What is so wrong with supporting use cases where the platform owner *wants*
> > > > to give up host PMU and NMI watchdog functionality?  If disabling host PMU usage
> > > > were complex, highly invasive, and/or difficult to maintain, then I can understand
> > > > the pushback.  
> > > 
> > > Because it sucks.
> >
> > > You're forcing people to choose between no host PMU or a slow guest PMU.
> 
> Nowhere did I say that we wouldn't take patches to improve the existing vPMU
> support.

Nowhere did I talk about vPMU -- I explicitly mentioned pass-through.

> > > worse it's not a choice based in technical reality.
> 
> The technical reality is that context switching the PMU between host and guest
> requires reading and writing far too many MSRs for KVM to be able to context
> switch at every VM-Enter and every VM-Exit.  And PMIs skidding past VM-Exit adds
> another layer of complexity to deal with.

I'm not sure what you're suggesting here. It will have to save/restore
all those MSRs anyway. Suppose it switches between vCPUs.

> > > It's a choice out of lazyness, disabling host PMU is not a requirement
> > > for pass-through.
> 
> The requirement isn't passthrough access, the requirements are that the guest's
> PMU has accuracy that is on par with bare metal, and that exposing a PMU to the
> guest doesn't have a meaningful impact on guest performance.

Given you don't think that trapping MSR accesses is viable, what else
besides pass-through did you have in mind?

> > Not just a choice of laziness, but it will clearly be forced upon users
> > by external entities:
> > 
> >    "Pass ownership of the PMU to the guest and have no host PMU, or you
> >     won't have sane guest PMU support at all. If you disagree, please open
> >     a support ticket, which we'll ignore."
> 
> We don't have sane guest PMU support today.

Because KVM is too damn hard to use, rebooting a machine is *sooo* much
easier -- and I'm really not kidding here.

Anyway, you want pass-through, but that doesn't mean host cannot use
PMU when vCPU thread is not running.

> If y'all are willing to let KVM redefined exclude_guest to be KVM's outer run
> loop, then I'm all for exploring that option.  But that idea got shot down over
> a year ago[*]. 

I never saw that idea in that thread. You virt people keep talking like
I know how KVM works -- I'm not joking when I say I have no clue about
virt.

Sometimes I get a little clue after y'all keep bashing me over the head,
but it quickly erases itself.

> Or at least, that was my reading of things.  Maybe it was just a
> misunderstanding because we didn't do a good job of defining the behavior.

This might be the case. I don't particularly care where the guest
boundary lies -- somewhere in the vCPU thread. Once the thread is gone,
PMU is usable again etc..

Re-reading parts of that linked thread, I see mention of
PT_MODE_HOST_GUEST -- see I knew we had something there, but I can never
remember all that nonsense. Worst part is that I can't find the relevant
perf code when I grep for that string :/


Anyway, what I don't like is KVM silently changing all events to
::exclude_guest=1. I would like all (pre-existing) ::exclude_guest=0
events to hard error when they run into a vCPU with pass-through on
(PERF_EVENT_STATE_ERROR). I would like event-creation to error out on
::exclude_guest=0 events when a vCPU with pass-through exists -- with
minimal scope (this probably means all CPU events, but only relevant
vCPU events).

It also means ::exclude_guest should actually work -- it often does not
today -- the IBS thing for example totally ignores it.

Anyway, none of this means host cannot use PMU because virt muck wants
it.
