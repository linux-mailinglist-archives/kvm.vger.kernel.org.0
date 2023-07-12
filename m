Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805A8751331
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 00:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjGLWFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 18:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjGLWFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 18:05:54 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0E59B;
        Wed, 12 Jul 2023 15:05:54 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-666eef03ebdso54789b3a.1;
        Wed, 12 Jul 2023 15:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689199553; x=1691791553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J75VE/da93k8vRDY9HQXjesLCZCbpKtjsT8bbmwy48o=;
        b=HJl148y2GoIyq7PncvM7QOJx+P0aj4UJ3mAaRAKEE5W/9T0Q8wezhU6vrZNT0/nKiy
         rG7Z4mJHxVEmqtvK5sq2YkZQhieDBpXAXjkeuz1ct9fVgq3vNjUFOLBr+Spe5Y29Qx1C
         OL1V7q2+oDsFGIetFEE1OUZK92E3ujhmdLs5HIRvwnBMrVWpCrLxw2nXQN+FAHm6by6F
         CvGLEzRPd56RJoQvpnZg8qNSDnAQCKwKTvLsLYya/q4OeiqmuxULOKvbh/C+sKhHuZSq
         bYgREzUU5RkL40Q5KHpJPG3Fr7KM9EC/W9sczyvukfATHCMYm8ueofAAN3UtWlyinTJz
         EzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689199553; x=1691791553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J75VE/da93k8vRDY9HQXjesLCZCbpKtjsT8bbmwy48o=;
        b=R06uj/3zA544xDZMXpGWAih2U6dlrIkt7AZFLvIk//kWm0LraHO3Ly2FiAl1XW98E5
         8LC4xFGTkBOiCjM8M7rTL2uKBicPsrBUWN6LcSkVjFcqvtFjXM5vn0gvOAFVLfarLDVZ
         Y3swP74Hp//9YNWPcLGI9VybqveDosAWmGIUEsx93BNEORWX+LIBrJIbzrpqQbIPUseE
         w2REjNEr6HE6dw5a6wugnCxNU88dOoOdSASo0JkZE+NP63FwqjcerI9SYrUW6qNKEj1U
         3kz7Ir3VoviRighECC40Tx9Ab7u6dhT65cUmpoaCFyk6OigNhBSAh0VzPH1DVbPlclNd
         aYXA==
X-Gm-Message-State: ABy/qLZ5JklgHBQhOciMigD5DACGFtqq0hsjekaLbZWEpl59hH8rIx6H
        hzZhB+TY95rKMl9yV/3XrY4=
X-Google-Smtp-Source: APBJJlH49hr8yoTtJs1PxgCAs0pn/eHY+ExYa4qd0f7CU3G8/fAb1xWII3ZTNXXBA/yck5fNf053rA==
X-Received: by 2002:a05:6a00:2e92:b0:682:2152:45df with SMTP id fd18-20020a056a002e9200b00682215245dfmr16450241pfb.9.1689199553291;
        Wed, 12 Jul 2023 15:05:53 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id g8-20020aa78188000000b006783ee5df8asm4035983pfi.189.2023.07.12.15.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 15:05:52 -0700 (PDT)
Date:   Wed, 12 Jul 2023 15:05:51 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, dave.hansen@intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH 03/10] x86/tdx: Move FRAME_BEGIN/END to TDX_MODULE_CALL
 asm macro
Message-ID: <20230712220551.GF3894444@ls.amr.corp.intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
 <c0206c457f366ab007ab67ca16970cc4fc562877.1689151537.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c0206c457f366ab007ab67ca16970cc4fc562877.1689151537.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 08:55:17PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

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
> -- 
> 2.41.0
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
