Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361B5751EF2
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 12:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbjGMKhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 06:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjGMKhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 06:37:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E31170E;
        Thu, 13 Jul 2023 03:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=dEXibbmhRBtyKV+Lf7x7FTvqeIE7OC/7cSBMdSS5N0o=; b=MKe1wQK9XPBvSRjxT92B1Zugue
        CHpwNmF64PtHUvXjKdHN5stZGArglpaDwPWPPwp1mVn+OvmjwQlWAJrVQCPE4qEoyLQvv0agDISpl
        l4pA8TRkJSoxJE6UfDboiIHkDru+RkHL7Jf77OOUchVyad8og5qoeVch98p8yVZJdZJJ5HTOWFOoD
        YsxhwE4Fwe2vkn3e3E/DyNtHf3GoHIf3Hs/Jap/C0QECK9A6q/MVTkh6iPVn7q93zciA+pZZyl4Xp
        XlSRWt9cMYwxL2MEhL0QCei1KQWBHFjIcFWoLm01ELQp6gpMr7k13618MIM01jogtdNa5PhYEVcOW
        CM7RaWaw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJthX-0003XJ-4J; Thu, 13 Jul 2023 10:37:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 86D773001FD;
        Thu, 13 Jul 2023 12:37:33 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 70589245CA111; Thu, 13 Jul 2023 12:37:33 +0200 (CEST)
Date:   Thu, 13 Jul 2023 12:37:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Message-ID: <20230713103733.GF3139243@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
 <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
 <20230712165912.GA3100142@hirez.programming.kicks-ass.net>
 <cc5b4df23273b546225241fae2cbbea52ccb13d3.camel@intel.com>
 <20230713084324.GA3138667@hirez.programming.kicks-ass.net>
 <5cc5ba09636647a076206fae932bbf88f233b8b2.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5cc5ba09636647a076206fae932bbf88f233b8b2.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 10:19:49AM +0000, Huang, Kai wrote:
> On Thu, 2023-07-13 at 10:43 +0200, Peter Zijlstra wrote:
> > On Thu, Jul 13, 2023 at 08:02:54AM +0000, Huang, Kai wrote:
> > 
> > > Sorry I am ignorant here.  Won't "clearing ECX only" leave high bits of
> > > registers still containing guest's value?
> > 
> > architecture zero-extends 32bit stores
> 
> Sorry, where can I find this information? Looking at SDM I couldn't find :-(

Yeah, I couldn't find it in a hurry either, but bpetkov pasted me this
from the AMD document:

 "In 64-bit mode, the following general rules apply to instructions and their operands:
 “Promoted to 64 Bit”: If an instruction’s operand size (16-bit or 32-bit) in legacy and
 compatibility modes depends on the CS.D bit and the operand-size override prefix, then the
 operand-size choices in 64-bit mode are extended from 16-bit and 32-bit to include 64 bits (with a
 REX prefix), or the operand size is fixed at 64 bits. Such instructions are said to be “Promoted to
 64 bits” in Table B-1. However, byte-operand opcodes of such instructions are not promoted."

> I _think_ I understand now? In 64-bit mode
> 
> 	xor %eax, %eax
> 
> equals to
> 
> 	xor %rax, %rax
> 
> (due to "architecture zero-extends 32bit stores")
> 
> Thus using the former (plus using "d" for %r*) can save some memory?

Yes, 64bit wide instruction get a REX prefix 0x4X (somehow I keep typing
RAX) byte in front to tell it's a 64bit wide op.

   31 c0                   xor    %eax,%eax
   48 31 c0                xor    %rax,%rax

The REX byte will show up for rN usage, because then we need the actual
Register Extention part of that prefix irrespective of the width.

   45 31 d2                xor    %r10d,%r10d
   4d 31 d2                xor    %r10,%r10

x86 instruction encoding is 'fun' :-)

See SDM Vol 2 2.2.1.2 if you want to know more about the REX prefix.
