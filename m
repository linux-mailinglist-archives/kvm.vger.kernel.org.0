Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7EA2F51B5
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 19:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbhAMSJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 13:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbhAMSJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 13:09:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824D8C061795;
        Wed, 13 Jan 2021 10:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jNibCvTx7q4DNq2LFCvJgnHxHkRHf0XgjGUF5aOVsQg=; b=nPh9SFDH0qvl6QN7IJFB0c5GI1
        JqsCAQ2HZQVdv9513XN7ehbo/8oXe+FRG/YL9EY1MiYteYeztRRffMpXvXEfsqwDVpbF/a91kqN/G
        qjbEzNcB7aagKoT530bItc0fY6LOGR3e43Q6QrNpJwLy59H//jebViet5n52pXhF5gjWctcVkORx/
        i8GG7MJdR3Hg1RkQiOJieeEMcrc4CMfdoCeK3emAb4mg7GUYwkTXrNtkS9wlvNHleGxWTQZm6ZJhs
        B3GZcJ6IGPIM/Alek4XlO4caXFXROifkRE2qDK2Ti0G8Hf8hjD1nUHL1izYjk/aJGhInqxPnuiwtY
        5jtvzItQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzkXI-006Y9v-Th; Wed, 13 Jan 2021 18:06:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6AF1C3010C8;
        Wed, 13 Jan 2021 19:06:20 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ACB4620CC02C7; Wed, 13 Jan 2021 19:06:20 +0100 (CET)
Date:   Wed, 13 Jan 2021 19:06:20 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/17] KVM: x86/pmu: Introduce the ctrl_mask value for
 fixed counter
Message-ID: <X/82nCHfFH0TVur2@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-4-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104131542.495413-4-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 04, 2021 at 09:15:28PM +0800, Like Xu wrote:
> @@ -327,6 +328,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
>  	pmu->version = 0;
>  	pmu->reserved_bits = 0xffffffff00200000ull;
> +	pmu->fixed_ctr_ctrl_mask = ~0ull;

All 1s

>  
>  	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
>  	if (!entry)
> @@ -358,6 +360,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  			((u64)1 << edx.split.bit_width_fixed) - 1;
>  	}
>  
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> +		pmu->fixed_ctr_ctrl_mask |= (0xbull << (i * 4));

With some extra 1s on top

> +	pmu->fixed_ctr_ctrl_mask = ~pmu->fixed_ctr_ctrl_mask;

Inverted is all 0s, always.

>  	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
>  		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
>  	pmu->global_ctrl_mask = ~pmu->global_ctrl;
> -- 
> 2.29.2
> 
