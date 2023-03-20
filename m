Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3C56C1E75
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 18:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjCTRrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 13:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCTRrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 13:47:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B4F399C6;
        Mon, 20 Mar 2023 10:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Cr313Q4mCqCZWruqV+XMhzNCMzHoO9GTRlmHEeVm1wk=; b=oYMiVUUYQn7SMWbFlj6kgNtedS
        HMoS6YnwHP4IByS4oxbS9rUjzU/vXmY+Evd5GtuqLek/qv1kEn1fzggBDD9YV5mT0ejA7F33W/xU7
        DVfrM9WiaIkpNnIzH85HAQAidPNbfyIkPtbgGJSmWrxyFlGe2AYpJneS7/MKsBHqmBMwJ890SJNNG
        m+bizV4OCxttkYExKmbqac22txqmZDk1xClzZIPzo2+L6NXrlvLE/LzFO/j6jwEdTxosb8Vs/TkCk
        gUmuoXsh7Sh/Q0qcIKxcgXj80+a6waDvRiPKRHzcPunbvA9swd2YQXfmAltQpcqJCCYncvZoBu80a
        AWr4sp5Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1peJWa-001G03-78; Mon, 20 Mar 2023 17:42:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7ECCC300392;
        Mon, 20 Mar 2023 18:42:23 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 61E8720EEFFC3; Mon, 20 Mar 2023 18:42:23 +0100 (CET)
Date:   Mon, 20 Mar 2023 18:42:23 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 04/34] x86/traps: add external_interrupt() to dispatch
 external interrupts
Message-ID: <20230320174223.GC2196776@hirez.programming.kicks-ass.net>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-5-xin3.li@intel.com>
 <20230320153630.GO2194297@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320153630.GO2194297@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 04:36:30PM +0100, Peter Zijlstra wrote:
> On Mon, Mar 06, 2023 at 06:39:16PM -0800, Xin Li wrote:
> 
> > +#ifndef CONFIG_X86_LOCAL_APIC
> > +/*
> > + * Used when local APIC is not compiled into the kernel, but
> > + * external_interrupt() needs dispatch_spurious_interrupt().
> > + */
> > +DEFINE_IDTENTRY_IRQ(spurious_interrupt)
> > +{
> > +	pr_info("Spurious interrupt (vector 0x%x) on CPU#%d, should never happen.\n",
> > +		vector, smp_processor_id());
> > +}
> > +#endif
> > +
> > +/*
> > + * External interrupt dispatch function.
> > + *
> > + * Until/unless dispatch_common_interrupt() can be taught to deal with the
> > + * special system vectors, split the dispatch.
> > + *
> > + * Note: dispatch_common_interrupt() already deals with IRQ_MOVE_CLEANUP_VECTOR.
> > + */
> > +int external_interrupt(struct pt_regs *regs, unsigned int vector)
> > +{
> > +	unsigned int sysvec = vector - FIRST_SYSTEM_VECTOR;
> > +
> > +	if (vector < FIRST_EXTERNAL_VECTOR) {
> > +		pr_err("invalid external interrupt vector %d\n", vector);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (sysvec < NR_SYSTEM_VECTORS) {
> > +		if (system_interrupt_handlers[sysvec])
> > +			system_interrupt_handlers[sysvec](regs);
> > +		else
> > +			dispatch_spurious_interrupt(regs, vector);
> 
> ISTR suggesting you can get rid of this branch if you stuff
> system_interrupt_handlers[] with dispatch_spurious_interrupt instead of
> NULL.

Ah, I suggested that for another function vector, but it applies here
too I suppose :-)
