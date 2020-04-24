Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF981B73B3
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 14:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgDXMRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 08:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgDXMRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 08:17:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4B4C09B045;
        Fri, 24 Apr 2020 05:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1LG3NTg+hQCnLOSki57Fzf/dRCxKCCPgCIak4djFi6U=; b=bcrd/MjrN7q9MjBw2FPtqGANDb
        G8GizFfPgO5JvWhBkqbbZakuSq4FHK48XFaYrsufaLf+eA9gHFanJKkTyJex6qrVnyzV0LDn9txKe
        gF1WZYAzpger/d0puTRVwfAr0V9w3dntoHLLGJV8F4S5EAFXZKSi5TpaVnf4IVGNGA8Wy0E2Ff/Uf
        ZKxV9G+98Tk/ZHn9JNJTchiWLMm4DL6I68e2gPaC3WVtC13zXIKmTy8bXq1cKqYqGU/G2diqvYkVn
        oe704Js1w8AMuziYZGzziDYrThyQSnyF5Q10csBICoHzYi1RxES/1/rjObx7cpDHD+466v6rBgtc3
        KrJVsn8Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRxFt-0007hI-4o; Fri, 24 Apr 2020 12:16:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4CFA530257C;
        Fri, 24 Apr 2020 14:16:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 31884202EEC81; Fri, 24 Apr 2020 14:16:26 +0200 (CEST)
Date:   Fri, 24 Apr 2020 14:16:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH v10 08/11] KVM: x86/pmu: Add LBR feature emulation via
 guest LBR event
Message-ID: <20200424121626.GB20730@hirez.programming.kicks-ass.net>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
 <20200423081412.164863-9-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423081412.164863-9-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 04:14:09PM +0800, Like Xu wrote:
> +static int intel_pmu_create_lbr_event(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct perf_event *event;
> +
> +	/*
> +	 * The perf_event_attr is constructed in the minimum efficient way:
> +	 * - set 'pinned = true' to make it task pinned so that if another
> +	 *   cpu pinned event reclaims LBR, the event->oncpu will be set to -1;
> +	 *
> +	 * - set 'sample_type = PERF_SAMPLE_BRANCH_STACK' and
> +	 *   'exclude_host = true' to mark it as a guest LBR event which
> +	 *   indicates host perf to schedule it without but a fake counter,
> +	 *   check is_guest_lbr_event() and intel_guest_event_constraints();
> +	 *
> +	 * - set 'branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
> +	 *   PERF_SAMPLE_BRANCH_USER' to configure it to use callstack mode,
> +	 *   which allocs 'ctx->task_ctx_data' and request host perf subsystem
> +	 *   to save/restore guest LBR records during host context switches,
> +	 *   check branch_user_callstack() and intel_pmu_lbr_sched_task();
> +	 */
> +	struct perf_event_attr attr = {
> +		.type = PERF_TYPE_RAW,

This is not right; this needs a .config

And I suppose that is why you need that horrible:
needs_guest_lbr_without_counter() thing to begin with.

Please allocate yourself an event from the pseudo event range:
event==0x00. Currently we only have umask==3 for Fixed2 and umask==4
for Fixed3, given you claim 58, which is effectively Fixed25,
umask==0x1a might be appropriate.

Also, I suppose we need to claim 0x0000 as an error, so that other
people won't try this again.

> +		.size = sizeof(attr),
> +		.pinned = true,
> +		.exclude_host = true,
> +		.sample_type = PERF_SAMPLE_BRANCH_STACK,
> +		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
> +					PERF_SAMPLE_BRANCH_USER,
> +	};
> +
> +	if (unlikely(pmu->lbr_event))
> +		return 0;
> +
> +	event = perf_event_create_kernel_counter(&attr, -1,
> +						current, NULL, NULL);
> +	if (IS_ERR(event)) {
> +		pr_debug_ratelimited("%s: failed %ld\n",
> +					__func__, PTR_ERR(event));
> +		return -ENOENT;
> +	}
> +	pmu->lbr_event = event;
> +	pmu->event_count++;
> +	return 0;
> +}

Also, what happens if you fail programming due to a conflicting cpu
event? That pinned doesn't guarantee you'll get the event, it just means
you'll error instead of getting RR.

I didn't find any code checking the event state.
