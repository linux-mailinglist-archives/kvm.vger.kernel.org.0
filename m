Return-Path: <kvm+bounces-11882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EBC887C871
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 06:12:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70D111C2228F
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 05:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D39FC1C;
	Fri, 15 Mar 2024 05:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/jcyLfv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EABBDF43;
	Fri, 15 Mar 2024 05:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710479512; cv=none; b=u+ril06hdVn096Kokz86/xl24s2MnSOxiaGuMijV/wpVVyxWpCI0qvXHwdrwY59lVLih434FpLyU5aYf33pMgTqIBdFM9LpIuFbXIcfZqenWBoUymCTIz4SefxJB798wo7DyEF+Kxs98DMaexmncNkqyQuvAeP4y/THjZ748dlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710479512; c=relaxed/simple;
	bh=Gi3R+/Q1NJs+2Ed2bS6L4K9DFuU1AoRGE03dZhlfigs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Enk4MQmrWPWG9hq9++sgiJh91sZ4YV++GJoQjpnwNx4nAQvyveag+3l1HslWRaYdoTK+r9Zu0meDzsxdYwoadalVd8wEXnNZMCEhEMeLfiWPThThwkGhFfQljwkk1CUGi16sVxx+9Ac2woKpAHnVLhtqxmvEAoPiLdJR/3Wka7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/jcyLfv; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710479510; x=1742015510;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gi3R+/Q1NJs+2Ed2bS6L4K9DFuU1AoRGE03dZhlfigs=;
  b=R/jcyLfvxejogBSFowWs7jnmdk29PQGEA/y+MzWUI6ypAB23mW4bBoew
   LyJzv/uAcv6OpdLjtBv5kk3VpepaE39gu3bFanFZEYkg0ZQcD3bPw3fOf
   i6jme2uEn6YA3HotnVsFV8Q5N6CFeq+YDpRl0Wjds6S5pUm5IcG0zpVSb
   FFuoOQ5sEYInsa7e/QLHAD64T+Sm4aL+oxn07DefrU1RUUetCCDPDldnD
   5totFo+Gx1v9a87+VNguHJsx6ShgVTkSLEej+q3fiZXilhTf3VfyNid/2
   uqbVi7nusU0cSR3UeIm9wwQZTLMIUQwBJJ0TRO/PqXr2KE5vYTDj+HcGu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="15884789"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="15884789"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 22:11:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="35680318"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 22:11:40 -0700
Message-ID: <10c41a88-d692-4ff5-a0c3-ae13a06a055c@intel.com>
Date: Fri, 15 Mar 2024 13:11:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX
 module on initialization
Content-Language: en-US
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
 <e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com>
 <15a13c5d-df88-46cf-8d88-2c8b94ff41ff@intel.com>
 <aa1ed4c118177e3e341eebccecac3b07bf75a47d.camel@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aa1ed4c118177e3e341eebccecac3b07bf75a47d.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/15/2024 12:57 PM, Huang, Kai wrote:
> On Fri, 2024-03-15 at 10:18 +0800, Li, Xiaoyao wrote:
>> On 3/15/2024 7:09 AM, Huang, Kai wrote:
>>>
>>>> +struct tdx_info {
>>>> +    u64 features0;
>>>> +    u64 attributes_fixed0;
>>>> +    u64 attributes_fixed1;
>>>> +    u64 xfam_fixed0;
>>>> +    u64 xfam_fixed1;
>>>> +
>>>> +    u16 num_cpuid_config;
>>>> +    /* This must the last member. */
>>>> +    DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
>>>> +};
>>>> +
>>>> +/* Info about the TDX module. */
>>>> +static struct tdx_info *tdx_info;
>>>> +
>>>>    #define TDX_MD_MAP(_fid, _ptr)            \
>>>>        { .fid = MD_FIELD_ID_##_fid,        \
>>>>          .ptr = (_ptr), }
>>>> @@ -66,7 +81,7 @@ static size_t tdx_md_element_size(u64 fid)
>>>>        }
>>>>    }
>>>> -static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>>>> +static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>>>>    {
>>>>        struct tdx_md_map *m;
>>>>        int ret, i;
>>>> @@ -84,9 +99,26 @@ static int __used tdx_md_read(struct tdx_md_map
>>>> *maps, int nr_maps)
>>>>        return 0;
>>>>    }
>>>> +#define TDX_INFO_MAP(_field_id, _member)            \
>>>> +    TD_SYSINFO_MAP(_field_id, struct tdx_info, _member)
>>>> +
>>>>    static int __init tdx_module_setup(void)
>>>>    {
>>>> +    u16 num_cpuid_config;
>>>>        int ret;
>>>> +    u32 i;
>>>> +
>>>> +    struct tdx_md_map mds[] = {
>>>> +        TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
>>>> +    };
>>>> +
>>>> +    struct tdx_metadata_field_mapping fields[] = {
>>>> +        TDX_INFO_MAP(FEATURES0, features0),
>>>> +        TDX_INFO_MAP(ATTRS_FIXED0, attributes_fixed0),
>>>> +        TDX_INFO_MAP(ATTRS_FIXED1, attributes_fixed1),
>>>> +        TDX_INFO_MAP(XFAM_FIXED0, xfam_fixed0),
>>>> +        TDX_INFO_MAP(XFAM_FIXED1, xfam_fixed1),
>>>> +    };
>>>>        ret = tdx_enable();
>>>>        if (ret) {
>>>> @@ -94,7 +126,48 @@ static int __init tdx_module_setup(void)
>>>>            return ret;
>>>>        }
>>>> +    ret = tdx_md_read(mds, ARRAY_SIZE(mds));
>>>> +    if (ret)
>>>> +        return ret;
>>>> +
>>>> +    tdx_info = kzalloc(sizeof(*tdx_info) +
>>>> +               sizeof(*tdx_info->cpuid_configs) * num_cpuid_config,
>>>> +               GFP_KERNEL);
>>>> +    if (!tdx_info)
>>>> +        return -ENOMEM;
>>>> +    tdx_info->num_cpuid_config = num_cpuid_config;
>>>> +
>>>> +    ret = tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdx_info);
>>>> +    if (ret)
>>>> +        goto error_out;
>>>> +
>>>> +    for (i = 0; i < num_cpuid_config; i++) {
>>>> +        struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
>>>> +        u64 leaf, eax_ebx, ecx_edx;
>>>> +        struct tdx_md_map cpuids[] = {
>>>> +            TDX_MD_MAP(CPUID_CONFIG_LEAVES + i, &leaf),
>>>> +            TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2, &eax_ebx),
>>>> +            TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2 + 1, &ecx_edx),
>>>> +        };
>>>> +
>>>> +        ret = tdx_md_read(cpuids, ARRAY_SIZE(cpuids));
>>>> +        if (ret)
>>>> +            goto error_out;
>>>> +
>>>> +        c->leaf = (u32)leaf;
>>>> +        c->sub_leaf = leaf >> 32;
>>>> +        c->eax = (u32)eax_ebx;
>>>> +        c->ebx = eax_ebx >> 32;
>>>> +        c->ecx = (u32)ecx_edx;
>>>> +        c->edx = ecx_edx >> 32;
>>>
>>> OK I can see why you don't want to use ...
>>>
>>>       struct tdx_metadata_field_mapping fields[] = {
>>>           TDX_INFO_MAP(NUM_CPUID_CONFIG, num_cpuid_config),
>>>       };
>>>
>>> ... to read num_cpuid_config first, because the memory to hold @tdx_info
>>> hasn't been allocated, because its size depends on the num_cpuid_config.
>>>
>>> And I confess it's because the tdx_sys_metadata_field_read() that got
>>> exposed in patch ("x86/virt/tdx: Export global metadata read
>>> infrastructure") only returns 'u64' for all metadata field, and you
>>> didn't want to use something like this:
>>>
>>>       u64 num_cpuid_config;
>>>
>>>       tdx_sys_metadata_field_read(..., &num_cpuid_config);
>>>
>>>       ...
>>>
>>>       tdx_info->num_cpuid_config = num_cpuid_config;
>>>
>>> Or you can explicitly cast:
>>>
>>>       tdx_info->num_cpuid_config = (u16)num_cpuid_config;
>>>
>>> (I know people may don't like the assigning 'u64' to 'u16', but it seems
>>> nothing wrong to me, because the way done in (1) below effectively has
>>> the same result comparing to type case).
>>>
>>> But there are other (better) ways to do:
>>>
>>> 1) you can introduce a helper as suggested by Xiaoyao in [*]:
>>>
>>>
>>>       int tdx_sys_metadata_read_single(u64 field_id,
>>>                       int bytes,  void *buf)
>>>       {
>>>           return stbuf_read_sys_metadata_field(field_id, 0,
>>>                           bytes, buf);
>>>       }
>>>
>>> And do:
>>>
>>>       tdx_sys_metadata_read_single(NUM_CPUID_CONFIG,
>>>           sizeof(num_cpuid_config), &num_cpuid_config);
>>>
>>> That's _much_ cleaner than the 'struct tdx_md_map', which only confuses
>>> people.
>>>
>>> But I don't think we need to do this as mentioned above -- we just do
>>> type cast.
>>
>> type cast needs another tmp variable to hold the output of u64.
>>
>> The reason I want to introduce tdx_sys_metadata_read_single() is to
>> provide a simple and unified interface for other codes to read one
>> metadata field, instead of letting the caller to use temporary u64
>> variable and handle the cast or memcpy itself.
>>
> 
> You can always use u64 to hold u16 metadata field AFAICT, so it doesn't have to
> be temporary.
> 
> Here is what Isaku can do using the current API:
> 
> 	u64 num_cpuid_config;
 >
> 
> 	...
> 
> 	tdx_sys_metadata_field_read(NUM_CPUID_CONFIG, &num_cpuid_config);
> 
> 	tdx_info = kzalloc(calculate_tdx_info_size(num_cpuid_config), ...);
> 
> 	tdx_info->num_cpuid_config = num_cpuid_config;

Dosen't num_cpuid_config serve as temporary variable in some sense?

For this case, it needs to be used for calculating the size of tdx_info. 
So we have to have it. But it's not the common case.

E.g., if we have another non-u64 field (e.g., field_x) in tdx_info, we 
cannot to read it via

	tdx_sys_metadata_field_read(FIELD_X_ID, &tdx_info->field_x);

we have to use a temporary u64 variable.

> 	...
> 
> (you can do explicit (u16)num_cpuid_config type cast above if you want.)
> 
> With your suggestion, here is what Isaku can do:
> 
> 	u16 num_cpuid_config;
> 
> 	...
> 
> 	tdx_sys_metadata_read_single(NUM_CPUID_CONFIG,
> sizeof(num_cpuid_config),
> 				&num_cpuid_config);
> 
> 	tdx_info = kzalloc(calculate_tdx_info_size(num_cpuid_config), ...);
> 
> 	tdx_info->num_cpuid_config = num_cpuid_config;
> 
> 	...
> 
> I don't see big difference?
> 
> One example that the current tdx_sys_metadata_field_read() doesn't quite fit is
> you have something like this:
> 
> 	struct {
> 		u16 whatever;
> 		...
> 	} st;
> 
> 	tdx_sys_metadata_field_read(FIELD_ID_WHATEVER, &st.whatever);
> 
> But for this use case you are not supposed to use tdx_sys_metadata_field_read(),
> but use tdx_sys_metadata_read() which has a mapping provided anyway.
> 
> So, while I don't quite object your proposal, I don't see it being quite
> necessary.
> 
> I'll let other people to have a say.
> 
> 


