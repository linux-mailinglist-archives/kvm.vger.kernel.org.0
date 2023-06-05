Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F237224F8
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 13:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjFEL4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 07:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjFEL4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 07:56:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0369C;
        Mon,  5 Jun 2023 04:56:11 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685966168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p9Tml1V4RSPC7qDnk/kmiBF7Kh2SuiVuJ3mG8ZUlnf4=;
        b=NQKly6a3QMGV5jln9Z9QXvUl/Mc6GnI0e+XGgHcnkInUw6wHpFP704HQTPtkaUt1zXwArs
        ga+GuvVEzMW2fABmXH5erPpiOMJpymDuxTFv+RUat2xpEQQAsnxCFGVPOMdlOZWA8L6ZeE
        mX0q5b8ylcCnJd16Cl4IkZ7hL/Uoi/4DyDM4UFCxEAxEdy/JETxIHTHIK10dx1NeEK1iqf
        WiiWhqJxLB6Lsn8Rxfr4X99Xi48YHdypzl2sey8ab/KsvYT1y+fBqVUNSESJoc2qdhjR+Q
        PkiBGFgeqjSDBFytdjjt7GHaKHcQCjnbiluUOw9rV36xkpb/Oryx9xlTfIbDkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685966168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p9Tml1V4RSPC7qDnk/kmiBF7Kh2SuiVuJ3mG8ZUlnf4=;
        b=knnT5Q+dgC9LrjR9Tt7MOnZSYwr8QxLW4MDQzgKDMKnF5qnQyGjdFNO/DafA56Ap8tRIxO
        tZUXqK2IbZyWYFAg==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 05/33] x86/traps: add external_interrupt() to
 dispatch external interrupts
In-Reply-To: <20230410081438.1750-6-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-6-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 13:56:08 +0200
Message-ID: <87ttvm6s2v.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
> Add external_interrupt() to dispatch external interrupts to their handlers.
>
> If an external interrupt is a system interrupt, dipatch it through
> system_interrupt_handlers table, otherwise to
> dispatch_common_interrupt().

This naming convention sucks. external interrupts which can be system
interrupts. Come on.

> +/*
> + * External interrupt dispatch function.
> + *
> + * Until/unless dispatch_common_interrupt() can be taught to deal with the
> + * special system vectors, split the dispatch.

More gibberish. It's not useful to add your sloppy personal notes which
are not understandable for anyone else. That comment might eventually
make some sense right in the code where the condition is.

> + * Note: dispatch_common_interrupt() already deals with IRQ_MOVE_CLEANUP_VECTOR.
> + */
> +int external_interrupt(struct pt_regs *regs)
> +{
> +	unsigned int vector = regs->vector;
> +	unsigned int sysvec = vector - FIRST_SYSTEM_VECTOR;
> +
> +	if (vector < FIRST_EXTERNAL_VECTOR) {

unlikely(...)

> +		pr_err("invalid external interrupt vector %d\n", vector);
> +		return -EINVAL;
> +	}
> +
> +	if (sysvec < NR_SYSTEM_VECTORS)
> +		system_interrupt_handlers[sysvec](regs);
> +	else
> +		dispatch_common_interrupt(regs, vector);

How is this supposed to work once the vector space gets extended in a
later version of FRED?

Can we please think about this _now_ and not rewrite all of this two
years down the road? 

Even if that's not fully specified yet, here is the obvious question:

 What are we going to do with the system vectors. Are they going to
 stay just in the middle of the expanded vector space?

That would be completely non-sensical as we'd end up with yet another
segmentation of the vector space.

So the obvious solution is to segment the vector space in the following
way:

  0  - 31   Exceptions/traps        - Cannot be moved
 32         IRQ_MOVE_CLEANUP_VECTOR
 33  - X    System vectors including APIC_SPURIOUS
 X+1 - MAX  External interrupts

This spares the IRQ_MOVE_CLEANUP_VECTOR hackery. It requires to move the
ISA vectors, but that's not rocket science.

That makes the external interrupt vector space trivially expandable, no?

Coming back to that comment:

> + * Until/unless dispatch_common_interrupt() can be taught to deal with the
> + * special system vectors, split the dispatch.

That's simply wishful thinking. Because all what this would achieve is
moving the condition and table lookup into dispatch_common_interrupt().

What's the win aside of convoluted code?

There are only two options to deal with that:

    1) Have the condition in external_interrupt()

       if (unlikely(vector < LEGACY_MAX_EXCEPTION_VECTORS))
            yell_and_bail();

       if (vector < FIRST_DEVICE_VECTOR)
            sysvec_handler[vector](regs)
       else
            fred_common_interrupt(regs, vector);

    2) Make the sysvec_handler[] fred wrapper functions take the vector
       argument and allocate the sysvec_handler[] array dynamically
       sized based on the maximum number of supported vectors in a
       particular [FRED]APIC implementation.

       Not sure whether that's worth it as FRED allows up to 64k vectors
       if I understand the reserved space layout in the spec correctly
       and that would cost 512k memory just for the table.

Why has all of the above not been thought through and addressed _before_
posting this pile?

<Kernel development educational template #11>

  1) Implementing a Prove of Concept for early validation is perfectly
     fine.

  2) Trying to sell that PoC upstream by polishing it a bit is doomed.

  3) The proper tools for upstream development are brain and taste, not
     duct tape and stapler.

</Kernel development educational template #11>

Thanks,

        tglx
