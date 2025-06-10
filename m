Return-Path: <kvm+bounces-48785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11BB5AD2DD7
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 08:18:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF5D01700C0
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C7427817D;
	Tue, 10 Jun 2025 06:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tgw2BpLm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789A921CA0C;
	Tue, 10 Jun 2025 06:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749536327; cv=none; b=TbWjjl8tUlkvwLEsGWnmGYe8grHmDOLNAjlAS9zpkidykxoaIa/aTTfwJL937bOIHREkR3MgNc3yyzAvvkLzZvQMkcNpEHYobtXSTGZRqdjWlFY5xcTFliQQ1Zsrj1lxSXKIZ4CL04f8UyiueyhNa3YBpRfj2+/jWMUHDlmQMrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749536327; c=relaxed/simple;
	bh=aqaF2FH8CbMEb7CF0tc3Ez2NC3jhnDqME0bWTPyhxqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lqWQjnH1/KeWf+dyH02Njdu9ZnnxxTEaLbtecAz0EMAYVBfrfhJEX2gUjzpS/clgoab+mQJiUsmZmYCncDZH8dW0ffapM5n7NY/L+yy8oF5ab+zACiA+pMUwGT74ylQrpKBQ7jt57F/ZmyxgVdd1J/ciKtTb0s2fP0a8Skf+2eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tgw2BpLm; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749536327; x=1781072327;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aqaF2FH8CbMEb7CF0tc3Ez2NC3jhnDqME0bWTPyhxqg=;
  b=Tgw2BpLmC7SlE2iqWtiZ5PU5fC9Vl9tXNSQD20oOym7ARgsGKrxOHwOm
   GKPgZ4gFE/AyR2AXhlKPHCht4ZhMKfZjjFuIy8Rdkvq2DEFf72vbOzZ65
   JNhZPPU4EDDHBmmbcy37SYDbS54TOCRWOZHjMhK0XL2pFvaA6kVmiRSHV
   Ao8jdt9U/2uU5ElI4FH2ifNcekYZmr1mjJbkADQsThXwdbFN55AG2K+Wz
   51H6ttUjHVBfKtlDb0n0FE2PGc6/7MSt0R+JcWxInALU9qa3yesoUur0x
   lH+Nee6d3am3tnus+GvcjvPNZFe1ymLejsyzX+4YhPAwa5Gvc0BUrGMWt
   A==;
X-CSE-ConnectionGUID: xw/ulTHETMGydPkFRnH7FQ==
X-CSE-MsgGUID: rUamgcC4SvK2JeVd4Zw7iQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51487124"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="51487124"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:18:46 -0700
X-CSE-ConnectionGUID: ANAFZMdBRW+xc9QcNP75aw==
X-CSE-MsgGUID: 7eTE/kRZScapcKfNoDAhxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="151743551"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:18:43 -0700
Message-ID: <e48708a0-d7d8-41bd-8d90-d7f7482489f3@linux.intel.com>
Date: Tue, 10 Jun 2025 14:18:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 05/16] x86: Implement get_supported_xcr0()
 using X86_PROPERTY_SUPPORTED_XCR0_{LO,HI}
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-6-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529221929.3807680-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/30/2025 6:19 AM, Sean Christopherson wrote:
> Use X86_PROPERTY_SUPPORTED_XCR0_{LO,HI} to implement get_supported_xcr0().
>
> Opportunistically rename the helper and move it to processor.h.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/processor.h |  9 +++++++++
>  x86/xsave.c         | 11 +----------
>  2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 8c6f28a3..cbfd2ee1 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -442,6 +442,15 @@ static inline u8 cpuid_maxphyaddr(void)
>  	return this_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
>  }
>  
> +static inline u64 this_cpu_supported_xcr0(void)
> +{
> +	if (!this_cpu_has_p(X86_PROPERTY_SUPPORTED_XCR0_LO))
> +		return 0;
> +
> +	return (u64)this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_LO) |
> +	       ((u64)this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_HI) << 32);
> +}
> +
>  struct far_pointer32 {
>  	u32 offset;
>  	u16 selector;
> diff --git a/x86/xsave.c b/x86/xsave.c
> index 5d80f245..cc8e3a0a 100644
> --- a/x86/xsave.c
> +++ b/x86/xsave.c
> @@ -8,15 +8,6 @@
>  #define uint64_t unsigned long long
>  #endif
>  
> -static uint64_t get_supported_xcr0(void)
> -{
> -    struct cpuid r;
> -    r = cpuid_indexed(0xd, 0);
> -    printf("eax %x, ebx %x, ecx %x, edx %x\n",
> -            r.a, r.b, r.c, r.d);
> -    return r.a + ((u64)r.d << 32);
> -}
> -
>  #define XCR_XFEATURE_ENABLED_MASK       0x00000000
>  #define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
>  
> @@ -33,7 +24,7 @@ static void test_xsave(void)
>  
>      printf("Legal instruction testing:\n");
>  
> -    supported_xcr0 = get_supported_xcr0();
> +    supported_xcr0 = this_cpu_supported_xcr0();
>      printf("Supported XCR0 bits: %#lx\n", supported_xcr0);
>  
>      test_bits = XSTATE_FP | XSTATE_SSE;

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



