Return-Path: <kvm+bounces-12929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 930C888F4C7
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE54C282BDA
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54DDA2943C;
	Thu, 28 Mar 2024 01:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g7zdxgAN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05505286AD;
	Thu, 28 Mar 2024 01:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711589789; cv=none; b=IuaMjEHrMnCDgN8fzZdONzEICVArbh+uZ0crlOAV3isqUuAYElHh6VwDPmmWYEoki7tHcC5wIvmPHOeabZsm9c/Rq3AR+RmYpzxnMr7hvVAkKJhfOVOha+b3SzBu1Wndg/R9TsnM7v3ifWewd1Z7FEuaHIhu1OpDNYVqZRihv14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711589789; c=relaxed/simple;
	bh=lhvQ3bL3zEzra6sPz4mYh3SCJYXmuoBa5F3CVmZ09oY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fM+guDBdeXQyODTAm2u29ZhHiyNt3E/msywpkrX0IQvMpIJDgxTRRGLXp/RpG9P07EG8gwonSuQbmyfwktlfptM4NONCJiht3dd8gl2q1EAiEZIpvh1jinUjfx+OqQMoimesXmI4vYJNWH6yw3QHcX6gc3quj59a3n9rNeOYmDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g7zdxgAN; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711589788; x=1743125788;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lhvQ3bL3zEzra6sPz4mYh3SCJYXmuoBa5F3CVmZ09oY=;
  b=g7zdxgANnSweXA7Yt+5AvoDFy7DzpYSVF8yf0v+co1fuxTPnrS331CFA
   sn3AQT8KYGzsO8pZCGB5GWHE1Fj8PTlpO7DarFqSSvAH3UhYylGOmmHtm
   6CkH4XliCgcXK5y4ajkI1tfgIXSaC5GGj8NvobDnWW9XGiVoIwU1m70Pb
   1aBNtjLMLMDGG+KvvcqnwVezsXKez33of64R9tu/ihM2wXUudylKKEe6I
   5iQ0S8OnaR3yDtQeaqj7+kNWbZsLeUksG5r4gb2qJLJw2hbKge5OMrLMC
   UShIVCA3wL9Qau0xkoN0b0QDgWPD4LEqfWkFz9sFCT/Csg/3GdDH/g7B9
   g==;
X-CSE-ConnectionGUID: LFX268AtRvewW9KbKX3XbA==
X-CSE-MsgGUID: bhA4xmoFTRSYbywfoxBkMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="7325620"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="7325620"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:36:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="20999108"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:36:24 -0700
Message-ID: <b065cf99-74bc-42d1-95a3-8a0b018218ee@intel.com>
Date: Thu, 28 Mar 2024 09:36:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
 <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "sagis@google.com" <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yuan, Hang"
 <hang.yuan@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <Zfp+YWzHV0DxVf1+@chao-email>
 <20240321155513.GL1994522@ls.amr.corp.intel.com>
 <5470570d804b52dcf24b454d5fdfc2320f735e80.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <5470570d804b52dcf24b454d5fdfc2320f735e80.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/28/2024 9:12 AM, Edgecombe, Rick P wrote:
> On Thu, 2024-03-21 at 08:55 -0700, Isaku Yamahata wrote:
>> On Wed, Mar 20, 2024 at 02:12:49PM +0800,
>> Chao Gao <chao.gao@intel.com> wrote:
>>
>>>> +static void setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
>>>> +                                 struct td_params *td_params)
>>>> +{
>>>> +       int i;
>>>> +
>>>> +       /*
>>>> +        * td_params.cpuid_values: The number and the order of cpuid_value must
>>>> +        * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
>>>> +        * It's assumed that td_params was zeroed.
>>>> +        */
>>>> +       for (i = 0; i < tdx_info->num_cpuid_config; i++) {
>>>> +               const struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
>>>> +               /* KVM_TDX_CPUID_NO_SUBLEAF means index = 0. */
>>>> +               u32 index = c->sub_leaf == KVM_TDX_CPUID_NO_SUBLEAF ? 0 : c->sub_leaf;
>>>> +               const struct kvm_cpuid_entry2 *entry =
>>>> +                       kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
>>>> +                                             c->leaf, index);
>>>> +               struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
>>>> +
>>>> +               if (!entry)
>>>> +                       continue;
>>>> +
>>>> +               /*
>>>> +                * tdsysinfo.cpuid_configs[].{eax, ebx, ecx, edx}
>>>> +                * bit 1 means it can be configured to zero or one.
>>>> +                * bit 0 means it must be zero.
>>>> +                * Mask out non-configurable bits.
>>>> +                */
>>>> +               value->eax = entry->eax & c->eax;
>>>> +               value->ebx = entry->ebx & c->ebx;
>>>> +               value->ecx = entry->ecx & c->ecx;
>>>> +               value->edx = entry->edx & c->edx;
>>>
>>> Any reason to mask off non-configurable bits rather than return an error? this
>>> is misleading to userspace because guest sees the values emulated by TDX module
>>> instead of the values passed from userspace (i.e., the request from userspace
>>> isn't done but there is no indication of that to userspace).
>>
>> Ok, I'll eliminate them.  If user space passes wrong cpuids, TDX module will
>> return error. I'll leave the error check to the TDX module.
> 
> I was just looking at this. Agreed. It breaks the selftests though.

If all you prefer to go this direction, then please update the error 
handling of this specific SEAMCALL.

