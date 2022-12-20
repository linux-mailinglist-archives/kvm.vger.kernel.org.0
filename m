Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51927651D84
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 10:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiLTJgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 04:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbiLTJf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 04:35:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5A813DC8;
        Tue, 20 Dec 2022 01:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wWwBRfhREBzIuxwu2AGHtH/z3yzlcL1AQ6b18LIlSD0=; b=eHJd+DJloc9zm9cS9SszTESBLB
        YG2VDb+z31bJ4gbgw19BDTcz67uM1jHGlRFjtD5AuCxkGQMgCyb2YNWMTZ5TIcNvlEY1h1TOHI0lk
        TdwFV9HH4aCO2AX9QYTFWGR6Aqi3SlCCsRpoP2NvADJ9DfZp3RNzVmx6PbLaXSnnUmOMnuB6ZgxIm
        hf63GH38BKU52LBHdqQYvNnugvhGDOmKwB03nAAI6lsydtSa/JdOholfX1mf0Bsf9HvBG+o1O/7V2
        l4rJGiRkN/wVZfG+yD4upDBSS0a3ohXJqvXFDZkT3DuBNtaF43oZH9f2/PnriPdmypwWcQJNfE2d4
        ROYx8DKQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7Z2G-001exO-Vi; Tue, 20 Dec 2022 09:35:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D42F430006D;
        Tue, 20 Dec 2022 10:35:32 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BB4E52C5F830C; Tue, 20 Dec 2022 10:35:32 +0100 (CET)
Date:   Tue, 20 Dec 2022 10:35:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [RFC PATCH 21/32] x86/fred: FRED entry/exit and dispatch code
Message-ID: <Y6GB5C1Bx60L9hk3@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-22-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220063658.19271-22-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022 at 10:36:47PM -0800, Xin Li wrote:

> +static DEFINE_FRED_HANDLER(fred_exception)
> +{
> +	/*
> +	 * This intentially omits exceptions that cannot happen on FRED h/w:
> +	 * vectors _NOT_ listed are set to NULL.
> +	 */
> +	static const fred_handler exception_handlers[NUM_EXCEPTION_VECTORS] = {
> +		[X86_TRAP_DE] = fred_exc_divide_error,
> +		[X86_TRAP_DB] = fred_exc_debug,
> +		[X86_TRAP_NMI] = NULL, /* A separate event type, not handled here */
> +		[X86_TRAP_BP] = exc_int3,
> +		[X86_TRAP_OF] = fred_exc_overflow,
> +		[X86_TRAP_BR] = fred_exc_bounds,
> +		[X86_TRAP_UD] = exc_invalid_op,
> +		[X86_TRAP_NM] = fred_exc_device_not_available,
> +		[X86_TRAP_DF] = fred_exc_double_fault,
> +		[X86_TRAP_OLD_MF] = NULL, /* 387 only! */
> +		[X86_TRAP_TS] = fred_exc_invalid_tss,
> +		[X86_TRAP_NP] = fred_exc_segment_not_present,
> +		[X86_TRAP_SS] = fred_exc_stack_segment,
> +		[X86_TRAP_GP] = fred_exc_general_protection,
> +		[X86_TRAP_PF] = fred_exc_page_fault,
> +		[X86_TRAP_SPURIOUS] = NULL, /* Interrupts are their own event type */
> +		[X86_TRAP_MF] = fred_exc_coprocessor_error,
> +		[X86_TRAP_AC] = fred_exc_alignment_check,
> +		[X86_TRAP_MC] = fred_exc_machine_check,
> +		[X86_TRAP_XF] = fred_exc_simd_coprocessor_error
> +	};
> +	static const u32 noinstr_mask = BIT(X86_TRAP_DB) | BIT(X86_TRAP_BP) |
> +					BIT(X86_TRAP_DF) | BIT(X86_TRAP_PF) |
> +					BIT(X86_TRAP_MC) | BIT(X86_TRAP_UD);
> +	u8 vector = array_index_nospec((u8)regs->vector, NUM_EXCEPTION_VECTORS);
> +	irqentry_state_t state;
> +
> +	if (likely(exception_handlers[vector])) {

Can't you get rid of this branch by stuffing the exception_handlers[]
table with fred_bad_event?

> +		if (!(BIT(vector) & noinstr_mask)) {
> +			state = irqentry_enter(regs);
> +			instrumentation_begin();
> +		}
> +
> +		exception_handlers[vector](regs);
> +
> +		if (!(BIT(vector) & noinstr_mask)) {
> +			instrumentation_end();
> +			irqentry_exit(regs, state);
> +		}

This noinstr mask is daft; why not have DEFINE_FRED_HANDLER and
DEFINE_FRED_HANDLER_RAW or something, have the normal one include the
irqentry bits and use the _RAW one for the 'funny' ones that need to do
it themselves?

> +	} else {
> +		return fred_bad_event(regs);
> +	}

Then all this becomes:

	exception_handlers[vector](regs);

no branches, no nothing.

> +}
