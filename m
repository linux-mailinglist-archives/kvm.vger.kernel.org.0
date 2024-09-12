Return-Path: <kvm+bounces-26670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BBB9764B8
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 10:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E72731F24A35
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 08:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8932C190057;
	Thu, 12 Sep 2024 08:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KgOusAie"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0935D2BB0D;
	Thu, 12 Sep 2024 08:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726130231; cv=none; b=kXhlm9Q4RZYeFYgOy36zg+1KQEoDomAbZWVp9u4GwUMWt3rqMBc5wp+h6ycPQsxjoht1OGB3TxoZrkmkdy0OdrvfE1o0XurvmU2g4WEAv8tJgQ6VlEJxsqe5VMGkYn9hEZ7JOFlwifBSjLKhsWw7mmti1uV7Ak3L5aNHy2Xb5Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726130231; c=relaxed/simple;
	bh=dMdyNS6X8lwdVAWYWS30gDfkheVbLMNtD0caHiArAco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UjlVF7KBxfiDtqS0fygpiMG7lPpAyOq9+0JO6+WPCoBRIgk48AmoAIaogq3OEp+xYbpXSR8BCg5IsXpkBxqj9mkHuDnjj21hmRcsqMhgpeKD5BTDTOEnmBe744O9VFfc9Sgo1shEr/siU5LRDPEkRolD7lsbkEshLIC715H3Zn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KgOusAie; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726130229; x=1757666229;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dMdyNS6X8lwdVAWYWS30gDfkheVbLMNtD0caHiArAco=;
  b=KgOusAie7zBgMoN+RSghIxLzZkSLi2w/1WaRqVj800Tzl6oXujOCwTfc
   i9suPEa49B0iXQXVz/E/2NNFhMzPpEo+4vJnW9TzWzkG8nxgMLZmKqVUa
   dcNZ6Y6a3/f4ZIXDrvvguPTN4HRsNNKsgIj1wQpeM2kbMKwffJ8pxtL1+
   hO1N0Z0sSDhmW2N23gFEuecBwqZKxKfivw7FaMqRG492nQsAFnLDHfcmK
   M329IN41GFu21FIQKrDdSJOdbk2Qf3sEsULa0jZG8OKcofQt/4mSvwA82
   LU8wInXKHnhYtNCF5Q/LT3CD0P6T+fgSveqEM2ZJ4tyitNh69Es8+Dkl1
   A==;
X-CSE-ConnectionGUID: XLZEQXmHTHq8xWFYMu3Rew==
X-CSE-MsgGUID: fEzPCFC4QnSsADJeaL2Gjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="25071246"
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="25071246"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 01:37:09 -0700
X-CSE-ConnectionGUID: 0EJR5hMvSfGGFMfaT/AeGw==
X-CSE-MsgGUID: /LVL6xsBRDma29LaJBHEfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="68143861"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.38]) ([10.124.224.38])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 01:37:06 -0700
Message-ID: <45963b9e-eec8-40b1-9e86-226504c463b8@intel.com>
Date: Thu, 12 Sep 2024 16:37:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Nikolay Borisov <nik.borisov@suse.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <caa4407a-b838-4e1b-bb3d-87518f3de66b@suse.com>
 <aa764aad-1736-459f-896e-4f43bfe8b18d@intel.com>
 <2a2dd102-2ad9-4bbd-a5f7-5994de3870ae@suse.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <2a2dd102-2ad9-4bbd-a5f7-5994de3870ae@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/12/2024 4:04 PM, Nikolay Borisov wrote:
> 
> 
> On 5.09.24 г. 16:36 ч., Xiaoyao Li wrote:
>> On 9/4/2024 7:58 PM, Nikolay Borisov wrote:
>>>
>>>
>>> On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
>>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>
>>>> While TDX module reports a set of capabilities/features that it
>>>> supports, what KVM currently supports might be a subset of them.
>>>> E.g., DEBUG and PERFMON are supported by TDX module but currently not
>>>> supported by KVM.
>>>>
>>>> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
>>>> supported_attrs and suppported_xfam are validated against fixed0/1
>>>> values enumerated by TDX module. Configurable CPUID bits derive from 
>>>> TDX
>>>> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>>>> i.e., mask off the bits that are configurable in the view of TDX module
>>>> but not supported by KVM yet.
>>>>
>>>> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
>>>> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
>>>>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>> ---
>>>> uAPI breakout v1:
>>>>   - Change setup_kvm_tdx_caps() to use the exported 'struct 
>>>> tdx_sysinfo'
>>>>     pointer.
>>>>   - Change how to copy 'kvm_tdx_cpuid_config' since 'struct 
>>>> tdx_sysinfo'
>>>>     doesn't have 'kvm_tdx_cpuid_config'.
>>>>   - Updates for uAPI changes
>>>> ---
>>>>   arch/x86/include/uapi/asm/kvm.h |  2 -
>>>>   arch/x86/kvm/vmx/tdx.c          | 81 
>>>> +++++++++++++++++++++++++++++++++
>>>>   2 files changed, 81 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/uapi/asm/kvm.h 
>>>> b/arch/x86/include/uapi/asm/kvm.h
>>>> index 47caf508cca7..c9eb2e2f5559 100644
>>>> --- a/arch/x86/include/uapi/asm/kvm.h
>>>> +++ b/arch/x86/include/uapi/asm/kvm.h
>>>> @@ -952,8 +952,6 @@ struct kvm_tdx_cmd {
>>>>       __u64 hw_error;
>>>>   };
>>>> -#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>>>> -
>>>>   struct kvm_tdx_cpuid_config {
>>>>       __u32 leaf;
>>>>       __u32 sub_leaf;
>>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>>> index 90b44ebaf864..d89973e554f6 100644
>>>> --- a/arch/x86/kvm/vmx/tdx.c
>>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>>> @@ -31,6 +31,19 @@ static void __used tdx_guest_keyid_free(int keyid)
>>>>       ida_free(&tdx_guest_keyid_pool, keyid);
>>>>   }
>>>> +#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>>>> +
>>>> +struct kvm_tdx_caps {
>>>> +    u64 supported_attrs;
>>>> +    u64 supported_xfam;
>>>> +
>>>> +    u16 num_cpuid_config;
>>>> +    /* This must the last member. */
>>>> +    DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
>>>> +};
>>>> +
>>>> +static struct kvm_tdx_caps *kvm_tdx_caps;
>>>> +
>>>>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>>>>   {
>>>>       const struct tdx_sysinfo_td_conf *td_conf = 
>>>> &tdx_sysinfo->td_conf;
>>>> @@ -131,6 +144,68 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user 
>>>> *argp)
>>>>       return r;
>>>>   }
>>>> +#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
>>>
>>> Why isn't TDX_TD_ATTR_DEBUG added as well?
>>
>> Because so far KVM doesn't support all the features of a DEBUG TD for 
>> userspace. e.g., KVM doesn't provide interface for userspace to 
>> read/write private memory of DEBUG TD.
> 
> But this means that you can't really run a TDX with SEPT_VE_DISABLE 
> disabled for debugging purposes, so perhaps it might be necessary to 
> rethink the condition allowing SEPT_VE_DISABLE to be disabled. Without 
> the debug flag and SEPT_VE_DISABLE disabled the code refuses to start 
> the VM, what if one wants to debug some SEPT issue by having an oops 
> generated inside the vm ?

sept_ve_disable is allowed to be disable, i.e., set to 0.

I think there must be some misunderstanding.

>>
>>> <snip>
>>
>>


