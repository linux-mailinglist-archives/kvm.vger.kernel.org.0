Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB5161D99A
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 12:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiKELLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 07:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKELLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 07:11:02 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3378A101D0;
        Sat,  5 Nov 2022 04:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1s0+3GTF0fsjeGIh0i5LncjrVKVlIP2ZMoJrLBl0D/M=; b=INLogPRLDBQuuQbiPJxIxU+i7I
        IbX7MxHRerkb6n4Ff/YtspDjH8U0hxIMMcxOTlxBqDYaOmUsrl5dfnFTFeteu2mT1M/Pq2ISkLOZ4
        1B4S1r19xgXdBuQlGhbigeZDAJrWFCqgCJ9U6Q4acltKF+gZTrtdMF+2V3FQ4aJWLZ1rvloTTTdf8
        OfWchvYQ3CIJv0KjRI4wT9s7UU0TyTP/VYCPwo0wGLjulic3eG7ivsxrt4ds1wZ7Wh2RhMf49OEgh
        O9KndvKz7K43ZJKWQO+i1SSw676yVm/H+i2K4sD2yZvxIgpjlkC8hcqfxXdgWjwRK+pR8rbK6PZU+
        nAmmaUmQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1orH3s-009Eek-U8; Sat, 05 Nov 2022 11:10:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CBBA130012F;
        Sat,  5 Nov 2022 12:10:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B5F2820B40528; Sat,  5 Nov 2022 12:10:02 +0100 (CET)
Date:   Sat, 5 Nov 2022 12:10:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
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
Message-ID: <Y2ZEinL+wlIX+1Sn@hirez.programming.kicks-ass.net>
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-3-kim.phillips@amd.com>
 <Y2WJjdY3wwQl9/q9@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2WJjdY3wwQl9/q9@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022 at 10:52:13PM +0100, Borislav Petkov wrote:
> On Fri, Nov 04, 2022 at 04:36:50PM -0500, Kim Phillips wrote:
> >  - Allow for spectre_v2=autoibrs in the kernel command line,
> >    reverting to auto-selection if the feature isn't available.
> 
> Why?
> 
> What the whole logic here should do is enable autoibrs when detected
> automatically, without the need for the user to even select it as it is
> the superior mitigation.

Well; perhaps the whole autoibrs thing should be mapped to the existing
eIBRS options. AFAICT this is the same thing under a new name, no need
to invent yet more options. bugs.c is quite insane enough already.
