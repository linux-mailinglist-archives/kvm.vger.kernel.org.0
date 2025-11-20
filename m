Return-Path: <kvm+bounces-63871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1418BC74FA0
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id CBF4C2B0F4
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B3B35FF53;
	Thu, 20 Nov 2025 15:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nd8bwrOy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF9635F8B0;
	Thu, 20 Nov 2025 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652222; cv=none; b=Mcyak6Vn+5TrTyy2sr2FdKzy0Lve7A/guN8/kXJMKhdviQ2Oh9HuifNYZODTzpbSl6K0JZy8EnZbyvehsT/CLkOOyxzZJJGik4opWckkrZz9pCekphi5ACMEYgvdOy96MoEFu1GuU14mwZPv1OfBSNgUWApO44YfTxtT7/uRzGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652222; c=relaxed/simple;
	bh=bj15Y9VvxernGXOXAHezLeGkYBBoJT0P5MFHGRZHdKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z579jMy9mcOQGcQLrxitNpnKVLpKbx5A80ghZqQI4EJESljkvF3jW0aTj7HXjvDPVo4laRpQ6CD7cRgxjZiNls2ZtKDdGCbp1XuHb9B62wLdREXoUKaGsCsVHUJmD3MLJEzok28tC65HvodsaYUx9YXz4JqnO9lSX85n7/2pHgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nd8bwrOy; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763652221; x=1795188221;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bj15Y9VvxernGXOXAHezLeGkYBBoJT0P5MFHGRZHdKY=;
  b=Nd8bwrOydN4FwZmhwIy3ibXxDazhYoKh41ekJmJy+tk1em/G8KyknPrq
   Fq2EtNLDyLqZl2PdURXNtG/YcbXWrcuFgaa8ZohAnwkgBOo7wJjTyeCT6
   +3WPvJocmAOY8dex9bEGZLKzeZzfBWGQEDfFCZ+mNE4baAvDfb7OSD2t6
   kOEhw+X4GXmKUR32fj6rg6HhhuDwSUWHlR7A/wJ8svagOr8Oj4Z6/0Ssm
   mJgMOx2ek/LPFmepg6UcZQ3Tuog8HxR1ikDR1BMAvVZ9Il4E1X5llvluL
   pCSqPIfk82wjU8yCYW2+m5btnoHVfZmYJynGykp5pb0avkhgGRCRxu8dw
   w==;
X-CSE-ConnectionGUID: rG0bbul6TK6NskT4S+axbg==
X-CSE-MsgGUID: +oYp8VDSTAaO8GjdgkI8pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="65763636"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="65763636"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 07:23:41 -0800
X-CSE-ConnectionGUID: poaTVW1nRHCa58cdzfOw5w==
X-CSE-MsgGUID: 73x9Rz1PT1qkJmj6xyLN/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="214749631"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.109.230]) ([10.125.109.230])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 07:23:40 -0800
Message-ID: <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>
Date: Thu, 20 Nov 2025 07:23:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
 chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
 yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
 <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
 <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>
 <aR6ws2yzwQumApb9@yilunxu-OptiPlex-7050>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aR6ws2yzwQumApb9@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/25 22:09, Xu Yilun wrote:
> On Tue, Nov 18, 2025 at 10:32:13AM -0800, Dave Hansen wrote:
...
>> Please *say* that. Explain how existing TDX metadata consumes memory and
>> how this new mechanism is different.
> 
> Yes.
> 
> Existing ways to provide an array of metadata pages to TDX Module
> varies:
> 
>  1. Assign each HPA for each SEAMCALL register.
>  2. Call the same seamcall multiple times.
>  3. Assign the PA of HPA-array in one register and the page number in
>     another register.
> 
> TDX Module defines new interfaces trying to unify the page array
> provision. It is similar to the 3rd method. The new objects HPA_ARRAY_T
> and HPA_LIST_INFO need a 'root page' which contains a list of HPAs.
> They collapse the HPA of the root page and the number of valid HPAs
> into a 64 bit raw value for one SEAMCALL parameter.
> 
> I think these words should be in:
> 
>   x86/virt/tdx: Add tdx_page_array helpers for new TDX Module objects

That's not quite what I was hoping for.

I want an overview of how this new memory fits into the overall scheme.
I'd argue that these "control pages" are most similar to the PAMT:
There's some back-and-forth with the module about how much memory it
needs, the kernel allocates it, hands it over, and never gets it back.

That's the level that this needs to be presented at: a high-level
logical overview.

...> I think it may be too heavy. We have a hundred SEAMCALLs and I expect
> few needs version 1. I actually think v2 is nothing different from a new
> leaf. How about something like:
> 
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -46,6 +46,7 @@
>  #define TDH_PHYMEM_PAGE_WBINVD         41
>  #define TDH_VP_WR                      43
>  #define TDH_SYS_CONFIG                 45
> +#define TDH_SYS_CONFIG_V1              (TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT))
> 
> And if a SEAMCALL needs export, add new tdh_foobar() helper. Anyway
> the parameter list should be different.

I'd need quite a bit of convincing that this is the right way.

What is the scenario where there's a:

	TDH_SYS_CONFIG_V1
and
	TDH_SYS_CONFIG_V2

in the tree at the same time?

Second, does it hurt to pass the version along with other calls, like
... (naming a random one) ... TDH_PHYMEM_PAGE_WBINVD ?

Even if we did this, we wouldn't copy and paste "(1ULL <<
TDX_VERSION_SHIFT)" all over the place, right? We'd create a more
concise, cleaner macro and then use it everywhere. Right?
	
>>>> rather non-obvious. It's doing:
>>>>
>>>> 	while (1) {
>>>> 		fill(&array);
>>>> 		tell_tdx_module(&array);
>>>> 	}
>>>
>>> There is some explanation in Patch #6:
>>
>> That doesn't really help me, or future reviewers.
>>
>>>  4. Note the root page contains 512 HPAs at most, if more pages are
>>>    required, refilling the tdx_page_array is needed.
>>>
>>>  - struct tdx_page_array *array = tdx_page_array_alloc(nr_pages);
>>>  - for each 512-page bulk
>>>    - tdx_page_array_fill_root(array, offset);
>>>    - seamcall(TDH_XXX_ADD, array, ...);
>>
>> Great! That is useful information to have here, in the code.

I asked in my last message, but perhaps it was missed: Could you please
start clearing irrelevant context in your replies. Like that hunk ^

>>>> Why can't it be:
>>>>
>>>> 	while (1)
>>>> 		fill(&array);
>>>> 	while (1)
>>>> 		tell_tdx_module(&array);
>>>
>>> The consideration is, no need to create as much supporting
>>> structures (struct tdx_page_array *, struct page ** and root page) for
>>> each 512-page bulk. Use one and re-populate it in loop is efficient.
>>
>> Huh? What is it efficient for? Are you saving a few pages of _temporary_
>> memory?
> 
> In this case yes, cause no way to reclaim TDX Module EXT required pages.
> But when reclaimation is needed, will hold these supporting structures
> long time.
> 
> Also I want the tdx_page_array object itself not been restricted by 512
> pages, so tdx_page_array users don't have to manage an array of array.

I suspect we're not really talking about the same thing here.

In any case, I'm not a super big fan of how tdx_ext_mempool_setup() is
written. Can you please take another pass at it and try to simplify it
and make it easier to follow?

This would be a great opportunity to bring in some of your colleagues to
take a look. You can solicit them for suggestions.

>>>>> +static int init_tdx_ext(void)
>>>>> +{
>>>>> +	int ret;
>>>>> +
>>>>> +	if (!(tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_EXT))
>>>>> +		return -EOPNOTSUPP;
>>>>> +
>>>>> +	struct tdx_page_array *mempool __free(tdx_ext_mempool_free) =
>>>>> +		tdx_ext_mempool_setup();
>>>>> +	/* Return NULL is OK, means no need to setup mempool */
>>>>> +	if (IS_ERR(mempool))
>>>>> +		return PTR_ERR(mempool);
>>>>
>>>> That's a somewhat odd comment to put above an if() that doesn't return NULL.
>>>
>>> I meant to explain why using IS_ERR instead of IS_ERR_OR_NULL. I can
>>> impove the comment.
>>
>> I'd kinda rather the code was improved. Why cram everything into a
>> pointer if you don't need to. This would be just fine, no?
>>
>> 	ret = tdx_ext_mempool_setup(&mempool);
>> 	if (ret)
>> 		return ret;
> 
> It's good.
> 
> The usage of pointer is still about __free(). In order to auto-free
> something, we need an object handler for something. I think this is a
> more controversial usage of __free() than pure allocation. We setup
> something and want auto-undo something on failure.
I'm not sure what you are trying to say here. By saying "It's good" are
you agreeing that my suggested structure is good and that you will use
it? Or are you saying that the original structure is good?

Second, what is an "object handler"? Are you talking about the function
that is pointed to by __free()?

Third, are you saying that the original code structure is somehow
connected to __free()? I thought that all of these were logically
equivalent:

	void *foo __free(foofree) = alloc_foo();

	void *foo __free(foofree) = NULL:
	foo = alloc_foo();

	void *foo __free(foofree) = NULL;
	populate_foo(&foo);

Is there something special about doing the variable assignment at the
variable declaration spot?

