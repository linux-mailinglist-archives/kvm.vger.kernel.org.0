Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64594592E81
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 13:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbiHOLv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 07:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiHOLv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 07:51:27 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87D11C929;
        Mon, 15 Aug 2022 04:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AY90FDGrlLVOwMMh0B+hcvwJokTU8oLwiaqpshHftBY=; b=DQK7Jm1/Ib1C91LitVokWcZo/V
        oVPJd4DRpps/JOvj4reIP9SRWHc7vH8/kt6bfBIhA2CziikfwhLmFWrfGd9LjCPElMgA0wfl/ZAto
        VqTlGrMwjzePCr2Ms4a8PkMR2/YRkF8y7XVaBG6q48OYZ/YafcokcZnr6q7fCdO5qz4pNczQVLaqj
        Lme7L5sS0Cp+Nx4LN5e/uGAsXle2H+FAj9yQDqaDc3e7dFWLDsSVaDH5m+VkRRYPjzsm1VknVHbKi
        qEnHfMjvVwrQJJPRrWqGhm3hQjq2ZAO665aPMfTpfJdu41NH96sDIdn5tEGgw9dh1G17JOmZBVyiA
        6h126/SA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNYcp-002f5R-LX; Mon, 15 Aug 2022 11:51:20 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id E39CF980153; Mon, 15 Aug 2022 13:51:17 +0200 (CEST)
Date:   Mon, 15 Aug 2022 13:51:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>
Subject: Re: [PATCH v2 1/7] perf/x86/core: Update x86_pmu.pebs_capable for
 ICELAKE_{X,D}
Message-ID: <YvozNSvcxet0gX6b@worktop.programming.kicks-ass.net>
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-2-likexu@tencent.com>
 <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
 <YvoSXyy7ojZ9ird/@worktop.programming.kicks-ass.net>
 <94e6c414-38e1-ebd7-0161-34548f0b5aae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94e6c414-38e1-ebd7-0161-34548f0b5aae@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 05:43:34PM +0800, Like Xu wrote:

> > diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> > index 2db93498ff71..b42c1beb9924 100644
> > --- a/arch/x86/events/intel/core.c
> > +++ b/arch/x86/events/intel/core.c
> > @@ -5933,7 +5933,6 @@ __init int intel_pmu_init(void)
> >   		x86_pmu.pebs_aliases = NULL;
> >   		x86_pmu.pebs_prec_dist = true;
> >   		x86_pmu.lbr_pt_coexist = true;
> > -		x86_pmu.pebs_capable = ~0ULL;
> >   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
> >   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
> >   		x86_pmu.get_event_constraints = glp_get_event_constraints;
> > @@ -6291,7 +6290,6 @@ __init int intel_pmu_init(void)
> >   		x86_pmu.pebs_aliases = NULL;
> >   		x86_pmu.pebs_prec_dist = true;
> >   		x86_pmu.pebs_block = true;
> > -		x86_pmu.pebs_capable = ~0ULL;
> >   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
> >   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
> >   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
> > @@ -6337,7 +6335,6 @@ __init int intel_pmu_init(void)
> >   		x86_pmu.pebs_aliases = NULL;
> >   		x86_pmu.pebs_prec_dist = true;
> >   		x86_pmu.pebs_block = true;
> > -		x86_pmu.pebs_capable = ~0ULL;
> >   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
> >   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
> >   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
> > diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> > index ba60427caa6d..e2da643632b9 100644
> > --- a/arch/x86/events/intel/ds.c
> > +++ b/arch/x86/events/intel/ds.c
> > @@ -2258,6 +2258,7 @@ void __init intel_ds_init(void)
> >   			x86_pmu.drain_pebs = intel_pmu_drain_pebs_icl;
> >   			x86_pmu.pebs_record_size = sizeof(struct pebs_basic);
> >   			if (x86_pmu.intel_cap.pebs_baseline) {
> > +				x86_pmu.pebs_capable = ~0ULL;
> 
> The two features of "Extended PEBS (about pebs_capable)" and "Adaptive PEBS
> (about pebs_baseline)"
> are orthogonal, although the two are often supported together.

The SDM explicitly states that PEBS Baseline implies Extended PEBS. See
3-19.8 (April 22 edition).

The question is if there is hardware that has Extended PEBS but doesn't
have Baseline; and I simply don't know and was hoping Kan could find
out.

That said; the above patch can be further improved by also removing the
PMU_FL_PEBS_ALL lines, which is already set by intel_ds_init().

In general though; the point is, we shouldn't be doing the FMS table
thing for discoverable features. Having pebs_capable = ~0 and
PMU_FL_PEBS_ALL on something with BASELINE set is just wrong.
