Return-Path: <kvm+bounces-64047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A56EC76DC6
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 02:18:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E1B9834BD21
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B273D27144E;
	Fri, 21 Nov 2025 01:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QA/vz88w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E95D2773DE;
	Fri, 21 Nov 2025 01:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763687915; cv=none; b=Nbl9YPpwtHtw4eDBpX0GK49gHW1rT6cH6iFhXRc1/etkpsx0sRUOJxbcgOrJ8hhT4VywDWw0xatEkO/SsyjUUmwtYIUs6XxtrVFxAhfOR0vm4qVWObX2sNxCBmIIb8otbcehtKjfiqOdN3fyPflbzwm79QiB8rlvWj8GDMWnX5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763687915; c=relaxed/simple;
	bh=zjOUf9QJkGZd50foy5VOeWyGByG+kC56893P8ylR0y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D1roDSSlMJ1ZWVxpQLh0J8nmUYjNPYGD21nSRIgfrkbjGUEFBLU/CPJeufOCzfA7H62qc4K/8+6PTG27bcDlNf8czxCu+qq49bghvPD8b4kcbilcTxL5QoiVll4FLepJB0I+b8+icKwDJvv733E1R48NyU2Rf+36RoCze40Uh00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QA/vz88w; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763687913; x=1795223913;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zjOUf9QJkGZd50foy5VOeWyGByG+kC56893P8ylR0y4=;
  b=QA/vz88w+txPGde2zhn5+XARXkW/yy+T9FVhcTHANOavnIDD0hHchb6a
   oakI2pEi/NWpyamGmUV9pufO5WZ1rrE0tjswlxsHe4sNUDTM+hWhf/K07
   0b4VcAhh3pQ4arNt+MtgcZkxH6qtEW6QnSqFiR9s+cmNniEdkdR9mTVND
   7TNu8Z4tkbN6PeS/amEu2n5yYxRanJe1GRVdXKZYxcdRalXnIpAaNvP+s
   woboBPAzwtHtUdNYmzBrgDWLl1BiyCvKLmkRA7uq1E0dDaE+HEbZVszhv
   lgODNJnZXWQRJBhN1jWf19+ui52kDwTF45uDbd3FmCU8ClIm5dNvHy8Pt
   g==;
X-CSE-ConnectionGUID: 3uKkS8l2Q6S6xeKjaqSHwA==
X-CSE-MsgGUID: ntKt3hCsTuecRe36UrGvxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="77138829"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="77138829"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 17:18:32 -0800
X-CSE-ConnectionGUID: I5XrZWPJTmqMhpZuXnQh4g==
X-CSE-MsgGUID: EuluM552TBunkEKTWAgXnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="190759576"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.213]) ([10.124.240.213])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 17:18:29 -0800
Message-ID: <45734caa-e058-47c9-a2ee-f49e15557aa0@linux.intel.com>
Date: Fri, 21 Nov 2025 09:18:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch v3 1/8] x86/pmu: Add helper to detect Intel
 overcount issues
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Zide Chen <zide.chen@intel.com>,
 Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 dongsheng <dongsheng.x.zhang@intel.com>, Yi Lai <yi1.lai@intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
 <20250903064601.32131-2-dapeng1.mi@linux.intel.com>
 <aR-VtupdTy4vHvSz@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aR-VtupdTy4vHvSz@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2025 6:27 AM, Sean Christopherson wrote:
> On Wed, Sep 03, 2025, Dapeng Mi wrote:
>> From: dongsheng <dongsheng.x.zhang@intel.com>
>>
>> For Intel Atom CPUs, the PMU events "Instruction Retired" or
>> "Branch Instruction Retired" may be overcounted for some certain
>> instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
>> and complex SGX/SMX/CSTATE instructions/flows.
>>
>> The detailed information can be found in the errata (section SRF7):
>> https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
>>
>> For the Atom platforms before Sierra Forest (including Sierra Forest),
>> Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
>> be overcounted on these certain instructions, but for Clearwater Forest
>> only "Instruction Retired" event is overcounted on these instructions.
>>
>> So add a helper detect_inst_overcount_flags() to detect whether the
>> platform has the overcount issue and the later patches would relax the
>> precise count check by leveraging the gotten overcount flags from this
>> helper.
>>
>> Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
>> [Rewrite comments and commit message - Dapeng]
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Tested-by: Yi Lai <yi1.lai@intel.com>
>> ---
>>  lib/x86/processor.h | 27 ++++++++++++++++++++++++++
>>  x86/pmu.c           | 47 +++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 74 insertions(+)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 62f3d578..937f75e4 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -1188,4 +1188,31 @@ static inline bool is_lam_u57_enabled(void)
>>  	return !!(read_cr3() & X86_CR3_LAM_U57);
>>  }
>>  
>> +/* Copy from kernel arch/x86/lib/cpu.c */
> Eh, just drop this, we don't care if the kernel code changes, this is all based
> on architectural behavior.
>
>> +static inline u32 x86_family(u32 sig)
>> +{
>> +	u32 x86;
>> +
>> +	x86 = (sig >> 8) & 0xf;
>> +
>> +	if (x86 == 0xf)
>> +		x86 += (sig >> 20) & 0xff;
>> +
>> +	return x86;
>> +}
>> +
>> +static inline u32 x86_model(u32 sig)
>> +{
>> +	u32 fam, model;
>> +
>> +	fam = x86_family(sig);
>> +
>> +	model = (sig >> 4) & 0xf;
>> +
>> +	if (fam >= 0x6)
>> +		model += ((sig >> 16) & 0xf) << 4;
>> +
>> +	return model;
>> +}
> We should place these up near is_intel() so that it's more obviously what "family"
> and "model" mean (should be obvious already, but it's an easy thing to do).

Yes.


>> +/*
>> + * For Intel Atom CPUs, the PMU events "Instruction Retired" or
>> + * "Branch Instruction Retired" may be overcounted for some certain
>> + * instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
>> + * and complex SGX/SMX/CSTATE instructions/flows.
>> + *
>> + * The detailed information can be found in the errata (section SRF7):
>> + * https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
>> + *
>> + * For the Atom platforms before Sierra Forest (including Sierra Forest),
>> + * Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
>> + * be overcounted on these certain instructions, but for Clearwater Forest
>> + * only "Instruction Retired" event is overcounted on these instructions.
>> + */
>> +static u32 detect_inst_overcount_flags(void)
>> +{
>> +	u32 flags = 0;
>> +	struct cpuid c = cpuid(1);
>> +
>> +	if (x86_family(c.a) == 0x6) {
>> +		switch (x86_model(c.a)) {
>> +		case 0xDD: /* Clearwater Forest */
>> +			flags = INST_RETIRED_OVERCOUNT;
>> +			break;
>> +
>> +		case 0xAF: /* Sierra Forest */
>> +		case 0x4D: /* Avaton, Rangely */
>> +		case 0x5F: /* Denverton */
>> +		case 0x86: /* Jacobsville */
>> +			flags = INST_RETIRED_OVERCOUNT | BR_RETIRED_OVERCOUNT;
>> +			break;
>> +		}
>> +	}
>> +
>> +	return flags;
>> +}
> The errata tracking definitely belongs "struct pmu_caps pmu", and the init in
> pmu_init().

Yes.


>

