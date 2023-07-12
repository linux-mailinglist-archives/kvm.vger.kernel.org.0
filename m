Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CF8751190
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 21:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjGLT6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 15:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjGLT6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 15:58:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017F51FDE;
        Wed, 12 Jul 2023 12:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689191893; x=1720727893;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FTIt/MjK6M1o3Ym3rIGdTL/PyU4TsEtJRvxtxh04uio=;
  b=YUzbCnwpoYjyPrC2pmHsC9ONWshqv6stwqqf2RpUDcZTUmEsRBRvzV1C
   1Fmzku9ZeTY+dPzzbgrV6H1F7uDs/ZAP/OrkzYWoXflx2i/uBRLnl85Yn
   14xen1eRsuEbXWUoS1ODMHlD2FZVoh8+ZtFK33jxZbWfOgscENWmibBko
   BiUZV8z9Vw7H2KQmCeMvPSK4fJElSt+V18Kud7QqvSET6LScLvQYP2jWJ
   B89855uDbV2zEc88hKQafdKVD+Djqv5ZVQuJeqyJd702TQxUSYAUC3Awc
   kZzy2qpAkzKdrNEUFiLNQFVmQqPQERwVCXxuIXZG0tyC4M/V2h0N2x4nE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="428734625"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="428734625"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 12:57:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="791743195"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="791743195"
Received: from averypay-mobl1.amr.corp.intel.com (HELO [10.212.212.40]) ([10.212.212.40])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 12:57:53 -0700
Message-ID: <5961fe40-7716-c0fe-b399-f3f2bf39b562@linux.intel.com>
Date:   Wed, 12 Jul 2023 12:57:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH 03/10] x86/tdx: Move FRAME_BEGIN/END to TDX_MODULE_CALL
 asm macro
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, peterz@infradead.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com
References: <cover.1689151537.git.kai.huang@intel.com>
 <c0206c457f366ab007ab67ca16970cc4fc562877.1689151537.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <c0206c457f366ab007ab67ca16970cc4fc562877.1689151537.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/23 1:55 AM, Kai Huang wrote:
> Currently, the TDX_MODULE_CALL asm macro and the __tdx_module_call()
> take registers directly as input and a 'struct tdx_module_output' as
> optional output.  This is different from the __tdx_hypercall(), which
> simply uses a structure to carry all input/output.  There's no point to
> leave __tdx_module_call() complicated as it is.
> 
> As a preparation to simplify the __tdx_module_call() to make it look
> like __tdx_hypercall(), move FRAME_BEGIN/END and RET from the
> __tdx_module_call() to the TDX_MODULE_CALL assembly macro.  This also
> allows more implementation flexibility of the assembly inside the
> TDX_MODULE_CALL macro, e.g., allowing putting an _ASM_EXTABLE() after
> the main body of the assembly.
> 
> This is basically based on Peter's code.
> 
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---

Looks fine to me.

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

>  arch/x86/coco/tdx/tdcall.S      | 3 ---
>  arch/x86/virt/vmx/tdx/tdxcall.S | 5 +++++
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/coco/tdx/tdcall.S b/arch/x86/coco/tdx/tdcall.S
> index 2eca5f43734f..e5d4b7d8ecd4 100644
> --- a/arch/x86/coco/tdx/tdcall.S
> +++ b/arch/x86/coco/tdx/tdcall.S
> @@ -78,10 +78,7 @@
>   * Return status of TDCALL via RAX.
>   */
>  SYM_FUNC_START(__tdx_module_call)
> -	FRAME_BEGIN
>  	TDX_MODULE_CALL host=0
> -	FRAME_END
> -	RET
>  SYM_FUNC_END(__tdx_module_call)
>  
>  /*
> diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> index 3524915d8bd9..b5ab919c7fa8 100644
> --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> @@ -1,5 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <asm/asm-offsets.h>
> +#include <asm/frame.h>
>  #include <asm/tdx.h>
>  
>  /*
> @@ -18,6 +19,7 @@
>   *            TDX module.
>   */
>  .macro TDX_MODULE_CALL host:req
> +	FRAME_BEGIN
>  	/*
>  	 * R12 will be used as temporary storage for struct tdx_module_output
>  	 * pointer. Since R12-R15 registers are not used by TDCALL/SEAMCALL
> @@ -91,4 +93,7 @@
>  .Lno_output_struct:
>  	/* Restore the state of R12 register */
>  	pop %r12
> +
> +	FRAME_END
> +	RET
>  .endm

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
