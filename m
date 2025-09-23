Return-Path: <kvm+bounces-58507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 10019B94890
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 08:19:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E41417B2C0A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 06:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9CB30F549;
	Tue, 23 Sep 2025 06:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gL1XK90c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906059475;
	Tue, 23 Sep 2025 06:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758608383; cv=none; b=hD9zk9YiAa77uejfiybk4rNqW67Ya4iFzR6xsfcn3+E16YM1EJaGJ31g1eBbSxoCs2coJ/2UrpQKmkctQhPtYI3OVdXBGN7+SuVlj3/vcPUzXwWUhDII6KLAMOwBc1nT6Gnfi8vJ/GfouAWY3yZmnj5pNgQfVuMvBqv8BRwgl6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758608383; c=relaxed/simple;
	bh=120YyptGHYoK0PLv0LMdqjCXd04nl/mVMf5yyM6umTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YbzpdmZFCWE+kgOl2vPu7jAoH9AD2G5QHm7qGZs6aXTI9pLGYzOfWbFDWmUYJKJ6uYTCysiQKzQ+ZZfQcfZyGZGmrBZEIk52ZraWjnYprp9vn4ebVkjicLKNNnUdXirGxtRkSR7AKN2+0DJ1RcFX01mVviKKJeD+cKIJTG/HHWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gL1XK90c; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758608381; x=1790144381;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=120YyptGHYoK0PLv0LMdqjCXd04nl/mVMf5yyM6umTM=;
  b=gL1XK90cVekrCghPcy5M+3/1d2i4/VgpPKZTsbVXAPHvazDiYsmHzos9
   N17FGDGbZMHkOHxkDXb9MGYbyaKCzN4BLJkdfcSPCYClQqTYy8a4DAwyY
   Io/nd0h1ZBo5X6vTE0RB0eesJmxR4a+TVJwlzCbaVF+l2/k7+tGUugpxx
   rHN71jhpOTPCx4OKwljsG4dWbHV37JiILWwQzrigiYp0fKMc1neAPnW0S
   WyKvYoTlci4eLPuUkHAho4VkvPMMP6O5+NYWDJeGn1drONiKihLcTQIJ9
   t160sA4OPMygPItKAuzwH9yk3UBHZNNvAmIw/l3PzDc9u6nGPgIBWxlCA
   A==;
X-CSE-ConnectionGUID: ZqyBPwVXQh+oRZ4xi3FIXA==
X-CSE-MsgGUID: 9vA5hOqtQz6yVMFNVTaAGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="72240637"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="72240637"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:19:40 -0700
X-CSE-ConnectionGUID: K372GqGFT7OueReZlcaCEQ==
X-CSE-MsgGUID: CrnBlMbaQeyJSlq8x6go3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="207429272"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:19:36 -0700
Message-ID: <8d861d33-142c-464e-8dc1-14a834eaa08a@linux.intel.com>
Date: Tue, 23 Sep 2025 14:19:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kas@kernel.org, bp@alien8.de, chao.gao@intel.com,
 dave.hansen@linux.intel.com, isaku.yamahata@intel.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, x86@kernel.org, yan.y.zhao@intel.com,
 vannapurve@google.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/19/2025 7:22 AM, Rick Edgecombe wrote:
[...]
>   	/*
> diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm/shared/tdx_errno.h
> index f98924fe5198..49ab7ecc7d54 100644
> --- a/arch/x86/include/asm/shared/tdx_errno.h
> +++ b/arch/x86/include/asm/shared/tdx_errno.h
> @@ -2,8 +2,10 @@
>   #ifndef _X86_SHARED_TDX_ERRNO_H
>   #define _X86_SHARED_TDX_ERRNO_H
>   
> +#include <asm/trapnr.h>
> +
>   /* Upper 32 bit of the TDX error code encodes the status */
> -#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
> +#define TDX_STATUS_MASK				0xFFFFFFFF00000000ULL
>   
>   /*
>    * TDX SEAMCALL Status Codes
> @@ -52,4 +54,54 @@
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

TDX_STATUS() will be called in noinstr range.
I suppose __always_inline is still needed even if it's a single statement
function.

...
> @@ -903,7 +897,7 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
>   	u32 exit_reason;
>   
> -	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
> +	switch (TDX_STATUS(tdx->vp_enter_ret)) {
>   	case TDX_SUCCESS:
>   	case TDX_NON_RECOVERABLE_VCPU:
>   	case TDX_NON_RECOVERABLE_TD:
>
[...]

