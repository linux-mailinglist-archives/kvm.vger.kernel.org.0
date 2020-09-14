Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125792696D1
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgINUkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:40:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbgINUkf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 16:40:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600116033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UBsIQsnyUT0RduIlv4tBtHoJIFfT0hnAJ3Ijxqz8sck=;
        b=e0yxQfhUcrRarf/94y1lnJZYsvQqlcTRN+F7amxIFsAXbfnJQVZ0eGjJ9GgUd7WHCmDi5e
        6n9+AzD6EcQB8ydoxcT2yvjQ2gh2t3ZcRByS+nEd7ey24bYYoVxt7fMmMeimEu7BGb9wvp
        3cubajz3+Fc/uE6NtwSjK39cRnVEO9I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-AghiDWkqO1CS4_cGkY_2TQ-1; Mon, 14 Sep 2020 16:40:32 -0400
X-MC-Unique: AghiDWkqO1CS4_cGkY_2TQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64EEC1017DC3;
        Mon, 14 Sep 2020 20:40:29 +0000 (UTC)
Received: from treble (ovpn-115-26.rdu2.redhat.com [10.10.115.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFF195DC06;
        Mon, 14 Sep 2020 20:40:27 +0000 (UTC)
Date:   Mon, 14 Sep 2020 15:40:24 -0500
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
Message-ID: <20200914204024.w3rpjon64d3fesys@treble>
References: <20200914195634.12881-1-sean.j.christopherson@intel.com>
 <20200914195634.12881-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200914195634.12881-2-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 12:56:33PM -0700, Sean Christopherson wrote:
> Move the asm blob that invokes the appropriate IRQ handler after VM-Exit
> into a proper subroutine.  Slightly rework the blob so that it plays
> nice with objtool without any additional hints (existing hints aren't
> able to handle returning with a seemingly modified stack size).
> 
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Uros Bizjak <ubizjak@gmail.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 28 ++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c     | 33 +++------------------------------
>  2 files changed, 31 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 799db084a336..baec1e0fefc5 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -4,6 +4,7 @@
>  #include <asm/bitsperlong.h>
>  #include <asm/kvm_vcpu_regs.h>
>  #include <asm/nospec-branch.h>
> +#include <asm/segment.h>
>  
>  #define WORD_SIZE (BITS_PER_LONG / 8)
>  
> @@ -294,3 +295,30 @@ SYM_FUNC_START(vmread_error_trampoline)
>  
>  	ret
>  SYM_FUNC_END(vmread_error_trampoline)
> +
> +SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
> +	/*
> +	 * Unconditionally create a stack frame.  RSP needs to be aligned for
> +	 * x86-64, getting the correct RSP on the stack (for x86-64) would take
> +	 * two instructions anyways, and it helps make objtool happy (see below).
> +	 */
> +	push %_ASM_BP
> +	mov %rsp, %_ASM_BP

RSP needs to be aligned to what?  How would this align the stack, other
than by accident?

> +
> +#ifdef CONFIG_X86_64
> +	push $__KERNEL_DS
> +	push %_ASM_BP
> +#endif
> +	pushf
> +	push $__KERNEL_CS
> +	CALL_NOSPEC _ASM_ARG1
> +
> +	/*
> +	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
> +	 * the correct value.  objtool doesn't know the target will IRET and so
> +	 * thinks the stack is getting walloped (without the explicit restore).
> +	 */
> +	mov %_ASM_BP, %rsp
> +	pop %_ASM_BP
> +	ret

BTW, there *is* actually an unwind hint for this situation:
UNWIND_HINT_RET_OFFSET.

So you might be able to do something like the following (depending on
what your alignment requirements actually are):

SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
#ifdef CONFIG_X86_64
	push $__KERNEL_DS
	push %_ASM_BP
#endif
	pushf
	push $__KERNEL_CS
	CALL_NOSPEC _ASM_ARG1

	/* The call popped the pushes */
	UNWIND_HINT_RET_OFFSET sp_offset=32

	ret
SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)

-- 
Josh

