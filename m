Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC6F625A4C
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 13:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiKKMKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 07:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiKKMKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 07:10:44 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC825EE37
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 04:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=x/4kMcD6iSpRsQ45fMznjzX9v02Cn/wjOY7VCMvtZ98=; b=ikG4RsVxFIZgZpPDwsGH827sLp
        vavwCBYxoD+DPHLuuhuykPvy8CrF0RdRt8iqZty+57l630ckP5TvssMsuaDDx9ve82yYuxCLKEzbY
        6h3zO0WtU5uQUEQ1g1IlqoBLCxm2VvlIgVf8xOoGJVcJIAlu4SMjdwAwf4Yn5L64zXzabgHplJRs9
        LQoY8005g7iWrtfBsPr9eissmmbxfTDf9/oV5FC2SpIeD1kV7VSbImfzyGTtip3b4FFekW9ijOzmL
        RCjHbrnU8etvoi1JhSI5VAdiBRNQbSV2VIGyiNxFZLxOBlD8kHATQgJ9fJPl+DWPOOrZO1/S/gkpU
        lxknLo3Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otSrD-0002D5-6b; Fri, 11 Nov 2022 12:10:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8C6A2300454;
        Fri, 11 Nov 2022 13:10:01 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 750F620839A5A; Fri, 11 Nov 2022 13:10:01 +0100 (CET)
Date:   Fri, 11 Nov 2022 13:10:01 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernnel.org" <linux-kernel@vger.kernnel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Message-ID: <Y247mQq0uAtFqCFQ@hirez.programming.kicks-ass.net>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com>
 <Y20f8v9ObO+IPwU+@google.com>
 <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y21ktSq1QlWZxs6n@google.com>
 <Y24Tm2P34jI3+E1R@hirez.programming.kicks-ass.net>
 <3A1B7743-9448-405A-8BE4-E1BDAB4D62F8@zytor.com>
 <Y24n4bHoFBuHVid5@hirez.programming.kicks-ass.net>
 <ef2c54f7-14b9-dcbb-c3c4-1533455e7a18@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef2c54f7-14b9-dcbb-c3c4-1533455e7a18@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 12:57:58PM +0100, Paolo Bonzini wrote:
> On 11/11/22 11:45, Peter Zijlstra wrote:
> > > What is "correct" in this context?
> > 
> > I don't know since I don't really speak virt, but I could image the
> > regset that would match the vmrun (or whatever intel decided to call
> > that again) instruction.
> 
> Right now it is not exactly that but close.  The RIP is somewhere in
> vmx_do_interrupt_nmi_irqoff; CS/SS are correct (i.e. it's not like they
> point to guest values!) and other registers including RSP and RFLAGS are
> consistent with the RIP.

*phew*, that sounds a *lot* better than 'random'. And yes, that should
do.

Another thing; these patches appear to be about system vectors and
everything, but what I understand from Andrew is that VMX is only screwy
vs NMI, not regular interrupts/exceptions, so where does that come from?

SVM specifically fixed the NMI wonkyness with their Global Interrupt
flag thingy.

