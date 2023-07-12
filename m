Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE29750F4D
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 19:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjGLRLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 13:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjGLRLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 13:11:53 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754641BDA;
        Wed, 12 Jul 2023 10:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nmU8GDqFORVZB/GJG20KAAkvGNSEL3nSuZMjnbfCcN4=; b=Mvp68jWogX7ikHndL5UCqHoqQ6
        nT2g+CN5wvlK/DJNprCTtYAJ+MqoYRsiOibsBBDP/XJdEMi9GoTWPcSLHgV8JUQjCwKELEKlLUi95
        nSPU6t4oD26oKzSg2MdxIpYuNTDj+5UiLEGron1I4xy2lAL7EmSITZyk4aUAORL/IiLA2xIPtnz1h
        +0IN2f9fWb8kwN/dOoLciWDuc0NZPYfTUccGQCZjlzGtkCxdlR2Gzi6rEcTH8efPOFyUBtb9zFHL9
        /0eZLzMZpiVf5Bw0EQrblLpkxAzwSxw68bpHsxbLCPH4cJE8/bFYRLA4c3KF7TqfP7zXpies+Qd4q
        4Ykh3k3Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJdNG-003jJ9-1s;
        Wed, 12 Jul 2023 17:11:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 777623001FD;
        Wed, 12 Jul 2023 19:11:33 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5FAD227E80242; Wed, 12 Jul 2023 19:11:33 +0200 (CEST)
Date:   Wed, 12 Jul 2023 19:11:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Message-ID: <20230712171133.GB3115257@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 08:55:21PM +1200, Kai Huang wrote:
> @@ -65,6 +104,37 @@
>  	.endif
>  
>  	.if \ret
> +	.if \saved
> +	/*
> +	 * Restore the structure from stack to saved the output registers
> +	 *
> +	 * In case of VP.ENTER returns due to TDVMCALL, all registers are
> +	 * valid thus no register can be used as spare to restore the
> +	 * structure from the stack (see "TDH.VP.ENTER Output Operands
> +	 * Definition on TDCALL(TDG.VP.VMCALL) Following a TD Entry").
> +	 * For this case, need to make one register as spare by saving it
> +	 * to the stack and then manually load the structure pointer to
> +	 * the spare register.
> +	 *
> +	 * Note for other TDCALLs/SEAMCALLs there are spare registers
> +	 * thus no need for such hack but just use this for all for now.
> +	 */
> +	pushq	%rax		/* save the TDCALL/SEAMCALL return code */
> +	movq	8(%rsp), %rax	/* restore the structure pointer */
> +	movq	%rsi, TDX_MODULE_rsi(%rax)	/* save %rsi */
> +	movq	%rax, %rsi	/* use %rsi as structure pointer */
> +	popq	%rax		/* restore the return code */
> +	popq	%rsi		/* pop the structure pointer */

Urgghh... At least for the \host case you can simply pop %rsi, no?
VP.ENTER returns with 0 there IIRC.

	/* xor-swap (%rsp) and %rax */
	xorq	(%rsp), %rax
	xorq	%rax, (%rsp)
	xorq	(%rsp), %rax

	movq	%rsi, TDX_MODULE_rsi(%rax);
	movq	%rax, %rsi

	popq	%rax

Isn't much better is it :/ Too bad xchg implies lock prefix.

> +
> +	/* Copy additional output regs to the structure  */
> +	movq %r12, TDX_MODULE_r12(%rsi)
> +	movq %r13, TDX_MODULE_r13(%rsi)
> +	movq %r14, TDX_MODULE_r14(%rsi)
> +	movq %r15, TDX_MODULE_r15(%rsi)
> +	movq %rbx, TDX_MODULE_rbx(%rsi)
> +	movq %rdi, TDX_MODULE_rdi(%rsi)
> +	.endif	/* \saved */
> +
>  	/* Copy output regs to the structure */
>  	movq %rcx, TDX_MODULE_rcx(%rsi)
>  	movq %rdx, TDX_MODULE_rdx(%rsi)
