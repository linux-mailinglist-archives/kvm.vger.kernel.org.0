Return-Path: <kvm+bounces-1694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F587EB6DC
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 20:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C26461F25806
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 19:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F29D26AD3;
	Tue, 14 Nov 2023 19:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iq1ob1uo"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C394126AC2
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 19:24:50 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A070FB;
	Tue, 14 Nov 2023 11:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699989889; x=1731525889;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DXy0hru+i9t5YWHtrQTgBmZudCR2V4Ap0+DZIcK0UDg=;
  b=Iq1ob1uoPi5gWsayo5Vu/4+/hdCVg/KJsOtbaG9/E3mR4LSy01i/QjAY
   fi850irN6P6bLm+0wX5kfKsC96qinPqsTRLcvhFsEYabiD1LmPTvUtU/l
   ZaiSIkI5zDejvoZIqSfIWsRl+53elTt5Pt4nyZ6zGobBdf4pRsPuYiMf9
   B1FS5pDlOejxDmlBDoNB0eol6czIZP+mSi3cQza1Q9+4pERjR5h9COaXh
   NwbHrUg12aRbg7m3GVHoQLLOXHM55EqgxgVGdjLJF9mpAwPzOLXo2veUQ
   Kir14HhEvCTeAxp/LaDSxdzB9T1hoO/2SnsJStPxxBYDMlT3uQAOgrsds
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="3800376"
X-IronPort-AV: E=Sophos;i="6.03,302,1694761200"; 
   d="scan'208";a="3800376"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 11:24:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="938221085"
X-IronPort-AV: E=Sophos;i="6.03,302,1694761200"; 
   d="scan'208";a="938221085"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 11:24:48 -0800
Date: Tue, 14 Nov 2023 11:24:47 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
	peterz@infradead.org, tony.luck@intel.com, tglx@linutronix.de,
	bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
	dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
	isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
	bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v15 05/23] x86/virt/tdx: Handle SEAMCALL no entropy error
 in common code
Message-ID: <20231114192447.GA1109547@ls.amr.corp.intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9565b2ccc347752607039e036fd8d19d78401b53.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9565b2ccc347752607039e036fd8d19d78401b53.1699527082.git.kai.huang@intel.com>

On Fri, Nov 10, 2023 at 12:55:42AM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> Some SEAMCALLs use the RDRAND hardware and can fail for the same reasons
> as RDRAND.  Use the kernel RDRAND retry logic for them.
> 
> There are three __seamcall*() variants.  Do the SEAMCALL retry in common
> code and add a wrapper for each of them.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirll.shutemov@linux.intel.com>
> Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> ---
> 
> v14 -> v15:
>  - Added Sathy's tag.
> 
> v13 -> v14:
>  - Use real function sc_retry() instead of using macros. (Dave)
>  - Added Kirill's tag.
> 
> v12 -> v13:
>  - New implementation due to TDCALL assembly series.
> 
> ---
>  arch/x86/include/asm/tdx.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index ea9a0320b1f8..f1c0c15469f8 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -24,6 +24,11 @@
>  #define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
>  #define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
>  
> +/*
> + * TDX module SEAMCALL leaf function error codes
> + */
> +#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
> +
>  #ifndef __ASSEMBLY__
>  
>  /*
> @@ -84,6 +89,27 @@ u64 __seamcall(u64 fn, struct tdx_module_args *args);
>  u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
>  u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
>  
> +#include <asm/archrandom.h>
> +
> +typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);
> +
> +static inline u64 sc_retry(sc_func_t func, u64 fn,
> +			   struct tdx_module_args *args)
> +{
> +	int retry = RDRAND_RETRY_LOOPS;
> +	u64 ret;
> +
> +	do {
> +		ret = func(fn, args);
> +	} while (ret == TDX_RND_NO_ENTROPY && --retry);

This loop assumes that args isn't touched when TDX_RND_NO_ENTRYPOY is returned.
It's not true.  TDH.SYS.INIT() and TDH.SYS.LP.INIT() clear RCX, RDX, etc on
error including TDX_RND_NO_ENTRY.  Because TDH.SYS.INIT() takes RCX as input,
this wrapper doesn't work.  TDH.SYS.LP.INIT() doesn't use RCX, RDX ... as
input. So it doesn't matter.

Other SEAMCALLs doesn't touch registers on the no entropy error.
TDH.EXPORTS.STATE.IMMUTABLE(), TDH.IMPORTS.STATE.IMMUTABLE(), TDH.MNG.ADDCX(),
and TDX.MNG.CREATE().  TDH.SYS.INIT() is an exception.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

