Return-Path: <kvm+bounces-33682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7BB9F0275
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 02:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FFFB284BC9
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 01:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266EC38382;
	Fri, 13 Dec 2024 01:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IMUf7F2I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757AB8F6E
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 01:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734054980; cv=none; b=sf7jB5/lmcagqyjCuT/Uzt46Y+hWKNMaO9X+7hoTtbj2TBveQj5WC7heYKMxKE1Sik38dTVxOEPtUXuOhNxBGN0zsgHNV8Ehaa3rvRqk+0xZGjfvAzlTom1ANJCYa9Z1CKASlXIYaNkzKhxny8thDtNlJkfaddaaabtbdMGGgXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734054980; c=relaxed/simple;
	bh=NyAt7fLg31sOOP5MsQWn9EgGROvizgBib4DX+ww1UBw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZgqnEixKsO0zJz8Fh+XoRPWA+cTWLVci5I/lxFAKC5rgMVq2oKkLEzfqLY9iJHxdt0eUBl1AInm3BOZhpJ+qmcXwgZCbvea4n1tuiEgml2PvOkr7zqWo0/WldNDhZMLwN42z56wmB0c71m5kxCjF8ZX19+T5YCjx9oXnnKxPiBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IMUf7F2I; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734054978; x=1765590978;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=NyAt7fLg31sOOP5MsQWn9EgGROvizgBib4DX+ww1UBw=;
  b=IMUf7F2IFF/UwLB6Qw6nWQSciCnD5p8IU77VgtrIa8pbE4UxvIysaDZG
   nk6n7nHlGwaqTbQ4T2LW1nVuhFedLXtgSm+KUeGKk3/WfpjL911X8No6B
   tVTaLoOYNHL66W1NO/CdkYjkSXjxPzXc9qa1xffn83vSDwdFBxlCX1REA
   JDO2PeojGC2I1tGYSS+TkT0auRfhaP9Aa9PfYZJYBijDN7KJ3znhU40YP
   9TAkoc81l/tYvMcL3U4FMO9fQUu5Zim9yGGg1LFEU5kYjLTV32KArqhjz
   yNORX66RT/5R1XSxcLHByB8FnAwFtfbZx8zLxl2sS4iXia2LizSk2eLrP
   A==;
X-CSE-ConnectionGUID: jeJlxs5PQfqPoma2MSSNbA==
X-CSE-MsgGUID: U69ra/UFShWm30V+gZZl8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="52025355"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="52025355"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 17:56:14 -0800
X-CSE-ConnectionGUID: D8jsdFF4RlyGSwH5qcdBcA==
X-CSE-MsgGUID: YzFOYt+DRReDruSUNIs15g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="96844586"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 17:56:11 -0800
Message-ID: <4462ce8a-70dc-4f13-a1e4-2f75b38d5e25@linux.intel.com>
Date: Fri, 13 Dec 2024 09:56:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Set return value after handling
 KVM_EXIT_HYPERCALL
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, xiaoyao.li@intel.com,
 qemu-devel@nongnu.org, michael.roth@amd.com, rick.p.edgecombe@intel.com,
 isaku.yamahata@intel.com, farrah.chen@intel.com, kvm@vger.kernel.org
References: <20241212032628.475976-1-binbin.wu@linux.intel.com>
 <Z1qZygKqvjIfpOXD@intel.com>
 <1a5e2988-9a7d-4415-86ad-8a7a98dbc5eb@redhat.com>
 <Z1s1yeWKnvmh718N@google.com>
 <5b8f7d63-ef0a-487f-bf9d-44421691fa85@redhat.com>
 <745b2b6e-7dd0-4437-bbbf-673ddc0df014@linux.intel.com>
Content-Language: en-US
In-Reply-To: <745b2b6e-7dd0-4437-bbbf-673ddc0df014@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/13/2024 9:46 AM, Binbin Wu wrote:
>
>
>
> On 12/13/2024 5:28 AM, Paolo Bonzini wrote:
>> On 12/12/24 20:13, Sean Christopherson wrote:
>>> On Thu, Dec 12, 2024, Paolo Bonzini wrote:
>>>> On 12/12/24 09:07, Zhao Liu wrote:
>>>>> On Thu, Dec 12, 2024 at 11:26:28AM +0800, Binbin Wu wrote:
>>>>>> Date: Thu, 12 Dec 2024 11:26:28 +0800
>>>>>> From: Binbin Wu <binbin.wu@linux.intel.com>
>>>>>> Subject: [PATCH] i386/kvm: Set return value after handling
>>>>>>    KVM_EXIT_HYPERCALL
>>>>>> X-Mailer: git-send-email 2.46.0
>>>>>>
>>>>>> Userspace should set the ret field of hypercall after handling
>>>>>> KVM_EXIT_HYPERCALL.  Otherwise, a stale value could be returned to KVM.
>>>>>>
>>>>>> Fixes: 47e76d03b15 ("i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE")
>>>>>> Reported-by: Farrah Chen <farrah.chen@intel.com>
>>>>>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>>>>>> Tested-by: Farrah Chen <farrah.chen@intel.com>
>>>>>> ---
>>>>>> To test the TDX code in kvm-coco-queue, please apply the patch to the QEMU,
>>>>>> otherwise, TDX guest boot could fail.
>>>>>> A matching QEMU tree including this patch is here:
>>>>>> https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu-upstream-v6.1-fix_kvm_hypercall_return_value
>>>>>>
>>>>>> Previously, the issue was not triggered because no one would modify the ret
>>>>>> value. But with the refactor patch for __kvm_emulate_hypercall() in KVM,
>>>>>> https://lore.kernel.org/kvm/20241128004344.4072099-7-seanjc@google.com/, the
>>>>>> value could be modified.
>>>>>
>>>>> Could you explain the specific reasons here in detail? It would be
>>>>> helpful with debugging or reproducing the issue.
>>>>>
>>>>>> ---
>>>>>>    target/i386/kvm/kvm.c | 8 ++++++--
>>>>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>>>>> index 8e17942c3b..4bcccb48d1 100644
>>>>>> --- a/target/i386/kvm/kvm.c
>>>>>> +++ b/target/i386/kvm/kvm.c
>>>>>> @@ -6005,10 +6005,14 @@ static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
>>>>>>    static int kvm_handle_hypercall(struct kvm_run *run)
>>>>>>    {
>>>>>> +    int ret = -EINVAL;
>>>>>> +
>>>>>>        if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
>>>>>> -        return kvm_handle_hc_map_gpa_range(run);
>>>>>> +        ret = kvm_handle_hc_map_gpa_range(run);
>>>>>> +
>>>>>> +    run->hypercall.ret = ret;
>>>>>
>>>>> ret may be negative but hypercall.ret is u64. Do we need to set it to
>>>>> -ret?
>>>>
>>>> If ret is less than zero, will stop the VM anyway as
>>>> RUN_STATE_INTERNAL_ERROR.
>>>>
>>>> If this has to be fixed in QEMU, I think there's no need to set anything
>>>> if ret != 0; also because kvm_convert_memory() returns -1 on error and
>>>> that's not how the error would be passed to the guest.
>>>>
>>>> However, I think the right fix should simply be this in KVM:
>>>>
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 83fe0a78146f..e2118ba93ef6 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -10066,6 +10066,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>>>>           }
>>>>           vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
>>>> +        vcpu->run->ret                = 0;
>>>
>>>         vcpu->run->hypercall.ret
>>>
>>>> vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
>>>>           vcpu->run->hypercall.args[0]  = gpa;
>>>>           vcpu->run->hypercall.args[1]  = npages;
>>>>
>>>> While there is arguably a change in behavior of the kernel both with
>>>> the patches in kvm-coco-queue and with the above one, _in practice_
>>>> the above change is one that userspace will not notice.
>>>
>>> I agree that KVM should initialize "ret", but I don't think '0' is the right
>>> value.  KVM shouldn't assume userspace will successfully handle the hypercall.
>>> What happens if KVM sets vcpu->run->hypercall.ret to a non-zero value, e.g. -KVM_ENOSYS?
>>
>> Unfortunately QEMU is never writing vcpu->run->hypercall.ret, so the guest sees -KVM_ENOSYS; this is basically the same bug that Binbin is fixing, just with a different value passed to the guest.
>>
>> In other words, the above one-liner is pulling the "don't break userspace" card.
>>
>> Paolo
>>
>>
> If the change need to be done in KVM, there are other 3 functions that use
> KVM_EXIT_HYPERCALL based on the code in kvm-coco-queue.
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 40fe7258843e..a624f7289282 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3633,6 +3633,7 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
>         }
>
>         vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
> +       vcpu->run->ret         = 0;
>         vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
>         vcpu->run->hypercall.args[0] = gpa;
>         vcpu->run->hypercall.args[1] = 1;
> @@ -3796,6 +3797,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
>         case VMGEXIT_PSC_OP_PRIVATE:
>         case VMGEXIT_PSC_OP_SHARED:
>                 vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
> +               vcpu->run->ret         = 0;
>                 vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
>                 vcpu->run->hypercall.args[0] = gfn_to_gpa(gfn);
>                 vcpu->run->hypercall.args[1] = npages;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 85c8aee263c1..c50c2edc8c56 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1161,6 +1161,7 @@ static void __tdx_map_gpa(struct vcpu_tdx * tdx)
>         pr_err("%s: gpa = 0x%llx, size = 0x%llx", __func__, gpa, size);
>
>         tdx->vcpu.run->exit_reason       = KVM_EXIT_HYPERCALL;
> +       tdx->vcpu->run->ret              = 0;
Sorry, this should be  " tdx->vcpu.run->ret              = 0;"

> tdx->vcpu.run->hypercall.nr      = KVM_HC_MAP_GPA_RANGE;
>         tdx->vcpu.run->hypercall.args[0] = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
>         tdx->vcpu.run->hypercall.args[1] = size / PAGE_SIZE;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4f94b1e24eae..3f82bb2357e3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10070,6 +10070,7 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>                 }
>
>                 vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> +               vcpu->run->ret                = 0;
>                 vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
>                 vcpu->run->hypercall.args[0]  = gpa;
>                 vcpu->run->hypercall.args[1]  = npages;
>


