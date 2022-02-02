Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C144A736F
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 15:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbiBBOnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 09:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345074AbiBBOna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 09:43:30 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E725C061714;
        Wed,  2 Feb 2022 06:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xufQ1Q9+1ygsCDJZkQhhHAWRleHJVLLr4QMMU3vcj5Y=; b=oOIEYjuILakE8XqGmGL6SEPV+T
        k3Z1T7J1Ni4TDwlzj9JH+w9eKYjh7JvxasFf6ZJvIa1yph2ueVL7S4jDGsdYSN9mZ3IcgWkHFaLYg
        5NgkC7K5e+UqFO0+2x1Gwk8mNXl9ip5gkrlIxJ1PbFckCa8t2JQJE4Hu5IgScl4LFXPizKTY00Fgd
        K2eEWXOMF6GJyrBZPoZPeNdjl1ITT+Z0Wu8qEw3CwTR0OPepSXztO4T1QFIA/FlvBlj8n6JjwZSic
        PKN89hiqv0IjCAfwi3Y2kZrGCfE8XR3WGmv/BEIG9EnNWxYkZyB/nqi8XkLqJbnQsJxT8N80DSrny
        ehaJ2xrQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nFGqk-006Dr6-1S; Wed, 02 Feb 2022 14:43:10 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id A2626984C61; Wed,  2 Feb 2022 15:43:08 +0100 (CET)
Date:   Wed, 2 Feb 2022 15:43:08 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Message-ID: <20220202144308.GB20638@worktop.programming.kicks-ass.net>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117085307.93030-3-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 17, 2022 at 04:53:06PM +0800, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Currently, we have [intel|knc|p4|p6]_perfmon_event_map on the Intel
> platforms and amd_[f17h]_perfmon_event_map on the AMD platforms.
> 
> Early clumsy KVM code or other potential perf_event users may have
> hard-coded these perfmon_maps (e.g., arch/x86/kvm/svm/pmu.c), so
> it would not make sense to program a common hardware event based
> on the generic "enum perf_hw_id" once the two tables do not match.
> 
> Let's provide an interface for callers outside the perf subsystem to get
> the counter config based on the perfmon_event_map currently in use,
> and it also helps to save bytes.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/events/core.c            | 9 +++++++++
>  arch/x86/include/asm/perf_event.h | 2 ++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 38b2c779146f..751048f4cc97 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -693,6 +693,15 @@ void x86_pmu_disable_all(void)
>  	}
>  }
>  
> +u64 perf_get_hw_event_config(int perf_hw_id)
> +{
> +	if (perf_hw_id < x86_pmu.max_events)
> +		return x86_pmu.event_map(perf_hw_id);
> +
> +	return 0;
> +}

Where does perf_hw_id come from? Does this need to be
array_index_nospec() ?

> +EXPORT_SYMBOL_GPL(perf_get_hw_event_config);

Urgh... hate on kvm being a module again. We really need something like
EXPORT_SYMBOL_KVM() or something.


>  struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
>  {
>  	return static_call(x86_pmu_guest_get_msrs)(nr);
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 8fc1b5003713..d1e325517b74 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -492,9 +492,11 @@ static inline void perf_check_microcode(void) { }
>  
>  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
>  extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
> +extern u64 perf_get_hw_event_config(int perf_hw_id);
>  extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
>  #else
>  struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
> +u64 perf_get_hw_event_config(int perf_hw_id);

I think Paolo already spotted this one.

>  static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>  {
>  	return -1;
> -- 
> 2.33.1
> 
