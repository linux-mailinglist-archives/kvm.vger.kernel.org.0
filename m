Return-Path: <kvm+bounces-25027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51ACA95E964
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 08:56:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FB46281735
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 06:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBD084A5E;
	Mon, 26 Aug 2024 06:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KKqu/9h5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80C68289E;
	Mon, 26 Aug 2024 06:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724655370; cv=none; b=KCEfWpp0ei/BEtloOhjqoBWEmNZA12At/R62BoqtK67DNC/RsxCC/Kv3NTyCMT95r1KaEYLtKdIw8ZeAQ3GfiRLVpLxEoJJGeNjLOA6v5T8TolI2w2u26Si4g2BSjaqAeilxO97+lPAIZTwvwTm6RjGQ1szlntS/I9v667AFTrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724655370; c=relaxed/simple;
	bh=Ru9+XhmubHdpIfS1dyFow9oErhNFqhxAQFaNGVviT5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhO9yajmZ6cgTC/aCczO1wLdIx4jvndyeiKb8s0gNwFd/4bPIwQ6fHIDRaz9Jkr1VNYwZQA89ZXqsxD5ijhgpc83Fn2gh75Oqhh56Cd5sO4tNIwUFGRpFfYFgkTeFDgviWKTfjPzqZuT4/fcjgeCpzu1787E1jcyimAV+X3Q+fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KKqu/9h5; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724655369; x=1756191369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ru9+XhmubHdpIfS1dyFow9oErhNFqhxAQFaNGVviT5o=;
  b=KKqu/9h5unhvIaFrAZ5J0BJ5gUj6D7B/VFjrxHTLmurdyaAQm4MPzaGG
   JHEyAt7B3KTKADdp1jUXnZlEfwJuiLxUfWKk80ls8EHHMvPVPlR8Pefju
   wEZVZWgadhG1RmghuO2NEEA84X040pR34sIj0yjITex+/BTXteimvgEXa
   oXw7Z2xoQCyRSVVhHGlHd04FQvobk/0LE9/9nm36kziPKAn4bJ3qhQ/np
   ATR63F6nNH9B7WJX4HfI3Hcb9xCV8d2C0fWBJyxSNMTitUxBJcH3ZW7pQ
   kZyM80UQSfq20VWErROZwwsqex+ObeaRWC78XjWCOgnoFR9szPVmBBYKa
   Q==;
X-CSE-ConnectionGUID: s/RVCZngS16haCyG/YOjUQ==
X-CSE-MsgGUID: Jdn9mIpXSRWP0xkIPWAEXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11175"; a="22866968"
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="22866968"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 23:56:08 -0700
X-CSE-ConnectionGUID: ochtj1rVSveqIgjB9HFk4Q==
X-CSE-MsgGUID: 5U5U7NhDR1ev5eRUw5Cuwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="62252536"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 23:56:05 -0700
Message-ID: <cea61aab-3feb-4008-adb9-2f2645589714@linux.intel.com>
Date: Mon, 26 Aug 2024 14:56:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v5 06/18] x86: pmu: Add asserts to warn inconsistent fixed
 events and counters
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang
 <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
 <20240703095712.64202-7-dapeng1.mi@linux.intel.com>
 <CALMp9eSEuA70itad7oQUo=Ak6MVJYLo4kG4zJwEXkiUG6MgdnA@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eSEuA70itad7oQUo=Ak6MVJYLo4kG4zJwEXkiUG6MgdnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/23/2024 2:22 AM, Jim Mattson wrote:
> On Tue, Jul 2, 2024 at 7:12 PM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>> Current PMU code deosn't check whether PMU fixed counter number is
>> larger than pre-defined fixed events. If so, it would cause memory
>> access out of range.
>>
>> So add assert to warn this invalid case.
>>
>> Reviewed-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  x86/pmu.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index b4de2680..3e0bf3a2 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -113,8 +113,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>>                 for (i = 0; i < gp_events_size; i++)
>>                         if (gp_events[i].unit_sel == (cnt->config & 0xffff))
>>                                 return &gp_events[i];
>> -       } else
>> -               return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
>> +       } else {
>> +               unsigned int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
>> +
>> +               assert(idx < ARRAY_SIZE(fixed_events));
> Won't this assertion result in a failure on bare metal, for CPUs
> supporting fixed counter 3?

Yes, this is intended use. Currently KVM vPMU still doesn't support fixed
counter 3. If it's supported in KVM vPMU one day but forget to add
corresponding support in this pmu test, this assert would remind this.


>
>> +               return &fixed_events[idx];
>> +       }
>>
>>         return (void*)0;
>>  }
>> @@ -740,6 +744,8 @@ int main(int ac, char **av)
>>         printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>>         printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>>
>> +       assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
>> +
> And this one as well?
>
>>         apic_write(APIC_LVTPC, PMI_VECTOR);
>>
>>         check_counters();
>> --
>> 2.40.1
>>

