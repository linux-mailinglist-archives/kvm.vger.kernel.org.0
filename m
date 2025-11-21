Return-Path: <kvm+bounces-64048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BED6C76DD8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 02:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E14935778B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBC72797AE;
	Fri, 21 Nov 2025 01:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bSfKVHqB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59C15746F;
	Fri, 21 Nov 2025 01:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763688341; cv=none; b=KSh4yqPcMc5tMgQYCKBzZ5pd3OrQBKkMphDK/NHvSbTTToOP5gJGSP6M3NndbtzJvP/wlgEkbvQPEB89MsiCAL0ekrEb6+M9/JifcjFNKgaDQB5KP4YbBImUYByitsuSSIa9jGP27jQZIO8jk2UIkaV8DyHdL6Ghps+XxU6fgy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763688341; c=relaxed/simple;
	bh=Se7GjA3yBqyYCw8zPro/STBGeggfCIXjMybYigEtu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aGBoVlMOuUkiJPUvX/ZQ1STAKI6YtB3WnrTZr9DWbwu3ilYyXEjtCGN1qjJ4qSEcjkWPL5CKryZ4MapxVnMx5O3D4oDtnzN8fxlYu209NK+FkGSayuX3f+9+5z+x8RiIgVOZUGLKaNp0iT42RIi9Er+Q0Gt+J4n0YH9bV2BKVIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bSfKVHqB; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763688340; x=1795224340;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Se7GjA3yBqyYCw8zPro/STBGeggfCIXjMybYigEtu8Q=;
  b=bSfKVHqB/2yCowZmNUZ5mTQLTDsUzMCxwhDN1JMOVMmsXCxKOGrxIsEt
   v/N1e70O4zGrGZ9b30m3xtFvKNos9nn9WQS+H6HqF/djRNpHf8/aZ1QOV
   CJFkCrNrhgPceJnUVUU/eHY/uMvOKH5aGSHh5RFaKIKvUm7a6EssyZhfk
   +MuU9ZIlJHuMtKeWEY0+RomMOgestb22aSCs9EyeCMTm8wXiu54kS3h1x
   LdPtvxKqoyDgz9Mol7yXfor1J2VU7RyYTsoT3RO3xNp9Y8uSlCFR+VdEV
   rFWnxwt4vzXIgHVUYEZ6xHfJSIESlWHihGS/e6yQuPRReOyMVKV/v+BSp
   Q==;
X-CSE-ConnectionGUID: kmuWFSdFSjiYwX7KqiVpqw==
X-CSE-MsgGUID: 8j39VXQiQxKGfc8R0gSG0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="69391471"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="69391471"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 17:25:40 -0800
X-CSE-ConnectionGUID: /dpE2n9kTOuX5q+zNC6S1Q==
X-CSE-MsgGUID: 3/gEUps8QnSzEpslchccMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="191638969"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.213]) ([10.124.240.213])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 17:25:36 -0800
Message-ID: <b6a694a0-5e6d-4cb6-947e-e3b00a4fd057@linux.intel.com>
Date: Fri, 21 Nov 2025 09:25:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch v3 3/8] x86/pmu: Fix incorrect masking of
 fixed counters
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Zide Chen <zide.chen@intel.com>,
 Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 dongsheng <dongsheng.x.zhang@intel.com>, Yi Lai <yi1.lai@intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
 <20250903064601.32131-4-dapeng1.mi@linux.intel.com>
 <aR-WAGVNZwNh7Xo8@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aR-WAGVNZwNh7Xo8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2025 6:28 AM, Sean Christopherson wrote:
> On Wed, Sep 03, 2025, Dapeng Mi wrote:
>> From: dongsheng <dongsheng.x.zhang@intel.com>
>>
>> The current implementation mistakenly limits the width of fixed counters
>> to the width of GP counters. Corrects the logic to ensure fixed counters
>> are properly masked according to their own width.
>>
>> Opportunistically refine the GP counter bitwidth processing code.
>>
>> Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
>> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Tested-by: Yi Lai <yi1.lai@intel.com>
>> ---
>>  x86/pmu.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 04946d10..44c728a5 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -556,18 +556,16 @@ static void check_counter_overflow(void)
>>  		int idx;
>>  
>>  		cnt.count = overflow_preset;
>> -		if (pmu_use_full_writes())
>> -			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
>> -
>>  		if (i == pmu.nr_gp_counters) {
>>  			if (!pmu.is_intel)
>>  				break;
>>  
>>  			cnt.ctr = fixed_events[0].unit_sel;
>> -			cnt.count = (&cnt);
> Per commit 7ec3b67a ("x86/pmu: Reset the expected count of the fixed counter 0
> when i386"), re-measuring for the fixed counter is necessary when running a 32-bit
> guests.  I didn't see failures (spotted this by inspection), but I don't see any
> point in making this change without good reason.

Thanks. I didn't realized that the 2nd measure_for_overflow() is intended
to add ...


>
>> -			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
>> +			cnt.count &= (1ull << pmu.fixed_counter_width) - 1;
>>  		} else {
>>  			cnt.ctr = MSR_GP_COUNTERx(i);
>> +			if (pmu_use_full_writes())
>> +				cnt.count &= (1ull << pmu.gp_counter_width) - 1;
>>  		}
>>  
>>  		if (i % 2)
>> -- 
>> 2.34.1
>>

