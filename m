Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871F77C567C
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 16:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbjJKOQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 10:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbjJKOQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 10:16:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6938CB8;
        Wed, 11 Oct 2023 07:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h1+bFrTxC9bNpWggJ1/WhAB0lCHgMj17Prrv9vHF3zw=; b=LimFqPKToomKM3ZLamW+/KIPGe
        FZJLYLU9SZ+I2Tz2YZPKHuBPxyLjsKL/1NrfjN7vtdtt6npXZY64RrPjJR0gGZFjoe6FvTNdHqY0J
        U/bYopgTCcQ647n9v/bFwel9DWixgUjZvcXP6R6z142PzIYuyKZWQGSxb/FOT/r6TxmoCvCmohxnD
        se/4tkB5jrGq0Kz9zCrnxkwsEJ87orN6fOdF1aXJxIbb14gjlMxOLHtpNsb8w9hbTWeFPPlL0JlXR
        ICf4vHeuJRR4Te/5/xgvZP1ZY5QTH8Z8S34GNYkntSo3FXBIJXT546pquCKZlPa7j8hTXhyMjS0A5
        Bwd3W/oQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qqZzr-00BCga-NG; Wed, 11 Oct 2023 14:15:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 64E5D30036C; Wed, 11 Oct 2023 16:15:35 +0200 (CEST)
Date:   Wed, 11 Oct 2023 16:15:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Manali Shukla <manali.shukla@amd.com>
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
        David Dunn <daviddunn@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
Message-ID: <20231011141535.GF6307@noisy.programming.kicks-ass.net>
References: <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net>
 <ZRwx7gcY7x1x3a5y@google.com>
 <20231004112152.GA5947@noisy.programming.kicks-ass.net>
 <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
 <ZR3eNtP5IVAHeFNC@google.com>
 <ZR3hx9s1yJBR0WRJ@google.com>
 <c69a1eb1-e07a-8270-ca63-54949ded433d@gmail.com>
 <03b7da03-78a1-95b1-3969-634b5c9a5a56@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03b7da03-78a1-95b1-3969-634b5c9a5a56@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 10:33:41PM +0530, Manali Shukla wrote:
> Hi all,
> 
> I would like to add following things to the discussion just for the awareness of
> everyone.
> 
> Fully virtualized PMC support is coming to an upcoming AMD SoC and we are
> working on prototyping it.
> 
> As part of virtualized PMC design, the PERF_CTL registers are defined as Swap
> type C: guest PMC states are loaded at VMRUN automatically but host PMC states
> are not saved by hardware.

Per the previous discussion, doing this while host has active counters
that do not have ::exclude_guest=1 is invalid and must result in an
error.

Also, I'm assuming it is all optional, a host can still profile a guest
if all is configured just so?

> If hypervisor is using the performance counters, it
> is hypervisor's responsibility to save PERF_CTL registers to host save area
> prior to VMRUN and restore them after VMEXIT. 

Does VMEXIT clear global_ctrl at least?

> In order to tackle PMC overflow
> interrupts in guest itself, NMI virtualization or AVIC can be used, so that
> interrupt on PMC overflow in guest will not leak to host.

Can you please clarify -- AMD has this history with very dodgy PMI
boundaries. See the whole amd_pmu_adjust_nmi_window() crud. Even the
PMUv2 update didn't fix that nonsense.

How is any virt stuff supposed to fix this? If the hardware is late
delivering PMI, what guarantees a guest PMI does not land in host
context and vice-versa?

How does NMI virtualization (what even is that) or AVIC (I'm assuming
that's a virtual interrupt controller) help?

Please make very sure, with your hardware team, that PMI must not be
delivered after clearing global_ctrl (preferably) or at the very least,
there exists a sequence of operations that provides a hard barrier
to order PMI.

