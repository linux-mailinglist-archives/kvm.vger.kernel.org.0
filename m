Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E20C6278BC
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbiKNJJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbiKNJJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:09:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D865330A;
        Mon, 14 Nov 2022 01:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CmCkVP6XVasiawMWAc2MfoRTytUQFHnWEyNdl8YOQ2s=; b=sJPpFzwZM45thglm1Lcdyxo+hB
        /kqvQJXKkVETWLF3wT7rXwfO8CE/lwpxaayg0f9hTslmteCjyVriq71W1GMQrgyWKxT9p1tjrfzlX
        h8aN9mrCczTIN1mqdShxKbMeaJ3uPsgFeQliRvSUvmPeZwh4j32mfhRHIl98JloUN4FcvsTs6nL7Q
        yy6zxw1NnYlE93wllagjvtdqocPe+2BrzVqXwF/O+yr/xCpZHq8Y2fgQPqcPbrEXvrF1fRvsaJNr0
        8alPAyIVFlxo9FTNHezy+JCEeN5Ln2onNVxA6C/vukjgqFqk5CLClrecLboV9ogydeVMV0oyYTywu
        0ExVDnwg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouVSd-00FNEY-ER; Mon, 14 Nov 2022 09:08:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B08F2300282;
        Mon, 14 Nov 2022 10:08:51 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7BF392C8037C6; Mon, 14 Nov 2022 10:08:51 +0100 (CET)
Date:   Mon, 14 Nov 2022 10:08:51 +0100
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
Message-ID: <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
References: <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 04:39:40AM +0000, Li, Xin3 wrote:

> > But what about NMIs, afaict this is all horribly broken for NMIs.
> > 
> > So the whole VMX thing latches the NMI (which stops NMI recursion), right?
> > 
> > But then you drop out of noinstr code, which means any random exception can
> > happen (kprobes #BP, hw_breakpoint #DB, or even #PF due to random
> > nonsense like *SAN). This exception will do IRET and clear the NMI latch, all
> > before you get to run any of the NMI code.
> 
> What you said here implies that we have this problem in the existing code.
> Because a fake iret stack is created to call the NMI handler in the IDT NMI
> descriptor, which lastly executes the IRET instruction.

I can't follow; of course the IDT handler terminates with IRET, it has
to no?

And yes, the current code appears to suffer the same defect.
