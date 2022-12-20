Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35353651CF5
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 10:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiLTJQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 04:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLTJQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 04:16:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA8595B0;
        Tue, 20 Dec 2022 01:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tLmDBRcb5bG0HEu7y3TsRnCiz9YjM9HkYhGNTN9FxjU=; b=A/Se8cRO5QDxTngZPZZNloMJWZ
        uG51t85sQf4iwVRFCoWyl8ikfeyiZM3Vgv0QNYJuzc+w8PVflica22xj70H3zxKCiMGqJViLp05vm
        Gnkx9booBqLDFkhSTABv3KtClAz/jDbyu/5NxI9JxD8/FqSk+nEnf8hwOljz0Pe2bQjkTM/eBOQSI
        63x79IkuUnFd3Mx7FHGB8zdMCOegX52rCnCZYeo37zDrxY0WPEgEueHGHYFJ+H/YXct1ZeI/liAMh
        Xk5IzUT9PjbDhpr7m4z8JeFythoYJ7cQSLsTcEUc2nENMk4Cu6+REkmuqnIU5vxuFQfeOM7sp67aJ
        e9seskVA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7Yj2-001dqa-W5; Tue, 20 Dec 2022 09:15:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DFB3E300023;
        Tue, 20 Dec 2022 10:15:41 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C344A2C5F830D; Tue, 20 Dec 2022 10:15:41 +0100 (CET)
Date:   Tue, 20 Dec 2022 10:15:41 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [RFC PATCH 18/32] x86/fred: add a debug fault entry stub for FRED
Message-ID: <Y6F9Pan/gY5Taty1@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-19-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220063658.19271-19-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022 at 10:36:44PM -0800, Xin Li wrote:

> +static __always_inline void debug_kernel_common(struct pt_regs *regs,
> +						unsigned long dr6)
>  {
> -	/*
> -	 * Disable breakpoints during exception handling; recursive exceptions
> -	 * are exceedingly 'fun'.
> -	 *
> -	 * Since this function is NOKPROBE, and that also applies to
> -	 * HW_BREAKPOINT_X, we can't hit a breakpoint before this (XXX except a
> -	 * HW_BREAKPOINT_W on our stack)
> -	 *
> -	 * Entry text is excluded for HW_BP_X and cpu_entry_area, which
> -	 * includes the entry stack is excluded for everything.
> -	 */
> -	unsigned long dr7 = local_db_save();
> -	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
>  	instrumentation_begin();
>  
>  	/*
> @@ -1062,7 +1050,8 @@ static __always_inline void exc_debug_kernel(struct pt_regs *regs,
>  	 * Catch SYSENTER with TF set and clear DR_STEP. If this hit a
>  	 * watchpoint at the same time then that will still be handled.
>  	 */
> -	if ((dr6 & DR_STEP) && is_sysenter_singlestep(regs))
> +	if (!cpu_feature_enabled(X86_FEATURE_FRED) &&
> +	    (dr6 & DR_STEP) && is_sysenter_singlestep(regs))
>  		dr6 &= ~DR_STEP;
>  
>  	/*
> @@ -1089,8 +1078,28 @@ static __always_inline void exc_debug_kernel(struct pt_regs *regs,
>  		regs->flags &= ~X86_EFLAGS_TF;
>  out:
>  	instrumentation_end();
> -	irqentry_nmi_exit(regs, irq_state);
> +}

Why doesn't the FRED handler get to to use irqentry_nmi_{enter,exit}() ?

> @@ -1179,6 +1188,24 @@ DEFINE_IDTENTRY_DEBUG_USER(exc_debug)
>  {
>  	exc_debug_user(regs, debug_read_clear_dr6());
>  }
> +
> +# ifdef CONFIG_X86_FRED
> +DEFINE_FRED_HANDLER(fred_exc_debug)
> +{
> +	/*
> +	 * The FRED debug information saved onto stack differs from
> +	 * DR6 in both stickiness and polarity; it is exactly what
> +	 * debug_read_clear_dr6() returns.
> +	 */
> +	unsigned long dr6 = fred_event_data(regs);
> +
> +	if (user_mode(regs))
> +		exc_debug_user(regs, dr6);
> +	else
> +		debug_kernel_common(regs, dr6);
> +}
> +# endif /* CONFIG_X86_FRED */

