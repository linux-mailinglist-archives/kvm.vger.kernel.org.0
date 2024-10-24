Return-Path: <kvm+bounces-29665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF459AF2CD
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 21:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DE521C21A37
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 19:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005C518BB88;
	Thu, 24 Oct 2024 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TEmUWDZ8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D40222B67F;
	Thu, 24 Oct 2024 19:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729799155; cv=none; b=qfwNGqWrXWTWTkwgAWiO2rDayvNlVLEAsev44RzQHncNPxUf9VNV6E1tnnq1JrPC3mmXXeCt2iFIKwaxeeMbX1ZbKUsEIh5iF/U4c2w1HhoRWOKSWSWmjInjElz4HYxWj7KcXmTU89edlzR99J+23w35IEtyUIisYJjqZyqx2hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729799155; c=relaxed/simple;
	bh=bgYitpnN1oSO4rKkV387ujRSJ2DlmrmlLUojI4iSrG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N+ejpKeTXK/fpLXiAsnBZDea9OcOhGv1k7zwW6hHxmZCNA776ehCqSNxkewAATE6CdzCJF/ekIgBEiVR4T6S7U5iL3AF20LH0np2Xy8Bw1bcQDmrCY20Hgu0fCR8Za94oNyHqoLpJPQuMzqVjL2kYmh3flHr2PBYJqvxxRgJ7vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TEmUWDZ8; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729799153; x=1761335153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bgYitpnN1oSO4rKkV387ujRSJ2DlmrmlLUojI4iSrG4=;
  b=TEmUWDZ8VScrUaJY6qwRG22v66isEX8VVjaYpUjpaCWZfvoJnp//NGWN
   luue/GgjpWuIatVT1w4ABvjevW4Oj+wMK8t0O7tvhYgvkkIiHGtAvcc4J
   l3TmhrEu8gYzlK+o007VA7xWJ/RHUm2CgKMgXNXAFuLsY+Q+bFL/MtK2I
   gLJovCBuMtH0c/YpfVRzQ/wM/KsOOldb6QGmNs1XiH5fC/oIWgJtX++Bm
   aBLj5NPQP2eZXb73PXxlsWyLWKk8q4bV7O/jr1SlYSkUt4RUHR24Fmwne
   4PkTEkte0sWurF0bhAaL8nvoGe7Ui/8G5FT20FRL5ScXQrVcO7RI4tZtk
   Q==;
X-CSE-ConnectionGUID: PsOlv0tyRCmom5urIbX+8A==
X-CSE-MsgGUID: jm+mSbIDSli9EI3a8hr+dQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52004894"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52004894"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 12:45:52 -0700
X-CSE-ConnectionGUID: B+GrMAY6RM+2W6ySmP1ISg==
X-CSE-MsgGUID: 3bKxS+7gRk2wCUt2hPSMRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="118161315"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.24.8.117]) ([10.24.8.117])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 12:45:52 -0700
Message-ID: <17f0f408-459a-4dc2-bad4-c697f782117c@intel.com>
Date: Thu, 24 Oct 2024 12:45:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 15/58] perf/x86: Support switch_interrupt interface
To: Colton Lewis <coltonlewis@google.com>, Mingwei Zhang <mizhang@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, xiong.y.zhang@intel.com,
 dapeng1.mi@linux.intel.com, kan.liang@intel.com, zhenyuw@linux.intel.com,
 manali.shukla@amd.com, sandipan.das@amd.com, jmattson@google.com,
 eranian@google.com, irogers@google.com, namhyung@kernel.org,
 gce-passthrou-pmu-dev@google.com, samantha.alt@intel.com,
 zhiyuan.lv@intel.com, yanfei.xu@intel.com, like.xu.linux@gmail.com,
 peterz@infradead.org, rananta@google.com, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <gsnt5xr4eauc.fsf@coltonlewis-kvm.c.googlers.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <gsnt5xr4eauc.fsf@coltonlewis-kvm.c.googlers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/9/2024 3:11 PM, Colton Lewis wrote:
> Mingwei Zhang <mizhang@google.com> writes:
> 
>> From: Kan Liang <kan.liang@linux.intel.com>
> 
>> Implement switch_interrupt interface for x86 PMU, switch PMI to dedicated
>> KVM_GUEST_PMI_VECTOR at perf guest enter, and switch PMI back to
>> NMI at perf guest exit.
> 
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>   arch/x86/events/core.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
> 
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 5bf78cd619bf..b17ef8b6c1a6 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -2673,6 +2673,15 @@ static bool x86_pmu_filter(struct pmu *pmu, int
>> cpu)
>>       return ret;
>>   }
> 
>> +static void x86_pmu_switch_interrupt(bool enter, u32 guest_lvtpc)
>> +{
>> +    if (enter)
>> +        apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
>> +               (guest_lvtpc & APIC_LVT_MASKED));
>> +    else
>> +        apic_write(APIC_LVTPC, APIC_DM_NMI);
>> +}
>> +
> 
> Similar issue I point out in an earlier patch. #define
> KVM_GUEST_PMI_VECTOR is guarded by CONFIG_KVM but this code is not,
> which can result in compile errors.

Since KVM_GUEST_PMI_VECTOR and the interrupt handler are owned by KVM,
how about to simplify it to:

static void x86_pmu_switch_guest_ctx(bool enter, void *data)
{
	if (enter)
		apic_write(APIC_LVTPC, *(u32 *)data);
        ...
}

In KVM side:
perf_guest_enter(whatever_lvtpc_value_it_decides);


>>   static struct pmu pmu = {
>>       .pmu_enable        = x86_pmu_enable,
>>       .pmu_disable        = x86_pmu_disable,
>> @@ -2702,6 +2711,8 @@ static struct pmu pmu = {
>>       .aux_output_match    = x86_pmu_aux_output_match,
> 
>>       .filter            = x86_pmu_filter,
>> +
>> +    .switch_interrupt    = x86_pmu_switch_interrupt,
>>   };
> 
>>   void arch_perf_update_userpage(struct perf_event *event,
> 


