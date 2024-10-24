Return-Path: <kvm+bounces-29593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B05049ADDB1
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEDB51C21745
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F2D197A7F;
	Thu, 24 Oct 2024 07:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R09RFLPZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494E01AB52D;
	Thu, 24 Oct 2024 07:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729755074; cv=none; b=TlBBEIbcieRg4ack9DNaXEAoaGlqvthOS0m+hUdloamZmhWsK1GA2oyb8+YHWs/U+UmqrXzvAWlfIKMzCDI22dMvsO7GL4C1ENKFChLUhP/wsVIfXgdVMDVMtzpzJDAJn9q5zxO58+L2BqbnwbC5eGQc0Y2nTU3pZmkgE/GkU6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729755074; c=relaxed/simple;
	bh=wf3cEPURcPpfG9APxjvGupgNsU7H6x3tO+a3BsUMl4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FeHBIfKncMC5TLBY1yjlRzuir9Mka2IwrB2F+f3e2PZmu7Qd8uiR41ZqWL4xykkK6JHG5bvmqTeDZiu2qpcwi9+0C7yGaOl0JimN9VeRMaBwyVEGrndv+x0wgsRP3wabo5KOdeC1TJX8cBOLLDAruaSukEKKNC2HlYOlt1fxWDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R09RFLPZ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729755073; x=1761291073;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wf3cEPURcPpfG9APxjvGupgNsU7H6x3tO+a3BsUMl4U=;
  b=R09RFLPZb2Qq1ufOFu81Pf6rahLwjYD/fstZL66S2jHM5Zh6JtD/id9m
   WxeOpROXuLkeyhusiGvvx5maG+uWGhvl+K6Ht0RSjVa6XUu/jo0609/lN
   UOMGD1wLLf3mLuGrY/1tha9DMl754RWJuuq2F4jHE2/XJ3cKiXAdjRyEj
   jR3M4glD1kqLUDsGyVSAV7I7PeNOoHLkt5QNbf/m/3LGlcqRPHStsTSY7
   KHlCpgb5eKUwno1wl96hhVjqHOoXSCfwjuzQLRU5aR/bw53Itbz4dsc2c
   oT/PYWhO92L98rP2Bx1CJ+CAnhzBPQmurEoceUX/Azxsd72IGA8t8Iqhv
   Q==;
X-CSE-ConnectionGUID: AiHnqiK5REmgvpD6ja8NFg==
X-CSE-MsgGUID: /h3DdF6cTfunbB1Enq57Zg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40489618"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40489618"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:31:12 -0700
X-CSE-ConnectionGUID: qUAp2O4RQiGD8RVc0VRefQ==
X-CSE-MsgGUID: ldtucLlCRseugEksyp/h7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="80681278"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:31:07 -0700
Message-ID: <3a13ad57-8006-4218-b9fb-36f235a5d5cc@intel.com>
Date: Thu, 24 Oct 2024 15:31:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
To: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-5-nikunj@amd.com>
 <c0596432-a20c-4cb7-8eb4-f8f23a1ec24b@intel.com>
 <33300e68-dde5-0456-2a6d-4fb585d188a6@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <33300e68-dde5-0456-2a6d-4fb585d188a6@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/24/2024 2:24 PM, Nikunj A. Dadhania wrote:
> 
> 
> On 10/23/2024 8:55 AM, Xiaoyao Li wrote:
>> On 10/21/2024 1:51 PM, Nikunj A Dadhania wrote:
>>> Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
>>> the subsequent TSC value reads are undefined. MSR_IA32_TSC read/write
>>> accesses should not exit to the hypervisor for such guests.
>>>
>>> Accesses to MSR_IA32_TSC needs special handling in the #VC handler for the
>>> guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be ignored,
>>> and reads of MSR_IA32_TSC should return the result of the RDTSC
>>> instruction.
>>>
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> Tested-by: Peter Gonda <pgonda@google.com>
>>> ---
>>>    arch/x86/coco/sev/core.c | 24 ++++++++++++++++++++++++
>>>    1 file changed, 24 insertions(+)
>>>
>>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>>> index 965209067f03..2ad7773458c0 100644
>>> --- a/arch/x86/coco/sev/core.c
>>> +++ b/arch/x86/coco/sev/core.c
>>> @@ -1308,6 +1308,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>>            return ES_OK;
>>>        }
>>>    +    /*
>>> +     * TSC related accesses should not exit to the hypervisor when a
>>> +     * guest is executing with SecureTSC enabled, so special handling
>>> +     * is required for accesses of MSR_IA32_TSC:
>>> +     *
>>> +     * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
>>> +     *         of the TSC to return undefined values, so ignore all
>>> +     *         writes.
>>> +     * Reads:  Reads of MSR_IA32_TSC should return the current TSC
>>> +     *         value, use the value returned by RDTSC.
>>> +     */
>>
>> Why doesn't handle it by returning ES_VMM_ERROR when hypervisor intercepts
>> RD/WR of MSR_IA32_TSC? With SECURE_TSC enabled, it seems not need to be
>> intercepted.
> 
> ES_VMM_ERROR will terminate the guest, which is not the expected behaviour. As
> documented, writes to the MSR is ignored and reads are done using RDTSC.
> 
>> I think the reason is that SNP guest relies on interception to do the ignore
>> behavior for WRMSR in #VC handler because the writing leads to undefined
>> result.
> 
> For legacy and secure guests MSR_IA32_TSC is always intercepted(for both RD/WR).

We cannot make such assumption unless it's enforced by AMD HW.

> Moreover, this is a legacy MSR, RDTSC and RDTSCP is the what modern OSes should
> use. 

Again, this is your assumption and expectation only.

> The idea is the catch any writes to TSC MSR and handle them gracefully.

If SNP guest requires MSR_IA32_TSC being intercepted by hypervisor. It 
should come with a solution that guest kernel can check it certainly, 
just like the patch 5 and patch 6, that they can check the behavior of 
hypervisor.

If there is no clean way for guest to ensure MSR_IA32_TSC is intercepted 
by hypervisor, we at least need add some comment to call out that these 
code replies on the assumption that hypervisor intercepts MSR_IA32_TSC.

>> Then the question is what if the hypervisor doesn't intercept write to
>> MSR_IA32_TSC in the first place?
> 
> I have tried to disable interception of MSR_IA32_TSC, and writes are ignored by
> the HW as well. I would like to continue the current documented HW as per the APM.

I only means the writes are ignored in your testing HW. We don't know 
the result on other SNP-capable HW or future HW, unless it's documented 
in APM.

Current documented behavior is that write leads to a undefined value of 
subsequent read. So we need to avoid write. One solution is to intercept 
write and ignore it, but it depends on hypervisor to intercept it. 
Anther solution would be we fix all the place of writing MSR_IA32_TSC 
for SNP guest in linux.

> Regards,
> Nikunj


