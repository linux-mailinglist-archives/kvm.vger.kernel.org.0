Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82723625A62
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 13:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbiKKMTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 07:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiKKMTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 07:19:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C436627F8;
        Fri, 11 Nov 2022 04:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TrDl26UsM79jWFLz4hQEcMFLuhNP+LrmD1HvrzIRqQ4=; b=WUiY5ty1bQBGkV9KPNLMZzL8H7
        XqcORPxICEQQf07CBPhAaeW/D0mx+3X20oul9/09wz8IwTaOYtV6d1YLRMwPRpBOujHeFL8gTqGS3
        dkbXK5ShksixPARtpRr6ocYYGyLPGGuwCAYUznuVVoT04tFAFicH1mX3Va4IsMb6xcjAWhkFJfoBr
        8gtBiTZSZO/k2JcQtyE6a00g/sfSH7zSQAKBzM7Bz15UpqkT88Q0HrZXvWlixaV2rJgkXR6Mm83MU
        kWUvOEunBQDp4phng54TlZuxHIFE3MDOghnqxJOdwahUmjX6VbpWMpqqMYXMNK5Aw+Z2TiDEAoXpj
        HicRFA2A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otT0T-00D2IT-Mu; Fri, 11 Nov 2022 12:19:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E046C30013F;
        Fri, 11 Nov 2022 13:19:31 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CF06820831B7F; Fri, 11 Nov 2022 13:19:31 +0100 (CET)
Date:   Fri, 11 Nov 2022 13:19:31 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Li, Xin3" <xin3.li@intel.com>,
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
Message-ID: <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 01:04:27PM +0100, Paolo Bonzini wrote:
> On 11/11/22 10:15, Peter Zijlstra wrote:
> > I don't speak virt (but this all sounds disguisting)
> 
> Yes, it is.  AMD does not need this, they just hold onto the interrupt
> until the host has issued both STGI (for NMIs) and STI (for IRQs).

Right -- Cooper just explained that to me.

> On Intel you can optionally make it hold onto IRQs, but NMIs are always
> eaten by the VMEXIT and have to be reinjected manually.

That 'optionally' thing worries me -- as in, KVM is currently
opting-out?

Since much of this is about preparing for FRED, can we pretty *PLEASE*
fix this VMX NMI hole instead so that all this nonsense isn't needed
anymore, please, really please?

Have FRED imply a GI flag for VMX or something and then we can all
forget about these reinjection horrors.
