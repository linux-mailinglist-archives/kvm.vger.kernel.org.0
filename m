Return-Path: <kvm+bounces-11284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C077874AC0
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 10:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6033A1C21059
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70FE7839F2;
	Thu,  7 Mar 2024 09:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="boJQMT7k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3260582D7C
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 09:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709803379; cv=none; b=LnbaHkNmPLm13XO/V2L8iizQd0DCL/tJGLG07REXxmzq/Z1iESJ0c/73OATpyVcBqd+oNG8FCz4FnT6WvZwivaiFtFPWYGvSkBo1n/9Fm3ekwFqh4XIsZym7yFRxHImopL7GffM+xlpULCrL+LI859KViFTJFChrnskOWpnw1pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709803379; c=relaxed/simple;
	bh=LCm4WDysRJEKroemlCsk0s6wnhOVs+cY4f1+mZ8gHEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gxQubccKN8BsfxivqNsi07CYjj0YzQMfqHJPuifYFipIPxYPN/jtEvKK0992Pvcu+fku9rM1tg7xKKW+Ra/wJ/tu4es48JrAgYOgCxvDXW6atpihf3fXOIJkyrpHa/MvTkHfyrQKuXK1f/S/G/JDky/T1wAUBXT/84npeUIaYGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=boJQMT7k; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709803378; x=1741339378;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LCm4WDysRJEKroemlCsk0s6wnhOVs+cY4f1+mZ8gHEE=;
  b=boJQMT7kCcanGPsSq1ZjAfM2kXdI27Ts2Us0W+lFk+MUO2/5RWTv3GuF
   bBi82OTFzTVUkWci7swXotLL1a6gdWrByCE63BiW7sZcLTT1LLj5BC+Io
   axhO9SWol2AwKkaIR+90CTO0UwirxGty680PXI5v8Qh++hdK3GCJauZaA
   AkCQhApvZW//Lif8mR6F5cRDJiJ16gP3odkdobGFR3V+HNgCU9gfX0RMS
   rZ2h1BQ9tYojmkZztfzoRh2hdBNYyfCFuypI9KBguvGo2U4Xe5CFMewXb
   Qo8IR1uvlNYcSAU/TKiwtGdtpbRPw0mrJMzrzKJCceLCvQVnr5H6XA2ry
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15106533"
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="15106533"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 01:22:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="10479231"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 01:22:55 -0800
Message-ID: <a72a0618-30b3-44c2-b090-a1a14f756662@linux.intel.com>
Date: Thu, 7 Mar 2024 17:22:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/4] x86/pmu: Enable PEBS on fixed counters
 iff baseline PEBS is support
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>,
 Mingwei Zhang <mizhang@google.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240306230153.786365-1-seanjc@google.com>
 <20240306230153.786365-2-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240306230153.786365-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/7/2024 7:01 AM, Sean Christopherson wrote:
> Enabling PEBS for fixed counters is only allowed if "Extended PEBS" is
> supported, and unfortunately "Extended PEBS" is bundled with a pile of
> other PEBS features under the "Baseline" umbrella.  KVM emulates this
> correctly and disallows enabling PEBS on fixed counters if the vCPU
> doesn't have Baseline PEBS support.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   x86/pmu_pebs.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
> index f7b52b90..050617cd 100644
> --- a/x86/pmu_pebs.c
> +++ b/x86/pmu_pebs.c
> @@ -356,13 +356,13 @@ static void check_pebs_counters(u64 pebs_data_cfg)
>   	unsigned int idx;
>   	u64 bitmask = 0;
>   
> -	for (idx = 0; idx < pmu.nr_fixed_counters; idx++)
> +	for (idx = 0; has_baseline && idx < pmu.nr_fixed_counters; idx++)
>   		check_one_counter(FIXED, idx, pebs_data_cfg);
>   
>   	for (idx = 0; idx < max_nr_gp_events; idx++)
>   		check_one_counter(GP, idx, pebs_data_cfg);
>   
> -	for (idx = 0; idx < pmu.nr_fixed_counters; idx++)
> +	for (idx = 0; has_baseline && idx < pmu.nr_fixed_counters; idx++)
>   		bitmask |= BIT_ULL(FIXED_CNT_INDEX + idx);
>   	for (idx = 0; idx < max_nr_gp_events; idx += 2)
>   		bitmask |= BIT_ULL(idx);

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


