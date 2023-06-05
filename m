Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A0672211C
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 10:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjFEIfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 04:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjFEIfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 04:35:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E971B0;
        Mon,  5 Jun 2023 01:35:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685954098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E8n9ePnUhtnsNw0/UoOy8KZA0t9F5cn2eYE4giKiTxQ=;
        b=ZYLMwKJonIHpbWbqUCUtNKvKVLq4FP6ro5oS/wilSBp/vqjxGVCpcgLTYoa1RhxoCJnFPm
        vxMEYmJhPorHuS/9bsQLXG+h+xrcxlXgJyrHYl6wjLVRyW+sa3UAQQx0x72Sc+aD3QOWNu
        M6M5n333FFxZ1oXfESc8AZVrsULI2XFJYINjt4WCX5IWUTSD38VRTKmhb+gli3XIyDA+Rf
        CvoTPDZENltfWrOlu4xOG/89O1D8oVnVJInPiWcvq2sAtPQ43RN8P0CuyCtyk6ov3d3/We
        mpRDy+TJxK/mtJdBJeX290BhCCGYQAjXPAXwKzUQ0JddPcVTqWrxdrM1fTeEzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685954098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E8n9ePnUhtnsNw0/UoOy8KZA0t9F5cn2eYE4giKiTxQ=;
        b=54x6bmSB+5xXMohPCz/svOxKGcZmUS+Ga0otaExKp5Egqb7huWQ3gf7RNn8sDHvn6xoUpl
        xXid46SPiohH4BCQ==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 03/33] x86/traps: add a system interrupt table for
 system interrupt dispatch
In-Reply-To: <20230410081438.1750-4-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-4-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 10:34:58 +0200
Message-ID: <877csi8fyl.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
>  
>  /**
>   * DECLARE_IDTENTRY_IRQ - Declare functions for device interrupt IDT entry
> - *			  points (common/spurious)
> + *			  points (common/spurious) and their corresponding
> + *			  software based dispatch handlers in the non-noinstr
> + *			  text section
>   * @vector:	Vector number (ignored for C)
>   * @func:	Function name of the entry point
>   *
> - * Maps to DECLARE_IDTENTRY_ERRORCODE()
> + * Maps to DECLARE_IDTENTRY_ERRORCODE(), plus a dispatch function prototype
>   */
>  #define DECLARE_IDTENTRY_IRQ(vector, func)				\
> -	DECLARE_IDTENTRY_ERRORCODE(vector, func)
> +	DECLARE_IDTENTRY_ERRORCODE(vector, func);			\
> +	void dispatch_##func(struct pt_regs *regs, unsigned long
>  error_code)

Can these IDTENTRY changes please be separate from the actual table
implementation?
  
>  
> +#ifdef CONFIG_X86_64
> +
> +#ifndef CONFIG_X86_LOCAL_APIC

Seriously? You _cannot_ disable local APIC on x8664 builds.

> +/*
> + * Used when local APIC is not configured to build into the kernel, but
> + * dispatch_table_spurious_interrupt() needs
> dispatch_spurious_interrupt().

What? If you there is something which is not used in a certain
configuration then just exclude it via #ifdef in the table or provide a

#define foo   NULL

if you want to spare the #ifdeffery.

> + */
> +DEFINE_IDTENTRY_IRQ(spurious_interrupt)
> +{
> +	pr_info("Spurious interrupt (vector 0x%x) on CPU#%d, should never happen.\n",
> +		vector, smp_processor_id());
> +}

But mindlessly copying code which is even never compiled is a pretty
pointless exercise.

> +#endif
> +
> +static void dispatch_table_spurious_interrupt(struct pt_regs *regs)
> +{
> +	dispatch_spurious_interrupt(regs, regs->vector);
> +}
> +
> +#define SYSV(x,y) [(x) - FIRST_SYSTEM_VECTOR] = y
> +
> +static system_interrupt_handler system_interrupt_handlers[NR_SYSTEM_VECTORS] = {
> +	[0 ... NR_SYSTEM_VECTORS-1]		= dispatch_table_spurious_interrupt,
> +#ifdef CONFIG_SMP
> +	SYSV(RESCHEDULE_VECTOR,			dispatch_table_sysvec_reschedule_ipi),
> +	SYSV(CALL_FUNCTION_VECTOR,		dispatch_table_sysvec_call_function),
> +	SYSV(CALL_FUNCTION_SINGLE_VECTOR,	dispatch_table_sysvec_call_function_single),
> +	SYSV(REBOOT_VECTOR,			dispatch_table_sysvec_reboot),
> +#endif
> +
> +#ifdef CONFIG_X86_THERMAL_VECTOR
> +	SYSV(THERMAL_APIC_VECTOR,		dispatch_table_sysvec_thermal),
> +#endif
> +
> +#ifdef CONFIG_X86_MCE_THRESHOLD
> +	SYSV(THRESHOLD_APIC_VECTOR,		dispatch_table_sysvec_threshold),
> +#endif
> +
> +#ifdef CONFIG_X86_MCE_AMD
> +	SYSV(DEFERRED_ERROR_VECTOR,		dispatch_table_sysvec_deferred_error),
> +#endif
> +
> +#ifdef CONFIG_X86_LOCAL_APIC
> +	SYSV(LOCAL_TIMER_VECTOR,		dispatch_table_sysvec_apic_timer_interrupt),
> +	SYSV(X86_PLATFORM_IPI_VECTOR,		dispatch_table_sysvec_x86_platform_ipi),
> +# ifdef CONFIG_HAVE_KVM
> +	SYSV(POSTED_INTR_VECTOR,		dispatch_table_sysvec_kvm_posted_intr_ipi),
> +	SYSV(POSTED_INTR_WAKEUP_VECTOR,		dispatch_table_sysvec_kvm_posted_intr_wakeup_ipi),
> +	SYSV(POSTED_INTR_NESTED_VECTOR,		dispatch_table_sysvec_kvm_posted_intr_nested_ipi),
> +# endif
> +# ifdef CONFIG_IRQ_WORK
> +	SYSV(IRQ_WORK_VECTOR,			dispatch_table_sysvec_irq_work),
> +# endif
> +	SYSV(SPURIOUS_APIC_VECTOR,		dispatch_table_sysvec_spurious_apic_interrupt),

This is clearly in the #ifdef CONFIG_X86_LOCAL_APIC, so what is the
above hackery useful for?

> +	SYSV(ERROR_APIC_VECTOR,			dispatch_table_sysvec_error_interrupt),
> +#endif
> +};

Thanks,

        tglx
