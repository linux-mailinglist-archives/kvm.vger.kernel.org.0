Return-Path: <kvm+bounces-11482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCDB87797F
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:25:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E8F1B20C4B
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 01:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6379510F1;
	Mon, 11 Mar 2024 01:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LYetnuqE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4697EC;
	Mon, 11 Mar 2024 01:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710120317; cv=none; b=euHTNs4YHHIhbd9a1lucf41A+UUdYgfrns1KHMjiWcocPAyVdnUpc8YeEDj6PBp3r9rsw5rmRrkE58NsTnnjQX2jp1tKVy7lnBZdKtw1ARAsrgTJlsfVz+u6aL1INMX8pynSqdUO068t6er725inMQpdzN1vXuGLb/UjY5YPgE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710120317; c=relaxed/simple;
	bh=lKxIPfAmhJg5NRvRX6earZY9WOuxFbqKzAFuaNb4zWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f1cebo6PuTqDAC4oiMSEPLrfb29eh3KTwpo51OGMVdwgnEefAR1F0P/Ah8APfiNks0VW0U1hPAzO2VBM1YTwwtNI4zX2qNP+0dbt5yCtccKFQ8jOq5zVKceHlvrAHKP3Rq4XOPvLcq07ZN+30ZiMVnmuln2ELQpUUpPQsIvP1L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LYetnuqE; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710120316; x=1741656316;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lKxIPfAmhJg5NRvRX6earZY9WOuxFbqKzAFuaNb4zWA=;
  b=LYetnuqEoYnP2m5Qj/z03DSUBGdmS07cMo+7K6hKrMj87uvsIGU7FWM2
   hnk6q/3xOmDPLE2YDtq+ARwv0JJrWUOVsie9Y0MrF0sYo9j+eMzhZOdHo
   xR7au5vy+FUTMrp6RL4876jFWvZPDO1LdF+XPrhOeQ3GrxDbeO/NB2XGN
   uID1TGgumdgrUPtKg7tAmDTch7ZCRsMtAM2H9GDnGozyK1D5xpKa+rt7q
   TR1tOGlUPpXht0l+D1oftQATbymWgj0II/wHy7aIst9aisZ/bINi84Fvg
   4nS/K3nFBLWMZ4wDq8BB0wSKRgfWxIoz7VhUXoybFy+oLQAKBUA5OR64A
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="15906520"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="15906520"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:25:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="11102618"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:25:12 -0700
Message-ID: <7baff2e1-0901-4a3a-b43b-06f2de6cb50b@linux.intel.com>
Date: Mon, 11 Mar 2024 09:25:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM: x86/pmu: Globally enable GP counters at "RESET"
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Babu Moger <babu.moger@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>
References: <20240309013641.1413400-1-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240309013641.1413400-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/9/2024 9:36 AM, Sean Christopherson wrote:
> Globally enable GP counters in PERF_GLOBAL_CTRL when refreshing a vCPU's
> PMU to emulate the architecturally defined post-RESET behavior of the MSR.
>
> Extend pmu_counters_test.c to verify the behavior.
>
> Note, this is slightly different than what I "posted" before: it keeps
> PERF_GLOBAL_CTRL '0' if there are no counters.  That's technically not
> what the SDM dictates, but I went with the common sense route of
> interpreting the SDM to mean "globally enable all GP counters".
>
> I figured it was much more likely that the SDM writers didn't think
> about virtual CPUs that can have a PMU without any GP counters, versus
> Intel really wanting to set _all_ bits in PERF_GLOBAL_CTRL :-)
>
> Sean Christopherson (2):
>    KVM: x86/pmu: Set enable bits for GP counters in PERF_GLOBAL_CTRL at
>      "RESET"
>    KVM: selftests: Verify post-RESET value of PERF_GLOBAL_CTRL in PMCs
>      test
>
>   arch/x86/kvm/pmu.c                            | 16 +++++++++++++--
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 20 ++++++++++++++++++-
>   2 files changed, 33 insertions(+), 3 deletions(-)
>
>
> base-commit: 964d0c614c7f71917305a5afdca9178fe8231434

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

Tested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


