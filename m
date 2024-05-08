Return-Path: <kvm+bounces-16958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 269A98BF508
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 05:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6212286262
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 03:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1603114A9F;
	Wed,  8 May 2024 03:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dcSU2C3L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACBD1640B;
	Wed,  8 May 2024 03:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715139862; cv=none; b=dGAmYCFnQOj/PTrvAsfXRFZiSfg4+i/DpuvvVmsp83dieFvqtkaYQUa0guxOVdgBIZ1zB8Furl9aVQalZe+XlZ6gfeDBX9aMB/otWa1ULGfmMQ1yF1tMqfSCZHjykeSyiafaURQnACtJ1cG4WKcULvcd54oqRy3QAUrj6ITeJUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715139862; c=relaxed/simple;
	bh=JgVdHonktQS30RQjdWEhSRIMpyhFhcYjaLJlFogWnKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KF5y2wbHjZfuVY+JHIjVcol66c6z7jpcQVJ4U7OShrc1T9ehFE1a0G1HalpEaVpIJvbXKmhu2jNfMQgImMkYbwtacqZJxzXXZYF+wl4O7xBpJFbYdwbUKJJy9sHA9dnaXJBtFVesJs1bnnQMq0xtq/gxGf4HfsM1ctIcEK62RRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dcSU2C3L; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715139860; x=1746675860;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JgVdHonktQS30RQjdWEhSRIMpyhFhcYjaLJlFogWnKo=;
  b=dcSU2C3LFzGffX4oXphr2TC6H4EZkXSr5Rwf8tvtMTxSZKkJlqXq9+Hj
   XRr83b1W08kyd0COdtqAB9hCX6iu6jVUj2gDJN+y4uEk0xb/s4xCa3ZtQ
   x1P4BkWQgsWN0AVnfNItoaG/i2GZ0WIf6jDWOiL3xFzWIny9WKZY190a5
   TsEiA4/tQwf6jeqhzu5QH8XMmOh9vLaWHXUadODWCyx+QE3qjCnf98DKo
   vdSr1tADbrCHaq0ywpdZR4T9EEqvjjON+LZuev5MeINQx1V6EjoO03ISF
   qAs2BxtpB1+sAShqGo5ewTOW3Qhi9flj1pN7XLJE2oPOf5NVZq6eJJ1vc
   A==;
X-CSE-ConnectionGUID: gwLeiXQ6RlGXcEbNUzqg1Q==
X-CSE-MsgGUID: wAZx6V/kQTOKhRz2aHhRbg==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="22369867"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="22369867"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 20:44:18 -0700
X-CSE-ConnectionGUID: DOfKS6+qRf2BYPrgYcoSkA==
X-CSE-MsgGUID: BB0qfzbsQo+56jUI7x+SQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="33572091"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 20:44:12 -0700
Message-ID: <2c4f53fe-0b6f-4e4c-a99c-f1a28677ebf9@linux.intel.com>
Date: Wed, 8 May 2024 11:44:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/54] perf: x86: Add x86 function to switch PMI
 handler
To: "Chen, Zide" <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-13-mizhang@google.com>
 <f49ebe98-c190-4767-bb0d-471776484fc8@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <f49ebe98-c190-4767-bb0d-471776484fc8@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/8/2024 5:40 AM, Chen, Zide wrote:
>
> On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
>> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>
>> Add x86 specific function to switch PMI handler since passthrough PMU and host
>> PMU use different interrupt vectors.
>>
>> x86_perf_guest_enter() switch PMU vector from NMI to KVM_GUEST_PMI_VECTOR,
>> and guest LVTPC_MASK value should be reflected onto HW to indicate whether
>> guest has cleared LVTPC_MASK or not, so guest lvt_pc is passed as parameter.
>>
>> x86_perf_guest_exit() switch PMU vector from KVM_GUEST_PMI_VECTOR to NMI.
>>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  arch/x86/events/core.c            | 17 +++++++++++++++++
>>  arch/x86/include/asm/perf_event.h |  3 +++
>>  2 files changed, 20 insertions(+)
>>
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 09050641ce5d..8167f2230d3a 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -701,6 +701,23 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
>>  }
>>  EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
>>  
>> +void x86_perf_guest_enter(u32 guest_lvtpc)
>> +{
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
>> +			       (guest_lvtpc & APIC_LVT_MASKED));
> If CONFIG_KVM is not defined, KVM_GUEST_PMI_VECTOR is not available and
> it causes compiling error.
Zide, thanks. If CONFIG_KVM is not defined, these two helpers would not
need to be called, it can be defined as null.

