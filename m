Return-Path: <kvm+bounces-56254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A6F0B3B39E
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 08:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97A8CA0023D
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 06:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49C0261B67;
	Fri, 29 Aug 2025 06:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eiu+GQLU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545AE223DD4;
	Fri, 29 Aug 2025 06:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756450067; cv=none; b=o557ffDL58JlirDDuEKutK/lyrASRE3D6FhWyyeKn/XWw5j3sNZ6qztdsVsksdmsyisX/6gU58YlwnEe6fjQ7/U0o28azIPCizw660bV+vmC+v0/n8CFY62/6S5CWgDfIrIrhLi1tl18QOJqyhtdAe31PQGtL3kNeL34bN86YP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756450067; c=relaxed/simple;
	bh=O/HE1gXeCkYVe/aIJCE4hHocKjAPsMCTpkKYu+FXid8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iwy8WJ5rSR9vd7fHYstN57e34fwnOij95mXTiJu9204F1zd6gLTMyW7TDc3XHMYHI/P8q0Lq5djtaaSNKvk9x0loVyYTdi2APFZ9jdouRpktHS5TeGoyXdeyuML7CNV72je9rzt9A87xOdwpWATi5f0sKmSmfMSk+zIcTFQ+qLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eiu+GQLU; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756450065; x=1787986065;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O/HE1gXeCkYVe/aIJCE4hHocKjAPsMCTpkKYu+FXid8=;
  b=Eiu+GQLUNqRWSMetv7xpe1zp/o23Jm0Y2pY4a3rI0hKNjtKjC2HZDW8F
   kgiKJuH65Itg0YVMbt2lhGbMHois0/nyIWO4CuAmGq+0IF/ciLmoABpu/
   FrsQQm8YxHwCPzd5+3fRwhAOAZSSGXf/1BK4B9wUAfjmuZMHpLDkvse3h
   Op9McUvO/A0Hsc1XmiS0AGt2lMUmMNwah0obL9jXjVWIZK0E5MVRZg1lk
   +xWU9LcTtOr077zXABd1HRYG+FnD/n+b3fE4AenAN7YFF8r1dTvu9uOoh
   pAOO3wPoVguIjN2lK/M2ewziHsQ9Fa8UrJ6gg/uc2MqdygRxwsETpk9cx
   g==;
X-CSE-ConnectionGUID: vw/7fByeT7uGaCYlABrGOQ==
X-CSE-MsgGUID: aB/mN/RERWWdfMkSdnMsww==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58834830"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58834830"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:47:45 -0700
X-CSE-ConnectionGUID: OvIAedLFSwO/vmdlcuuH7g==
X-CSE-MsgGUID: UsBGxirhSOG7pGVoIXXeNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170207683"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:47:40 -0700
Message-ID: <5cc4f58d-d122-43ca-98ec-eabdbe5bf110@intel.com>
Date: Fri, 29 Aug 2025 14:47:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 03/21] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 john.allen@amd.com, mingo@redhat.com, minipli@grsecurity.net,
 mlevitsk@redhat.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, tglx@linutronix.de, weijiang.yang@intel.com,
 x86@kernel.org, xin@zytor.com, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-4-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250821133132.72322-4-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/2025 9:30 PM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
> due to XSS MSR modification.
> CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
> xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
> before allocate sufficient xsave buffer.
> 
> Note, KVM does not yet support any XSS based features, i.e. supported_xss
> is guaranteed to be zero at this time.
> 
> Opportunistically return KVM_MSR_RET_UNSUPPORTED if guest CPUID doesn't
> enumerate it. Since KVM_MSR_RET_UNSUPPORTED takes care of host_initiated
> cases, drop the host_initiated check.

It looks most of this patch is introducing

   vcpu->arch.guest_supported_xss

and use it to guard the wrmsr of MSR_IA32_XSS instead of KVM global 
kvm_caps.supported_xss.

So it's better to split it into two patches?

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 ++-
>   arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
>   arch/x86/kvm/x86.c              |  9 +++++----
>   3 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0d3cc0fc27af..b7f82a421718 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -815,7 +815,6 @@ struct kvm_vcpu_arch {
>   	bool at_instruction_boundary;
>   	bool tpr_access_reporting;
>   	bool xfd_no_write_intercept;
> -	u64 ia32_xss;
>   	u64 microcode_version;
>   	u64 arch_capabilities;
>   	u64 perf_capabilities;
> @@ -876,6 +875,8 @@ struct kvm_vcpu_arch {
>   
>   	u64 xcr0;
>   	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
> +	u64 ia32_xss;
>   
>   	struct kvm_pio_request pio;
>   	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index ad6cadf09930..b5f87254ced7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -263,6 +263,17 @@ static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
>   	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>   }
>   
> +static u64 cpuid_get_supported_xss(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpuid_entry2 *best;
> +
> +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
> +	if (!best)
> +		return 0;
> +
> +	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
> +}
> +
>   static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
>   						       struct kvm_cpuid_entry2 *entry,
>   						       unsigned int x86_feature,
> @@ -305,7 +316,8 @@ static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>   	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
>   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>   		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> +		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
> +						 vcpu->arch.ia32_xss, true);
>   }
>   
>   static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
> @@ -424,6 +436,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	}
>   
>   	vcpu->arch.guest_supported_xcr0 = cpuid_get_supported_xcr0(vcpu);
> +	vcpu->arch.guest_supported_xss = cpuid_get_supported_xss(vcpu);
>   
>   	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 569583943779..75b7a29721bb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4011,16 +4011,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		}
>   		break;
>   	case MSR_IA32_XSS:
> -		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> -			return 1;
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> +			return KVM_MSR_RET_UNSUPPORTED;
>   		/*
>   		 * KVM supports exposing PT to the guest, but does not support
>   		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>   		 * XSAVES/XRSTORS to save/restore PT MSRs.
>   		 */
> -		if (data & ~kvm_caps.supported_xss)
> +		if (data & ~vcpu->arch.guest_supported_xss)
>   			return 1;
> +		if (vcpu->arch.ia32_xss == data)
> +			break;
>   		vcpu->arch.ia32_xss = data;
>   		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>   		break;


