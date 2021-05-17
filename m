Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA9038271C
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 10:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbhEQIfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 04:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEQIff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 04:35:35 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23E1C061573;
        Mon, 17 May 2021 01:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0eBZZp7NN4Bj+DVjUM73MXPTxCqdNREhhnuMJLwciiU=; b=gLGmVQfIeGqV1yKmMUsUZiovFj
        n4+Xnakss/wACreSv95R+lY5xbP4ixYOm6744uFrtkaogzP86Hteu2CfpQzc5daVDRBFPNs0EYdKn
        43R9KWf+qqAdAywA3dQZlVS8IRgMZZQL4YAeVFS95wcOBC7RCV9PJiF2lDpuiZISbU8CZug2YYRry
        6I9LsnE1QdX5MAygRQo0Ut6V96zbyC9o+ujnOd6/zY1+J8fG7l7Sa/yv1nn2I09t0TjySYhpE0mAU
        E1G1Lkb5C9kSBPrPwQ/FDrH+KNehXDmpFJswXYgMN+DYfwyNYCpU9lRRG9sZvJZ4da4iHRvBD4wca
        OzkRpMfw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1liYhC-00EGHk-Lo; Mon, 17 May 2021 08:33:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4B91D300095;
        Mon, 17 May 2021 10:33:50 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3CEC12D3FBA01; Mon, 17 May 2021 10:33:50 +0200 (CEST)
Date:   Mon, 17 May 2021 10:33:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: Re: [PATCH v6 06/16] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR
 emulation for extended PEBS
Message-ID: <YKIqbph62oclxjnt@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-7-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511024214.280733-7-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 10:42:04AM +0800, Like Xu wrote:
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 2f89fd599842..c791765f4761 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3898,31 +3898,49 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>  	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
>  	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
> +	u64 pebs_mask = (x86_pmu.flags & PMU_FL_PEBS_ALL) ?
> +		cpuc->pebs_enabled : (cpuc->pebs_enabled & PEBS_COUNTER_MASK);

> -	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
> -		arr[0].guest &= ~cpuc->pebs_enabled;
> -	else
> -		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
> -	*nr = 1;

Instead of endlessly mucking about with branches, do we want something
like this instead?

---
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2521d03de5e0..bcfba11196c8 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2819,10 +2819,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 * counters from the GLOBAL_STATUS mask and we always process PEBS
 	 * events via drain_pebs().
 	 */
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		status &= ~cpuc->pebs_enabled;
-	else
-		status &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	status &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
 
 	/*
 	 * PEBS overflow sets bit 62 in the global status register
@@ -3862,10 +3859,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		arr[0].guest &= ~cpuc->pebs_enabled;
-	else
-		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
 	*nr = 1;
 
 	if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
@@ -5546,6 +5540,7 @@ __init int intel_pmu_init(void)
 	x86_pmu.events_mask_len		= eax.split.mask_length;
 
 	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
+	x86_pmu.pebs_capable		= PEBS_COUNTER_MASK;
 
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
@@ -5730,6 +5725,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.lbr_pt_coexist = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.get_event_constraints = glp_get_event_constraints;
@@ -6080,6 +6076,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
@@ -6123,6 +6120,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 27fa85e7d4fd..6f3cf81ccb1b 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -805,6 +805,7 @@ struct x86_pmu {
 	void		(*pebs_aliases)(struct perf_event *event);
 	unsigned long	large_pebs_flags;
 	u64		rtm_abort_event;
+	u64		pebs_capable;
 
 	/*
 	 * Intel LBR
