Return-Path: <kvm+bounces-52466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4A0B05640
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDF003AEDB3
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977472D63E4;
	Tue, 15 Jul 2025 09:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nHhQTHTz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661B42D4B6C;
	Tue, 15 Jul 2025 09:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752571464; cv=none; b=msGG1ENq2pXG+zJ0sOHb5Js+KQG9Qet4In3zLc7rzXfWi9HGPwV08bKAioqlRg8K+IDWNYIfZMavYWW/ijjbU5OQGHCPnGieleTWZZOIS8wtGgePHFEQuBEszitdtbILeatkJZj8+EVnVBsJn/uiknF/muZdgCzv/FXZWvocu08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752571464; c=relaxed/simple;
	bh=ug9T64uB92te6hmysDI/TqsvZlQinqTdtWIr5KV0EU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JBvLcdaKdpb9zxhPEGdEnYFAnHLrjb1f+HibMPKIenxIRIWVXQsf0u2BoVG8hZQ7BSDPYsnvV/cGaCA2L7O3lUxv/n71SAokv7XbLSZJb8K9WccWsLRU26WfYmm3pmJxZLtIyZVT2HpyAKsYazauVg7FIjshYQZHolmxboYOie8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nHhQTHTz; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752571464; x=1784107464;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ug9T64uB92te6hmysDI/TqsvZlQinqTdtWIr5KV0EU0=;
  b=nHhQTHTzb7gZWDGtXRHs30MSK7vW2/RCRPIV/bStZeT8rVAOYDINwzd2
   +AjmNVAh4i1zvdl6dSIa5uCUPh34zq4d/+V/+4/D7aWrhAz+sbRqaiGPp
   3ecPnRqKFCgjNm6E61dwIeWanZdeWfl07AvSz66GttIkZRSXn+BD0fHG9
   2h1JDnUllIYRvxCnOZSAY0uby/52HTomPuom5UxiRBR+vjk+uZwmiLaG4
   Oil+FUQCKbWomJ/DK2KjuA4Dv3UUgBcNgZ2u9faZWlbCnDrGAAIT7SI9w
   TA+mwyV+B65mlgjd3iONXPUZTAvulmKQzeY27O1AJsGNSeas4frJvALJ4
   Q==;
X-CSE-ConnectionGUID: 2fpKB3TfTXyvbrZj22d0pw==
X-CSE-MsgGUID: yFXoOaZcSo26tEOy3HQscA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54636642"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54636642"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 02:24:23 -0700
X-CSE-ConnectionGUID: TnCyZxG2SaaCSPmNWhCoew==
X-CSE-MsgGUID: P/GLCB5VRduEG7xSu8ak8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="161487060"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 02:24:17 -0700
Message-ID: <3ac8cf43-49ae-4371-8a63-d30c2361f51b@intel.com>
Date: Tue, 15 Jul 2025 17:24:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc: "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "Huang, Kai"
 <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250711132620.262334-1-xiaoyao.li@intel.com>
 <20250711132620.262334-2-xiaoyao.li@intel.com>
 <94f7657e9ba7d3dee2d7188e494bf37f2eaddee1.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <94f7657e9ba7d3dee2d7188e494bf37f2eaddee1.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/2025 1:51 AM, Edgecombe, Rick P wrote:
> On Fri, 2025-07-11 at 21:26 +0800, Xiaoyao Li wrote:
>> Fix the typo from TDX_ATTR_MIGRTABLE to TDX_ATTR_MIGRATABLE.
>>
>> Since the names are stringified and printed out to dmesg in
>> tdx_dump_attributes(), this correction will also fix the dmesg output.
>>
>>
> 
>> But not any kind of machine readable proc or anything like that.
> 
> Thanks for adding the impact. This is such a small patch that I hate to generate
> a v3, but this is too imprecise for a tip commit log.
> 
> Here is how I would write it, what do you think?

It's way better than mine!

I use it in v3 with few fix (by gpt).

thanks!

> 
> x86/tdx: Fix the typo in TDX_ATTR_MIGRTABLE
> 
> The TD scoped TDCS attributes are defined by a bit position. In the guest side
> of the TDX code, the 'tdx_attributes' string array holds pretty print names for
> these attributes, which are generated via macros and defines. Today these pretty
> print names are only used to print the attribute names to dmesg.
> 
> Unfortunately there is a typo in define for the migratable bit define. Change
> the defines TDX_ATTR_MIGRTABLE* to TDX_ATTR_MIGRATABLE*. Update the sole user,
> the tdx_attributes array, to use the fixed name.
> 
> Since these defines control the string printed to dmesg, the change is user
> visible. But the risk of breakage is almost zero since is not exposed in any
> interface expected to be consumed programatically.
> 
> Fixes: 564ea84c8c14 ("x86/tdx: Dump attributes and TD_CTLS on boot")
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>


