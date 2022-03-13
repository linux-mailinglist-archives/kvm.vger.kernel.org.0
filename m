Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B54D789C
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 23:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbiCMWnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 18:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiCMWnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 18:43:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0055774DD7;
        Sun, 13 Mar 2022 15:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647211348; x=1678747348;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cyiTK7byaZJ6qM8AR155i2GjEMQZs5N+uOLkdJTzm0o=;
  b=iHVftaLxOWQnr98yeP0hNhwEX2Rets0TvaMMbZdQzKT8PAiacapM00R3
   xGu3svvyPlwCXFB5XsvU9b4wwOZXHa7Dq/xeK7owT1TbdkkvTyxalOCi8
   Q5mJLxFE40OqYLYcsDiR8l0nQGykaTPWi3zXBumZGiMqu7k7zUEju8NHC
   NpwOFzWj9s9l9coR1w5rJlXDiSN2Js8J5/n8aTXpaETXQaTSKKy7hi20l
   HaCJHWJLZgzkqejaF2nv/no4BaaBAvSUypZQd5LmO6P5JwT4c7UTXuwnX
   DGlQI3L12CS8CowkyxQ5VThnnAGKSK+TeJNdUOVa9aiOFuwM7+DaIbhJ/
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="238074935"
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="238074935"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 15:42:28 -0700
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="549012627"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 15:42:26 -0700
Message-ID: <292e56e9b2050a1e8c7d64ff3f4ccaf0593a3deb.camel@intel.com>
Subject: Re: [RFC PATCH v5 014/104] KVM: TDX: Add a function for KVM to
 invoke SEAMCALL
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        kirill.shutemov@linux.intel.com
Date:   Mon, 14 Mar 2022 11:42:24 +1300
In-Reply-To: <355f08931d2b1917fd7230393de6f1052bf6f0c9.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <355f08931d2b1917fd7230393de6f1052bf6f0c9.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add an assembly function for KVM to call the TDX module because __seamcall
> defined in arch/x86/virt/vmx/seamcall.S doesn't fit for the KVM use case.
> 
> TDX module API returns extended error information in registers, rcx, rdx,
> r8, r9, r10, and r11 in addition to success case.  KVM uses those extended
> error information in addition to the status code returned in RAX.  Update
> the assembly code to optionally return those outputs even in the error case
> and define the specific version for KVM to call the TDX module.

+Kirill.

Kirill's patches hasn't been merged yet.  Can Kirill just change his patch so
you don't have to change the assembly code again?  Btw this change is
reasonable for host kernel support series as well.  Sorry that I failed to
notice.

Btw, SEAMCALL C function is already implemented in host kernel support series:

https://lore.kernel.org/kvm/269a053607357eedd9a1e8ddf0e7240ae0c3985c.1647167475.git.kai.huang@intel.com/

I think maybe you can just export __seamcall() and use it?

> 
> SEAMCALL to the SEAM module (P-SEAMLDR or TDX module) can result in the
> error of VmFailInvalid indicated by CF=1 when VMX isn't enabled by VMXON
> instruction.  Because KVM guarantees that VMX is enabled, VmFailInvalid
> error won't happen.  Don't check the error for KVM.

Perhaps you can introduce kvm_seamcall() which calls __seamcall(), but WARN()
if it returns VMfailInvalid?

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/Makefile       |  2 +-
>  arch/x86/kvm/vmx/seamcall.S | 55 +++++++++++++++++++++++++++++++++++++
>  arch/x86/virt/tdxcall.S     |  8 ++++--
>  3 files changed, 62 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/seamcall.S
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index e2c05195cb95..e8f83a7d0dc3 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -24,7 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
>  kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>  			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
>  kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> -kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
> +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/seamcall.o
>  
>  kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
>  
> diff --git a/arch/x86/kvm/vmx/seamcall.S b/arch/x86/kvm/vmx/seamcall.S
> new file mode 100644
> index 000000000000..4a15017fc7dd
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/seamcall.S
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#include <linux/linkage.h>
> +#include <asm/export.h>
> +#include <asm/frame.h>
> +
> +#include "../../virt/tdxcall.S"
> +
> +/*
> + * kvm_seamcall()  - Host-side interface functions to SEAM software (TDX module)
> + *
> + * Transform function call register arguments into the SEAMCALL register
> + * ABI.  Return the completion status of the SEAMCALL.  Additional output
> + * operands are saved in @out (if it is provided by the user).
> + * It doesn't check TDX_SEAMCALL_VMFAILINVALID unlike __semcall() because KVM
> + * guarantees that VMX is enabled so that TDX_SEAMCALL_VMFAILINVALID doesn't
> + * happen.  In the case of error completion status code, extended error code may
> + * be stored in leaf specific output registers.
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
> + * kvm_seamcall() function ABI:
> + *
> + * @fn  (RDI)          - SEAMCALL Leaf number, moved to RAX
> + * @rcx (RSI)          - Input parameter 1, moved to RCX
> + * @rdx (RDX)          - Input parameter 2, moved to RDX
> + * @r8  (RCX)          - Input parameter 3, moved to R8
> + * @r9  (R8)           - Input parameter 4, moved to R9
> + *
> + * @out (R9)           - struct tdx_module_output pointer
> + *                       stored temporarily in R12 (not
> + *                       shared with the TDX module). It
> + *                       can be NULL.
> + *
> + * Return (via RAX) the completion status of the SEAMCALL
> + */
> +SYM_FUNC_START(kvm_seamcall)
> +        FRAME_BEGIN
> +        TDX_MODULE_CALL host=1 error_check=0
> +        FRAME_END
> +        ret
> +SYM_FUNC_END(kvm_seamcall)
> +EXPORT_SYMBOL_GPL(kvm_seamcall)

> diff --git a/arch/x86/virt/tdxcall.S b/arch/x86/virt/tdxcall.S
> index 90569faedacc..2e614b6b5f1e 100644
> --- a/arch/x86/virt/tdxcall.S
> +++ b/arch/x86/virt/tdxcall.S
> @@ -13,7 +13,7 @@
>  #define tdcall		.byte 0x66,0x0f,0x01,0xcc
>  #define seamcall	.byte 0x66,0x0f,0x01,0xcf
>  
> -.macro TDX_MODULE_CALL host:req
> +.macro TDX_MODULE_CALL host:req error_check=1
>  	/*
>  	 * R12 will be used as temporary storage for struct tdx_module_output
>  	 * pointer. Since R12-R15 registers are not used by TDCALL/SEAMCALL
> @@ -51,9 +51,11 @@
>  	 *
>  	 * Set %rax to TDX_SEAMCALL_VMFAILINVALID for VMfailInvalid.
>  	 * This value will never be used as actual SEAMCALL error code.
> -	 */
> +	*/
> +	.if \error_check
>  	jnc .Lno_vmfailinvalid
>  	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
> +	.endif
>  .Lno_vmfailinvalid:
>  	.else
>  	tdcall
> @@ -66,8 +68,10 @@
>  	pop %r12
>  
>  	/* Check for success: 0 - Successful, otherwise failed */
> +	.if \error_check
>  	test %rax, %rax
>  	jnz .Lno_output_struct
> +	.endif
>  

Checking VMfailInvalid, and checking whether %rax is 0 are totally different
things.  I don't think it's good to use one single 'error_check' to handle.

As I mentioned above, I think checking whether %rax is 0 can be just removed
in Kirill's patch.  But I don't have strong opinion on whether you should add
another parameter to determine whether to check VMfailInvalid, or you should
just call __seamcall() which is implemented in host support series.

