Return-Path: <kvm+bounces-51199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB159AEFDBE
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 17:13:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C9623B98CB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 15:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7EB27876E;
	Tue,  1 Jul 2025 15:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M3VXH5zH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE447140E34
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751382823; cv=none; b=eFWJCPQeWYRhk4mdc//XV+c3VFpHuJmVRI8gU4qnH631ZbdQZre86lItwOCAbqbYmFJfOuRjnwlcRvnVL9oiP2TyFpvRZyR4NulX0ExLeYLwa/JUH07DbhbHVR9d0fpTl1EDuQB+OWzwu7IDL6iiwXm8KfEkApMQdN4PveJUjC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751382823; c=relaxed/simple;
	bh=hcGGy5cmnJsNTiMK7Lwef975+eC1/j95aZrplOwmAxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZ3rkSYBNompnZX1GD7i4Mq/mZqAxV9FOTPfV5/Sb87ulD9VeTkoKHnUHBGkhMtLTQTu71uwJ/hHFkEUhMfO/utngaTq/t9NwwokL6nG9Y6PQj7J7H3AYgM8qJZSMOaZufHpYemlLJmOKNFyycJ3kwFjk9u+pYPPepZvk8WXPPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M3VXH5zH; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751382822; x=1782918822;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hcGGy5cmnJsNTiMK7Lwef975+eC1/j95aZrplOwmAxs=;
  b=M3VXH5zHG4j4IE0AS/tmrIs0l5IW1HHBQuo8+8T76oCcKZsvx2qrhWT9
   1Do70jOuF6f/TSpHfghaw/AIUQDn4lW9C4f+BwEt0Iq7udgYCIikbjKLW
   zc7csfzJblJcBWl1HAZM0L9au/IfZ78utF0UUFypgum22889tkp1er3er
   ZJR4hKMvEr3HN6bUx5A6qalEP68urrTl5Y+bF8xJL0MewnSjKohdiXk+y
   kSeNoIQ7JMsZuWlkSIUStQhr+uQncW3iW1Q2cWjPVlEg903IzUT49sst8
   vQVQ23d8VWzm6e8tj4ma1JvcwuGPgYYESDucdNRFEuVs1ZEEYQAG6Q3Cm
   A==;
X-CSE-ConnectionGUID: XmM7tmXwTpGp3mUaTviLig==
X-CSE-MsgGUID: 7wkEiwJOSAWGMhBKuhFoCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="71217150"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="71217150"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 08:13:41 -0700
X-CSE-ConnectionGUID: rABrkWjbQQyBLlPZQxR9ag==
X-CSE-MsgGUID: IKozC8+QS/iUjy+Ta7CQqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="159514178"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 08:13:38 -0700
Message-ID: <e19644ed-3e32-42f7-8d46-70f744ffe33b@intel.com>
Date: Tue, 1 Jul 2025 23:13:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
To: Alexandre Chartre <alexandre.chartre@oracle.com>,
 Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org,
 konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
 maciej.szmigiero@oracle.com, Sean Christopherson <seanjc@google.com>,
 kvm@vger.kernel.org
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com> <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <1ecfac9a-29c0-4612-b4d2-fd6f0e70de9d@oracle.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1ecfac9a-29c0-4612-b4d2-fd6f0e70de9d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/2025 8:12 PM, Alexandre Chartre wrote:
> 
> On 7/1/25 13:12, Xiaoyao Li wrote:
>> On 7/1/2025 6:26 PM, Zhao Liu wrote:
>>>> unless it was explicitly requested by the user.
>>> But this could still break Windows, just like issue #3001, which enables
>>> arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
>>> turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
>>> value would even break something.
>>>
>>> So even for named CPUs, arch-capabilities=on doesn't reflect the fact
>>> that it is purely emulated, and is (maybe?) harmful.
>>
>> It is because Windows adds wrong code. So it breaks itself and it's 
>> just the regression of Windows.
>>
>> KVM and QEMU are not supposed to be blamed.
> 
> I can understand the Windows code logic, and I don't think it is 
> necessarily wrong,
> because it finds that the system has:
> 
> - an AMD cpu
> - an Intel-only feature/MSR
> 
> Then what should the code do? Trust the cpu type (AMD) or trust the MSR 
> (Intel).
> They decided not to choose, and for safety they stop because they have 
> an unexpected
> configuration.

It's not how software/OS is supposed to work with x86 architecture.

Though there are different vendors for x86, like Intel and AMD, they 
both implement x86 architecture. For x86 architecture, architectural 
features are enumerated by CPUID. If you read Intel SDM and AMD APM, you 
will find that Intel defines most features at range [0, x] while AMD 
defines most features at range [0x8000 000, 0x8000 000y]. But if a bit 
is defined by both Intel and AMD, it must have same meaning and 
enumerate the same feature.

Usually, a feature is first introduced by one vendor, then other vendors 
might implement the same one later. E.g., bus lock detection, which is 
enumerated via CPUID.7_0:ECX[bit 24] and first introduced by Intel in 
2020. Later, AMD implemented the same one from Zen 5. Before AMD 
implemented it, it was an Intel-only feature. Can we make code as below

    if (is_AMD && cpuid_enumerates_bus_lock_detect)
	error(unsupported CPU);

at that time? If we wrote such code, then it will fail on all the AMD 
Zen 5 CPUs.

Besides, I would like to talk about how software is supposed to deal 
with reserved bits on x86 architecture. In general, software should not 
set any expectation on the reserved bit. The value cannot be relied upon 
to be 0 since any reserved bit can have a meaning in the future. As Igor 
said:

   software shouldn't even try to use it or make any decisions
   based on that

For more information, you can refer to Intel SDM vol1. chapter 1.3.2 
Reserved Bits and Software compatibility. For AMD APM, you would need 
search yourself.

OK, back to the original question "what should the code do?"

My answer is, it can behave with any of below option:

- Be vendor agnostic and stick to x86 architecture. If CPUID enumerates 
a feature, then the feature is available architecturally.

- Based on AMD spec. Ignore the bit since it's a reserved bit. (Expect a 
reserved bit to be zero if not explicitly state by spec is totally wrong!)

> alex.
> 


