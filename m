Return-Path: <kvm+bounces-56260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D02AB3B69C
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 11:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AF973BDB3D
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 09:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6435A2E3AFD;
	Fri, 29 Aug 2025 09:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KR5SZlw6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CCD2C17B2;
	Fri, 29 Aug 2025 09:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756458191; cv=none; b=f0Fpy27elABjuX3NB4AAS6pS1S0y0S4ygEUnT8tBYg4DF85D3XcdvEwr5XQRnbXeUGg7BzFTpiD2nBAll+nuoCuLGDfMS/SLuOkEv+1baUR1UiAem5XQGAghmnqq7mveBPH3IcGu2VGdNsGQbxMstewnhzDspt2d6ntTDY54yzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756458191; c=relaxed/simple;
	bh=rfCydt4F768oc/kiHWd8J0zI+4wJzEfpn6BpsGWhauM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X0VqCgOHB1neGTylssovOOvFeHcsIsMP2SssKLgfgP2r6OwCmvI2dXnM0eDTjZznUel6kFgmZ+CC89vpTMGJkXGJGHyHMJce8Q5b9FwDdNjGMf2o8yYe/CTKcZfPARgDD7V21YcygI1nZfQdNWvIHdJZczjBqi6IbBEpjIVSlKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KR5SZlw6; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756458190; x=1787994190;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rfCydt4F768oc/kiHWd8J0zI+4wJzEfpn6BpsGWhauM=;
  b=KR5SZlw62We/34Z8drPF9QQF7Do+zGcf4pKxLhnkyXu/iO0FsNRWZF5m
   RT/lIR5MaEf18Mvw5pXw215YWj7/rKBknex8WPNyQW6WkGboD3v5TCYkw
   O9voZ1aKAHDrbLD+QR0FPEGuW8TLTifboDtrIAhtYyqwKd4Z97IuMdxEM
   kshn/8Hk0NocPPUZcpxDg5dyi873SBsvPRAHR7FyjckaB27b86/4IINv7
   Qvo5eg+Ue9T2ioW+3GUip/VPHkDOD0wrGkbSr+xKd9m4lfi8yRlSdarDE
   y4OAoI9B3poM0x8SR7+gmN0OM+Y2+UddggbBbKWu2keNe0hNK4Yqd4AMs
   Q==;
X-CSE-ConnectionGUID: FNzv4G42QhyGaNbxG27MXw==
X-CSE-MsgGUID: fjb2lAV+RISExQNK/kBWLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="69838867"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="69838867"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:03:09 -0700
X-CSE-ConnectionGUID: Jl+/wSrKRm+MK7smNjxqiw==
X-CSE-MsgGUID: MWOBUiYwTlSq1SQ+x9cenA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="201248159"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:03:06 -0700
Message-ID: <fcf19563-df65-4936-bd08-46f1a95359af@linux.intel.com>
Date: Fri, 29 Aug 2025 17:03:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 15/18] KVM: TDX: Combine KVM_BUG_ON +
 pr_tdx_error() into TDX_BUG_ON()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-16-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250829000618.351013-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/29/2025 8:06 AM, Sean Christopherson wrote:
> Add TDX_BUG_ON() macros (with varying numbers of arguments) to deduplicate
> the myriad flows that do KVM_BUG_ON()/WARN_ON_ONCE() followed by a call to
> pr_tdx_error().  In addition to reducing boilerplate copy+paste code, this
> also helps ensure that KVM provides consistent handling of SEAMCALL errors.
>
> Opportunistically convert a handful of bare WARN_ON_ONCE() paths to the
> equivalent of KVM_BUG_ON(), i.e. have them terminate the VM.  If a SEAMCALL
> error is fatal enough to WARN on, it's fatal enough to terminate the TD.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++------------------------
>   1 file changed, 47 insertions(+), 67 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index aa6d88629dae..df9b4496cd01 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -24,20 +24,32 @@
>   #undef pr_fmt
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
> -#define pr_tdx_error(__fn, __err)	\
> -	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
> +#define __TDX_BUG_ON(__err, __f, __kvm, __fmt, __args...)			\
> +({										\
> +	struct kvm *_kvm = (__kvm);						\
> +	bool __ret = !!(__err);							\
> +										\
> +	if (WARN_ON_ONCE(__ret && (!_kvm || !_kvm->vm_bugged))) {		\
> +		if (_kvm)							\
> +			kvm_vm_bugged(_kvm);					\
> +		pr_err_ratelimited("SEAMCALL " __f " failed: 0x%llx" __fmt "\n",\
> +				   __err,  __args);				\
> +	}									\
> +	unlikely(__ret);							\
> +})
>   
> -#define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)		\
> -	pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)
> +#define TDX_BUG_ON(__err, __fn, __kvm)				\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
>   
> -#define pr_tdx_error_1(__fn, __err, __rcx)		\
> -	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)
> +#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
>   
> -#define pr_tdx_error_2(__fn, __err, __rcx, __rdx)	\
> -	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
> +#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)
> +
> +#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)
>   
> -#define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
> -	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)

I thought you would use the format Rick proposed in
https://lore.kernel.org/all/9e55a0e767317d20fc45575c4ed6dafa863e1ca0.camel@intel.com/
     #define TDX_BUG_ON_2(__err, __fn, arg1, arg2, __kvm)        \
         __TDX_BUG_ON(__err, #__fn, __kvm, ", " #arg1 " 0x%llx, " #arg2 "
     0x%llx", arg1, arg2)

     so you get: entry: 0x00 level:0xF00

No?

[...]

