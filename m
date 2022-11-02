Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DC0616F39
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 21:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiKBU4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 16:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiKBU4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 16:56:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B76C9FFD
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 13:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RuYJBwdniC0fUIA8iPYvmqqtIFeCrOoE56vBbxBIa1w=; b=wUJiR5mE13DDjTMOHdu4oOUwsD
        nTNhOS567uNhR/8LADRz1JqAymbZ3PEvKiajRgviBOreNLS/+YzRt8u4qHlLoIsKdNxEBdG9Bb7n4
        EoiCEXUn4U3yOlh6MFTvO35Oy5aUWKuHkCMag8yuWZ/NKYRuXkbrfb1cPhzHuOPtABB8wkKEr9OzW
        KnlymCRkXRVJcIV45NN3j4iCq4RwaevxfJxdEuIKwrhARSQbaVOzhmLKjcsZTZcAYHEGlnmi26bga
        6Fhsyw0o82Yyc+tMXi9TlQjAQ//QnazVTLjJoP+/V1tPOARtETfQNpfOxxxUaqE6pDE3hXyrMjpr3
        f04U2sJA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqKmT-005ptZ-Iq; Wed, 02 Nov 2022 20:56:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 73F8A30031B;
        Wed,  2 Nov 2022 21:56:07 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5B8272078A2A9; Wed,  2 Nov 2022 21:56:07 +0100 (CET)
Date:   Wed, 2 Nov 2022 21:56:07 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix undefined behavior in bit shift for
 __feature_bit
Message-ID: <Y2LZZ7VTq4MfHTxD@hirez.programming.kicks-ass.net>
References: <20221031113638.4182263-1-cuigaosheng1@huawei.com>
 <Y2AJIFQlF5C0ozoU@google.com>
 <Y2A2HmJxTdoWm1vf@hirez.programming.kicks-ass.net>
 <47ae788b-c19d-3a1f-8ac2-b6674770e79f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ae788b-c19d-3a1f-8ac2-b6674770e79f@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 06:54:22PM +0100, Paolo Bonzini wrote:
> On 10/31/22 21:54, Peter Zijlstra wrote:
> > > PeterZ is contending that this isn't actually undefined behavior given how the
> > > kernel is compiled[*].  That said, I would be in favor of replacing the open-coded
> > > shift with BIT() to make the code a bit more self-documenting, and that would
> > > naturally fix this maybe-undefined-behavior issue.
> > > 
> > > [*]https://lore.kernel.org/all/Y1%2FAaJOcgIc%2FINtv@hirez.programming.kicks-ass.net
> > I'm definitely in favour of updating this code; both your suggestion and
> > hpa's suggestion look like sane changes. But I do feel that whatever
> > UBSAN thing generated this warning needs to be fixed too.
> > 
> > I'm fine with the compiler warning about this code -- but it must not
> > claim undefined behaviour given the compiler flags we use.
> 
> Yes, the compiler is buggy here (see old bug report for GCC, now fixed, at
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=68418).
> 
> I cannot even reproduce the problem with the simple userspace testcase
> 
> #include <stdlib.h>
> int main(int argc) {
> 	int i = argc << 31;
> 	exit(i < 0);
> }
> 
> on either GCC 12 or clang 15.

Perhaps we should have the UBSAN splat include the compiler-version
used... because clearly someone is using ancient crap here.
