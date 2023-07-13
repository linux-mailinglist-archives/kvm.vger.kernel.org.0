Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C5F751D18
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbjGMJZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjGMJZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:25:33 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94FA1BD7;
        Thu, 13 Jul 2023 02:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aLfJs3MS+i1Qzrwg9ezBlk9asSjTnp3lzmR8uEU7R9Y=; b=lDQ6s6wGUFFJ7MwDzjY5rytAjZ
        wIhU1KE2cfZOnghtLSgsRY2LB822iznodWTe678cOcTfA05MFznf2XUBvylx4ipG33WZYq9lOTbk2
        h0zherga88YGyf7GlgOCnWvYVlx/D8BqyWf4z+oAg453H+Yv4myASzNV2ypiWxsoYw7GWvpEgKUDb
        Q/08fCyjfhNbvzbAFBO2JS+MMLAOLT05TM9eQjOE0LL2N1f2oofK7z+xUVAfB7tX0E7WJIy9nYWDo
        xIsmDAawHdiuvI0rX8JT2mWWjiUvlA99EwENksSEAkBpc5iSMN6KYgyu909nncNxKBeKzOuAG+RHS
        XhGxnAJg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJsZb-004atD-0A;
        Thu, 13 Jul 2023 09:25:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9DB573001FD;
        Thu, 13 Jul 2023 11:25:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 84DA2245CA117; Thu, 13 Jul 2023 11:25:18 +0200 (CEST)
Date:   Thu, 13 Jul 2023 11:25:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Message-ID: <20230713092518.GF3138667@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
 <20230712171133.GB3115257@hirez.programming.kicks-ass.net>
 <a36d1f0068154a9acd3fdbed2586dc5b2476e140.camel@intel.com>
 <20230713090110.GC3138667@hirez.programming.kicks-ass.net>
 <4e542a29ba6083981c13c43d0c5e69d24f42f812.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e542a29ba6083981c13c43d0c5e69d24f42f812.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 09:15:49AM +0000, Huang, Kai wrote:
> On Thu, 2023-07-13 at 11:01 +0200, Peter Zijlstra wrote:
> > On Thu, Jul 13, 2023 at 08:09:33AM +0000, Huang, Kai wrote:
> > > On Wed, 2023-07-12 at 19:11 +0200, Peter Zijlstra wrote:
> > > > On Wed, Jul 12, 2023 at 08:55:21PM +1200, Kai Huang wrote:
> > > > > @@ -65,6 +104,37 @@
> > > > >  	.endif
> > > > >  
> > > > >  	.if \ret
> > > > > +	.if \saved
> > > > > +	/*
> > > > > +	 * Restore the structure from stack to saved the output registers
> > > > > +	 *
> > > > > +	 * In case of VP.ENTER returns due to TDVMCALL, all registers are
> > > > > +	 * valid thus no register can be used as spare to restore the
> > > > > +	 * structure from the stack (see "TDH.VP.ENTER Output Operands
> > > > > +	 * Definition on TDCALL(TDG.VP.VMCALL) Following a TD Entry").
> > > > > +	 * For this case, need to make one register as spare by saving it
> > > > > +	 * to the stack and then manually load the structure pointer to
> > > > > +	 * the spare register.
> > > > > +	 *
> > > > > +	 * Note for other TDCALLs/SEAMCALLs there are spare registers
> > > > > +	 * thus no need for such hack but just use this for all for now.
> > > > > +	 */
> > > > > +	pushq	%rax		/* save the TDCALL/SEAMCALL return code */
> > > > > +	movq	8(%rsp), %rax	/* restore the structure pointer */
> > > > > +	movq	%rsi, TDX_MODULE_rsi(%rax)	/* save %rsi */
> > > > > +	movq	%rax, %rsi	/* use %rsi as structure pointer */
> > > > > +	popq	%rax		/* restore the return code */
> > > > > +	popq	%rsi		/* pop the structure pointer */
> > > > 
> > > > Urgghh... At least for the \host case you can simply pop %rsi, no?
> > > > VP.ENTER returns with 0 there IIRC.
> > > 
> > > No VP.ENTER doesn't return 0 for RAX.  Firstly, VP.ENTER can return for many
> > 
> > No, but it *does* return 0 for: RBX,RSI,RDI,R10-R15.
> > 
> > So for \host you can simply do:
> > 
> > 	pop	%rsi
> > 	mov	$0, TDX_MODULE_rsi(%rsi)
> > 
> > and call it a day.
> 
> This isn't true for the case that VP.ENTER returns due to a TDVMCALL.  In that
> case RCX contains the bitmap of shared registers, and RBX/RDX/RDI/RSI/R8-R15
> contains guest value if the corresponding bit is set in RCX (RBP will be
> excluded by updating the spec I assume).
> 
> Or are you suggesting we need to decode RAX to decide whether the VP.ENTER
> return is due to TDVMCALL vs other reasons, and act differently?

Urgh, no I had missed there are *TWO* tables for output :/ Who does
something like that :-(

So yeah, sucks.
