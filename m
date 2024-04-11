Return-Path: <kvm+bounces-14337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B22948A20A4
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 688111F24E08
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA3933062;
	Thu, 11 Apr 2024 21:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PG8P1t86"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED3A524C;
	Thu, 11 Apr 2024 21:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712869499; cv=none; b=oqZ/63y4Xv0RJ8+lvu3XJmdSw6+/87D+qTC84CjNTuv/P3HZvh4F7OmFY3doYm/jDv+D4CCMF4OdVRU3iOnGHGUutYJETzGE5q/V0t6iZx5oQeMYR6rhcdY7wTih6wq3b2FDQt3eOOUBgKN/S3F8+1xa/r52DmFtL9HD8rOaRMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712869499; c=relaxed/simple;
	bh=CGaiRDnTdz5GIe5+v4+BmkyLEBDRNdDaieIGQ/ZwpCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sq/OJv71ouJQZvsfZGrWOvNPNN+HNI/SrozaIeZ6wJnghkwRIRRa0SuE1jiF4ivLfaaZdPD31wqzifHscQh3K1+oVcMdqmdtHLyEiNtlKSAwkt8Xfbmv+kVuNlKi3z7VupT4UkFo3cXRGZIxfZOFi8v7oFJkBlSAX0fJ8sIlPc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PG8P1t86; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712869498; x=1744405498;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CGaiRDnTdz5GIe5+v4+BmkyLEBDRNdDaieIGQ/ZwpCo=;
  b=PG8P1t863MrvyTMepBtNBk4kizsKbPZc/zc8dNBFvOOmVgXayL/aaIJL
   7JZT2Ywei8XNAt3N6l3hz21qNXIssnf6tXWSayJtc+EJxC0t8YPHMsa1/
   Av5W+Pf7TYhb7978s30xfeQ7lF3N7a56h32HkIkj/UHBXNyKZJrWJGz4v
   JCBu9OuzqlUiFzyaXgR++Uys5DO2TR8OGsLtciXh0VwKsYw+B3IhXsHg1
   xbiKh9u1nuU6GrlTLdIRAcgHoydfTH+Db6hk1Nsvv1ht10lRQTSklBQZz
   FEwEQurl7Ws9mthbBK1yG6LeeHOYpRYezatTQEnlgA3PA1VL87uKDRUUk
   w==;
X-CSE-ConnectionGUID: o7Khgz8FTcGXz+ug4hoaxQ==
X-CSE-MsgGUID: YEEzYUn+QCOYCDQpH7L9yA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8475048"
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="8475048"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 14:04:57 -0700
X-CSE-ConnectionGUID: foXovo82Q9St841fCTJc1A==
X-CSE-MsgGUID: vkHBmpNNQBqF/9YZOKKfCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="44309191"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 14:04:57 -0700
Received: from [10.212.101.117] (kliang2-mobl1.ccr.corp.intel.com [10.212.101.117])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 30CC120921DA;
	Thu, 11 Apr 2024 14:04:54 -0700 (PDT)
Message-ID: <f18c309d-f5dd-4b55-a55e-aa77ee334cd9@linux.intel.com>
Date: Thu, 11 Apr 2024 17:04:52 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/41] perf: x86/intel: Support
 PERF_PMU_CAP_VPMU_PASSTHROUGH
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, mizhang@google.com, kan.liang@intel.com,
 zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com,
 samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-2-xiong.y.zhang@linux.intel.com>
 <ZhgYD4B1szpbvlHq@google.com>
 <56a98cae-36c5-40f8-8554-77f9d9c9a1b0@linux.intel.com>
 <CALMp9eRwsyBUHRtjKZDyU6i13hr5tif3ty7tpNjfs=Zq3RA8RA@mail.gmail.com>
 <Zhgh_vQYx2MCzma6@google.com>
 <afb9faeb-11f4-47a2-a77b-4f2496182952@linux.intel.com>
 <ZhhLZFcNhTIidGRy@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZhhLZFcNhTIidGRy@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-04-11 4:43 p.m., Sean Christopherson wrote:
>>> And peeking ahead, IIUC perf effectively _forces_ a passthrough model when
>>> has_vpmu_passthrough_cap() is true, which is wrong.  There needs to be a user/admin
>>> opt-in (or opt-out) to that behavior, at a kernel/perf level, not just at a KVM
>>> level.  Hmm, or is perf relying on KVM to do that right thing?  I.e. relying on
>>> KVM to do perf_guest_{enter,exit}() if and only if the PMU can support the
>>> passthrough model.
>>>
>> Yes, perf relies on KVM to tell if a guest is entering the passthrough mode.
>>
>>> If that's the case, most of the has_vpmu_passthrough_cap() checks are gratiutous
>>> and confusing, e.g. just WARN if KVM (or some other module) tries to trigger a
>>> PMU context switch when it's not supported by perf.
>> If there is only non supported PMUs running in the host, perf wouldn't
>> do any context switch. The guest can feel free to use the core PMU. We
>> should not WARN for this case.
> I'm struggling to wrap my head around this.  If there is no supported PMU in the
> host, how can there be a core PMU for the guest to use?  KVM virtualizes a PMU
> if and only if kvm_init_pmu_capability() reports a compatible PMU, and IIUC that
> reporting is done based on the core PMU.
> 
> Specifically, I want to ensure we don't screw is passing through PMU MSR access,
> e.g. because KVM thinks perf will context switch those MSRs, but perf doesn't

Perf only context switches the MSRs of the PMU with the
PERF_PMU_CAP_VPMU_PASSTHROUGH flag. (Only the core PMU for this RFC).

For other PMUs without the PERF_PMU_CAP_VPMU_PASSTHROUGH, perf does
nothing in perf_guest_enter/exit().

KVM can rely on the flag to decide whether to enable the passthrough
mode for the PMU.

Thanks,
Kan


