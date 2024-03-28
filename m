Return-Path: <kvm+bounces-12953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B50788F603
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05918295625
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B18B376E1;
	Thu, 28 Mar 2024 03:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/fQxXWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7591DA5B;
	Thu, 28 Mar 2024 03:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711597237; cv=none; b=QyaIZN1jepJkbE7QZ/2d6+8NixAEXEOMdY1UIKrlCe/O1XtFABH08EYNXSGGwfMoCp3H/03z610vcZ1JqEYvFP+U9yLgcvc78YOYZnDM4bCyPxLeacM7FnI8pvdjHhTSnUqDkKpc17GuO5BeGly/EAltDiMjN6bnOpgwH0llYbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711597237; c=relaxed/simple;
	bh=Ym+ihHFVt13GNw2mWqOvJzw+VVmFqNGAwtRWX7YdW7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0XFNz55LnvQW3gsd61T8ehYevfq+5A55IxXoRi+O31U+sbyZqICE8eGg6ekeE6AetjcEfxJid7/BlBuE8LXbZnd2XeucPebZ8ypdP8wF3LdyUqNIRZsrpzjMz19fRMeREEZNtoFWrAZ36d8cDS28bOZe7rVbLKFJkn7/gjHzbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/fQxXWZ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711597235; x=1743133235;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ym+ihHFVt13GNw2mWqOvJzw+VVmFqNGAwtRWX7YdW7U=;
  b=R/fQxXWZHiSq1AT6FqujqhKYnKCXpLAzevhFoR5GaOdf7Vi+EyDQ6g1f
   OL/+oFi4rU0gxfx01JeMgEpcEZdaMeKAcy04olPXPYYc/XXgNex4O8Gtz
   6hZWEswlnIQA8A9xAGoUHvdJu66j9XHa/XRrGhKhv86DOBNZYpuHbxHMV
   IiuE3NcTvu702sJ59YsSdwYlFUHhhuGC5emEaHwe9NDYJoumHKFQVE0PS
   i4fLrjLMaSNZXAy06IxBKKxwP4vrlU74wk6VoLx4Gt/tF959aaBoUqdMX
   W6OjoiETIPwB1Tcp7i2MBHFWXuVdXQe2SYwg4XT/b0iHJdHbyeeHULUaA
   Q==;
X-CSE-ConnectionGUID: lJbeGd3yQuiH8qwSP4jG/g==
X-CSE-MsgGUID: r0M5cMuCSrWCDw17VfQnTg==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="32131414"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="32131414"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:40:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21191081"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:40:30 -0700
Message-ID: <f499ee87-0ce3-403e-bad6-24f82933903a@intel.com>
Date: Thu, 28 Mar 2024 11:40:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
 <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yuan, Hang"
 <hang.yuan@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
 <20240325221836.GO2357401@ls.amr.corp.intel.com>
 <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
 <ZgKt6ljcmnfSbqG/@chao-email>
 <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
 <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
 <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
 <20ef977a-75e5-4bbc-9acf-fa1250132138@intel.com>
 <783d85acd13fedafc6032a82f202eb74dc2bd214.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <783d85acd13fedafc6032a82f202eb74dc2bd214.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/2024 11:04 AM, Edgecombe, Rick P wrote:
> On Thu, 2024-03-28 at 09:30 +0800, Xiaoyao Li wrote:
>>> The current ABI of KVM_EXIT_X86_RDMSR when TDs are created is nothing. So I don't see how this
>>> is
>>> any kind of ABI break. If you agree we shouldn't try to support MTRRs, do you have a different
>>> exit
>>> reason or behavior in mind?
>>
>> Just return error on TDVMCALL of RDMSR/WRMSR on TD's access of MTRR MSRs.
> 
> MTRR appears to be configured to be type "Fixed" in the TDX module. So the guest could expect to be
> able to use it and be surprised by a #GP.
> 
>          {
>            "MSB": "12",
>            "LSB": "12",
>            "Field Size": "1",
>            "Field Name": "MTRR",
>            "Configuration Details": null,
>            "Bit or Field Virtualization Type": "Fixed",
>            "Virtualization Details": "0x1"
>          },
> 
> If KVM does not support MTRRs in TDX, then it has to return the error somewhere or pretend to
> support it (do nothing but not return an error). Returning an error to the guest would be making up
> arch behavior, and to a lesser degree so would ignoring the WRMSR. 

The root cause is that it's a bad design of TDX to make MTRR fixed1. 
When guest reads MTRR CPUID as 1 while getting #VE on MTRR MSRs, it 
already breaks the architectural behavior. (MAC faces the similar issue 
, MCA is fixed1 as well while accessing MCA related MSRs gets #VE. This 
is why TDX is going to fix them by introducing new feature and make them 
configurable)

> So that is why I lean towards
> returning to userspace and giving the VMM the option to ignore it, return an error to the guest or
> show an error to the user. 

"show an error to the user" doesn't help at all. Because user cannot fix 
it, nor does QEMU.

> If KVM can't support the behavior, better to get an actual error in
> userspace than a mysterious guest hang, right?
What behavior do you mean?

> Outside of what kind of exit it is, do you object to the general plan to punt to userspace?
> 
> Since this is a TDX specific limitation, I guess there is KVM_EXIT_TDX_VMCALL as a general category
> of TDVMCALLs that cannot be handled by KVM.

I just don't see any difference between handling it in KVM and handling 
it in userspace: either a) return error to guest or b) ignore the WRMSR.

