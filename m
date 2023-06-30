Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D097438F8
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbjF3KIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbjF3KIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:08:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0873C12;
        Fri, 30 Jun 2023 03:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3y/9Jj3obwNlU1SHCuDEqbkfMRtUW049ByAh+VjrS7s=; b=RAtEFZtnK5tETG0+gXxsyxFmRT
        3JrM9TmL1/M9nWvYz886V0MIHUZF+C5yK24DZWqJ3jR/XalWnP/FlHGAw8YcDlK1PfIjPsgM9zzXD
        u6jIoIq2LSI3yibgHYi6bf18sITxHZ01MXkMQnXrrP5eieLS1Dh3ULf9oj2ovRBw0z73S/w+8BWld
        LyVwdPgOcoq38WnJeA6H017NQwGeTGqLh7GSIk5PdqVguyENId1Ilp9zLfDWfrfnHOjAbsn1CFWPX
        TG2GpTNHM4+yeAuT9f9GbV18BUZGcyTBKN1C2mvSP17gC3WPMibuXnIBWOvVjOpHLjJAEC7SByHYN
        PLg/NPhw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qFB1q-005e1n-19; Fri, 30 Jun 2023 10:07:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 195DE300118;
        Fri, 30 Jun 2023 12:07:00 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0204224819479; Fri, 30 Jun 2023 12:06:59 +0200 (CEST)
Date:   Fri, 30 Jun 2023 12:06:59 +0200
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
Message-ID: <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 10:33:38AM +0000, Huang, Kai wrote:
> On Wed, 2023-06-28 at 22:38 +0200, Peter Zijlstra wrote:
> > On Wed, Jun 28, 2023 at 05:29:01PM +0200, Peter Zijlstra wrote:
> > > On Tue, Jun 27, 2023 at 02:12:50AM +1200, Kai Huang wrote:
> > > > diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> > > > index 49a54356ae99..757b0c34be10 100644
> > > > --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> > > > +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> > > > @@ -1,6 +1,7 @@
> > > >  /* SPDX-License-Identifier: GPL-2.0 */
> > > >  #include <asm/asm-offsets.h>
> > > >  #include <asm/tdx.h>
> > > > +#include <asm/asm.h>
> > > >  
> > > >  /*
> > > >   * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
> > > > @@ -45,6 +46,7 @@
> > > >  	/* Leave input param 2 in RDX */
> > > >  
> > > >  	.if \host
> > > > +1:
> > > >  	seamcall
> > > 
> > > So what registers are actually clobbered by SEAMCALL ? There's a
> > > distinct lack of it in SDM Vol.2 instruction list :-(
> > 
> > With the exception of the abomination that is TDH.VP.ENTER all SEAMCALLs
> > seem to be limited to the set presented here (c,d,8,9,10,11) and all
> > other registers should be available.
> 
> RAX is also used as SEAMCALL return code.
> 
> Looking at the later versions of TDX spec (with TD live migration, etc), it
> seems they are already using R12-R13 as SEAMCALL output:
> 
> https://cdrdv2.intel.com/v1/dl/getContent/733579

Urgh.. I think I read an older versio because I got bleeding eyes from
all this colour coded crap.

All this red is unreadable :-( Have they been told about the glories of
TeX and diff ?

> E.g., 6.3.15. NEW: TDH.IMPORT.MEM Leaf
> 
> It uses R12 and R13 as input.

12 and 14. They skipped 13 for some mysterious raisin.

But also, 10,11 are frequently used as input with this new stuff, which
already suggests the setup from your patches is not tenable.

> > Can we please make that a hard requirement, SEAMCALL must not use
> > registers outside this? We can hardly program to random future
> > extentions; we need hard ABI guarantees here.
> 
> 
> I believe all other GPRs are just saved/restored in SEAMCALL/SEAMRET, so in
> practice all other GPRs not used as input/output should not be clobbered.  But I
> will confirm with TDX module guys.  And even it's true in practice it's better
> to document it.  
> 
> But I think we also want to ask them to stop adding more registers as
> input/output.
> 
> I'll talk to TDX module team on this.

Please, because 12,14 are callee-saved, which means we need to go add
push/pop to preserve them :-(

Then you end up with something like this...

/*
 * TDX_MODULE_CALL - common helper macro for both
 *                 TDCALL and SEAMCALL instructions.
 *
 * TDCALL   - used by TDX guests to make requests to the
 *            TDX module and hypercalls to the VMM.
 * SEAMCALL - used by TDX hosts to make requests to the
 *            TDX module.
 *
 *-------------------------------------------------------------------------
 * TDCALL/SEAMCALL ABI:
 *-------------------------------------------------------------------------
 * Input Registers:
 *
 * RAX                 - TDCALL Leaf number.
 * RCX,RDX,R8-R11      - TDCALL Leaf specific input registers.
 *
 * Output Registers:
 *
 * RAX                 - TDCALL instruction error code.
 * RCX,RDX,R8-R11      - TDCALL Leaf specific output registers.
 * R12-R14	       - extra output registers
 *
 *-------------------------------------------------------------------------
 *
 * __tdx_module_call() function ABI:
 *
 * @fn   (RDI)         - TDCALL Leaf ID,    moved to RAX
 * @regs (RSI)         - struct tdx_regs pointer
 *
 * Return status of TDCALL via RAX.
 */
.macro TDX_MODULE_CALL host:req ret:req extra:0
	FRAME_BEGIN

	movq	%rdi, %rax
	movq	$TDX_SEAMCALL_VMFAILINVALID, %rdi

	movq	TDX_MODULE_rcx(%rsi), %rcx
	movq	TDX_MODULE_rdx(%rsi), %rdx
	movq	TDX_MODULE_r8(%rsi),  %r8
	movq	TDX_MODULE_r9(%rsi),  %r9
	movq	TDX_MODULE_r10(%rsi), %r10
	movq	TDX_MODULE_r11(%rsi), %r11
.if \extra
	pushq	r12
	pushq	r13
	pushq	r14

//	movq	TDX_MODULE_r12(%rsi), %r12
//	movq	TDX_MODULE_r13(%rsi), %r13
//	movq	TDX_MODULE_r14(%rsi), %r14
.endif

.if \host
1:	seamcall
	/*
	 * SEAMCALL instruction is essentially a VMExit from VMX root
	 * mode to SEAM VMX root mode.  VMfailInvalid (CF=1) indicates
	 * that the targeted SEAM firmware is not loaded or disabled,
	 * or P-SEAMLDR is busy with another SEAMCALL.  %rax is not
	 * changed in this case.
	 *
	 * Set %rax to TDX_SEAMCALL_VMFAILINVALID for VMfailInvalid.
	 * This value will never be used as actual SEAMCALL error code as
	 * it is from the Reserved status code class.
	 */
	cmovc	%rdi, %rax
2:
.else
	tdcall
.endif

.if \ret
	movq	%rcx, TDX_MODULE_rcx(%rsi)
	movq	%rdx, TDX_MODULE_rdx(%rsi)
	movq	%r8,  TDX_MODULE_r8(%rsi)
	movq	%r9,  TDX_MODULE_r9(%rsi)
	movq	%r10, TDX_MODULE_r10(%rsi)
	movq	%r11, TDX_MODULE_r11(%rsi)
.endif
.if \extra
	movq	%r12, TDX_MODULE_r12(%rsi)
	movq	%r13, TDX_MODULE_r13(%rsi)
	movq	%r14, TDX_MODULE_r14(%rsi)

	popq	%r14
	popq	%r13
	popq	%r12
.endif

	FRAME_END
	RET

.if \host
3:
	mov	$TDX_SW_ERROR, %rdi
	or	%rdi, %rax
	jmp 2b

	_ASM_EXTABLE_FAULT(1b, 3b)
.endif
.endm
