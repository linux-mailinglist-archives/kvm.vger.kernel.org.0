Return-Path: <kvm+bounces-7940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A83E7848A59
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 03:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09E081F23608
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 02:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 049CA17CE;
	Sun,  4 Feb 2024 02:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XheSH94v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540E910F7;
	Sun,  4 Feb 2024 02:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707012054; cv=none; b=D5eteMyG6cOqPTTEH6Y0Ek4/MLW8wIhC+eoIWTKx+00M61BLJp9vtJha8Yz7vEHVBsU2jRhHXSXqJWPGFnYyqhOAmGiCc2801qVNuBWmHzTQ2Ls42DSa/yV5mJY/ED2RJxLOrTw4Xzs2Hm+pyRP1Qr0CbotLwprYHT4NQJlOi6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707012054; c=relaxed/simple;
	bh=+rf6PU3RLo3ZUiTjf43C+X38tPNp6EdKyNz3q5sslBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q1DEW1PKIH/kwLvu3ERE5wjMoSbNXzThUGPOrml394PGsWrMhUWT6KwzfLM4XMenaLXsZcHx9EzQfDosmQ+T4jDo3LACNkomTenOVdjhAdntITTzKwrNQkADkoev3q7QtSyULBsFlvzJlXK/W/hM6TQ2bqDlqMdiD4KEJlkbSCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XheSH94v; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707012052; x=1738548052;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+rf6PU3RLo3ZUiTjf43C+X38tPNp6EdKyNz3q5sslBY=;
  b=XheSH94vOOu1ygLOumL237N+PlPksSCYHlNMdgB6PlaHkzMzpR/DzOad
   bGeFJkI1OA5oLyxCw3fd3kODybkhELxH9SyOxvmYRBMC6w9x5NgXhvPBm
   7kBF3GCaWQczzVXx+rD0cpQP6PUNC53IMUPP6QFbeXctTIFmPG/A/mfs7
   hpH1bIdwaltFg7NghzRhepWqIIAopUj7erHm6TJHAF8vGiBCIxGAltVxP
   NUG8KbTpRouSYDhFZOm6OKoZR+9E3DaTkKDWOPQOF4mYe/cJQi4putnho
   +mjE73PANCr5FyL720+ySwx5l6g8EGwcKbHGmXmIpLhs0G6eKoUtCX5EY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10973"; a="531191"
X-IronPort-AV: E=Sophos;i="6.05,241,1701158400"; 
   d="scan'208";a="531191"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 18:00:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,241,1701158400"; 
   d="scan'208";a="403427"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 18:00:48 -0800
Message-ID: <33ef0842-f91f-4c70-821c-0fa41b1d5e6e@linux.intel.com>
Date: Sun, 4 Feb 2024 10:00:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 023/121] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
 Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>,
 Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <ed33ebe29b231e8e657cd610a983fa603b10f530.1705965634.git.isaku.yamahata@intel.com>
 <7cc28677-f7d1-4aba-8557-66c685115074@linux.intel.com>
 <20240201061622.hvun7amakvbplmsb@yy-desk-7060>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240201061622.hvun7amakvbplmsb@yy-desk-7060>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/1/2024 2:16 PM, Yuan Yao wrote:
> On Wed, Jan 24, 2024 at 09:17:15AM +0800, Binbin Wu wrote:
>>
>> On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> TDX has its own limitation on the maximum number of vcpus that the guest
>>> can accommodate.  Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
>>> handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  user space VMM,
>>> e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.
>> For legacy VM, KVM just provides the interface to query the max_vcpus.
>> Why TD needs to provide a interface for userspace to set the limitation?
>> What's the scenario?
> I think the reason is TDH.MNG.INIT needs it:
>
> TD_PARAMS:
>      MAX_VCPUS:
>          offset: 16 bytes.
>          type: Unsigned 16b Integer.
>          size: 2.
>          Description: Maximum number of VCPUs.
Thanks for explanation.

I am also wondering if this info can be passed via KVM_TDX_INIT_VM.
Because userspace is allowed to set the value no greater than
min(KVM_MAX_VCPUS, TDX_MAX_VCPUS), providing the extra cap KVM_CAP_MAX_VCPUS
doesn't make more restriction comparing to providing it in KVM_TDX_INIT_VM.

>
> May better to clarify this in the commit yet.
>
>>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> ---
>>> v18:
>>> - use TDX instead of "x86, tdx" in subject
>>> - use min(max_vcpu, TDX_MAX_VCPU) instead of
>>>     min3(max_vcpu, KVM_MAX_VCPU, TDX_MAX_VCPU)
>>> - make "if (KVM_MAX_VCPU) and if (TDX_MAX_VCPU)" into one if statement
>>> ---
>>>    arch/x86/include/asm/kvm-x86-ops.h |  2 ++
>>>    arch/x86/include/asm/kvm_host.h    |  2 ++
>>>    arch/x86/kvm/vmx/main.c            | 22 ++++++++++++++++++++++
>>>    arch/x86/kvm/vmx/tdx.c             | 29 +++++++++++++++++++++++++++++
>>>    arch/x86/kvm/vmx/x86_ops.h         |  5 +++++
>>>    arch/x86/kvm/x86.c                 |  4 ++++
>>>    6 files changed, 64 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>>> index 943b21b8b106..2f976c0f3116 100644
>>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>>> @@ -21,6 +21,8 @@ KVM_X86_OP(hardware_unsetup)
>>>    KVM_X86_OP(has_emulated_msr)
>>>    KVM_X86_OP(vcpu_after_set_cpuid)
>>>    KVM_X86_OP(is_vm_type_supported)
>>> +KVM_X86_OP_OPTIONAL(max_vcpus);
>>> +KVM_X86_OP_OPTIONAL(vm_enable_cap)
>>>    KVM_X86_OP(vm_init)
>>>    KVM_X86_OP_OPTIONAL(vm_destroy)
>>>    KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 26f4668b0273..db44a92e5659 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1602,7 +1602,9 @@ struct kvm_x86_ops {
>>>    	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>>>    	bool (*is_vm_type_supported)(unsigned long vm_type);
>>> +	int (*max_vcpus)(struct kvm *kvm);
>>>    	unsigned int vm_size;
>>> +	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
>>>    	int (*vm_init)(struct kvm *kvm);
>>>    	void (*vm_destroy)(struct kvm *kvm);
>>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>>> index 50da807d7aea..4611f305a450 100644
>>> --- a/arch/x86/kvm/vmx/main.c
>>> +++ b/arch/x86/kvm/vmx/main.c
>>> @@ -6,6 +6,7 @@
>>>    #include "nested.h"
>>>    #include "pmu.h"
>>>    #include "tdx.h"
>>> +#include "tdx_arch.h"
>>>    static bool enable_tdx __ro_after_init;
>>>    module_param_named(tdx, enable_tdx, bool, 0444);
>>> @@ -16,6 +17,17 @@ static bool vt_is_vm_type_supported(unsigned long type)
>>>    		(enable_tdx && tdx_is_vm_type_supported(type));
>>>    }
>>> +static int vt_max_vcpus(struct kvm *kvm)
>>> +{
>>> +	if (!kvm)
>>> +		return KVM_MAX_VCPUS;
>>> +
>>> +	if (is_td(kvm))
>>> +		return min(kvm->max_vcpus, TDX_MAX_VCPUS);
>>> +
>>> +	return kvm->max_vcpus;
>>> +}
>>> +
>>>    static int vt_hardware_enable(void)
>>>    {
>>>    	int ret;
>>> @@ -54,6 +66,14 @@ static void vt_hardware_unsetup(void)
>>>    	vmx_hardware_unsetup();
>>>    }
>>> +static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>> +{
>>> +	if (is_td(kvm))
>>> +		return tdx_vm_enable_cap(kvm, cap);
>>> +
>>> +	return -EINVAL;
>>> +}
>>> +
>>>    static int vt_vm_init(struct kvm *kvm)
>>>    {
>>>    	if (is_td(kvm))
>>> @@ -91,7 +111,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>>>    	.has_emulated_msr = vmx_has_emulated_msr,
>>>    	.is_vm_type_supported = vt_is_vm_type_supported,
>>> +	.max_vcpus = vt_max_vcpus,
>>>    	.vm_size = sizeof(struct kvm_vmx),
>>> +	.vm_enable_cap = vt_vm_enable_cap,
>>>    	.vm_init = vt_vm_init,
>>>    	.vm_destroy = vmx_vm_destroy,
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index 8c463407f8a8..876ad7895b88 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -100,6 +100,35 @@ struct tdx_info {
>>>    /* Info about the TDX module. */
>>>    static struct tdx_info *tdx_info;
>>> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>> +{
>>> +	int r;
>>> +
>>> +	switch (cap->cap) {
>>> +	case KVM_CAP_MAX_VCPUS: {
>>> +		if (cap->flags || cap->args[0] == 0)
>>> +			return -EINVAL;
>>> +		if (cap->args[0] > KVM_MAX_VCPUS ||
>>> +		    cap->args[0] > TDX_MAX_VCPUS)
>>> +			return -E2BIG;
>>> +
>>> +		mutex_lock(&kvm->lock);
>>> +		if (kvm->created_vcpus)
>>> +			r = -EBUSY;
>>> +		else {
>>> +			kvm->max_vcpus = cap->args[0];
>>> +			r = 0;
>>> +		}
>>> +		mutex_unlock(&kvm->lock);
>>> +		break;
>>> +	}
>>> +	default:
>>> +		r = -EINVAL;
>>> +		break;
>>> +	}
>>> +	return r;
>>> +}
>>> +
>>>    static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>>>    {
>>>    	struct kvm_tdx_capabilities __user *user_caps;
>>> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
>>> index 6e238142b1e8..3a3be66888da 100644
>>> --- a/arch/x86/kvm/vmx/x86_ops.h
>>> +++ b/arch/x86/kvm/vmx/x86_ops.h
>>> @@ -139,12 +139,17 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>>>    void tdx_hardware_unsetup(void);
>>>    bool tdx_is_vm_type_supported(unsigned long type);
>>> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>>>    int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>>>    #else
>>>    static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
>>>    static inline void tdx_hardware_unsetup(void) {}
>>>    static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>>> +static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>> +{
>>> +	return -EINVAL;
>>> +};
>>>    static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>>>    #endif
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index dd3a23d56621..a1389ddb1b33 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -4726,6 +4726,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>    		break;
>>>    	case KVM_CAP_MAX_VCPUS:
>>>    		r = KVM_MAX_VCPUS;
>>> +		if (kvm_x86_ops.max_vcpus)
>>> +			r = static_call(kvm_x86_max_vcpus)(kvm);
>>>    		break;
>>>    	case KVM_CAP_MAX_VCPU_ID:
>>>    		r = KVM_MAX_VCPU_IDS;
>>> @@ -6683,6 +6685,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>>    		break;
>>>    	default:
>>>    		r = -EINVAL;
>>> +		if (kvm_x86_ops.vm_enable_cap)
>>> +			r = static_call(kvm_x86_vm_enable_cap)(kvm, cap);
>>>    		break;
>>>    	}
>>>    	return r;
>>


