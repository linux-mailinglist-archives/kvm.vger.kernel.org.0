Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631A2623E19
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 09:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiKJI4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 03:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKJI4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 03:56:49 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3510A3F078;
        Thu, 10 Nov 2022 00:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l+TRjxo7IPalxZWdUpMe9P3L9tHl56uBoUPSHQDClug=; b=itZ6NJLr08T6NzZSXaCaokzqO7
        nOoBXXdFOAhHkbIveoPKgHiz4exubCS5EHcbAl4GCqVtd6aq5aVGLEve9xeoBAWkz1h33SbmL6g5B
        tNNvQRm0Eg53EpuKMxNRNTkhdz6ytqB+JhsMo8ATtae1cRXJGocWeNEHgBluPxA6VsPmQxXLoLFSV
        Cmz4V54lT1BoIoJ+ThQ5n9LaGSebcHqEcaKbOphN2NHSRl6/1bCepiJgu4BJfZbbkrgS6LBEW8pvc
        zXtpz0gyDbVY2Q0zEHXl1BGIVqEAAL//f2ASd0FD7Nu444FBU3ksT1OEjNuMvEpnvjac3Zq7kNkzh
        Si/nDkzA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ot3Lu-00AF2Q-OK; Thu, 10 Nov 2022 08:56:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2E700300137;
        Thu, 10 Nov 2022 09:56:01 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 11C02201A6C3D; Thu, 10 Nov 2022 09:56:01 +0100 (CET)
Date:   Thu, 10 Nov 2022 09:56:01 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com
Subject: Re: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Message-ID: <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110061545.1531-3-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 10:15:41PM -0800, Xin Li wrote:
> Upon receiving an external interrupt, KVM VMX reinjects it through
> calling the interrupt handler in its IDT descriptor on the current
> kernel stack, which essentially uses the IDT as an interrupt dispatch
> table.
> 
> However the IDT is one of the lowest level critical data structures
> between a x86 CPU and the Linux kernel, we should avoid using it
> *directly* whenever possible, espeically in a software defined manner.
> 
> On x86, external interrupts are divided into the following groups
>   1) system interrupts
>   2) external device interrupts
> With the IDT, system interrupts are dispatched through the IDT
> directly, while external device interrupts are all routed to the
> external interrupt dispatch function common_interrupt(), which
> dispatches external device interrupts through a per-CPU external
> interrupt dispatch table vector_irq.
> 
> To eliminate dispatching external interrupts through the IDT, add
> a system interrupt handler table for dispatching a system interrupt
> to its corresponding handler directly. Thus a software based dispatch
> function will be:
> 
>   void external_interrupt(struct pt_regs *regs, u8 vector)
>   {
>     if (is_system_interrupt(vector))
>       system_interrupt_handler_table[vector_to_sysvec(vector)](regs);
>     else /* external device interrupt */
>       common_interrupt(regs, vector);
>   }
> 
> What's more, with the Intel FRED (Flexible Return and Event Delivery)
> architecture, IDT, the hardware based event dispatch table, is gone,
> and the Linux kernel needs to dispatch events to their handlers with
> vector to handler mappings, the dispatch function external_interrupt()
> is also needed.
> 
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>

This is not a valid SOB, it would suggest hpa is the author, but he's
not in in From.

> ---
>  arch/x86/include/asm/traps.h |  8 ++++++
>  arch/x86/kernel/traps.c      | 55 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 47ecfff2c83d..3dc63d753bda 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -47,4 +47,12 @@ void __noreturn handle_stack_overflow(struct pt_regs *regs,
>  				      struct stack_info *info);
>  #endif
>  
> +/*
> + * How system interrupt handlers are called.
> + */
> +#define DECLARE_SYSTEM_INTERRUPT_HANDLER(f)			\
> +	void f (struct pt_regs *regs __maybe_unused,		\
> +		unsigned long vector __maybe_unused)
> +typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
> +
>  #endif /* _ASM_X86_TRAPS_H */
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 178015a820f0..95dd917ef9ad 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -1444,6 +1444,61 @@ DEFINE_IDTENTRY_SW(iret_error)
>  }
>  #endif
>  
> +#define SYSV(x,y) [(x) - FIRST_SYSTEM_VECTOR] = (system_interrupt_handler)y
> +
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Wcast-function-type"

How does this not break CFI ?
