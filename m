Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2233751112
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 21:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjGLTTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 15:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjGLTTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 15:19:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711FA198A;
        Wed, 12 Jul 2023 12:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689189553; x=1720725553;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=erSspT/giTSCdU16BhFoAH7WAi6laQ6iA2u5zYWC5ak=;
  b=QHnCpdE6VH4DihqE+8KDaAc03BHYLz0LGMtNEQLxVkdJ0wA5hnAIA+2k
   n46QJfQxQjaHL7lwtjK0wvszOiFoX5d4a/gy6IjumS/52+FJYkAY4r44l
   CljVD5TKyYXQ1M8OVbVXzD6iBQi70dXJQoZ+gwM9XxySca2ugM4X0XtBZ
   zmeU/FAMn01md8N/KcRbBvKraUQ58aCbLgUH8sXLdtHiBNywji1L7rVLD
   q25vx4F7ZGl+n1wT1NzSgZh7LepCICToHl+KbLXxSylDwvWPsUX1mUwBX
   M5qqzn1bjaGOf62S9z/wnPQqFCljDAAtqwY58t3TCvVGxPkpboZFqIzpj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="362448803"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="362448803"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 12:19:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="895731592"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="895731592"
Received: from averypay-mobl1.amr.corp.intel.com (HELO [10.212.212.40]) ([10.212.212.40])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 12:19:12 -0700
Message-ID: <c29cb23b-d14c-4449-2881-5b2d3f9e7a74@linux.intel.com>
Date:   Wed, 12 Jul 2023 12:19:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH 01/10] x86/tdx: Zero out the missing RSI in TDX_HYPERCALL
 macro
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, peterz@infradead.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com
References: <cover.1689151537.git.kai.huang@intel.com>
 <2d821f2c32e6cdca252a80451f38429ef49b6984.1689151537.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <2d821f2c32e6cdca252a80451f38429ef49b6984.1689151537.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/23 1:55 AM, Kai Huang wrote:
> In the TDX_HYPERCALL asm, after the TDCALL instruction returns from the
> untrusted VMM, the registers that the TDX guest shares to the VMM need
> to be cleared to avoid speculative execution of VMM-provided values.
> 
> RSI is specified in the bitmap of those registers, but it is missing
> when zeroing out those registers in the current TDX_HYPERCALL.
> 
> It was there when it was originally added in commit 752d13305c78
> ("x86/tdx: Expand __tdx_hypercall() to handle more arguments"), but was
> later removed in commit 1e70c680375a ("x86/tdx: Do not corrupt
> frame-pointer in __tdx_hypercall()"), which was correct because %rsi is
> later restored in the "pop %rsi".  However a later commit 7a3a401874be
> ("x86/tdx: Drop flags from __tdx_hypercall()") removed that "pop %rsi"
> but forgot to add the "xor %rsi, %rsi" back.
> 
> Fix by adding it back.
> 
> Fixes: 7a3a401874be ("x86/tdx: Drop flags from __tdx_hypercall()")
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---

Looks fine to me.

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

>  arch/x86/coco/tdx/tdcall.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/coco/tdx/tdcall.S b/arch/x86/coco/tdx/tdcall.S
> index b193c0a1d8db..2eca5f43734f 100644
> --- a/arch/x86/coco/tdx/tdcall.S
> +++ b/arch/x86/coco/tdx/tdcall.S
> @@ -195,6 +195,7 @@ SYM_FUNC_END(__tdx_module_call)
>  	xor %r10d, %r10d
>  	xor %r11d, %r11d
>  	xor %rdi,  %rdi
> +	xor %rsi,  %rsi
>  	xor %rdx,  %rdx
>  
>  	/* Restore callee-saved GPRs as mandated by the x86_64 ABI */

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
