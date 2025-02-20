Return-Path: <kvm+bounces-38663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E58A3D750
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69E847A718D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 10:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F80C1F153C;
	Thu, 20 Feb 2025 10:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lM0PsO6X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF38F1F1524;
	Thu, 20 Feb 2025 10:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740048628; cv=none; b=V6c4wNeORL8TxW1dEIOPZmHkpgUQ/K+MyFRXvDDH2HVKeuoH7wSCmS16VK4TP1QK0v886fSzeyDETs7BuFw5b+kfVEEdH9xucT/8ICFRWCrYR2Dxsgl2TQe5yzGaHlhhbwJ92FtD4ZXMoESstRSWzUf3gZUfWnF6fFCR34QJkRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740048628; c=relaxed/simple;
	bh=dQfui+x7NqLkRgd6EX70wAU8MmIduNsHqM4NpPGsIlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rNf8fLbKe9zNMQnArBW9nbrbTW9RaOERCRiUTBcKDCXTf6uP9igiChgtxlbdDxUbQ0eEaC604xOky5LzBy0dh2FjaLnlzgqbv9XJ3wXOjR7LeIqT5DipFM7R469fcrQ2rTUdiyHVzqU3qVgJxVsskF+Z05HhbgYjtwf0xL9vd5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lM0PsO6X; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740048627; x=1771584627;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dQfui+x7NqLkRgd6EX70wAU8MmIduNsHqM4NpPGsIlc=;
  b=lM0PsO6X015anHKa/r2veifUW8b1YvyhtTtv3YwfCzFMdIziOR++vLEU
   NW9ajJMVIMTLnHRtrEXotjUgAxMcY/2lXcsgWadZ0t3R3unMq5rPkTLfA
   IpIeH3TZ7a+IS4RpvLCAPdijjZ9Xt3uog6v4pvvXSnDiL9l/HfFewVNls
   uwui10tTd2RIOr9RC0JCcLyPKzmC7OkAMIjBMNQCkmf/qJS3wQd6wFPu5
   TAGwg9ibRy/xy6ENC9fAWL9g2O5LUBb2OKn2O7ObLT5HdHm2nj924heXp
   VnhOMSvEBEpaDQnBbsuQAoVCcSuumY4sbiGR3pUitIXko8Lkacfj+w/U6
   w==;
X-CSE-ConnectionGUID: ouejZNTmToa/IL0816HAKA==
X-CSE-MsgGUID: lHFp5K+UQiuNfkibLf9DdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="40052254"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="40052254"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:50:26 -0800
X-CSE-ConnectionGUID: T+4ENf0XQq6u9oBVHB+plQ==
X-CSE-MsgGUID: 4XqSrFUAS42XuN8Yxa4O3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="145854374"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:50:20 -0800
Message-ID: <01e85b96-db63-4de2-9f49-322919e054ec@intel.com>
Date: Thu, 20 Feb 2025 18:50:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 02/12] KVM: x86: Allow the use of
 kvm_load_host_xsave_state() with guest_state_protected
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-3-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250129095902.16391-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/2025 5:58 PM, Adrian Hunter wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Allow the use of kvm_load_host_xsave_state() with
> vcpu->arch.guest_state_protected == true. This will allow TDX to reuse
> kvm_load_host_xsave_state() instead of creating its own version.
> 
> For consistency, amend kvm_load_guest_xsave_state() also.
> 
> Ensure that guest state that kvm_load_host_xsave_state() depends upon,
> such as MSR_IA32_XSS, cannot be changed by user space, if
> guest_state_protected.
> 
> [Adrian: wrote commit message]
> 
> Link: https://lore.kernel.org/r/Z2GiQS_RmYeHU09L@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
> TD vcpu enter/exit v2:
>   - New patch
> ---
>   arch/x86/kvm/svm/svm.c |  7 +++++--
>   arch/x86/kvm/x86.c     | 18 +++++++++++-------
>   2 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7640a84e554a..b4bcfe15ad5e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4253,7 +4253,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>   		svm_set_dr6(svm, DR6_ACTIVE_LOW);
>   
>   	clgi();
> -	kvm_load_guest_xsave_state(vcpu);
> +
> +	if (!vcpu->arch.guest_state_protected)
> +		kvm_load_guest_xsave_state(vcpu);
>   
>   	kvm_wait_lapic_expire(vcpu);
>   
> @@ -4282,7 +4284,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>   	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>   		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
>   
> -	kvm_load_host_xsave_state(vcpu);
> +	if (!vcpu->arch.guest_state_protected)
> +		kvm_load_host_xsave_state(vcpu);
>   	stgi();
>   
>   	/* Any pending NMI will happen here */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bbb6b7f40b3a..5cf9f023fd4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1169,11 +1169,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
>   
>   void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>   {
> -	if (vcpu->arch.guest_state_protected)
> -		return;
> +	WARN_ON_ONCE(vcpu->arch.guest_state_protected);
>   
>   	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
> -
>   		if (vcpu->arch.xcr0 != kvm_host.xcr0)
>   			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>   
> @@ -1192,13 +1190,11 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>   
>   void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>   {
> -	if (vcpu->arch.guest_state_protected)
> -		return;
> -
>   	if (cpu_feature_enabled(X86_FEATURE_PKU) &&
>   	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>   	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
> -		vcpu->arch.pkru = rdpkru();
> +		if (!vcpu->arch.guest_state_protected)
> +			vcpu->arch.pkru = rdpkru();

this needs justification.

>   		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
>   			wrpkru(vcpu->arch.host_pkru);
>   	}


> @@ -3916,6 +3912,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (!msr_info->host_initiated &&
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>   			return 1;
> +
> +		if (vcpu->arch.guest_state_protected)
> +			return 1;
> +

this and below change need to be a separate patch. So that we can 
discuss independently.

I see no reason to make MSR_IA32_XSS special than other MSRs. When 
guest_state_protected, most of the MSRs that aren't emulated by KVM are 
inaccessible by KVM.

>   		/*
>   		 * KVM supports exposing PT to the guest, but does not support
>   		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
> @@ -4375,6 +4375,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (!msr_info->host_initiated &&
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>   			return 1;
> +
> +		if (vcpu->arch.guest_state_protected)
> +			return 1;
> +
>   		msr_info->data = vcpu->arch.ia32_xss;
>   		break;
>   	case MSR_K7_CLK_CTL:


