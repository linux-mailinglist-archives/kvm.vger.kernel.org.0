Return-Path: <kvm+bounces-6813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 003DD83A3E7
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 09:18:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25DAA1C26910
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F6017560;
	Wed, 24 Jan 2024 08:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V41sOhsf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC1B1754B;
	Wed, 24 Jan 2024 08:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706084320; cv=none; b=lGWSakeO6LS+PNfF5d1flskZsVAAp+Ux+xsFOjwKc1mbx64vXssnR4CsCpN57P4us0Yx5joHOVIOTU+yHTcS+xncIpE9EwWNKHzt0DFRHOq/bZKo9npXXJRUDi4QpQURE+AsAVQAMgOdTQwSWTvK8QrSTVMpiUaMZwpyUlTRgGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706084320; c=relaxed/simple;
	bh=qPZmXtvQTm0aCsonLOTgRn0Vg+Gt0aHy3AKi57QVx2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CNXTRNDWsao8HYsgzAV1aM7Mb5rL3XsPCEiuyHUUlZzGFgwf2+HumR0v9awNIGxEHKr15aQAyB0uWUdVZzEb8kVuCGHxBokfgrZN8po1JxJuLzwrm43pCbsJN6epCBDvxj1CVjTdyQI3x4WoLUtuneZnhIKb8UKteOeeMYBeby0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V41sOhsf; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706084320; x=1737620320;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qPZmXtvQTm0aCsonLOTgRn0Vg+Gt0aHy3AKi57QVx2s=;
  b=V41sOhsfA6vX37EXp6wfdeqZOcz1221yd/C8Qz4z27mmmedRoFQd0mj/
   B3UKQWb43/NUrE8C2PxADr76N64698rsqt6VX8h8G91VOwIPEW6Nm2g71
   EgH/O9PDkUZ/LCys0UCs4EBzrgq1lXjh8kVOn2apaetDMwxPfDVUq1THh
   peuu/XSZCSwSKclgqDbQ8d8U8HbkoZaz9CwVl6PsxypxwkAtRPSBNJbxp
   CCyhkQ4jvLJeW/clT1fA3bAPKKszmX5oiAodqu7F4Go0BN2jieAgz6WGv
   IldY3u/UGkS3GZsi01Jqwqp7loaiBQKIbBge4z918a1jeZD5P1oKmLAcg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="8428613"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="8428613"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 00:18:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="20649455"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.25.46]) ([10.93.25.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 00:18:35 -0800
Message-ID: <30d574f8-77d3-4e69-b1c5-6a4d6a083c6f@linux.intel.com>
Date: Wed, 24 Jan 2024 16:18:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 00/11] pmu test bugs fix and
 improvements
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Kindly ping ...

On 1/3/2024 11:13 AM, Dapeng Mi wrote:
> When running pmu test on Sapphire Rapids, we found sometimes pmu test
> reports the following failures.
>
> 1. FAIL: Intel: all counters
> 2. FAIL: Intel: core cycles-0
> 3. FAIL: Intel: llc misses-4
>
> Further investigation shows these failures are all false alarms rather
> than real vPMU issues.
>
> The failure 1 is caused by a bug in check_counters_many() which defines
> a cnt[] array with length 10. On Sapphire Rapids KVM supports 8 GP
> counters and 3 fixed counters, obviously the total counter number (11)
> of Sapphire Rapids exceed current cnt[] length 10, it would cause a out
> of memory access and lead to the "all counters" false alarm. Patch
> 02~03 would fix this issue.
>
> The failure 2 is caused by pipeline and cache warm-up latency.
> Currently "core cycles" is the first executed event. When the measured
> loop() program is executed at the first time, cache hierarchy and pipeline
> are needed to warm up. All these warm-up work consumes so much cycles
> that it exceeds the predefined upper boundary and cause the failure.
> Patch 04 fixes this issue.
>
> The failure 3 is caused by 0 llc misses count. It's possible and
> reasonable that there is no llc misses happened for such simple loop()
> asm blob especially along with larger and larger LLC size on new
> processors. Patch 09 would fix this issue by introducing clflush
> instruction to force LLC miss.
>
> Besides above bug fixes, this patch series also includes several
> optimizations.
>
> One important optimization (patch 07~08) is to move
> GLOBAL_CTRL enabling/disabling into the loop asm blob, so the precise
> count for instructions and branches events can be measured and the
> verification can be done against the precise count instead of the rough
> count range. This improves the verification accuracy.
>
> Another important optimization (patch 10~11) is to leverage IBPB command
> to force to trigger a branch miss, so the lower boundary of branch miss
> event can be set to 1 instead of the ambiguous 0. This eliminates the
> ambiguity brought from 0.
>
> All these changes are tested on Intel Sapphire Rapids server platform
> and the pmu test passes. Since I have no AMD platforms on my hand, these
> changes are not verified on AMD platforms yet. If someone can help to
> verify these changes on AMD platforms, it's welcome and appreciated.
>
> Changes:
>    v2 -> v3:
>          fix "core cycles" failure,
>          introduce precise verification for instructions/branches,
>          leverage IBPB command to optimize branch misses verification,
>          drop v2 introduced slots event verification
>    v1 -> v2:
>          introduce clflush to optimize llc misses verification
>          introduce rdrand to optimize branch misses verification
>
> History:
>    v2: https://lore.kernel.org/lkml/20231031092921.2885109-1-dapeng1.mi@linux.intel.com/
>    v1: https://lore.kernel.org/lkml/20231024075748.1675382-1-dapeng1.mi@linux.intel.com/
>
> Dapeng Mi (10):
>    x86: pmu: Enlarge cnt[] length to 64 in check_counters_many()
>    x86: pmu: Add asserts to warn inconsistent fixed events and counters
>    x86: pmu: Switch instructions and core cycles events sequence
>    x86: pmu: Refine fixed_events[] names
>    x86: pmu: Remove blank line and redundant space
>    x86: pmu: Enable and disable PMCs in loop() asm blob
>    x86: pmu: Improve instruction and branches events verification
>    x86: pmu: Improve LLC misses event verification
>    x86: pmu: Add IBPB indirect jump asm blob
>    x86: pmu: Improve branch misses event verification
>
> Xiong Zhang (1):
>    x86: pmu: Remove duplicate code in pmu_init()
>
>   lib/x86/pmu.c |   5 --
>   x86/pmu.c     | 201 ++++++++++++++++++++++++++++++++++++++++++--------
>   2 files changed, 171 insertions(+), 35 deletions(-)
>

