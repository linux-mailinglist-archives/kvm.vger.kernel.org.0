Return-Path: <kvm+bounces-58285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 934EDB8BB55
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 02:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CAF31C07EA4
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A745D1F37A1;
	Sat, 20 Sep 2025 00:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lw/o40zC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005452110E;
	Sat, 20 Sep 2025 00:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758329406; cv=none; b=gaQNp/idyv9fYTy9GS4MXsUnpXw9uoyAHsLBJE5HCS9y72DgagYVgU8WVbb9pO6XdZuj8+2u56icN8xEBn6Kys9t/lsctAYMZIyRhDxIqPFaMtGW/0PrlaTUgYzRPWIRQ8p0wJC72vr+fZh99Y6ihzwsLnhwJqKu7N3yhaSUYfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758329406; c=relaxed/simple;
	bh=9xut0kS2Ch4+Rz27BgojyjLrsvYJn7wc+hHLXHbWTvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lJ8zkwP+wn4XkIgvXGzX8V3FqJdfcINwpvVNBPCmrwASIkGx9DESmy3/TSy09b3cb0b+m+ZEHmdlCOWsH+HVxKQM1IrbP5B80b0JBzUrZAAEyBaup1S3CBBB5JYgqMeYQUJLOa05TbJ2ePWxN27CBrYjIXKpwLUkf/Z2bfcAq0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lw/o40zC; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758329406; x=1789865406;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9xut0kS2Ch4+Rz27BgojyjLrsvYJn7wc+hHLXHbWTvM=;
  b=Lw/o40zCYrN8+M6U8leCzNcHHNxmdJIr6nZfAzJAXqzBSHn1Yyhuxvr3
   eBRaNJ5IIp7in5zOtJKfSsY5TlAijanf5UXvyQpvkj+40QXu0OVSentNp
   dgRdKnkVlsN7bamL++V1g9HKw2guNd0+ZRnUXm1d8z07EDpsmj40A3qlR
   d1lQ8FGnVsAy7J/eJoC3bj8D2bYE6bLwtFqzirGFON7VL343DDcvI4XqY
   bgL+tKPfLUxJ3NrU8C8mBHII1KGWMsfJbxxYDj+pboFn4Cx6kbv6Ev/vj
   naYI5r919Voiqve6IOUaAOSZxeVpM8qmQsLtxqL+2qxKVNSQyGHqSRFh6
   A==;
X-CSE-ConnectionGUID: mRX1KdddT5GGseq+7Fw0Wg==
X-CSE-MsgGUID: JOqcGjaNS/WYU/n6fu0fkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60736353"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60736353"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 17:50:05 -0700
X-CSE-ConnectionGUID: HoVAZt0ERKSd1G+LQFWCZA==
X-CSE-MsgGUID: upTihaMJRZKmJrl02HTzFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="175098823"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.233.177]) ([10.124.233.177])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 17:50:03 -0700
Message-ID: <dcb17b1b-a1a3-427c-8b5d-c2e791a3a46f@linux.intel.com>
Date: Sat, 20 Sep 2025 08:50:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] KVM: selftests: PMU fixes for GNR/SRF/CWF
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yi Lai <yi1.lai@intel.com>
References: <20250919214648.1585683-1-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250919214648.1585683-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 9/20/2025 5:46 AM, Sean Christopherson wrote:
> Fix KVM PMU selftests errors encountered on Granite Rapids (GNR),
> Sierra Forest (SRF) and Clearwater Forest (CWF).
>
> The cover letter from v2 has gory details, as do the patches.
>
> v4:
>  - Fix an unavailable_mask goof. [Dapeng]
>  - Fix a bitmask goof (missing BIT_ULL()). [Dapeng]
>
> v3: 
>  - https://lore.kernel.org/all/20250919004512.1359828-1-seanjc@google.com/
>  - Make PMU errata available to all tests by default.
>  - Redo testing of "unavailable PMU events" to drastically reduce the number
>    of testcases.
>
> v2:
>  - https://lore.kernel.org/all/20250718001905.196989-1-dapeng1.mi@linux.intel.com 
>  - Add error fix for vmx_pmu_caps_test on GNR/SRF (patch 2/5).
>  - Opportunistically fix a typo (patch 1/5).
>
> v1: https://lore.kernel.org/all/20250712172522.187414-1-dapeng1.mi@linux.intel.com
>
> Dapeng Mi (2):
>   KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
>   KVM: selftests: Validate more arch-events in pmu_counters_test
>
> Sean Christopherson (2):
>   KVM: selftests: Track unavailable_mask for PMU events as 32-bit value
>   KVM: selftests: Reduce number of "unavailable PMU events" combos
>     tested
>
> dongsheng (1):
>   KVM: selftests: Handle Intel Atom errata that leads to PMU event
>     overcount
>
>  tools/testing/selftests/kvm/include/x86/pmu.h | 26 ++++++++
>  .../selftests/kvm/include/x86/processor.h     |  7 ++-
>  tools/testing/selftests/kvm/lib/x86/pmu.c     | 49 +++++++++++++++
>  .../testing/selftests/kvm/lib/x86/processor.c |  4 ++
>  .../selftests/kvm/x86/pmu_counters_test.c     | 63 +++++++++++++------
>  .../selftests/kvm/x86/pmu_event_filter_test.c |  4 +-
>  .../selftests/kvm/x86/vmx_pmu_caps_test.c     |  3 +-
>  7 files changed, 135 insertions(+), 21 deletions(-)
>
>
> base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4

Test pmu_counters_test/pmu_event_filter_test/vmx_pmu_caps_test on
SPR/GNR/SRF/CWF platforms, no issue is found. Thanks.

Tested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



