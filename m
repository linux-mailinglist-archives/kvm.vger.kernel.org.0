Return-Path: <kvm+bounces-57268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63023B525B2
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 03:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CAED7ACE56
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 01:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340A61E3DCF;
	Thu, 11 Sep 2025 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mVWoWeFh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4287E8634A;
	Thu, 11 Sep 2025 01:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757553624; cv=none; b=U2x2Cvf9xL20maTcJ77yZT22N1Dr3chVLZp2tfwRPWnffPZtwEcDZYs8yL9isSnGTZ/qfuLLR5+0Mb/nWtyRf8YpBrk225jVyTlbWwjb9IR4r6EjcpMu/OMLL7eFGl1cHJu/yMsx974K91bA3K/dj1ABsaiUMXwiu6yr2OvJmzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757553624; c=relaxed/simple;
	bh=o6WRffcEM/8Gti6ksmiZu/eNzoCqTn5niA+O9XhwlAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjUEwTa0sA4++VYn0QWZYlXG/v0BJTEAn5shslyczV8YrsxIHWFQy6JpUAWIWr6PJfmOboVi2S0JRisu2Q0ayn5ThT+JKxxszyRK2DMqHRBTNXRKpv7Pd6sqQfIQFZtak7WzhLHvQXDOwQnBpb/MBUslRdtLXaHSBOUy1Qh8RPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mVWoWeFh; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757553622; x=1789089622;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o6WRffcEM/8Gti6ksmiZu/eNzoCqTn5niA+O9XhwlAM=;
  b=mVWoWeFhmA8+BFxH2lr2u+HE5EIk+B5AmU7k3itQM68GksnPSsxQe9Rc
   1PDBAuectALHSjxxl3uwrqyxvphgNf87CNuR7YBiCuRAMBKKUwz1U2fva
   EusPCcBAid2EhOdN2O5SM7Z406NoZY/smd5BPTF94EeHco979+oafHaO3
   cCUxaeKwkWjhNEpXeN0gZvsRvscrynPfek4fuoRHU4u1gHt1j5xkYdw3O
   8CDFXZh9eZmsL06TGTpmHnl5BHRX1UVZh8nKT8SnSzaEgDcunOb2wTbPI
   2NBScHo25kbVDxxvuVmDAe/GrWkhrR0Z5hgpPomKhy2xxsQtc/SqJRJCQ
   Q==;
X-CSE-ConnectionGUID: FWRsP/UnRRqJVfaee71upw==
X-CSE-MsgGUID: eIaD03YCQjGpVeewzrAQHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="62509125"
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="62509125"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 18:20:21 -0700
X-CSE-ConnectionGUID: nti9w0Y3SZSPtxjkz66Ebw==
X-CSE-MsgGUID: TqIHeK1OTEyiZWGkno9aZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="173119643"
Received: from unknown (HELO [10.238.3.254]) ([10.238.3.254])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 18:20:17 -0700
Message-ID: <3b3d361e-9543-4155-8837-037be854332f@linux.intel.com>
Date: Thu, 11 Sep 2025 09:20:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] KVM: selftests: Add timing_info bit support in
 vmx_pmu_caps_test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Zide Chen <zide.chen@intel.com>,
 Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
 <20250718001905.196989-3-dapeng1.mi@linux.intel.com>
 <aMH1xwsK1eTjJh71@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aMH1xwsK1eTjJh71@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 9/11/2025 6:03 AM, Sean Christopherson wrote:
> On Fri, Jul 18, 2025, Dapeng Mi wrote:
>> A new bit PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
>> to indicated if PEBS supports to record timing information in a new
>> "Retried Latency" field.
>>
>> Since KVM requires user can only set host consistent PEBS capabilities,
>> otherwise the PERF_CAPABILITIES setting would fail, so add
>> pebs_timing_info bit into "immutable_caps" to block host inconsistent
>> PEBS configuration and cause errors.
> Please explain the removal of anythread_deprecated.  AFAICT, something like this
> is accurate:
>
> Opportunistically drop the anythread_deprecated bit.  It isn't and likely
> never was a PERF_CAPABILITIES flag, the test's definition snuck in when
> the union was copy+pasted from the kernel's definition.

Yes, would add this in next version. Thanks.


>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Tested-by: Yi Lai <yi1.lai@intel.com>
>> ---
>>  tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
>> index a1f5ff45d518..f8deea220156 100644
>> --- a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
>> +++ b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
>> @@ -29,7 +29,7 @@ static union perf_capabilities {
>>  		u64 pebs_baseline:1;
>>  		u64	perf_metrics:1;
>>  		u64	pebs_output_pt_available:1;
>> -		u64	anythread_deprecated:1;
>> +		u64	pebs_timing_info:1;
>>  	};
>>  	u64	capabilities;
>>  } host_cap;
>> @@ -44,6 +44,7 @@ static const union perf_capabilities immutable_caps = {
>>  	.pebs_arch_reg = 1,
>>  	.pebs_format = -1,
>>  	.pebs_baseline = 1,
>> +	.pebs_timing_info = 1,
>>  };
>>  
>>  static const union perf_capabilities format_caps = {
>> -- 
>> 2.34.1
>>

