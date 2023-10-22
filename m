Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92207D2444
	for <lists+kvm@lfdr.de>; Sun, 22 Oct 2023 18:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjJVQQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Oct 2023 12:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVQQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Oct 2023 12:16:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D99E1;
        Sun, 22 Oct 2023 09:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=0kocVwQoUwGiyQuImeQDWp0cHvDVXBacQM1Z7EfsYZE=; b=dVCavni3/f+jfYr49EBBt4bQfT
        g6xlVVoj9XmqAdZn2LJc5meaMTfCkNPK/jmCOacsz6c7MDmiP54UKVi+PwZC8kRH90pYe6QnctrTj
        DU9O6YNcQQsj32M4CVh4IR3wbIABtTHVU43VfZdzLOhG5tdZIP+f7Bht20YOyLlqTfy7MGwFjltuI
        htL3dX8VtdsauivO7zrfPZeExPUwqtrZ7jkh+OdBf169U96s8M6TWzhq6SWLFJmVA5o+hQGcmbQUI
        kM6IAAkV8RHVQFhZvptAR0Aq9Z9LuYqDIAebBArjJq2rZso9NUV6WSceRck+F/p88+eRhlA5Zdabr
        mPIiS/1g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qub7R-008ZJr-T7; Sun, 22 Oct 2023 16:16:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8941F300473; Sun, 22 Oct 2023 18:16:01 +0200 (CEST)
Date:   Sun, 22 Oct 2023 18:16:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231022161601.GE31411@noisy.programming.kicks-ass.net>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-1-cff54096326d@linux.intel.com>
 <6439a094-23a6-4de3-aa41-bd033163e044@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6439a094-23a6-4de3-aa41-bd033163e044@citrix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 21, 2023 at 12:50:37AM +0100, Andrew Cooper wrote:
> On 20/10/2023 9:44 pm, Pawan Gupta wrote:
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index c55cc243592e..e1b623a27e1b 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -111,6 +111,24 @@
> >  #define RESET_CALL_DEPTH_FROM_CALL
> >  #endif
> >  
> > +/*
> > + * Macro to execute VERW instruction to mitigate transient data sampling
> > + * attacks such as MDS. On affected systems a microcode update overloaded VERW
> > + * instruction to also clear the CPU buffers.
> > + *
> > + * Note: Only the memory operand variant of VERW clears the CPU buffers. To
> > + * handle the case when VERW is executed after user registers are restored, use
> > + * RIP to point the memory operand to a part NOPL instruction that contains
> > + * __KERNEL_DS.
> > + */
> > +#define __EXEC_VERW(m)	verw _ASM_RIP(m)
> > +
> > +#define EXEC_VERW				\
> > +	__EXEC_VERW(551f);			\
> > +	/* nopl __KERNEL_DS(%rax) */		\
> > +	.byte 0x0f, 0x1f, 0x80, 0x00, 0x00;	\
> > +551:	.word __KERNEL_DS;			\
> > +
> 
> Is this actually wise from a perf point of view?
> 
> You're causing a data access to the instruction stream, and not only
> that, the immediate next instruction.  Some parts don't take kindly to
> snoops hitting L1I.
> 
> A better option would be to simply have
> 
> .section .text.entry
> .align CACHELINE
> mds_verw_sel:
>     .word __KERNEL_DS
>     int3
> .align CACHELINE
> 
> 
> And then just have EXEC_VERW be
> 
>     verw mds_verw_sel(%rip)

	ALTERNATIVE "", "verw mds_verw_sel(%rip)", X86_FEATURE_USER_CLEAR_CPU_BUF

But yeah, his seems like the sanest form.
