Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0299E634427
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 19:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiKVS6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 13:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiKVS6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 13:58:12 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6351E85166;
        Tue, 22 Nov 2022 10:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669143478; x=1700679478;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Dy8QPCf5a8i9eyvXCeVU8Af+cGBQOxVnsTSgurdjvVA=;
  b=K0DxbbxpePpdQAqb2AwafAv0MrQ7AdT0xhVk37LVciFe7/4ABr6b/Zi5
   FGLy2FQn2I1dg45WrUdLTSfI79ZzQJF7ADit7LykQfbgIVTbeSxuui/wj
   TqhPEHNa2CZOSbPpNWLv1Kke34YM44SJ2OrfMtVq+Aarw9a95gKO1qyZr
   DqC+JCw8f51Dix66bNjS/B4zAC22+bSPzWRSUkojqAYFikjI9a8fgQ9/v
   3tkUWRL+GEIQm6i4qHDYV7UtrckNVN8sVkBJfZ/UKSpVPfIGdqGjLWiX+
   H3IEov9Uny2hw/u71avx+D8cd2uIY1KqJ6Kh77bp42Dqvkp7bS7zO6mTe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="400180987"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="400180987"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 10:57:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="766433655"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="766433655"
Received: from coltsavx-mobl1.amr.corp.intel.com (HELO [10.255.0.114]) ([10.255.0.114])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 10:57:54 -0800
Message-ID: <bea49f7f-8411-662f-9fa8-97c98f61ce8b@intel.com>
Date:   Tue, 22 Nov 2022 10:57:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
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
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
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
> TDX supports shutting down the TDX module at any time during its
> lifetime.  After the module is shut down, no further TDX module SEAMCALL
> leaf functions can be made to the module on any logical cpu.
> 
> Shut down the TDX module in case of any error during the initialization
> process.  It's pointless to leave the TDX module in some middle state.
> 
> Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
> BIOS-enabled CPUs, and the SEMACALL can run concurrently on different
> CPUs.  Implement a mechanism to run SEAMCALL concurrently on all online
> CPUs and use it to shut down the module.  Later logical-cpu scope module
> initialization will use it too.

To me, this starts to veer way too far into internal implementation details.

	Issue the TDH.SYS.LP.SHUTDOWN SEAMCALL on all BIOS-enabled CPUs
	to shut down the TDX module.

This is also the point where you should talk about the new
infrastructure.  Why do you need a new 'struct seamcall_something'?
What makes it special?

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index b06c1a2bc9cb..5db1a05cb4bd 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -13,6 +13,8 @@
>  #include <linux/mutex.h>
>  #include <linux/cpu.h>
>  #include <linux/cpumask.h>
> +#include <linux/smp.h>
> +#include <linux/atomic.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/apic.h>
> @@ -124,15 +126,27 @@ bool platform_tdx_enabled(void)
>  	return !!tdx_keyid_num;
>  }
>  
> +/*
> + * Data structure to make SEAMCALL on multiple CPUs concurrently.
> + * @err is set to -EFAULT when SEAMCALL fails on any cpu.
> + */
> +struct seamcall_ctx {
> +	u64 fn;
> +	u64 rcx;
> +	u64 rdx;
> +	u64 r8;
> +	u64 r9;
> +	atomic_t err;
> +};
> +
>  /*
>   * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
>   * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
>   * leaf function return code and the additional output respectively if
>   * not NULL.
>   */
> -static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> -				    u64 *seamcall_ret,
> -				    struct tdx_module_output *out)
> +static int seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +		    u64 *seamcall_ret, struct tdx_module_output *out)
>  {
>  	u64 sret;
>  
> @@ -166,6 +180,25 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	}
>  }
>  
> +static void seamcall_smp_call_function(void *data)
> +{
> +	struct seamcall_ctx *sc = data;
> +	int ret;
> +
> +	ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9, NULL, NULL);
> +	if (ret)
> +		atomic_set(&sc->err, -EFAULT);
> +}

The atomic_t is kinda silly.  I guess it's not *that* wasteful though.

I think it would have actually been a lot more clear if instead of
containing an errno it was a *count* of the number of encountered errors.

An "atomic_set()" where everyone is overwriting each other is a bit
counterintuitive.  It's OK here, of course, but it still looks goofy.

If this were:

	atomic_inc(&sc->nr_errors);

it would be a lot more clear that *anyone* can increment and that it
truly is shared.

> +/*
> + * Call the SEAMCALL on all online CPUs concurrently.  Caller to check
> + * @sc->err to determine whether any SEAMCALL failed on any cpu.
> + */
> +static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
> +{
> +	on_each_cpu(seamcall_smp_call_function, sc, true);
> +}
> +
>  /*
>   * Detect and initialize the TDX module.
>   *
> @@ -181,7 +214,9 @@ static int init_tdx_module(void)
>  
>  static void shutdown_tdx_module(void)
>  {
> -	/* TODO: Shut down the TDX module */
> +	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_SHUTDOWN };
> +
> +	seamcall_on_each_cpu(&sc);
>  }


The seamcall_on_each_cpu() function is silly as-is.  Either collapse the
functions or note in the changelog why this is not as silly as it looks.

>  static int __tdx_enable(void)
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 92a8de957dc7..215cc1065d78 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -12,6 +12,11 @@
>  /* MSR to report KeyID partitioning between MKTME and TDX */
>  #define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
>  
> +/*
> + * TDX module SEAMCALL leaf functions
> + */
> +#define TDH_SYS_LP_SHUTDOWN	44
> +
>  /*
>   * Do not put any hardware-defined TDX structure representations below
>   * this comment!

