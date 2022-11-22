Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9687B634382
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 19:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiKVSUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 13:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiKVSUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 13:20:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB16F7C45C;
        Tue, 22 Nov 2022 10:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669141246; x=1700677246;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CbRC6pSIzsPIVrroVyhHdGfXfbcf0VTlnYQ/6+PBglU=;
  b=lJbACnOIDyIcJ7DB5Dph+vA1psE3TYGryYEj31yY1LQK3odGxdk8g6Jr
   Es65lAfvAHC+Y3YnuQFXyky86+J+6EnFYrM60DxG+gCwQcJWKXQUJLtAz
   wlc6m7PiGLuMiFAwjxXioAIv+HvfgGY9YkRomjTD81ekwvfSyTjj0fyJ8
   MhNkRnxKDmmGE2bvQuiPv7lSm2aOPqbLSSo80+C+Yx8Fjnrw3D447Np8H
   aPv8SmSRkdU+z/gElcmexYqG7S8YEy9emDFH4Fmil4EuVCwfCd9CaXK9N
   X2DMyuGC45lzXfFw/u17Epe2tL3X3XirmvXXW7vAI/l9cA1k0AUJgToEf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="400173743"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="400173743"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 10:20:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="710289326"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="710289326"
Received: from coltsavx-mobl1.amr.corp.intel.com (HELO [10.255.0.114]) ([10.255.0.114])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 10:20:33 -0800
Message-ID: <c551c360-4924-c42e-d4d9-b56ad6d6e2fd@intel.com>
Date:   Tue, 22 Nov 2022 10:20:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 05/20] x86/virt/tdx: Implement functions to make
 SEAMCALL
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <5977ec3c2e682e6927ce1c33e7fcac7fcfe2d346.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <5977ec3c2e682e6927ce1c33e7fcac7fcfe2d346.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).  This
> mode runs only the TDX module itself or other code to load the TDX
> module.
> 
> The host kernel communicates with SEAM software via a new SEAMCALL
> instruction.  This is conceptually similar to a guest->host hypercall,
> except it is made from the host to SEAM software instead.
> 
> The TDX module defines a set of SEAMCALL leaf functions to allow the
> host to initialize it, and to create and run protected VMs.  SEAMCALL
> leaf functions use an ABI different from the x86-64 system-v ABI.
> Instead, they share the same ABI with the TDCALL leaf functions.

I may have suggested this along the way, but the mention of the sysv ABI
is just confusing here.  This is enough for a changelog:

	The TDX module establishes a new SEAMCALL ABI which allows the
	host to initialize the module and to and to manage VMs.

Kill the rest.

> Implement a function __seamcall() to allow the host to make SEAMCALL
> to SEAM software using the TDX_MODULE_CALL macro which is the common
> assembly for both SEAMCALL and TDCALL.

In general, I dislike mentioning function names in changelogs.  Keep
this high-level, like:

	Add infrastructure to make SEAMCALLs.  The SEAMCALL ABI is very
	similar to the TDCALL ABI and leverages much TDCALL
	infrastructure.

> SEAMCALL instruction causes #GP when SEAMRR isn't enabled, and #UD when
> CPU is not in VMX operation.  The current TDX_MODULE_CALL macro doesn't
> handle any of them.  There's no way to check whether the CPU is in VMX
> operation or not.

What is SEAMRR?

Why even mention this behavior in the changelog.  Is this a problem?
Does it have a solution?

> Initializing the TDX module is done at runtime on demand, and it depends
> on the caller to ensure CPU is in VMX operation before making SEAMCALL.
> To avoid getting Oops when the caller mistakenly tries to initialize the
> TDX module when CPU is not in VMX operation, extend the TDX_MODULE_CALL
> macro to handle #UD (and also #GP, which can theoretically still happen
> when TDX isn't actually enabled by the BIOS, i.e. due to BIOS bug).

I'm not completely sure this is worth it.  If the BIOS lies, we oops.
There are lots of ways that the BIOS lying can make the kernel oops.
What's one more?

> Introduce two new TDX error codes for #UD and #GP respectively so the
> caller can distinguish.  Also, Opportunistically put the new TDX error
> codes and the existing TDX_SEAMCALL_VMFAILINVALID into INTEL_TDX_HOST
> Kconfig option as they are only used when it is on.
> 
> As __seamcall() can potentially return multiple error codes, besides the
> actual SEAMCALL leaf function return code, also introduce a wrapper
> function seamcall() to convert the __seamcall() error code to the kernel
> error code, so the caller doesn't need to duplicate the code to check
> return value of __seamcall() and return kernel error code accordingly.


> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 05fc89d9742a..d688228f3151 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -8,6 +8,10 @@
>  #include <asm/ptrace.h>
>  #include <asm/shared/tdx.h>
>  
> +#ifdef CONFIG_INTEL_TDX_HOST
> +
> +#include <asm/trapnr.h>
> +
>  /*
>   * SW-defined error codes.
>   *
> @@ -18,6 +22,11 @@
>  #define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
>  #define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
>  
> +#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
> +#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
> +
> +#endif
> +
>  #ifndef __ASSEMBLY__
>  
>  /*
> diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
> index 93ca8b73e1f1..38d534f2c113 100644
> --- a/arch/x86/virt/vmx/tdx/Makefile
> +++ b/arch/x86/virt/vmx/tdx/Makefile
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-y += tdx.o
> +obj-y += tdx.o seamcall.o
> diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> new file mode 100644
> index 000000000000..f81be6b9c133
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#include <linux/linkage.h>
> +#include <asm/frame.h>
> +
> +#include "tdxcall.S"
> +
> +/*
> + * __seamcall() - Host-side interface functions to SEAM software module
> + *		  (the P-SEAMLDR or the TDX module).
> + *
> + * Transform function call register arguments into the SEAMCALL register
> + * ABI.  Return TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself fails,
> + * or the completion status of the SEAMCALL leaf function.  Additional
> + * output operands are saved in @out (if it is provided by the caller).
> + *
> + *-------------------------------------------------------------------------
> + * SEAMCALL ABI:
> + *-------------------------------------------------------------------------
> + * Input Registers:
> + *
> + * RAX                 - SEAMCALL Leaf number.
> + * RCX,RDX,R8-R9       - SEAMCALL Leaf specific input registers.
> + *
> + * Output Registers:
> + *
> + * RAX                 - SEAMCALL completion status code.
> + * RCX,RDX,R8-R11      - SEAMCALL Leaf specific output registers.
> + *
> + *-------------------------------------------------------------------------
> + *
> + * __seamcall() function ABI:
> + *
> + * @fn  (RDI)          - SEAMCALL Leaf number, moved to RAX
> + * @rcx (RSI)          - Input parameter 1, moved to RCX
> + * @rdx (RDX)          - Input parameter 2, moved to RDX
> + * @r8  (RCX)          - Input parameter 3, moved to R8
> + * @r9  (R8)           - Input parameter 4, moved to R9
> + *
> + * @out (R9)           - struct tdx_module_output pointer
> + *			 stored temporarily in R12 (not
> + *			 used by the P-SEAMLDR or the TDX
> + *			 module). It can be NULL.
> + *
> + * Return (via RAX) the completion status of the SEAMCALL, or
> + * TDX_SEAMCALL_VMFAILINVALID.
> + */
> +SYM_FUNC_START(__seamcall)
> +	FRAME_BEGIN
> +	TDX_MODULE_CALL host=1
> +	FRAME_END
> +	RET
> +SYM_FUNC_END(__seamcall)
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 28c187b8726f..b06c1a2bc9cb 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -124,6 +124,48 @@ bool platform_tdx_enabled(void)
>  	return !!tdx_keyid_num;
>  }
>  
> +/*
> + * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
> + * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> + * leaf function return code and the additional output respectively if
> + * not NULL.
> + */
> +static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +				    u64 *seamcall_ret,
> +				    struct tdx_module_output *out)
> +{
> +	u64 sret;
> +
> +	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +
> +	/* Save SEAMCALL return code if caller wants it */
> +	if (seamcall_ret)
> +		*seamcall_ret = sret;
> +
> +	/* SEAMCALL was successful */
> +	if (!sret)
> +		return 0;
> +
> +	switch (sret) {
> +	case TDX_SEAMCALL_GP:
> +		/*
> +		 * platform_tdx_enabled() is checked to be true
> +		 * before making any SEAMCALL.
> +		 */

This doesn't make any sense.  "platform_tdx_enabled() is checked"???

Do you mean that it *should* be checked and probably wasn't which is
what caused the error?

> +		WARN_ON_ONCE(1);
> +		fallthrough;
> +	case TDX_SEAMCALL_VMFAILINVALID:
> +		/* Return -ENODEV if the TDX module is not loaded. */
> +		return -ENODEV;

Pro tip: you don't need to rewrite code in comments.  If the code
literally says, "return -ENODEV", there is very little value in writing
virtually identical bytes "Return -ENODEV" in the comment.

