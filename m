Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844AF510A9B
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352707AbiDZUiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245092AbiDZUiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:38:01 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5295D1A8C2B;
        Tue, 26 Apr 2022 13:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651005293; x=1682541293;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=seRKhyyQxbjAWS3pD/CGNEKp3GJzRdg9ieuOFomteK0=;
  b=IkZyTv2vy73rVbPEfwvdS2V37TbGGa+dD0eDZy/yYD+AkjmRkliL/YD4
   BN1nuNOJPttvJZKWZFmHTsvBx/6Cs03V6isQaCq0Cmkd2kCvvt7ixIhrE
   GdP2pF5sR1mrmnEv0V0USifHkOZpSRSztWs3YEmGfHDGQgq2RF2XP5LAl
   aP5yAORKCpaQJEzUenNspe9jJgzGmnYWH5an/SrV9LGrb+POKMYi+0oGM
   qgei5KiF4jU9l8JfFKd5HHHyK2n55LQcq6gUrfR9SjSTYTfz3qzQ6pUeO
   +zfE4ES90HpZq/3pGBRbASUOuFIokSD4FNOchWaYSrozC+FbnKybvkech
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="263306861"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="263306861"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:34:53 -0700
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="580144930"
Received: from dsocek-mobl2.amr.corp.intel.com (HELO [10.212.69.119]) ([10.212.69.119])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:34:51 -0700
Message-ID: <56f368c6-4a60-ea78-2cc7-cd2d57823e3a@intel.com>
Date:   Tue, 26 Apr 2022 13:37:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <1c3f555934c73301a9cbf10232500f3d15efe3cc.1649219184.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <1c3f555934c73301a9cbf10232500f3d15efe3cc.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 21:49, Kai Huang wrote:
> Secure Arbitration Mode (SEAM) is an extension of VMX architecture.  It
> defines a new VMX root operation (SEAM VMX root) and a new VMX non-root
> operation (SEAM VMX non-root) which are isolated from legacy VMX root
> and VMX non-root mode.

I feel like this is too much detail for an opening paragraph.

> A CPU-attested software module (called the 'TDX module') runs in SEAM
> VMX root to manage the crypto-protected VMs running in SEAM VMX non-root.
> SEAM VMX root is also used to host another CPU-attested software module
> (called the 'P-SEAMLDR') to load and update the TDX module.
>> Host kernel transits to either the P-SEAMLDR or the TDX module via the
> new SEAMCALL instruction.  SEAMCALL leaf functions are host-side
> interface functions defined by the P-SEAMLDR and the TDX module around
> the new SEAMCALL instruction.  They are similar to a hypercall, except
> they are made by host kernel to the SEAM software.

I think you can get rid of about half of this changelog so farand make
it more clear in the process with this:

	TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).
	This mode runs only the TDX module itself or other code needed
	to load the TDX module.

	The host kernel communicates with SEAM software via a new
	SEAMCALL instruction.  This is conceptually similar to
	a guest->host hypercall, except it is made from the host to SEAM
	software instead.

This is a technical document, but you're writing too technically for my
taste and focusing on the low-level details rather than the high-level
concepts.  What do I care that SEAM is two modes and what their names
are at this juncture?  Are those details necesarry to get me to
understand what a SEAMCALL is or what this patch implements?

> SEAMCALL leaf functions use an ABI different from the x86-64 system-v
> ABI.  Instead, they share the same ABI with the TDCALL leaf functions.
> %rax is used to carry both the SEAMCALL leaf function number (input) and
> the completion status code (output).  Additional GPRs (%rcx, %rdx,
> %r8->%r11) may be further used as both input and output operands in
> individual leaf functions.
> 
> Implement a C function __seamcall()

Your "C function" looks a bit like assembly to me.

> to do SEAMCALL leaf functions using
> the assembly macro used by __tdx_module_call() (the implementation of
> TDCALL leaf functions).  The only exception not covered here is TDENTER
> leaf function which takes all GPRs and XMM0-XMM15 as both input and
> output.  The caller of TDENTER should implement its own logic to call
> TDENTER directly instead of using this function.

I have no idea why this paragraph is here or what it is trying to tell me.

> SEAMCALL instruction is essentially a VMExit from VMX root to SEAM VMX
> root, and it can fail with VMfailInvalid, for instance, when the SEAM
> software module is not loaded.  The C function __seamcall() returns
> TDX_SEAMCALL_VMFAILINVALID, which doesn't conflict with any actual error
> code of SEAMCALLs, to uniquely represent this case.

Again, I'm lost.  Why is this detail here?  I don't even see
TDX_SEAMCALL_VMFAILINVALID in the patch.

> diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
> index 1bd688684716..fd577619620e 100644
> --- a/arch/x86/virt/vmx/tdx/Makefile
> +++ b/arch/x86/virt/vmx/tdx/Makefile
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o
> +obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o seamcall.o
> diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> new file mode 100644
> index 000000000000..327961b2dd5a
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
> + * __seamcall()  - Host-side interface functions to SEAM software module
> + *		   (the P-SEAMLDR or the TDX module)
> + *
> + * Transform function call register arguments into the SEAMCALL register
> + * ABI.  Return TDX_SEAMCALL_VMFAILINVALID, or the completion status of
> + * the SEAMCALL.  Additional output operands are saved in @out (if it is
> + * provided by caller).

This needs to say:

	Returns TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself fails.

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
> +	ret
> +SYM_FUNC_END(__seamcall)
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> new file mode 100644
> index 000000000000..9d5b6f554c20
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -0,0 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _X86_VIRT_TDX_H
> +#define _X86_VIRT_TDX_H
> +
> +#include <linux/types.h>
> +
> +struct tdx_module_output;
> +u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +	       struct tdx_module_output *out);
> +
> +#endif

