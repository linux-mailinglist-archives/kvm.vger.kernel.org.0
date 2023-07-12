Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3350751130
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 21:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbjGLT1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 15:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjGLT1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 15:27:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EC21FD8;
        Wed, 12 Jul 2023 12:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689190039; x=1720726039;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rmWix9xmBsf4l8C7qj1+gB0nzdzmGQbV/inpq2dCZcc=;
  b=Aid4RyFCzfUZvqXnzgV3ltK01viKtdg8kHF8QlH3s0WeyqTI5wIrJ/8o
   nJRrvjw0sUF9lgDadt3J69HRzFgevsBoxlvfEmV7yh45FrMIFtwyjlOze
   QlRXGmXF42eDciV2aiwVZVjxvuIFJ6/jhH+h0oqOlbeo9a5py383m7VG8
   s01nN2KxHbpOui4bTapG3E2uSS/XUb7oaxBgFS0pUoyfGMUAA1mYb3ofK
   dehdI1jUxLdAM1zKdFMOPgcia+7KNheYOiU8N2Kbbbua0Rem/D4ynhpn1
   CGB6DcL82qlpfHP1eUN37wAyErQ+tj5A3glkr9S6N/MZnMtWqiUHwo4lc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="368517455"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="368517455"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 12:27:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="845755269"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="845755269"
Received: from averypay-mobl1.amr.corp.intel.com (HELO [10.212.212.40]) ([10.212.212.40])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 12:27:18 -0700
Message-ID: <400c0d11-fa14-cb1c-f6ed-02f850753e46@linux.intel.com>
Date:   Wed, 12 Jul 2023 12:27:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH 02/10] x86/tdx: Use cmovc to save a label in
 TDX_MODULE_CALL asm
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, peterz@infradead.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com
References: <cover.1689151537.git.kai.huang@intel.com>
 <70784afc0a42d4dc1b1e743f90d89f7728496add.1689151537.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <70784afc0a42d4dc1b1e743f90d89f7728496add.1689151537.git.kai.huang@intel.com>
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
> Change 'jnc .Lno_vmfailinvalid' to 'cmovc %rdi, %rax' to save the
> .Lno_vmfailinvalid label in the TDX_MODULE_CALL asm macro.

You are removing the label, right? What use "save"?

> 
> Note %rdi, which is used as the first argument, has been saved to %rax
> as TDCALL leaf ID thus is free to hold the error code for cmovc.

> 
> This is basically based on Peter's code.
> 
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/virt/vmx/tdx/tdxcall.S | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> index 49a54356ae99..3524915d8bd9 100644
> --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> @@ -57,10 +57,8 @@
>  	 * This value will never be used as actual SEAMCALL error code as
>  	 * it is from the Reserved status code class.
>  	 */
> -	jnc .Lno_vmfailinvalid
> -	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
> -.Lno_vmfailinvalid:
> -
> +	mov $TDX_SEAMCALL_VMFAILINVALID, %rdi
> +	cmovc %rdi, %rax
>  	.else
>  	tdcall
>  	.endif

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
