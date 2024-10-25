Return-Path: <kvm+bounces-29681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DB29AF65C
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 02:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5408F282FCB
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 00:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B403C8DF;
	Fri, 25 Oct 2024 00:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ChBrEzCS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B9F4C8C;
	Fri, 25 Oct 2024 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729817545; cv=none; b=V6xdpNGv5r+0zTtZ3tBzYA/88onBJ0DlSq4u7y10+4B7j2GYRpGCJ8tEYVZnyiQfeX8EafKSv2xkl/wnA5ecbvHY6Ufn4ZJbE65VhQ78xbnjaXjRQG6jgcf53NrtcR2IC1eDmYyhZ2isuqOgo7b1Sl/gUxhbXU+ue57WuCxlu44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729817545; c=relaxed/simple;
	bh=ocI0j6ZWn+2VEadnGbtQtimuXCI7Yg0dIzJL/2nqX8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sQPyaeGRzY2+GKHwN3sTP4pKklDbcdjEipsAL0vokABqZETPEbHw7Ox+ShDA7LeczGVI3sU9lmHIuLlrREwRHRUH9tSCnlSjsoA8I7OoOdRLA4zYzXJeNtO6yC22bNxt3EOmqu2OkP6JVqNgIbA1GPNhfAQIO6Gzb0M6yNNSLNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ChBrEzCS; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729817544; x=1761353544;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ocI0j6ZWn+2VEadnGbtQtimuXCI7Yg0dIzJL/2nqX8s=;
  b=ChBrEzCSKaXvORAmdn6TisOoyvPnktYFh3y81whC3TMXDhK9XieiXwZ+
   SonuxBDdm0IYwi8vOuwsN2LFRUkRli7rdUvoV89botIT7nzHMIw5P/1aj
   /TLiMPf6NeRSnlRKl5Y7euoDsiiNR8xy9D41wJQMugUkI46zo8oId6WX5
   ek15IIRi36yOxkmy4t7+ENdUB+kuuNLAIHU9f5CSwB3YECoc8ghd4Iarb
   BsjRIocdXm9rkcNLX6Ysb5j5sSHYt6hX+8LZqqoz4+rAgF1CspY+OT15i
   8Q4R3alQmstU+QrHpS5Am2mNydOfidbQVi9Kk1zyPS/JJnrnjiTZG+dZO
   w==;
X-CSE-ConnectionGUID: x3MVrbs0TsKgXTEC9ATLVw==
X-CSE-MsgGUID: MPdLTRUTRHSqrgFtmukMtw==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="29590861"
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="29590861"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 17:52:23 -0700
X-CSE-ConnectionGUID: Fh8opea2Tumn8ezYh4QYyw==
X-CSE-MsgGUID: fYA9z0wVS6aPricdlmZwzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="80750176"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.240.3]) ([10.125.240.3])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 17:52:17 -0700
Message-ID: <55be834b-b489-49c7-b975-66f09f2244d3@linux.intel.com>
Date: Fri, 25 Oct 2024 08:52:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 15/58] perf/x86: Support switch_interrupt interface
To: "Chen, Zide" <zide.chen@intel.com>, Colton Lewis
 <coltonlewis@google.com>, Mingwei Zhang <mizhang@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, xiong.y.zhang@intel.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, manali.shukla@amd.com,
 sandipan.das@amd.com, jmattson@google.com, eranian@google.com,
 irogers@google.com, namhyung@kernel.org, gce-passthrou-pmu-dev@google.com,
 samantha.alt@intel.com, zhiyuan.lv@intel.com, yanfei.xu@intel.com,
 like.xu.linux@gmail.com, peterz@infradead.org, rananta@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <gsnt5xr4eauc.fsf@coltonlewis-kvm.c.googlers.com>
 <17f0f408-459a-4dc2-bad4-c697f782117c@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <17f0f408-459a-4dc2-bad4-c697f782117c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 10/25/2024 3:45 AM, Chen, Zide wrote:
>
> On 9/9/2024 3:11 PM, Colton Lewis wrote:
>> Mingwei Zhang <mizhang@google.com> writes:
>>
>>> From: Kan Liang <kan.liang@linux.intel.com>
>>> Implement switch_interrupt interface for x86 PMU, switch PMI to dedicated
>>> KVM_GUEST_PMI_VECTOR at perf guest enter, and switch PMI back to
>>> NMI at perf guest exit.
>>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>> ---
>>>   arch/x86/events/core.c | 11 +++++++++++
>>>   1 file changed, 11 insertions(+)
>>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>>> index 5bf78cd619bf..b17ef8b6c1a6 100644
>>> --- a/arch/x86/events/core.c
>>> +++ b/arch/x86/events/core.c
>>> @@ -2673,6 +2673,15 @@ static bool x86_pmu_filter(struct pmu *pmu, int
>>> cpu)
>>>       return ret;
>>>   }
>>> +static void x86_pmu_switch_interrupt(bool enter, u32 guest_lvtpc)
>>> +{
>>> +    if (enter)
>>> +        apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
>>> +               (guest_lvtpc & APIC_LVT_MASKED));
>>> +    else
>>> +        apic_write(APIC_LVTPC, APIC_DM_NMI);
>>> +}
>>> +
>> Similar issue I point out in an earlier patch. #define
>> KVM_GUEST_PMI_VECTOR is guarded by CONFIG_KVM but this code is not,
>> which can result in compile errors.
> Since KVM_GUEST_PMI_VECTOR and the interrupt handler are owned by KVM,
> how about to simplify it to:
>
> static void x86_pmu_switch_guest_ctx(bool enter, void *data)
> {
> 	if (enter)
> 		apic_write(APIC_LVTPC, *(u32 *)data);
>         ...
> }
>
> In KVM side:
> perf_guest_enter(whatever_lvtpc_value_it_decides);

Good point. Would address in v4.


>
>
>>>   static struct pmu pmu = {
>>>       .pmu_enable        = x86_pmu_enable,
>>>       .pmu_disable        = x86_pmu_disable,
>>> @@ -2702,6 +2711,8 @@ static struct pmu pmu = {
>>>       .aux_output_match    = x86_pmu_aux_output_match,
>>>       .filter            = x86_pmu_filter,
>>> +
>>> +    .switch_interrupt    = x86_pmu_switch_interrupt,
>>>   };
>>>   void arch_perf_update_userpage(struct perf_event *event,

