Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32C57C56A0
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 16:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbjJKOUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 10:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbjJKOUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 10:20:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E60A4;
        Wed, 11 Oct 2023 07:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=giWFgglIwvl79cFsu43H0+4WKJFrU3jVnmUoXzCqgBA=; b=BhimHCpistBqcNILTpqmB95VgU
        7PmFSmnPRvQQyRpFA0g7FVo0LbKL5mLZwxk/6dbjL+y/CSOGsKpPgP9QBf1R85Lcb7iXfpVCC3p9j
        uQUMiBKlRc+vbq1Fktephy4/45HG9+hQRSjxyNzaWWPv4mBrSIXcl8AqE+imo/sUd6Oia6/wG7jNQ
        NuVuioo4VIDTezY7pjFo+uV6eqmRDBsi8kf3JlR9roMTFRFib4KOxUv6a04qCfR0BuytGa6g7yzn3
        0uyvgrPPgjUp3HzKHrRJ4vn9efOIJnnevO4/9BMPcATcav/BS8x5jOrtQNUy6fy3BTyjBA0+5iOwe
        oBwI4MVg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qqa4C-00BCzx-9t; Wed, 11 Oct 2023 14:20:04 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id EE6F130036C; Wed, 11 Oct 2023 16:20:03 +0200 (CEST)
Date:   Wed, 11 Oct 2023 16:20:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>, Ingo Molnar <mingo@kernel.org>,
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
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
Message-ID: <20231011142003.GF19999@noisy.programming.kicks-ass.net>
References: <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com>
 <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net>
 <ZRwx7gcY7x1x3a5y@google.com>
 <20231004112152.GA5947@noisy.programming.kicks-ass.net>
 <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
 <ZR3eNtP5IVAHeFNC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR3eNtP5IVAHeFNC@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 02:50:46PM -0700, Sean Christopherson wrote:

> Thinking about this more, what if we do a blend of KVM's FPU swapping and debug
> register swapping?
> 
>   A. Load guest PMU state in vcpu_enter_guest() after IRQs are disabled
>   B. Put guest PMU state (and load host state) in vcpu_enter_guest() before IRQs
>      are enabled, *if and only if* the current CPU has one or perf events that
>      wants to use the hardware PMU
>   C. Put guest PMU state at vcpu_put()
>   D. Add a perf callback that is invoked from IRQ context when perf wants to
>      configure a new PMU-based events, *before* actually programming the MSRs,
>      and have KVM's callback put the guest PMU state
> 

No real objection, but I would suggest arriving at that solution by
first building the simple-stupid thing and then making it more
complicated in additinoal patches. Hmm?
