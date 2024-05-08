Return-Path: <kvm+bounces-16976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B60BC8BF6A8
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41FEAB21BB3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E74225D9;
	Wed,  8 May 2024 06:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K/Wq4DiB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904611A2C15;
	Wed,  8 May 2024 06:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715151521; cv=none; b=HRVtcIN7bk3JVXjS3VFDiOJNubBX/W+1RBv5BenMsu6U1MkteIwVVzHnasAyjYGIDXYajMd7wmfUNFSFMnKXXMe5NCyir1qkfWzWcpS9WYnDNEY2dLv98rtoTXPvlUEVpFIivV4mS9p/XCu2XHyPdGaUDTimX8+SQYUZPK1Gdu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715151521; c=relaxed/simple;
	bh=02pfMD/+H0cvQ+j9wplpH/CkaJ7KgYPMc+AIc8kLhhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ow7WNC5bqT3pzU7OObQwNuF88P7yQ78vwubrBqtsIUaPkfaUE6FSBSPN4OaXx6HEPXinQ0c+axcbsODXB1NHNGxLpguAIkr692ZTSiaTNeM3m0kG28MtW5a5AX5KpslVU9OdSY33WMxddNcRQSTzMfV47m3yFjj+9XcgYFlU/pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K/Wq4DiB; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715151519; x=1746687519;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=02pfMD/+H0cvQ+j9wplpH/CkaJ7KgYPMc+AIc8kLhhk=;
  b=K/Wq4DiBtZCotJ+QiNHPMOudeoJImXO8eDeFRDLPaa5Nrwc00IkM/wAt
   BCaa3UkPVAsqDnSjK6StGRh4BFxLFFRx+8Wc80U5eMyXRy5e7tzmeemNH
   vni4cNY9/3XzSPvGWyJFy9bD+PiPMx23nh6wQJ9jEYoHM9p1ryyFAy4RF
   3zqM4JqGTbTRu/lSVDZH+yr1NxIH9+iamGo9gN1zZuRxAHh3IoYt4LxpZ
   EruwrjJShdzEJLtqiyHmXJx1wPMQ69nfLYcRFVDFIESmZHHDPFlHToYKu
   /QxTqeOo2KTAU6HdQ5ns4p0tpeKxzkqU+SpqqsTCiqys6QNZY8VwM2LBR
   g==;
X-CSE-ConnectionGUID: cfAc+qvtTGGpOIeQh2NVBA==
X-CSE-MsgGUID: Tem6lO/ATnyuIjhaMsbA0Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="22144486"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="22144486"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 23:58:39 -0700
X-CSE-ConnectionGUID: 0BkwCdbAQFyPZLF6xV6Bvg==
X-CSE-MsgGUID: R0sjFcOkSfSkgaWarwRK7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="28760747"
Received: from tiesheng-mobl.ccr.corp.intel.com (HELO [10.124.225.233]) ([10.124.225.233])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 23:58:34 -0700
Message-ID: <34245468-00fc-49aa-951e-d7d786084d08@linux.intel.com>
Date: Wed, 8 May 2024 14:58:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/54] perf: x86: Add x86 function to switch PMI
 handler
To: Peter Zijlstra <peterz@infradead.org>, Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-13-mizhang@google.com>
 <20240507092241.GV40213@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <20240507092241.GV40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/7/2024 5:22 PM, Peter Zijlstra wrote:
> On Mon, May 06, 2024 at 05:29:37AM +0000, Mingwei Zhang wrote:
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
>> +}
>> +EXPORT_SYMBOL_GPL(x86_perf_guest_enter);
>> +
>> +void x86_perf_guest_exit(void)
>> +{
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
>> +}
>> +EXPORT_SYMBOL_GPL(x86_perf_guest_exit);
> 
> Urgghh... because it makes sense for this bare APIC write to be exported
> ?!?
Usually KVM doesn't access HW except vmx directly and requests other
components to access HW to avoid confliction, APIC_LVTPC is managed by x86
perf driver, so I added two functions here and exported them.
> 
> Can't this at the very least be hard tied to perf_guest_{enter,exit}() ?
> perf_guest_{enter, exit} is called from this function in another commit, I
should merge that commit into this one according to your suggestion in
other email.

thanks

