Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF0C269C05
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 04:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgIOCmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 22:42:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:58954 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgIOCmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 22:42:02 -0400
IronPort-SDR: AB/2b5g1mhnqbDWad7WIFULemAnflptnRXCzhImn/kBPFYa1zl5ZEB5Sj9gvdHUgZrRmVp2sG9
 GRj0JqTciCoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="146879518"
X-IronPort-AV: E=Sophos;i="5.76,428,1592895600"; 
   d="scan'208";a="146879518"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 19:42:02 -0700
IronPort-SDR: BmrQGyB+8l574LwXi+Sq9NLBI0yRDeieQgipDhcbe6Xk0rr16sfhjEsOw1tzOMjx/ct/hoZSqz
 h14tUu38B/9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,428,1592895600"; 
   d="scan'208";a="343330939"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.54.74.11])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Sep 2020 19:42:01 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id B4C26301C59; Mon, 14 Sep 2020 19:42:01 -0700 (PDT)
Date:   Mon, 14 Sep 2020 19:42:01 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Move IRQ invocation to assembly subroutine
Message-ID: <20200915024201.GA13818@tassilo.jf.intel.com>
References: <20200914195634.12881-1-sean.j.christopherson@intel.com>
 <20200914195634.12881-2-sean.j.christopherson@intel.com>
 <20200914204024.w3rpjon64d3fesys@treble>
 <20200914210719.GB7084@sjchrist-ice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914210719.GB7084@sjchrist-ice>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 02:07:19PM -0700, Sean Christopherson wrote:
> 16-byte aligned to correctly mimic CPU behavior when vectoring an IRQ/NMI.
> When not changing stack, the CPU aligns RSP before pushing the frame.

16 byte alignment is not needed for the internal kernel ABI because it doesn't use
SSE.

-Andi

> 
> The above shenanigans work because the x86-64 ABI also requires RSP to be
> 16-byte aligned prior to CALL.  RSP is thus 8-byte aligned due to CALL
> pushing the return IP, and so creating the stack frame by pushing RBP makes
> it 16-byte aliagned again.
> 
> > > +
> > > +#ifdef CONFIG_X86_64
> > > +	push $__KERNEL_DS
> > > +	push %_ASM_BP
> > > +#endif
> > > +	pushf
> > > +	push $__KERNEL_CS
> > > +	CALL_NOSPEC _ASM_ARG1
> > > +
> > > +	/*
> > > +	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
> > > +	 * the correct value.  objtool doesn't know the target will IRET and so
> > > +	 * thinks the stack is getting walloped (without the explicit restore).
> > > +	 */
> > > +	mov %_ASM_BP, %rsp
> > > +	pop %_ASM_BP
> > > +	ret
> > 
> > BTW, there *is* actually an unwind hint for this situation:
> > UNWIND_HINT_RET_OFFSET.
> 
> I played with that one, but for the life of me couldn't figure out how to
> satisfy both the "stack size" and "cfa.offset" checks.  In the code below,
> cfa.offset will be 8, stack_size will be 40 and initial_func_cfi.cfa.offset
> will be 8.  But rereading this, I assume I missed something that would allow
> maniuplating cfa.offset?  Or maybe I botched my debugging?
> 
> static bool has_modified_stack_frame(struct instruction *insn, struct insn_state *state)
> {
> 	...
> 
>         if (cfi->cfa.offset != initial_func_cfi.cfa.offset + ret_offset)
>                 return true;
> 
>         if (cfi->stack_size != initial_func_cfi.cfa.offset + ret_offset)
>                 return true;
> 
> 	...
> }
>  
> > So you might be able to do something like the following (depending on
> > what your alignment requirements actually are):
> > 
> > SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
> > #ifdef CONFIG_X86_64
> > 	push $__KERNEL_DS
> > 	push %_ASM_BP
> > #endif
> > 	pushf
> > 	push $__KERNEL_CS
> > 	CALL_NOSPEC _ASM_ARG1
> > 
> > 	/* The call popped the pushes */
> > 	UNWIND_HINT_RET_OFFSET sp_offset=32
> > 
> > 	ret
> > SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
> > 
> > -- 
> > Josh
> > 
