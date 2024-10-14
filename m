Return-Path: <kvm+bounces-28787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4360D99D471
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:16:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FE09B27EBA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6C11AF4F6;
	Mon, 14 Oct 2024 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DzW9mbhP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A38EAD5;
	Mon, 14 Oct 2024 16:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728922518; cv=none; b=jdbY5Pugd1Sk/y6L9Ei5OHGP6icVFnHlVxVxBcxDzWpu/m/IamgYZlw4UI+en8JdiuODDKzK/DX95jvpdtkEHm5ExkiNdZUuvapJSiRERjues8QKv9SY4G+dA6iJvA1tF/3sDV8A52GaJGjPytUAFPxGsp7wepINMOGVUMBB+9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728922518; c=relaxed/simple;
	bh=ZgO4XzwdPSrqMsqsQPIQ64+2pkAUqjluJf+D+/tvzFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tSLsaxMSzOZv2BbAEymybKBdpQoUHGQFqqNtsH6gT+zIMgvDBman5HhnHyGD8A76/xbjLtZKd9kwbbIxHmXGm3WUq/PmqLzAN1dqTQtt2YGVEwjbCvYWCTHFifF3yRbIkX8uxqlWOLe3pHDuaVZiy800CDJSxYuDBFqvOUcUiu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DzW9mbhP; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728922517; x=1760458517;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZgO4XzwdPSrqMsqsQPIQ64+2pkAUqjluJf+D+/tvzFQ=;
  b=DzW9mbhPbKhsBVHIJTwdeNMsw2d7Xcvc+BpRrwGotM8XznPtccEeoehD
   7i6p349yQYGby2FqC/HBosyH4B/K0Yxdn6wgpi+5eGKGDI7sR2cU6VcBd
   uFUexdaQYV9BMuNYojJSxoXx2cMCfXGIqw33sjFqM4pNfR+FK6F4VbLUi
   HimpJ5aVy96/DoailYoQ7bZi4vyUM2oKSoZv/K2eFK3DOJ+d6nX8guH1n
   Km7F6zdsewEl0pyYuGQpnNf8zpTalTDLriMd8iaOSD7lNwO5OTU1N5pIp
   xCXAgOcBkZrBB+ZkAmfGE3i/1uxx9VBZcg6brZGEAdQMH1g9Mc8Ja3yqo
   A==;
X-CSE-ConnectionGUID: SBQeeituT9Oiuy+7mQg3jg==
X-CSE-MsgGUID: i3Ay+AlHRumweWf9HPiV+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="31165101"
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="31165101"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 09:15:16 -0700
X-CSE-ConnectionGUID: ZaMsyQ1aQe+0NGRfeUpEcA==
X-CSE-MsgGUID: umtUwMMUSkazasfqmOkSMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="77958700"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 09:15:15 -0700
Received: from [10.212.61.73] (kliang2-mobl1.ccr.corp.intel.com [10.212.61.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 36B8E20B5782;
	Mon, 14 Oct 2024 09:15:13 -0700 (PDT)
Message-ID: <c4d61d85-fb4f-40c4-8400-4a5b907c79a7@linux.intel.com>
Date: Mon, 14 Oct 2024 12:15:11 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
To: Peter Zijlstra <peterz@infradead.org>, Mingwei Zhang <mizhang@google.com>
Cc: Manali Shukla <manali.shukla@amd.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com>
 <1db598cd-328e-4b4d-a147-7030eb697ece@linux.intel.com>
 <3dd7e187-9fbe-4748-9be5-638c8816116e@amd.com>
 <CAL715W+a9p_44CVdXZ6HCS42oUgfam=qYT_XoeN6zxfS16YY8w@mail.gmail.com>
 <20241014115903.GF16066@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241014115903.GF16066@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-10-14 7:59 a.m., Peter Zijlstra wrote:
> On Mon, Sep 23, 2024 at 08:49:17PM +0200, Mingwei Zhang wrote:
> 
>> The original implementation is by design having a terrible performance
>> overhead, ie., every PMU context switch at runtime requires a SRCU
>> lock pair and pmu list traversal. To reduce the overhead, we put
>> "passthrough" pmus in the front of the list and quickly exit the pmu
>> traversal when we just pass the last "passthrough" pmu.
> 
> What was the expensive bit? The SRCU memory barrier or the list
> iteration? How long is that list really?

Both. But I don't think there is any performance data.

The length of the list could vary on different platforms. For a modern
server, there could be hundreds of PMUs from uncore PMUs, CXL PMUs,
IOMMU PMUs, PMUs of accelerator devices and PMUs from all kinds of
devices. The number could keep increasing with more and more devices
supporting the PMU capability.

Two methods were considered.
- One is to add a global variable to track the "passthrough" pmu. The
idea assumes that there is only one "passthrough" pmu that requires the
switch, and the situation will not be changed in the near feature.
So the SRCU memory barrier and the list iteration can be avoided.
It's implemented in the patch

- The other one is always put the "passthrough" pmus in the front of the
list. So the unnecessary list iteration can be avoided. It does nothing
for the SRCU lock pair.

Thanks,
Kan


