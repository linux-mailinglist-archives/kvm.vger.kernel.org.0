Return-Path: <kvm+bounces-57685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 25EBEB58EFF
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14B057B17A5
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFF52C1583;
	Tue, 16 Sep 2025 07:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l6IQULo+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B6B262FF6;
	Tue, 16 Sep 2025 07:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758007233; cv=none; b=C4h1zPxuOoulFxtSBLS+/9RMxGBxxMcUSnzTk5bqFvwpZGUc+y/7Grc4rpQlNRonEgHt+9dHxxe4KvloCeCPZKWupUWGMRICWWBe7fBrv2mL5V9H4yIpunmSeViDXuxfIP3fNfjkOfBn2PRS9k/Cg0pf8KrgTlIgxNrRSSCS2IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758007233; c=relaxed/simple;
	bh=37Fy6N+KfsDikO4TqwR4OWfPbZGWzuU4xuF6iKlsq8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EDMCoBPWBBq6fdhBCUa+H9ZBxMwUtRHLQLAlzleAHx/4QqvqxTu83wCUqdXyy/YUbmdJHEHeMpQhGMdiAJzqpXm+PAXQp6JLiw7rYgUFupWypToAJxSgX/OgmnIgxhX26rqVVoKZ+wOM2NhjDV3odnc2RKjf3T0aGSOkaDQoKRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l6IQULo+; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758007232; x=1789543232;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=37Fy6N+KfsDikO4TqwR4OWfPbZGWzuU4xuF6iKlsq8Y=;
  b=l6IQULo+rAGkpyjBOgzjvIisqWGZah+LeYiwLySiGxaRYbgWTTbsfUep
   mCwXDSUoz0ganH9gLvdbniuZS+svOMrXMpWgxUsJUq0sEksHDqz77RmnI
   q1nzFsOGeRLf1FKptrbyK+qsfC52eUsTqt7tW00NaDcn40XpK0Rf5fLSP
   9oabLWjbSp6eDfoB/2xFlUQebh+f2bpoydGRv9YKrLK1G5Va3IBKErAkG
   4pmuiozprA/wNAfoWhKSZoJGQ39XoJAa2HLNdwispveI3yaNr464Za0nr
   R+3vWsrcr7H1Bcsh5k3PyIni+i4IOyqwfbg5FmuCKx0LsPGNpjqkXK+3x
   w==;
X-CSE-ConnectionGUID: 8OU0KaHLQuSZ10thYvh2RA==
X-CSE-MsgGUID: pDtg81EtT2S4FzYxPI+Yjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="71704915"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="71704915"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:20:31 -0700
X-CSE-ConnectionGUID: W4Z+oqg6TPqTeg691iEvkQ==
X-CSE-MsgGUID: bohQPtd2QFiN9wRdst0C6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="205644703"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:20:29 -0700
Message-ID: <fd6f995a-ce95-4dde-88ef-06678dd18744@linux.intel.com>
Date: Tue, 16 Sep 2025 15:20:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 06/41] KVM: x86: Check XSS validity against guest
 CPUIDs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-7-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Chao Gao <chao.gao@intel.com>
>
> Maintain per-guest valid XSS bits and check XSS validity against them
> rather than against KVM capabilities. This is to prevent bits that are
> supported by KVM but not supported for a guest from being set.
>
> Opportunistically return KVM_MSR_RET_UNSUPPORTED on IA32_XSS MSR accesses
> if guest CPUID doesn't enumerate X86_FEATURE_XSAVES. Since
> KVM_MSR_RET_UNSUPPORTED takes care of host_initiated cases, drop the
> host_initiated check.
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h |  3 ++-
>   arch/x86/kvm/cpuid.c            | 12 ++++++++++++
>   arch/x86/kvm/x86.c              |  7 +++----
>   3 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2762554cbb7b..d931d72d23c9 100644
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
> +	u64 ia32_xss;
> +	u64 guest_supported_xss;
>   
>   	struct kvm_pio_request pio;
>   	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index ad6cadf09930..46cf616663e6 100644
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
> @@ -424,6 +435,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	}
>   
>   	vcpu->arch.guest_supported_xcr0 = cpuid_get_supported_xcr0(vcpu);
> +	vcpu->arch.guest_supported_xss = cpuid_get_supported_xss(vcpu);
>   
>   	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3b4258b38ad8..5a5af40c06a9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3984,15 +3984,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
>   		vcpu->arch.ia32_xss = data;
>   		vcpu->arch.cpuid_dynamic_bits_dirty = true;


