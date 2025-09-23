Return-Path: <kvm+bounces-58505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4972B94792
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:49:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87EB12A60B5
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2F130CDA6;
	Tue, 23 Sep 2025 05:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P1BjAtYV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DF1214A9B;
	Tue, 23 Sep 2025 05:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758606566; cv=none; b=MdnGO+pUDBkWhC/++8PECTAcT3aE1bHu8K0+FWn4q9yetOgni36uKu9/kvza2TDa9IZ/mLJLyZJL6+YRe1ofr9AWM2Plp0I75lbI5xMVp1SviPRmNRY8K6aZSaeHMJEfbSJO3EEad9EhZ8o76Hb+qcQJdE9zf1DfyebgCvIc3Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758606566; c=relaxed/simple;
	bh=9KhHhKpIuAcrrNcmvN9l1vjy6d5T0ju3oNA6kv8u3Wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZvPVVhBuTTYHiRHKXga/1PB8sT2ItGE12ye5vE4xp0U759IW2WOhy5vTyaJlO6S0awaYt+Dp2KnzaKy2mG5jxhWP3euCR8KJpJGQG/RTLF9T/vH5rJcukCMeCELsAaiILv+Nqe+Aqv95UZJ68JOhaKKYjGbSKPR6ltjh0j25B48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P1BjAtYV; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758606565; x=1790142565;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9KhHhKpIuAcrrNcmvN9l1vjy6d5T0ju3oNA6kv8u3Wo=;
  b=P1BjAtYVS78EhWKPGpm5qTMwVzMm95OldsO8Q5gUnAIp0qk2QjVRn8Cs
   Zo0j1mFIXaNo4qFcFLetmUOBCiK5G7mJ6Pp5CxkP9J6zJQwxGkO4sHi+R
   tgoVeG6mfJnl/R/erQ5CdZooIKjk6f9jLktIftJDNR3WQC3lH9glZhjEP
   RLkkwqt2hUjDFQYCZx24tDcKCdPrRYFLCD3cvTAL9cfI2m002HiXaNJPa
   NhKAd+LUgHEtBKcJyLLAgXndHOdpgLu8R89LPMg+zj4QKH4K4HfI5vYvH
   D5Qg82z6732/JXDu73nOD07uSQesQmi3Gg720Lkh+y7s2/pu5/A9fQ3c7
   Q==;
X-CSE-ConnectionGUID: mYgMsQ1vS6mBAoDpjhD4mQ==
X-CSE-MsgGUID: ZIsyNa58Q++sE9ZQF6NWgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60766055"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="60766055"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 22:49:25 -0700
X-CSE-ConnectionGUID: YDt2itetQvejjsKkPHBLtg==
X-CSE-MsgGUID: 9GicGyx7R6yDu7xj6bStzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="175961800"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 22:49:21 -0700
Message-ID: <76019bfc-cd06-4a03-9e1e-721cf63637c4@linux.intel.com>
Date: Tue, 23 Sep 2025 13:49:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kas@kernel.org, bp@alien8.de, chao.gao@intel.com,
 dave.hansen@linux.intel.com, isaku.yamahata@intel.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, x86@kernel.org, yan.y.zhao@intel.com,
 vannapurve@google.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/19/2025 7:22 AM, Rick Edgecombe wrote:
[...]
> +/*
> + * SW-defined error codes.
> + *
> + * Bits 47:40 == 0xFF indicate Reserved status code class that never used by
> + * TDX module.
> + */
> +#define TDX_ERROR			_BITULL(63)
> +#define TDX_NON_RECOVERABLE		_BITULL(62)

TDX_ERROR and TDX_NON_RECOVERABLE are defined in TDX spec as the classes of TDX
Interface Functions Completion Status.

For clarity, is it better to move the two before the "SW-defined error codes"
comment?

> +#define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
> +#define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _ULL(0xFFFF0000))
> +
> +#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
> +#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
> +
>   /*
>    * TDX module operand ID, appears in 31:0 part of error code as
>    * detail information
> @@ -37,4 +52,4 @@
>   #define TDX_OPERAND_ID_SEPT			0x92
>   #define TDX_OPERAND_ID_TD_EPOCH			0xa9
>   
> -#endif /* __KVM_X86_TDX_ERRNO_H */
> +#endif /* _X86_SHARED_TDX_ERRNO_H */
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 7ddef3a69866..0e795e7c0b22 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -12,26 +12,6 @@
>   #include <asm/trapnr.h>
>   #include <asm/shared/tdx.h>
>   
> -/*
> - * SW-defined error codes.
> - *
> - * Bits 47:40 == 0xFF indicate Reserved status code class that never used by
> - * TDX module.
> - */
> -#define TDX_ERROR			_BITUL(63)
> -#define TDX_NON_RECOVERABLE		_BITUL(62)
> -#define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
> -#define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
> -
> -#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
> -#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
> -
> -/*
> - * TDX module SEAMCALL leaf function error codes
> - */
> -#define TDX_SUCCESS		0ULL
> -#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
> -
>   #ifndef __ASSEMBLER__
>   
>   #include <uapi/asm/mce.h>
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index ca39a9391db1..f4e609a745ee 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -3,7 +3,6 @@
>   #define __KVM_X86_VMX_TDX_H
>   
>   #include "tdx_arch.h"
> -#include "tdx_errno.h"
>   
>   #ifdef CONFIG_KVM_INTEL_TDX
>   #include "common.h"


