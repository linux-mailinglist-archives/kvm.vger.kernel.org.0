Return-Path: <kvm+bounces-11796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC6D87BF0A
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 15:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 581ADB2387F
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 14:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B026FE02;
	Thu, 14 Mar 2024 14:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MK67uHSx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39AD1D69C;
	Thu, 14 Mar 2024 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710426955; cv=none; b=TIiC2zOfJn1LA8ORgqDJBw8WF+mbWNG3cf77e3NW6xcLmcRIAZHKv8oZ0PocNamoOSMYEWBEXZ24juA4FATsWZ1NRAxVEJJGEYZ23BRyGGcvR9vpIqpvBWq8thmVf6IaGtiNCg5dIX0Fh1081V95QqJ/Px3lrUuR4Oz+gc6vwB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710426955; c=relaxed/simple;
	bh=6xbyJ7GIbC4QvTGfOs9ps+p/AN8HhIqQUhKt35m2s9Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=bfP1RpGHF+j/uqI6AUngb0V/G9O03MqvWqeoFZmuNfHdX1Xm7zTQ0BqFJ6xIr/7Lr9G8qJuBE+m95fBkAazyCfKkaIW7hSmb4JtTs/unXPO6eVCscCUWRsmzJFaFoad+plSUt2lhoD01SZTKqP+HcAA78AI5fkbmwSs+wHHMkQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MK67uHSx; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710426952; x=1741962952;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=6xbyJ7GIbC4QvTGfOs9ps+p/AN8HhIqQUhKt35m2s9Y=;
  b=MK67uHSx/ay9e31VRrQkJmBUbCzwwmW9eaVUpE8ZugFeVe47dauzwjIT
   /ciHnDddS6i9Zc/wuYckVa2Qnrd/BhfOfpPT3keLzWVQqi6xAj4EDd29Z
   xlOB2//8YDQLmdfbfzbHvBgr1rZ/zkW9e7aIDO4FoUMgmPT2oOnULC5fM
   5DtdzpI852US7D0UZGtt+1B1UhrSInlnE4lzurPsH/t+3vzDmowJyvFpK
   Te3WrcVNX6G222eWiWQCZJytQtnVdKleKXErvmdgdW+lWGRb3CWmzakfl
   ozUhBrz/4M07lFnYypFR+niQOtPiJGi69DniBCy/GRocHhvu8VobGwdkh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="15800979"
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="15800979"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 07:35:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="12196456"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 07:35:50 -0700
Message-ID: <06fab911-2364-4b1d-81f4-1517da334507@linux.intel.com>
Date: Thu, 14 Mar 2024 22:35:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 033/130] KVM: TDX: Add helper function to read TDX
 metadata in array
From: Binbin Wu <binbin.wu@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <72b528863d14b322df553efa285ef4637ee67581.1708933498.git.isaku.yamahata@intel.com>
 <2ffcdb7b-79c1-4516-b889-55316b480cb0@linux.intel.com>
In-Reply-To: <2ffcdb7b-79c1-4516-b889-55316b480cb0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/14/2024 5:17 PM, Binbin Wu wrote:
>
>
> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> To read meta data in series, use table.
>> Instead of metadata_read(fid0, &data0); metadata_read(...); ...
>> table = { {fid0, &data0}, ...}; metadata-read(tables).
>> TODO: Once the TDX host code introduces its framework to read TDX 
>> metadata,
>> drop this patch and convert the code that uses this.
>
> Do you mean the patch 1-5 included in this patch set.
> I think the patch 1-5 of this patch set is doing this thing, right?
>
> Since they are already there, I think you can use them directly in this
> patch set instead of introducing these temp code?
I may have some mis-understanding, but I think the TODO has been done, 
right?

>
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>> v18:
>> - newly added
>> ---
>>   arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 45 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index cde971122c1e..dce21f675155 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -6,6 +6,7 @@
>>   #include "capabilities.h"
>>   #include "x86_ops.h"
>>   #include "x86.h"
>> +#include "tdx_arch.h"
>>   #include "tdx.h"
>>     #undef pr_fmt
>> @@ -39,6 +40,50 @@ static void __used tdx_guest_keyid_free(int keyid)
>>       ida_free(&tdx_guest_keyid_pool, keyid);
>>   }
>>   +#define TDX_MD_MAP(_fid, _ptr)            \
>> +    { .fid = MD_FIELD_ID_##_fid,        \
>> +      .ptr = (_ptr), }
>> +
>> +struct tdx_md_map {
>> +    u64 fid;
>> +    void *ptr;
>> +};
>> +
>> +static size_t tdx_md_element_size(u64 fid)
>> +{
>> +    switch (TDX_MD_ELEMENT_SIZE_CODE(fid)) {
>> +    case TDX_MD_ELEMENT_SIZE_8BITS:
>> +        return 1;
>> +    case TDX_MD_ELEMENT_SIZE_16BITS:
>> +        return 2;
>> +    case TDX_MD_ELEMENT_SIZE_32BITS:
>> +        return 4;
>> +    case TDX_MD_ELEMENT_SIZE_64BITS:
>> +        return 8;
>> +    default:
>> +        WARN_ON_ONCE(1);
>> +        return 0;
>> +    }
>> +}
>> +
>> +static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>> +{
>> +    struct tdx_md_map *m;
>> +    int ret, i;
>> +    u64 tmp;
>> +
>> +    for (i = 0; i < nr_maps; i++) {
>> +        m = &maps[i];
>> +        ret = tdx_sys_metadata_field_read(m->fid, &tmp);
>> +        if (ret)
>> +            return ret;
>> +
>> +        memcpy(m->ptr, &tmp, tdx_md_element_size(m->fid));
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static int __init tdx_module_setup(void)
>>   {
>>       int ret;
>


