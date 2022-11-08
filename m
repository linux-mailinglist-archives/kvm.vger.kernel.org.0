Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CEF620AF0
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 09:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiKHIJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 03:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiKHIIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 03:08:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403731FF8B;
        Tue,  8 Nov 2022 00:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LwCgedXafwEPt8/fNTGd0hg7ywmKoM5jv7NpAinjw0o=; b=CE5kURuQzUML+Y5qGGUHpmZ+Qm
        3/swCA5I5TJh09kWiZ+pcJ+7dya9D+wdxNV/UvOfrH/Op5nSb05OI8kfdht2WPzZr2EFYggM9veFL
        K/iULMowBAADj5VOeE84C/rD6n2MZC/i1DOgpQMAyixVY7mxZkiLU7/nGxjhSAGHDuqUvPweNffgg
        a/w2odk4WhnkG3hPFUHjq24hlkZ8WCnOvB2Kb6LTbbEo8NEZO4R++BsyioSD93T79KhkCiim3e1CO
        5bBhwXMnpQxLJ/k8lcNKcp4pQJCBbpyIrbh9belKIJVRaivJshlcCj8YSRDlgR9xA8njloAersYPM
        BKDgPDog==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1osJdQ-00A65A-7X; Tue, 08 Nov 2022 08:07:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3B103300244;
        Tue,  8 Nov 2022 09:06:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2347029B98571; Tue,  8 Nov 2022 09:06:50 +0100 (CET)
Date:   Tue, 8 Nov 2022 09:06:50 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/speculation: Support Automatic IBRS
Message-ID: <Y2oOGoh6wBdmG16k@hirez.programming.kicks-ass.net>
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-3-kim.phillips@amd.com>
 <Y2WJjdY3wwQl9/q9@zn.tnic>
 <Y2ZEinL+wlIX+1Sn@hirez.programming.kicks-ass.net>
 <d413c064-ee9b-5853-9cf1-544adde22c8a@amd.com>
 <da41d7f0-68ea-0c21-1dca-218f8184a0f3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da41d7f0-68ea-0c21-1dca-218f8184a0f3@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 03:41:03PM -0800, Dave Hansen wrote:
> On 11/7/22 14:39, Kim Phillips wrote:
> > I've started a version that has AUTOIBRS reuse SPECTRE_V2_EIBRS
> > spectre_v2_mitigation enum, but, so far, it's change to bugs.c
> > looks bigger: 58 lines changed vs. 34 (see below).
> > 
> > Let me know if you want me to send it as a part of a v2 submission
> > after I take care of the kvm CPUID review.
> 
> Thanks for putting that together.  I generally like how this looks.
> 
> I think it probably goes to a _bit_ too much trouble to turn off
> "eibrs,lfence/retpoline".  If someone goes to the trouble of specifying
> those, a warning or pr_info() is probably enough.  You don't need to
> actively override it.

Not, even, just do it. User told you to, it's not technically
impossible, so just go.
