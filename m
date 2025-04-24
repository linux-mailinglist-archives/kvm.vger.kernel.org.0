Return-Path: <kvm+bounces-44070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C367A9A23A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A52A179D6C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C29A207A22;
	Thu, 24 Apr 2025 06:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="frtjTorX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC3E1DDC21;
	Thu, 24 Apr 2025 06:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745475970; cv=none; b=qFzSV8mWf6pXHaxl+6szdoc/RyPCdCAwXAI/iTmxa1HyPaoTsLsh2PuZSBqwtG1X6QzOw0q3edysS61U3+GGhlHWlMsNoLD/Wv9zzOAwZkKaKdULVNwMPZsqyDLunQMb7gPVRshThYfQVEzIydUHRl0iWAVCtE0gSLxFAzJuIQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745475970; c=relaxed/simple;
	bh=r9pnF53EyyaRucMwNVgQLeGE6Ab0R4f4MEaSIMBKOXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IE2zI/x8j13CcPvtXUwjzDePmkBTb7TjM9rnQOnmIur2rDvdsRBIniA1UgeEM+g2R/sMrElMfkFk9q2R+/KgRnfHzGbSeSyAjynlSKaibPRBgAMaaTmk8QGgiTGzKz4DPkC9eldQmAvl9+FMgkKXNgn7h1D6GG4DxrJ6pGdMJZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=frtjTorX; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745475966; x=1777011966;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r9pnF53EyyaRucMwNVgQLeGE6Ab0R4f4MEaSIMBKOXs=;
  b=frtjTorXnnyRNojO/uMNvHpfb8o8jg6AILywkYb0KIv7SI4HsdlatWLi
   4q79+bYdQluLuCFzEC0Y0QYqjp91xKftuKGiJ3Oq6sb9lwO2fs5WMWjbE
   29PSOIZf4TBuVUGFe9aSM+s6Y41b5BQuDnfB1uMHuXqxt21pny0n2aHFW
   u50qo8Rqooqz4I8E9ReYRHLeSQOpPnKZwJuQorYio/u64jEaWxNHf4Lwn
   aTE8ge/fEdVzPOCMoJ6w0TLR6dHMPkMS6HIKD+aND3du8P72ZLecYoUwj
   LWsW/ZMh0joA7wL60wBWfChehZi8bj+QlrdADgtiBFTXDH0pM9hTE6Vyt
   g==;
X-CSE-ConnectionGUID: Z1dpGu+eQHW25lxJoYL7Aw==
X-CSE-MsgGUID: 9HrqRHW1RMKp0TVWhdoWtw==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47187615"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="47187615"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 23:26:05 -0700
X-CSE-ConnectionGUID: Ejvh0aUHTACVpOK/Jqvr7Q==
X-CSE-MsgGUID: i3jvGnxIQpSi7EjKCit1UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="132432771"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 23:25:52 -0700
Message-ID: <20471e53-c228-4cf6-83e6-3ab49f32f19f@linux.intel.com>
Date: Thu, 24 Apr 2025 14:25:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 11/34] x86/msr: Remove calling
 native_{read,write}_msr{,_safe}() in pmu_msr_{read,write}()
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
 namhyung@kernel.org, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com,
 adrian.hunter@intel.com, kan.liang@linux.intel.com, wei.liu@kernel.org,
 ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
 tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
 seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
 kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-12-xin@zytor.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250422082216.1954310-12-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/22/2025 4:21 PM, Xin Li (Intel) wrote:
> hpa found that pmu_msr_write() is actually a completely pointless
> function [1]: all it does is shuffle some arguments, then calls
> pmu_msr_chk_emulated() and if it returns true AND the emulated flag
> is clear then does *exactly the same thing* that the calling code
> would have done if pmu_msr_write() itself had returned true.  And
> pmu_msr_read() does the equivalent stupidity.
>
> Remove the calls to native_{read,write}_msr{,_safe}() within
> pmu_msr_{read,write}().  Instead reuse the existing calling code
> that decides whether to call native_{read,write}_msr{,_safe}() based
> on the return value from pmu_msr_{read,write}().  Consequently,
> eliminate the need to pass an error pointer to pmu_msr_{read,write}().
>
> While at it, refactor pmu_msr_write() to take the MSR value as a u64
> argument, replacing the current dual u32 arguments, because the dual
> u32 arguments were only used to call native_write_msr{,_safe}(), which
> has now been removed.
>
> [1]: https://lore.kernel.org/lkml/0ec48b84-d158-47c6-b14c-3563fd14bcc4@zytor.com/
>
> Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Sign-off-by: Xin Li (Intel) <xin@zytor.com>
> ---
>  arch/x86/xen/enlighten_pv.c |  6 +++++-
>  arch/x86/xen/pmu.c          | 27 ++++-----------------------
>  arch/x86/xen/xen-ops.h      |  4 ++--
>  3 files changed, 11 insertions(+), 26 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
> index 9fbe187aff00..1418758b57ff 100644
> --- a/arch/x86/xen/enlighten_pv.c
> +++ b/arch/x86/xen/enlighten_pv.c
> @@ -1132,6 +1132,8 @@ static void set_seg(unsigned int which, unsigned int low, unsigned int high,
>  static void xen_do_write_msr(unsigned int msr, unsigned int low,
>  			     unsigned int high, int *err)
>  {
> +	u64 val;
> +
>  	switch (msr) {
>  	case MSR_FS_BASE:
>  		set_seg(SEGBASE_FS, low, high, err);
> @@ -1158,7 +1160,9 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
>  		break;
>  
>  	default:
> -		if (!pmu_msr_write(msr, low, high, err)) {
> +		val = (u64)high << 32 | low;
> +
> +		if (!pmu_msr_write(msr, val)) {
>  			if (err)
>  				*err = native_write_msr_safe(msr, low, high);
>  			else
> diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
> index 9c1682af620a..95caae97a394 100644
> --- a/arch/x86/xen/pmu.c
> +++ b/arch/x86/xen/pmu.c
> @@ -313,37 +313,18 @@ static bool pmu_msr_chk_emulated(unsigned int msr, uint64_t *val, bool is_read,
>  	return true;
>  }
>  
> -bool pmu_msr_read(unsigned int msr, uint64_t *val, int *err)
> +bool pmu_msr_read(u32 msr, u64 *val)

The function name is some kind of misleading right now. With the change,
this function only read PMU MSR's value if it's emulated, otherwise it
won't really read PMU MSR. How about changing the name to
"pmu_emulated_msr_read" or something similar?


>  {
>  	bool emulated;
>  
> -	if (!pmu_msr_chk_emulated(msr, val, true, &emulated))
> -		return false;
> -
> -	if (!emulated) {
> -		*val = err ? native_read_msr_safe(msr, err)
> -			   : native_read_msr(msr);
> -	}
> -
> -	return true;
> +	return pmu_msr_chk_emulated(msr, val, true, &emulated) && emulated;
>  }
>  
> -bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err)
> +bool pmu_msr_write(u32 msr, u64 val)

ditto.


>  {
> -	uint64_t val = ((uint64_t)high << 32) | low;
>  	bool emulated;
>  
> -	if (!pmu_msr_chk_emulated(msr, &val, false, &emulated))
> -		return false;
> -
> -	if (!emulated) {
> -		if (err)
> -			*err = native_write_msr_safe(msr, low, high);
> -		else
> -			native_write_msr(msr, low, high);
> -	}
> -
> -	return true;
> +	return pmu_msr_chk_emulated(msr, &val, false, &emulated) && emulated;
>  }
>  
>  static u64 xen_amd_read_pmc(int counter)
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index dc886c3cc24d..a1875e10be31 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -271,8 +271,8 @@ void xen_pmu_finish(int cpu);
>  static inline void xen_pmu_init(int cpu) {}
>  static inline void xen_pmu_finish(int cpu) {}
>  #endif
> -bool pmu_msr_read(unsigned int msr, uint64_t *val, int *err);
> -bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err);
> +bool pmu_msr_read(u32 msr, u64 *val);

The prototype of pmu_msr_read() has been changed, but why there is no
corresponding change in its caller (xen_do_read_msr())?


> +bool pmu_msr_write(u32 msr, u64 val);
>  int pmu_apic_update(uint32_t reg);
>  u64 xen_read_pmc(int counter);
>  

