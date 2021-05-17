Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3991C382804
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 11:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhEQJRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 05:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbhEQJRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 05:17:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC12C061763;
        Mon, 17 May 2021 02:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fCrrb2wfn5Zi32JbXpVG62C+jD1F3AjSSjfgB0Dmat8=; b=G48hOt5WAJAMdzdaFVHcJvE8D+
        ZVcQ1Old/mPKH9bPE+m1O+zMsvVEt1M5sePG1vncrhbTVAyb73A5J+kKaV4qPTUIOo9REid6MBe0p
        vgJNCjFYP2BP/KKiX1XYE7ySKaTj2J46WG+T1YaZ4M3VnGLpVS2McgYkJeLh9AIU6w9QNArl4DR4O
        ZmcvW9RAm1ocHDz4Ly2PwcXGVXOAPZL611MFky/KfmtXeVqEkEjS4usApoy2V4aavKIC8xNrzKUIF
        zziHoJ6Mr76nLaWhzLvdNIQg/8fIqBqLhYYjXPdMJI0UI33NFytH8k0+BaR/7iT9x0vKXRHehVEZu
        UiIQVH2g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1liZKg-00Cjt0-F6; Mon, 17 May 2021 09:14:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AD098300095;
        Mon, 17 May 2021 11:14:36 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9C1702D4489BD; Mon, 17 May 2021 11:14:36 +0200 (CEST)
Date:   Mon, 17 May 2021 11:14:36 +0200
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
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 07/16] KVM: x86/pmu: Reprogram PEBS event to emulate
 guest PEBS counter
Message-ID: <YKIz/J1HoOvbmR42@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-8-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511024214.280733-8-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 10:42:05AM +0800, Like Xu wrote:
> @@ -99,6 +109,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  				  bool exclude_kernel, bool intr,
>  				  bool in_tx, bool in_tx_cp)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
>  	struct perf_event *event;
>  	struct perf_event_attr attr = {
>  		.type = type,
> @@ -110,6 +121,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		.exclude_kernel = exclude_kernel,
>  		.config = config,
>  	};
> +	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
>  
>  	attr.sample_period = get_sample_period(pmc, pmc->counter);
>  
> @@ -124,9 +136,23 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		attr.sample_period = 0;
>  		attr.config |= HSW_IN_TX_CHECKPOINTED;
>  	}
> +	if (pebs) {
> +		/*
> +		 * The non-zero precision level of guest event makes the ordinary
> +		 * guest event becomes a guest PEBS event and triggers the host
> +		 * PEBS PMI handler to determine whether the PEBS overflow PMI
> +		 * comes from the host counters or the guest.
> +		 *
> +		 * For most PEBS hardware events, the difference in the software
> +		 * precision levels of guest and host PEBS events will not affect
> +		 * the accuracy of the PEBS profiling result, because the "event IP"
> +		 * in the PEBS record is calibrated on the guest side.
> +		 */
> +		attr.precise_ip = 1;
> +	}
>  
>  	event = perf_event_create_kernel_counter(&attr, -1, current,
> -						 intr ? kvm_perf_overflow_intr :
> +						 (intr || pebs) ? kvm_perf_overflow_intr :
>  						 kvm_perf_overflow, pmc);

How would pebs && !intr be possible? Also; wouldn't this be more legible
when written like:

	perf_overflow_handler_t ovf = kvm_perf_overflow;

	...

	if (intr)
		ovf = kvm_perf_overflow_intr;

	...

	event = perf_event_create_kernel_counter(&attr, -1, current, ovf, pmc);

