Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC8A4DE038
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbiCRRs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236763AbiCRRs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:48:57 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED18130DC7A;
        Fri, 18 Mar 2022 10:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jtXAoNk4oHdT6AchqGCksjwUQyf3YGIaQZHARzJgBPI=; b=SB0qvOOM4dSIeWvJQgJRbW9rIR
        ZXbNVm78f4P8tMst7oZjSVCKBlA+qJKczOrAnyuQ4uKcpm2/YAsRNwevrc9PEwEIpkuSNpW2ei8KA
        70WS8JDsADQqBefxhS4BM3x96Ef5khyZhsTUkdj6jvpodQQKt+bbezGgpg0aEXvwX2/5u+4D0qBwK
        Le4JBou9OKvSQ+SLJ6MHVBgBsTyF1nnXdXB0u2nsQwwEfeML2bsZvPa+vaJFQ4pSDwWJN8rP+JIkY
        7zgzZoY+zdIR6nAjqzVBLD7xni1CBuPTRGpSLJEdQvqX4z1t633g+MmitE19jGfQ+H54IeHyDAEQO
        mgmXKtDQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nVGhJ-002GU8-Dl; Fri, 18 Mar 2022 17:47:33 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id BF02698841D; Fri, 18 Mar 2022 18:47:32 +0100 (CET)
Date:   Fri, 18 Mar 2022 18:47:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, seanjc@google.com
Subject: Re: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
Message-ID: <20220318174732.GE14330@worktop.programming.kicks-ass.net>
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-7-pbonzini@redhat.com>
 <3bbe3f8717cdf122f909a48e117dab6c09d8e0c8.camel@redhat.com>
 <1dc56110-5f1b-6140-937c-bf4a28ddbe87@redhat.com>
 <20220318172837.GQ8939@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318172837.GQ8939@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 06:28:37PM +0100, Peter Zijlstra wrote:
> > Related to this, I don't see anything in arch/x86/kernel/static_call.c that
> > limits this code to x86-64:
> > 
> >                 if (func == &__static_call_return0) {
> >                         emulate = code;
> >                         code = &xor5rax;
> >                 }
> > 
> > 
> > On 32-bit, it will be patched as "dec ax; xor eax, eax" or something like
> > that.  Fortunately it doesn't corrupt any callee-save register but it is not
> > just a bit funky, it's also not a single instruction.
> 
> Urggghh.. that's fairly yuck. So there's two options I suppose:
> 
> 	0x66, 0x66, 0x66, 0x31, 0xc0

Argh, that turns into: xorw %ax, %ax.

Let me see if there's another option.

> Which is a tripple prefix xor %eax, %eax, which, IIRC should still clear
> the whole 64bit on 64bit and *should* still not trigger the prefix
> decoding penalty some frontends have (which is >3 IIRC).
> 
> Or we can emit:
> 
> 	0xb8, 0x00, 0x00, 0x00, 0x00
> 
> which decodes to: mov $0x0,%eax, which is less efficient in some
> front-ends since it doesn't always get picked up in register rename
> stage.
> 
> 
