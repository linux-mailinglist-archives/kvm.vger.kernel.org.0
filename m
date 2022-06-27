Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B808755D6C4
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiF0W5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 18:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiF0W5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 18:57:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21709DEC8;
        Mon, 27 Jun 2022 15:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656370631; x=1687906631;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KYtQj1bfrqojCjIeYc3LY3q2wleqkrJ3eSIIQdAxG2E=;
  b=KydhWjiZs3GppDptFPQeyDyFJG1tGIxuvHN1IMToxtnk3lo2BIWr7Xdg
   tkLKEi0CVs67ijtS3dLMPyE5ElBNbJ1AGMzSN/roCnfCBPOHPNB/G4B6L
   G0K4rZreUWMwIgQA4DScsRVyAD38f9wscf0nYH+5e0xuSP4g+G+ryUzOs
   lW/hq80I/YmsCl68OVKur+LIzvLi5LIKdbWlqGWXdbbgMchFkWYUGGHmU
   CpI683V5VqcuSGI578IqN+/nMYUlrd6QOqctGXXH8gqG3OvlLv5ajUjkO
   y2kacG8kDJfjFyp7+pN7R826PLuqEDJNRp0fvjm1IDI686nqfkZ5EX4LV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="343269772"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="343269772"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:57:01 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="732509629"
Received: from jsagoe-mobl1.amr.corp.intel.com (HELO [10.209.12.66]) ([10.209.12.66])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:57:00 -0700
Message-ID: <6ed2746d-f44c-4511-7373-5706dd7c3f0f@intel.com>
Date:   Mon, 27 Jun 2022 15:56:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 08/22] x86/virt/tdx: Shut down TDX module in case of
 error
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
References: <cover.1655894131.git.kai.huang@intel.com>
 <89fffc70cdbb74c80bb324364b712ec41e5f8b91.1655894131.git.kai.huang@intel.com>
 <765a20f1-681d-33c2-68e9-24cc249fe6f9@intel.com>
 <cc90e5f8be0c6f48a144240d4569b15bd4b75dd8.camel@intel.com>
 <77c90075-79d4-7cc7-f266-1b67e586513b@intel.com>
 <2b94afd608303f104376e6a775b211714e34bc7e.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <2b94afd608303f104376e6a775b211714e34bc7e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/22 15:34, Kai Huang wrote:
> On Mon, 2022-06-27 at 13:46 -0700, Dave Hansen wrote:
> I think I can just use __always_unused for this purpose?
> 
> So I think we put seamcall() implementation to the patch which implements
> __seamcall().  And we can inline for seamcall() and put it in either tdx.h or
> tdx.c, or we can use __always_unused  (or the one you prefer) to get rid of the
> warning.
> 
> What's your opinion?

A temporary __always_unused seems fine to me.

>>> Alternatively, we can always add EXTABLE to TDX_MODULE_CALL macro to handle #UD
>>> and #GP by returning dedicated error codes (please also see my reply to previous
>>> patch for the code needed to handle), in which case we don't need such check
>>> here.
>>>
>>> Always handling #UD in TDX_MODULE_CALL macro also has another advantage:  there
>>> will be no Oops for #UD regardless the issue that "there's no way to check
>>> whether VMXON has been done" in the above comment.
>>>
>>> What's your opinion?
>>
>> I think you should explore using the EXTABLE.  Let's see how it looks.
> 
> I tried to wrote the code before.  I didn't test but it should look like to
> something below.  Any comments?
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 4b75c930fa1b..4a97ca8eb14c 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -8,6 +8,7 @@
>  #include <asm/ptrace.h>
>  #include <asm/shared/tdx.h>
> 
> +#ifdef CONFIG_INTEL_TDX_HOST
>  /*
>   * SW-defined error codes.
>   *
> @@ -18,6 +19,21 @@
>  #define TDX_SW_ERROR                   (TDX_ERROR | GENMASK_ULL(47, 40))
>  #define TDX_SEAMCALL_VMFAILINVALID     (TDX_SW_ERROR | _UL(0xFFFF0000))
> 
> +/*
> + * Special error codes to indicate SEAMCALL #GP and #UD.
> + *
> + * SEAMCALL causes #GP when SEAMRR is not properly enabled by BIOS, and
> + * causes #UD when CPU is not in VMX operation.  Define two separate
> + * error codes to distinguish the two cases so caller can be aware of
> + * what caused the SEAMCALL to fail.
> + *
> + * Bits 61:48 are reserved bits which will never be set by the TDX
> + * module.  Borrow 2 reserved bits to represent #GP and #UD.
> + */
> +#define TDX_SEAMCALL_GP                (TDX_ERROR | GENMASK_ULL(48, 48))
> +#define TDX_SEAMCALL_UD                (TDX_ERROR | GENMASK_ULL(49, 49))
> +#endif
> +
>  #ifndef __ASSEMBLY__
> 
>  /*
> diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> index 49a54356ae99..7431c47258d9 100644
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
>         /* Leave input param 2 in RDX */
> 
>         .if \host
> +1:
>         seamcall
>         /*
>          * SEAMCALL instruction is essentially a VMExit from VMX root
> @@ -57,9 +59,25 @@
>          * This value will never be used as actual SEAMCALL error code as
>          * it is from the Reserved status code class.
>          */
> -       jnc .Lno_vmfailinvalid
> +       jnc .Lseamcall_out
>         mov $TDX_SEAMCALL_VMFAILINVALID, %rax
> -.Lno_vmfailinvalid:
> +       jmp .Lseamcall_out
> +2:
> +       /*
> +        * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
> +        * the trap number.  Check the trap number and set up the return
> +        * value to %rax.
> +        */
> +       cmp $X86_TRAP_GP, %eax
> +       je .Lseamcall_gp
> +       mov $TDX_SEAMCALL_UD, %rax
> +       jmp .Lseamcall_out
> +.Lseamcall_gp:
> +       mov $TDX_SEAMCALL_GP, %rax
> +       jmp .Lseamcall_out
> +
> +       _ASM_EXTABLE_FAULT(1b, 2b)
> +.Lseamcall_out

Not too bad, although the end of that is a bit ugly.  It would be nicer
if you could just return the %rax value in the exception section instead
of having to do the transform there.  Maybe have a TDX_ERROR code with
enough bits to hold any X86_TRAP_FOO.

It'd be nice if Peter Z or Andy L has a sec to look at this.  Seems like
the kind of thing they'd have good ideas about.
