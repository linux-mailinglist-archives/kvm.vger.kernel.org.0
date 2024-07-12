Return-Path: <kvm+bounces-21480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C66C792F684
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47A3F1F23B6C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 07:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F22140E22;
	Fri, 12 Jul 2024 07:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gQ7mc+DE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC2A18E0E;
	Fri, 12 Jul 2024 07:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720770706; cv=none; b=AaG9PKg6VsRETBJ13pOVqAmjy9WqsDysiMhe/DNqGn510QVlnPYB3hc89JEZDT4ZN8mpj8F/7f84OBsiup5qO2o5WnxokTFVzPO6/AjurU+BOOeHZG0cqltOzSNNVgcVTQD6YC494yqK6YsuK4sPEdnIcXyNteo5kyDyYMe07Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720770706; c=relaxed/simple;
	bh=/WIurWJG+oKfW+i69cYnWTy8/zE+GskbYcFddxQcYq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDL8KXUJ0mrdUNcwgbzJe6n8pGmtc3bJtvELSpwIQSd2bh9Nm60AoZb6yMoag6ZHQOoFS+We8g2176y5TYyu/gCMl7IwRaTVtN2+xETcOfnHOXQ6YjMGPkdLN41jqdcxBdB+C1V67kIMLhYAuyPRDibSHGMKkhaz6YxoE/b4IDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gQ7mc+DE; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720770705; x=1752306705;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/WIurWJG+oKfW+i69cYnWTy8/zE+GskbYcFddxQcYq0=;
  b=gQ7mc+DE3AL0nOwMthyZoxE8cqYVtYNX9xagjkTE4GnhnTrBlTggc4K3
   IqddXKLZ+GAaG5NMi0H2fEAiZ+siV6fC15rnQlIcYNg63zzltUDs8rZxL
   G4zOicHrGydnrwN6xJa01/UbXyN3TAh2L1QJ19BELDbnSaD+oi820o7ye
   qVymfEQyKca5XMjH7bYgAetFtKpBs8vYMp06ROizfsCdtlcdB6QS7WZaH
   03NlGGtoz0mPsnI1bcUhhBQ/DzxnehPiLilyf2hQCuOExnhj0HbcIKece
   XyKmpGan9OttOXIsMA9l6y8BfqGvhiOH3rYSRR99r/3akHdH0KYm9Tz2X
   g==;
X-CSE-ConnectionGUID: DyuZ8dKDRjGPiJjcJ+TmSw==
X-CSE-MsgGUID: 9gSrHZceRPusW/4pYRQq/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="18403450"
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="18403450"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 00:51:45 -0700
X-CSE-ConnectionGUID: i8tcuoWoT3mwX1qLEIsMtA==
X-CSE-MsgGUID: AsTAu88CTI+WNwC/+gaFYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="79537595"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 00:51:41 -0700
Message-ID: <5a9d0c9c-ef97-4a77-b81b-a67bd27603aa@intel.com>
Date: Fri, 12 Jul 2024 15:51:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/49] KVM: x86: Reject disabling of MWAIT/HLT
 interception when not allowed
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-13-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240517173926.965351-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/18/2024 1:38 AM, Sean Christopherson wrote:
> Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT or
> HLT exits and KVM previously reported (via KVM_CHECK_EXTENSION) that
> disabling the exit(s) is not allowed.  E.g. because MWAIT isn't supported
> or the CPU doesn't have an aways-running APIC timer, or because KVM is
> configured to mitigate cross-thread vulnerabilities.
> 
> Cc: Kechen Lu <kechenl@nvidia.com>
> Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
> Fixes: 6f0f2d5ef895 ("KVM: x86: Mitigate the cross-thread return address predictions bug")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Just realize the same issue when reading the MWAIT code then find your 
this fix.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 54 ++++++++++++++++++++++++----------------------
>   1 file changed, 28 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4cb0c150a2f8..c729227c6501 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4590,6 +4590,20 @@ static inline bool kvm_can_mwait_in_guest(void)
>   		boot_cpu_has(X86_FEATURE_ARAT);
>   }
>   
> +static u64 kvm_get_allowed_disable_exits(void)
> +{
> +	u64 r = KVM_X86_DISABLE_EXITS_PAUSE;
> +
> +	if (!mitigate_smt_rsb) {
> +		r |= KVM_X86_DISABLE_EXITS_HLT |
> +			KVM_X86_DISABLE_EXITS_CSTATE;
> +
> +		if (kvm_can_mwait_in_guest())
> +			r |= KVM_X86_DISABLE_EXITS_MWAIT;
> +	}
> +	return r;
> +}
> +
>   #ifdef CONFIG_KVM_HYPERV
>   static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
>   					    struct kvm_cpuid2 __user *cpuid_arg)
> @@ -4726,15 +4740,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = KVM_CLOCK_VALID_FLAGS;
>   		break;
>   	case KVM_CAP_X86_DISABLE_EXITS:
> -		r = KVM_X86_DISABLE_EXITS_PAUSE;
> -
> -		if (!mitigate_smt_rsb) {
> -			r |= KVM_X86_DISABLE_EXITS_HLT |
> -			     KVM_X86_DISABLE_EXITS_CSTATE;
> -
> -			if (kvm_can_mwait_in_guest())
> -				r |= KVM_X86_DISABLE_EXITS_MWAIT;
> -		}
> +		r |= kvm_get_allowed_disable_exits();
>   		break;
>   	case KVM_CAP_X86_SMM:
>   		if (!IS_ENABLED(CONFIG_KVM_SMM))
> @@ -6565,33 +6571,29 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		break;
>   	case KVM_CAP_X86_DISABLE_EXITS:
>   		r = -EINVAL;
> -		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
> +		if (cap->args[0] & ~kvm_get_allowed_disable_exits())

sigh.

KVM_X86_DISABLE_VALID_EXITS has no user now. But we cannot remove it 
since it's in uapi header, right?

>   			break;
>   
>   		mutex_lock(&kvm->lock);
>   		if (kvm->created_vcpus)
>   			goto disable_exits_unlock;
>   
> -		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
> -			kvm->arch.pause_in_guest = true;
> -
>   #define SMT_RSB_MSG "This processor is affected by the Cross-Thread Return Predictions vulnerability. " \
>   		    "KVM_CAP_X86_DISABLE_EXITS should only be used with SMT disabled or trusted guests."
>   
> -		if (!mitigate_smt_rsb) {
> -			if (boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible() &&
> -			    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
> -				pr_warn_once(SMT_RSB_MSG);
> -
> -			if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
> -			    kvm_can_mwait_in_guest())
> -				kvm->arch.mwait_in_guest = true;
> -			if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
> -				kvm->arch.hlt_in_guest = true;
> -			if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
> -				kvm->arch.cstate_in_guest = true;
> -		}
> +		if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
> +		    cpu_smt_possible() &&
> +		    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
> +			pr_warn_once(SMT_RSB_MSG);
>   
> +		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
> +			kvm->arch.pause_in_guest = true;
> +		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
> +			kvm->arch.mwait_in_guest = true;
> +		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
> +			kvm->arch.hlt_in_guest = true;
> +		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
> +			kvm->arch.cstate_in_guest = true;
>   		r = 0;
>   disable_exits_unlock:
>   		mutex_unlock(&kvm->lock);


