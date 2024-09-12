Return-Path: <kvm+bounces-26675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 428EB97652D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71D87B2236A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1AC192D61;
	Thu, 12 Sep 2024 09:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dBsKwQ6n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE2719048D;
	Thu, 12 Sep 2024 09:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726132067; cv=none; b=pHO5G3OUbfI5ADTr89Ju1mbRRvIbF0a/ijDysCQgYDSZqpnueo1QcxhWOYsq8/ACu0WXrwGwGTtemSUyZTvmQXjRFQcLYNCHJgtL3X95OJcq50LBBNwLu+dU43oxfgx58ma+9JcbRxgjwy76dUVJArm5QLr9DRBNDd/g3jY9p0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726132067; c=relaxed/simple;
	bh=7k0XyMEH1Z3n5hHu5Ip9hn4g+5mmuwI5Pk2cZmfaAwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NilsHGnNrO86eH8bRL6cmGNZdgkDKi13FnQSDI9ampHpvNm2QcXvvqK2btEgucjy+11LFgB9kdLtpDsfztCHlCDFVtUPKa45REt+QjOv0cO6Z/4ZyfBDxYlpmDdapEzZnQRUCQiRWZbzK1BPWSlgQ8lOYUaBzsegXyEhRS8PgUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dBsKwQ6n; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726132066; x=1757668066;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7k0XyMEH1Z3n5hHu5Ip9hn4g+5mmuwI5Pk2cZmfaAwk=;
  b=dBsKwQ6n8epAxUg3xU85f9c8MLsXQ1X4VC0csDgk+13WbQ8gn4AmlvUC
   GJV156u8fK58l/CdpY/t21irqjLYSPII5gxuDN6kULe5aaR8vjc1t+iat
   gJK3+mUnopr3YOpdT1cm5Vam3Jfs/oi/wD0YclURU/n/LQO2IaP/Tokef
   vcoyDiP9w6C/hz35bZ+uQ21lZRg7qTHLSYqLNMbW3vQ5+Ma/Gdxu34KIA
   FTBfbCusSd4/jD+7Q0nn7x3TqB14xoD2qVllq3zKb1ITl1pKrdBACYR4r
   ghhZSuCSwh1vk4JWbW67svpoUcUomHcFh9InA8lpeU7dBPSADB4ZMpcUq
   A==;
X-CSE-ConnectionGUID: MB2a0AujTUODiLDbZPdTsQ==
X-CSE-MsgGUID: 1P3dXy3+Q82UkpUSPlPhYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="13490770"
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="13490770"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 02:07:45 -0700
X-CSE-ConnectionGUID: l6wLoMHlTtG+zcCHKarU5g==
X-CSE-MsgGUID: dEd+rqZURI6hQJlO+dSTAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="67367320"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.38]) ([10.124.224.38])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 02:07:43 -0700
Message-ID: <e2a11f6d-96d3-4607-b3f2-3a42ba036641@intel.com>
Date: Thu, 12 Sep 2024 17:07:40 +0800
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
 <45963b9e-eec8-40b1-9e86-226504c463b8@intel.com>
 <55366da1-2b9c-4d12-aba7-93c15a1b3b09@suse.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <55366da1-2b9c-4d12-aba7-93c15a1b3b09@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/12/2024 4:43 PM, Nikolay Borisov wrote:
> 
> 
> On 12.09.24 г. 11:37 ч., Xiaoyao Li wrote:
>> On 9/12/2024 4:04 PM, Nikolay Borisov wrote:
>>>
>>>
>>> On 5.09.24 г. 16:36 ч., Xiaoyao Li wrote:
>>>> On 9/4/2024 7:58 PM, Nikolay Borisov wrote:
>>>>>
>>>>>
>>>>> On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
>>>>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>>>
>>>>>> While TDX module reports a set of capabilities/features that it
>>>>>> supports, what KVM currently supports might be a subset of them.
>>>>>> E.g., DEBUG and PERFMON are supported by TDX module but currently not
>>>>>> supported by KVM.
>>>>>>
>>>>>> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of 
>>>>>> TDX.
>>>>>> supported_attrs and suppported_xfam are validated against fixed0/1
>>>>>> values enumerated by TDX module. Configurable CPUID bits derive 
>>>>>> from TDX
>>>>>> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>>>>>> i.e., mask off the bits that are configurable in the view of TDX 
>>>>>> module
>>>>>> but not supported by KVM yet.
>>>>>>
>>>>>> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it 
>>>>>> to 0
>>>>>> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of 
>>>>>> KVM.
>>>>>>
>>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>>>> ---
>>>>>> uAPI breakout v1:
>>>>>>   - Change setup_kvm_tdx_caps() to use the exported 'struct 
>>>>>> tdx_sysinfo'
>>>>>>     pointer.
>>>>>>   - Change how to copy 'kvm_tdx_cpuid_config' since 'struct 
>>>>>> tdx_sysinfo'
>>>>>>     doesn't have 'kvm_tdx_cpuid_config'.
>>>>>>   - Updates for uAPI changes
>>>>>> ---
>>>>>>   arch/x86/include/uapi/asm/kvm.h |  2 -
>>>>>>   arch/x86/kvm/vmx/tdx.c          | 81 
>>>>>> +++++++++++++++++++++++++++++++++
>>>>>>   2 files changed, 81 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/include/uapi/asm/kvm.h 
>>>>>> b/arch/x86/include/uapi/asm/kvm.h
>>>>>> index 47caf508cca7..c9eb2e2f5559 100644
>>>>>> --- a/arch/x86/include/uapi/asm/kvm.h
>>>>>> +++ b/arch/x86/include/uapi/asm/kvm.h
>>>>>> @@ -952,8 +952,6 @@ struct kvm_tdx_cmd {
>>>>>>       __u64 hw_error;
>>>>>>   };
>>>>>> -#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>>>>>> -
>>>>>>   struct kvm_tdx_cpuid_config {
>>>>>>       __u32 leaf;
>>>>>>       __u32 sub_leaf;
>>>>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>>>>> index 90b44ebaf864..d89973e554f6 100644
>>>>>> --- a/arch/x86/kvm/vmx/tdx.c
>>>>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>>>>> @@ -31,6 +31,19 @@ static void __used tdx_guest_keyid_free(int keyid)
>>>>>>       ida_free(&tdx_guest_keyid_pool, keyid);
>>>>>>   }
>>>>>> +#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>>>>>> +
>>>>>> +struct kvm_tdx_caps {
>>>>>> +    u64 supported_attrs;
>>>>>> +    u64 supported_xfam;
>>>>>> +
>>>>>> +    u16 num_cpuid_config;
>>>>>> +    /* This must the last member. */
>>>>>> +    DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
>>>>>> +};
>>>>>> +
>>>>>> +static struct kvm_tdx_caps *kvm_tdx_caps;
>>>>>> +
>>>>>>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>>>>>>   {
>>>>>>       const struct tdx_sysinfo_td_conf *td_conf = 
>>>>>> &tdx_sysinfo->td_conf;
>>>>>> @@ -131,6 +144,68 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user 
>>>>>> *argp)
>>>>>>       return r;
>>>>>>   }
>>>>>> +#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
>>>>>
>>>>> Why isn't TDX_TD_ATTR_DEBUG added as well?
>>>>
>>>> Because so far KVM doesn't support all the features of a DEBUG TD 
>>>> for userspace. e.g., KVM doesn't provide interface for userspace to 
>>>> read/write private memory of DEBUG TD.
>>>
>>> But this means that you can't really run a TDX with SEPT_VE_DISABLE 
>>> disabled for debugging purposes, so perhaps it might be necessary to 
>>> rethink the condition allowing SEPT_VE_DISABLE to be disabled. 
>>> Without the debug flag and SEPT_VE_DISABLE disabled the code refuses 
>>> to start the VM, what if one wants to debug some SEPT issue by having 
>>> an oops generated inside the vm ?
>>
>> sept_ve_disable is allowed to be disable, i.e., set to 0.
>>
>> I think there must be some misunderstanding.
> 
> There isn't, the current code is:
> 
>    201         if (!(td_attr & ATTR_SEPT_VE_DISABLE)) {
>      1                 const char *msg = "TD misconfiguration: 
> SEPT_VE_DISABLE attribute must be set.";
>      2
>      3                 /* Relax SEPT_VE_DISABLE check for debug TD. */
>      4                 if (td_attr & ATTR_DEBUG)
>      5                         pr_warn("%s\n", msg);
>      6                 else
>      7                         tdx_panic(msg);
>      8         }
> 
> 
> I.e if we disable SEPT_VE_DISABLE without having ATTR_DEBUG it results 
> in a panic.

I see now.

It's linux TD guest's implementation, which requires SEPT_VE_DISABLE 
must be set unless it's a debug TD.

Yes, it can be the motivation to request KVM to add the support of 
ATTRIBUTES.DEBUG. But the support of ATTRIBUTES.DEBUG is not just 
allowing this bit to be set to 1. For DEBUG TD, VMM is allowed to 
read/write the private memory content, cpu registers, and MSRs, VMM is 
allowed to trap the exceptions in TD, VMM is allowed to manipulate the 
VMCS of TD vcpu, etc.

IMHO, for upstream, no need to support all the debug capability as 
described above. But we need firstly define a subset of them as the 
starter of supporting ATTRIBUTES.DEBUG. Otherwise, what is the meaning 
of KVM to allow the DEBUG to be set without providing any debug capability?

For debugging purpose, you can just hack guest kernel to allow 
spet_ve_disable to be 0 without DEBUG bit set, or hack KVM to allow 
DEBUG bit to be set.

>>
>>>>
>>>>> <snip>
>>>>
>>>>
>>


