Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766CF748200
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 12:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjGEKWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 06:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjGEKWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 06:22:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F705122;
        Wed,  5 Jul 2023 03:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4Ry2jwT0YbMwWbjx+3d3lF7amM0BUUKmYAyIeJr5PH0=; b=TkLfIfSOKiy03+vFG2OK6XsHNN
        Iq/mWTSZwNCg6/mZQN71Of8QJbi5+cWYhWfQs7Bg4NO1fX6WIuakygNQYhMZCOyeZBV/fVZJcp4+m
        JaHFPtOq0506oqa9eJxIq3H1ZQlw/Xgm/Sy6TUK5IRLCoKiLI4pzqvQ93rUo5XLnJbVhPlg7hbmrd
        +GdtrTHYNPvLalFg8XnTjE3HI89O7Lhkz+M3iW5BX3ZQIYNQfBnDHchympbxWrlXeIEFDnNibnAdw
        YLit9T+us3bY6+IX/Kpgx/R/E2ggxQ1gpsSUQ/Se+5PiF54l+IifukRhkO7I8VfhslIyaLjqT3SIt
        oxlzWqyA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qGzdj-009yvy-Tr; Wed, 05 Jul 2023 10:21:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 02A2F30005E;
        Wed,  5 Jul 2023 12:21:38 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DD7032028F056; Wed,  5 Jul 2023 12:21:37 +0200 (CEST)
Date:   Wed, 5 Jul 2023 12:21:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230705102137.GX4253@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
 <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
 <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
 <20230630120650.GB2534364@hirez.programming.kicks-ass.net>
 <fdd81fbd2424d8da04f98d156668cad5e73c740b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdd81fbd2424d8da04f98d156668cad5e73c740b.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 03, 2023 at 12:15:13PM +0000, Huang, Kai wrote:
> 
> > 
> > So I think the below deals with everything and unifies __tdx_hypercall()
> > and __tdx_module_call(), since both sides needs to deal with exactly the
> > same trainwreck.
> 
> Hi Peter,
> 
> Just want to make sure I understand you correctly:
> 
> You want to make __tdx_module_call() look like __tdx_hypercall(), but not to
> unify them into one assembly (at least for now), right?

Well, given the horrendous trainwreck this is all turning into, I
through it prudent to have it all in a single place. The moment you go
play games with callee-saved registers you're really close to what
hypercall does so then they might as well be the same.

> I am confused you mentioned VP.VMCALL below, which is handled by
> __tdx_hypercall().

But why? It really isn't *that* special if you consider the other calls
that are using callee-saved regs, yes it has the rdi/rsi extra, but meh,
it really just is tdcall-0.


> >  *-------------------------------------------------------------------------
> >  * TDCALL/SEAMCALL ABI:
> >  *-------------------------------------------------------------------------
> >  * Input Registers:
> >  *
> >  * RAX                 - Leaf number.
> >  * RCX,RDX,R8-R11      - Leaf specific input registers.
> >  * RDI,RSI,RBX,R11-R15 - VP.VMCALL VP.ENTER
> >  *
> >  * Output Registers:
> >  *
> >  * RAX                 - instruction error code.
> >  * RCX,RDX,R8-R11      - Leaf specific output registers.
> >  * RDI,RSI,RBX,R12-R15 - VP.VMCALL VP.ENTER
> 
> As mentioned above, VP.VMCALL is handled by __tdx_hypercall().  Also, VP.ENTER
> will be handled by KVM's own assembly.  They both are not handled in this
> TDX_MODULE_CALL assembly.

I don't think they should be special, they're really just yet another
leaf call. Yes, they have a shit calling convention, and yes VP.ENTER is
terminally broken for unconditionally clobbering BP :-(

That really *must* be fixed.

> > .Lcall:
> > .if \host
> > 	seamcall
> > 	/*
> > 	 * SEAMCALL instruction is essentially a VMExit from VMX root
> > 	 * mode to SEAM VMX root mode.  VMfailInvalid (CF=1) indicates
> > 	 * that the targeted SEAM firmware is not loaded or disabled,
> > 	 * or P-SEAMLDR is busy with another SEAMCALL. RAX is not
> > 	 * changed in this case.
> > 	 */
> > 	jc	.Lseamfail
> > 
> > .if \saved && \ret
> > 	/*
> > 	 * VP.ENTER clears RSI on output, use it to restore state.
> > 	 */
> > 	popq	%rsi
> > 	xor	%edi,%edi
> > 	movq	%rdi, TDX_MODULE_rdi(%rsi)
> > 	movq	%rdi, TDX_MODULE_rsi(%rsi)
> > .endif
> > .else
> > 	tdcall
> > 
> > 	/*
> > 	 * RAX!=0 indicates a failure, assume no return values.
> > 	 */
> > 	testq	%rax, %rax
> > 	jne	.Lerror
> 
> For some SEAMCALL/TDCALL the output registers may contain additional error
> information.  We need to jump to a location where whether returning those
> additional regs to 'struct tdx_module_args' depends on \ret.

I suppose we can move this into the below conditional :-( The [DS]I
register stuff requires a scratch reg to recover, AX being zero provides
that.

> > .if \saved && \ret
> > 	/*
> > 	 * Since RAX==0, it can be used as a scratch register to restore state.
> > 	 *
> > 	 * [ assumes \saved implies \ret ]
> > 	 */
> > 	popq	%rax
> > 	movq	%rdi, TDX_MODULE_rdi(%rax)
> > 	movq	%rsi, TDX_MODULE_rsi(%rax)
> > 	movq	%rax, %rsi
> > 	xor	%eax, %eax;
> > .endif
> > .endif // \host

So the reason I want this, is that I feel very strongly that if you
cannot write a single coherent wrapper for all this, its calling
convention is fundamentally *too* complex / broken.


