Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400177CC4D2
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343819AbjJQNek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343642AbjJQNej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:34:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F26F0;
        Tue, 17 Oct 2023 06:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697549678; x=1729085678;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ar0hHvQvp5BFk8tVIHGjdWvXPxmhKvWwhrPxeliAhfE=;
  b=TcEpRaS6vWObVnrtBzjLkhzX9Gn7uH6Q4ndMDu1y+tSMlK3iFBoInoAd
   K9Jyog0H6fKQxewzqdzS2bloe8GDzKpN+2wLP1agXBl2tSX7ahDOJDKZH
   FxlolW7yf3yY25w9DGxpmYT9KK8V5map5vjRAPDUDW35EB69Wmmrs558S
   wXYGWV9KTIl6rYDINwQc5jEXRE52IiFwmwciQ8AU/tfe+pVYXPSP7B7IZ
   e1S7pdJw5mmeLDEc/W4RiCKvJiMDSejGRYxgkApa3GjwJHSzIHJU/SYdJ
   4kCSbazK4Pt8U6uKwb//kBw1O0KZPSBA6xMbF44Z4zoa9OoB+hkcHHAV+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="383005035"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="383005035"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 06:34:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="1087502716"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="1087502716"
Received: from nmdsouza-mobl1.amr.corp.intel.com (HELO [10.209.106.102]) ([10.209.106.102])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 06:34:35 -0700
Message-ID: <736a6745-3ba7-4a0e-a00c-bb36fa1cc51c@linux.intel.com>
Date:   Tue, 17 Oct 2023 06:34:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 05/23] x86/virt/tdx: Handle SEAMCALL no entropy error
 in common code
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        nik.borisov@suse.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com
References: <cover.1697532085.git.kai.huang@intel.com>
 <cf05bd02c7d33375965c2647ce3689ae786aa97d.1697532085.git.kai.huang@intel.com>
From:   Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <cf05bd02c7d33375965c2647ce3689ae786aa97d.1697532085.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/17/2023 3:14 AM, Kai Huang wrote:
> Some SEAMCALLs use the RDRAND hardware and can fail for the same reasons
> as RDRAND.  Use the kernel RDRAND retry logic for them.
> 
> There are three __seamcall*() variants.  Do the SEAMCALL retry in common
> code and add a wrapper for each of them.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirll.shutemov@linux.intel.com>
> ---
> 
> v13 -> v14:
>  - Use real function sc_retry() instead of using macros. (Dave)
>  - Added Kirill's tag.
> 
> v12 -> v13:
>  - New implementation due to TDCALL assembly series.
> ---

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com

>  arch/x86/include/asm/tdx.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index a252328734c7..d624aa25aab0 100644
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
> @@ -82,6 +87,27 @@ u64 __seamcall(u64 fn, struct tdx_module_args *args);
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
> +
> +	return ret;
> +}
> +
> +#define seamcall(_fn, _args)		sc_retry(__seamcall, (_fn), (_args))
> +#define seamcall_ret(_fn, _args)	sc_retry(__seamcall_ret, (_fn), (_args))
> +#define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
> +
>  bool platform_tdx_enabled(void);
>  #else
>  static inline bool platform_tdx_enabled(void) { return false; }

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
