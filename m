Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E6C3609ED
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhDONDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:03:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232332AbhDONDm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 09:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618491799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CiuW5G7174N1nIvctBeDjqozkHMzKYq3gtNMA3LnU7M=;
        b=dggAAekTQLsWqFRkJhvIhmwxTBzlw5rVy3Wd4xHrQml+qKTtvwrJD4y9ExQhvrXct9ZONf
        3rTo2Tolmd0lg/E0q4trF+Ejqvh7IfHuN6ybCrPQBUGgtgc7GHGFnHaB8FoLCf8/oQPyIr
        SizqeIF+vok2dh+IgxOTWkJTWe/feuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-2ZxS_BSLPiao75LrO1Wctg-1; Thu, 15 Apr 2021 09:03:16 -0400
X-MC-Unique: 2ZxS_BSLPiao75LrO1Wctg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FC0010054F6;
        Thu, 15 Apr 2021 13:03:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05DEB19D9F;
        Thu, 15 Apr 2021 13:03:09 +0000 (UTC)
Date:   Thu, 15 Apr 2021 15:03:07 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 1/8] arm/arm64: Reorganize cstart assembler
Message-ID: <20210415130307.axkkcftuwpc6xbcr@kamzik.brq.redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-2-drjones@redhat.com>
 <2b647637-d307-5256-beab-c58728f60e9b@arm.com>
 <20210414085921.lazllz24o3eqts52@kamzik.brq.redhat.com>
 <931b6bdd-c012-7666-ff79-0bf337dedfcf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <931b6bdd-c012-7666-ff79-0bf337dedfcf@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 14, 2021 at 04:15:10PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/14/21 9:59 AM, Andrew Jones wrote:
> > On Tue, Apr 13, 2021 at 05:34:24PM +0100, Alexandru Elisei wrote:
> >> Hi Drew,
> >>
> >> On 4/7/21 7:59 PM, Andrew Jones wrote:
> >>> Move secondary_entry helper functions out of .init and into .text,
> >>> since secondary_entry isn't run at "init" time.
> >> The tests aren't loaded using the loader, so as far as I can tell the reason for
> >> having an .init section is to make sure the code from the start label is put at
> >> offset 0 in the test binary. As long as the start label is kept at the beginning
> >> of the .init section, and the loader script places the section first, I don't see
> >> any issues with this change.
> >>
> >> The only hypothetical problem that I can think of is that the code from .init
> >> calls code from .text, and if the text section grows very large we might end up
> >> with a PC offset larger than what can be encoded in the BL instruction. That's
> >> unlikely to happen (the offset is 16MB for arm and 64MB for arm64), and the .init
> >> code already calls other functions (like setup) which are in .text, so we would
> >> have this problem regardless of this change. And the compiler will emit an error
> >> if that happens.
> >>
> >>> Signed-off-by: Andrew Jones <drjones@redhat.com>
> >>> ---
> >>>  arm/cstart.S   | 62 +++++++++++++++++++++++++++-----------------------
> >>>  arm/cstart64.S | 22 +++++++++++-------
> >>>  2 files changed, 48 insertions(+), 36 deletions(-)
> >>>
> >>> diff --git a/arm/cstart.S b/arm/cstart.S
> >>> index d88a98362940..653ab1e8a141 100644
> >>> --- a/arm/cstart.S
> >>> +++ b/arm/cstart.S
> >>> @@ -96,32 +96,7 @@ start:
> >>>  	bl	exit
> >>>  	b	halt
> >>>  
> >>> -
> >>> -.macro set_mode_stack mode, stack
> >>> -	add	\stack, #S_FRAME_SIZE
> >>> -	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
> >>> -	isb
> >>> -	mov	sp, \stack
> >>> -.endm
> >>> -
> >>> -exceptions_init:
> >>> -	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
> >>> -	bic	r2, #CR_V		@ SCTLR.V := 0
> >>> -	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
> >>> -	ldr	r2, =vector_table
> >>> -	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
> >>> -
> >>> -	mrs	r2, cpsr
> >>> -
> >>> -	/* first frame reserved for svc mode */
> >>> -	set_mode_stack	UND_MODE, r0
> >>> -	set_mode_stack	ABT_MODE, r0
> >>> -	set_mode_stack	IRQ_MODE, r0
> >>> -	set_mode_stack	FIQ_MODE, r0
> >>> -
> >>> -	msr	cpsr_cxsf, r2		@ back to svc mode
> >>> -	isb
> >>> -	mov	pc, lr
> >>> +.text
> >> Hm... now we've moved enable_vfp from .init to .text, and enable_vfp *is* called
> >> from .init code, which doesn't fully match up with the commit message. Is the
> >> actual reason for this change that the linker script for EFI will discard the
> >> .init section? Maybe it's worth mentioning that in the commit message, because it
> >> will explain this change better.
> > Right, the .init section may not exist when linking with other linker
> > scripts. I'll make the commit message more clear.
> >
> >> Or is it to align arm with arm64, where only
> >> start is in the .init section?
> >>
> >>>  
> >>>  enable_vfp:
> >>>  	/* Enable full access to CP10 and CP11: */
> >>> @@ -133,8 +108,6 @@ enable_vfp:
> >>>  	vmsr	fpexc, r0
> >>>  	mov	pc, lr
> >>>  
> >>> -.text
> >>> -
> >>>  .global get_mmu_off
> >>>  get_mmu_off:
> >>>  	ldr	r0, =auxinfo
> >>> @@ -235,6 +208,39 @@ asm_mmu_disable:
> >>>  
> >>>  	mov     pc, lr
> >>>  
> >>> +/*
> >>> + * Vectors
> >>> + */
> >>> +
> >>> +.macro set_mode_stack mode, stack
> >>> +	add	\stack, #S_FRAME_SIZE
> >>> +	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
> >>> +	isb
> >>> +	mov	sp, \stack
> >>> +.endm
> >>> +
> >>> +exceptions_init:
> >>> +	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
> >>> +	bic	r2, #CR_V		@ SCTLR.V := 0
> >>> +	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
> >>> +	ldr	r2, =vector_table
> >>> +	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
> >>> +
> >>> +	mrs	r2, cpsr
> >>> +
> >>> +	/*
> >>> +	 * Input r0 is the stack top, which is the exception stacks base
> >>> +	 * The first frame is reserved for svc mode
> >>> +	 */
> >>> +	set_mode_stack	UND_MODE, r0
> >>> +	set_mode_stack	ABT_MODE, r0
> >>> +	set_mode_stack	IRQ_MODE, r0
> >>> +	set_mode_stack	FIQ_MODE, r0
> >>> +
> >>> +	msr	cpsr_cxsf, r2		@ back to svc mode
> >>> +	isb
> >>> +	mov	pc, lr
> >>> +
> >>>  /*
> >>>   * Vector stubs
> >>>   * Simplified version of the Linux kernel implementation
> >>> diff --git a/arm/cstart64.S b/arm/cstart64.S
> >>> index 0a85338bcdae..d39cf4dfb99c 100644
> >>> --- a/arm/cstart64.S
> >>> +++ b/arm/cstart64.S
> >>> @@ -89,10 +89,12 @@ start:
> >>>  	msr	cpacr_el1, x4
> >>>  
> >>>  	/* set up exception handling */
> >>> +	mov	x4, x0				// x0 is the addr of the dtb
> >> I suppose changing exceptions_init to use x0 as a scratch register instead of x4
> >> makes some sense if you look at it from the perspective of it being called from
> >> secondary_entry, where all the functions use x0 as a scratch register. But it's
> >> still called from start, where using x4 as a scratch register is preferred because
> >> of the kernel boot protocol (x0-x3 are reserved).
> >>
> >> Is there an actual bug that this is supposed to fix (I looked for it and couldn't
> >> figure it out) or is it just a cosmetic change?
> > Now that exceptions_init isn't a private function of start (actually it
> > hasn't been in a long time, considering secondary_entry calls it) I would
> > like it to better conform to calling conventions. I guess I should have
> > used x19 here instead of x4 to be 100% correct. Or, would you rather I
> > just continue using x4 in exceptions_init in order to avoid the
> > save/restore?
> 
> To be honest, for this patch, I think it would be best to leave exceptions_init
> unchanged:
> 
> - We switch to using x0 like the rest of the code from secondary_entry, but
> because of that we need to save and restore the DTB address from x0 in start, so I
> don't think we've gained anything.
> - It makes the diff larger.
> - It runs the risk of introducing regressions (like all changes).
> 
> Maybe this can be left for a separate patch that changes code called from C to
> follow aapcs64.
>

OK, I'll switch it back to x4 and add a comment.

Thanks,
drew

