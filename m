Return-Path: <kvm+bounces-13018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34966890231
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64DA41C2DD70
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 14:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E7512DDA7;
	Thu, 28 Mar 2024 14:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="njKnrrfG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D72128369;
	Thu, 28 Mar 2024 14:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711637168; cv=none; b=ilIw9mDVhGFCH4CNrHHcYR01XdkJ1TxxjH1XvZPESldon6+jhvq8tmUrRe0kZsWmD4PqeueygMQ+dtw4Fz6R8OWRw5aTWFsdiV6SD4liDBJmCGxeyBQn5IFbgBBBXZ6V11q6NdCHeq/jwkgxHRNvYihi+Rsy14s8gtx7p1ypzUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711637168; c=relaxed/simple;
	bh=e7T2k8jeQC9M808lpQTjDzIA9RTU/rhvmNyQ/wDrKOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GaDwfFhJcYytv5/+fGADFgJoMvSL8mOexsDVe/cS7ZSXApo8n8nXlzhYDGpwQl+ExmgaE0PBq8EjahpV126g/WB+cCYETn7n8Zlo/SbPvEPK848qAeQEEBID80dhnMkatNLid8LKLBiApYGplYP4SSZwFm9dj712yJypnfJLbYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=njKnrrfG; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711637166; x=1743173166;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=e7T2k8jeQC9M808lpQTjDzIA9RTU/rhvmNyQ/wDrKOo=;
  b=njKnrrfGF2aunM+EjMIZnEaMq+qHNYTKHNn3Ok3Xplml28n2TyBhlaAB
   SNe+6quzzvNDP4lhT3zfZs1ugYdkLXFjWG2AidAc5qPrGd38lmSrVWoCa
   VjxIv2tsdhx+rvvMTxLeX9eR/vs+6CHnxjktVDioEd75IxosBATCWL7xp
   vitEdVHT74oaZZFP+Ei1PQCJtU6hYwKuLUBsf3JaCqQWT8VaZoimuIGq3
   ZP90nr6cpXTcpfkqVjplsse+fCWmmOM1QD1DV7FqnStzmCJcASsMSUEmq
   VA7X1TeQ9L0cKPbnUtU6XP7x10gac6/DNPefFmpsdKJVwT2Smo5lC1o9W
   w==;
X-CSE-ConnectionGUID: vpsdT2oMTTiAdk+7oZM7IA==
X-CSE-MsgGUID: Civ7iNmFQ/ipuDa2YU9+wA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6681770"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6681770"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 07:46:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="47857228"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 07:46:01 -0700
Message-ID: <79adf996-48d6-41b0-8327-f3258d74bb7b@intel.com>
Date: Thu, 28 Mar 2024 22:45:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To: Chao Gao <chao.gao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yuan, Hang"
 <hang.yuan@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
 <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
 <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
 <20ef977a-75e5-4bbc-9acf-fa1250132138@intel.com>
 <783d85acd13fedafc6032a82f202eb74dc2bd214.camel@intel.com>
 <f499ee87-0ce3-403e-bad6-24f82933903a@intel.com>
 <ZgVDvCePGwKWv0wd@chao-email>
 <234c9998-c314-44bb-ad96-6af2cece7465@intel.com>
 <ZgVywaHkKVNNfuQ8@chao-email>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZgVywaHkKVNNfuQ8@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/2024 9:38 PM, Chao Gao wrote:
> On Thu, Mar 28, 2024 at 09:21:37PM +0800, Xiaoyao Li wrote:
>> On 3/28/2024 6:17 PM, Chao Gao wrote:
>>> On Thu, Mar 28, 2024 at 11:40:27AM +0800, Xiaoyao Li wrote:
>>>> On 3/28/2024 11:04 AM, Edgecombe, Rick P wrote:
>>>>> On Thu, 2024-03-28 at 09:30 +0800, Xiaoyao Li wrote:
>>>>>>> The current ABI of KVM_EXIT_X86_RDMSR when TDs are created is nothing. So I don't see how this
>>>>>>> is
>>>>>>> any kind of ABI break. If you agree we shouldn't try to support MTRRs, do you have a different
>>>>>>> exit
>>>>>>> reason or behavior in mind?
>>>>>>
>>>>>> Just return error on TDVMCALL of RDMSR/WRMSR on TD's access of MTRR MSRs.
>>>>>
>>>>> MTRR appears to be configured to be type "Fixed" in the TDX module. So the guest could expect to be
>>>>> able to use it and be surprised by a #GP.
>>>>>
>>>>>            {
>>>>>              "MSB": "12",
>>>>>              "LSB": "12",
>>>>>              "Field Size": "1",
>>>>>              "Field Name": "MTRR",
>>>>>              "Configuration Details": null,
>>>>>              "Bit or Field Virtualization Type": "Fixed",
>>>>>              "Virtualization Details": "0x1"
>>>>>            },
>>>>>
>>>>> If KVM does not support MTRRs in TDX, then it has to return the error somewhere or pretend to
>>>>> support it (do nothing but not return an error). Returning an error to the guest would be making up
>>>>> arch behavior, and to a lesser degree so would ignoring the WRMSR.
>>>>
>>>> The root cause is that it's a bad design of TDX to make MTRR fixed1. When
>>>> guest reads MTRR CPUID as 1 while getting #VE on MTRR MSRs, it already breaks
>>>> the architectural behavior. (MAC faces the similar issue , MCA is fixed1 as
>>>
>>> I won't say #VE on MTRR MSRs breaks anything. Writes to other MSRs (e.g.
>>> TSC_DEADLINE MSR) also lead to #VE. If KVM can emulate the MSR accesses, #VE
>>> should be fine.
>>>
>>> The problem is: MTRR CPUID feature is fixed 1 while KVM/QEMU doesn't know how
>>> to virtualize MTRR especially given that KVM cannot control the memory type in
>>> secure-EPT entries.
>>
>> yes, I partly agree on that "#VE on MTRR MSRs breaks anything". #VE is not a
>> problem, the problem is if the #VE is opt-in or unconditional.
> 
>  From guest's p.o.v, there is no difference: the guest doesn't know whether a feature
> is opted in or not.

I don't argue it makes any difference to guest. I argue that it is a bad 
design of TDX to make MTRR fixed1, which leaves the tough problem to 
VMM. TDX architecture is one should be blamed.

Though TDX is going to change it, we have to come up something to handle 
with current existing TDX if we want to support them.

I have no objection of leaving it to userspace, via KVM_EXIT_TDX_VMCALL. 
If we go this path, I would suggest return error to TD guest on QEMU 
side (when I prepare the QEMU patch for it) because QEMU cannot emulate 
it neither.


