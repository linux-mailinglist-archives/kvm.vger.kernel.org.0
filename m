Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A72613F55
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 21:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiJaUzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 16:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiJaUzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 16:55:31 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A4913D63
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 13:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=chfqJSScQ3qOlYlT7wRsaEKtslKVNvF3Pi/wWrj+H5Q=; b=cDaDsAEnZ9GgfjWG20p3DdmuGs
        71JnqfVghsiOtLzpoUBXC+/dgi+YQ64ISli+q5Yg0knlZB3fjeUbe3j6ySr241e0+1qpdNPZZ2JlV
        JIAhYzVOUOB3Zip8KxwHVkSMfLimzV8pSa8nRjTVquNTUS95KP93UQXsRo1gQcKeCdeDkVTDA4cfc
        e1yW/4p12la8CjQEEGFekeSOjl9WZV41zwhwy/xI8SDKULMnjB/pN5shP+4fRlz57wn045xdNxmGx
        aKqHXnhitQ4TUy5Budf8Y2f0M9/9+gZ3krPit9zr8r9UlM6Ce69XPEmtn7fTygObVEMdPtCq2qC/I
        D52LB1dA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1opboD-007xXL-Ss; Mon, 31 Oct 2022 20:55:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 978D530020B;
        Mon, 31 Oct 2022 21:54:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 81F372C76DB81; Mon, 31 Oct 2022 21:54:54 +0100 (CET)
Date:   Mon, 31 Oct 2022 21:54:54 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Gaosheng Cui <cuigaosheng1@huawei.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix undefined behavior in bit shift for
 __feature_bit
Message-ID: <Y2A2HmJxTdoWm1vf@hirez.programming.kicks-ass.net>
References: <20221031113638.4182263-1-cuigaosheng1@huawei.com>
 <Y2AJIFQlF5C0ozoU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2AJIFQlF5C0ozoU@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 05:42:56PM +0000, Sean Christopherson wrote:
> On Mon, Oct 31, 2022, Gaosheng Cui wrote:
> > Shifting signed 32-bit value by 31 bits is undefined, so changing
> > significant bit to unsigned. The UBSAN warning calltrace like below:
> > 
> > UBSAN: shift-out-of-bounds in arch/x86/kvm/reverse_cpuid.h:101:11
> > left shift of 1 by 31 places cannot be represented in type 'int'
> 
> PeterZ is contending that this isn't actually undefined behavior given how the
> kernel is compiled[*].  That said, I would be in favor of replacing the open-coded
> shift with BIT() to make the code a bit more self-documenting, and that would
> naturally fix this maybe-undefined-behavior issue. 
> 
> [*] https://lore.kernel.org/all/Y1%2FAaJOcgIc%2FINtv@hirez.programming.kicks-ass.net

I'm definitely in favour of updating this code; both your suggestion and
hpa's suggestion look like sane changes. But I do feel that whatever
UBSAN thing generated this warning needs to be fixed too.

I'm fine with the compiler warning about this code -- but it must not
claim undefined behaviour given the compiler flags we use.
