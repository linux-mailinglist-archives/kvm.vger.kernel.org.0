Return-Path: <kvm+bounces-3663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 50A17806699
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 06:33:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43E34B21243
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 05:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA54D101C3;
	Wed,  6 Dec 2023 05:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ALNK88Vj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED07A1A2;
	Tue,  5 Dec 2023 21:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701840776; x=1733376776;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=L8FXHbQY2NjwwufwQG+OS1NuMlxKowjr553YIDVdUiI=;
  b=ALNK88VjO29zmz1PNvOk9hqh65pb/Puua3XgMbnPMsoO3ips5Xai4txw
   U77OEomq3tBs5Y3TCcyhY8Wgca2VFA4lZTv8DGFKviDcoHQ4i1hBXotrk
   UMCaIh0LfXx+WNGfgKZb0JTudx7riwiTUMrjuO7DXSao/nnOyAWedFl06
   3G9RauCsWhGReMHzWLpGZ3pxdUHvj9QxevKKcDZXK/TqxQRIsilndCA/x
   G8t4jlfh+sO/xNxnBb2M6IV3iTOv/7ov5tE+wYBgDQvedaYQvuip44kv3
   UCRLx4zuhUJliO9yZHZtVqmReO9PU40uKDVNFoNNNLri0o1ABH8bcINB9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="374191824"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="374191824"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 21:32:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="837203391"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="837203391"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 21:32:53 -0800
Message-ID: <d5da1688-da97-4d5b-a194-9e0a9698c1a6@linux.intel.com>
Date: Wed, 6 Dec 2023 13:32:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 012/116] KVM: TDX: Retry SEAMCALL on the lack of
 entropy error
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <a67c877521a6913911bd569c38c772ade6a1403b.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <a67c877521a6913911bd569c38c772ade6a1403b.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Some SEAMCALL may return TDX_RND_NO_ENTROPY error when the entropy is
> lacking.  Retry SEAMCALL on the error following rdrand_long() to retry
> RDRAND_RETRY_LOOPS times.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx_errno.h |  1 +
>   arch/x86/kvm/vmx/tdx_ops.h   | 40 +++++++++++++++++++++---------------
>   2 files changed, 24 insertions(+), 17 deletions(-)
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
> index 12fd6b8d49e0..a55977626ae3 100644
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
> @@ -17,25 +18,30 @@
>   static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
>   			       struct tdx_module_args *out)
>   {
> +	int retry;
>   	u64 ret;
>   
> -	if (out) {
> -		*out = (struct tdx_module_args) {
> -			.rcx = rcx,
> -			.rdx = rdx,
> -			.r8 = r8,
> -			.r9 = r9,
> -		};
> -		ret = __seamcall_ret(op, out);
> -	} else {
> -		struct tdx_module_args args = {
> -			.rcx = rcx,
> -			.rdx = rdx,
> -			.r8 = r8,
> -			.r9 = r9,
> -		};
> -		ret = __seamcall(op, &args);
> -	}
> +	/* Mimic the existing rdrand_long() to retry RDRAND_RETRY_LOOPS times. */
> +	retry = RDRAND_RETRY_LOOPS;
Nit: The value can be assigned when define.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> +	do {
> +		if (out) {
> +			*out = (struct tdx_module_args) {
> +				.rcx = rcx,
> +				.rdx = rdx,
> +				.r8 = r8,
> +				.r9 = r9,
> +			};
> +			ret = __seamcall_ret(op, out);
> +		} else {
> +			struct tdx_module_args args = {
> +				.rcx = rcx,
> +				.rdx = rdx,
> +				.r8 = r8,
> +				.r9 = r9,
> +			};
> +			ret = __seamcall(op, &args);
> +		}
> +	} while (unlikely(ret == TDX_RND_NO_ENTROPY) && --retry);
>   	if (unlikely(ret == TDX_SEAMCALL_UD)) {
>   		/*
>   		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.


