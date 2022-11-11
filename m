Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC18626206
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 20:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiKKTeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 14:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbiKKTeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 14:34:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CB567124;
        Fri, 11 Nov 2022 11:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=re1xEC6k7MwZnaDsgXlcM1FC9AzckvHp8TB1sTA3mF0=; b=bGucnxcMeuxE0K1iwsx2lvLt1Y
        HP2vOL+Yga26V3XNxf4TJCY37B8AfzAMswhmZMkIkldaaDpibqEl8eLfQEixZzlycR5MGNGYSJjgc
        00E1jNkYEHB50Ujye1TJQCCD7vbLL+r1xW+CCID6omjbHdLhZDFc8fayjqqMKpNEXkRXmCOfzn45T
        UkhsD6CrT3UcF/pYx5f5pwMv7JmNThTlqjtzPhXHMvGsowsMy01sFC1NM+nZX8fb7Y9m1FzJ6DVfq
        iMP9aI2YPhS/DVopa+r49H1Cg9RvcOKfd8t0kxKHe/hMgI2xo1S1fMbFuxHSavxZwY6mPreIJlxFZ
        RjVqdPog==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otZma-00DItQ-JG; Fri, 11 Nov 2022 19:33:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A810D300137;
        Fri, 11 Nov 2022 20:33:36 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9154B209EDD10; Fri, 11 Nov 2022 20:33:36 +0100 (CET)
Date:   Fri, 11 Nov 2022 20:33:36 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Message-ID: <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 06:06:12PM +0000, Li, Xin3 wrote:
> > On Fri, Nov 11, 2022 at 01:48:26PM +0100, Paolo Bonzini wrote:
> > > On 11/11/22 13:19, Peter Zijlstra wrote:
> > > > On Fri, Nov 11, 2022 at 01:04:27PM +0100, Paolo Bonzini wrote:
> > > > > On Intel you can optionally make it hold onto IRQs, but NMIs are
> > > > > always eaten by the VMEXIT and have to be reinjected manually.
> > > >
> > > > That 'optionally' thing worries me -- as in, KVM is currently
> > > > opting-out?
> > >
> > > Yes, because "If the “process posted interrupts” VM-execution control
> > > is 1, the “acknowledge interrupt on exit” VM-exit control is 1" (SDM
> > > 26.2.1.1, checks on VM-Execution Control Fields).  Ipse dixit.  Posted
> > > interrupts are available and used on all processors since I think Ivy Bridge.
> > 
> > (imagine the non-coc compliant reaction here)
> > 
> > So instead of fixing it, they made it worse :-(
> > 
> > And now FRED is arguably making it worse again, and people wonder why I
> > hate virt...
> 
> Maybe I take it wrong, but FRED doesn't make anything worse. Fred entry
> code will call external_interrupt() immediately for IRQs.

But what about NMIs, afaict this is all horribly broken for NMIs.

So the whole VMX thing latches the NMI (which stops NMI recursion),
right?

But then you drop out of noinstr code, which means any random exception
can happen (kprobes #BP, hw_breakpoint #DB, or even #PF due to random
nonsense like *SAN). This exception will do IRET and clear the NMI
latch, all before you get to run any of the NMI code.

Note how the normal NMI code is very careful to clear DR7 and both
kprobes and hw_breakpoint know not to accept noinstr code as targets.

You threw all that out the window.

Also, NMI is IST, and with FRED it will run on a different stack as
well, directly calling external_interrupt() doesn't honour that either.

> You really really don't like the context how VMX dispatches NMI/IRQs (which has
> been there for a long time), right?

I really really hate this with a passion. The fact that it's been this
way is no justification for keeping it. Crap is crap.

Intel should have taken an example of SVM in this regard, and not
doubled down and extended this NMI hole to regular IRQs. These are
exactly the kind of exception delivery trainwrecks FRED is supposed to
fix, except in this case it appears it doesn't :/
