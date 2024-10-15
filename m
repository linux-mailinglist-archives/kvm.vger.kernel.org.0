Return-Path: <kvm+bounces-28893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3A299ED60
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D94A1F25024
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 13:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525261B21BA;
	Tue, 15 Oct 2024 13:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="labYjZUX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ED61B2181;
	Tue, 15 Oct 2024 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998591; cv=none; b=cGRYvd/4HhRABpWnGOSABHQBuhfy43jaqJJ3SWBtzYFgQSDGRDDC/A3Yr6mCac5SzSY7VzGvvkdm0EYq1RycuDblILIDvqLH9+pHOm4C29JNe2sY3g0NYmgPGKHNEonJ4TzmlZvIz4UCeO6e9Ii0pmww8T1WfLwxb9k5vJvq14M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998591; c=relaxed/simple;
	bh=HwZG0ynlovbLC0YjioshrHqux1oDWiaxe6IYxIZAeZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SuUmp1jFgT0Z1hlXjVN8HgSDURL/CFgHI5+Sj3aDFQ0/2CV7o+jiRKHkKue34uYJf8/w8pacDjUhtjz37BM2NEe6TwKeTABGmJpZHsLFzK1JnRjCkrm4vRn7N+Fc3r7xJyMTngxOi0JPW9WrD1w4UJtYkaoIPHLg0FawSuzVr+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=labYjZUX; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728998590; x=1760534590;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HwZG0ynlovbLC0YjioshrHqux1oDWiaxe6IYxIZAeZQ=;
  b=labYjZUXujV971wBs/E0/zM4J/GjQ4F4STcj84ptebwx8NW0wcK9Z081
   7S7nbbfjKBvY/ciXfOedUSn01nxHa8s2PbJLmIRHAdZIsmRB3PMhFw+P+
   Emww3UYomKqSUUpIYqRuWRyvrUVdEKYaesd9hRJwcKmp8WJDZ4ajGJxAD
   Oh7Uu8sczjIIovRgWix8AgC+tc3y95/9c2NYmarV+FDxadP1mifSX1LGo
   mXVALKefuOacccstxjoMOdlhUs1rV0H+8Dv7m7+ZzigwzsYCQ0PWF6np0
   9Hx1lBEmbmV0U/CEVXRdPB8P91fr6k3JWKGlxlFitoJnzFubWa4pbj58Q
   Q==;
X-CSE-ConnectionGUID: c8YtOIsDRUWl0fI0ZaSzdQ==
X-CSE-MsgGUID: MtX9whZQSZS2gu3XlgDglA==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="27872579"
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="27872579"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 06:23:09 -0700
X-CSE-ConnectionGUID: hjg30QUFRZ6Ixw4g5soS5g==
X-CSE-MsgGUID: hoeIldPMQY6kMZQKUXwk8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="82457053"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 06:23:09 -0700
Received: from [10.212.125.233] (kliang2-mobl1.ccr.corp.intel.com [10.212.125.233])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 0322520CFEDE;
	Tue, 15 Oct 2024 06:23:05 -0700 (PDT)
Message-ID: <411cce4d-593e-4643-8c5c-d6a34cde0e54@linux.intel.com>
Date: Tue, 15 Oct 2024 09:23:04 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <20241014120354.GG16066@noisy.programming.kicks-ass.net>
 <3cc05609-4fbd-4fb8-87bf-34ea1092ab2b@linux.intel.com>
 <20241014174929.GL16066@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241014174929.GL16066@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-10-14 1:49 p.m., Peter Zijlstra wrote:
> On Mon, Oct 14, 2024 at 11:51:06AM -0400, Liang, Kan wrote:
>> On 2024-10-14 8:03 a.m., Peter Zijlstra wrote:
>>> On Thu, Aug 01, 2024 at 04:58:23AM +0000, Mingwei Zhang wrote:
>>>> From: Kan Liang <kan.liang@linux.intel.com>
>>>>
>>>> There will be a dedicated interrupt vector for guests on some platforms,
>>>> e.g., Intel. Add an interface to switch the interrupt vector while
>>>> entering/exiting a guest.
>>>>
>>>> When PMI switch into a new guest vector, guest_lvtpc value need to be
>>>> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
>>>> bit should be cleared also, then PMI can be generated continuously
>>>> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
>>>> and switch_interrupt().
>>>>
>>>> At switch_interrupt(), the target pmu with PASSTHROUGH cap should
>>>> be found. Since only one passthrough pmu is supported, we keep the
>>>> implementation simply by tracking the pmu as a global variable.
>>>>
>>>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>>>>
>>>> [Simplify the commit with removal of srcu lock/unlock since only one pmu is
>>>> supported.]
>>>>
>>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>>> ---
>>>>  include/linux/perf_event.h |  9 +++++++--
>>>>  kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
>>>>  2 files changed, 41 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>>>> index 75773f9890cc..aeb08f78f539 100644
>>>> --- a/include/linux/perf_event.h
>>>> +++ b/include/linux/perf_event.h
>>>> @@ -541,6 +541,11 @@ struct pmu {
>>>>  	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
>>>>  	 */
>>>>  	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
>>>> +
>>>> +	/*
>>>> +	 * Switch the interrupt vectors, e.g., guest enter/exit.
>>>> +	 */
>>>> +	void (*switch_interrupt)	(bool enter, u32 guest_lvtpc); /* optional */
>>>>  };
>>>
>>> I'm thinking the guets_lvtpc argument shouldn't be part of the
>>> interface. That should be PMU implementation data and accessed by the
>>> method implementation.
>>
>> I think the name of the perf_switch_interrupt() is too specific.
>> Here should be to switch the guest context. The interrupt should be just
>> part of the context. Maybe a interface as below
>>
>> void (*switch_guest_ctx)	(bool enter, void *data); /* optional */
> 
> I don't think you even need the data thing. For example, the x86/intel
> implementation can just look at a x86_pmu data field to find the magic
> value.

The new vector is created by KVM, not perf. So it cannot be found in the
x86_pmu data field. Perf needs it to update the interrupt vector so the
guest PMI can be handled by KVM directly.

Thanks,
Kan


