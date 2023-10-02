Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6B17B5C3F
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 22:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjJBUxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 16:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjJBUxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 16:53:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F07CC;
        Mon,  2 Oct 2023 13:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NJ3mkZai2rRb7fHwiHbH42pQCrq+/XPwIYX9xlpeNjA=; b=TwmFmK+cbs5K6/l/UHgdF7kfWz
        Q35hPPXix6s7N45u2WlTUkS4H8EG03QSJVLL91iPFWFU7NIkcLbWj1Vr+MMfiNnj983knf2LSCVxz
        m46udwv48pFhoUSncX70ZlQGNdZ561hTCKzHDIqCYntbjZSbdTBCR+NamMYT43hC0nXOi3IE7m+y7
        +ggzmi7+LtD8E5VTp1Rdz/J1W9Rll6tZqQodKIHUxbegBFmMmGBWAOfunyt5qGqdH941GbFWR7xZ5
        FKValdgHOo5zwPp7gMAoVyg47366brN0SUMSMYJjm4Q/dQeh55uurMQCuf5eFLQnnNbUtv17cR/Og
        Dg2Ad+FA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qnPuF-00B7zd-1t; Mon, 02 Oct 2023 20:52:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id B08AC300454; Mon,  2 Oct 2023 22:52:42 +0200 (CEST)
Date:   Mon, 2 Oct 2023 22:52:42 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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
Message-ID: <20231002205242.GC27267@noisy.programming.kicks-ass.net>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com>
 <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com>
 <ZRroQg6flyGBtZTG@google.com>
 <f6b295f2-966c-f566-14c0-dbe02cad2bd2@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6b295f2-966c-f566-14c0-dbe02cad2bd2@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023 at 03:50:24PM -0400, Liang, Kan wrote:

> Now, the NMI watchdog is using a "CPU-pinned" event. But I think it can
> be replaced by the buddy system, commit 1f423c905a6b
> ("watchdog/hardlockup: detect hard lockups using secondary (buddy) CPUs")

For some simple cases. I've had plenty experience with situations where
that thing would be completely useless.

That is, at some point the 'all CPUs hard locked up' scenario was
something I ran into a lot (although I can't for the life of me remember
wtf I was doing at the time). All that needs is a single
spin_lock_irqsave() on a common lock (or group of locks, like the
rq->lock). Before you know it, the whole machine is a brick.

That said; if you augment this thing with a bunch of CPUs that have
HPET-NMI and IPI-NMI for backtraces, it might actually be useful.
