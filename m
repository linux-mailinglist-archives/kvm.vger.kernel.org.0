Return-Path: <kvm+bounces-14317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4D68A1F46
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C2331C232F6
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA8117589;
	Thu, 11 Apr 2024 19:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L6PcVKKu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C494E205E35;
	Thu, 11 Apr 2024 19:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712862819; cv=none; b=udGSDK/O59Zte98so3RYKUUOaBGGOdSuGoytHPMCLIAqJ5rTa1Yb7P8l17JA9da/IOg7KJg3hUJixdo2EAeXAYymQ3JjCfXy32Ms0KsUZqr4c+DRmvFAEXm55HJ1ctwB3YVq42Jlt8fCrThRQpy7E1nzCfrXOpBtmDmcyVALvoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712862819; c=relaxed/simple;
	bh=y/sxAUKba/Hnba4JIkCZAyUn5XTGgZOqDRvmcUEs3AM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YPTklrnl6JW4n+sR5px98tc7IoYQ1OVhGNtbbi1fB24c/UE+qetOJCVhhZB/3T80CYIHSBszPRq3URgqxBdK+WTFO19cQiCkk4pvPOrWNdbDf59zyMZughr7ITywW1hT6J5Iiq6GIoI4WH/Jj/GNPvmwbja01VBDpGyehx+7Ya8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L6PcVKKu; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712862818; x=1744398818;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y/sxAUKba/Hnba4JIkCZAyUn5XTGgZOqDRvmcUEs3AM=;
  b=L6PcVKKu1qgLGV5V5G6NmrNrwlcgr7kWGICbq5ZckDx3vrzWEhIHS+r5
   FnBSmoZ6rf0e4Cps/LdBdUKB9682vpGjkeDPEd7XZFT4tS520WG84WqnE
   PgdQs3lRZkeHCl+qubgkY/lVW0sK0UnavAst2wMGQPrFgn71xZ85/djfR
   bAcZcF+cAjpG35Fa8Z7XBE5XEPkMJE7Y4wyJjbHS5i8W+aO54P2T2SOrb
   pSP9KjdDV1qrSIh4VoDLwtZY1qDpAbg/R8uAMI6tNoUZdg+pfX+YFWE87
   mcHP628l/DGfmqvahO/vhvH0zSw32mT+J8BqP85qpLtkjqJxnEdILMwHM
   Q==;
X-CSE-ConnectionGUID: sAxog+V6SrCJe89ytW7sSw==
X-CSE-MsgGUID: wKuhlz+xSMCmJs54yjprNg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="30778808"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="30778808"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 12:13:38 -0700
X-CSE-ConnectionGUID: suaKhH8KTgmdkZ7h/3pCKw==
X-CSE-MsgGUID: 506CiWWGTwCdIg+oQFTZVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25794323"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 12:13:37 -0700
Received: from [10.212.101.117] (kliang2-mobl1.ccr.corp.intel.com [10.212.101.117])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 091C920921DA;
	Thu, 11 Apr 2024 12:13:34 -0700 (PDT)
Message-ID: <afb9faeb-11f4-47a2-a77b-4f2496182952@linux.intel.com>
Date: Thu, 11 Apr 2024 15:13:33 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/41] perf: x86/intel: Support
 PERF_PMU_CAP_VPMU_PASSTHROUGH
To: Sean Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
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
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <Zhgh_vQYx2MCzma6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2024-04-11 1:46 p.m., Sean Christopherson wrote:
> On Thu, Apr 11, 2024, Jim Mattson wrote:
>> On Thu, Apr 11, 2024 at 10:21 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>> On 2024-04-11 1:04 p.m., Sean Christopherson wrote:
>>>> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>>>>> From: Kan Liang <kan.liang@linux.intel.com>
>>>>>
>>>>> Define and apply the PERF_PMU_CAP_VPMU_PASSTHROUGH flag for the version 4
>>>>> and later PMUs
>>>>
>>>> Why?  I get that is an RFC, but it's not at all obvious to me why this needs to
>>>> take a dependency on v4+.
>>>
>>> The IA32_PERF_GLOBAL_STATUS_RESET/SET MSRs are introduced in v4. They
>>> are used in the save/restore of PMU state. Please see PATCH 23/41.
>>> So it's limited to v4+ for now.
>>
>> Prior to version 4, semi-passthrough is possible, but IA32_PERF_GLOBAL_STATUS
>> has to be intercepted and emulated, since it is non-trivial to set bits in
>> this MSR.
> 
> Ah, then this _perf_ capability should be PERF_PMU_CAP_WRITABLE_GLOBAL_STATUS or
> so, especially since it's introduced in advance of the KVM side of things.  Then
> whether or not to support a mediated PMU becomes a KVM decision, e.g. intercepting
> accesses to IA32_PERF_GLOBAL_STATUS doesn't seem like a complete deal breaker
> (or maybe it is, I now see the comment about it being used to do the context switch).

The PERF_PMU_CAP_VPMU_PASSTHROUGH is to indicate whether the PMU has the
capability to support passthrough mode. It's used to distinguish the
other PMUs, e.g., uncore PMU. It's just because the current RFC utilizes
the IA32_PERF_GLOBAL_STATUS_RESET/SET MSRs, I have to limit it to V4+.

I agree that it should be a KVM decision, not perf. The v4 check should
be removed.

Regarding the PERF_PMU_CAP_WRITABLE_GLOBAL_STATUS, I think perf already
passes the x86_pmu.version to KVM. Maybe KVM can add an internal flag to
track it, so a PERF_PMU_CAP_ bit can be saved?

> 
> And peeking ahead, IIUC perf effectively _forces_ a passthrough model when
> has_vpmu_passthrough_cap() is true, which is wrong.  There needs to be a user/admin
> opt-in (or opt-out) to that behavior, at a kernel/perf level, not just at a KVM
> level.  Hmm, or is perf relying on KVM to do that right thing?  I.e. relying on
> KVM to do perf_guest_{enter,exit}() if and only if the PMU can support the
> passthrough model.
>

Yes, perf relies on KVM to tell if a guest is entering the passthrough mode.

> If that's the case, most of the has_vpmu_passthrough_cap() checks are gratiutous
> and confusing, e.g. just WARN if KVM (or some other module) tries to trigger a
> PMU context switch when it's not supported by perf.

If there is only non supported PMUs running in the host, perf wouldn't
do any context switch. The guest can feel free to use the core PMU. We
should not WARN for this case.

Thanks,
Kan

