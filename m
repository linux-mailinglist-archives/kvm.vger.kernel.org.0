Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DF772218E
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 10:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjFEI5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 04:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjFEI5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 04:57:41 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311F383;
        Mon,  5 Jun 2023 01:57:39 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685955458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tuEkjNVEJ3j/43zY6b+9s7oKjaQbFi38GVw4aDtO4j8=;
        b=VdAJFx/sFaXO/52StCccf9+2cWQeeCijqidyPyKgTSGB6zopsc3qMlsfLU2vhce/6LCCtt
        iBoAGJhluF/ZwykTFyBeORSwWItVLzUQfB4HHgC+5SEuxhByHPbd99ph4rhOEiPU9Qkc02
        2GbrJwNzB9SsIDLtuji2es44QJNFDA+fnmfOlUK35zNY9Xah9I9qezFDE2nkEkKXVgK6OD
        J+R08effDEDw/Drb3kOdhe6TUdJyADGWyIGVyEeutli4nzrElizfzVR5pWg2zf6et6hTna
        e8GXtFvcv/+NpVenLeRW4sTsgP8TQoOuetoS0AxfG+dyQ9EJ7NeFMN6L5MU5KQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685955458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tuEkjNVEJ3j/43zY6b+9s7oKjaQbFi38GVw4aDtO4j8=;
        b=ydXyr9/G94Bk+OvplT7yjR3ywDeQ+2M3eMtRE8y8FRjT2W1ITGnm/qDdSRFMLWtAAcGsbt
        zZ4pu7lOGt+2D/BA==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 04/33] x86/traps: add install_system_interrupt_handler()
In-Reply-To: <20230410081438.1750-5-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-5-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 10:57:37 +0200
Message-ID: <87y1ky70ce.ffs@tglx>
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
> Some kernel components install system interrupt handlers into the IDT,
> and we need to do the same for system_interrupt_handlers.

We need to the same? This sentence does not make any sense at all.

  https://www.kernel.org/doc/html/latest/process/maintainer-tip.html

> +void install_system_interrupt_handler(unsigned int n, const void *asm_addr, const void *addr);

Why is this void *?

>  
> +void __init install_system_interrupt_handler(unsigned int n, const void *asm_addr, const void *addr)
> +{
> +	BUG_ON(n < FIRST_SYSTEM_VECTOR);
> +
> +#ifdef CONFIG_X86_64
> +	system_interrupt_handlers[n - FIRST_SYSTEM_VECTOR] = (system_interrupt_handler)addr;

Just that you can add a silly typecast here, right?

Oh well.

> -	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_xen_hvm_callback);
> +	install_system_interrupt_handler(HYPERVISOR_CALLBACK_VECTOR,
> +					 asm_sysvec_xen_hvm_callback,
> +					 sysvec_xen_hvm_callback);

Can we please make this less convoluted?

#ifdef CONFIG_X86_64
static inline void sysvec_setup_fred(unsigned int vector, void (*func)(struct pt_regs*))
{
        ...
}
#else
static inline void sysvec_setup_fred(unsigned int vector, void (*func)(struct pt_regs*))
{
}
#endif

#define sysvec_install(vector, func) {                                  \
        sysvec_setup_fred(vector, func);                                \
        alloc_intr_gate(vector, asm_##func);                            \
}

-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_xen_hvm_callback);
+	sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_xen_hvm_callback);

No?

Thanks,

        tglx
