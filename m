Return-Path: <kvm+bounces-19764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8807190A917
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 11:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E18A2861F1
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 09:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18CC190694;
	Mon, 17 Jun 2024 09:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ae9LZzGy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CB51836FC;
	Mon, 17 Jun 2024 09:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718615283; cv=none; b=ouafjBWdGlYqD9EaiRPKZmeiG5PVtUF/5MlXmu/Tx4nK5bZdyA0z74EOaFnOFMSIBRshc/6qOrxg2O+kd6Ms7bBI3bj+C+dmIuqPYj1jxW26+Otax2Vo4krdSfjThmwHaTJKmrxLGDcijU28D+cRl6oAB60PHI2JtDj43tsM90E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718615283; c=relaxed/simple;
	bh=piJxAFqGxAn9CGsf1gaLZV6u6Ts8aj8V3y5yzYpfobc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uy6idm3+UUY36pORqzCk49cltmdWkzgh1SpBJa0z6JS8BsGSin6oZFAljzu5M/E9sURU1yJJpUsNKGe2y9Cm9v/riBGLL5lGNfgwR5wPy3/nwy/b77WVhcryDocx8GCP89YIFRSGEqomF3/etL2ioGYaUWdegpy2TR7qMS6b/is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ae9LZzGy; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718615282; x=1750151282;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=piJxAFqGxAn9CGsf1gaLZV6u6Ts8aj8V3y5yzYpfobc=;
  b=ae9LZzGyVZkzGGc/jXUS8ppqitaWPeRAETk3bmKkRlO52gN02f8rO0lV
   EH7nl4Qg0d/8Hp4eRnl+Pn65U5T33qXa/OIcYX3Zj6f0ZKH2Ckxzpv6W8
   jIBU4huT++yQ8VpWe2qZDUSEn3KzGKkvzgwRDZo6FlCoz2pM8SZthFRva
   qLE0gHm5UL+cdVWM0P8o3qNpQjNH4rtU/Ho1zv6lDYKGvT/E+3eYc/c24
   EVNa73XM6GvGeg//mHQEOUNHRQUVtKJB0IGS0YA3XFAzPTyvjMqS2o9D5
   jwawMxNWF9fuKzu7QuEZsLUX+17u4CK/ziuo2HBhvm/yUEY31pFXQBoyP
   A==;
X-CSE-ConnectionGUID: 5QL1tipJQmSM9UHnvjKAUQ==
X-CSE-MsgGUID: 45m6/WPaTMCM+lvwwrdGow==
X-IronPort-AV: E=McAfee;i="6700,10204,11105"; a="32902199"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="32902199"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 02:08:02 -0700
X-CSE-ConnectionGUID: JtpqNSJFROSqr+FGCIQcZw==
X-CSE-MsgGUID: /G+JMWO7T1CIhATwfhK07w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="40988414"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.234.76]) ([10.124.234.76])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 02:07:58 -0700
Message-ID: <c1426d14-3c00-4956-89a3-c06336905330@linux.intel.com>
Date: Mon, 17 Jun 2024 17:07:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 085/130] KVM: TDX: Complete interrupts after tdexit
To: Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
 <20240617080729.j5nottky5bjmgdmf@yy-desk-7060>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240617080729.j5nottky5bjmgdmf@yy-desk-7060>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/17/2024 4:07 PM, Yuan Yao wrote:
> On Mon, Feb 26, 2024 at 12:26:27AM -0800, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> This corresponds to VMX __vmx_complete_interrupts().  Because TDX
>> virtualize vAPIC, KVM only needs to care NMI injection.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> v19:
>> - move tdvps_management_check() to this patch
>> - typo: complete -> Complete in short log
>> ---
>>   arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
>>   arch/x86/kvm/vmx/tdx.h |  4 ++++
>>   2 files changed, 14 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 83dcaf5b6fbd..b8b168f74dfe 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -535,6 +535,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   	 */
>>   }
>>
>> +static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
>> +{
>> +	/* Avoid costly SEAMCALL if no nmi was injected */
>> +	if (vcpu->arch.nmi_injected)
>> +		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
>> +							      TD_VCPU_PEND_NMI);
>> +}
> Looks this leads to NMI injection delay or even won't be
> reinjected if KVM_REQ_EVENT is not set on the target cpu
> when more than 1 NMIs are pending there.
>
> On normal VM, KVM uses NMI window vmexit for injection
> successful case to rasie the KVM_REQ_EVENT again for remain
> pending NMIs, see handle_nmi_window(). KVM also checks
> vectoring info after VMEXIT for case that the NMI is not
> injected successfully in this vmentry vmexit round, and
> raise KVM_REQ_EVENT to try again, see __vmx_complete_interrupts().
>
> In TDX, consider there's no way to get vectoring info or
> handle nmi window vmexit, below checking should cover both
> scenarios for NMI injection:
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e9c9a185bb7b..9edf446acd3b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -835,9 +835,12 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
>   {
>          /* Avoid costly SEAMCALL if no nmi was injected */
> -       if (vcpu->arch.nmi_injected)
> +       if (vcpu->arch.nmi_injected) {
>                  vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
>                                                                TD_VCPU_PEND_NMI);
> +               if (vcpu->arch.nmi_injected || vcpu->arch.nmi_pending)
> +                       kvm_make_request(KVM_REQ_EVENT, vcpu);

For nmi_injected, it should be OK because TD_VCPU_PEND_NMI is still set.
But for nmi_pending, it should be checked and raise event.

I remember there was a discussion in the following link:
https://lore.kernel.org/kvm/20240402065254.GY2444378@ls.amr.corp.intel.com/
It said  tdx_vcpu_run() will ignore force_immediate_exit.
If force_immediate_exit is igored for TDX, then the nmi_pending handling 
could still be delayed if the previous NMI was injected successfully.


> +       }
>   }
>
>> +
>>   struct tdx_uret_msr {
>>   	u32 msr;
>>   	unsigned int slot;
>> @@ -663,6 +671,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>>
>> +	tdx_complete_interrupts(vcpu);
>> +
>>   	return EXIT_FASTPATH_NONE;
>>   }
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>> index 44eab734e702..0d8a98feb58e 100644
>> --- a/arch/x86/kvm/vmx/tdx.h
>> +++ b/arch/x86/kvm/vmx/tdx.h
>> @@ -142,6 +142,8 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
>>   			 "Invalid TD VMCS access for 16-bit field");
>>   }
>>
>> +static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
>> +
>>   #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
>>   static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
>>   							u32 field)		\
>> @@ -200,6 +202,8 @@ TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
>>   TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
>>   TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
>>
>> +TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
>> +
>>   static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
>>   {
>>   	struct tdx_module_args out;
>> --
>> 2.25.1
>>
>>


