Return-Path: <kvm+bounces-26671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD909764C1
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 10:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1A2B1F24A4C
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 08:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F6A18FDC2;
	Thu, 12 Sep 2024 08:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b7r5micS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F300918C915
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 08:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726130595; cv=none; b=IUQr7irAGYXUhj8DXpql7fRnRQb8HkksF0gSGfiA9Nw0rXOIwUdmEcKtpA/wNzkmKsXo9jKL/ap2fOzeZbPYxPWkHguZhRh5PWIep9Vk/ctTq95Qv9DvWLbZ6+THbywYKNONXCO04R4uKrRft9SSn45lA8UbCvk5ULLkw63oZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726130595; c=relaxed/simple;
	bh=dsW4dSpQykdg67bz04HE3UICRsUhbSjaOXv+3ikor50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SouvTliTwU90ztP27dV3MmYj7sCzDODnATTHnm1u15V606dU+d5mHfEDjTUHTQNu5ZVQLmUj+M4BFFH7NTLNkdAkPMlf/N8OFsfqiZJBmXMAEvowB9KebXaqGWETVgUV+H1p8BfbWQB5rZlIlPBq2zQohRyEhjXAeChWeUBPSIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b7r5micS; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-374b9761eecso592079f8f.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 01:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726130591; x=1726735391; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8C7k36zp6nuvCl3rPtCpYR0WkNI/VFLekJAPO3wtMQ8=;
        b=b7r5micS/TmaSCBk4zLpjNbXIUi+eAY/6vBViNvfBP/iX9Tpwu1/sUPl4aCxu8KuI0
         TUYGkB2rLm4Pg7OxPaav5aflweSC1mBxlrenDtdyh5SXMPRnGThuOt1uDeJVQpbl4StB
         AXu94Mp8tBc5EcIPB8lyOG00/r3E0CfUYOyZujked/ls4LAwN7We7byjKg6WR+X8Mbje
         2SncCTKZE9Yna4zjSnNFawqkqnkC3xgg6RTZXwsYkD+iVkrfZbLbPEDzMPQ3EVyeZGbU
         fdcvr1lE89KSlqqYafydgvNVdaQNVxQhpYG0EfvPNSgxd0eI4FM5XgZAUwoL6FNbLqRC
         iSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726130591; x=1726735391;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8C7k36zp6nuvCl3rPtCpYR0WkNI/VFLekJAPO3wtMQ8=;
        b=q9Naayhf2x78Q5bF4Bx0Yo0Hpuuct6VlL+rumV2Kt2PAhEVdpjl0Uq2rdzySivr+pz
         qamJ0emgzsVAMGAwmXZDOrsId8QKYAIYEzJbEatExQHs5Si4HGQ6YpCkQk1QVXuCdRrW
         QeMfz+886AH/AmuTJrSPoqaeKBkKA3UKc/kuzFgDW4EQdz7tBFDVxB69J5apFKtw862k
         1lF8HIyg+uqUNWzX348/FYQwjpF7O8oXqsrkHIQXaYqBsVjA3BVgu74bbce2ttM6r7GC
         EFddB2iBl7Jn1+apYju75aj/xckV5npcN4VkkgNcDOkR4orjf6nt+MVkmxHVEfp4EDOE
         C/mg==
X-Forwarded-Encrypted: i=1; AJvYcCW6dlHVX/YA1WfD+Lw4UfkKfIOywASmvINyg45K/9QE3O1zlTdDQDYLiwdyOjp2VO9kuCk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2fqKRu9OkImAeuc6aZTSBjJAKjHnwqgf32LnzB4wNd0b/2JJl
	GEC0KJLlaTA3D/R8wioIGTlsVtjJz6EsTHX4ijVEpw3FOZtES5eGZcuCMxAxEAk=
X-Google-Smtp-Source: AGHT+IEYZ4XupAL5Kt47RVjQRhyZJxYobH7jy6a6s8BJ0ZFnSihZjOZtxf3EjySqNpaSaFXNRBS04g==
X-Received: by 2002:a5d:6250:0:b0:367:9d05:cf1f with SMTP id ffacd0b85a97d-378c2cf40c5mr1021162f8f.14.1726130590279;
        Thu, 12 Sep 2024 01:43:10 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:75b8:2c66:dc25:5ab3:ad59? ([2a10:bac0:b000:75b8:2c66:dc25:5ab3:ad59])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42cb5a66475sm135924465e9.44.2024.09.12.01.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 01:43:10 -0700 (PDT)
Message-ID: <55366da1-2b9c-4d12-aba7-93c15a1b3b09@suse.com>
Date: Thu, 12 Sep 2024 11:43:08 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Xiaoyao Li <xiaoyao.li@intel.com>,
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
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <45963b9e-eec8-40b1-9e86-226504c463b8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 12.09.24 г. 11:37 ч., Xiaoyao Li wrote:
> On 9/12/2024 4:04 PM, Nikolay Borisov wrote:
>>
>>
>> On 5.09.24 г. 16:36 ч., Xiaoyao Li wrote:
>>> On 9/4/2024 7:58 PM, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
>>>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>>
>>>>> While TDX module reports a set of capabilities/features that it
>>>>> supports, what KVM currently supports might be a subset of them.
>>>>> E.g., DEBUG and PERFMON are supported by TDX module but currently not
>>>>> supported by KVM.
>>>>>
>>>>> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of 
>>>>> TDX.
>>>>> supported_attrs and suppported_xfam are validated against fixed0/1
>>>>> values enumerated by TDX module. Configurable CPUID bits derive 
>>>>> from TDX
>>>>> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>>>>> i.e., mask off the bits that are configurable in the view of TDX 
>>>>> module
>>>>> but not supported by KVM yet.
>>>>>
>>>>> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it 
>>>>> to 0
>>>>> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
>>>>>
>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>>> ---
>>>>> uAPI breakout v1:
>>>>>   - Change setup_kvm_tdx_caps() to use the exported 'struct 
>>>>> tdx_sysinfo'
>>>>>     pointer.
>>>>>   - Change how to copy 'kvm_tdx_cpuid_config' since 'struct 
>>>>> tdx_sysinfo'
>>>>>     doesn't have 'kvm_tdx_cpuid_config'.
>>>>>   - Updates for uAPI changes
>>>>> ---
>>>>>   arch/x86/include/uapi/asm/kvm.h |  2 -
>>>>>   arch/x86/kvm/vmx/tdx.c          | 81 
>>>>> +++++++++++++++++++++++++++++++++
>>>>>   2 files changed, 81 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/include/uapi/asm/kvm.h 
>>>>> b/arch/x86/include/uapi/asm/kvm.h
>>>>> index 47caf508cca7..c9eb2e2f5559 100644
>>>>> --- a/arch/x86/include/uapi/asm/kvm.h
>>>>> +++ b/arch/x86/include/uapi/asm/kvm.h
>>>>> @@ -952,8 +952,6 @@ struct kvm_tdx_cmd {
>>>>>       __u64 hw_error;
>>>>>   };
>>>>> -#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>>>>> -
>>>>>   struct kvm_tdx_cpuid_config {
>>>>>       __u32 leaf;
>>>>>       __u32 sub_leaf;
>>>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>>>> index 90b44ebaf864..d89973e554f6 100644
>>>>> --- a/arch/x86/kvm/vmx/tdx.c
>>>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>>>> @@ -31,6 +31,19 @@ static void __used tdx_guest_keyid_free(int keyid)
>>>>>       ida_free(&tdx_guest_keyid_pool, keyid);
>>>>>   }
>>>>> +#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>>>>> +
>>>>> +struct kvm_tdx_caps {
>>>>> +    u64 supported_attrs;
>>>>> +    u64 supported_xfam;
>>>>> +
>>>>> +    u16 num_cpuid_config;
>>>>> +    /* This must the last member. */
>>>>> +    DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
>>>>> +};
>>>>> +
>>>>> +static struct kvm_tdx_caps *kvm_tdx_caps;
>>>>> +
>>>>>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>>>>>   {
>>>>>       const struct tdx_sysinfo_td_conf *td_conf = 
>>>>> &tdx_sysinfo->td_conf;
>>>>> @@ -131,6 +144,68 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user 
>>>>> *argp)
>>>>>       return r;
>>>>>   }
>>>>> +#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
>>>>
>>>> Why isn't TDX_TD_ATTR_DEBUG added as well?
>>>
>>> Because so far KVM doesn't support all the features of a DEBUG TD for 
>>> userspace. e.g., KVM doesn't provide interface for userspace to 
>>> read/write private memory of DEBUG TD.
>>
>> But this means that you can't really run a TDX with SEPT_VE_DISABLE 
>> disabled for debugging purposes, so perhaps it might be necessary to 
>> rethink the condition allowing SEPT_VE_DISABLE to be disabled. Without 
>> the debug flag and SEPT_VE_DISABLE disabled the code refuses to start 
>> the VM, what if one wants to debug some SEPT issue by having an oops 
>> generated inside the vm ?
> 
> sept_ve_disable is allowed to be disable, i.e., set to 0.
> 
> I think there must be some misunderstanding.

There isn't, the current code is:

   201         if (!(td_attr & ATTR_SEPT_VE_DISABLE)) { 

     1                 const char *msg = "TD misconfiguration: 
SEPT_VE_DISABLE attribute must be set.";
     2 

     3                 /* Relax SEPT_VE_DISABLE check for debug TD. */ 

     4                 if (td_attr & ATTR_DEBUG) 

     5                         pr_warn("%s\n", msg); 

     6                 else 

     7                         tdx_panic(msg); 

     8         }


I.e if we disable SEPT_VE_DISABLE without having ATTR_DEBUG it results 
in a panic.

> 
>>>
>>>> <snip>
>>>
>>>
> 

