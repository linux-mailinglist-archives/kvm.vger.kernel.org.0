Return-Path: <kvm+bounces-48976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9564AD4EE9
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91896173175
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 08:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E85242D84;
	Wed, 11 Jun 2025 08:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V0agl7UH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95592BD11;
	Wed, 11 Jun 2025 08:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749632139; cv=none; b=GVOStwQ1MPgga4MqNB5LSUCUe50IBqDlJMxqDU5Hi4kSJ0jbCZhawmwAdzNtPyOD6WFFMkMVeuWnOh77/M7odxP1hjVxNyFARsEMrg9IqMoZeezjUNl2Cmxc0Q8O1SG7cB7Y0cP9B7XHEdn5+7SYV95yaReu1+Z15SrXLLKs6GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749632139; c=relaxed/simple;
	bh=0DZmRSZvljrpWkJwb291+ZV4LAGXR6iZSBRZw7lLpjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mVGa7i9aDEQ0kEI0MIZms6UcYVp7+aFgudL63TS/Qk9VHB7MQ2qBCf8qvrS3S5GRRupO4fX9H2n/2auWUwtcGBlPAqkKpM3K+aTXgXtWZjhIANGFTozsDvG8r6u7lvORB7jqiHW1Qa070QVMb+1VwkjNG8tYZImMx5535Fyl2Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V0agl7UH; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749632138; x=1781168138;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0DZmRSZvljrpWkJwb291+ZV4LAGXR6iZSBRZw7lLpjs=;
  b=V0agl7UHVmI/1G7zc26vwk61n9LwM2/rK9GWKG53bfUU/LSo2FLKiFm+
   VIRPN0OR4QvzcfrH/khOSBglRk0IgOXzNnqbgOuWU6x1lBKfLOLvrTkRF
   cP8yhoCCmXh3yDdxDXbh2MtIYwYKdQgF10SbsgrP+L7BNMz6LrpG0YAq7
   uUfqyHZqFNWdS/Ry+OW06LiL1fcz0rUGAx8KnAZUqK5K6+DkwcBTtuuF4
   XlMemjlwU4MOg9+R2K3Ua6YeWs9Yc+qD4sn6kIMcxi8iprrS+T9LdK7Wy
   dcaKA76ZmYKJaBVQKAS2kTeu2pB+1Kf2mKVVudp3I0wT53Gv8h3ENAl3D
   g==;
X-CSE-ConnectionGUID: zrp//KAdT8aFP62Azfpttg==
X-CSE-MsgGUID: iPHEGwsyRSGU7sSAbge+Gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="39385139"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="39385139"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 01:55:37 -0700
X-CSE-ConnectionGUID: VmO353wCQ7qxFE7k2Oh1xA==
X-CSE-MsgGUID: 9Lr0CUiUTA2HNgRQukFE0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="147625598"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 01:55:35 -0700
Message-ID: <44de2c92-3969-471a-970c-fcc751a0415a@linux.intel.com>
Date: Wed, 11 Jun 2025 16:55:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/8] KVM: VMX: Extract checking of guest's DEBUGCTL
 into helper
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
References: <20250610232010.162191-1-seanjc@google.com>
 <20250610232010.162191-6-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250610232010.162191-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/11/2025 7:20 AM, Sean Christopherson wrote:
> Move VMX's logic to check DEBUGCTL values into a standalone helper so that
> the code can be used by nested VM-Enter to apply the same logic to the
> value being loaded from vmcs12.
>
> KVM needs to explicitly check vmcs12->guest_ia32_debugctl on nested
> VM-Enter, as hardware may support features that KVM does not, i.e. relying
> on hardware to detect invalid guest state will result in false negatives.
> Unfortunately, that means applying KVM's funky suppression of BTF and LBR
> to vmcs12 so as not to break existing guests.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ab5c742db140..358c7036272a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2191,6 +2191,19 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
>  	return debugctl;
>  }
>  
> +static bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data,
> +				  bool host_initiated)
> +{
> +	u64 invalid;
> +
> +	invalid = data & ~vmx_get_supported_debugctl(vcpu, host_initiated);
> +	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
> +		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
> +		invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);

nit: add spaces around "|".

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


> +	}
> +	return !invalid;
> +}
> +
>  /*
>   * Writes msr value into the appropriate "register".
>   * Returns 0 on success, non-0 otherwise.
> @@ -2259,19 +2272,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		}
>  		vmcs_writel(GUEST_SYSENTER_ESP, data);
>  		break;
> -	case MSR_IA32_DEBUGCTLMSR: {
> -		u64 invalid;
> -
> -		invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
> -		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
> -			kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
> -			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> -			invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> -		}
> -
> -		if (invalid)
> +	case MSR_IA32_DEBUGCTLMSR:
> +		if (!vmx_is_valid_debugctl(vcpu, data, msr_info->host_initiated))
>  			return 1;
>  
> +		data &= vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
> +
>  		if (is_guest_mode(vcpu) && get_vmcs12(vcpu)->vm_exit_controls &
>  						VM_EXIT_SAVE_DEBUG_CONTROLS)
>  			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
> @@ -2281,7 +2287,6 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    (data & DEBUGCTLMSR_LBR))
>  			intel_pmu_create_guest_lbr_event(vcpu);
>  		return 0;
> -	}
>  	case MSR_IA32_BNDCFGS:
>  		if (!kvm_mpx_supported() ||
>  		    (!msr_info->host_initiated &&

