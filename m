Return-Path: <kvm+bounces-6723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D81048388F8
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 09:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDE48B2284F
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 08:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE37E5731D;
	Tue, 23 Jan 2024 08:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TdhLtcEX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE875676C;
	Tue, 23 Jan 2024 08:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705998754; cv=none; b=ql/GmwL2QiOxtxyhBC75/Tg8zeeRq+9Pl/fjGN+CPYq5f9gqQh4TSSODxd5/frWopR5H8EVjii/DwIsHP4p6MxuYEnzAR4Y9oNg3Cd3JeGeFH+EAbGq/QvigjWagZ3iby8Gx3O/yiwCL3/fvaOBZ6dRt8iLJdiHsLs5B+GjnuOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705998754; c=relaxed/simple;
	bh=4MYkW78c04363Tb5/aRRLw1xwUWwRKc1h7leOKSHZbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IEDkKInuN2JFks1h4bBZ1hfBB6xh0ajdfqh2u/1lP+HCMe2NYbFGfcM5Au0NErxj1/eqRKc8HrbSM9y6Wx8Gr+2yAoPYNp78ym1u8HXXdDCyxeu0vlXRcNSoJh8tviFhno6gV8zNLbbS2WWfXUBb6Oi+HRHN5io8f4EG/b/E49o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TdhLtcEX; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705998753; x=1737534753;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4MYkW78c04363Tb5/aRRLw1xwUWwRKc1h7leOKSHZbQ=;
  b=TdhLtcEXlWOAWnYOr5m7AoeSBwhVPZBHLEw6FekXUpApDECwMAfRpFz9
   lZrYXbgoVr3xMz8dMs8A0BVr43E9P29T2fbeGc+DQlMhFiE+8/jY7ASvC
   ZhTFa5xyNZUbUFV6ANfPy52OK6L+MIalWa9+7Lnfi14hiU+25dwjAyAiP
   4uHZp2kcOHsDCpqENKDg7lu9HNdPY+OcWclf0hnng3/zN6gZXZOvUHjwR
   N7aGIzDqKJbPUrhAziMj/XUjk0s5WpUWL37RXsPuo8lFDZetGUZon6LBb
   c9tpgvffd46VIFWV+cYZ+69+HL8CFlDya7Y5NfbQbYoTBX3e8bGfKKTnX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="398603870"
X-IronPort-AV: E=Sophos;i="6.05,213,1701158400"; 
   d="scan'208";a="398603870"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 00:32:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="909222387"
X-IronPort-AV: E=Sophos;i="6.05,213,1701158400"; 
   d="scan'208";a="909222387"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.92]) ([10.93.8.92])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 00:32:27 -0800
Message-ID: <03e3eb4c-1d7e-4f24-8d5c-1f48f1d6f81f@linux.intel.com>
Date: Tue, 23 Jan 2024 16:32:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 015/121] KVM: TDX: Retry SEAMCALL on the lack of
 entropy error
To: isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <a4d44b01523c935595c8ee00622ab8766e269ef4.1705965634.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <a4d44b01523c935595c8ee00622ab8766e269ef4.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Some SEAMCALL may return TDX_RND_NO_ENTROPY error when the entropy is
> lacking.  Retry SEAMCALL on the error following rdrand_long() to retry
> RDRAND_RETRY_LOOPS times.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - update to use struct tdx_modules_args for inputs.
> ---
>   arch/x86/kvm/vmx/tdx_errno.h |  1 +
>   arch/x86/kvm/vmx/tdx_ops.h   | 15 +++++++++++----
>   2 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> index 7f96696b8e7c..bb093e292fef 100644
> --- a/arch/x86/kvm/vmx/tdx_errno.h
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -14,6 +14,7 @@
>   #define TDX_OPERAND_INVALID			0xC000010000000000ULL
>   #define TDX_OPERAND_BUSY			0x8000020000000000ULL
>   #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
> +#define TDX_RND_NO_ENTROPY			0x8000020300000000ULL
>   #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
>   #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
>   #define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index 0e26cf22240e..f4c16e5265f0 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -6,6 +6,7 @@
>   
>   #include <linux/compiler.h>
>   
> +#include <asm/archrandom.h>
>   #include <asm/cacheflush.h>
>   #include <asm/asm.h>
>   #include <asm/kvm_host.h>
> @@ -17,14 +18,20 @@
>   static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
>   			       struct tdx_module_args *out)
>   {
> +	struct tdx_module_args args;
> +	int retry;
>   	u64 ret;
>   
> -	if (out) {
> +	if (!out)
> +		out = &args;
> +
> +	/* Mimic the existing rdrand_long() to retry RDRAND_RETRY_LOOPS times. */
> +	retry = RDRAND_RETRY_LOOPS;
> +	do {
> +		/* As __seamcall_ret() overwrites out, init out on each loop. */
>   		*out = *in;
>   		ret = __seamcall_ret(op, out);
> -	} else
> -		ret = __seamcall(op, in);
> -
> +	} while (unlikely(ret == TDX_RND_NO_ENTROPY) && --retry);
>   	if (unlikely(ret == TDX_SEAMCALL_UD)) {
>   		/*
>   		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
One question is when the return code is TDX_RND_NO_ENTROPY, does the input
tdx_module_args value will be modified or not?

As mentioned by Kai in previous review, there are seamcall*() variants which
handle TDX_RND_NO_ENTROPY already.

If the input tdx_module_args is not modified by a seamcall when the return
code is TDX_RND_NO_ENTROPY, the seamcall_ret() can be used directly.

But if the input tdx_module_args could be modified by a seamcall when the
return code is TDX_RND_NO_ENTROPY, the implementations of seamcall_ret() and
seamcall_saved_ret() have problem then, because the input tdx_module_args is
not re-initialized when retry.
They need to be fixed or deleted (no one is using them currently).



