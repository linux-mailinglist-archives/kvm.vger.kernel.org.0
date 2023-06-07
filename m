Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B8B7262BA
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 16:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240578AbjFGOY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 10:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbjFGOY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 10:24:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0DF1BCA;
        Wed,  7 Jun 2023 07:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686147866; x=1717683866;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sUWkSxgwBsXAkdU4ldyR6gvwpsyhLGUlWvmJEX9acQQ=;
  b=DwEUNvfX0BvOVILen/1cCNrcOjFgyO5tzUaRTtw7z/5UtpNUZ57RrguV
   tQP88sLIKnF1iFXxf6suuV8gV8sDFa7NO21XErAOicVt/Wrm69uwVRSTv
   3qnoH3rxv4COmYDvSQf+xDONJhDOX75QFvWQlDlfAyb+C8jLWKK99vVqj
   YjH+iQxun/h4vWYPGQrvMj47z4mjFR7vh2HaJuBsPCDXoo0W3kyoidW6T
   SJ9L+cspSK8FD2mP/WxT7F1xGSksx5PO4NgxQYG+9UmLpOJam1xieYu56
   y7OKsEsC7u+G4FkKtF7x/oq1VCxEYMJcG7EhuB7nTO7UCO4LCOnCr06NV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="357011482"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="357011482"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 07:24:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="799394117"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="799394117"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 07:24:24 -0700
Message-ID: <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
Date:   Wed, 7 Jun 2023 07:24:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/23 07:27, Kai Huang wrote:
> TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).  This
> mode runs only the TDX module itself or other code to load the TDX
> module.
> 
> The host kernel communicates with SEAM software via a new SEAMCALL
> instruction.  This is conceptually similar to a guest->host hypercall,
> except it is made from the host to SEAM software instead.  The TDX
> module establishes a new SEAMCALL ABI which allows the host to
> initialize the module and to manage VMs.
> 
> Add infrastructure to make SEAMCALLs.  The SEAMCALL ABI is very similar
> to the TDCALL ABI and leverages much TDCALL infrastructure.
> 
> SEAMCALL instruction causes #GP when TDX isn't BIOS enabled, and #UD
> when CPU is not in VMX operation.  Currently, only KVM code mocks with

"mocks"?  Did you mean "mucks"?

> VMX enabling, and KVM is the only user of TDX.  This implementation
> chooses to make KVM itself responsible for enabling VMX before using
> TDX and let the rest of the kernel stay blissfully unaware of VMX.
> 
> The current TDX_MODULE_CALL macro handles neither #GP nor #UD.  The
> kernel would hit Oops if SEAMCALL were mistakenly made w/o enabling VMX
> first.  Architecturally, there is no CPU flag to check whether the CPU
> is in VMX operation.  Also, if a BIOS were buggy, it could still report
> valid TDX private KeyIDs when TDX actually couldn't be enabled.

I'm not sure this is a great justification.  If the BIOS is lying to the
OS, we _should_ oops.

How else can this happen other than silly kernel bugs.  It's OK to oops
in the face of silly kernel bugs.

...
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 4dfe2e794411..b489b5b9de5d 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -8,6 +8,8 @@
>  #include <asm/ptrace.h>
>  #include <asm/shared/tdx.h>
>  
> +#include <asm/trapnr.h>
> +
>  /*
>   * SW-defined error codes.
>   *
> @@ -18,6 +20,9 @@
>  #define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
>  #define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
>  
> +#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
> +#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
> +
>  #ifndef __ASSEMBLY__
>  
>  /* TDX supported page sizes from the TDX module ABI. */
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
> index 2d91e7120c90..e82713dd5d54 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -12,14 +12,70 @@
>  #include <linux/init.h>
>  #include <linux/errno.h>
>  #include <linux/printk.h>
> +#include <linux/smp.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/tdx.h>
> +#include "tdx.h"
>  
>  static u32 tdx_global_keyid __ro_after_init;
>  static u32 tdx_guest_keyid_start __ro_after_init;
>  static u32 tdx_nr_guest_keyids __ro_after_init;
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
> +	int cpu, ret = 0;
> +	u64 sret;
> +
> +	/* Need a stable CPU id for printing error message */
> +	cpu = get_cpu();
> +
> +	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +
> +	/* Save SEAMCALL return code if the caller wants it */
> +	if (seamcall_ret)
> +		*seamcall_ret = sret;
> +
> +	/* SEAMCALL was successful */
> +	if (!sret)
> +		goto out;
> +
> +	switch (sret) {
> +	case TDX_SEAMCALL_GP:
> +		pr_err_once("[firmware bug]: TDX is not enabled by BIOS.\n");
> +		ret = -ENODEV;
> +		break;
> +	case TDX_SEAMCALL_VMFAILINVALID:
> +		pr_err_once("TDX module is not loaded.\n");
> +		ret = -ENODEV;
> +		break;
> +	case TDX_SEAMCALL_UD:
> +		pr_err_once("SEAMCALL failed: CPU %d is not in VMX operation.\n",
> +				cpu);
> +		ret = -EINVAL;
> +		break;
> +	default:
> +		pr_err_once("SEAMCALL failed: CPU %d: leaf %llu, error 0x%llx.\n",
> +				cpu, fn, sret);
> +		if (out)
> +			pr_err_once("additional output: rcx 0x%llx, rdx 0x%llx, r8 0x%llx, r9 0x%llx, r10 0x%llx, r11 0x%llx.\n",
> +					out->rcx, out->rdx, out->r8,
> +					out->r9, out->r10, out->r11);
> +		ret = -EIO;
> +	}
> +out:
> +	put_cpu();
> +	return ret;
> +}

This fails to distinguish two very different things:

 * A SEAMCALL error
and
 * A SEAMCALL *failure*

"Errors" are normal.  Hypercalls can return errors and so can SEAMCALLs.
 No biggie.

But SEAMCALL failures are another matter.  They mean that something
really fundamental is *BROKEN*.

Just saying "SEAMCALL was successful" is a bit ambiguous for me.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> new file mode 100644
> index 000000000000..48ad1a1ba737
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _X86_VIRT_TDX_H
> +#define _X86_VIRT_TDX_H
> +
> +#include <linux/types.h>
> +
> +struct tdx_module_output;
> +u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +	       struct tdx_module_output *out);
> +#endif
> diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> index 49a54356ae99..757b0c34be10 100644
> --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <asm/asm-offsets.h>
>  #include <asm/tdx.h>
> +#include <asm/asm.h>
>  
>  /*
>   * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
> @@ -45,6 +46,7 @@
>  	/* Leave input param 2 in RDX */
>  
>  	.if \host
> +1:
>  	seamcall
>  	/*
>  	 * SEAMCALL instruction is essentially a VMExit from VMX root
> @@ -57,10 +59,23 @@
>  	 * This value will never be used as actual SEAMCALL error code as
>  	 * it is from the Reserved status code class.
>  	 */
> -	jnc .Lno_vmfailinvalid
> +	jnc .Lseamcall_out
>  	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
> -.Lno_vmfailinvalid:
> +	jmp .Lseamcall_out
> +2:
> +	/*
> +	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
> +	 * the trap number.  Convert the trap number to the TDX error
> +	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
> +	 *
> +	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
> +	 * only accepts 32-bit immediate at most.
> +	 */
> +	mov $TDX_SW_ERROR, %r12
> +	orq %r12, %rax

I think the justification for doing the #UD/#GP handling is a bit weak.
In the end, it gets us a nicer error message.  Is that error message
*REALLY* needed?  Or is an oops OK in the very rare circumstance that
the BIOS is totally buggy?

