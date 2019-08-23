Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05509A978
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 09:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387674AbfHWH7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 03:59:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55856 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731700AbfHWH7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 03:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BVrbQe8ircJFDpKbFl4qSXEUGsJpAUh/e+k1VZjAJUI=; b=gZW3ESVoFjFL0zDVK/0iQpWtP
        dfR1uRXHdbPXSuB6iaf2NNgYyqus97bt1G8MxATLN1pnNor0iVgDTFP3M5yZP0y/iPOo+UNI7rdGL
        1qVA/MzvlKPhS+9Slaxz5+FrY5KUh3TRx0Xw/XV9UEraj43gA3xyIeXf4d5alGejiqbhUxToYG2Dc
        3rFH8tNMvo6kaSTXVuv6WS+rqklt+eeNVMATpbF1k4V23R1+VLis8Z6QVAmoKn3hurFDFso07R2RX
        FD9C5djUI7ZS43FRU5LV3er7mFf4iOP9BT9dQR+ndyXFv3GRNa0edFsnsuSGSS3P4zpE3VunCBszw
        AFuuEJ7Iw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i14Tw-0008EQ-EO; Fri, 23 Aug 2019 07:59:36 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1FA5C30759B;
        Fri, 23 Aug 2019 09:59:01 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7E64C20F61BEF; Fri, 23 Aug 2019 09:59:33 +0200 (CEST)
Date:   Fri, 23 Aug 2019 09:59:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC
 on i386
Message-ID: <20190823075933.GY2369@hirez.programming.kicks-ass.net>
References: <20190822211122.27579-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822211122.27579-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 02:11:22PM -0700, Sean Christopherson wrote:
> Use 'lea' instead of 'add' when adjusting %rsp in CALL_NOSPEC so as to
> avoid clobbering flags.
> 
> KVM's emulator makes indirect calls into a jump table of sorts, where
> the destination of the CALL_NOSPEC is a small blob of code that performs
> fast emulation by executing the target instruction with fixed operands.
> 
>   adcb_al_dl:
>      0x000339f8 <+0>:   adc    %dl,%al
>      0x000339fa <+2>:   ret
> 
> A major motiviation for doing fast emulation is to leverage the CPU to
> handle consumption and manipulation of arithmetic flags, i.e. RFLAGS is
> both an input and output to the target of CALL_NOSPEC.  Clobbering flags
> results in all sorts of incorrect emulation, e.g. Jcc instructions often
> take the wrong path.  Sans the nops...
> 
>   asm("push %[flags]; popf; " CALL_NOSPEC " ; pushf; pop %[flags]\n"
>      0x0003595a <+58>:  mov    0xc0(%ebx),%eax
>      0x00035960 <+64>:  mov    0x60(%ebx),%edx
>      0x00035963 <+67>:  mov    0x90(%ebx),%ecx
>      0x00035969 <+73>:  push   %edi
>      0x0003596a <+74>:  popf
>      0x0003596b <+75>:  call   *%esi
>      0x000359a0 <+128>: pushf
>      0x000359a1 <+129>: pop    %edi
>      0x000359a2 <+130>: mov    %eax,0xc0(%ebx)
>      0x000359b1 <+145>: mov    %edx,0x60(%ebx)
> 
>   ctxt->eflags = (ctxt->eflags & ~EFLAGS_MASK) | (flags & EFLAGS_MASK);
>      0x000359a8 <+136>: mov    -0x10(%ebp),%eax
>      0x000359ab <+139>: and    $0x8d5,%edi
>      0x000359b4 <+148>: and    $0xfffff72a,%eax
>      0x000359b9 <+153>: or     %eax,%edi
>      0x000359bd <+157>: mov    %edi,0x4(%ebx)
> 
> For the most part this has gone unnoticed as emulation of guest code
> that can trigger fast emulation is effectively limited to MMIO when
> running on modern hardware, and MMIO is rarely, if ever, accessed by
> instructions that affect or consume flags.

Also, because nobody every uses 32bit anymore, I suspect ;-)

> Breakage is almost instantaneous when running with unrestricted guest
> disabled, in which case KVM must emulate all instructions when the guest
> has invalid state, e.g. when the guest is in Big Real Mode during early
> BIOS.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: <kvm@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> Fixes: 1a29b5b7f347a ("KVM: x86: Make indirect calls in emulator speculation safe")

Cute; arguably this is a fix for:

776b043848fd2 ("x86/retpoline: Add initial retpoline support")

The patch you quote just happens to trigger it in KVM, but you're right
to note that CALL shouldn't frob EFLAGS, and who knows what possible
other sites care.

Anyway,

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/nospec-branch.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 109f974f9835..80bc209c0708 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -192,7 +192,7 @@
>  	"    	lfence;\n"					\
>  	"       jmp    902b;\n"					\
>  	"       .align 16\n"					\
> -	"903:	addl   $4, %%esp;\n"				\
> +	"903:	lea    4(%%esp), %%esp;\n"			\
>  	"       pushl  %[thunk_target];\n"			\
>  	"       ret;\n"						\
>  	"       .align 16\n"					\
> -- 
> 2.22.0
> 
