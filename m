Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DB77CC4DC
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343844AbjJQNiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQNiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:38:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8347AED;
        Tue, 17 Oct 2023 06:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697549884; x=1729085884;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=viYL9kj13UNdjdoNh4jdZRaevUW5TxFFMp38YUnZVTE=;
  b=YzPxecCErd3gTYNsA30/zrglglGiXE0l08z0BeLeyeLgqGa0yrn4xXn7
   9NZtszyCoW3fP1qh4oCjGvwO8jfV8Gylxru+Awz8bhBnjFwSYT9lkQIFp
   SDBZvt6kxp8lfz8T+jpb7uvi135QlHKc6W7gb0EY2VNwQkqJ2w+SOJt/J
   RNPiED6k3RGVpPG5DKL6a61o82Q5TRC23GNuHcFd9cR4T3+U5CrXgDhRo
   Xh/YN0nziwACAPOIAr7vbwPlTdQrxC8TnAJI0RRXfOOvp2w8QTlII+MOD
   Nf9QMhtGfGWXJ+4nF/P9DtDGytQYzTKXz4D2YXVDxiiBxoIrN94jfwjgl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="450000640"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="450000640"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 06:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="732730254"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="732730254"
Received: from nmdsouza-mobl1.amr.corp.intel.com (HELO [10.209.106.102]) ([10.209.106.102])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 06:37:50 -0700
Message-ID: <28569cea-4291-4d2c-9662-da19a6f53308@linux.intel.com>
Date:   Tue, 17 Oct 2023 06:37:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/23] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
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
 <58c44258cb5b1009f0ddfe6b07ac986b9614b8b3.1697532085.git.kai.huang@intel.com>
From:   Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <58c44258cb5b1009f0ddfe6b07ac986b9614b8b3.1697532085.git.kai.huang@intel.com>
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
> The SEAMCALLs involved during the TDX module initialization are not
> expected to fail.  In fact, they are not expected to return any non-zero
> code (except the "running out of entropy error", which can be handled
> internally already).
> 
> Add yet another set of SEAMCALL wrappers, which treats all non-zero
> return code as error, to support printing SEAMCALL error upon failure
> for module initialization.  Note the TDX module initialization doesn't
> use the _saved_ret() variant thus no wrapper is added for it.
> 
> SEAMCALL assembly can also return kernel-defined error codes for three
> special cases: 1) TDX isn't enabled by the BIOS; 2) TDX module isn't
> loaded; 3) CPU isn't in VMX operation.  Whether they can legally happen
> depends on the caller, so leave to the caller to print error message
> when desired.
> 
> Also convert the SEAMCALL error codes to the kernel error codes in the
> new wrappers so that each SEAMCALL caller doesn't have to repeat the
> conversion.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
> 
> v13 -> v14:
>  - Use real functions to replace macros. (Dave)
>  - Moved printing error message for special error code to the caller
>    (internal)
>  - Added Kirill's tag
> 
> v12 -> v13:
>  - New implementation due to TDCALL assembly series.
> 
> ---
>  arch/x86/include/asm/tdx.h  |  1 +
>  arch/x86/virt/vmx/tdx/tdx.c | 52 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index d624aa25aab0..984efd3114ed 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -27,6 +27,7 @@
>  /*
>   * TDX module SEAMCALL leaf function error codes
>   */
> +#define TDX_SUCCESS		0ULL
>  #define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
>  
>  #ifndef __ASSEMBLY__
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 13d22ea2e2d9..52fb14e0195f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -20,6 +20,58 @@ static u32 tdx_global_keyid __ro_after_init;
>  static u32 tdx_guest_keyid_start __ro_after_init;
>  static u32 tdx_nr_guest_keyids __ro_after_init;
>  
> +typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
> +
> +static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
> +{
> +	pr_err("SEAMCALL (0x%llx) failed: 0x%llx\n", fn, err);
> +}
> +

Why pass args here?

> +static inline void seamcall_err_ret(u64 fn, u64 err,
> +				    struct tdx_module_args *args)
> +{
> +	seamcall_err(fn, err, args);
> +	pr_err("RCX 0x%llx RDX 0x%llx R8 0x%llx R9 0x%llx R10 0x%llx R11 0x%llx\n",
> +			args->rcx, args->rdx, args->r8, args->r9,
> +			args->r10, args->r11);
> +}
> +
> +static inline void seamcall_err_saved_ret(u64 fn, u64 err,
> +					  struct tdx_module_args *args)
> +{
> +	seamcall_err_ret(fn, err, args);
> +	pr_err("RBX 0x%llx RDI 0x%llx RSI 0x%llx R12 0x%llx R13 0x%llx R14 0x%llx R15 0x%llx\n",
> +			args->rbx, args->rdi, args->rsi, args->r12,
> +			args->r13, args->r14, args->r15);
> +}
> +
> +static inline int sc_retry_prerr(sc_func_t func, sc_err_func_t err_func,
> +				 u64 fn, struct tdx_module_args *args)
> +{
> +	u64 sret = sc_retry(func, fn, args);
> +
> +	if (sret == TDX_SUCCESS)
> +		return 0;
> +
> +	if (sret == TDX_SEAMCALL_VMFAILINVALID)
> +		return -ENODEV;
> +
> +	if (sret == TDX_SEAMCALL_GP)
> +		return -EOPNOTSUPP;
> +
> +	if (sret == TDX_SEAMCALL_UD)
> +		return -EACCES;
> +
> +	err_func(fn, sret, args);
> +	return -EIO;
> +}
> +
> +#define seamcall_prerr(__fn, __args)						\
> +	sc_retry_prerr(__seamcall, seamcall_err, (__fn), (__args))
> +
> +#define seamcall_prerr_ret(__fn, __args)					\
> +	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
> +
>  static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
>  					    u32 *nr_tdx_keyids)
>  {

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
