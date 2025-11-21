Return-Path: <kvm+bounces-64157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B37C9C7A86A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 16:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 29A724ED451
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A1F27B35F;
	Fri, 21 Nov 2025 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RVLB8nPd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AD0355815;
	Fri, 21 Nov 2025 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763738116; cv=none; b=Pob15daIE+E+6kebs3IcWewW+uJSqYa/T7DUU4Af3gCivFkTrMpmLkoLet/vqPxBdA2jktGNgbfPM3QiuWGy2JLXRTQeiaM3ny7ZdF9TESV7OKYg9w72BHO2IIrBnPeJUpm5OVlBm6EN3ulUNTHFyODwpMrINKfixXJHSxJUCZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763738116; c=relaxed/simple;
	bh=tGkLoaIerxSzCgo8kr0dzfb3bmHGcG6BnOlM4l+YMg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YYgzcdcrRQEqW1gRY/+8cNrcH+Jw+aTgKyhyQtYny9UehqjJB0NEqlzlI6AqobBWtplt6Y9dQHjj5kj5SyEYypKBdGsuhAExHQnR91wbP2IYdjCSSMbN+1f0QsYO6T+67867D6Ekq5WQHNkSEfc//dgtMJCgC9yesw71TuPAgOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RVLB8nPd; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763738115; x=1795274115;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tGkLoaIerxSzCgo8kr0dzfb3bmHGcG6BnOlM4l+YMg4=;
  b=RVLB8nPd70IetbwiaInnhZWFvIykdtPeOD7keAFYtHqvdMDRjGp/HUzS
   oAKA9Xal0mVs7jFYAPMM6MJnEnTNcHJgWyBZU/5P1BPcNLgRkLcqwQY4c
   HS8sj/fiaPkw3JQPCG2vwfe6km9mMT0GTtRXw1bnX35VpPgy5YTpNUeZe
   G7Pdi2G5xMwrQTBcevP7nk3noRvYAbjmra8rBVStfEU3nRkzNCgnPnQkG
   UbGvEc/I3gnoy4Pn5zSuYgjIH+B5WRSG/b9EKOzzZ9zE2da65KWyz7Iks
   arS8AZZPMMOuZIT+DBWO507xK5U8oJYaqVHi/j4ScCQDviBKCNCb3CmhO
   A==;
X-CSE-ConnectionGUID: 4oOgPnyNRJqiDPrnGzS5aw==
X-CSE-MsgGUID: M6vZhUK3RaiGj5ridH4ufg==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="69690052"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="69690052"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 07:15:15 -0800
X-CSE-ConnectionGUID: fpyK4875SNCv4NIwY/lWmQ==
X-CSE-MsgGUID: amSWJXh2SBCjtU4H+qZSog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="191499047"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.110.33]) ([10.125.110.33])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 07:15:15 -0800
Message-ID: <ca331aa3-6304-4e07-9ed9-94dc69726382@intel.com>
Date: Fri, 21 Nov 2025 07:15:13 -0800
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
 <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>
 <aSBg+5rS1Y498gHx@yilunxu-OptiPlex-7050>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aSBg+5rS1Y498gHx@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/25 04:54, Xu Yilun wrote:
...
> For now, TDX Module Extensions consume quite large amount of memory
> (12800 pages), print this readout value on TDX Module Extentions
> initialization.

Overall, the description is looking better, thanks!

A few more nits, though. Please don't talk about things in terms of
number of pages. Just give the usage in megabytes.


>>> --- a/arch/x86/virt/vmx/tdx/tdx.h
>>> +++ b/arch/x86/virt/vmx/tdx/tdx.h
>>> @@ -46,6 +46,7 @@
>>>  #define TDH_PHYMEM_PAGE_WBINVD         41
>>>  #define TDH_VP_WR                      43
>>>  #define TDH_SYS_CONFIG                 45
>>> +#define TDH_SYS_CONFIG_V1              (TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT))
>>>
>>> And if a SEAMCALL needs export, add new tdh_foobar() helper. Anyway
>>> the parameter list should be different.
>>
>> I'd need quite a bit of convincing that this is the right way.
>>
>> What is the scenario where there's a:
>>
>> 	TDH_SYS_CONFIG_V1
>> and
>> 	TDH_SYS_CONFIG_V2
>>
>> in the tree at the same time?
> 
> I assume you mean TDH_SYS_CONFIG & TDH_SYS_CONFIG_V1.

Sure. But I wasn't being that literal about it. My point was whether we
need two macros for two simultaneous uses of the same seamcall.

> If you want to enable optional features via this seamcall, you must use
> v1, otherwise v0 & v1 are all good. Mm... I suddenly don't see usecase
> they must co-exist. Unconditionally use v1 is fine. So does TDH_VP_INIT.
> 
> Does that mean we don't have to keep versions, always use the latest is
> good? (Proper Macro to be used...)
> 
>  -#define TDH_SYS_CONFIG                 45
>  +#define TDH_SYS_CONFIG                 (45 | (1ULL << TDX_VERSION_SHIFT))

That's my theory: we don't need to keep versions.

>> Second, does it hurt to pass the version along with other calls, like
>> ... (naming a random one) ... TDH_PHYMEM_PAGE_WBINVD ?
> 
> I see no runtime hurt, just an extra zero parameter passed around.
> 
> And version change always goes with more parameters, if we add version
> parameter, it looks like:
> 
>  u64 tdh_phymem_page_wbinvd_tdr(int version, struct tdx_td *td, int new_param1, int new_param2);
> 
> For readability, I prefer the following, they provide clear definitions:
> 
>  u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
>  u64 tdh_phymem_page_wbinvd_tdr_1(struct tdx_td *td, int new_param1, int new_param2);
> 
> But I hope eventually we don't have to keep versions, then we don't have to choose:
> 
>  u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td, int new_param1, int new_param2);

Sure, but that's not happening today. So for TDX_FEATURES0_TDXCONNECT at
least, config_tdx_module() doesn't change.

> The TDX Module can only accept one root page (i.e. 512 HPAs at most), while
> struct tdx_page_array contains the whole EXT memory (12800 pages). So we
> can't populate all pages into one root page then tell TDX Module. We need to
> populate one batch, tell tdx module, then populate the next batch, tell
> tdx module...

That is, indeed, the information that I was looking for. Can you please
ensure that makes it into code comments?

