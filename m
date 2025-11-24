Return-Path: <kvm+bounces-64327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5DA8C7F6FA
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 09:56:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7491E3A5777
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 08:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516312F0C63;
	Mon, 24 Nov 2025 08:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ijEu0H7o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD822EF677;
	Mon, 24 Nov 2025 08:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763974584; cv=none; b=eE/o3QV2CDNlcbEZ3OtPELWwS0PfoC5bZl0gYXYtLl6OcwOBxKWj8hO7oAT3rwl+CYBuqBLIk3wquqoVt3oz7XvxhZaBey9F5l3O7IYZlC73lDCAzsOMco+/3v6VDsA641IfA9sjpHF657+nbf9c8kxg8wql83LYD7xsEN6thFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763974584; c=relaxed/simple;
	bh=Jm+teq8+3Q9frtKYeahT0HHK2VI/U5Z9xTgTT0mlHkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cY/ZuTGi/ScTOfCbtDA4XmUVKsIWPfXSnHyrJE9sRj63tJD1c/eS5D7NG357jiT7gmCzuzqWYjaX/+QPPPgqVGMMBHQHTDVYz0Gy51PviEpwFyzd5o3d2hKd/f2dPN6cRrjEsA1vMokYpwzw8V63svuWlZJU8CWKHsby3P0KQPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ijEu0H7o; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763974583; x=1795510583;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jm+teq8+3Q9frtKYeahT0HHK2VI/U5Z9xTgTT0mlHkc=;
  b=ijEu0H7oLROzpOu1E3qFKW9VX4MAlwsI6dnZadNVwOHn8ZrRzkcOPefB
   ElgpaFhkAEGdX12NpDLyS+ro/uV2kW3r+qoH3T2OEEp4j2Lz5Q9r1UzJ1
   ulwL0M7o8xfjrB03f+yAEkbCpUSInmpXqCmeBBjI0CBGcZUmbeylINj1y
   d6c/zxZ4vPi3VmCgTZ5xeBZmGBKGrx9kKI7fYla3eEUYQ5pGi24l+QUiK
   IPlSbATixc7h19JgKbsT0dyUWHiszs7asJFZ+kdVHaBTCFze0wkJVyLb9
   Wtsy1mQWpxmNqQtO5M2oyPyq+DJUjevi1gXAs+8xAZOHaFxHzneQrt7Zb
   A==;
X-CSE-ConnectionGUID: KlOVaM8ESg+OP298MPB4LA==
X-CSE-MsgGUID: tABV1TeGTZWHn7SGWKyJoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="77330655"
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="77330655"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 00:56:22 -0800
X-CSE-ConnectionGUID: h29LzYTXQJ2XO/Md6x/71Q==
X-CSE-MsgGUID: xTJbEjixScy/JUNmCCD1qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="197395735"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 00:56:17 -0800
Message-ID: <86e2d5fa-4d68-4200-98d1-77113bc3c1da@linux.intel.com>
Date: Mon, 24 Nov 2025 16:56:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/16] x86/tdx: Add helpers to check return status
 codes
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-3-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-3-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
[...]
>
> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index 7b2833705d47..167c5b273c40 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -129,9 +129,9 @@ int tdx_mcall_get_report0(u8 *reportdata, u8 *tdreport)
>   
>   	ret = __tdcall(TDG_MR_REPORT, &args);
>   	if (ret) {
> -		if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
> +		if (IS_TDX_OPERAND_INVALID(ret))
>   			return -ENXIO;
> -		else if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
> +		else if (IS_TDX_OPERAND_BUSY(ret))
>   			return -EBUSY;
>   		return -EIO;
>   	}
> @@ -165,9 +165,9 @@ int tdx_mcall_extend_rtmr(u8 index, u8 *data)
>   
>   	ret = __tdcall(TDG_MR_RTMR_EXTEND, &args);
>   	if (ret) {
> -		if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
> +		if (IS_TDX_OPERAND_INVALID(ret))
>   			return -ENXIO;
> -		if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
> +		if (IS_TDX_OPERAND_BUSY(ret))

After the changes in tdx_mcall_get_report0() and tdx_mcall_extend_rtmr(), the
macros defined in arch/x86/coco/tdx/tdx.c can be removed:

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 7b2833705d47..f72b7dfdacd1 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -33,11 +33,6 @@
  #define VE_GET_PORT_NUM(e)     ((e) >> 16)
  #define VE_IS_IO_STRING(e)     ((e) & BIT(4))

-/* TDX Module call error codes */
-#define TDCALL_RETURN_CODE(a)  ((a) >> 32)
-#define TDCALL_INVALID_OPERAND 0xc0000100
-#define TDCALL_OPERAND_BUSY    0x80000200
-
  #define TDREPORT_SUBTYPE_0     0

  static atomic_long_t nr_shared;

>   			return -EBUSY;
>   		return -EIO;
>   	}
> @@ -316,7 +316,7 @@ static void reduce_unnecessary_ve(void)
>   {
>   	u64 err = tdg_vm_wr(TDCS_TD_CTLS, TD_CTLS_REDUCE_VE, TD_CTLS_REDUCE_VE);
>   
> -	if (err == TDX_SUCCESS)
> +	if (IS_TDX_SUCCESS(err))
>   		return;
>   
>   	/*
> diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm/shared/tdx_errno.h
> index 3aa74f6a6119..e302aed31b50 100644
> --- a/arch/x86/include/asm/shared/tdx_errno.h
> +++ b/arch/x86/include/asm/shared/tdx_errno.h
> @@ -5,7 +5,7 @@
>   #include <asm/trapnr.h>
>   
>   /* Upper 32 bit of the TDX error code encodes the status */
> -#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
> +#define TDX_STATUS_MASK				0xFFFFFFFF00000000ULL
>   
>   /*
>    * TDX SEAMCALL Status Codes
> @@ -54,4 +54,49 @@
>   #define TDX_OPERAND_ID_SEPT			0x92
>   #define TDX_OPERAND_ID_TD_EPOCH			0xa9
>   
> +#ifndef __ASSEMBLER__
> +#include <linux/bits.h>
> +#include <linux/types.h>
> +
> +static inline u64 TDX_STATUS(u64 err)
> +{
> +	return err & TDX_STATUS_MASK;
> +}

Should be tagged with __always_inline since it's used in noinstr range.

[...]

