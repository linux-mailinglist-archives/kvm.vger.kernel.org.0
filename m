Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D7C654183
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 14:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbiLVNIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 08:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLVNIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 08:08:48 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E897ABCA;
        Thu, 22 Dec 2022 05:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HhoSwzjsX6UdVDfKy5dRYCKC7f/qrncYptmJiwWeaRQ=; b=fesxcpNbE0oJeFZPMvmCh+d3LK
        qlIl5fScBoN+8WXxtBmMBH9rdrY9idvco1tIul3jlkdhxhghkVaaHm17DYGbDQgDU8hK634za4MtA
        m3KWiTP3XHN6XUyUw5x1jXhXBinDldSNQjFkDPcAWr4ES0rEmFmkVxN2X6HhWn1fgghfMQfRxqbDI
        yEsvxj27uIVkm/NGK9rMkTynU8ahAtwDC0z+Q6baYyYyGT1vtup4/JklCGYehMH25VtBhAnsCH68I
        UHG8MYkb5J4MbvsFVtgnylivBP0TOUeM/50mqLSHjTFEnxlxoBgXnXyHmPsocvXpwTWMuOh+U54ly
        pedw64mQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p8LJ5-00Dpt4-03;
        Thu, 22 Dec 2022 13:08:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F01CF3001E5;
        Thu, 22 Dec 2022 14:08:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D8FCC20D2DE37; Thu, 22 Dec 2022 14:08:19 +0100 (CET)
Date:   Thu, 22 Dec 2022 14:08:19 +0100
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
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [RFC PATCH 21/32] x86/fred: FRED entry/exit and dispatch code
Message-ID: <Y6RWwzBfgtMBorAy@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-22-xin3.li@intel.com>
 <Y6GB5C1Bx60L9hk3@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21611C69A6B168B2A0A888F4A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB21611C69A6B168B2A0A888F4A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 02:56:08AM +0000, Li, Xin3 wrote:

> > > +		if (!(BIT(vector) & noinstr_mask)) {
> > > +			state = irqentry_enter(regs);
> > > +			instrumentation_begin();
> > > +		}
> > > +
> > > +		exception_handlers[vector](regs);
> > > +
> > > +		if (!(BIT(vector) & noinstr_mask)) {
> > > +			instrumentation_end();
> > > +			irqentry_exit(regs, state);
> > > +		}
> > 
> > This noinstr mask is daft; why not have DEFINE_FRED_HANDLER and
> > DEFINE_FRED_HANDLER_RAW or something, have the normal one include the
> > irqentry bits and use the _RAW one for the 'funny' ones that need to do it
> > themselves?
> 
> I wanted to keep "state = irqentry_enter(regs); instrumentation_begin();"
> in the dispatch framework, instead of pushing down to the handlers.
> 
> Of course, we could do it the other way if it is more preferred.

Yes, please do as I suggested, it is consistent IDTENTRY macros.
