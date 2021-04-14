Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB4135F03C
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 11:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350395AbhDNJBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 05:01:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350259AbhDNJAN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 05:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618390777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+7RKdsYE9Dit9s7fqKe4htpbMtGwJmEzBNvN06lrEuM=;
        b=hpcRFkV6DNU5wnEx8H9QsM/UmRrYp1IJJHYWp6SsUmMda2NrTOhbdcS/D/IoritO1RDgX3
        frDSN1vI7craSTy9Rc/7nJALPxn/A/UWoV2Wgzz6FUVdGcAohapQugN9/ba2dIBG2Z2BiE
        cjRDeiydlbdq0WVvc8HRTQKb+yIeqd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-WpdarJk9PDiDQU8sr6jrMA-1; Wed, 14 Apr 2021 04:59:35 -0400
X-MC-Unique: WpdarJk9PDiDQU8sr6jrMA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 772778030A0;
        Wed, 14 Apr 2021 08:59:34 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33A7362499;
        Wed, 14 Apr 2021 08:59:24 +0000 (UTC)
Date:   Wed, 14 Apr 2021 10:59:21 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 1/8] arm/arm64: Reorganize cstart assembler
Message-ID: <20210414085921.lazllz24o3eqts52@kamzik.brq.redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-2-drjones@redhat.com>
 <2b647637-d307-5256-beab-c58728f60e9b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b647637-d307-5256-beab-c58728f60e9b@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 05:34:24PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/7/21 7:59 PM, Andrew Jones wrote:
> > Move secondary_entry helper functions out of .init and into .text,
> > since secondary_entry isn't run at "init" time.
> 
> The tests aren't loaded using the loader, so as far as I can tell the reason for
> having an .init section is to make sure the code from the start label is put at
> offset 0 in the test binary. As long as the start label is kept at the beginning
> of the .init section, and the loader script places the section first, I don't see
> any issues with this change.
> 
> The only hypothetical problem that I can think of is that the code from .init
> calls code from .text, and if the text section grows very large we might end up
> with a PC offset larger than what can be encoded in the BL instruction. That's
> unlikely to happen (the offset is 16MB for arm and 64MB for arm64), and the .init
> code already calls other functions (like setup) which are in .text, so we would
> have this problem regardless of this change. And the compiler will emit an error
> if that happens.
> 
> >
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arm/cstart.S   | 62 +++++++++++++++++++++++++++-----------------------
> >  arm/cstart64.S | 22 +++++++++++-------
> >  2 files changed, 48 insertions(+), 36 deletions(-)
> >
> > diff --git a/arm/cstart.S b/arm/cstart.S
> > index d88a98362940..653ab1e8a141 100644
> > --- a/arm/cstart.S
> > +++ b/arm/cstart.S
> > @@ -96,32 +96,7 @@ start:
> >  	bl	exit
> >  	b	halt
> >  
> > -
> > -.macro set_mode_stack mode, stack
> > -	add	\stack, #S_FRAME_SIZE
> > -	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
> > -	isb
> > -	mov	sp, \stack
> > -.endm
> > -
> > -exceptions_init:
> > -	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
> > -	bic	r2, #CR_V		@ SCTLR.V := 0
> > -	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
> > -	ldr	r2, =vector_table
> > -	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
> > -
> > -	mrs	r2, cpsr
> > -
> > -	/* first frame reserved for svc mode */
> > -	set_mode_stack	UND_MODE, r0
> > -	set_mode_stack	ABT_MODE, r0
> > -	set_mode_stack	IRQ_MODE, r0
> > -	set_mode_stack	FIQ_MODE, r0
> > -
> > -	msr	cpsr_cxsf, r2		@ back to svc mode
> > -	isb
> > -	mov	pc, lr
> > +.text
> 
> Hm... now we've moved enable_vfp from .init to .text, and enable_vfp *is* called
> from .init code, which doesn't fully match up with the commit message. Is the
> actual reason for this change that the linker script for EFI will discard the
> .init section? Maybe it's worth mentioning that in the commit message, because it
> will explain this change better.

Right, the .init section may not exist when linking with other linker
scripts. I'll make the commit message more clear.

> Or is it to align arm with arm64, where only
> start is in the .init section?
> 
> >  
> >  enable_vfp:
> >  	/* Enable full access to CP10 and CP11: */
> > @@ -133,8 +108,6 @@ enable_vfp:
> >  	vmsr	fpexc, r0
> >  	mov	pc, lr
> >  
> > -.text
> > -
> >  .global get_mmu_off
> >  get_mmu_off:
> >  	ldr	r0, =auxinfo
> > @@ -235,6 +208,39 @@ asm_mmu_disable:
> >  
> >  	mov     pc, lr
> >  
> > +/*
> > + * Vectors
> > + */
> > +
> > +.macro set_mode_stack mode, stack
> > +	add	\stack, #S_FRAME_SIZE
> > +	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
> > +	isb
> > +	mov	sp, \stack
> > +.endm
> > +
> > +exceptions_init:
> > +	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
> > +	bic	r2, #CR_V		@ SCTLR.V := 0
> > +	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
> > +	ldr	r2, =vector_table
> > +	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
> > +
> > +	mrs	r2, cpsr
> > +
> > +	/*
> > +	 * Input r0 is the stack top, which is the exception stacks base
> > +	 * The first frame is reserved for svc mode
> > +	 */
> > +	set_mode_stack	UND_MODE, r0
> > +	set_mode_stack	ABT_MODE, r0
> > +	set_mode_stack	IRQ_MODE, r0
> > +	set_mode_stack	FIQ_MODE, r0
> > +
> > +	msr	cpsr_cxsf, r2		@ back to svc mode
> > +	isb
> > +	mov	pc, lr
> > +
> >  /*
> >   * Vector stubs
> >   * Simplified version of the Linux kernel implementation
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index 0a85338bcdae..d39cf4dfb99c 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -89,10 +89,12 @@ start:
> >  	msr	cpacr_el1, x4
> >  
> >  	/* set up exception handling */
> > +	mov	x4, x0				// x0 is the addr of the dtb
> 
> I suppose changing exceptions_init to use x0 as a scratch register instead of x4
> makes some sense if you look at it from the perspective of it being called from
> secondary_entry, where all the functions use x0 as a scratch register. But it's
> still called from start, where using x4 as a scratch register is preferred because
> of the kernel boot protocol (x0-x3 are reserved).
> 
> Is there an actual bug that this is supposed to fix (I looked for it and couldn't
> figure it out) or is it just a cosmetic change?

Now that exceptions_init isn't a private function of start (actually it
hasn't been in a long time, considering secondary_entry calls it) I would
like it to better conform to calling conventions. I guess I should have
used x19 here instead of x4 to be 100% correct. Or, would you rather I
just continue using x4 in exceptions_init in order to avoid the
save/restore?

Thanks,
drew

