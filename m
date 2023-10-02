Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D490D7B51D9
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 13:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbjJBL5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 07:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjJBL5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 07:57:53 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C97DA;
        Mon,  2 Oct 2023 04:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Wkp4ZFR4A8eDeB5jRNcWvSfEDmCQBh31225KsSq0CIM=; b=dc8WAugVpShhXR3MSKlvXjPHOC
        eheG5oU/xn3vn+bQm2fXAvqK7cp+YhZ93zD7SsmprJn6xaPL/61Rau/z2DJcWEFUbDpfbdRH2TF4p
        LGhPJsMhTui3n7wsD/T4iGkQ2kDa/1yKOMvoijNNVhFdfciB216+i3HkB6rwbtAVKu8uL8r6v+4zA
        2a9A1z9HllqaPqJYb4O0oLGuKdqSDyTCxVsT0DLOScob8VEG1a3em2llnoVDDrlaUa8JS6BWmqR5m
        4K4sVByJ879c6JOzej3Fdm+Xgsj8Oz/k1ct9Nli8w49ZkHa2ejxXZ8uGATKfWDYvNqfNCDQrmaak0
        KpxeuWOA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qnHY5-0090Er-0H;
        Mon, 02 Oct 2023 11:57:19 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 347FC300410; Mon,  2 Oct 2023 13:57:18 +0200 (CEST)
Date:   Mon, 2 Oct 2023 13:57:18 +0200
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
Message-ID: <20231002115718.GB13957@noisy.programming.kicks-ass.net>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRbxb15Opa2_AusF@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023 at 03:46:55PM +0000, Sean Christopherson wrote:

> > I will firmly reject anything that takes the PMU away from the host
> > entirely through.
> 
> Why?  What is so wrong with supporting use cases where the platform owner *wants*
> to give up host PMU and NMI watchdog functionality?  If disabling host PMU usage
> were complex, highly invasive, and/or difficult to maintain, then I can understand
> the pushback.  

Because it sucks.

You're forcing people to choose between no host PMU or a slow guest PMU.
And that's simply not a sane choice for most people -- worse it's not a
choice based in technical reality.

It's a choice out of lazyness, disabling host PMU is not a requirement
for pass-through. 

Like I wrote, all we need to do is ensure vCPU tasks will never have a
perf-event scheduled that covers guest mode. Currently this would be
achievable by having event creation for both:

 - CPU events without attr::exclude_guest=1, and
 - task events for vCPU task of interest without attr::exclude_guest=1

error with -EBUSY or something.

This ensures there are no events active for those vCPU tasks at VMENTER
time and you can haz pass-through.

