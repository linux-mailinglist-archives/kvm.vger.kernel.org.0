Return-Path: <kvm+bounces-28783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF84799D42C
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D649CB26A92
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014081AB6CC;
	Mon, 14 Oct 2024 15:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="agurejxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A10231CA4;
	Mon, 14 Oct 2024 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728921074; cv=none; b=eJ170kR/NXMmeV14pC+ESmqtY4qQRG0j9u2QHO+aTHWtXwuzMksuzB3Ak9lZIPP47E5GFbpuwq/jAvRNx8L2YGK9xUnBeRKkJiBRQZN81GPrys4m0t75qcijXtCPpSkF78hMJQMr3rGr5l5c+vG9PSrC70iGOrApK3CPVj89aB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728921074; c=relaxed/simple;
	bh=HhPrxWs1dM37KDlTXC1Ni3YUM5RwkVU2HNXUsmfxu5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JjP4Tl59viwlFrTT8OjOs1bsJlsXv810QCEwkpeaOuug69/4f4dUbnKMuRYlTRFv0EqCAz6O26kVcQmFzdl9hjdnfJkX+PFGWN97ggtFTCIF/FyrqaCvqAtjVah2/086CbpqrR5LExCbw/dsJb4eV/NnkfW2QIsvfIn//0zUIoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=agurejxZ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728921073; x=1760457073;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HhPrxWs1dM37KDlTXC1Ni3YUM5RwkVU2HNXUsmfxu5E=;
  b=agurejxZuzmUi5t8x1cSGmMfec45Q8nqYBXPrMpuIV24donmvrOW2tg5
   IIwLbZ2VyvAF8xuvtafXRngL18IUXbIK/02kEHefg/3Bzhh4bQaSqWn1S
   cSvHR+BizfCy39uwVnbQbiDKYI0gsV4JVJP+WbtZ3xZ5FBePq49OTnCgA
   r+7wB3Qww4elEBEpOKRTLq3nFEWD3NvXMeiWvK95ELuPVjlanPkOgkZyA
   uwsT4ufnDxnQ31JEKLnbj4PsKjln2yVst3pu6xnhoGapwKLX7jF63dcra
   79QXkHOP2HIrVZ4dwEGrhaIHGgOqj+zQlOHk9Z+i6KSeTLNVEofms9ncU
   g==;
X-CSE-ConnectionGUID: UW/3P7d+QfWAg/xzyPgf8w==
X-CSE-MsgGUID: +JrwazQuR7mKVN3qu5Tivw==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="39654866"
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="39654866"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:51:12 -0700
X-CSE-ConnectionGUID: +S79P0jnToaF+FpQ6U3LTw==
X-CSE-MsgGUID: bCQJkcYlT5+XLGw44IexsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="82651019"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:51:11 -0700
Received: from [10.212.61.73] (kliang2-mobl1.ccr.corp.intel.com [10.212.61.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 5751D20B5782;
	Mon, 14 Oct 2024 08:51:08 -0700 (PDT)
Message-ID: <3cc05609-4fbd-4fb8-87bf-34ea1092ab2b@linux.intel.com>
Date: Mon, 14 Oct 2024 11:51:06 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
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
 Like Xu <like.xu.linux@gmail.com>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <20241014120354.GG16066@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241014120354.GG16066@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-10-14 8:03 a.m., Peter Zijlstra wrote:
> On Thu, Aug 01, 2024 at 04:58:23AM +0000, Mingwei Zhang wrote:
>> From: Kan Liang <kan.liang@linux.intel.com>
>>
>> There will be a dedicated interrupt vector for guests on some platforms,
>> e.g., Intel. Add an interface to switch the interrupt vector while
>> entering/exiting a guest.
>>
>> When PMI switch into a new guest vector, guest_lvtpc value need to be
>> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
>> bit should be cleared also, then PMI can be generated continuously
>> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
>> and switch_interrupt().
>>
>> At switch_interrupt(), the target pmu with PASSTHROUGH cap should
>> be found. Since only one passthrough pmu is supported, we keep the
>> implementation simply by tracking the pmu as a global variable.
>>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>>
>> [Simplify the commit with removal of srcu lock/unlock since only one pmu is
>> supported.]
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  include/linux/perf_event.h |  9 +++++++--
>>  kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
>>  2 files changed, 41 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index 75773f9890cc..aeb08f78f539 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -541,6 +541,11 @@ struct pmu {
>>  	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
>>  	 */
>>  	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
>> +
>> +	/*
>> +	 * Switch the interrupt vectors, e.g., guest enter/exit.
>> +	 */
>> +	void (*switch_interrupt)	(bool enter, u32 guest_lvtpc); /* optional */
>>  };
> 
> I'm thinking the guets_lvtpc argument shouldn't be part of the
> interface. That should be PMU implementation data and accessed by the
> method implementation.

I think the name of the perf_switch_interrupt() is too specific.
Here should be to switch the guest context. The interrupt should be just
part of the context. Maybe a interface as below

void (*switch_guest_ctx)	(bool enter, void *data); /* optional */

Thanks,
Kan

