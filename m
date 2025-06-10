Return-Path: <kvm+bounces-48784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D484DAD2DCA
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 08:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB2221891898
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76013242907;
	Tue, 10 Jun 2025 06:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXLFL/zd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2163A2222D7;
	Tue, 10 Jun 2025 06:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749536177; cv=none; b=VVr9Ch6qfzqGaZfbuRJ8IzJGlBLRiTHHbkOaHTyduot5C0yud3OZPf9ePDxZpoku2Ku+8sb9xlM0KiFwcxOr7U6ZwRdzPAj4Gr+r4bQ71YeZZL3QXhvJ9WOWf6lNk+734FWI8KV5xoCCX0CzYQ3jEzjN1pAi5V5EsBvy+RpGCwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749536177; c=relaxed/simple;
	bh=g4LjuN3moKRTUytYrxH847zYyyNOlBUZBBeSd8RwcXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lx+bXUi2TXbIHXxsvRqj3MLo38g11wv6CiiM2Hmmuruub6pdPtsEiCcVnkEIS/zP+/SvcfUnSyL5kFLh+10Oe8XhSjSu+jBPm3141l8zIYDjHmq3Ftjyvb4gnO0sPHKUSd6SmmfNsWEwNxd3L6kK6WrYNgY/+9vlNh6ifIEe0Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXLFL/zd; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749536176; x=1781072176;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g4LjuN3moKRTUytYrxH847zYyyNOlBUZBBeSd8RwcXI=;
  b=HXLFL/zdM3VEkPcMBhYM10E4g98CC0limT8yU6KYyi+gxfMUsCjlgyXF
   Enf/JWM/LTpuMLhn/iz+rTaGYBc76M/bikE1nDx/pJfMLg8DV9MBI5ma0
   sMx++GcVe0bHKyDSL6GWY1ACog3hxjNzv2LyQoAwHvFyvte50CkJorxUL
   F5gtFKUNWNw757nwrv2/fyPPoDvGB04eRhI4yV6nhQVCWAjMg7z/+Groj
   c3GM9Fre9tYeQv5wS3dkeqyyX+zDIllI/nXnNdqbizk4j9sRtoG78Mz4Q
   yvZlvv/fr7i1sOtihYCCi1iQAy5innLuWkrWbyesKjiMTjBIbLl0IzOK1
   Q==;
X-CSE-ConnectionGUID: jVqR9hVqScGSBkvMMqendw==
X-CSE-MsgGUID: IdVw02FBTIaK5p6G1PIBLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="77029418"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="77029418"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:16:14 -0700
X-CSE-ConnectionGUID: NU3kUdWXRdCQrihdNyn8Pw==
X-CSE-MsgGUID: kwkA/DNSRU+vkuvSU9FiEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="146713085"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:16:11 -0700
Message-ID: <8fdebefa-b6b1-44d5-b804-46a08bf23e11@linux.intel.com>
Date: Tue, 10 Jun 2025 14:16:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 04/16] x86: Use X86_PROPERTY_MAX_VIRT_ADDR
 in is_canonical()
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-5-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529221929.3807680-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/30/2025 6:19 AM, Sean Christopherson wrote:
> Use X86_PROPERTY_MAX_VIRT_ADDR in is_canonical() instead of open coding a
> *very* rough equivalent.  Default to a maximum virtual address width of
> 48 bits instead of 64 bits to better match real x86 CPUs (and Intel and
> AMD architectures).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/processor.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 6b61a38b..8c6f28a3 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -1022,9 +1022,14 @@ static inline void write_pkru(u32 pkru)
>  
>  static inline bool is_canonical(u64 addr)
>  {
> -	int va_width = (raw_cpuid(0x80000008, 0).a & 0xff00) >> 8;
> -	int shift_amt = 64 - va_width;
> +	int va_width, shift_amt;
>  
> +	if (this_cpu_has_p(X86_PROPERTY_MAX_VIRT_ADDR))
> +		va_width = this_cpu_property(X86_PROPERTY_MAX_VIRT_ADDR);
> +	else
> +		va_width = 48;
> +
> +	shift_amt = 64 - va_width;
>  	return (s64)(addr << shift_amt) >> shift_amt == addr;
>  }
>  

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



