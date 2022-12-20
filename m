Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5215651E54
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 11:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbiLTKEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 05:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbiLTKEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 05:04:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4BD15FEC;
        Tue, 20 Dec 2022 02:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=6rsBo09ooyd8tgU+HKMozFrDhJd3cHOmSKWXCS0o8X0=; b=BoKMiTBwIr94CpJv3JnJvQNei8
        9zf8Bp/kesSQRe50mgJ0N4geqDVuS1oq3pTpSpBx5TANrC+wIiqd5y6pWH8CBsWg1mUhv651fkZg2
        8rENtRx7ODsfTNqxqLbnFSiFgDy1ZwHxso1uyJ350r9QaeyVsGS0x2tKBEV0s3nHUqxEzxqsjtb2a
        u0nbR7wrOF+wH7gqQUj291VO3etma0vlq0UQQjooD24WxARCjX4Ez1zKCvbJRn84MtoJfA4/BslIG
        5Mrj4idDp3ERrZZpFno1QkLj0A7lJ/jSWEY/QBEkE2ZVouC+WFVatQD68Y3F22TwAHH+LWO7y4sxq
        O+CjB0IQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7ZSM-001g9x-Mb; Tue, 20 Dec 2022 10:02:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6D5E63000DD;
        Tue, 20 Dec 2022 11:02:31 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 54AFA200A4AD7; Tue, 20 Dec 2022 11:02:31 +0100 (CET)
Date:   Tue, 20 Dec 2022 11:02:31 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc:     Xin Li <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ravi.v.shankar@intel.com" <ravi.v.shankar@intel.com>
Subject: Re: [RFC PATCH 22/32] x86/fred: FRED initialization code
Message-ID: <Y6GIN5Uf7Qd43A9U@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-23-xin3.li@intel.com>
 <Y6GELyEJeKY3dEqJ@hirez.programming.kicks-ass.net>
 <16972e64-7d7b-ad8c-f8dc-6dcab69e629e@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16972e64-7d7b-ad8c-f8dc-6dcab69e629e@citrix.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 09:55:31AM +0000, Andrew Cooper wrote:
> On 20/12/2022 9:45 am, Peter Zijlstra wrote:
> > On Mon, Dec 19, 2022 at 10:36:48PM -0800, Xin Li wrote:
> >
> >> +	wrmsrl(MSR_IA32_FRED_STKLVLS,
> >> +	       FRED_STKLVL(X86_TRAP_DB,  1) |
> >> +	       FRED_STKLVL(X86_TRAP_NMI, 2) |
> >> +	       FRED_STKLVL(X86_TRAP_MC,  2) |
> >> +	       FRED_STKLVL(X86_TRAP_DF,  3));
> >> +
> >> +	/* The FRED equivalents to IST stacks... */
> >> +	wrmsrl(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
> >> +	wrmsrl(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
> >> +	wrmsrl(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(DF));
> > Not quite.. IIRC fred only switches to another stack when the level of
> > the exception is higher. Specifically, if we trigger #DB while inside
> > #NMI we will not switch to the #DB stack (since 1 < 2).
> 
> There needs to be a new stack for #DF, and just possibly one for #MC. 
> NMI and #DB do not need separate stacks under FRED.

True, there is very little need to use additional stacks with FRED.

> > Now, as mentioned elsewhere, it all nests a lot saner, but stack
> > exhaustion is still a thing, given the above, what happens when a #DB
> > hits an #NMI which tickles a #VE or something?
> >
> > I don't think we've increased the exception stack size, but perhaps we
> > should for FRED?
> 
> Not sure if it matters too much - it doesn't seem usefully different to
> IDT delivery.  #DB shouldn't get too deep, and NMI gets properly
> inhibited now.

Both #DB and #NMI can end up in perf, and all that goes quite deep :/
