Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA59629427
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 10:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiKOJTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 04:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238074AbiKOJTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 04:19:01 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022EE220F1;
        Tue, 15 Nov 2022 01:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3JrxPzcorZeK61/Wcg0xBe2/JrcIdLGSAklAl931rsA=; b=gTwwKyN4DOB1IbNxKigY+Tep5Q
        W/smCH9eIzXkbqRYiHkN3Eg2FAW400kL4lvd2gDiDAtm2cMh3exWUy7mwC5Wltsud/RWeyFTZpNEL
        UGs60j5DZ0gacNe7ZHhKLCW/ujI6V/ka6c9cLiMFYiPs4Mzox05EUnLZpVRQWqJZWrUOgZi6z3JVS
        oQF7M7rp+ZKh9tUp1gNHDz9iF6/qViakLpSr77FDLytxiesy2BfRrTvaQA+e09OU5AupSobnassTQ
        gNA1CuU3RY3b9a09AGLN0ft7D4lqYAIUjrcv0kTxiX26oEWNkrLHsXMuDEna6m2wTjqSLBNW9qMbg
        5M+y7bvw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ous4u-00GN7o-9I; Tue, 15 Nov 2022 09:18:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 19F75300422;
        Tue, 15 Nov 2022 10:17:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EB17920167EB2; Tue, 15 Nov 2022 10:17:52 +0100 (CET)
Date:   Tue, 15 Nov 2022 10:17:52 +0100
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
Message-ID: <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
References: <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 07:50:49AM +0000, Li, Xin3 wrote:
> > > > But what about NMIs, afaict this is all horribly broken for NMIs.
> > > >
> > > > So the whole VMX thing latches the NMI (which stops NMI recursion),
> > right?
> > > >
> > > > But then you drop out of noinstr code, which means any random
> > > > exception can happen (kprobes #BP, hw_breakpoint #DB, or even #PF
> > > > due to random nonsense like *SAN). This exception will do IRET and
> > > > clear the NMI latch, all before you get to run any of the NMI code.
> > >
> > > What you said here implies that we have this problem in the existing code.
> > > Because a fake iret stack is created to call the NMI handler in the
> > > IDT NMI descriptor, which lastly executes the IRET instruction.
> > 
> > I can't follow; of course the IDT handler terminates with IRET, it has to no?
> 
> With FRED, ERETS/ERETU replace IRET, and use bit 28 of the popped CS field
> to control whether to unblock NMI. If bit 28 of the field (above the selector)
> is 1, ERETS/ERETU unblocks NMIs.

Yes, I know that. It is one of the many improvements FRED brings.
Ideally the IBT WAIT-FOR-ENDBR state also gets squirreled away in the
hardware exception frame, but that's still up in the air I believe :/

Anyway.. given there is interrupt priority and NMI is pretty much on top
of everything else the reinject crap *should* run NMI first. That way
NMI runs with the latch disabled and whatever other pending interrupts
will run later.

But that all is still broken because afaict the current code also leaves
noinstr -- and once you leave noinstr (or use a static_key, static_call
or anything else that *can* change at runtime) you can't guarantee
nothing.
