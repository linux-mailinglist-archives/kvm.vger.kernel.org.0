Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2A6751C8B
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbjGMJCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbjGMJCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:02:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147392D43;
        Thu, 13 Jul 2023 02:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SvFjQgh7iMrGngVir0RKl1OuGXHDDPqcLIw4Qq3ouqo=; b=Z8O9ONkl5y8vJdFIYe/+RdrdE0
        URpFWy9AVayh4SUvAYwyCgJSzmdK/eGYR+dzAxL8ORuOhVzjb5Q8SDsBSRq/XWEpV7Ctn+oJpthk4
        3dYqwmZXPs/Lvjewhs5lqdmjGPBcAUkqtYrE+BTqbbe/Zh9cHGZi4QJaD3nUGZ4IGnoi5ZBskicoR
        1tKJNIZM/WlxMIvDPsvbqKdqMwgE8A4GESceWXs9MmpwkhPD3MCgHEHGmXu3ER0qBQug9pfi/I99u
        UceBkoaLJh89wEYiPuoF5gGM+ySaIhW9Lp+0G5aAefFFzwxWco3AbQDmjND45FE9eNYzJE/967n0h
        ele+Q0MQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJsCG-00HaMu-C1; Thu, 13 Jul 2023 09:01:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B7F26300222;
        Thu, 13 Jul 2023 11:01:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9FB33245CA111; Thu, 13 Jul 2023 11:01:10 +0200 (CEST)
Date:   Thu, 13 Jul 2023 11:01:10 +0200
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
Message-ID: <20230713090110.GC3138667@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
 <20230712171133.GB3115257@hirez.programming.kicks-ass.net>
 <a36d1f0068154a9acd3fdbed2586dc5b2476e140.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36d1f0068154a9acd3fdbed2586dc5b2476e140.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 08:09:33AM +0000, Huang, Kai wrote:
> On Wed, 2023-07-12 at 19:11 +0200, Peter Zijlstra wrote:
> > On Wed, Jul 12, 2023 at 08:55:21PM +1200, Kai Huang wrote:
> > > @@ -65,6 +104,37 @@
> > >  	.endif
> > >  
> > >  	.if \ret
> > > +	.if \saved
> > > +	/*
> > > +	 * Restore the structure from stack to saved the output registers
> > > +	 *
> > > +	 * In case of VP.ENTER returns due to TDVMCALL, all registers are
> > > +	 * valid thus no register can be used as spare to restore the
> > > +	 * structure from the stack (see "TDH.VP.ENTER Output Operands
> > > +	 * Definition on TDCALL(TDG.VP.VMCALL) Following a TD Entry").
> > > +	 * For this case, need to make one register as spare by saving it
> > > +	 * to the stack and then manually load the structure pointer to
> > > +	 * the spare register.
> > > +	 *
> > > +	 * Note for other TDCALLs/SEAMCALLs there are spare registers
> > > +	 * thus no need for such hack but just use this for all for now.
> > > +	 */
> > > +	pushq	%rax		/* save the TDCALL/SEAMCALL return code */
> > > +	movq	8(%rsp), %rax	/* restore the structure pointer */
> > > +	movq	%rsi, TDX_MODULE_rsi(%rax)	/* save %rsi */
> > > +	movq	%rax, %rsi	/* use %rsi as structure pointer */
> > > +	popq	%rax		/* restore the return code */
> > > +	popq	%rsi		/* pop the structure pointer */
> > 
> > Urgghh... At least for the \host case you can simply pop %rsi, no?
> > VP.ENTER returns with 0 there IIRC.
> 
> No VP.ENTER doesn't return 0 for RAX.  Firstly, VP.ENTER can return for many

No, but it *does* return 0 for: RBX,RSI,RDI,R10-R15.

So for \host you can simply do:

	pop	%rsi
	mov	$0, TDX_MODULE_rsi(%rsi)

and call it a day.
