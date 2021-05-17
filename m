Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13F2382D6B
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhEQN2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 09:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbhEQN2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 09:28:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B10C061573;
        Mon, 17 May 2021 06:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1TkaZMCH4yU+NNIwz6Q7XkI/dtRqVzRXjzjhd8deeS4=; b=eUv4w/6y+TmCqLanxh4zcXig9e
        ub0gCJacdgHQaQlH4W7PJM+ot+4/rQabSVoABRPfwlq08nStwh7edm/dGsg+ecq2jOPDj0ih5LRGX
        +4WSmEFqmB6f9jhkYa+CD9+Jiqw5tvKfYBu4wVrIn9/yD6JGsFgCiMaXCMrb3NSHNr8OonAn084R1
        dqYuNmAG2V2ZhVvgFqOAoD6sV+z8KwJ39rW+ybfawjnLQ8TR01ggvQQHOqibWdI8hKb7ntMkdgGpE
        NDKcs/pxVj9cznhm34mKROc7Xyza/dVp+wMcjv3p7JEp5QSbM922yZjQHXotDfNdH6llcc/V48IaG
        AT9HqXwg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lidGY-00F4UM-WD; Mon, 17 May 2021 13:26:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4010530022C;
        Mon, 17 May 2021 15:26:35 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 21ACB2028F05C; Mon, 17 May 2021 15:26:35 +0200 (CEST)
Date:   Mon, 17 May 2021 15:26:35 +0200
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
Subject: Re: [PATCH v6 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 support guest DS
Message-ID: <YKJvC5T5UOoCFwhL@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-9-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511024214.280733-9-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 10:42:06AM +0800, Like Xu wrote:
> @@ -3897,6 +3898,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  {
>  	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>  	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
> +	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
> +	struct kvm_pmu *pmu = (struct kvm_pmu *)data;

You can do without the cast, this is C, 'void *' silently casts to any
other pointer type.

>  	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
>  	u64 pebs_mask = (x86_pmu.flags & PMU_FL_PEBS_ALL) ?
>  		cpuc->pebs_enabled : (cpuc->pebs_enabled & PEBS_COUNTER_MASK);

> @@ -3931,6 +3934,12 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  	if (!x86_pmu.pebs_vmx)
>  		return arr;
>  
> +	arr[(*nr)++] = (struct perf_guest_switch_msr){
> +		.msr = MSR_IA32_DS_AREA,
> +		.host = (unsigned long)ds,

Using:
		(unsigned long)cpuc->ds;

was too complicated? :-)

> +		.guest = pmu->ds_area,
> +	};
> +
>  	arr[*nr] = (struct perf_guest_switch_msr){
>  		.msr = MSR_IA32_PEBS_ENABLE,
>  		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
