Return-Path: <kvm+bounces-54089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7E9B1C156
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 254F218C056B
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 07:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643D721B199;
	Wed,  6 Aug 2025 07:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCmrCwh2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B72C204583;
	Wed,  6 Aug 2025 07:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754465439; cv=none; b=kjtUkwzKTGTykoKZzJCRGDkux4dyzLnyOWJqMCufKsWEWJ5Y97jVF2ALzxAbOa39Mwny9p0pxjH8/fo/e5X5mpflwYCxo7cmStff629Mf5dBMSKfHwiYMW+Ayzr1deMf3RMJ29xL02FZ0Z8kqg1aqZrnqgbymSmFd62miJVL2d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754465439; c=relaxed/simple;
	bh=euCZIlasW5DVhSnPXfTN27QdzYcetqKGnl1AdxhlSqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SQ56PKL8zEE2sudmoTjs1bktr/eOBKhBrVC/ZzCTvHzHc3yZP5Co5chaLiS+JCLwf8SIGUfhrZJGoPG9zCy9d2JQ9iu6H4O1n+z+imauRSzLxIF5sy6ILBmopnCTZnm6+LgiPbRB3EgR4CaSozup05pxnibCj5BrAAuiqWZBpBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCmrCwh2; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754465438; x=1786001438;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=euCZIlasW5DVhSnPXfTN27QdzYcetqKGnl1AdxhlSqU=;
  b=oCmrCwh2tfZsJgd9VDhAQTPnaEKdIZ8oR3fjgy8KI9clSG/+TXftmRGM
   0DiY41THM7CN68wnApJ3RoGLxisAn51Lch3e2Q24e/nu1qQbpPmhz87ig
   JShPI7IO/oPTqsBTkAwURjpMPafqJKgh7mFjeo5qX8/SgXFLC+EQXYr0s
   wsmuuGK51IK9KW726KnaoEQ6nh4FCiU1V7TDS59hnX7Ghc8+97K8V26vG
   zb7brjSxbL0f1VKDNYEEg9sT2KkvoN1jRFH0I/B82EWnHf6t/LTWH4OHc
   W9U4/A+J8K18UEV8z63z8udlEAp05mNtbLfrAtn3ABAr3Ca2ovKUrK8mR
   A==;
X-CSE-ConnectionGUID: hVlBboUiQVKqwp89PZ0cZw==
X-CSE-MsgGUID: A3L6/YF4TcGMrexe3VGiAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56858009"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56858009"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:30:38 -0700
X-CSE-ConnectionGUID: mayaMalZTzmGXCbDWnSU+w==
X-CSE-MsgGUID: oxyl7Yc2QJKri48kzfbmvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="165069436"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:30:36 -0700
Message-ID: <ba9a19c0-c30a-44fa-bc21-7184422c937d@linux.intel.com>
Date: Wed, 6 Aug 2025 15:30:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/18] KVM: x86/pmu: Open code pmc_event_is_allowed() in
 its callers
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-14-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> Open code pmc_event_is_allowed() in its callers, as kvm_pmu_trigger_event()
> only needs to check the event filter (both global and local enables are
> consulted outside of the loop).
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index e73c2a44028b..a495ab5d0556 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -491,12 +491,6 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>  	return is_fixed_event_allowed(filter, pmc->idx);
>  }
>  
> -static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
> -{
> -	return pmc_is_globally_enabled(pmc) && pmc_is_locally_enabled(pmc) &&
> -	       check_pmu_event_filter(pmc);
> -}
> -
>  static int reprogram_counter(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -507,7 +501,8 @@ static int reprogram_counter(struct kvm_pmc *pmc)
>  
>  	emulate_overflow = pmc_pause_counter(pmc);
>  
> -	if (!pmc_event_is_allowed(pmc))
> +	if (!pmc_is_globally_enabled(pmc) || !pmc_is_locally_enabled(pmc) ||
> +	    !check_pmu_event_filter(pmc))
>  		return 0;
>  
>  	if (emulate_overflow)
> @@ -974,7 +969,8 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>  		return;
>  
>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
> -		if (!pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
> +		if (!pmc_is_globally_enabled(pmc) || !pmc_is_locally_enabled(pmc) ||
> +		    !check_pmu_event_filter(pmc) || !cpl_is_matched(pmc))
>  			continue;
>  
>  		kvm_pmu_incr_counter(pmc);

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



