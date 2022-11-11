Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948066258A7
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbiKKKqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiKKKqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:46:18 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976FC64CF
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 02:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cbppjbbD/CnYxNOoIxdeSyOSlREN+zemPAlPBQJbNrY=; b=V6Nlf+YgL0Mc84GV7UB65L2Dgs
        ycu0OOGanwtm08Fnb0Ed4Whn418IHP4jsiS8Wydrh4eFdLtHZkz6jr9sYWFuA4POScz5/TnBGHGb/
        0kkMbnq6fbb2lPyMNxI1epJ7eIzCkQ5XAKegyM8TqS4cHhbJ2gucf2cBUY982I8FnblMdEq0v/CYY
        IiGbQpELYsfruDKkeU6YX509Qm8GUtTXxeD7thkkyy7pSwn18G1yj2w9eGNclmDvQvTXwFpdBsms1
        fa85b83bi5loCba+3NgC9iLK1U3gHGz5EDcPWRCxAKXwyMQ/8zizhhaCqNw/I7M3T3dghNDAsx4f5
        NiXY8H/g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otRXn-0000jx-Vw; Fri, 11 Nov 2022 10:45:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 64511300244;
        Fri, 11 Nov 2022 11:45:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4C39A2B8EC738; Fri, 11 Nov 2022 11:45:53 +0100 (CET)
Date:   Fri, 11 Nov 2022 11:45:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernnel.org" <linux-kernel@vger.kernnel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Message-ID: <Y24n4bHoFBuHVid5@hirez.programming.kicks-ass.net>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com>
 <Y20f8v9ObO+IPwU+@google.com>
 <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y21ktSq1QlWZxs6n@google.com>
 <Y24Tm2P34jI3+E1R@hirez.programming.kicks-ass.net>
 <3A1B7743-9448-405A-8BE4-E1BDAB4D62F8@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3A1B7743-9448-405A-8BE4-E1BDAB4D62F8@zytor.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 01:29:35AM -0800, H. Peter Anvin wrote:
> On November 11, 2022 1:19:23 AM PST, Peter Zijlstra <peterz@infradead.org> wrote:
> >On Thu, Nov 10, 2022 at 08:53:09PM +0000, Sean Christopherson wrote:
> >> On Thu, Nov 10, 2022, Li, Xin3 wrote:
> >
> >> > > > + * call thus the values in the pt_regs structure are not used in
> >> > > > + * executing NMI/IRQ handlers,
> >> > > 
> >> > > Won't this break stack traces to some extent?
> >> > > 
> >> > 
> >> > The pt_regs structure, and its IP/CS, is NOT part of the call stack, thus
> >> > I don't see a problem. No?
> >
> >I'm not sure what Xin3 is trying to say, but NMI/IRQ handers use pt_regs
> >a *LOT*. pt_regs *MUST* be correct.
> 
> What is "correct" in this context? 

I don't know since I don't really speak virt, but I could image the
regset that would match the vmrun (or whatever intel decided to call
that again) instruction.

> Could you describe what aspects of
> the register image you rely on, and what you expect them to be?

We rely on CS,IP,FLAGS,SS,SP to be coherent and usable at the very least
(must be able to start an unwind from it). But things like perf (NMI)
access *all* of them and possibly copy them out to userspace. Perf can
also try and use the segment registers in order to try and establish a
linear address.

Some exceptions (#GP) access whatever is needed to fully decode and
emulate the instruction (IOPL,UMIP,etc..) including the segment
registers.

> Currently KVM basically stuff random data into pt_regs; this at least
> makes it explicitly zero.

:-( Both is broken. Once again proving to me that virt is a bunch of
duck-tape at best.
