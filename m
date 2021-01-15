Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414002F7568
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 10:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731127AbhAOJ2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 04:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbhAOJ2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 04:28:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3051C061757;
        Fri, 15 Jan 2021 01:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U+hG/mavMZpvfSPes2gpdEM/EjKu6huLCmLOLZQWXjA=; b=OJ7jgDXGo0Ik4ORSM8YvJSayxh
        hFqdmOcTH6vmfY/l6woP1JAEx0bMJGdMXg+fU8tf+8ermNzXy0kw+9/WagVzwLdFmP3aOqRTwo+F9
        Yyr+3Pendd/SpmTDpCcT7fEGG/nZd80l39UTleeZZgil0IXO41zchyqTrCAdQosrFtpe2L3JR3RUZ
        UGQ+pY9SWRTQNoOyKEotY9O6g+GwiiP0knYIrIwUQXT4uZOXB6KvfuayEc8XoPHntWjcyuI2fsrix
        nUIdixT9M3099O2QDmkrzelDk7+A5MPMksWOhUussvQ7+tUDUCDOo9bBP5vh4jnyb89alMt7Dg30s
        cbnxFM8w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l0LNc-008j2a-49; Fri, 15 Jan 2021 09:27:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C13C0301324;
        Fri, 15 Jan 2021 10:26:51 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A5D83200E0BD2; Fri, 15 Jan 2021 10:26:51 +0100 (CET)
Date:   Fri, 15 Jan 2021 10:26:51 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jason Baron <jbaron@akamai.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
Message-ID: <YAFf2+nvhvWjGImy@hirez.programming.kicks-ass.net>
References: <cover.1610680941.git.jbaron@akamai.com>
 <e5cc82ead7ab37b2dceb0837a514f3f8bea4f8d1.1610680941.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5cc82ead7ab37b2dceb0837a514f3f8bea4f8d1.1610680941.git.jbaron@akamai.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 10:27:55PM -0500, Jason Baron wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3f7c1fc..c21927f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -113,6 +113,15 @@ static int sync_regs(struct kvm_vcpu *vcpu);
>  struct kvm_x86_ops kvm_x86_ops __read_mostly;
>  EXPORT_SYMBOL_GPL(kvm_x86_ops);
>  
> +#define KVM_X86_OP(func)					     \
> +	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
> +				*(((struct kvm_x86_ops *)0)->func));
> +#define KVM_X86_OP_NULL KVM_X86_OP
> +#include <asm/kvm-x86-ops.h>
> +EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
> +EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
> +EXPORT_STATIC_CALL_GPL(kvm_x86_tlb_flush_current);

Would something like:

  https://lkml.kernel.org/r/20201110103909.GD2594@hirez.programming.kicks-ass.net

Be useful? That way modules can call the static_call() but not change
it.
