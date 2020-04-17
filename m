Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B591ADB13
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgDQKas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 06:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728830AbgDQKar (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 06:30:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA77C061A0C;
        Fri, 17 Apr 2020 03:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=5T+iJux5AD2LbQoaV8j0BcNwC32G2ubqGpp3NLw7K2U=; b=OJJIIwujh1arTkzUU+hPFfANoY
        NiFEfLxyk7MLGkT08KL5BncSK7vyJY5V1xcSdc9lu4nmdLJWsOOjLtcHiAFMxitLUHUhiDjpxfur5
        re+nSC6fHG0QGIQepP+ceQyfoA498aJNGGkDr8wP1kTpcdo48Dbs7e5ih92O3nndERPXsTZSpJ9J5
        eGj1sgLq1Zy0x0/y/NQh7uct6dhQwwEu+QZ88iicydfw2e/NkA1C05v7rJHyuUD+IfeLPpFKwD4WA
        Jc2eMY70zCMsMSJgshZNIsYf8F/uwbsy+9V7UIrA79dxto2GrGLCaxDqW56X6o2O4Y0O0qZg4kN5G
        KvHh6R6Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPOGL-0007BH-EK; Fri, 17 Apr 2020 10:30:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1EEC53006E0;
        Fri, 17 Apr 2020 12:30:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 075632B0DE450; Fri, 17 Apr 2020 12:30:17 +0200 (CEST)
Date:   Fri, 17 Apr 2020 12:30:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v9 03/10] perf/x86: Add constraint to create guest LBR
 event without hw counter
Message-ID: <20200417103016.GV20730@hirez.programming.kicks-ass.net>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
 <20200313021616.112322-4-like.xu@linux.intel.com>
 <20200409163717.GD20713@hirez.programming.kicks-ass.net>
 <0b89963d-33d8-3b0f-fc56-eff3ccce648d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b89963d-33d8-3b0f-fc56-eff3ccce648d@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 11:03:33AM +0800, Xu, Like wrote:
> On 2020/4/10 0:37, Peter Zijlstra wrote:

> > That should sort the branches in order of: gp,fixed,bts,vlbr
> 
> Note the current order is: bts, pebs, fixed, gp.

Yeah, and that means that gp (which is I think the most common case) is
the most expensive.

> Sure, let me try to refactor it in this way.

Thanks!

> > > +static inline bool is_guest_event(struct perf_event *event)
> > > +{
> > > +	if (event->attr.exclude_host && is_kernel_event(event))
> > > +		return true;
> > > +	return false;
> > > +}
> > I don't like this one, what if another in-kernel users generates an
> > event with exclude_host set ?
> Thanks for the clear attitude.
> 
> How about:
> - remove the is_guest_event() to avoid potential misuse;
> - move all checks into is_guest_lbr_event() and make it dedicated:
> 
> static inline bool is_guest_lbr_event(struct perf_event *event)
> {
>     if (is_kernel_event(event) &&
>         event->attr.exclude_host && needs_branch_stack(event))
>         return true;
>     return false;
> }
> 
> In this case, it's safe to generate an event with exclude_host set
> and also use LBR to count guest or nothing for other in-kernel users
> because the intel_guest_lbr_event_constraints() makes LBR exclusive.
> 
> For this generic usage, I may rename:
> - is_guest_lbr_event() to is_lbr_no_counter_event();
> - intel_guest_lbr_event_constraints() to
> intel_lbr_no_counter_event_constraints();
> 
> Is this acceptable to you？

I suppose so, please put a comment on top of that function though, so we
don't forget.

> > > @@ -181,9 +181,19 @@ struct x86_pmu_capability {
> > >   #define GLOBAL_STATUS_UNC_OVF				BIT_ULL(61)
> > >   #define GLOBAL_STATUS_ASIF				BIT_ULL(60)
> > >   #define GLOBAL_STATUS_COUNTERS_FROZEN			BIT_ULL(59)
> > > -#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(58)
> > > +#define GLOBAL_STATUS_LBRS_FROZEN_BIT			58
> > > +#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(GLOBAL_STATUS_LBRS_FROZEN_BIT)
> > >   #define GLOBAL_STATUS_TRACE_TOPAPMI			BIT_ULL(55)
> > > +/*
> > > + * We model guest LBR event tracing as another fixed-mode PMC like BTS.
> > > + *
> > > + * We choose bit 58 (LBRS_FROZEN_BIT) which is used to indicate that the LBR
> > > + * stack is frozen on a hardware PMI request in the PERF_GLOBAL_STATUS msr,
> > > + * and the 59th PMC counter (if any) is not supposed to use it as well.
> > Is this saying that STATUS.58 should never be set? I don't really
> > understand the language.
> My fault, and let me make it more clearly:
> 
> We choose bit 58 because it's used to indicate LBR stack frozen state
> not like other overflow conditions in the PERF_GLOBAL_STATUS msr,
> and it will not be used for any actual fixed events.

That's only with v4, also we unconditionally mask that bit in
handle_pmi_common(), so it'll never be set in the overflow handling.

That's all fine, I suppose, all you want is means of programming the LBR
registers, we don't actually do anything with then in the host context.
Please write a more elaborate comment here.
