Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D858750F1F
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjGLQ7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjGLQ7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:59:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C8A11D;
        Wed, 12 Jul 2023 09:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Vz/tOg41P4p1d33Hb8aHe1RPyw3zTJIf/VyvOU8uRdA=; b=B5sZqLvcv1fs7TOkzddJpdkOfo
        KKKXcNlCOnXL9bS79Kf7OZdI1p3kkotJMseOlP0AFexJdVi7vArRqD6+R3AuiDHBi6KTehsaXh9Tk
        mfvi4Hv7ZL9LLW1TfN6cLgbP0amq7v9TPFLVIWPXf+IwjnRseWE7UbxG0RdMXxSGotpdi0TKAPtPi
        fSprwJGGEgVRBX2jJkUsRk+Sq7TjjHuOuMC3+HbAuKQyWAgu7gdL2u/gYaRKgipwTfrtJvFBncPwz
        MyIN8MuXAEBSZ5q9BLGEESlCJGoS6Ona8z5giw3aeN7DICCPcDpyIVkMfmUiK4pFeVn+DUyFT0hVw
        UTaZnUjg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJdBI-00GtYT-NQ; Wed, 12 Jul 2023 16:59:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4C29030036B;
        Wed, 12 Jul 2023 18:59:12 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2B76B27E80242; Wed, 12 Jul 2023 18:59:12 +0200 (CEST)
Date:   Wed, 12 Jul 2023 18:59:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Message-ID: <20230712165912.GA3100142@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
 <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 06:53:37PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 12, 2023 at 08:55:21PM +1200, Kai Huang wrote:
> 
> 
> > @@ -72,7 +142,46 @@
> >  	movq %r9,  TDX_MODULE_r9(%rsi)
> >  	movq %r10, TDX_MODULE_r10(%rsi)
> >  	movq %r11, TDX_MODULE_r11(%rsi)
> > -	.endif
> > +	.endif	/* \ret */
> > +
> > +	.if \saved
> > +	.if \ret && \host
> > +	/*
> > +	 * Clear registers shared by guest for VP.ENTER to prevent
> > +	 * speculative use of guest's values, including those are
> > +	 * restored from the stack.
> > +	 *
> > +	 * See arch/x86/kvm/vmx/vmenter.S:
> > +	 *
> > +	 * In theory, a L1 cache miss when restoring register from stack
> > +	 * could lead to speculative execution with guest's values.
> > +	 *
> > +	 * Note: RBP/RSP are not used as shared register.  RSI has been
> > +	 * restored already.
> > +	 *
> > +	 * XOR is cheap, thus unconditionally do for all leafs.
> > +	 */
> > +	xorq %rcx, %rcx
> > +	xorq %rdx, %rdx
> > +	xorq %r8,  %r8
> > +	xorq %r9,  %r9
> > +	xorq %r10, %r10
> > +	xorq %r11, %r11
> 
> > +	xorq %r12, %r12
> > +	xorq %r13, %r13
> > +	xorq %r14, %r14
> > +	xorq %r15, %r15
> > +	xorq %rbx, %rbx
> 
> ^ those are an instant pop below, seems daft to clear them.

Also, please use the 32bit variant:

	xorl	%ecx, %ecx

saves a RAX prefix each.

> > +	xorq %rdi, %rdi
> > +	.endif	/* \ret && \host */
> > +
> > +	/* Restore callee-saved GPRs as mandated by the x86_64 ABI */
> > +	popq	%r15
> > +	popq	%r14
> > +	popq	%r13
> > +	popq	%r12
> > +	popq	%rbx
> > +	.endif	/* \saved */
> >  
> >  	FRAME_END
> >  	RET
> > -- 
> > 2.41.0
> > 
