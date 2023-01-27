Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0647A67E5A3
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbjA0Mma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbjA0MmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:42:20 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AF872654;
        Fri, 27 Jan 2023 04:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uvHj20TTbrgV/IPd1XkJDIUiQVnvExKvw3Gg+WnioGs=; b=BI+rt7XWOFM9StS4hVcOPsbWdO
        7klkyntzhCbOv+Mp3WJ/zhRaJoZ/CYX356tINw55C/faKAW9kAgQRo9fFgMLuo0LQWDHnvP6dN2E7
        7GCRy22m7smpfS82g52sTmeBGN0DMeDdDqvVkbTfwwVS8W83mpcmPcttWRstIsahxQkQL+mjja/Cb
        yqsgIqgc+0DKwYBaUo49sDIaq0vTeVOAWN1UO3+fRv6DFp0RwTmkOlvsSn9RVVVfVkxqhVqe+4egS
        a41vmRYcY2VasjsZiTXcPK8M9dLjw82UHtMuMK5Cy1hQsa/cDxiCqZsutREEpkFSitvlBI6e3qGBS
        l2wQNyTQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pLO2S-002meV-1p;
        Fri, 27 Jan 2023 12:41:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8970A30036B;
        Fri, 27 Jan 2023 13:41:34 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 14E1B20D3CC56; Fri, 27 Jan 2023 13:41:34 +0100 (CET)
Date:   Fri, 27 Jan 2023 13:41:34 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, joro@8bytes.org
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9PGfjiMyZFnhnvf@hirez.programming.kicks-ass.net>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <c2716284-a8f2-9494-e130-cbda2a1dccfb@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2716284-a8f2-9494-e130-cbda2a1dccfb@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:13:38PM +1100, Alexey Kardashevskiy wrote:

> > This is broken, and building with DEBUG_ENTRY=y would've told you.
> 
> 
> Huh, good to know. Is this it telling me so?
> 
> vmlinux.o: warning: objtool: exc_nmi+0x73: call to native_get_debugreg7()
> leaves .noinstr.text section
> 

Yep. The ramification of all that is that by calling non-noinstr code
(double negative, iow, regular instrumented code) is that you can end up
in the tracers/*SAN/breakpoints etc.. code -- something we're very much
not ready for at this point.

> > > +
> > >   #ifdef CONFIG_CPU_SUP_AMD
> > >   extern void set_dr_addr_mask(unsigned long mask, int dr);
> > >   #else
> > > diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> > > index cec0bfa3bc04..400b5b6b74f6 100644
> > > --- a/arch/x86/kernel/nmi.c
> > > +++ b/arch/x86/kernel/nmi.c
> > > @@ -503,7 +503,7 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
> > >   	 */
> > >   	sev_es_ist_enter(regs);
> > > -	this_cpu_write(nmi_dr7, local_db_save());
> > > +	this_cpu_write(nmi_dr7, local_db_save_exc_nmi());
> > >   	irq_state = irqentry_nmi_enter(regs);
> > 
> > So what I don't get is why sev_es_ist_enter() doesn't cause us to make a
> > stack frame, that has an actual call in it (although admittedly
> > conditional).
> 
> Is not the frame gone when sev_es_ist_enter() (which does not get inlined as
> per objdump's "ffffffff81bd4550 <__sev_es_ist_enter>:
> ") returned?

Well, returning would consume the callframe, but the stack setup of the
caller should remain. Let me go stare at some asm.
