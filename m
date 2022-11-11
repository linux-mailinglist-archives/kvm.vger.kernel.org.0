Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ACD625662
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 10:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiKKJPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 04:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiKKJP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 04:15:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1172D45;
        Fri, 11 Nov 2022 01:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J/Kd/DRS7pK3+FItfTHVpYFeOxFkIUYqgC78gar9GRk=; b=YJVgPIWaArlf7N5fpU/UogHAmO
        mWD5B0E+ZO2AhawIJ01HBDc6MejEiDn7khBC++KF43indIGBtSKwU9Y+ev/lv7ar6m1psOpIpBgmV
        kIDBnHnrc3Syn569tR4AlKSok8yuP4bWVfS/27kK894uDjTTOdHYngsUtjvoGDBopGtfKL0CcddXk
        OBFxc7SiIVxyShcrJteUUxeNyjqdoDzJe8tshj/uPVLQSuROCfR65DrTGt5nVCO78K1j6q5TBoqtx
        uuGXyi1l6s2qrkesccc9b6QryAzLjNnhYQmWDM8wA5l1W81+m0eHpnaqvyINU2T75CeNfKJ7Q0oiQ
        RHFhRnoQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otQ86-00CtP3-Gy; Fri, 11 Nov 2022 09:15:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 711CE30031B;
        Fri, 11 Nov 2022 10:15:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 56B2C20243A99; Fri, 11 Nov 2022 10:15:12 +0100 (CET)
Date:   Fri, 11 Nov 2022 10:15:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Message-ID: <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 08:53:30PM +0000, Li, Xin3 wrote:

> > >  static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> > > {
> > >  	u32 intr_info = vmx_get_intr_info(vcpu);
> > >  	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
> > > -	gate_desc *desc = (gate_desc *)host_idt_base + vector;
> > >
> > >  	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
> > >  	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
> > >  		return;
> > >
> > > -	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
> > > +	handle_interrupt_nmi_irqoff(vcpu, vector);
> > >  	vcpu->arch.at_instruction_boundary = true;  }
> > 
> > How does any of this work? You're calling into entry/noinstr code from a
> > random context.
> 
> Can you please elaborate your concern a bit more?
> 
> We are here in handle_external_interrupt_irqoff () because an external
> interrupt happened when a guest was running and the CPU vm-exits to host
> to dispatch to the IRQ handler with IRQ disabled.

I don't speak virt (but this all sounds disguisting) -- but what appears
to be the case is you calling into entry code from regular kernel
context, which is odd at best.

Specifically, going by the fact that all this is not noinstr code, the
assumption is that RCU/lockdep/etc.. is all set-up and running. This
means you should not be calling DEFINE_IDTENTRY_*(func) functions
because those will try and set all that up again.

Granted, irqentry_{enter,exit}() do nest, but *yuck*.


