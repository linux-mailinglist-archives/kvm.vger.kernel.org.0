Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021C6722DE7
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjFERwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbjFERwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:52:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B80CF1;
        Mon,  5 Jun 2023 10:52:13 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685987532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rxkSm+r2MuxwffE6LSORNENjYZAwM8TRdnyWWwPwchc=;
        b=TVAJdJlhkwGrJTj6GIv6umSELa1bW+XbBLNGHMqp/PMHZdJA8ri6hJ56J+IebrHo8ysVu4
        xM6MllWATCE9e4t51WQ3TO1ZZpbvfDQDCnpUlgVuIrp3h3OQAXf5zjnFxhe1Fa7qZdlknF
        zapYsNPLIaxIiYj2im+pGdQnS1j3+UMImJiaExzr4uMQmvB3PI5B7S8fBRXkTIosHTWKKv
        fPM+b84hZFhGd5VMDGEa+b8x8qU1nEgXHl+8ONloLrpGJr9WFqjckPtSnXi6lCo166Bu8H
        9YpyOEBtjhd0t3TPZQsMGByGi6+Sp1CcCXSW97CdoNpZ/3RV3tfXjYyqNF3jDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685987532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rxkSm+r2MuxwffE6LSORNENjYZAwM8TRdnyWWwPwchc=;
        b=7ZI8NSDxrLNaC0GpYEEIG6FRMHOZfxz5I/RhObVSqmkVGUbij1umlLQHz8Uxotjrrodo66
        5lXvMh5SrTaorkDg==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 05/33] x86/traps: add external_interrupt() to
 dispatch external interrupts
In-Reply-To: <87ttvm6s2v.ffs@tglx>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-6-xin3.li@intel.com> <87ttvm6s2v.ffs@tglx>
Date:   Mon, 05 Jun 2023 19:52:11 +0200
Message-ID: <87wn0h4x10.ffs@tglx>
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

On Mon, Jun 05 2023 at 13:56, Thomas Gleixner wrote:
> On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
> How is this supposed to work once the vector space gets extended in a
> later version of FRED?
>
> Can we please think about this _now_ and not rewrite all of this two
> years down the road? 
>
> Even if that's not fully specified yet, here is the obvious question:
>
>  What are we going to do with the system vectors. Are they going to
>  stay just in the middle of the expanded vector space?
>
> That would be completely non-sensical as we'd end up with yet another
> segmentation of the vector space.
>
> So the obvious solution is to segment the vector space in the following
> way:
>
>   0  - 31   Exceptions/traps        - Cannot be moved
>  32         IRQ_MOVE_CLEANUP_VECTOR
>  33  - X    System vectors including APIC_SPURIOUS
>  X+1 - MAX  External interrupts
>
> This spares the IRQ_MOVE_CLEANUP_VECTOR hackery. It requires to move the
> ISA vectors, but that's not rocket science.

Which we just discussed completely away. :)

> That makes the external interrupt vector space trivially expandable, no?

So there is a theoretical problem here that device interrupts could
starve system vectors due to the priority scheme. Needs some thought.

That whole APIC priority muck is pretty useless as long as CR8 writes
are slower than sti/cli. When I tested that last (Broadwell) they were
significantly slower.

Also it's unclear how that expansion vector space is handled
vs. priorities.

Ideally event delivery would be FIFO because that's the only guarantee
for preventing starvation without having to configure priorities (which
is mostly a wrong guess anyway).

Thanks,

        tglx
