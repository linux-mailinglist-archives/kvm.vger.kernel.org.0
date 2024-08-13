Return-Path: <kvm+bounces-24035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76699950A36
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3B071F2718C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE411A255E;
	Tue, 13 Aug 2024 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ehJ/7GO8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B7419B3E3;
	Tue, 13 Aug 2024 16:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723566770; cv=none; b=U5DR4C9Fr767M398QK25l3U3EX/UV9k3BkydlLhmkymLIExR0LWWWz8FRJzZooHzLmzSkgK0etLVmOZI8ve5dJiC4+xLH4xCMzt5c+4jHK6EoBXLmE8vDu9jJmB6ReXvSoJe398uxIQOYvvdK2Pxt4c6zxFSmYVAm/sla89O41w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723566770; c=relaxed/simple;
	bh=q4Sx4tcrBOiF4T8DKZh+Bg5CmcxE+JsjM4CdKyOwO9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKxPXscfmeYSd3FUpesyJJfm0uz+Trhv9gnBRvS+dPprK9pav2ApZLMCiNLzoSo5IOkpT890k38mDRCnD0VaTO09J3isiNKS6nETKe/bQ/0dWp3jBuGjFVXEm2ChmUP0lnm3yybTo5Y0UncQrQQUnjwsIhjOxKGuZQ0y5qLC7uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ehJ/7GO8; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723566768; x=1755102768;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q4Sx4tcrBOiF4T8DKZh+Bg5CmcxE+JsjM4CdKyOwO9M=;
  b=ehJ/7GO8jGP/jGJcw+uGNShQnccHsH+5FbDadX3yoH1NUohpswqS7OVd
   k/ABGkL4zVnKj1CVw9BBydBmmdWltUdjN+MtRzAfq9SYUlX+ySDDDY2uy
   rLIk9uE7x6trnPRZwaV9nihIJ4BH0JgQA2ZYpFtdlA47SEs7eVBExqfuf
   Ic8C86z+GZSOAaudJMqaiR5vqk+l8ssf0m0VSfhBek4nlEKVACJ3MkEI6
   ysyzjtaOxOT+SJd/VLIcHEAUILyFpLd3ydUjHRPQhGsa91chTC4YREep8
   8CneQQzQQ8spXOt9gO/hg5hWezr9CpR00lkLXfoWGNyMTNqSEKu9TbzF8
   A==;
X-CSE-ConnectionGUID: kccdjhrlShWbapLEDentYA==
X-CSE-MsgGUID: RKyB6fnXS+GcHClRW9beew==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="47144448"
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="47144448"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 09:32:47 -0700
X-CSE-ConnectionGUID: Y6etry+xSha+Kk7s/65NoA==
X-CSE-MsgGUID: 8v1UOn16S2G+vLKiuadRjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="96247309"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 09:32:45 -0700
Date: Tue, 13 Aug 2024 09:32:45 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 05/25] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Message-ID: <ZruKrWWDtB+E3kwr@ls.amr.corp.intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-6-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-6-rick.p.edgecombe@intel.com>

On Mon, Aug 12, 2024 at 03:48:00PM -0700,
Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add helper functions to print out errors from the TDX module in a uniform
> manner.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> ---
> uAPI breakout v1:
> - Update for the wrapper functions for SEAMCALLs. (Sean)
> - Reorder header file include to adjust argument change of the C wrapper.
> - Fix bisectability issues in headers (Kai)
> - Updates from seamcall overhaul (Kai)
> 
> v19:
> - dropped unnecessary include <asm/tdx.h>
> 
> v18:
> - Added Reviewed-by Binbin.
> ---
>  arch/x86/kvm/vmx/tdx_ops.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index a9b9ad15f6a8..3f64c871a3f2 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -16,6 +16,21 @@
>  
>  #include "x86.h"
>  
> +#define pr_tdx_error(__fn, __err)	\
> +	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
> +
> +#define pr_tdx_error_N(__fn, __err, __fmt, ...)		\
> +	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx, " __fmt, #__fn, __err,  __VA_ARGS__)

Stringify in the inner macro results in expansion of __fn.  It means value
itself, not symbolic string.  Stringify should be in the outer macro.
"SEAMCALL 7 failed" vs "SEAMCALL TDH_MEM_RANGE_BLOCK failed"

#define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)           \
        pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)

#define pr_tdx_error_N(__fn, __err, __fmt, ...)         \
        __pr_tdx_error_N(#__fn, __err, __fmt, __VA_ARGS__)

#define pr_tdx_error_1(__fn, __err, __rcx)              \
        __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)

#define pr_tdx_error_2(__fn, __err, __rcx, __rdx)       \
        __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)

#define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8) \
        __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)


> +
> +#define pr_tdx_error_1(__fn, __err, __rcx)		\
> +	pr_tdx_error_N(__fn, __err, "rcx 0x%llx\n", __rcx)
> +
> +#define pr_tdx_error_2(__fn, __err, __rcx, __rdx)	\
> +	pr_tdx_error_N(__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
> +
> +#define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
> +	pr_tdx_error_N(__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
> +
>  static inline u64 tdh_mng_addcx(struct kvm_tdx *kvm_tdx, hpa_t addr)
>  {
>  	struct tdx_module_args in = {
> -- 
> 2.34.1
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

