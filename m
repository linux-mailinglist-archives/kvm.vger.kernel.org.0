Return-Path: <kvm+bounces-26666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A30E9763E1
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 10:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EC6C1C20E86
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 08:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37EC19047A;
	Thu, 12 Sep 2024 08:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xtfg0Jvo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB2318F2DD
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 08:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726128260; cv=none; b=Eu/Vue87hVA+23lsWKP20BgSGQb9Kx2s2oZoB4TP6Ez9UnZCIifgYHEaB8Xl65SVrrPJkDk1Q3H7sRDSs4S7j+vGLIX2wbEKq7uDG0XMu92oKudhaxunxQ6R0iohhBPLfe6Ao5QkkTWSqDF6DuZHbOzF4t+xHXv10H7lMnshF2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726128260; c=relaxed/simple;
	bh=DZz6BPm5Y8g79lftloZDX6D22Au7imvIxsJZijxch6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kIkedp7ydxc1zLhUn3J5ZJt5q4GTlc/F2axBG2w67Cv3AoC6xvCANuXKvmba2XjRoLkzKhfNiBsTBw9RWmdUsHjdhW/g0lDp3NGqzK86chcXomdQwy2cW0SrFh0UIhI+e7O6B45IPmIhfZwocp62yeidPI7jmIQ5mjyJEorE6r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xtfg0Jvo; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c275491c61so798093a12.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 01:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726128255; x=1726733055; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TBJ2+XdUW/qafjoJnmA9ma/Xf9l2jCrkQ02M3zdM7sU=;
        b=Xtfg0Jvodg73B8YY4wiev9zXoagpyjbY1kwhdbm63cneygzsVzDYWvjdhTexvr0uwf
         F+5yAjQbqAZFacJOr/VbxT5UH+JxmGNXXcKlaWCqmrDLhbiNq23wHaPJV874QShs64rr
         svQ9lqpNoE5kcb5+DiO32wRywtfocoaYDE/XgvLxSy8OSN3r3JyJqaH3HZHdZBEzCrAI
         sRHesEBfccUtfXq0oZCdeU8o+uPIeUablN9vQLIxdG53ZgMOnu3ndmAjmcLM5TtQntEF
         r6+AIX6bSDfqNkrlG0K5xxZV8IlRoEnvqFG9Cf+Gp/59frinoG106b8Vrm8JfddJ5oPh
         HLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726128255; x=1726733055;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBJ2+XdUW/qafjoJnmA9ma/Xf9l2jCrkQ02M3zdM7sU=;
        b=D80PI0qMJUgaCx83tGIZNIk1DBl6MYxQU8si+7LEt1w4mIQnHey0YLo+WEPFms/W1+
         8iyb41nppd4Iy8HHd+1ijyn0cmWLAvgDU7bDg7hkVtlIwyzuJSuvefwIxaYbnxDSWhXU
         9veMmyP/aLYIuqWNykbYXCN6ZlgSVJt6uGnSfOZKHrKB+96QMAUdi6zag69m0EiyBa0Y
         0ZtevbhmhfY8SxkSLVfp/gpSX8jENV6ZQsbaIwMi9PF4X6M4l1aAC7pb2hDaVtJVjUmL
         1UbFtHI5QLaijRplenaStltJOYcq9/rP5mg1DjkDqqprW83qQ30DwO0B94wYe9uQcmrX
         +VGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOZUBKSLftjGo0GKaBfIgvfeKp0GpiV3ffT7fC9jEFWUzyv40ZayPy9f5ejzXGrku5Wo4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYWx7aAS9eH6f6FCkXyGujuNwf0Hf/ExJtBBnpZSB3rbsR91B6
	oENTSHvWwlGJcc21455A/6pKNSgZ+keiThHe6HWZ0TCuuBmiMhQnRBnYkHETEJQ=
X-Google-Smtp-Source: AGHT+IF/rJztx9gqu2mmKHo36afM3kDLZPJkVPeDslFK1r3K2IZksYBImDJOHrN8xF8lPscvyhwlwg==
X-Received: by 2002:a05:6402:1e8f:b0:5c3:c548:bb25 with SMTP id 4fb4d7f45d1cf-5c413e4d2eamr2008032a12.23.1726128254287;
        Thu, 12 Sep 2024 01:04:14 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:75b8:97eb:f4c4:420c:463b? ([2a10:bac0:b000:75b8:97eb:f4c4:420c:463b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd468casm6214095a12.33.2024.09.12.01.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 01:04:13 -0700 (PDT)
Message-ID: <2a2dd102-2ad9-4bbd-a5f7-5994de3870ae@suse.com>
Date: Thu, 12 Sep 2024 11:04:12 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Xiaoyao Li <xiaoyao.li@intel.com>, Nikolay Borisov
 <nik.borisov@suse.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <caa4407a-b838-4e1b-bb3d-87518f3de66b@suse.com>
 <aa764aad-1736-459f-896e-4f43bfe8b18d@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <aa764aad-1736-459f-896e-4f43bfe8b18d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5.09.24 г. 16:36 ч., Xiaoyao Li wrote:
> On 9/4/2024 7:58 PM, Nikolay Borisov wrote:
>>
>>
>> On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>
>>> While TDX module reports a set of capabilities/features that it
>>> supports, what KVM currently supports might be a subset of them.
>>> E.g., DEBUG and PERFMON are supported by TDX module but currently not
>>> supported by KVM.
>>>
>>> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
>>> supported_attrs and suppported_xfam are validated against fixed0/1
>>> values enumerated by TDX module. Configurable CPUID bits derive from TDX
>>> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>>> i.e., mask off the bits that are configurable in the view of TDX module
>>> but not supported by KVM yet.
>>>
>>> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
>>> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>> ---
>>> uAPI breakout v1:
>>>   - Change setup_kvm_tdx_caps() to use the exported 'struct tdx_sysinfo'
>>>     pointer.
>>>   - Change how to copy 'kvm_tdx_cpuid_config' since 'struct tdx_sysinfo'
>>>     doesn't have 'kvm_tdx_cpuid_config'.
>>>   - Updates for uAPI changes
>>> ---
>>>   arch/x86/include/uapi/asm/kvm.h |  2 -
>>>   arch/x86/kvm/vmx/tdx.c          | 81 +++++++++++++++++++++++++++++++++
>>>   2 files changed, 81 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/uapi/asm/kvm.h 
>>> b/arch/x86/include/uapi/asm/kvm.h
>>> index 47caf508cca7..c9eb2e2f5559 100644
>>> --- a/arch/x86/include/uapi/asm/kvm.h
>>> +++ b/arch/x86/include/uapi/asm/kvm.h
>>> @@ -952,8 +952,6 @@ struct kvm_tdx_cmd {
>>>       __u64 hw_error;
>>>   };
>>> -#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>>> -
>>>   struct kvm_tdx_cpuid_config {
>>>       __u32 leaf;
>>>       __u32 sub_leaf;
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index 90b44ebaf864..d89973e554f6 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -31,6 +31,19 @@ static void __used tdx_guest_keyid_free(int keyid)
>>>       ida_free(&tdx_guest_keyid_pool, keyid);
>>>   }
>>> +#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>>> +
>>> +struct kvm_tdx_caps {
>>> +    u64 supported_attrs;
>>> +    u64 supported_xfam;
>>> +
>>> +    u16 num_cpuid_config;
>>> +    /* This must the last member. */
>>> +    DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
>>> +};
>>> +
>>> +static struct kvm_tdx_caps *kvm_tdx_caps;
>>> +
>>>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>>>   {
>>>       const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
>>> @@ -131,6 +144,68 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user 
>>> *argp)
>>>       return r;
>>>   }
>>> +#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
>>
>> Why isn't TDX_TD_ATTR_DEBUG added as well?
> 
> Because so far KVM doesn't support all the features of a DEBUG TD for 
> userspace. e.g., KVM doesn't provide interface for userspace to 
> read/write private memory of DEBUG TD.

But this means that you can't really run a TDX with SEPT_VE_DISABLE 
disabled for debugging purposes, so perhaps it might be necessary to 
rethink the condition allowing SEPT_VE_DISABLE to be disabled. Without 
the debug flag and SEPT_VE_DISABLE disabled the code refuses to start 
the VM, what if one wants to debug some SEPT issue by having an oops 
generated inside the vm ?

> 
>> <snip>
> 
> 

