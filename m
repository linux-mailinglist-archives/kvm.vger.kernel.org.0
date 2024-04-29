Return-Path: <kvm+bounces-16141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1948B527D
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 09:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B31C1C2128F
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 07:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06713156CF;
	Mon, 29 Apr 2024 07:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SlgZIWBl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8C1134BF
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 07:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714376428; cv=none; b=QdZO7uLUmCWyOsd08YU9ETBMFmHbX5uHnKlXHQbjPPWHaaiJdnN04eayKwzYEK3VHUVjm/F8q5Llf/EaGJDm2xDyGPviPPqbTHvEL9xoORdMzWsX7NNPLW6WUcMRhpN0mGFJrQvBifkRGCfTieD98B/TQIch3FbXsaxAo7NayGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714376428; c=relaxed/simple;
	bh=MAil5FS34+y75CS+0PDQspYjKX73sE7JdG9ERtzpH2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SkgavlTGfQEnCW69jHQ9/P9QEPS4bE8ddYK+tGv5JPZStxwEb9yDBMJlpIO3atXYfVlcmcdWwDKf0VMqJIeIAA0R40fKrEHOlbuygfDa2vNjEt2Xs5nH2K/oWexeCxT6+xRoIfHW1zcE9QtGH4/Kn/A97VrBAAS08VwKQpGiWIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SlgZIWBl; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714376427; x=1745912427;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MAil5FS34+y75CS+0PDQspYjKX73sE7JdG9ERtzpH2c=;
  b=SlgZIWBllPqFToal7knFrcQ36+tRGqzXV1jUgYSVKnOMa0pdaEGpJRhx
   in8B+VAbAseYtDWGq4anufeGyHuxd0rrgcNMqzM6VYUaxAszi5AL92pGL
   CU3Haw+9OQhCDEP09N8YMFKkE5gm4BaDrm+PhpykJ68fydKJYBUkex4ri
   PF8rHvUSA77ZAINUUx1mNZEoZUW6mW+qe9B1sNA961Yqewi8mRyFDUgnk
   xZp6gTFtWBLXaVwcfixxthKQ2fdl9okr8XA0FbhOLDSGSxm8X9GMRqqbZ
   UiKc+f+q6ejwPVwThQLzo9Ljudp8Bbp6YDU7mmdqnvVa5LB+hf1GyB+n4
   g==;
X-CSE-ConnectionGUID: yMcJ27KhTw+2vGtkfczWkw==
X-CSE-MsgGUID: OScFxuT0SJyBryt7HDcoHA==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="10244672"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="10244672"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 00:40:25 -0700
X-CSE-ConnectionGUID: QDWFDxr3T4+vZvUV2Ap7MA==
X-CSE-MsgGUID: z2OiI6FdTe+jFrgVQSOX+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26105134"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 00:40:24 -0700
Message-ID: <9ed124f0-9006-4166-921b-135c3c2c84fd@intel.com>
Date: Mon, 29 Apr 2024 15:40:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/1] x86/apic: Fix
 test_apic_timer_one_shot() random failure
To: Yao Yuan <yuan.yao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, yuan.yao@linux.intel.com
References: <20240428022906.373130-1-yuan.yao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240428022906.373130-1-yuan.yao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/2024 10:29 AM, Yao Yuan wrote:
> Explicitly clear TMICT to avoid test_apic_timer_one_shot()
> negative failure.
> 
> Clear TMICT to disable any enabled but masked local timer.
> Otherwise timer interrupt may occur after lvtt_handler() is
> set as handler and **before** TDCR or TIMCT is set to new
> value, lead this test failure. Log comes from UEFI mode:

The exact reason is that the new value written to APIC_LVTT unmasks the 
timer interrupt and if TMICT has non-zero and small value configured 
before (by firmware or whatever) it may get an additional one-shot timer 
interrupt before new TMICT being programmed.

> PASS: PV IPIs testing
> PASS: pending nmi

> Got local timer intr before write to TDCR / TMICT
> old tmict:0x989680 old lvtt:0x30020 tsc2 - tsc1 = 0xb68
>            ^^^^^^^^          ^^^^^^^

It took me a while to figure out the above 2 two lines are added for 
debug yourself.

> FAIL: APIC LVT timer one shot
> 
> Fixes: 9f815b293961 ("x86: apic: add LVT timer test")
> Signed-off-by: Yao Yuan <yuan.yao@intel.com>
> ---
>   x86/apic.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/x86/apic.c b/x86/apic.c
> index dd7e7834..2052e864 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -480,6 +480,13 @@ static void test_apic_timer_one_shot(void)
>   	uint64_t tsc1, tsc2;
>   	static const uint32_t interval = 0x10000;
>   
> +	/*
> +	 * clear TMICT to disable any enabled but masked local timer.
> +	 * Otherwise timer interrupt may occur after lvtt_handler() is
> +	 * set as handler and **before** TDCR or TIMCT is set to new value,
> +	 * lead this test failure.
> +	 */
> +	apic_write(APIC_TMICT, 0);
>   #define APIC_LVT_TIMER_VECTOR    (0xee)
>   
>   	handle_irq(APIC_LVT_TIMER_VECTOR, lvtt_handler);
> 
> base-commit: 9cab58249f98adc451933530fd7e618e1856eb94


