Return-Path: <kvm+bounces-12990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B8C488FB79
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31930296466
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AA554745;
	Thu, 28 Mar 2024 09:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O4jkjKCA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBF42594;
	Thu, 28 Mar 2024 09:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711618184; cv=none; b=qr13+cnl+fXLVr5vpnnxculw8h/Fqbllsv32HlY9O+KfpHGj6ALr+aDcu82YmHIqi+97TA79CJ3ZI5NhkR8eICca6V9Knt7NEDV1m2J8KabnlmidPqu+QVtaWn6xBUpIXsAG/OOlI6eGpOxypbNtOMwe1K+WQ107xAjQBpcLF3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711618184; c=relaxed/simple;
	bh=v3ajfryQVZH7lWMblKAdRzpy7eCW+nx7XKEL/vmZWBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HR/AOqpXfX10+IlsH/yi3KBA74G6vOqWo5L8KCmNq96h2uZrXM9zBIVTPkCSRHuaOGclnFT9bOsBEgafRxEf/crcUTOa1+/4XbwyMDa0gxuEUiFc3aeYldOcyhUes5n0iv2pDj42aL0TN7y9DKZUfS2QC0UgVkM6UIKFdvY4V5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O4jkjKCA; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711618183; x=1743154183;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v3ajfryQVZH7lWMblKAdRzpy7eCW+nx7XKEL/vmZWBo=;
  b=O4jkjKCAPoJ+09icwo9QkzlfcGb9f/qYPNry6j0cn/K0Zaqa9Fxo+51x
   D/SqzOAhvPhXYJImO0UPlehlZa8YHYVBTyuO3y6Qoy14Mvu6RDx/Jc6Qj
   eck9q/LgHYKDNW4cG8vexzH11X7Xo2/ROR18sDMAfct+H2EbbxHgkHKXt
   nhgd92GK+OeNHtHYd0mb06pTRiBgSnxdyAI0gU1ur49vAInwm1TPfnkVW
   RHb9MW8MSENG5/6yQQhzk2pJYg6PkbVugWO3DqpSvd+cnw4/3tg4ZhIn+
   m1QuXbw8+cLeLpG8yQwDrcqmFxLNRhtcDDnaloUaXQyog54YfbKKg74Qv
   A==;
X-CSE-ConnectionGUID: NJVoyxKJSHKMOth5TAQB5g==
X-CSE-MsgGUID: Wp35oWLDRH+BZUYvgamC0Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="29240432"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="29240432"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 02:29:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="21063871"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 02:29:39 -0700
Message-ID: <a4e33c84-416d-4bdb-a8ff-2bab70527877@linux.intel.com>
Date: Thu, 28 Mar 2024 17:29:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 03/11] x86: pmu: Add asserts to warn
 inconsistent fixed events and counters
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-4-dapeng1.mi@linux.intel.com>
 <CALMp9eRLVJrGORS5RrXefLOiMkhvbSAMgHLcPHM1Y0sLbQ4MmA@mail.gmail.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eRLVJrGORS5RrXefLOiMkhvbSAMgHLcPHM1Y0sLbQ4MmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/27/2024 9:11 PM, Jim Mattson wrote:
> On Tue, Jan 2, 2024 at 7:09 PM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>> Current PMU code deosn't check whether PMU fixed counter number is
>> larger than pre-defined fixed events. If so, it would cause memory
>> access out of range.
>>
>> So add assert to warn this invalid case.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   x86/pmu.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index a13b8a8398c6..a42fff8d8b36 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -111,8 +111,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>>                  for (i = 0; i < gp_events_size; i++)
>>                          if (gp_events[i].unit_sel == (cnt->config & 0xffff))
>>                                  return &gp_events[i];
>> -       } else
>> -               return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
>> +       } else {
>> +               int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
>> +
>> +               assert(idx < ARRAY_SIZE(fixed_events));
>> +               return &fixed_events[idx];
>> +       }
>>
>>          return (void*)0;
>>   }
>> @@ -245,6 +249,7 @@ static void check_fixed_counters(void)
>>          };
>>          int i;
>>
>> +       assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
>>          for (i = 0; i < pmu.nr_fixed_counters; i++) {
>>                  cnt.ctr = fixed_events[i].unit_sel;
>>                  measure_one(&cnt);
>> @@ -266,6 +271,7 @@ static void check_counters_many(void)
>>                          gp_events[i % gp_events_size].unit_sel;
>>                  n++;
>>          }
>> +       assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
> Can we assert this just once, in main()?
sure. would do.
>
>>          for (i = 0; i < pmu.nr_fixed_counters; i++) {
>>                  cnt[n].ctr = fixed_events[i].unit_sel;
>>                  cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
>> --
>> 2.34.1
>>

