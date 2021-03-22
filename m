Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF5A3449FE
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCVP7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:59:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230196AbhCVP6q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 11:58:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616428724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DeaBrRr4NgPMGFFsVocBf/o3zzh8roz3RW/ouXbCm7M=;
        b=Pe8l/liwXDNAWmZ0h9qclubs2LWwtoMt+BYRt0PqhrcGZG6dhizWTQCro2LYTWmd8WkVOG
        RRbPIBw6EH0X20iPh9n1ViM2ObY3krlGm8DLsqf5h4liBZQDRLZbxLyWWUV2XTjTF0AxzR
        M+YuUC15GaTR79QpwJHwXA9iKL+4FOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-ikFcBgIPMG6CK5fKmHfU9Q-1; Mon, 22 Mar 2021 11:58:41 -0400
X-MC-Unique: ikFcBgIPMG6CK5fKmHfU9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76AC58C7246;
        Mon, 22 Mar 2021 15:58:25 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46F085D769;
        Mon, 22 Mar 2021 15:58:23 +0000 (UTC)
Date:   Mon, 22 Mar 2021 16:58:21 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [PATCH kvm-unit-tests] arm/arm64: Zero BSS and stack at startup
Message-ID: <20210322155821.sru7urrxki47rm6p@kamzik.brq.redhat.com>
References: <20210322121058.62072-1-drjones@redhat.com>
 <38a908f6-1c7c-ee10-08ac-7204db2b54fc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38a908f6-1c7c-ee10-08ac-7204db2b54fc@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 03:52:13PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 3/22/21 12:10 PM, Andrew Jones wrote:
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
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arm/cstart.S   | 22 ++++++++++++++++++++++
> >  arm/cstart64.S | 23 ++++++++++++++++++++++-
> >  arm/flat.lds   |  6 ++++++
> >  3 files changed, 50 insertions(+), 1 deletion(-)
> >
> > diff --git a/arm/cstart.S b/arm/cstart.S
> > index ef936ae2f874..6de461ef94bf 100644
> > --- a/arm/cstart.S
> > +++ b/arm/cstart.S
> > @@ -15,12 +15,34 @@
> >  
> >  #define THREAD_START_SP ((THREAD_SIZE - S_FRAME_SIZE * 8) & ~7)
> >  
> > +.macro zero_range, tmp1, tmp2, tmp3, tmp4
> > +	mov	\tmp3, #0
> > +	mov	\tmp4, #0
> > +9998:	cmp	\tmp1, \tmp2
> > +	beq	9997f
> > +	strd	\tmp3, \tmp4, [\tmp1]
> > +	add	\tmp1, \tmp1, #8
> 
> This could use post-indexed addressing and the add instruction could be removed.
> Same for arm64.
> 
> > +	b	9998b
> > +9997:
> > +.endm
> > +
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
> > +	ldr	r4, =stackbase
> > +	ldr	r5, =stacktop
> > +	zero_range r4, r5, r6, r7
> > +
> >  	/*
> >  	 * set stack, making room at top of stack for cpu0's
> >  	 * exception stacks. Must start wtih stackptr, not
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index 0428014aa58a..4dc5989ef50c 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -13,6 +13,15 @@
> >  #include <asm/page.h>
> >  #include <asm/pgtable-hwdef.h>
> >  
> > +.macro zero_range, tmp1, tmp2
> > +9998:	cmp	\tmp1, \tmp2
> > +	b.eq	9997f
> > +	stp	xzr, xzr, [\tmp1]
> > +	add	\tmp1, \tmp1, #16
> > +	b	9998b
> > +9997:
> > +.endm
> > +
> >  .section .init
> >  
> >  /*
> > @@ -51,7 +60,19 @@ start:
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
> > +	adrp	x4, stackbase
> > +	add	x4, x4, :lo12:stackbase
> > +	adrp    x5, stacktop
> > +	add     x5, x5, :lo12:stacktop
> > +	zero_range x4, x5
> >  	mov	x4, #1
> >  	msr	spsel, x4
> >  	isb
> > diff --git a/arm/flat.lds b/arm/flat.lds
> > index 25f8d03cba87..8eab3472e2f2 100644
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
> > @@ -26,6 +30,8 @@ SECTIONS
> >       * sp must be 16 byte aligned for arm64, and 8 byte aligned for arm
> >       * sp must always be strictly less than the true stacktop
> >       */
> > +    . = ALIGN(16);
> > +    PROVIDE(stackbase = .);
> 
> This is correct, but strictly speaking, current_thread_info() accesses stacktop -
> THREAD_SIZE, which is at most 64k. Is it worth declaring it after we add 644 and
> we align it, something like this:
> 
> PROVIDE(stackbase = . - 64K)
> 
> Or maybe we shouldn't even create a variable for the base of the stack, and
> compute it in cstart{,64}.S as stacktop - THREAD_SIZE? That could make the boot
> process a tiny bit faster in some cases.

Good idea. I will take both your suggestions and send a v2.

Thanks,
drew

