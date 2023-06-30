Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381EF743B95
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbjF3MIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 08:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbjF3MIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 08:08:34 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4D14C31;
        Fri, 30 Jun 2023 05:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aQIbBeHHxL8b1EjNDcJ4bA1/I8pw3VBqIBojsRFOLbw=; b=KC/TbbzT8bzIA0JpUlRQYGkWSu
        X36S4/OI2xzOEihSBR6z3wSl1KCcHUBx4VX7XNxsLT9r0RDfusT+qDwypgxa2N2qTmYDJZbwKmPHo
        afaRLdxGeSE1dFf81lP+9jSfsYVKnLeTp9Xlz58gos5YrnsB+H3ln/H4v+d2+LynRreSEDtIViXqF
        EVweNvkVBisoB9UnnDIQu1Gl/yksQNfy3ois/kPe3S6Zu323pM5taGFZ4WpIJh+LiT5Xt5TNsGaIZ
        wjUCmtD54dZSTarHds4fj4AMRwlh28BlrQovnx+z1An9E1XKvSSpvsAXfl9OZahC0gHLlGhH6sXlE
        wGpkDy/w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qFCto-007yu1-06;
        Fri, 30 Jun 2023 12:06:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 41827300338;
        Fri, 30 Jun 2023 14:06:50 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 28EC024806A2C; Fri, 30 Jun 2023 14:06:50 +0200 (CEST)
Date:   Fri, 30 Jun 2023 14:06:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
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
Message-ID: <20230630120650.GB2534364@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
 <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
 <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 12:21:41PM +0200, Peter Zijlstra wrote:
> On Fri, Jun 30, 2023 at 12:07:00PM +0200, Peter Zijlstra wrote:
> > On Thu, Jun 29, 2023 at 10:33:38AM +0000, Huang, Kai wrote:
> 
> > > Looking at the later versions of TDX spec (with TD live migration, etc), it
> > > seems they are already using R12-R13 as SEAMCALL output:
> > > 
> > > https://cdrdv2.intel.com/v1/dl/getContent/733579
> > 
> > Urgh.. I think I read an older versio because I got bleeding eyes from
> > all this colour coded crap.
> > 
> > All this red is unreadable :-( Have they been told about the glories of
> > TeX and diff ?
> > 
> > > E.g., 6.3.15. NEW: TDH.IMPORT.MEM Leaf
> > > 
> > > It uses R12 and R13 as input.
> > 
> > 12 and 14. They skipped 13 for some mysterious raisin.
> 
> Things like TDH.SERVTD.BIND do use R13.
> 
> > But also, 10,11 are frequently used as input with this new stuff, which
> > already suggests the setup from your patches is not tenable.
> 
> 
> TDG.SERVTD.RD *why* can't they pass that TD_UUID as a pointer? Using *4*
> registers like that is quite insane.
> 
> TDG.VP.ENTER :-(((( that has b,15,si,di as additional output.
> 
> That means there's not a single register left unused. Can we still get
> this changed, please?!?

Can't :/, VP.ENTER mirrors VP.VMCALL, so we need to deal with both.

So I think the below deals with everything and unifies __tdx_hypercall()
and __tdx_module_call(), since both sides needs to deal with exactly the
same trainwreck.


/*
 * Used for input/output registers values of the TDCALL and SEAMCALL
 * instructions when requesting services from the TDX module.
 *
 * This is a software only structure and not part of the TDX module/VMM ABI.
 */
struct tdx_module_args {
	/* callee-clobbered */
	u64 rdx;
	u64 rcx;
	u64 r8;
	u64 r9;
	/* extra callee-clobbered */
	u64 r10;
	u64 r11;
	/* callee-saved + rdi/rsi */
	u64 rdi;
	u64 rsi;
	u64 rbx;
	u64 r12;
	u64 r13;
	u64 r14;
	u64 r15;
};



/*
 * TDX_MODULE_CALL - common helper macro for both
 *                   TDCALL and SEAMCALL instructions.
 *
 * TDCALL   - used by TDX guests to make requests to the
 *            TDX module and hypercalls to the VMM.
 *
 * SEAMCALL - used by TDX hosts to make requests to the
 *            TDX module.
 *
 *-------------------------------------------------------------------------
 * TDCALL/SEAMCALL ABI:
 *-------------------------------------------------------------------------
 * Input Registers:
 *
 * RAX                 - Leaf number.
 * RCX,RDX,R8-R11      - Leaf specific input registers.
 * RDI,RSI,RBX,R11-R15 - VP.VMCALL VP.ENTER
 *
 * Output Registers:
 *
 * RAX                 - instruction error code.
 * RCX,RDX,R8-R11      - Leaf specific output registers.
 * RDI,RSI,RBX,R12-R15 - VP.VMCALL VP.ENTER
 *
 *-------------------------------------------------------------------------
 *
 * So while the common core (RAX,RCX,RDX,R8-R11) fits nicely in the
 * callee-clobbered registers and even leaves RDI,RSI free to act as a base
 * pointer some rare leafs (VP.VMCALL, VP.ENTER) make a giant mess of things.
 *
 * For simplicity, assume that anything that needs the callee-saved regs also
 * tramples on RDI,RSI. This isn't strictly true, see for example EXPORT.MEM.
 */
.macro TDX_MODULE_CALL host:req ret:req saved:0
	FRAME_BEGIN

	movq	%rdi, %rax

	movq	TDX_MODULE_rcx(%rsi), %rcx
	movq	TDX_MODULE_rdx(%rsi), %rdx
	movq	TDX_MODULE_r8(%rsi),  %r8
	movq	TDX_MODULE_r9(%rsi),  %r9
	movq	TDX_MODULE_r10(%rsi), %r10
	movq	TDX_MODULE_r11(%rsi), %r11

.if \saved
	pushq	rbx
	pushq	r12
	pushq	r13
	pushq	r14
	pushq	r15

	movq	TDX_MODULE_rbx(%rsi), %rbx
	movq	TDX_MODULE_r12(%rsi), %r12
	movq	TDX_MODULE_r13(%rsi), %r13
	movq	TDX_MODULE_r14(%rsi), %r14
	movq	TDX_MODULE_r15(%rsi), %r15

	/* VP.VMCALL and VP.ENTER */
.if \ret
	pushq	%rsi
.endif
	movq	TDX_MODULE_rdi(%rsi), %rdi
	movq	TDX_MODULE_rsi(%rsi), %rsi
.endif

.Lcall:
.if \host
	seamcall
	/*
	 * SEAMCALL instruction is essentially a VMExit from VMX root
	 * mode to SEAM VMX root mode.  VMfailInvalid (CF=1) indicates
	 * that the targeted SEAM firmware is not loaded or disabled,
	 * or P-SEAMLDR is busy with another SEAMCALL. RAX is not
	 * changed in this case.
	 */
	jc	.Lseamfail

.if \saved && \ret
	/*
	 * VP.ENTER clears RSI on output, use it to restore state.
	 */
	popq	%rsi
	xor	%edi,%edi
	movq	%rdi, TDX_MODULE_rdi(%rsi)
	movq	%rdi, TDX_MODULE_rsi(%rsi)
.endif
.else
	tdcall

	/*
	 * RAX!=0 indicates a failure, assume no return values.
	 */
	testq	%rax, %rax
	jne	.Lerror

.if \saved && \ret
	/*
	 * Since RAX==0, it can be used as a scratch register to restore state.
	 *
	 * [ assumes \saved implies \ret ]
	 */
	popq	%rax
	movq	%rdi, TDX_MODULE_rdi(%rax)
	movq	%rsi, TDX_MODULE_rsi(%rax)
	movq	%rax, %rsi
	xor	%eax, %eax;
.endif
.endif // \host

.if \ret
	/* RSI is restored */
	movq	%rcx, TDX_MODULE_rcx(%rsi)
	movq	%rdx, TDX_MODULE_rdx(%rsi)
	movq	%r8,  TDX_MODULE_r8(%rsi)
	movq	%r9,  TDX_MODULE_r9(%rsi)
	movq	%r10, TDX_MODULE_r10(%rsi)
	movq	%r11, TDX_MODULE_r11(%rsi)
.if \saved
	movq	%rbx, TDX_MODULE_rbx(%rsi)
	movq	%r12, TDX_MODULE_r12(%rsi)
	movq	%r13, TDX_MODULE_r13(%rsi)
	movq	%r14, TDX_MODULE_r14(%rsi)
	movq	%r15, TDX_MODULE_r15(%rsi)
.endif
.endif // \ret

.Lout:
.if \saved
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbx
.endif
	FRAME_END
	RET

	/*
	 * Error and exception handling at .Lcall. Ignore \ret on failure.
	 */
.Lerror:
.if \saved && \ret
	popq	%rsi
.endif
	jmp	.Lout

.if \host
.Lseamfail:
	/*
	 * Set RAX to TDX_SEAMCALL_VMFAILINVALID for VMfailInvalid.
	 * This value will never be used as actual SEAMCALL error code as
	 * it is from the Reserved status code class.
	 */
	movq	$TDX_SEAMCALL_VMFAILINVALID, %rax
	jmp	.Lerror

.Lfault:
	/*
	 * SEAMCALL caused #GP or #UD. Per _ASM_EXTABLE_FAULT() RAX
	 * contains the trap number, convert to a TDX error code by
	 * setting the high word to TDX_SW_ERROR.
	 */
	mov	$TDX_SW_ERROR, %rdi
	or	%rdi, %rax
	jmp	.Lerror

	_ASM_EXTABLE_FAULT(.Lcall, .Lfault)
.endif
.endm
