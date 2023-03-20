Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0116C1A19
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 16:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjCTPqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 11:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjCTPqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 11:46:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0F43E0B3;
        Mon, 20 Mar 2023 08:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Pf02v7GC1tO+yNx151tkhuYDiX/K0UPtxvGyi0kyS0Q=; b=Ws9scCdv2b60pN4Jzze9OlmzQm
        owZlezWNaOBKwpGZdhhvTGcN9rTHrC7IOwrcdnFvq537Tq4gLom5uSTFNBhcx7QBWrEffimZ+9Dvx
        3ZNZfXfj5+HdgmabWGxADlvn+T/JCG1e+Yr8iBfMlMVCInUAWRAApt7XLnklSXZLMNansj5teduJs
        aEWmkLHsslytbI3VSmbjo/iK5okbJyBrRiAw26dNzSWRZidTxaXVo/U8zBmUTgtElXcLI7fneamY3
        qV8g+BZApotfuKgV1c+CMIQm8On4RIsY9IvRGdiPki106BGHpxVsfTwNF/94b2cAGRx3l2Rdp3fTM
        Mp0kmEow==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1peHYm-0019xE-87; Mon, 20 Mar 2023 15:36:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A42AB30006D;
        Mon, 20 Mar 2023 16:36:30 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 46D70240AD5BE; Mon, 20 Mar 2023 16:36:30 +0100 (CET)
Date:   Mon, 20 Mar 2023 16:36:30 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 04/34] x86/traps: add external_interrupt() to dispatch
 external interrupts
Message-ID: <20230320153630.GO2194297@hirez.programming.kicks-ass.net>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-5-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307023946.14516-5-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 06:39:16PM -0800, Xin Li wrote:

> +#ifndef CONFIG_X86_LOCAL_APIC
> +/*
> + * Used when local APIC is not compiled into the kernel, but
> + * external_interrupt() needs dispatch_spurious_interrupt().
> + */
> +DEFINE_IDTENTRY_IRQ(spurious_interrupt)
> +{
> +	pr_info("Spurious interrupt (vector 0x%x) on CPU#%d, should never happen.\n",
> +		vector, smp_processor_id());
> +}
> +#endif
> +
> +/*
> + * External interrupt dispatch function.
> + *
> + * Until/unless dispatch_common_interrupt() can be taught to deal with the
> + * special system vectors, split the dispatch.
> + *
> + * Note: dispatch_common_interrupt() already deals with IRQ_MOVE_CLEANUP_VECTOR.
> + */
> +int external_interrupt(struct pt_regs *regs, unsigned int vector)
> +{
> +	unsigned int sysvec = vector - FIRST_SYSTEM_VECTOR;
> +
> +	if (vector < FIRST_EXTERNAL_VECTOR) {
> +		pr_err("invalid external interrupt vector %d\n", vector);
> +		return -EINVAL;
> +	}
> +
> +	if (sysvec < NR_SYSTEM_VECTORS) {
> +		if (system_interrupt_handlers[sysvec])
> +			system_interrupt_handlers[sysvec](regs);
> +		else
> +			dispatch_spurious_interrupt(regs, vector);

ISTR suggesting you can get rid of this branch if you stuff
system_interrupt_handlers[] with dispatch_spurious_interrupt instead of
NULL.

> +	} else {
> +		dispatch_common_interrupt(regs, vector);
> +	}
> +
> +	return 0;
> +}
