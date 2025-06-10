Return-Path: <kvm+bounces-48786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60733AD2DDD
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 08:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 037B418923C2
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4708525F974;
	Tue, 10 Jun 2025 06:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q6wCvyw1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC3A1F09B0;
	Tue, 10 Jun 2025 06:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749536472; cv=none; b=u/5AbPXIcmxYEUBfE12+i12CUFsmADSIuOwEvPqI+ZzYUJnd5kObGEOu8pK1vFt6Mj3YPOem7ZXmdiuhNK3R7f1uyre58OIq795MrvZW79lijOiqHYk8CEdfpMuOn6MhVFzZvb9pDHynylXKGpf6nIMLO+eHLa0YlQ3IUpdjtDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749536472; c=relaxed/simple;
	bh=0PAdnlXmh5hKwjgU6sUS3J6AWlqP+z7tw2yaNPyNdOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RVhP0I1ZNRITh7YumlSdLHw9MYwFdqVQW2ULNpncFmTL/F2GRtW5q0b7N4MZ5d149l9ie3Q+M37U6FAUfeqSCTwYGA3c2GqREYX7lrxiyTbPYRaoJz51UT1Z7hEvuD8NiAxUg63q5wDujMj/+WD6LqyR1cBk/ssHRQCDEHt+JhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q6wCvyw1; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749536471; x=1781072471;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0PAdnlXmh5hKwjgU6sUS3J6AWlqP+z7tw2yaNPyNdOA=;
  b=Q6wCvyw1isnaGX2faGh/bZR6US5U1W1fxbOj+4F67vvSSxaSWgjMFbWq
   eBfibbzc9ICmT+d2FMrCDqoxuIIEuQfGgqMUw1JlFpjWziq0S75bsJvgn
   fGiGSCGG2ujRzJ5E6yzQb4/2QClLnuWJ8TYbRAAjMlew95hsR07/vX4hQ
   BO3E37PPqwLhmVbaDnJvw85af2RXkbEpXgv79U4Co6v2qjEorYML3tOre
   ZUiss9HUd270hoJIPto3muM9qi9g49gUtuFzfl3hi1AbYMoHnQ6GPd8Me
   thecgiBB4Z8S2gDgIDRHzTfAvCTLzB6ujNrpfkWuP0NN7CO6+tSsk5uoC
   Q==;
X-CSE-ConnectionGUID: QEFsWR3jSuOGzz63pm7PrA==
X-CSE-MsgGUID: 9B+1y2O4T7WUHv/ic5z9Yw==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51771260"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="51771260"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:21:10 -0700
X-CSE-ConnectionGUID: EvT91XccR8qL2MtfgcrCnQ==
X-CSE-MsgGUID: DP1cOW1pSV+4XWpQL/wpYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="146656509"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:21:07 -0700
Message-ID: <92b737d4-4584-4e8c-89dc-e2a5308449ec@linux.intel.com>
Date: Tue, 10 Jun 2025 14:21:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 06/16] x86: Add and use
 X86_PROPERTY_INTEL_PT_NR_RANGES
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-7-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529221929.3807680-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/30/2025 6:19 AM, Sean Christopherson wrote:
> Add a definition for X86_PROPERTY_INTEL_PT_NR_RANGES, and use it instead
> of open coding equivalent logic in the LA57 testcase that verifies the
> canonical address behavior of PT MSRs.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/processor.h | 3 +++
>  x86/la57.c          | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index cbfd2ee1..3b02a966 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -370,6 +370,9 @@ struct x86_cpu_property {
>  
>  #define X86_PROPERTY_XSTATE_TILE_SIZE		X86_CPU_PROPERTY(0xd, 18, EAX,  0, 31)
>  #define X86_PROPERTY_XSTATE_TILE_OFFSET		X86_CPU_PROPERTY(0xd, 18, EBX,  0, 31)
> +
> +#define X86_PROPERTY_INTEL_PT_NR_RANGES		X86_CPU_PROPERTY(0x14, 1, EAX,  0, 2)
> +
>  #define X86_PROPERTY_AMX_MAX_PALETTE_TABLES	X86_CPU_PROPERTY(0x1d, 0, EAX,  0, 31)
>  #define X86_PROPERTY_AMX_TOTAL_TILE_BYTES	X86_CPU_PROPERTY(0x1d, 1, EAX,  0, 15)
>  #define X86_PROPERTY_AMX_BYTES_PER_TILE		X86_CPU_PROPERTY(0x1d, 1, EAX, 16, 31)
> diff --git a/x86/la57.c b/x86/la57.c
> index 41764110..1161a5bf 100644
> --- a/x86/la57.c
> +++ b/x86/la57.c
> @@ -288,7 +288,7 @@ static void __test_canonical_checks(bool force_emulation)
>  
>  	/* PT filter ranges */
>  	if (this_cpu_has(X86_FEATURE_INTEL_PT)) {
> -		int n_ranges = cpuid_indexed(0x14, 0x1).a & 0x7;
> +		int n_ranges = this_cpu_property(X86_PROPERTY_INTEL_PT_NR_RANGES);
>  		int i;
>  
>  		for (i = 0 ; i < n_ranges ; i++) {

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



