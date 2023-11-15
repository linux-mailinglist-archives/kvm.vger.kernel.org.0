Return-Path: <kvm+bounces-1751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 807247EBD9E
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:18:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEC9C1C20B34
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47E5F9C8;
	Wed, 15 Nov 2023 07:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BW6DGWOF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CBCE542
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:18:12 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EB68E;
	Tue, 14 Nov 2023 23:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032691; x=1731568691;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K94+ZW5WqsqsHW+UUEKhHYET4SuOMIzEuNQ2zXPv0eg=;
  b=BW6DGWOFBtiEIxIqq3Us6Jq71Fr24895cWGHDQ5NDfBm4ggtUUgmhrcV
   4a9LzAta4m24RYZ9g7GHqTHOJqhxmJsPPowDrHno8a6phUsthLon6hSmb
   H6MVLmngGGZFcIanPa1f+Ti2Ko96NnDnscIJ5kYVYcUvgTfNKW1SXi5GW
   GoE7rRV19VzNgFBgqyN9uNKHo3ieFQOB0DcsPIUhEJ+BcvDMYzJxN5szD
   DnwdYYG+Hz8nfMyj51tRMRnXD3zi/9UqWiSFHDeiZJYgwDYHNEbxKUvAE
   CybfSUCBGgKwFo55OsEVLeaOXcaUkUs/UPK27s8n97fz28Tw+p6ISRP2B
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="3899959"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="3899959"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:18:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="799760959"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="799760959"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.39]) ([10.238.2.39])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:18:06 -0800
Message-ID: <ed24d2a9-ab37-4807-b6a9-802943007591@linux.intel.com>
Date: Wed, 15 Nov 2023 15:18:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/25] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To: seanjc@google.com, pbonzini@redhat.com
Cc: Yang Weijiang <weijiang.yang@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org,
 chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-13-weijiang.yang@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230914063325.85503-13-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/14/2023 2:33 PM, Yang Weijiang wrote:
> Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
> due to XSS MSR modification.
> CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
> xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
> before allocate sufficient xsave buffer.
>
> Note, KVM does not yet support any XSS based features, i.e. supported_xss
> is guaranteed to be zero at this time.
>
> Opportunistically modify XSS write access logic as: if !guest_cpuid_has(),
> write initiated from host is allowed iff the write is reset operaiton,
> i.e., data == 0, reject host_initiated non-reset write and any guest write.
Hi Sean & Polo,
During code review of Enable CET Virtualization v5 patchset, there were
discussions about "do a wholesale cleanup of all the cases that essentially
allow userspace to do KVM_SET_MSR before KVM_SET_CPUID2", i.e. force the 
order
between  KVM_SET_CPUID2 and KVM_SET_MSR, but allow the host_initiated 
path with
default (generally 0) value.
https://lore.kernel.org/kvm/ZM1C+ILRMCfzJxx7@google.com/
https://lore.kernel.org/kvm/CABgObfbvr8F8g5hJN6jn95m7u7m2+8ACkqO25KAZwRmJ9AncZg@mail.gmail.com/

I can take the task to do the code cleanup.
Before going any further, I want to confirm it is still the direction 
intended,
right?


>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
>   arch/x86/kvm/x86.c              | 13 +++++++++----
>   3 files changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0fc5e6312e93..d77b030e996c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -803,6 +803,7 @@ struct kvm_vcpu_arch {
>   
>   	u64 xcr0;
>   	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
>   
>   	struct kvm_pio_request pio;
>   	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 1f206caec559..4e7a820cba62 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -275,7 +275,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>   	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>   		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> +		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
> +						 vcpu->arch.ia32_xss, true);
>   
>   	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>   	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> @@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
>   	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>   }
>   
> +static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
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
>   static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
>   {
>   	struct kvm_cpuid_entry2 *entry;
> @@ -358,6 +370,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	}
>   
>   	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
> +	vcpu->arch.guest_supported_xss = vcpu_get_supported_xss(vcpu);
>   
>   	/*
>   	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1258d1d6dd52..9a616d84bd39 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3795,20 +3795,25 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			vcpu->arch.ia32_tsc_adjust_msr += adj;
>   		}
>   		break;
> -	case MSR_IA32_XSS:
> -		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> +	case MSR_IA32_XSS: {
> +		bool host_msr_reset = msr_info->host_initiated && data == 0;
> +
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
> +		    (!host_msr_reset || !msr_info->host_initiated))
>   			return 1;
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
>   		kvm_update_cpuid_runtime(vcpu);
>   		break;
> +	}
>   	case MSR_SMI_COUNT:
>   		if (!msr_info->host_initiated)
>   			return 1;


