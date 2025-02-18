Return-Path: <kvm+bounces-38412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B17AEA39705
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:27:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F330617153C
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49EB22FF22;
	Tue, 18 Feb 2025 09:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1V3ZfFp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8B71FFC48;
	Tue, 18 Feb 2025 09:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739870689; cv=none; b=neaiqcNqETuynuwB/scxZG168RB6k5czaCCnd7xMEEJCvzLvU5F0r5P3VzX9am3kHTjyctEQOqbxZhfXRret2H6UkGfQUsLbbGQrvd+ZtbLjZ6aREIG9H694UV9MpXLbj9GerHsmfA8hfMeOWZCX5wgxS7nbMxWN9zlZmrcpnmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739870689; c=relaxed/simple;
	bh=u3NTUke63J+FiMXN2bpgaJxdQ+QYdBae8LOnVMR0vtw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XvQsOT1G9vCccSJNqWryTmVSUMtNRGFmmBlnoXuV/a05PG8ePquvGS5g5yQYJWIUNodThNwZpMN3KWdsmLYC9RF+MhaqyBZ4QznM2/sWY0V7OldjSP9DrKa+CzGtRuIMdrgGvceV8eBktr8jan/f6jaQaGAfqvxrG4dZe09NHXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1V3ZfFp; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739870687; x=1771406687;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u3NTUke63J+FiMXN2bpgaJxdQ+QYdBae8LOnVMR0vtw=;
  b=h1V3ZfFpuz8woa3lKJkmljODYms/5kPci4XuciE3jgi1gwRAfL5NzEWM
   VrtGDtKBGIL+w9LVJblO2vbx0Iz1ypkDnf+KslfM3MuPo5yyw5/YAbCtx
   1XZPsPXvd613HSIz9YeCa5mNsQEqArDLMrkOFQcapiTZuaKoC1hJHaZ8I
   qeqzPZRCl+7hluyS65EwspC/ssnEuBVu/yNu1oH0t5sdq3oPdE06ezg3o
   jUEdI1HUNxpQSxI6vhEOwqtnWPPODCoedONTHTPl8O2/ESWQSpRyFV4XD
   VSmhQQeTnOxHl+Y1v0a4bDp5V4rMTw5h395DiPuv3FlbN3E/jO32yPYbi
   A==;
X-CSE-ConnectionGUID: mV4nD0wORzmbljC68iJKpA==
X-CSE-MsgGUID: 6KhEjPa4TEaOQSN0PupWoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="50770709"
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="50770709"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:24:46 -0800
X-CSE-ConnectionGUID: PKzfezc7QLi6eGJFjA8ITw==
X-CSE-MsgGUID: F1VeVPGETfelmdvdTilkwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="114208710"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:24:43 -0800
Message-ID: <cf013079-ad8a-4b07-bbcf-6f35d1126a92@linux.intel.com>
Date: Tue, 18 Feb 2025 17:24:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch v6 05/18] x86: pmu: Enlarge cnt[] length to
 48 in check_counters_many()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
 <20240914101728.33148-6-dapeng1.mi@linux.intel.com>
 <Z6-wbu7KFqFDLTLH@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z6-wbu7KFqFDLTLH@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 2/15/2025 5:06 AM, Sean Christopherson wrote:
> On Sat, Sep 14, 2024, Dapeng Mi wrote:
>> Considering there are already 8 GP counters and 4 fixed counters on
>> latest Intel processors, like Sapphire Rapids. The original cnt[] array
>> length 10 is definitely not enough to cover all supported PMU counters on
>> these new processors even through currently KVM only supports 3 fixed
>> counters at most. This would cause out of bound memory access and may trigger
>> false alarm on PMU counter validation
>>
>> It's probably more and more GP and fixed counters are introduced in the
>> future and then directly extends the cnt[] array length to 48 once and
>> for all. Base on the layout of IA32_PERF_GLOBAL_CTRL and
>> IA32_PERF_GLOBAL_STATUS, 48 looks enough in near feature.
>>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  x86/pmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index a0268db8..b4de2680 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -255,7 +255,7 @@ static void check_fixed_counters(void)
>>  
>>  static void check_counters_many(void)
>>  {
>> -	pmu_counter_t cnt[10];
>> +	pmu_counter_t cnt[48];
> ARGH.  Since the *entire* purpose of increasing the size is to guard against
> buffer overflow, add an assert that the loop doesn't overflow.

This is not only for ensuring no buffer overflow. As the commit message
says,  the counter number has already exceeded 10, such as SPR has 12
counters (8 GP + 4 fixed), and there would be more counters in later
platfroms. The aim of enlarging the array size is to ensure these counters
can be enabled and verified simultaneously.  48 may be too large and 32
should be fair enough. Thanks.


>
>>  	int i, n;
>>  
>>  	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
>> -- 
>> 2.40.1
>>

