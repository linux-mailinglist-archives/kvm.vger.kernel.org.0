Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9319D345CDB
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 12:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhCWL3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 07:29:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229504AbhCWL3c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 07:29:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616498971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zqLkbfLgJqD/s1fzPitvnEHbO/z5dT0Iej1bSOuam8I=;
        b=VogG6t1+WPSRDLb873om6yRFzG4Bzaso/0BP+zzW/+mxrl3o8lX9AmIzh9VR8VqflITGNl
        5tyyfqLvRR79BvtoBnKrKZzZ4HdpzRDzTZ4URSew7TqtpxiT4pRsxNGWjCuVlJXq+5uAZV
        CBLzSy6xmLqiZkfA1a4udmaeEk1/zhQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-UkAcbVn2MK-g0KeyvElj3A-1; Tue, 23 Mar 2021 07:29:29 -0400
X-MC-Unique: UkAcbVn2MK-g0KeyvElj3A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 647CE1083E82;
        Tue, 23 Mar 2021 11:29:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 51B001001B2C;
        Tue, 23 Mar 2021 11:29:27 +0000 (UTC)
Date:   Tue, 23 Mar 2021 12:29:23 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [PATCH kvm-unit-tests v2] arm/arm64: Zero BSS and stack at
 startup
Message-ID: <20210323112923.37h2ctwebmx4lo45@kamzik.brq.redhat.com>
References: <20210322162721.108514-1-drjones@redhat.com>
 <ac1705ed-904b-6b99-4357-6b8cedd66bb2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac1705ed-904b-6b99-4357-6b8cedd66bb2@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 11:09:27AM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 3/22/21 4:27 PM, Andrew Jones wrote:
> > So far we've counted on QEMU or kvmtool implicitly zeroing all memory.
> > With our goal of eventually supporting bare-metal targets with
> > target-efi we should explicitly zero any memory we expect to be zeroed
> > ourselves. This obviously includes the BSS, but also the bootcpu's
> > stack, as the bootcpu's thread-info lives in the stack and may get
> > used in early setup to get the cpu index. Note, this means we still
> > assume the bootcpu's cpu index to be zero. That assumption can be
> > removed later.
> >
> > Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arm/cstart.S   | 20 ++++++++++++++++++++
> >  arm/cstart64.S | 22 +++++++++++++++++++++-
> >  arm/flat.lds   |  4 ++++
> >  3 files changed, 45 insertions(+), 1 deletion(-)
> >
> > diff --git a/arm/cstart.S b/arm/cstart.S
> > index ef936ae2f874..9eb11ba4dcaf 100644
> > --- a/arm/cstart.S
> > +++ b/arm/cstart.S
> > @@ -15,12 +15,32 @@
> >  
> >  #define THREAD_START_SP ((THREAD_SIZE - S_FRAME_SIZE * 8) & ~7)
> >  
> > +.macro zero_range, tmp1, tmp2, tmp3, tmp4
> 
> tmp1 and tmp2 could be renamed to start and end (same for arm64), but the macro is
> nice and simple, and it's also pretty clear what the arguments represent from the
> call sites. Looks good either way:

I considered tmp1 and tmp2 being start and end, but start gets used like
a temporary anyway.

> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

> 
> Thanks,
> 
> Alex
> 
> > +	mov	\tmp3, #0
> > +	mov	\tmp4, #0
> > +9998:	cmp	\tmp1, \tmp2
> > +	beq	9997f
> > +	strd	\tmp3, \tmp4, [\tmp1], #8
> > +	b	9998b
> > +9997:
> > +.endm
> > +
> >  .arm
> >  
> >  .section .init
> >  
> >  .globl start
> >  start:
> > +	/* zero BSS */
> > +	ldr	r4, =bss
> > +	ldr	r5, =ebss
> > +	zero_range r4, r5, r6, r7
> > +
> > +	/* zero stack */
> > +	ldr	r5, =stacktop
> > +	sub	r4, r5, #THREAD_SIZE
> > +	zero_range r4, r5, r6, r7
> > +
> >  	/*
> >  	 * set stack, making room at top of stack for cpu0's
> >  	 * exception stacks. Must start wtih stackptr, not
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index 0428014aa58a..2a691f8f5065 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -12,6 +12,15 @@
> >  #include <asm/processor.h>
> >  #include <asm/page.h>
> >  #include <asm/pgtable-hwdef.h>
> > +#include <asm/thread_info.h>
> > +
> > +.macro zero_range, tmp1, tmp2
> > +9998:	cmp	\tmp1, \tmp2
> > +	b.eq	9997f
> > +	stp	xzr, xzr, [\tmp1], #16
> > +	b	9998b
> > +9997:
> > +.endm
> >  
> >  .section .init
> >  
> > @@ -51,7 +60,18 @@ start:
> >  	b	1b
> >  
> >  1:
> > -	/* set up stack */
> > +	/* zero BSS */
> > +	adrp	x4, bss
> > +	add	x4, x4, :lo12:bss
> > +	adrp    x5, ebss
> > +	add     x5, x5, :lo12:ebss
> > +	zero_range x4, x5
> > +
> > +	/* zero and set up stack */
> > +	adrp    x5, stacktop
> > +	add     x5, x5, :lo12:stacktop
> > +	sub	x4, x5, #THREAD_SIZE
> > +	zero_range x4, x5
> >  	mov	x4, #1
> >  	msr	spsel, x4
> >  	isb
> > diff --git a/arm/flat.lds b/arm/flat.lds
> > index 25f8d03cba87..4d43cdfeab41 100644
> > --- a/arm/flat.lds
> > +++ b/arm/flat.lds
> > @@ -17,7 +17,11 @@ SECTIONS
> >  
> >      .rodata   : { *(.rodata*) }
> >      .data     : { *(.data) }
> > +    . = ALIGN(16);
> > +    PROVIDE(bss = .);
> >      .bss      : { *(.bss) }
> > +    . = ALIGN(16);
> > +    PROVIDE(ebss = .);
> >      . = ALIGN(64K);
> >      PROVIDE(edata = .);
> >  
> 

