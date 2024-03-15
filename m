Return-Path: <kvm+bounces-11878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C8C87C76E
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 03:19:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B9581C20F79
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 02:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD3579C1;
	Fri, 15 Mar 2024 02:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gPcW2PxH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D865612E;
	Fri, 15 Mar 2024 02:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710469145; cv=none; b=UsGGVI7buqxdO8GuenB+aL3R9bF1cmWY2ygMFb5ObniyNYG2WJg5ujNXhEmo50FeJFhhxuBg8/xy9rV3U865jOEe4mX3FrNGN7/oCfHaHI4V2yRmR9O++Vhzg/j7/7Fa324g6RElusMaLikSSSFcMt3yJdv6O8ToSy/IdJ+f0Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710469145; c=relaxed/simple;
	bh=3yVcTPMCUb0I93YKr63zWkcjxC95tX4f7ziTHbEe/wQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZvT7RxUfJJSvWjhBiSjCVr9WfM0GlcEvkMWos21HpTpdXWVjMylkGrnFxJX5iIBmx4RoeIra/vGwk+ymFtvnD/aA7tZFAmR/xFsINRuwRQu8doDaxAeCDLpTRp3A4kLLpTGuka2BMnol/Un/kZYNoaAuivbLhPcZg8WFs9PAoHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gPcW2PxH; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710469140; x=1742005140;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3yVcTPMCUb0I93YKr63zWkcjxC95tX4f7ziTHbEe/wQ=;
  b=gPcW2PxHZIhVb3AND7idItUM5f+QDN5SNAmaI9VEmTHbKzArQYh+kxUD
   C8v1xMngxvSJizfnkaOm7D25pLqxV1Ly/ZzNqfqL2tlOHKeSUDFZR/lt4
   bznFpIDGJjM1BQ014QlLltnMeEjY6LYTQPMG4iXN3ggMRl20VemQmN/7W
   mOkotU1om+gNaO3ClrStzp0a3I7my4i1Typ71o4ah/RbBvU+9XjIex+3M
   M309XB2AnUsbTObPrrTTD5b3jNEoobnLyOLl0ez0HuFGDz5VhzGW1KpT6
   vV2HbuD8jMMzfzIbbo42a3YeIGxcJ54n+dHVQlQed+g6GFEZcrOZm+C9F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="22844058"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="22844058"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 19:18:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="12961841"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 19:18:56 -0700
Message-ID: <15a13c5d-df88-46cf-8d88-2c8b94ff41ff@intel.com>
Date: Fri, 15 Mar 2024 10:18:52 +0800
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
To: "Huang, Kai" <kai.huang@intel.com>, isaku.yamahata@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
 <e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/15/2024 7:09 AM, Huang, Kai wrote:
> 
>> +struct tdx_info {
>> +    u64 features0;
>> +    u64 attributes_fixed0;
>> +    u64 attributes_fixed1;
>> +    u64 xfam_fixed0;
>> +    u64 xfam_fixed1;
>> +
>> +    u16 num_cpuid_config;
>> +    /* This must the last member. */
>> +    DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
>> +};
>> +
>> +/* Info about the TDX module. */
>> +static struct tdx_info *tdx_info;
>> +
>>   #define TDX_MD_MAP(_fid, _ptr)            \
>>       { .fid = MD_FIELD_ID_##_fid,        \
>>         .ptr = (_ptr), }
>> @@ -66,7 +81,7 @@ static size_t tdx_md_element_size(u64 fid)
>>       }
>>   }
>> -static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>> +static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>>   {
>>       struct tdx_md_map *m;
>>       int ret, i;
>> @@ -84,9 +99,26 @@ static int __used tdx_md_read(struct tdx_md_map 
>> *maps, int nr_maps)
>>       return 0;
>>   }
>> +#define TDX_INFO_MAP(_field_id, _member)            \
>> +    TD_SYSINFO_MAP(_field_id, struct tdx_info, _member)
>> +
>>   static int __init tdx_module_setup(void)
>>   {
>> +    u16 num_cpuid_config;
>>       int ret;
>> +    u32 i;
>> +
>> +    struct tdx_md_map mds[] = {
>> +        TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
>> +    };
>> +
>> +    struct tdx_metadata_field_mapping fields[] = {
>> +        TDX_INFO_MAP(FEATURES0, features0),
>> +        TDX_INFO_MAP(ATTRS_FIXED0, attributes_fixed0),
>> +        TDX_INFO_MAP(ATTRS_FIXED1, attributes_fixed1),
>> +        TDX_INFO_MAP(XFAM_FIXED0, xfam_fixed0),
>> +        TDX_INFO_MAP(XFAM_FIXED1, xfam_fixed1),
>> +    };
>>       ret = tdx_enable();
>>       if (ret) {
>> @@ -94,7 +126,48 @@ static int __init tdx_module_setup(void)
>>           return ret;
>>       }
>> +    ret = tdx_md_read(mds, ARRAY_SIZE(mds));
>> +    if (ret)
>> +        return ret;
>> +
>> +    tdx_info = kzalloc(sizeof(*tdx_info) +
>> +               sizeof(*tdx_info->cpuid_configs) * num_cpuid_config,
>> +               GFP_KERNEL);
>> +    if (!tdx_info)
>> +        return -ENOMEM;
>> +    tdx_info->num_cpuid_config = num_cpuid_config;
>> +
>> +    ret = tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdx_info);
>> +    if (ret)
>> +        goto error_out;
>> +
>> +    for (i = 0; i < num_cpuid_config; i++) {
>> +        struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
>> +        u64 leaf, eax_ebx, ecx_edx;
>> +        struct tdx_md_map cpuids[] = {
>> +            TDX_MD_MAP(CPUID_CONFIG_LEAVES + i, &leaf),
>> +            TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2, &eax_ebx),
>> +            TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2 + 1, &ecx_edx),
>> +        };
>> +
>> +        ret = tdx_md_read(cpuids, ARRAY_SIZE(cpuids));
>> +        if (ret)
>> +            goto error_out;
>> +
>> +        c->leaf = (u32)leaf;
>> +        c->sub_leaf = leaf >> 32;
>> +        c->eax = (u32)eax_ebx;
>> +        c->ebx = eax_ebx >> 32;
>> +        c->ecx = (u32)ecx_edx;
>> +        c->edx = ecx_edx >> 32;
> 
> OK I can see why you don't want to use ...
> 
>      struct tdx_metadata_field_mapping fields[] = {
>          TDX_INFO_MAP(NUM_CPUID_CONFIG, num_cpuid_config),
>      };
> 
> ... to read num_cpuid_config first, because the memory to hold @tdx_info 
> hasn't been allocated, because its size depends on the num_cpuid_config.
> 
> And I confess it's because the tdx_sys_metadata_field_read() that got 
> exposed in patch ("x86/virt/tdx: Export global metadata read 
> infrastructure") only returns 'u64' for all metadata field, and you 
> didn't want to use something like this:
> 
>      u64 num_cpuid_config;
> 
>      tdx_sys_metadata_field_read(..., &num_cpuid_config);
> 
>      ...
> 
>      tdx_info->num_cpuid_config = num_cpuid_config;
> 
> Or you can explicitly cast:
> 
>      tdx_info->num_cpuid_config = (u16)num_cpuid_config;
> 
> (I know people may don't like the assigning 'u64' to 'u16', but it seems 
> nothing wrong to me, because the way done in (1) below effectively has 
> the same result comparing to type case).
> 
> But there are other (better) ways to do:
> 
> 1) you can introduce a helper as suggested by Xiaoyao in [*]:
> 
> 
>      int tdx_sys_metadata_read_single(u64 field_id,
>                      int bytes,  void *buf)
>      {
>          return stbuf_read_sys_metadata_field(field_id, 0,
>                          bytes, buf);
>      }
> 
> And do:
> 
>      tdx_sys_metadata_read_single(NUM_CPUID_CONFIG,
>          sizeof(num_cpuid_config), &num_cpuid_config);
> 
> That's _much_ cleaner than the 'struct tdx_md_map', which only confuses 
> people.
> 
> But I don't think we need to do this as mentioned above -- we just do 
> type cast.

type cast needs another tmp variable to hold the output of u64.

The reason I want to introduce tdx_sys_metadata_read_single() is to 
provide a simple and unified interface for other codes to read one 
metadata field, instead of letting the caller to use temporary u64 
variable and handle the cast or memcpy itself.

> [*] 
> https://lore.kernel.org/lkml/bd61e29d-5842-4136-b30f-929b00bdf6f9@intel.com/T/#m2512e378c83bc44d3ca653f96f25c3fc85eb0e8a
> 
> 
> 
> 


