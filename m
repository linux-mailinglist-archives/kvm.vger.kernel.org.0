Return-Path: <kvm+bounces-16960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C6E8BF52F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 496BF1C2307E
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 04:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5658915E97;
	Wed,  8 May 2024 04:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IPBXrH9v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1774414AB0;
	Wed,  8 May 2024 04:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715141622; cv=none; b=QzZbMbwtWRaqeJX6EA2TU9PsGCI58/etGTEwGtvvDFNXS6iXEvkSXBJRl4NwyXfBjQX4Z0jqvAA89BK705RMJ4FH9j3RN1Eh6rrvT2jCpupTqcEpfvXXmtKrQQ3r4gQ+1HXlGqFYn+PPlQCveiPzkubiiHQSeOriJFI1uNyuY34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715141622; c=relaxed/simple;
	bh=OgJthl6HgWnetgotb6UpXcBcQvXfygk3MsKoVyeTLz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u7dvcHmzorTV+PUXzGvzNiUniEY0vqlofhbCRgw4q69oK9WSP6o7NhcFV+VYKOprz2YyfMmI/zq8Bd0AoGbztv2Rus2Pczez6sn6HT9I8WLrwgR+QAyGEzmJY0dWV+hnZ16Q5xngSNWI4IcJIE9z6YXu+aIYI/gEjTNqTr65U4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IPBXrH9v; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715141621; x=1746677621;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OgJthl6HgWnetgotb6UpXcBcQvXfygk3MsKoVyeTLz4=;
  b=IPBXrH9vOqmYr5VmK1olRU0Yu6rJh+VbK0O0kgemsaNX0NUEkqxrzF6Z
   aoYeW8TYHgl9SRVUEPjD56lKANK7JPoHgU2LiJ9wILi3LOrGj6RG9qOaD
   tsJReA1Uec/u3I/7PdGJV6PzSTUNnA0z7Na9NzDhfN9TeAMqkTC1KH6OC
   UkynQf8bT2ckPsSCQkAy2K7iCK9v9RG2oPH6jZIWksmA+vVVCcH8HYN67
   /889i7WWSmhJKJKTiAEepxpxK6SrmpWkJjPTIeXjDOhz9HUbN3gDrJVkx
   D8slkr3FRta1Z9sio9jHL5jBTG5L/DPPfCJkKyODswE7OPk3+8YZj35/K
   A==;
X-CSE-ConnectionGUID: xlxbeo89R3+2kvwzoQoKww==
X-CSE-MsgGUID: zgnFIKUmSeyGMEuQNSsxxQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11191569"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11191569"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 21:13:40 -0700
X-CSE-ConnectionGUID: 2S92u2dNRt6j/QJOmb3u2w==
X-CSE-MsgGUID: NkXsqHoYROOi+CJ+LCXZXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="51952598"
Received: from tiesheng-mobl.ccr.corp.intel.com (HELO [10.124.225.233]) ([10.124.225.233])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 21:13:35 -0700
Message-ID: <077000e5-960c-462d-bbf7-156b4420ccd9@linux.intel.com>
Date: Wed, 8 May 2024 12:13:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/54] perf: Support get/put passthrough PMU interfaces
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
 <20240506053020.3911940-7-mizhang@google.com>
 <20240507083133.GQ40213@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <20240507083133.GQ40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/7/2024 4:31 PM, Peter Zijlstra wrote:
> On Mon, May 06, 2024 at 05:29:31AM +0000, Mingwei Zhang wrote:
> 
> 
>> +int perf_get_mediated_pmu(void)
>> +{
>> +	int ret = 0;
>> +
>> +	mutex_lock(&perf_mediated_pmu_mutex);
>> +	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
>> +		goto end;
>> +
>> +	if (atomic_read(&nr_include_guest_events)) {
>> +		ret = -EBUSY;
>> +		goto end;
>> +	}
>> +	refcount_set(&nr_mediated_pmu_vms, 1);
>> +end:
>> +	mutex_unlock(&perf_mediated_pmu_mutex);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(perf_get_mediated_pmu);
> 
> Blergh... it seems I never got my perf guard patches merged :/, but
> could we please write this like:
> 
> int perf_get_mediated_pmu(void)
> {
> 	guard(mutex)(&perf_mediated_pmu_mutex);
> 	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
> 		return 0;
> 
> 	if (atomic_read(&nr_include_guest_events))
> 		return -EBUSY;
> 
> 	refcount_set(&nr_mediated_pmu_vms, 1);
> 	return 0;
> }
> 
> And avoid adding more unlock goto thingies?
>yes, this works. And code is cleaner.

thanks


