Return-Path: <kvm+bounces-17920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5058CBAA0
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 07:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0675F282C45
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 05:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D24F77105;
	Wed, 22 May 2024 05:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jrOTd2kX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1177922086;
	Wed, 22 May 2024 05:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716354572; cv=none; b=uMhKTgQHtntSfub3O6TBgCppZVh5VeJxwqaM6SkKZTx96jG+JEi2oUnEO+ODt+aSJDFOlLHh9vTYyRnw1JZAqBUp7qPOI01RoT3MIIDfmq8bZAg35g4r16PwsnoTREzXlE1FbSGBnEdmYaPK/VigVA/89ga5IHcdApuO8Y7zw4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716354572; c=relaxed/simple;
	bh=5yMQt29GiX4QLWSZnaoUlqn2FUv+SMQYFbAoLq8shn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gGYWc3YqQBgPqQ8fgmVyu/pezDrJzG/76yXoVYMkiW1x67Ow8nbyjloU3WwuW5hbs2swo5WeWlIRn9LgEQLnRoQf4stylz4W2bO+C+Rv+xmZl7CU1b+jn2mwygid7Faii1FZY/xiC6aMqY6LY3tgJMElzdCh1Gy/VxZnmbaUEyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jrOTd2kX; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716354571; x=1747890571;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5yMQt29GiX4QLWSZnaoUlqn2FUv+SMQYFbAoLq8shn0=;
  b=jrOTd2kX7GFx6g2coWXlwSQ2OPXHxTwhCjzeumaBMR2KBWifyFFtWqBe
   CwypoKValDJxrS/wgJOKptL0fkgSkzfmTbycSGZFE9qK3yNRq4tie0m7y
   YqTpNvk6eU/UujvxZOvuZZ0xocXtWUvmlNSdgQh1vKmD70m5O2JRWtCu2
   dZKErSP25gnd39/M7ShhZMbSkluECns9k3aylO7REqS8sqoKINe0rRUwF
   Egjj5u1C7b4Tacy8V/2qD6zoO1824MwWuOconE3E1b8ZVC8/OS010mdqd
   LmppXdzEYeMQk7VU6BYL8FS1qGWaal8loyjeycEUUIH7+oaRziw+TPy7y
   Q==;
X-CSE-ConnectionGUID: bMrLr6YrRD+nicZcZFVnLQ==
X-CSE-MsgGUID: Uv03fCIWSJaDjIUTheu02g==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12696599"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12696599"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 22:09:30 -0700
X-CSE-ConnectionGUID: SPXqoh8cTNyio1ipcb/jnQ==
X-CSE-MsgGUID: NV0A7hRJTH++l9KJcLFJQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33080563"
Received: from unknown (HELO [10.238.8.173]) ([10.238.8.173])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 22:09:27 -0700
Message-ID: <18f52be4-6449-4761-a178-1ca87124c28d@linux.intel.com>
Date: Wed, 22 May 2024 13:09:25 +0800
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
 Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-13-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240517173926.965351-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/18/2024 1:38 AM, Sean Christopherson wrote:
> Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT or
> HLT exits and KVM previously reported (via KVM_CHECK_EXTENSION) that
> disabling the exit(s) is not allowed.  E.g. because MWAIT isn't supported
> or the CPU doesn't have an aways-running APIC timer, or because KVM is

aways-running -> always-running

> configured to mitigate cross-thread vulnerabilities.
>
> Cc: Kechen Lu <kechenl@nvidia.com>
> Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
> Fixes: 6f0f2d5ef895 ("KVM: x86: Mitigate the cross-thread return address predictions bug")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
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

Nit: Just use "=".

>   		break;
>   	case KVM_CAP_X86_SMM:
>   		if (!IS_ENABLED(CONFIG_KVM_SMM))
> @@ -6565,33 +6571,29 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		break;
>   	case KVM_CAP_X86_DISABLE_EXITS:
>   		r = -EINVAL;
> -		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
> +		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
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


