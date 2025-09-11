Return-Path: <kvm+bounces-57272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 012A4B5263B
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 04:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC02E467671
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 01:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B022264B7;
	Thu, 11 Sep 2025 01:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QQsdD+Ls"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3E52AE97;
	Thu, 11 Sep 2025 01:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757555991; cv=none; b=QgqguR9ZkArKeHFwFFSQsrRNT1/aYzhvoYPIjkz7M7XzMZXp1+McUQCMRUQ+le24RfBsIFjMgayUDr/OfusIAX/WotD3M5gIoGvcckCvPvXYjYSYWdbzyl2qHq83udQfbLXMcGVSOHLdb1gRm9Niwtdbffw65xvwIoRM9hsUNiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757555991; c=relaxed/simple;
	bh=KyiWWusl6tfeztniB0AZif+vqEt76oXXpSYaVJzI8L4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7Izxtu1hV67Fk+UUmYouiBtwPgm3oiNPOpWUfNmcGf+XI3PAWsODlab67GXID3LOqrJQATwFW7zVDi03ln51ELUjSg25T6GlC7lwrMcJ8TT23fgbTokQnmgGfFWd8kKSSzMYC6SRjDOdPVYemCsRUm9sga4V9B2ot/qlscNHjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QQsdD+Ls; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757555990; x=1789091990;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KyiWWusl6tfeztniB0AZif+vqEt76oXXpSYaVJzI8L4=;
  b=QQsdD+LsDav36i+as+jyLfxzaEnWIPd1aBlU/9cHSZ25nEcAfKL/GKnn
   rnPZO3F6DYDLivXR/cXsVwek9e+LIfCT6+7BFMP7u+nncYOtnH2VL5fid
   8anZj2ObZ+qI9nC5rw/lnYStFzgWkDfsPMB4Gl5O/p4iVte3E0GAP89MF
   kvmeIx1DIQm9GWgAnRIBjYm6CHJ5plJ3bhsEKNzgtPPxm4N2HwKvaq1F6
   SESCiYe/exc+mp05YXII/DTM16bvrn1vKeoaJ8FKZgz1m7uvCl3z+RF11
   pn+Cg2p+wDDEVLuiJxueh0NOw7wmKV1P9yXQ5vYmmhRdRPs+uIr0scwMV
   A==;
X-CSE-ConnectionGUID: h4CbcyYLQZGzCLSi8cJaiA==
X-CSE-MsgGUID: lMurCmsoRO6FafRHjvOO1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="59988228"
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="59988228"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 18:59:49 -0700
X-CSE-ConnectionGUID: Rewa4N0ES4ik5nKmGrTfYQ==
X-CSE-MsgGUID: DaBgleRnQNqnHcQarRW76g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="173943852"
Received: from unknown (HELO [10.238.3.254]) ([10.238.3.254])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 18:59:46 -0700
Message-ID: <5cf9e53c-2d64-440c-b08b-73962f91056a@linux.intel.com>
Date: Thu, 11 Sep 2025 09:59:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Fix PMU kselftests errors on GNR/SRF/CWF
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Zide Chen <zide.chen@intel.com>,
 Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
 <aMIQ6vxYuHA2jVuN@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aMIQ6vxYuHA2jVuN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 9/11/2025 7:59 AM, Sean Christopherson wrote:
> On Fri, Jul 18, 2025, Dapeng Mi wrote:
>> This patch series fixes KVM PMU kselftests errors encountered on Granite
>> Rapids (GNR), Sierra Forest (SRF) and Clearwater Forest (CWF).
>>
>> GNR and SRF starts to support the timed PEBS. Timed PEBS adds a new
>> "retired latency" field in basic info group to show the timing info and
>> the PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
>> to indicated whether timed PEBS is supported. KVM module doesn't need to
>> do any specific change to support timed PEBS except a perf change adding
>> PERF_CAP_PEBS_TIMING_INFO flag into PERF_CAP_PEBS_MASK[1]. The patch 2/5
>> adds timed PEBS support in vmx_pmu_caps_test and fix the error as the
>> PEBS caps field mismatch.
>>
>> CWF introduces 5 new architectural events (4 level-1 topdown metrics
>> events and LBR inserts event). The patch 3/5 adds support for these 5
>> arch-events and fixes the error that caused by mismatch between HW real
>> supported arch-events number with NR_INTEL_ARCH_EVENTS.
>>
>> On Intel Atom platforms, the PMU events "Instruction Retired" or
>> "Branch Instruction Retired" may be overcounted for some certain
>> instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
>> and complex SGX/SMX/CSTATE instructions/flows[2].
>>
>> In details, for the Atom platforms before Sierra Forest (including
>> Sierra Forest), Both 2 events "Instruction Retired" and
>> "Branch Instruction Retired" would be overcounted on these certain
>> instructions, but for Clearwater Forest only "Instruction Retired" event
>> is overcounted on these instructions.
>>
>> As this overcount issue, pmu_counters_test and pmu_event_filter_test
>> would fail on the precise event count validation for these 2 events on
>> Atom platforms.
>>
>> To work around this Atom platform overcount issue, Patches 4-5/5 looses
>> the precise count validation separately for pmu_counters_test and
>> pmu_event_filter_test.
>>
>> BTW, this patch series doesn't depend on the mediated vPMU support.
>>
>> Changes:
>>   * Add error fix for vmx_pmu_caps_test on GNR/SRF (patch 2/5).
>>   * Opportunistically fix a typo (patch 1/5).
>>
>> Tests:
>>   * PMU kselftests (pmu_counters_test/pmu_event_filter_test/
>>     vmx_pmu_caps_test) passed on Intel SPR/GNR/SRF/CWF platforms.
>>
>> History:
>>   * v1: https://lore.kernel.org/all/20250712172522.187414-1-dapeng1.mi@linux.intel.com/
>>
>> Ref:
>>   [1] https://lore.kernel.org/all/20250717090302.11316-1-dapeng1.mi@linux.intel.com/
>>   [2] https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details
>>
>> Dapeng Mi (4):
>>   KVM: x86/pmu: Correct typo "_COUTNERS" to "_COUNTERS"
>>   KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
>>   KVM: Selftests: Validate more arch-events in pmu_counters_test
>>   KVM: selftests: Relax branches event count check for event_filter test
>>
>> dongsheng (1):
>>   KVM: selftests: Relax precise event count validation as overcount
>>     issue
> Overall looks good, I just want to take a more infrastructure-oriented approach
> for the errata.  I'll post a v3 tomorrow.  All coding is done and the tests pass,
> but I want to take a second look with fresh eyes before posting it :-)

Thanks! :-)


>

