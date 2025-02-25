Return-Path: <kvm+bounces-39127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B250A445DC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D15D188DC2E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 16:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4146518DB08;
	Tue, 25 Feb 2025 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HrSMdm5x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81571632C8;
	Tue, 25 Feb 2025 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740500352; cv=none; b=YFrv3m6f/9IJHifTyROcrHmLKdkGOXXXQ+gWLw4goT1Tq3UBvLkAW7OWgbd0YAukyiV8AIcovfjBAzixtDSndI7ldmLavfF07iLb0XLasFy6gGX4XCE1UU350L3psjOTM31CGvLdKRU2N9D2IOG6bjyUo0T9XgnJxIb43sU766k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740500352; c=relaxed/simple;
	bh=+EjWCET6v674qjOenEVjythFERNBnRl7O6pWOnch6gw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KXlm8s7BeabjYbJ5IwM5IK2P8nTJageX5r++5/jCkN4+3dBnl/27iz2CqPjTknKwAD0rSwWjuTZ4tAH8rrvE+nXPB3+6SEE6pzJyiqYfTek5tCWb6rnECzmf9dhLd+BTgRgpThLSlk9McRnREeb/a387neW+JGi/tkBS1zUbukA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HrSMdm5x; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740500351; x=1772036351;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+EjWCET6v674qjOenEVjythFERNBnRl7O6pWOnch6gw=;
  b=HrSMdm5xfC1d5cFb3/D6uUmYB65ZCvjCd51goE+fpDFGvYSFaonZSm+l
   e7aoqcn4P+vpNojt5aRGh0h1+PMTxiYTx9tu8knezt/uS57D4au8EhybV
   p1v+emHQnUYThBogzi/y2KNwWOgANEX+RqOm/ipVuskBuqQ2YK77HW0Fb
   LJAQWr0sGgjGSGJsiQfUI2E2VdgHuG8eNj+Jf65iKpCVhcWk5W+bzTJKt
   6EfMB1u3EydrfP0n88s8N9wjd1TzCpHbGtvRp46gBklkZBPFZ5ePc1h+P
   ++pmPwOvO0tekq/U1kzrEVHHV1GqJT9+bVyfAqJr+X5DC868TyVpBdjdu
   A==;
X-CSE-ConnectionGUID: NgtDAI5KQRSC/RolKto39w==
X-CSE-MsgGUID: PZuwV9SCQhOSiRE2GUy2+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="41160711"
X-IronPort-AV: E=Sophos;i="6.13,314,1732608000"; 
   d="scan'208";a="41160711"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 08:19:11 -0800
X-CSE-ConnectionGUID: jL2zoDiJSt+DLXjtBLT28A==
X-CSE-MsgGUID: jFDHBEY/SrqF2rf1DRcQFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="120546345"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 08:19:07 -0800
Message-ID: <5380c4fd-d0bd-4a20-8fb1-1ecad76e96b2@intel.com>
Date: Wed, 26 Feb 2025 00:19:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] KVM: x86: Snapshot the host's DEBUGCTL in common x86
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 rangemachine@gmail.com, whanos@sergal.fun,
 Ravi Bangoria <ravi.bangoria@amd.com>, Peter Zijlstra <peterz@infradead.org>
References: <20250224181315.2376869-1-seanjc@google.com>
 <20250224181315.2376869-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250224181315.2376869-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/2025 2:13 AM, Sean Christopherson wrote:
> Move KVM's snapshot of DEBUGCTL to kvm_vcpu_arch and take the snapshot in
> common x86, so that SVM can also use the snapshot.
> 
> Opportunistically change the field to a u64.  While bits 63:32 are reserved
> on AMD, not mentioned at all in Intel's SDM, and managed as an "unsigned
> long" by the kernel, DEBUGCTL is an MSR and therefore a 64-bit value.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/vmx/vmx.c          | 8 ++------
>   arch/x86/kvm/vmx/vmx.h          | 2 --
>   arch/x86/kvm/x86.c              | 1 +
>   4 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3506f497741b..02bffe6b54c8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -781,6 +781,7 @@ struct kvm_vcpu_arch {
>   	u32 pkru;
>   	u32 hflags;
>   	u64 efer;
> +	u64 host_debugctl;
>   	u64 apic_base;
>   	struct kvm_lapic *apic;    /* kernel irqchip context */
>   	bool load_eoi_exitmap_pending;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b71392989609..729c224b72dd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1514,16 +1514,12 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>    */
>   void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   {
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -
>   	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
>   		shrink_ple_window(vcpu);
>   
>   	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
>   
>   	vmx_vcpu_pi_load(vcpu, cpu);
> -
> -	vmx->host_debugctlmsr = get_debugctlmsr();
>   }
>   
>   void vmx_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -7458,8 +7454,8 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   	}
>   
>   	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
> -	if (vmx->host_debugctlmsr)
> -		update_debugctlmsr(vmx->host_debugctlmsr);
> +	if (vcpu->arch.host_debugctl)
> +		update_debugctlmsr(vcpu->arch.host_debugctl);
>   
>   #ifndef CONFIG_X86_64
>   	/*
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 8b111ce1087c..951e44dc9d0e 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -340,8 +340,6 @@ struct vcpu_vmx {
>   	/* apic deadline value in host tsc */
>   	u64 hv_deadline_tsc;
>   
> -	unsigned long host_debugctlmsr;
> -
>   	/*
>   	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
>   	 * msr_ia32_feature_control. FEAT_CTL_LOCKED is always included
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 58b82d6fd77c..09c3d27cc01a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4991,6 +4991,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   
>   	/* Save host pkru register if supported */
>   	vcpu->arch.host_pkru = read_pkru();
> +	vcpu->arch.host_debugctl = get_debugctlmsr();
>   
>   	/* Apply any externally detected TSC adjustments (due to suspend) */
>   	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {


