Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF761A3836
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgDIQqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 12:46:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44838 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgDIQqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 12:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JF8YIk2xFNHVFU1BBr/GqiO+G+p4hUPmEi3VXvq3m8w=; b=zGwzrwVZUwkq0Ox8InOnz/dj9j
        1H28pKr6QAnD702oNub4/F3RpPbM7V1b0EqQFnDOXKFXpjYnLRHM8X89fugBhBjb1azQf/FgggwkF
        k1r1KPBnjLcfH12NgxGYlEHF4jyUxD1khm6MJ59YSi28ygiNk7K2LCttumYJJFEtEJkWep+QjZE8q
        +mnhR9oLBp1Gz92FBPWaYBkaGL4miUM3sKtWdrkNYx3ZrLV7lm+tRPi1+bKAcKm7dOCvRDmYVlRNP
        DxItH7vdamlQJ1FWaEl/m4D6S2WLJ8UbtymNZlecI3EOkExp4pI1ibMGmWSawygb73iWR8DV+w3Vi
        Y07OXveQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMaJG-0004Bi-SA; Thu, 09 Apr 2020 16:45:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 43F9A300478;
        Thu,  9 Apr 2020 18:45:45 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3678F2BA1D829; Thu,  9 Apr 2020 18:45:45 +0200 (CEST)
Date:   Thu, 9 Apr 2020 18:45:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
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
Subject: Re: [PATCH v9 04/10] perf/x86: Keep LBR stack unchanged on the host
 for guest LBR event
Message-ID: <20200409164545.GE20713@hirez.programming.kicks-ass.net>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
 <20200313021616.112322-5-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313021616.112322-5-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 13, 2020 at 10:16:10AM +0800, Like Xu wrote:
> When a guest wants to use the LBR stack, its hypervisor creates a guest
> LBR event and let host perf schedules it. A new 'int guest_lbr_enabled'
> field in the "struct cpu_hw_events", is marked as true when perf adds
> a guest LBR event and false on deletion.
> 
> The LBR stack msrs are accessible to the guest when its guest LBR event
> is scheduled in by the perf subsystem. Before scheduling out the event,
> we should avoid host changes on IA32_DEBUGCTLMSR or LBR_SELECT. Otherwise,
> some unexpected branch operations may interfere with guest behavior,
> pollute LBR records, and even cause host branch data leakage. In addition,
> the intel_pmu_lbr_read() on the host is also avoidable for guest usage.
> 
> On v4 PMU or later, the LBR stack are frozen on the overflowed condition
> if Freeze_LBR_On_PMI is true and resume recording via acking LBRS_FROZEN
> to global status msr instead of re-enabling IA32_DEBUGCTL.LBR. So when a
> guest LBR event is running, the host PMI handler has to keep LBRS_FROZEN
> bit set (thus LBR being frozen) until the guest enables it. Otherwise,
> when the guest enters non-root mode, the LBR will start recording and
> the guest PMI handler code will also pollute the LBR stack.
> 
> To ensure that guest LBR records are not lost during the context switch,
> the BRANCH_CALL_STACK flag should be configured in the 'branch_sample_type'
> for a guest LBR event because a callstack event could save/restore guest
> unread records with the help of intel_pmu_lbr_sched_task() naturally.
> 
> However, the regular host LBR perf event doesn't save/restore LBR_SELECT,
> because it's configured in the LBR_enable() based on branch_sample_type.
> So when a guest LBR is running, the guest LBR_SELECT may changes for its
> own use and we have to add the LBR_SELECT save/restore to ensure what the
> guest LBR_SELECT value doesn't get lost during the context switching.

I had to read the patch before that made sense; I think it's mostly
there, but it can use a little help.


> @@ -691,8 +714,12 @@ void intel_pmu_lbr_read(void)
>  	 *
>  	 * This could be smarter and actually check the event,
>  	 * but this simple approach seems to work for now.
> +	 *
> +	 * And there is no need to read lbr here if a guest LBR event

There's 'lbr' and 'LBR' in the same sentence

> +	 * is using it, because the guest will read them on its own.
>  	 */
> -	if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
> +	if (!cpuc->lbr_users || cpuc->guest_lbr_enabled ||
> +		cpuc->lbr_users == cpuc->lbr_pebs_users)

indent fail

>  		return;
>  
>  	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
