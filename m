Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E19F5930C2
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 16:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242794AbiHOOaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 10:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243109AbiHOOaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 10:30:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB8D23BF4;
        Mon, 15 Aug 2022 07:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=udinPTaxlmsveuQ7BCs88a/BH/6ZgIvQZPLYDOcFcNI=; b=gWmWI3RjItS53SEQytLQHC8GXu
        FO09jw9s6iyNzoFlq76tljbHMWR6YY4E0kXQ1MtNbnKc3EX1hD8jsHvc8KhH7o4xeSXDPVYQucuWq
        53lAh2sMOG+6kPl7lgSAFXOnoYjTvxHGKl6mkU8gbS1EZkZ26WfJSahFFH+gEp3gf56FCl+Cz5QL0
        FGl7ZYiALFVGF6W72zNN/BOnZ7ZhaLGSCwr9HMIxY8JAPT/6vCfiJnmTnlJ+gNCUPnYlzEM2zwMYN
        HsveeOOGe5E+MrRhMupvB0RvggLuQhMg2nb3zeoztpXJpEV7UtVPzSFPjbnOb1o254BoKmD7lQ3mW
        Kid726rg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNb6T-005n1e-KU; Mon, 15 Aug 2022 14:30:05 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id DA3D6980153; Mon, 15 Aug 2022 16:30:03 +0200 (CEST)
Date:   Mon, 15 Aug 2022 16:30:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/7] perf/x86/core: Update x86_pmu.pebs_capable for
 ICELAKE_{X,D}
Message-ID: <YvpYa+YagI/7x9MU@worktop.programming.kicks-ass.net>
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-2-likexu@tencent.com>
 <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
 <YvoSXyy7ojZ9ird/@worktop.programming.kicks-ass.net>
 <94e6c414-38e1-ebd7-0161-34548f0b5aae@gmail.com>
 <YvozNSvcxet0gX6b@worktop.programming.kicks-ass.net>
 <952632db-b090-ceb9-1467-a6b598ca2b02@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <952632db-b090-ceb9-1467-a6b598ca2b02@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 09:06:01AM -0400, Liang, Kan wrote:

> Goldmont Plus should be the only platform which supports extended PEBS
> but doesn't have Baseline.

Like so then...

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2db93498ff71..cb98a05ee743 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6291,10 +6291,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
-		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
-		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 
@@ -6337,10 +6335,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
-		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
-		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 		x86_pmu.lbr_pt_coexist = true;
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index ba60427caa6d..ac6dd4c96dbc 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2262,6 +2262,7 @@ void __init intel_ds_init(void)
 					PERF_SAMPLE_BRANCH_STACK |
 					PERF_SAMPLE_TIME;
 				x86_pmu.flags |= PMU_FL_PEBS_ALL;
+				x86_pmu.pebs_capable = ~0ULL;
 				pebs_qual = "-baseline";
 				x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_EXTENDED_REGS;
 			} else {
