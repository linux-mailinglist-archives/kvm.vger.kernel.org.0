Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE422697CD
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgINViY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:38:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbgINViV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 17:38:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600119499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/v1wwDAFZE/oB9w58Q8ZV7TM6ldOPRAWCKUXh0ELQS4=;
        b=OqBeSd/9qDmynAINKQkxq4LYxPWF5Semjf2ZaxpfYm8VO5p+8yPtaljPqQWE74O+Dpq4+s
        FXnJcfWcrQOyCVVSnXuaBEn+XJRorsooX6A+uzsCRAi97fcHwvvVRbjczKbvMyWItzj5T9
        JgaYuIXx3EoBpBBIgz7GPKBDflOig/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-ZvBjN7b6OOaJemwRKH6PiQ-1; Mon, 14 Sep 2020 17:38:18 -0400
X-MC-Unique: ZvBjN7b6OOaJemwRKH6PiQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0EEB420E9;
        Mon, 14 Sep 2020 21:38:16 +0000 (UTC)
Received: from treble (ovpn-115-26.rdu2.redhat.com [10.10.115.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39EFC19C4F;
        Mon, 14 Sep 2020 21:38:15 +0000 (UTC)
Date:   Mon, 14 Sep 2020 16:38:13 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Move IRQ invocation to assembly subroutine
Message-ID: <20200914213813.zfxlffphcp5czvof@treble>
References: <20200914195634.12881-1-sean.j.christopherson@intel.com>
 <20200914195634.12881-2-sean.j.christopherson@intel.com>
 <20200914204024.w3rpjon64d3fesys@treble>
 <20200914210719.GB7084@sjchrist-ice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200914210719.GB7084@sjchrist-ice>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 02:07:19PM -0700, Sean Christopherson wrote:
> > RSP needs to be aligned to what?  How would this align the stack, other
> > than by accident?
> 
> Ah, yeah, that's lacking info.
> 
> 16-byte aligned to correctly mimic CPU behavior when vectoring an IRQ/NMI.
> When not changing stack, the CPU aligns RSP before pushing the frame.
> 
> The above shenanigans work because the x86-64 ABI also requires RSP to be
> 16-byte aligned prior to CALL.  RSP is thus 8-byte aligned due to CALL
> pushing the return IP, and so creating the stack frame by pushing RBP makes
> it 16-byte aliagned again.

As Uros mentioned, the kernel doesn't do this.

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

It only works without the frame pointer, in which case stack size and
cfa.offset will be the same (see below code).  With the frame pointer,
it probably wouldn't work.

But if you're going to be aligning the stack in the next patch version,
your frame pointer approach works better anyway, because the stack size
will be variable depending on the stack alignment of the callee.  So
forget I said anything :-)

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

-- 
Josh

