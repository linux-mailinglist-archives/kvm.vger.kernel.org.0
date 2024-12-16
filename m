Return-Path: <kvm+bounces-33830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B69E9F27A6
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 01:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 822767A16AB
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 00:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4340ADDAB;
	Mon, 16 Dec 2024 00:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZUgxQ2Wy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03548BE8;
	Mon, 16 Dec 2024 00:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734310467; cv=none; b=gDMtqDh7lypiE5QzALP2wkGn6CZHMF2k0Qc/7n1Wih/IOwhgxzWq5sYkSf60jV3cbtm3pmmQvw3N9BySCT4CB0TSalDv+Vw94ZK+ztWONfhdBfdr4P8i4XWH8NO16j7KkAcSN8PeQ8WF/o6fH+vynsx+MPRI3BQ/PPRXEorhm1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734310467; c=relaxed/simple;
	bh=4jLKy2uykh/k+3qMSZlBMo2s9tSlJC7rCwK0O0XTXgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DDgRYbCeJ7B2pb9amIhaXPPyXwnpNFrV4xUku1QjbAYwBdRd/obSERpf/ifVkjPidjljeTHNi6+VUtFhtqaBgwTdDVwWZ+s8ahFG/Q/pmPdzRCArZmRDU3M5TD8iNsA7Py3byvq6OV67y8CF9OvWjTLYHHKp4Hza6+/AaWaQsyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZUgxQ2Wy; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734310466; x=1765846466;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4jLKy2uykh/k+3qMSZlBMo2s9tSlJC7rCwK0O0XTXgg=;
  b=ZUgxQ2Wyg97TN5/E/aLfLfkeCytqX4t6Vo4716qJ5vbiGg1uCNrHyoUS
   EGYUmmqIKSH/zAMiujT7OiLVbnElwdAr659OlmZz0O+iEc9yMS/gMqW01
   /+jzXtJ5tIBhNYBHR2OTSOCRAyWu3gbxWAL6ebJ9OZXIB7o9V5i3Jm7KS
   eDFc8Ouwh04sm+BMGtl4MeXHx8IHN5R10xSG6KagyugDWMLEQqCwcKrUh
   NldzfGXe3Khyib6iXGJmRAeZ7SPm+cP3aFd3MSKQ5aD5ujpCD3cNtZTLF
   XoTd8IAek4HloolLaZCfJ6n7YR2WKgimhfzWWpWw0v+qMCagWgj9lPUmo
   Q==;
X-CSE-ConnectionGUID: zgrP3AsXSHGkkUI5ikE2pA==
X-CSE-MsgGUID: kp0xEy2MSK+y+wmFn5shuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11287"; a="34564553"
X-IronPort-AV: E=Sophos;i="6.12,237,1728975600"; 
   d="scan'208";a="34564553"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 16:54:25 -0800
X-CSE-ConnectionGUID: p2HCikbkTuylKYzVTn1qfA==
X-CSE-MsgGUID: E+pecBJFS32hwC1tfJgDAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,237,1728975600"; 
   d="scan'208";a="97593926"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 16:54:22 -0800
Message-ID: <25a042e8-c39a-443c-a2e4-10f515b1f2af@linux.intel.com>
Date: Mon, 16 Dec 2024 08:54:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] KVM: TDX: Add a place holder to handle TDX VM exit
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-2-binbin.wu@linux.intel.com>
 <28930ac3-f4af-4d93-a766-11a5fedb321e@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <28930ac3-f4af-4d93-a766-11a5fedb321e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/13/2024 4:57 PM, Xiaoyao Li wrote:
> On 12/1/2024 11:53 AM, Binbin Wu wrote:
>>
[...]
>> +
>> +static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
>> +{
>> +    vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
>> +    vcpu->mmio_needed = 0;
>> +    return 0;
>
> This function is just same as handle_triple_fault() in vmx.c, why not use it instead?
Yes, handle_triple_fault() could be moved to vmx.h can then it can be used
by tdx code.
Will do to.



>
>>   }
>>     void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>> @@ -1135,6 +1215,88 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>>       return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
>>   }
>>   +int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>> +{
>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +    u64 vp_enter_ret = tdx->vp_enter_ret;
>> +    union vmx_exit_reason exit_reason;
>> +
>> +    if (fastpath != EXIT_FASTPATH_NONE)
>> +        return 1;
>> +
>> +    /*
>> +     * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
>> +     * TDX_SEAMCALL_VMFAILINVALID.
>> +     */
>> +    if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
>> +        KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
>> +        goto unhandled_exit;
>> +    }
>> +
>> +    /*
>> +     * Without off-TD debug enabled, failed_vmentry case must have
>> +     * TDX_NON_RECOVERABLE set.
>> +     */
>
> This comment is confusing. I'm not sure why it is put here. Below code does nothing with exit_reason.failed_vmentry.

Because when failed_vmentry occurs, vp_enter_ret will have
TDX_NON_RECOVERABLE set, so it will be handled below.

>
>> +    if (unlikely(vp_enter_ret & (TDX_ERROR | TDX_NON_RECOVERABLE))) {
>> +        /* Triple fault is non-recoverable. */
>> +        if (unlikely(tdx_check_exit_reason(vcpu, EXIT_REASON_TRIPLE_FAULT)))
>> +            return tdx_handle_triple_fault(vcpu);
>> +
>> +        kvm_pr_unimpl("TD vp_enter_ret 0x%llx, hkid 0x%x hkid pa 0x%llx\n",
>> +                  vp_enter_ret, to_kvm_tdx(vcpu->kvm)->hkid,
>> +                  set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
>
> It indeed needs clarification for the need of "hkid" and "hkid pa". Especially the "hkdi pa", which is the result of applying HKID of the current TD to a physical address 0. I cannot think of any reason why we need such info.
Yes, set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid) should be removed.
I didn't notice it.
Thanks!


>
>> +        goto unhandled_exit;
>> +    }
>> +
>> +    /* From now, the seamcall status should be TDX_SUCCESS. */
>> +    WARN_ON_ONCE((vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
>
> Is there any case that TDX_SUCCESS with additional non-zero information in the lower 32-bits? I thought TDX_SUCCESS is a whole 64-bit status code.
TDX status code uses the upper 32-bits.

When the status code is TDX_SUCCESS and has a valid VMX exit reason, the lower
32-bit is the VMX exit reason.

You can refer to the TDX module ABI spec or interface_function_completion_status.json
from the intel-tdx-module-1.5-abi-table for details.


>
>> +    exit_reason = tdexit_exit_reason(vcpu);
>> +
>> +    switch (exit_reason.basic) {
>> +    default:
>> +        break;
>> +    }
>> +
>> +unhandled_exit:
>> +    vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +    vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>> +    vcpu->run->internal.ndata = 2;
>> +    vcpu->run->internal.data[0] = vp_enter_ret;
>> +    vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
>> +    return 0;
>> +}
>> +
>> +void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>> +        u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
>> +{
>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>> +    if (tdx_has_exit_reason(vcpu)) {
>> +        /*
>> +         * Encode some useful info from the the 64 bit return code
>> +         * into the 32 bit exit 'reason'. If the VMX exit reason is
>> +         * valid, just set it to those bits.
>> +         */
>> +        *reason = (u32)tdx->vp_enter_ret;
>> +        *info1 = tdexit_exit_qual(vcpu);
>> +        *info2 = tdexit_ext_exit_qual(vcpu);
>> +    } else {
>> +        /*
>> +         * When the VMX exit reason in vp_enter_ret is not valid,
>> +         * overload the VMX_EXIT_REASONS_FAILED_VMENTRY bit (31) to
>> +         * mean the vmexit code is not valid. Set the other bits to
>> +         * try to avoid picking a value that may someday be a valid
>> +         * VMX exit code.
>> +         */
>> +        *reason = 0xFFFFFFFF;
>> +        *info1 = 0;
>> +        *info2 = 0;
>> +    }
>> +
>> +    *intr_info = tdexit_intr_info(vcpu);
>> +    *error_code = 0;
>> +}
>> +
>>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>>   {
>>       const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
>> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
>> index f9dbb3a065cc..6ff4672c4181 100644
>> --- a/arch/x86/kvm/vmx/tdx_errno.h
>> +++ b/arch/x86/kvm/vmx/tdx_errno.h
>> @@ -10,6 +10,9 @@
>>    * TDX SEAMCALL Status Codes (returned in RAX)
>>    */
>>   #define TDX_NON_RECOVERABLE_VCPU        0x4000000100000000ULL
>> +#define TDX_NON_RECOVERABLE_TD            0x4000000200000000ULL
>> +#define TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE 0x6000000500000000ULL
>> +#define TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE 0x6000000700000000ULL
>
> Not the fault of this patch.
>
> There are other Status code defined in arch/x86/include/asm/tdx.h
>
>   /*
>    * TDX module SEAMCALL leaf function error codes
>    */
>   #define TDX_SUCCESS        0ULL
>   #define TDX_RND_NO_ENTROPY    0x8000020300000000ULL
>
> It's better to put them in one single place.
Agree.

Thanks!
>
>>   #define TDX_INTERRUPTED_RESUMABLE 0x8000000300000000ULL
>>   #define TDX_OPERAND_INVALID            0xC000010000000000ULL
>>   #define TDX_OPERAND_BUSY            0x8000020000000000ULL
>> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
>> index 02b33390e1bf..1c18943e0e1d 100644
>> --- a/arch/x86/kvm/vmx/x86_ops.h
>> +++ b/arch/x86/kvm/vmx/x86_ops.h
>> @@ -133,6 +133,10 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
>>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
>>   void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>>   void tdx_vcpu_put(struct kvm_vcpu *vcpu);
>> +int tdx_handle_exit(struct kvm_vcpu *vcpu,
>> +        enum exit_fastpath_completion fastpath);
>> +void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>> +        u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
>>     int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>>   @@ -167,6 +171,10 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
>>   }
>>   static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
>>   static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
>> +static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
>> +        enum exit_fastpath_completion fastpath) { return 0; }
>> +static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
>> +                     u64 *info2, u32 *intr_info, u32 *error_code) {}
>>     static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>


