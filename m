Return-Path: <kvm+bounces-6181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD91A82D381
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 04:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DA5E1F2146A
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 03:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5451FDD;
	Mon, 15 Jan 2024 03:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HL91+I/I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB6F1C3D
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 03:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705290673; x=1736826673;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hqkWkscx7XpxVuFcGpTfTCVLvZmhCxQ8KR63EtrKzD0=;
  b=HL91+I/ILBxsThqCyMoBbYeOy/ocD3qOxPp1VQAPtpAcxKD0zI4a43yI
   0SYxoXvuqUM34MDgEeHmHSyoj/AiGMJX3xAw9OyWxJ8xd2+vbblVQg77E
   akx6UOiabXGLsysy+h2Vrp2sDqgMf+3Cm2duWRBtrwhIDiW3X15CWy8Hg
   QgGeWL+QI0PDiD+j4TijIosHgptSuKf55lmBaENz4Bd7JElCsZWsX/I48
   bWITcHJmfIncFl4uJ27KfgKRiRnheTXfpns6biAe0BUcHS1O5NTEhfYLf
   gBtOZ8jy6OmXkpsr0YuZk0t66fmOm9oNA+VQ+8iVxDcucaI7gbAgwR/iJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="6622712"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="6622712"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 19:51:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="786964036"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="786964036"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 19:51:07 -0800
Message-ID: <93492d11-ca58-43b1-afeb-56fe7da4c45d@intel.com>
Date: Mon, 15 Jan 2024 11:51:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/16] i386/cpu: Use APIC ID offset to encode cache
 topo in CPUID[4]
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Robert Hoo <robert.hu@linux.intel.com>, Babu Moger <babu.moger@amd.com>,
 Yongwei Ma <yongwei.ma@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-3-zhao1.liu@linux.intel.com>
 <f5202ebd-6bc8-44b1-b22b-f3a033e0f283@intel.com> <ZZ+qGfykupOEFPA2@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZZ+qGfykupOEFPA2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/11/2024 4:43 PM, Zhao Liu wrote:
> Hi Xiaoyao,
> 
> On Wed, Jan 10, 2024 at 05:31:28PM +0800, Xiaoyao Li wrote:
>> Date: Wed, 10 Jan 2024 17:31:28 +0800
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>> Subject: Re: [PATCH v7 02/16] i386/cpu: Use APIC ID offset to encode cache
>>   topo in CPUID[4]
>>
>> On 1/8/2024 4:27 PM, Zhao Liu wrote:
>>> From: Zhao Liu <zhao1.liu@intel.com>
>>>
>>> Refer to the fixes of cache_info_passthrough ([1], [2]) and SDM, the
>>> CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26] should use the
>>> nearest power-of-2 integer.
>>>
>>> The nearest power-of-2 integer can be calculated by pow2ceil() or by
>>> using APIC ID offset (like L3 topology using 1 << die_offset [3]).
>>>
>>> But in fact, CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26]
>>> are associated with APIC ID. For example, in linux kernel, the field
>>> "num_threads_sharing" (Bits 25 - 14) is parsed with APIC ID.
>>
>> And for
>>> another example, on Alder Lake P, the CPUID.04H:EAX[bits 31:26] is not
>>> matched with actual core numbers and it's calculated by:
>>> "(1 << (pkg_offset - core_offset)) - 1".
>>
>> could you elaborate it more? what is the value of actual core numbers on
>> Alder lake P? and what is the pkg_offset and core_offset?
> 
> For example, the following's the CPUID dump of an ADL-S machine:
> 
> CPUID.04H:
> 
> 0x00000004 0x00: eax=0xfc004121 ebx=0x01c0003f ecx=0x0000003f edx=0x00000000
> 0x00000004 0x01: eax=0xfc004122 ebx=0x01c0003f ecx=0x0000007f edx=0x00000000
> 0x00000004 0x02: eax=0xfc01c143 ebx=0x03c0003f ecx=0x000007ff edx=0x00000000
> 0x00000004 0x03: eax=0xfc1fc163 ebx=0x0240003f ecx=0x00009fff edx=0x00000004
> 0x00000004 0x04: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> 
> 
> CPUID.1FH:
> 
> 0x0000001f 0x00: eax=0x00000001 ebx=0x00000001 ecx=0x00000100 edx=0x0000004c
> 0x0000001f 0x01: eax=0x00000007 ebx=0x00000014 ecx=0x00000201 edx=0x0000004c
> 0x0000001f 0x02: eax=0x00000000 ebx=0x00000000 ecx=0x00000002 edx=0x0000004c
> 
> The CPUID.04H:EAX[bits 31:26] is 63.
>  From CPUID.1FH.00H:EAX[bits 04:00], the core_offset is 1, and from
> CPUID.1FH.01H:EAX[bits 04:00], the pkg_offset is 7.
> 
> Thus we can verify that the above equation as:
> 
> 1 << (0x7 - 0x1) - 1 = 63.
> 
> "Maximum number of addressable IDs" refers to the maximum number of IDs
> that can be enumerated in the APIC ID's topology layout, which does not
> necessarily correspond to the actual number of topology domains.
> 

you still don't tell how many core numbers on Alder lake P.

I guess the number is far smaller than 64, which is not matched with (63 
+ 1)


