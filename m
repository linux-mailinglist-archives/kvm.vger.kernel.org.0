Return-Path: <kvm+bounces-52557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB55BB06B03
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 03:13:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C41E84E09B2
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 01:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF7EE20E704;
	Wed, 16 Jul 2025 01:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RiymNPSs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D79C14EC5B;
	Wed, 16 Jul 2025 01:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752628427; cv=none; b=p9g3axhzIW0jZ5DKuGFgFFE5IyxX+lfJKDnpVDGPWpF1Jnid2XGGuCxAVsZm9snmp5uB7y2rJ/YCuZ9Jr+AKCA14dsPVSZKwM/rO5UWPnUS7WynuY+agCqxZRf5e8ebBoSbDJhKd/MwnPvRICsAERf3BQh+W5T4J2i3b8t3HS0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752628427; c=relaxed/simple;
	bh=X48MZnoiV532ANMzgp7bTB5uiop/oI4cGhR8Ze3iHTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=INF2yNQ4CIerkDUSmz6OcXiNDK1icFbrcseJm2/4qcXn1h3JyvMR5O+wJIlxiI+OChqasWdA/iQkQ5hHQbU/NwB22P36cj69N/pN5DOWcinu1eRb8nEcYyiKfenpROoEsEaZBUQU6H3ti3PAo5O789djIDc6XHg7eQKDHqlMSrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RiymNPSs; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752628425; x=1784164425;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=X48MZnoiV532ANMzgp7bTB5uiop/oI4cGhR8Ze3iHTM=;
  b=RiymNPSsQuItLOZcgBacgJ77TU1Qo33+ctwF9a6jDAOyfAe3uBiuz7dX
   GukT4kkAlWJb8gkuTqJwub3xX3/cA1k4xWA992y6f9jS4zmztCWpgD4RA
   4LFAM5uj4yZJYFK8+Q7gPJ5+hLF0GYsdiA+kagMTLSNZNV+kSMnwnYSij
   s0QXhtPpd86ZW23BKUWTQ3OEc+EztZpmZDKy9Xy7YUG9RgKuIQgl9P2j5
   XjSZmJpKvMMqQFfKaDzAoh4Cykdi/Y7N5zHYWiToCztbSZGalRYESo+17
   ZrcVDlALAaYeuvxy8Xs2L7t7m4y6qPD8uLfSVX+KNp/qsPIWWYuHjk8Dh
   Q==;
X-CSE-ConnectionGUID: QMt9KL/qTWaFjrtxDdPZhQ==
X-CSE-MsgGUID: gF1BJNd2RaKggV7zmbX7DQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="58519589"
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="58519589"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 18:13:44 -0700
X-CSE-ConnectionGUID: hyTx16iVSiKOyxm1RmOHNQ==
X-CSE-MsgGUID: a2BKpr8nRqKEYCuKI6WJAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="157469012"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 18:13:39 -0700
Message-ID: <449b2fa5-775b-41ab-8a9e-5a43e855e931@linux.intel.com>
Date: Wed, 16 Jul 2025 09:13:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch 1/5] x86/pmu: Add helper to detect Intel
 overcount issues
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>,
 Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>,
 Shukla Manali <Manali.Shukla@amd.com>, Yi Lai <yi1.lai@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, dongsheng <dongsheng.x.zhang@intel.com>
References: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
 <20250712174915.196103-2-dapeng1.mi@linux.intel.com>
 <e635c41e-55be-408d-ab43-7875021a9ecc@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <e635c41e-55be-408d-ab43-7875021a9ecc@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 7/15/2025 9:27 PM, Xiaoyao Li wrote:
> On 7/13/2025 1:49 AM, Dapeng Mi wrote:
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
>>   lib/x86/processor.h | 17 ++++++++++++++++
>>   x86/pmu.c           | 47 +++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 64 insertions(+)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 62f3d578..3f475c21 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -1188,4 +1188,21 @@ static inline bool is_lam_u57_enabled(void)
>>   	return !!(read_cr3() & X86_CR3_LAM_U57);
>>   }
>>   
>> +static inline u32 x86_family(u32 eax)
>> +{
>> +	u32 x86;
>> +
>> +	x86 = (eax >> 8) & 0xf;
>> +
>> +	if (x86 == 0xf)
>> +		x86 += (eax >> 20) & 0xff;
>> +
>> +	return x86;
>> +}
>> +
>> +static inline u32 x86_model(u32 eax)
>> +{
>> +	return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
>> +}
> It seems to copy the implementation of kvm selftest.
>
> I need to point it out that it's not correct (because I fixed the 
> similar issue on QEMU recently).
>
> We cannot count Extended Model ID unconditionally. Intel counts Extended 
> Model when (base) Family is 0x6 or 0xF, while AMD counts EXtended Model 
> when (base) Family is 0xF.
>
> You can refer to kernel's x86_model() in arch/x86/lib/cpu.c, while it 
> optimizes the condition to "family >= 0x6", which seems to have the 
> assumption that Intel doesn't have processor with family ID from 7 to 
> 0xe and AMD doesn't have processor with family ID from 6 to 0xe.

Sure. Thanks for reviewing.



