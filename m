Return-Path: <kvm+bounces-26196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 910419728BE
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 07:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46B201F251C0
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 05:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8741A166307;
	Tue, 10 Sep 2024 05:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vol1VdKY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DFC153800;
	Tue, 10 Sep 2024 05:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725944458; cv=none; b=PzP2UR/onFe6jbzHPowfq8G+XgEqIRE1I0jA/jga68usk43AmqEicNn3XFL+h3JYzBosxN3cCap1xdOuI7V/CWVmTz6yV2eSUye3p9d/n19o6Rvpz5mVhTClg3vwCPtUv4BhczWs8kh2NU4VCpEVRK/yyjgCti+9r7mVFFhnHiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725944458; c=relaxed/simple;
	bh=WvIaDNSAlvr1QOHZM8SRPaDk4mEfSyRnr1rvahdIpwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hkTRx8D5+mIdXUdpoH6LKawmRG8VNHp07bJkMDz+2ADU+Mlt2pNnuct1FJpxsqqSfC5dqNmbzdnv9jJQSHhm8c8dou0jhkdz7oy3URHAEVKMn3KK5tfuyzW0NDNcc6NftS/eAso6HwUGBGa9aS/bEQFvWsNND3d9pf2q3dgWn80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vol1VdKY; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725944457; x=1757480457;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WvIaDNSAlvr1QOHZM8SRPaDk4mEfSyRnr1rvahdIpwE=;
  b=Vol1VdKYpKfb9MS0/mnTa1UVdHED3KMxPRjXH55EMY63QXCEVwhwMKjd
   w45F+/cmamDsfw+WIya6dVkZSXt+tZijjOdcfXvUeGiDrVprkcwrrHlZr
   zXVJFMksQIGMzJfsJpkpiPj6AzSej0aDD1qDrIsYH3zzY8eNlb5OBuNIG
   98EOyvMRbIavGSlb+mhGbkiW2W2Umskb+6/+o/HL4/xBuewFCBI+tLRhY
   jM0sjukgG2dFWBQYitJumx2zGbC89TgQDEN4OKc9EQTSZM9kzK+hAOQM/
   zI92HX6T5TAMMSD3kI71TfuLIlTvb2i1Uh6LNdvx+M4kSuuFVyNFqjnA2
   w==;
X-CSE-ConnectionGUID: QIzIKBJTRh+hOM+HKg/nUQ==
X-CSE-MsgGUID: 2kUr60r2Qdm6yJhOl8Hcug==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24537564"
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="24537564"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 22:00:57 -0700
X-CSE-ConnectionGUID: /0gdkZzaSgSw8Ch+aG9fPg==
X-CSE-MsgGUID: sqkvnjgxR6+Kj6hU1mGZMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="66853609"
Received: from unknown (HELO [10.238.2.208]) ([10.238.2.208])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 22:00:52 -0700
Message-ID: <8843b93e-72e1-445a-b7ad-c9f186e77f16@linux.intel.com>
Date: Tue, 10 Sep 2024 13:00:49 +0800
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
 kan.liang@intel.com, zhenyuw@linux.intel.com, manali.shukla@amd.com,
 sandipan.das@amd.com, jmattson@google.com, eranian@google.com,
 irogers@google.com, namhyung@kernel.org, gce-passthrou-pmu-dev@google.com,
 samantha.alt@intel.com, zhiyuan.lv@intel.com, yanfei.xu@intel.com,
 like.xu.linux@gmail.com, peterz@infradead.org, rananta@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <gsnt5xr4eauc.fsf@coltonlewis-kvm.c.googlers.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <gsnt5xr4eauc.fsf@coltonlewis-kvm.c.googlers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 9/10/2024 6:11 AM, Colton Lewis wrote:
> Mingwei Zhang <mizhang@google.com> writes:
>
>> From: Kan Liang <kan.liang@linux.intel.com>
>> Implement switch_interrupt interface for x86 PMU, switch PMI to dedicated
>> KVM_GUEST_PMI_VECTOR at perf guest enter, and switch PMI back to
>> NMI at perf guest exit.
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>   arch/x86/events/core.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 5bf78cd619bf..b17ef8b6c1a6 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -2673,6 +2673,15 @@ static bool x86_pmu_filter(struct pmu *pmu, int  
>> cpu)
>>   	return ret;
>>   }
>> +static void x86_pmu_switch_interrupt(bool enter, u32 guest_lvtpc)
>> +{
>> +	if (enter)
>> +		apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
>> +			   (guest_lvtpc & APIC_LVT_MASKED));
>> +	else
>> +		apic_write(APIC_LVTPC, APIC_DM_NMI);
>> +}
>> +
> Similar issue I point out in an earlier patch. #define
> KVM_GUEST_PMI_VECTOR is guarded by CONFIG_KVM but this code is not,
> which can result in compile errors.

Yes, thanks for pointing this.


>
>>   static struct pmu pmu = {
>>   	.pmu_enable		= x86_pmu_enable,
>>   	.pmu_disable		= x86_pmu_disable,
>> @@ -2702,6 +2711,8 @@ static struct pmu pmu = {
>>   	.aux_output_match	= x86_pmu_aux_output_match,
>>   	.filter			= x86_pmu_filter,
>> +
>> +	.switch_interrupt	= x86_pmu_switch_interrupt,
>>   };
>>   void arch_perf_update_userpage(struct perf_event *event,

