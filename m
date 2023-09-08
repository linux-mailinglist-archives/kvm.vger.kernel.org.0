Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE550798A9A
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 18:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbjIHQV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 12:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbjIHQV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 12:21:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EA9CFA;
        Fri,  8 Sep 2023 09:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694190083; x=1725726083;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=e873u3sibJs0xbxxhRsYnTPnv8uBch+24bj/ve5sdac=;
  b=ZbN7KW9rlrnvvbueH6+qqzrTIGASq4npZkEgtr/WMqTrnQK+JNzTVTcp
   hs5TpfcnMI2YpOEbVGZNmCtvXovvaqaqXkdGL+dFffS4k67sd+2pehvni
   DxJE+NGu7iKULHX4frfCIMMypSLOhHOX3T8rD9LNC9HnQXYb2qBkzjfE+
   aWoWJL5iVk0hzn+b+cALneOursXl+1v22KW+9w6nehqGrdNuS//t29LQw
   +zDrricHYi00+KB2XtrKRqjGcVgkjQ8+MKtzNe8ow5eJiw6FvdxLR98jd
   oe4pC7/8H8jVpI7JIpVeUPcWOyxmcRHCtW0qVUHl5V3oxm3brKs+w7fnT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="441699731"
X-IronPort-AV: E=Sophos;i="6.02,237,1688454000"; 
   d="scan'208";a="441699731"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 09:21:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="808068882"
X-IronPort-AV: E=Sophos;i="6.02,237,1688454000"; 
   d="scan'208";a="808068882"
Received: from fgilganx-mobl1.amr.corp.intel.com (HELO [10.209.17.195]) ([10.209.17.195])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 09:21:20 -0700
Message-ID: <0676101a-e781-81e0-2e0f-7f5e72595e5c@intel.com>
Date:   Fri, 8 Sep 2023 09:21:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v13 05/22] x86/virt/tdx: Handle SEAMCALL no entropy error
 in common code
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1692962263.git.kai.huang@intel.com>
 <c945c9a8db98b7a304c404a7ef18aa2f7770ffaf.1692962263.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <c945c9a8db98b7a304c404a7ef18aa2f7770ffaf.1692962263.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/23 05:14, Kai Huang wrote:
> Some SEAMCALLs use the RDRAND hardware and can fail for the same reasons
> as RDRAND.  Use the kernel RDRAND retry logic for them.
> 
> There are three __seamcall*() variants.  Add a macro to do the SEAMCALL
> retry in the common code and define a wrapper for each __seamcall*()
> variant.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v12 -> v13:
>  - New implementation due to TDCALL assembly series.
> 
> ---
>  arch/x86/include/asm/tdx.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index a252328734c7..cfae8b31a2e9 100644
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
> @@ -82,6 +87,28 @@ u64 __seamcall(u64 fn, struct tdx_module_args *args);
>  u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
>  u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
>  
> +#include <asm/archrandom.h>
> +
> +#define SEAMCALL_NO_ENTROPY_RETRY(__seamcall_func, __fn, __args)	\
> +({									\
> +	int ___retry = RDRAND_RETRY_LOOPS;				\
> +	u64 ___sret;							\
> +									\
> +	do {								\
> +		___sret = __seamcall_func((__fn), (__args));		\
> +	} while (___sret == TDX_RND_NO_ENTROPY && --___retry);		\
> +	___sret;							\
> +})

This is a *LOT* less eye-bleedy if you do it without macros:


typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);

static inline
u64 sc_retry(sc_func_t func, u64 fn, struct tdx_module_args *args)
{
        int retry = RDRAND_RETRY_LOOPS;
        u64 ret;

        do {
                ret = func(fn, args);
        } while (ret == TDX_RND_NO_ENTROPY && --retry);

        return ret;
}

#define seamcall(_fn, _args)           sc_retry(_seamcall,
(_fn), (_args))
#define seamcall_ret(_fn, _args)       sc_retry(_seamcall_ret,
(_fn), (_args))
#define seamcall_saved_ret(_fn, _args) sc_retry(_seamcall_saved_ret,
(_fn), (_args))

The compiler can figure it out and avoid making func() an indirect call
since it knows the call location at compile time.

You can also do the seamcall() #define as a static inline, but it does
take up more screen real estate.  Oh, and going a wee bit over 80
columns is OK for those #defines.
