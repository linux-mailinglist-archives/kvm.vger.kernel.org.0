Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C37592CCB
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiHOJbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 05:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiHOJbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 05:31:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985BBE011;
        Mon, 15 Aug 2022 02:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lsCtyoJst0y6igAhNKtZzd9Wf3Mi9HXJ47UnqiGz/dY=; b=Es8b23DGOno0sq+qAcTDpP28cE
        eICM+0KvmeHXtIXGFX7EnCbk5lY1jxvAZhsD5Evze7Asya4tbcAc1OZL+AdF87g69P1xjQh12gE+/
        c224yJOKia0znaba31tJ6pbPlkSuZ2w3qjgg7ISWuoAWYoVWbZJrDCdb9vJxN2muMW34nPE0iHCdd
        FTOu5rJf+vcsGRk3TFuYMHZokvPWBU7FFvBBsf/3mbdMdLvlW6WfRxad91rLbenDMQMFNetifOSnw
        cBFYjvVwyBGuzj2mPedq6tTe9RgE45nnYkV0vr/W0MqcOxP9fcRyHfUmTlZIEYNxilCqURo7YLnwU
        fKcMM+QA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNWRF-002dQM-HZ; Mon, 15 Aug 2022 09:31:13 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id F0CF3980153; Mon, 15 Aug 2022 11:31:11 +0200 (CEST)
Date:   Mon, 15 Aug 2022 11:31:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>
Subject: Re: [PATCH v2 1/7] perf/x86/core: Update x86_pmu.pebs_capable for
 ICELAKE_{X,D}
Message-ID: <YvoSXyy7ojZ9ird/@worktop.programming.kicks-ass.net>
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-2-likexu@tencent.com>
 <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 09:52:13AM +0200, Paolo Bonzini wrote:
> On 7/21/22 12:35, Like Xu wrote:
> > From: Like Xu <likexu@tencent.com>
> > 
> > Ice Lake microarchitecture with EPT-Friendly PEBS capability also support
> > the Extended feature, which means that all counters (both fixed function
> > and general purpose counters) can be used for PEBS events.
> > 
> > Update x86_pmu.pebs_capable like SPR to apply PEBS_ALL semantics.
> > 
> > Cc: Kan Liang <kan.liang@linux.intel.com>
> > Fixes: fb358e0b811e ("perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server")
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > ---
> >   arch/x86/events/intel/core.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> > index 4e9b7af9cc45..e46fd496187b 100644
> > --- a/arch/x86/events/intel/core.c
> > +++ b/arch/x86/events/intel/core.c
> > @@ -6239,6 +6239,7 @@ __init int intel_pmu_init(void)
> >   	case INTEL_FAM6_ICELAKE_X:
> >   	case INTEL_FAM6_ICELAKE_D:
> >   		x86_pmu.pebs_ept = 1;
> > +		x86_pmu.pebs_capable = ~0ULL;
> >   		pmem = true;
> >   		fallthrough;
> >   	case INTEL_FAM6_ICELAKE_L:
> 
> Peter, can you please ack this (you were not CCed on this KVM series but
> this patch is really perf core)?

I would much rather see something like this; except I don't know if it
is fully correct. I can never find what models support what... Kan do
you know?


diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2db93498ff71..b42c1beb9924 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5933,7 +5933,6 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.lbr_pt_coexist = true;
-		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.get_event_constraints = glp_get_event_constraints;
@@ -6291,7 +6290,6 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
-		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
@@ -6337,7 +6335,6 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
-		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index ba60427caa6d..e2da643632b9 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2258,6 +2258,7 @@ void __init intel_ds_init(void)
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_icl;
 			x86_pmu.pebs_record_size = sizeof(struct pebs_basic);
 			if (x86_pmu.intel_cap.pebs_baseline) {
+				x86_pmu.pebs_capable = ~0ULL;
 				x86_pmu.large_pebs_flags |=
 					PERF_SAMPLE_BRANCH_STACK |
 					PERF_SAMPLE_TIME;
