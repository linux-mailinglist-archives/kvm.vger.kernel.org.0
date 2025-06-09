Return-Path: <kvm+bounces-48717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 816E6AD1889
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 08:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7158A3A37A0
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 06:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9276C27FB16;
	Mon,  9 Jun 2025 06:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Or2tMm80"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F2416EB42
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 06:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749450104; cv=none; b=WwfC2fwA/1hHD6Ed70OWrj66BRXZq0u3j4f5vhbOpDvYm74dfgUlkiLYcEZCAuJDwhoJG4gcMfoN0vQzZAbn7MvSElogelgUZTHfhUk2v2rkTzwa63lp8JEfvgce+Fu1JSUap7FXz9RBeiMSZa8mKSyQavvEP8qLlT0nF+DitRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749450104; c=relaxed/simple;
	bh=NYX+TvE+pDX0lwYbTGMt55Kf6/4PDHNpf1rFT0aG4ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mak+suHtSZTzkygYHX6VXLqzShv4Il06w6pEsFLTUdiFUxNAJMN40LqWUe3yp2p4oRo4KjDJrFDrohR8IrjWeLXPCQ0ABzLwymXVkSxnRD0ZwNOkp8CpBSva7ttsh8lOg1T9d5p2orsus+OV4gf9/1OOv2h+mus26rNovJrxkk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Or2tMm80; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749450103; x=1780986103;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NYX+TvE+pDX0lwYbTGMt55Kf6/4PDHNpf1rFT0aG4ic=;
  b=Or2tMm80Cpqkr3mherWurske4RQ5HV8xZinthyqHt3hZ1hbvQio1h0PJ
   st/dAJs8gXX810zkrWJq8P+DznCu+fdqzZbnYkP/RZ+vjhsOCng2g/Xia
   XQUuyJD/W6PHGnQYMRq5vrjfht8psvUx3LP3j76cbf5302Yz4bQvATOGF
   1AqoAXeMNMtraAIyKWRdr6tb29KK5eguN6VyyIQh7bCnxwGBiOQC8clrk
   YDPtauzCR3079FMHxnZrYbdZq0+qrPkB825LQlCatbkQMeoH+I859pb4N
   LvQnBv4f8i54x5pnwDMMpho8hJVua0Q2w3zzVr32fOT+VMsVac96XXdjn
   g==;
X-CSE-ConnectionGUID: fd63QqS1QzOxcDK4x8p6GA==
X-CSE-MsgGUID: CD5VQUTfS9Ov83vJYsW+Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="62168088"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="62168088"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 23:21:40 -0700
X-CSE-ConnectionGUID: +9ofs445QvihNclFsG1awA==
X-CSE-MsgGUID: G/ED4g4STeaerB/s7Z10iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="183607883"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 23:21:39 -0700
Message-ID: <aa72e0b4-eb54-4913-bfbd-f26cd354b428@linux.intel.com>
Date: Mon, 9 Jun 2025 14:21:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 4/8] x86: Expand the suite of bitops to
 cover all set/clear operations
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
References: <20250605192226.532654-1-seanjc@google.com>
 <20250605192226.532654-5-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250605192226.532654-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/6/2025 3:22 AM, Sean Christopherson wrote:
> Provide atomic and non-atomic APIs for clearing and setting bits, along
> with "test" versions to return the original value.  Don't bother with
> "change" APIs, as they are highly unlikely to be needed.
>
> Opportunistically move the existing definitions to bitops.h so that common
> code can access the helpers.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/asm/bitops.h | 86 +++++++++++++++++++++++++++++++++++++++++---
>  lib/x86/processor.h  | 12 -------
>  2 files changed, 81 insertions(+), 17 deletions(-)
>
> diff --git a/lib/x86/asm/bitops.h b/lib/x86/asm/bitops.h
> index 54ec9c42..3ece1b67 100644
> --- a/lib/x86/asm/bitops.h
> +++ b/lib/x86/asm/bitops.h
> @@ -13,12 +13,88 @@
>  
>  #define HAVE_BUILTIN_FLS 1
>  
> -static inline void test_and_set_bit(long nr, unsigned long *addr)
> +/*
> + * Macros to generate condition code outputs from inline assembly,
> + * The output operand must be type "bool".
> + */
> +#ifdef __GCC_ASM_FLAG_OUTPUTS__
> +# define CC_SET(c) "\n\t/* output condition code " #c "*/\n"
> +# define CC_OUT(c) "=@cc" #c
> +#else
> +# define CC_SET(c) "\n\tset" #c " %[_cc_" #c "]\n"
> +# define CC_OUT(c) [_cc_ ## c] "=qm"
> +#endif
> +
> +static inline void __clear_bit(int bit, void *__addr)
> +{
> +	unsigned long *addr = __addr;
> +
> +	__asm__ __volatile__("btr %1, %0"
> +			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
> +}
> +
> +static inline void __set_bit(int bit, void *__addr)
> +{
> +	unsigned long *addr = __addr;
> +
> +	__asm__ __volatile__("bts %1, %0"
> +			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
> +}
> +
> +static inline bool __test_and_clear_bit(int bit, void *__addr)
> +{
> +	unsigned long *addr = __addr;
> +	bool v;
> +
> +	__asm__ __volatile__("btr %2, %1" CC_SET(c)
> +			     : CC_OUT(c) (v), "+m" (*addr) : "Ir" (bit));
> +	return v;
> +}
> +
> +static inline bool __test_and_set_bit(int bit, void *__addr)
>  {
> -	asm volatile("lock; bts %1,%0"
> -		     : "+m" (*addr)
> -		     : "Ir" (nr)
> -		     : "memory");
> +	unsigned long *addr = __addr;
> +	bool v;
> +
> +	__asm__ __volatile__("bts %2, %1" CC_SET(c)
> +			     : CC_OUT(c) (v), "+m" (*addr) : "Ir" (bit));
> +	return v;
> +}
> +
> +static inline void clear_bit(int bit, void *__addr)
> +{
> +	unsigned long *addr = __addr;
> +
> +	__asm__ __volatile__("lock; btr %1, %0"
> +			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
> +}
> +
> +static inline void set_bit(int bit, void *__addr)
> +{
> +	unsigned long *addr = __addr;
> +
> +	__asm__ __volatile__("lock; bts %1, %0"
> +			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
> +}
> +
> +static inline bool test_and_clear_bit(int bit, void *__addr)
> +{
> +	unsigned long *addr = __addr;
> +	bool v;
> +
> +	__asm__ __volatile__("lock; btr %2, %1" CC_SET(c)
> +			     : CC_OUT(c) (v), "+m" (*addr) : "Ir" (bit));
> +	return v;
> +}
> +
> +static inline bool test_and_set_bit(int bit, void *__addr)
> +{
> +	unsigned long *addr = __addr;
> +	bool v;
> +
> +	__asm__ __volatile__("lock; bts %2, %1" CC_SET(c)
> +			     : CC_OUT(c) (v), "+m" (*addr) : "Ir" (bit));
> +	return v;
>  }
>  
>  #endif
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index a0be04c5..5bc9ef89 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -914,18 +914,6 @@ static inline bool is_canonical(u64 addr)
>  	return (s64)(addr << shift_amt) >> shift_amt == addr;
>  }
>  
> -static inline void clear_bit(int bit, u8 *addr)
> -{
> -	__asm__ __volatile__("lock; btr %1, %0"
> -			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
> -}
> -
> -static inline void set_bit(int bit, u8 *addr)
> -{
> -	__asm__ __volatile__("lock; bts %1, %0"
> -			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
> -}
> -
>  static inline void flush_tlb(void)
>  {
>  	ulong cr4;

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>




