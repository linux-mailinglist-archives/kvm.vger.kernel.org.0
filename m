Return-Path: <kvm+bounces-33560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D679EE034
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0724B1885F93
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E299820ADFD;
	Thu, 12 Dec 2024 07:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HpgHaqiV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F16545027
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 07:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733988301; cv=none; b=qKPCng/rTkckgMTLDPtZM/jUs/vvpyBNhGkQKDmHMcETUrkLNbaa6sGYMq7praRh7a3OMCx/THDajwQ8wiEjrZptOAcqMoWVYKDOzY5nmaURf27arpw/p2EQ1qdkauoWQPqex0y+VFRCuXTQdyP8a34F9blDaKpADyFqg9/3+GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733988301; c=relaxed/simple;
	bh=E+96D3TkpcXMYnW3QE77wCn78YjajPKs3Y+V0ASafvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DnIbvgBgRCo+TJJiHeKJPTkOnscTkVZ775XMYIlZwAmETSlf8OvJTY40qyqzYnjO6NHmW4ljvL2jl/DZWRJL/lzKf3PeGdcGGaikMKDRgjaocrNz4YEKDJN7cjGGhLAEKMNZZaCXJJmY0y2qmdJ+Y7OH08xcEkzKiXRR0SwhlHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HpgHaqiV; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733988299; x=1765524299;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E+96D3TkpcXMYnW3QE77wCn78YjajPKs3Y+V0ASafvk=;
  b=HpgHaqiVUjhnqnFxsF0Y8u1M8wkLplm0OVcYJkVD1Os5pFQxFQrRPd+8
   pmcjFdLRPWjdQsQRLobvUMkoxarbEXdsMVDV64TtndEakaurVlYgYyvPN
   +0+V8rigwGRBuJAKJ3cXkaHXYLUDngT6QxtLwk4g8KkRP5dDleKfehpuW
   jGR6iENXz+8IQeEd1yWbQ31dLfKy9ADfb3P1UMW1Fx3nqULmIV9hOgf14
   VrHZhdZ+jW7nVO53CzczERzebzZVm+peOHQC1lNbCzqj0Tfad90tU+AxT
   S3xIDzs2ofp0LJqWBVC9W1nzYtEk9e9RM8YPnKggcTZwi632Obkn3octp
   A==;
X-CSE-ConnectionGUID: n2ev1Q86TnadiwGv/HuaHA==
X-CSE-MsgGUID: T8eB3oYoSPmcFh10BZvIPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="51922112"
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="51922112"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 23:24:59 -0800
X-CSE-ConnectionGUID: LxlQghzuS06ekibFJcdWhA==
X-CSE-MsgGUID: mKEccI+RQ4yCxhEbDgowAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="101248236"
Received: from unknown (HELO [10.238.0.149]) ([10.238.0.149])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 23:24:56 -0800
Message-ID: <f6ee0b77-cb9b-4e7c-87f8-2d8feea40d0f@linux.intel.com>
Date: Thu, 12 Dec 2024 15:24:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Set return value after handling
 KVM_EXIT_HYPERCALL
To: Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
 qemu-devel@nongnu.org
Cc: seanjc@google.com, michael.roth@amd.com, rick.p.edgecombe@intel.com,
 isaku.yamahata@intel.com, farrah.chen@intel.com, kvm@vger.kernel.org
References: <20241212032628.475976-1-binbin.wu@linux.intel.com>
 <2144c2c0-4a5d-4efd-b5e2-f2b4096c08b5@intel.com>
 <72e1da62-5fd2-4633-b304-24be3dac1e7f@linux.intel.com>
 <0d480d7e-3c8f-43b9-a123-11b23062669d@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <0d480d7e-3c8f-43b9-a123-11b23062669d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/12/2024 3:09 PM, Xiaoyao Li wrote:
> On 12/12/2024 1:18 PM, Binbin Wu wrote:
>>
>>
>>
>> On 12/12/2024 11:44 AM, Xiaoyao Li wrote:
>>> On 12/12/2024 11:26 AM, Binbin Wu wrote:
>>>> Userspace should set the ret field of hypercall after handling
>>>> KVM_EXIT_HYPERCALL.  Otherwise, a stale value could be returned to KVM.
>>>>
>>>> Fixes: 47e76d03b15 ("i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE")
>>>> Reported-by: Farrah Chen <farrah.chen@intel.com>
>>>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>>>> Tested-by: Farrah Chen <farrah.chen@intel.com>
>>>> ---
>>>> To test the TDX code in kvm-coco-queue, please apply the patch to the QEMU,
>>>> otherwise, TDX guest boot could fail.
>>>> A matching QEMU tree including this patch is here:
>>>> https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu- upstream-v6.1-fix_kvm_hypercall_return_value
>>>>
>>>> Previously, the issue was not triggered because no one would modify the ret
>>>> value. But with the refactor patch for __kvm_emulate_hypercall() in KVM,
>>>> https://lore.kernel.org/kvm/20241128004344.4072099-7- seanjc@google.com/, the
>>>> value could be modified.
>>>> ---
>>>>   target/i386/kvm/kvm.c | 8 ++++++--
>>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>>> index 8e17942c3b..4bcccb48d1 100644
>>>> --- a/target/i386/kvm/kvm.c
>>>> +++ b/target/i386/kvm/kvm.c
>>>> @@ -6005,10 +6005,14 @@ static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
>>>>     static int kvm_handle_hypercall(struct kvm_run *run)
>>>>   {
>>>> +    int ret = -EINVAL;
>>>> +
>>>>       if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
>>>> -        return kvm_handle_hc_map_gpa_range(run);
>>>> +        ret = kvm_handle_hc_map_gpa_range(run);
>>>> +
>>>> +    run->hypercall.ret = ret;
>>>
>>> Updating run->hypercall.ret is useful only when QEMU needs to re-enter the guest. For the case of ret < 0, QEMU will stop the vcpu.
>>
>> IMHO, assign run->hypercall.ret anyway should be OK, no need to add a
>> per-condition on ret, although the value is not used when ret < 0.
>>
>> Currently, since QEMU will stop the vcpu when ret < 0, this patch doesn't
>> convert ret to -Exxx that the ABI expects.
>
> I was thinking if it is better to let each specific handling function to   update run->hypercall.ret with its own logic. E.g., for this case, let kvm_handle_hc_map_gpa_range() to update the run->hypercall.ret.
I think it makes sense.

Also, each handling function can decide whether the vcpu should continue if the handling failed.
- Return 0 and set the error code ( 0 or -Exxx) to run->hypercall.ret if it want to continue.
- Return negative value if it want to stop the vcpu thread.

>
> Reusing the return value of the handling function to update
> run->hypercall.ret seems not logically correct to me.
>
>>>
>>> I think we might need re-think on the handling of KVM_EXIT_HYPERCALL. E.g., in what error case should QEMU stop the vcpu, and in what case can QEMU return the error back to the guest via run->hypercall.ret.
>>
>> Actually, I had the similar question before.
>> https://lore.kernel.org/kvm/ d25cc62c-0f56-4be2-968a-63c8b1d63b5a@linux.intel.com/
>>
>> It might depends on the hypercall number?
>> Another option is QEMU always sets run->hypercall.ret appropriately and continues the vcpu thread.
>>
>>
>>>
>>>> -    return -EINVAL;
>>>> +    return ret;
>>>>   }
>>>>     #define VMX_INVALID_GUEST_STATE 0x80000021
>>>>
>>>> base-commit: ae35f033b874c627d81d51070187fbf55f0bf1a7
>>>
>>
>


