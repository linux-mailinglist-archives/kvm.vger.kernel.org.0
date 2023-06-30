Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6FB7437DB
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjF3JD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbjF3JDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:03:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB11C2118;
        Fri, 30 Jun 2023 02:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688115800; x=1719651800;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G4tgA5Quxms81FQitPgPzP60ScKph30Y7igWUr2N9eg=;
  b=QLMjkTlOT92fEDbPTZ5LVOlPKtEhLNQ1evgZM/D5mJE3HR6TRoUFiu4N
   QzepQ16Dur//5lovbi79xx6bs4tDCiqWj34g4v6ppB1E8M9h+sgyMG454
   PLl8x+9hei+pw45+rWJaQOYOu4ss0MCBgrGFnvaOBe/Ej/pjFV1CvzzVi
   wn3du7m8RPYp9m7IRJDh1r7bM7IDMyvhd/h5sVGgfYz+0yGd5FB02w8Kr
   QSP9uobdkKqn+XNeECWAfIB/Z0+ts5nWTi/n6/ro52CV7W+2YSfBewo5c
   JaVb9zHgJ7EqjOiNlWsqz6J9c88gykKup6/ffwU4y08PjrgzctEcfLC5G
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="342690207"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="342690207"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 02:03:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="694958090"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="694958090"
Received: from valeriik-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.49.47])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 02:03:12 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id DC7D3109754; Fri, 30 Jun 2023 12:03:09 +0300 (+03)
Date:   Fri, 30 Jun 2023 12:03:09 +0300
From:   kirill.shutemov@linux.intel.com
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        dave.hansen@intel.com, tony.luck@intel.com, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230630090309.6mnsvfhcptekmzfu@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <20230628211132.GS38236@hirez.programming.kicks-ass.net>
 <20230628211641.GT38236@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628211641.GT38236@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 11:16:41PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 28, 2023 at 11:11:32PM +0200, Peter Zijlstra wrote:
> > --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> > +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> > @@ -17,37 +17,44 @@
> >   *            TDX module and hypercalls to the VMM.
> >   * SEAMCALL - used by TDX hosts to make requests to the
> >   *            TDX module.
> > + *
> > + *-------------------------------------------------------------------------
> > + * TDCALL/SEAMCALL ABI:
> > + *-------------------------------------------------------------------------
> > + * Input Registers:
> > + *
> > + * RAX                 - TDCALL Leaf number.
> > + * RCX,RDX,R8-R9       - TDCALL Leaf specific input registers.
> > + *
> > + * Output Registers:
> > + *
> > + * RAX                 - TDCALL instruction error code.
> > + * RCX,RDX,R8-R11      - TDCALL Leaf specific output registers.
> > + *
> > + *-------------------------------------------------------------------------
> > + *
> > + * __tdx_module_call() function ABI:
> > + *
> > + * @fn   (RDI)         - TDCALL Leaf ID,    moved to RAX
> > + * @regs (RSI)         - struct tdx_regs pointer
> > + *
> > + * Return status of TDCALL via RAX.
> >   */
> > +.macro TDX_MODULE_CALL host:req ret:req
> > +	FRAME_BEGIN
> >  
> > +	mov	%rdi, %rax
> > +	mov	$TDX_SEAMCALL_VMFAILINVALID, %rdi
> >  
> > +	mov	TDX_MODULE_rcx(%rsi), %rcx
> > +	mov	TDX_MODULE_rdx(%rsi), %rdx
> > +	mov	TDX_MODULE_r8(%rsi),  %r8
> > +	mov	TDX_MODULE_r9(%rsi),  %r9
> > +//	mov	TDX_MODULE_r10(%rsi), %r10
> > +//	mov	TDX_MODULE_r11(%rsi), %r11
> >  
> > +.if \host
> > +1:	seamcall
> >  	/*
> >  	 * SEAMCALL instruction is essentially a VMExit from VMX root
> >  	 * mode to SEAM VMX root mode.  VMfailInvalid (CF=1) indicates
> 	...
> >  	 * This value will never be used as actual SEAMCALL error code as
> >  	 * it is from the Reserved status code class.
> >  	 */
> > +	cmovc	%rdi, %rax
> >  2:
> > +.else
> >  	tdcall
> > +.endif
> >  
> > +.if \ret
> > +	movq %rcx, TDX_MODULE_rcx(%rsi)
> > +	movq %rdx, TDX_MODULE_rdx(%rsi)
> > +	movq %r8,  TDX_MODULE_r8(%rsi)
> > +	movq %r9,  TDX_MODULE_r9(%rsi)
> > +	movq %r10, TDX_MODULE_r10(%rsi)
> > +	movq %r11, TDX_MODULE_r11(%rsi)
> > +.endif
> > +
> > +	FRAME_END
> > +	RET
> > +
> > +.if \host
> > +3:
> > +	mov	$TDX_SW_ERROR, %rdi
> > +	or	%rdi, %rax
> > +	jmp 2b
> >  
> > +	_ASM_EXTABLE_FAULT(1b, 3b)
> > +.endif
> >  .endm
> 
> Isn't that much simpler?

I'm okay either way.

Obviously, arch/x86/coco/tdx/tdcall.S has to be patched to use the new
TDX_MODULE_CALL macro.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
