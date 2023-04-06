Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064B86DA56E
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 00:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238925AbjDFV74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 17:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239782AbjDFV7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 17:59:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC01B46D;
        Thu,  6 Apr 2023 14:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U8JW0408VL+0xUA1rdsbCgWZ7VzW8QR93tRjPIuuUHY=; b=sKDCcUHIsdldUKSc73yu/nAvU6
        q6H0Z+iGdUSkV7WetTYD+KgssCbS+ZImEj+6QfYcyDgYu5l9HneHncQ5MvI0BHtsDJgx0qOUwcjha
        fpVsoxDJxr8by/Ar77X7MEaXVF09SCCtLNQxRneTi4wwfu64EJBeUjtaN8pcKt2XxxA8YiFNsfQm/
        RvMBNsfjjRxFhER9xNRkWS4XmtJ+yCZKz6D8c6P7Z0uJArOWfB48hWJeNJbnFcIGvL/zJo96OwIh0
        /WElvKlA4J3IjrXq6ZHxU0fMQdEZnz5u7gWfOjKAWGfqWtcZ48BeJ5gEUmcStPP90J+AoWe3dT/k/
        O8RKFAyQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pkXcz-000CyW-U7; Thu, 06 Apr 2023 21:58:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CA2D430036C;
        Thu,  6 Apr 2023 23:58:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 57DDF20B52972; Thu,  6 Apr 2023 23:58:43 +0200 (CEST)
Date:   Thu, 6 Apr 2023 23:58:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
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
        linux-coco@lists.linux.dev, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 3/7] x86/entry: Implement atomic-IST-entry
Message-ID: <20230406215843.GH405948@hirez.programming.kicks-ass.net>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <20230403140605.540512-4-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140605.540512-4-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 10:06:01PM +0800, Lai Jiangshan wrote:
> +static __always_inline
> +void copy_regs_exception_head(struct pt_regs *target, const struct pt_regs *from)
> +{
> +	target->ss	= from->ss;
> +	target->sp	= from->sp;
> +	target->flags 	= from->flags;
> +	target->cs	= from->cs;
> +	target->ip	= from->ip;
> +	target->orig_ax	= from->orig_ax;
> +}
> +
> +static __always_inline
> +void copy_regs_general_registers(struct pt_regs *target, const struct pt_regs *from)
> +{
> +	target->di  = from->di;
> +	target->si  = from->si;
> +	target->dx  = from->dx;
> +	target->cx  = from->cx;
> +	target->ax  = from->ax;
> +	target->r8  = from->r8;
> +	target->r9  = from->r9;
> +	target->r10 = from->r10;
> +	target->r11 = from->r11;
> +	target->bx  = from->bx;
> +	target->bp  = from->bp;
> +	target->r12 = from->r12;
> +	target->r13 = from->r13;
> +	target->r14 = from->r14;
> +	target->r15 = from->r15;
> +}

> +/* Replicate the interrupted atomic-IST-entry's CLEAR_REGS macro. */
> +static __always_inline void replicate_clear_regs(struct pt_regs *target)
> +{
> +	target->di  = 0;
> +	target->si  = 0;
> +	target->dx  = 0;
> +	target->cx  = 0;
> +	target->ax  = 0;
> +	target->r8  = 0;
> +	target->r9  = 0;
> +	target->r10 = 0;
> +	target->r11 = 0;
> +	target->bx  = 0;
> +	target->bp  = 0;
> +	target->r12 = 0;
> +	target->r13 = 0;
> +	target->r14 = 0;
> +	target->r15 = 0;
> +}

I think there's compilers smart enough to see through your attempts at
avoiding mem{set,cpy}() there and I think we'll end up needing something
like __inline_memset() and __inline_memcpy() like here:

https://lore.kernel.org/lkml/Y759AJ%2F0N9fqwDED@hirez.programming.kicks-ass.net/
