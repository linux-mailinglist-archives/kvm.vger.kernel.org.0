Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37AA6D9465
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 12:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbjDFKsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 06:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbjDFKsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 06:48:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FBE4C39;
        Thu,  6 Apr 2023 03:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rdAbLYuDGVUm7ohyMR/0H/BoSxd4WAGt6zxSS/ncARs=; b=gTwWQys8gdM862G4qu6zi4JfXs
        2DTw1Tztc/RBMvw6a4zPFgJOhVpnMODBIGWF2M7gIMZYncSBdmjZ2nBB7s+2Qb3OkoCaVlM3vnSOY
        mUComrjkVEv/lBzX4/FvMiV6U+jsiIFJSMU8APAKrv8Y4Xf3qrGZ3IW+ndEBMv16IznxPnJ9mJLNn
        IXBzvmveioLr0cBd82cPXjAY614plJ0Z9nSaUc/IEwmp5uMLa7gc1Rfxnj2WHaKpJAA1Z3vvtsthC
        zpfup66Pl0InbgqINg5srbd75TR3p7/axh6RkKG4SoG9QVX3o5SrmEPCxizAMn4bWE2cQYWgw1kJz
        UDbARO8A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pkN9n-00HL0u-Cd; Thu, 06 Apr 2023 10:47:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0C92A300194;
        Thu,  6 Apr 2023 12:47:50 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D27AE207C33EE; Thu,  6 Apr 2023 12:47:50 +0200 (CEST)
Date:   Thu, 6 Apr 2023 12:47:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org
Subject: Re: [RFC PATCH 0/7] x86/entry: Atomic statck switching for IST
Message-ID: <20230406104750.GA392176@hirez.programming.kicks-ass.net>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <19035c40-e756-6efd-1c02-b09109fb44c1@intel.com>
 <CAJhGHyBHmC=UXr88GsykO9eUeqJZp59jrCH3ngkFiCxVBW2F3g@mail.gmail.com>
 <3591487f-96ae-3ab7-6ce7-e524a070c9e7@redhat.com>
 <20230406101254.GI386572@hirez.programming.kicks-ass.net>
 <26be2c81-9431-6b43-e3e9-52d7d184750e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26be2c81-9431-6b43-e3e9-52d7d184750e@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023 at 12:35:24PM +0200, Jiri Slaby wrote:
> On 06. 04. 23, 12:12, Peter Zijlstra wrote:
> > On Tue, Apr 04, 2023 at 07:03:45PM +0200, Paolo Bonzini wrote:
> > > On 4/4/23 05:17, Lai Jiangshan wrote:
> > > > The cover letter has 800+ lines of comments.  About 100-300 lines
> > > > of comments will be moved into the code which would make the diffstat
> > > > not so appealing.
> > > 
> > > Removing assembly from arch/x86/entry/ and adding English to Documentation/?
> > > That's _even more_ appealing. :)
> > 
> > I *much* prefer in-code comments to random gibberish that's instantly
> > out of date squirreled away somewhere in an unreadable format in
> > Documentation/
> 
> +1 as one can link comments in the code to Documentation easily nowadays.
> They are sourced and end up in the generated Documentation [1] then. One
> only needs to type the kernel-doc properly.

Urgh, so that kernel doc stuff can defeat its purpose too. Some of that
is so heavily formatted it is unreadable gibberish just like
Documentation/ :/

I really detest that whole RST thing, and my solution is to explicitly
not write kerneldoc, that way the doc generation stuff doesn't complain
and I don't get random drive by patches wrecking the perfectly readable
comment.
