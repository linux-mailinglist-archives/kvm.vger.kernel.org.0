Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A33741AAF
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 23:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjF1VWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 17:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjF1VWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 17:22:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A16735A3;
        Wed, 28 Jun 2023 14:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SHmTybyGcoc5/JHuzcVL5NX4Cs2gDAkCaV9bDoHI6B0=; b=rL7tFVolsDXSDWlE9Rcxp2bWmN
        Q9/yYXbuz8LgkmajLixE4pyVs8jNt0e1htRkRgqpAojAOnS2IOcggOUqw7n4Njl7Fsvsy1wXYY71M
        6QN4rTTRRQfiWfLfN4AgVeNqDhL+cq3CIfR3KSmolf0VLZuS2C/wSY3e4G5TnkMziNOhqb1HFJjNy
        v3qIw7bK00JYJ7nic7cGo0ApMaYScx2DWyHXF+5w3wLSGpyxnahYAgdApeZERqxR1XZYoCZZICuVF
        4FTp11QpjOsXVK3HYE3/zq0Zx7zV/3s0TnkCRbD6kn0mE8gqnVB+o8WEI9UzwY0l7e2YqpWy2t8y2
        jv+xC5HA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qEcWo-004E0P-8M; Wed, 28 Jun 2023 21:16:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C765F3002C5;
        Wed, 28 Jun 2023 23:16:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AA92C2481AF37; Wed, 28 Jun 2023 23:16:41 +0200 (CEST)
Date:   Wed, 28 Jun 2023 23:16:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@redhat.com, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ashok.raj@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230628211641.GT38236@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <20230628211132.GS38236@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628211132.GS38236@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 11:11:32PM +0200, Peter Zijlstra wrote:
> --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> @@ -17,37 +17,44 @@
>   *            TDX module and hypercalls to the VMM.
>   * SEAMCALL - used by TDX hosts to make requests to the
>   *            TDX module.
> + *
> + *-------------------------------------------------------------------------
> + * TDCALL/SEAMCALL ABI:
> + *-------------------------------------------------------------------------
> + * Input Registers:
> + *
> + * RAX                 - TDCALL Leaf number.
> + * RCX,RDX,R8-R9       - TDCALL Leaf specific input registers.
> + *
> + * Output Registers:
> + *
> + * RAX                 - TDCALL instruction error code.
> + * RCX,RDX,R8-R11      - TDCALL Leaf specific output registers.
> + *
> + *-------------------------------------------------------------------------
> + *
> + * __tdx_module_call() function ABI:
> + *
> + * @fn   (RDI)         - TDCALL Leaf ID,    moved to RAX
> + * @regs (RSI)         - struct tdx_regs pointer
> + *
> + * Return status of TDCALL via RAX.
>   */
> +.macro TDX_MODULE_CALL host:req ret:req
> +	FRAME_BEGIN
>  
> +	mov	%rdi, %rax
> +	mov	$TDX_SEAMCALL_VMFAILINVALID, %rdi
>  
> +	mov	TDX_MODULE_rcx(%rsi), %rcx
> +	mov	TDX_MODULE_rdx(%rsi), %rdx
> +	mov	TDX_MODULE_r8(%rsi),  %r8
> +	mov	TDX_MODULE_r9(%rsi),  %r9
> +//	mov	TDX_MODULE_r10(%rsi), %r10
> +//	mov	TDX_MODULE_r11(%rsi), %r11
>  
> +.if \host
> +1:	seamcall
>  	/*
>  	 * SEAMCALL instruction is essentially a VMExit from VMX root
>  	 * mode to SEAM VMX root mode.  VMfailInvalid (CF=1) indicates
	...
>  	 * This value will never be used as actual SEAMCALL error code as
>  	 * it is from the Reserved status code class.
>  	 */
> +	cmovc	%rdi, %rax
>  2:
> +.else
>  	tdcall
> +.endif
>  
> +.if \ret
> +	movq %rcx, TDX_MODULE_rcx(%rsi)
> +	movq %rdx, TDX_MODULE_rdx(%rsi)
> +	movq %r8,  TDX_MODULE_r8(%rsi)
> +	movq %r9,  TDX_MODULE_r9(%rsi)
> +	movq %r10, TDX_MODULE_r10(%rsi)
> +	movq %r11, TDX_MODULE_r11(%rsi)
> +.endif
> +
> +	FRAME_END
> +	RET
> +
> +.if \host
> +3:
> +	mov	$TDX_SW_ERROR, %rdi
> +	or	%rdi, %rax
> +	jmp 2b
>  
> +	_ASM_EXTABLE_FAULT(1b, 3b)
> +.endif
>  .endm

Isn't that much simpler?
