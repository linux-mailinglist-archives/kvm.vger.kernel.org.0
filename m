Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D76625677
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 10:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiKKJTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 04:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiKKJTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 04:19:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D472613C
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 01:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cMMCcucAsGolv5//xqeEzkd07EWyc4Atda4dDWbFHy8=; b=Oc8acBiGdRATRfe+O9YnPMxlem
        bqr13X35I316iYolHjKsPsnuUZqDwc0r6gCekigzu1X1lzS7nduPUivpegYixS4PQray6Sy0SZS4H
        l3OHicAB9HUKFyXWr7NFNIB4FdYWBOnVpCpqsh3Wv0VFRtyZtGD5YOnm8ymHtI2p7gAu+1MX5rL8S
        13Gvn82ighn5NNn8hs0xwmJZCpriIb2GNsGSAgpwac1ep3DWNpTxuuzpMxAHrL+5Yo/5IoEeuc9/6
        SXpDFJqJ/nk0VzOgUonJ+TXL1dIJdRrAOBZye5A3HZz+rhIq1IOJQB+gRrWipNg8+6Gia21BQYwSA
        2UstXtVQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otQC9-00Ctj7-69; Fri, 11 Nov 2022 09:19:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5D8C930031B;
        Fri, 11 Nov 2022 10:19:23 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 41E8720243A99; Fri, 11 Nov 2022 10:19:23 +0100 (CET)
Date:   Fri, 11 Nov 2022 10:19:23 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernnel.org" <linux-kernel@vger.kernnel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Message-ID: <Y24Tm2P34jI3+E1R@hirez.programming.kicks-ass.net>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com>
 <Y20f8v9ObO+IPwU+@google.com>
 <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y21ktSq1QlWZxs6n@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y21ktSq1QlWZxs6n@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 08:53:09PM +0000, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Li, Xin3 wrote:

> > > > + * call thus the values in the pt_regs structure are not used in
> > > > + * executing NMI/IRQ handlers,
> > > 
> > > Won't this break stack traces to some extent?
> > > 
> > 
> > The pt_regs structure, and its IP/CS, is NOT part of the call stack, thus
> > I don't see a problem. No?

I'm not sure what Xin3 is trying to say, but NMI/IRQ handers use pt_regs
a *LOT*. pt_regs *MUST* be correct.
