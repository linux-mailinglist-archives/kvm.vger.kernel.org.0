Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914351B7169
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 12:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgDXKCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 06:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726193AbgDXKCi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 06:02:38 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A678C09B045;
        Fri, 24 Apr 2020 03:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iPgS037mNuGvOYOpwoSf1H/SfmbqTuuOMcYJNVtGJDI=; b=N4R7qIENToOsIMIszN0piefZdS
        2/V8uPlGpM1eSpjZV9jU7iBzEBFYlR2nc3k4M9iY5pHLt7x+6LFFEYiNtDpxL1u6NCoZ1SSRoq4MC
        4V620UaJ1I5+ORn4seM/IPAsDckj5M52yBHsu+67CjjqzxaHBM/EY8wZKpdoEnv7DYJZCL5ewQfgg
        qTTtkicv5fLDkxYXQECiXioyxjxqHgtBMCBBhaSImsDUEo6wut7MTvd1azRa2mgIPawK7ZgVWX9Te
        oFvp9LbQggANylejedo3TyR1ZzQD0Qn9w39ZIMJZsaBSFHWab7a0dMwyUa2bqw6P+cFD04Nrc7zex
        AOreSQ8Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRv9X-0006sU-7O; Fri, 24 Apr 2020 10:01:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 88B4E300B38;
        Fri, 24 Apr 2020 12:01:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5F4B320325E18; Fri, 24 Apr 2020 12:01:43 +0200 (CEST)
Date:   Fri, 24 Apr 2020 12:01:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        joro@8bytes.org, jmattson@google.com, wanpengli@tencent.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: Re: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF registers
Message-ID: <20200424100143.GZ20730@hirez.programming.kicks-ass.net>
References: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 01:08:55PM +0800, Li RongQing wrote:
> Guest kernel reports a fixed cpu frequency in /proc/cpuinfo,
> this is confused to user when turbo is enable, and aperf/mperf
> can be used to show current cpu frequency after 7d5905dc14a
> "(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
> so we should emulate aperf mperf to achieve it
> 
> the period of aperf/mperf in guest mode are accumulated
> as emulated value
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 +++++
>  arch/x86/kvm/cpuid.c            |  5 ++++-
>  arch/x86/kvm/vmx/vmx.c          | 20 ++++++++++++++++++++
>  3 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d3984a..526bd13a3d3d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -820,6 +820,11 @@ struct kvm_vcpu_arch {
>  
>  	/* AMD MSRC001_0015 Hardware Configuration */
>  	u64 msr_hwcr;
> +
> +	u64 host_mperf;
> +	u64 host_aperf;
> +	u64 v_mperf;
> +	u64 v_aperf;
>  };
>  
>  struct kvm_lpage_info {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 901cd1fdecd9..00e4993cb338 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -558,7 +558,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	case 6: /* Thermal management */
>  		entry->eax = 0x4; /* allow ARAT */
>  		entry->ebx = 0;
> -		entry->ecx = 0;
> +		if (boot_cpu_has(X86_FEATURE_APERFMPERF))
> +			entry->ecx = 0x1;
> +		else
> +			entry->ecx = 0x0;
>  		entry->edx = 0;
>  		break;
>  	/* function 7 has additional index. */

AFAICT this is generic x86 code, that is, this will tell an AMD SVM
guest it has APERFMPERF on.

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 91749f1254e8..f20216fc0b57 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1064,6 +1064,11 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
>  
>  static void pt_guest_enter(struct vcpu_vmx *vmx)
>  {
> +	struct kvm_vcpu *vcpu = &vmx->vcpu;
> +
> +	rdmsrl(MSR_IA32_MPERF, vcpu->arch.host_mperf);
> +	rdmsrl(MSR_IA32_APERF, vcpu->arch.host_aperf);
> +
>  	if (vmx_pt_mode_is_system())
>  		return;
>  
> @@ -1081,6 +1086,15 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
>  
>  static void pt_guest_exit(struct vcpu_vmx *vmx)
>  {
> +	struct kvm_vcpu *vcpu = &vmx->vcpu;
> +	u64 perf;
> +
> +	rdmsrl(MSR_IA32_MPERF, perf);
> +	vcpu->arch.v_mperf += perf - vcpu->arch.host_mperf;
> +
> +	rdmsrl(MSR_IA32_APERF, perf);
> +	vcpu->arch.v_aperf += perf - vcpu->arch.host_aperf;
> +
>  	if (vmx_pt_mode_is_system())
>  		return;
>  
> @@ -1914,6 +1928,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>  			return 1;
>  		goto find_shared_msr;
> +	case MSR_IA32_MPERF:
> +		msr_info->data = vcpu->arch.v_mperf;
> +		break;
> +	case MSR_IA32_APERF:
> +		msr_info->data = vcpu->arch.v_aperf;
> +		break;
>  	default:
>  	find_shared_msr:
>  		msr = find_msr_entry(vmx, msr_info->index);

But then here you only emulate it for VMX, which then results in SVM
guests going wobbly.

Also, on Intel, the moment you advertise APERFMPERF, we'll try and read
MSR_PLATFORM_INFO / MSR_TURBO_RATIO_LIMIT*, I don't suppose you're
passing those through as well?


