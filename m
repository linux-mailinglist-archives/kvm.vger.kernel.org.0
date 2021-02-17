Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B659A31DC71
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhBQPhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 10:37:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233799AbhBQPhb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 10:37:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613576163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4AoOAx0grFpmKh6AM9iw+rK1fYoTmC4anyAgsb7wUuA=;
        b=WOk/epJfU7HGPkq65G6K2uNRBtllgWfCAj3NfOQf6ALpAipsg9zWXFUKd33LnlT8cxf9Rm
        rONNjbbI6Wr/RKevPvDnLn73+NuxINbYvxKe2aQ6N9hzncr0ddUuWTKzNOZq6KHLMo+Tac
        klyiBZ5gNizoUq3ANtrNtIgsWLZrLYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-zkDoRg-tO7uqbtNNapzoiQ-1; Wed, 17 Feb 2021 10:36:01 -0500
X-MC-Unique: zkDoRg-tO7uqbtNNapzoiQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BDB7835E22;
        Wed, 17 Feb 2021 15:36:00 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-116.ams2.redhat.com [10.36.112.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C01FE1002391;
        Wed, 17 Feb 2021 15:35:55 +0000 (UTC)
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/8] s390x: Fully commit to stack save
 area for exceptions
Message-ID: <338944d9-9135-185e-829f-4f202b632a5b@redhat.com>
Date:   Wed, 17 Feb 2021 16:35:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210217144116.3368-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/2021 15.41, Janosch Frank wrote:
> Having two sets of macros for saving registers on exceptions makes
> maintaining harder. Also we have limited space in the lowcore to save
> stuff and by using the stack as a save area, we can stack exceptions.
> 
> So let's use the SAVE/RESTORE_REGS_STACK as the default. When we also
> move the diag308 macro over we can remove the old SAVE/RESTORE_REGS
> macros.
[...]
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 9c4e330a..31c2fc66 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -8,13 +8,30 @@
>   #ifndef _ASM_S390X_ARCH_DEF_H_
>   #define _ASM_S390X_ARCH_DEF_H_
>   
> -/*
> - * We currently only specify the stack frame members needed for the
> - * SIE library code.
> - */
>   struct stack_frame {
> -	unsigned long back_chain;
> -	unsigned long empty1[5];
> +	struct stack_frame *back_chain;
> +	u64 reserved;
> +	/* GRs 2 - 5 */
> +	unsigned long argument_area[4];
> +	/* GRs 6 - 15 */
> +	unsigned long grs[10];
> +	/* FPRs 0, 2, 4, 6 */
> +	s64  fprs[4];
> +};

For consistency, could you please replace the "unsigned long" with u64, or 
even switch to uint64_t completely?

Currently, we have:

$ grep -r u64 lib/s390x/ | wc -l
8
$ grep -r uint64 lib/s390x/ | wc -l
94

... so uint64_t seems to be the better choice.

> +struct stack_frame_int {
> +	struct stack_frame *back_chain;
> +	u64 reserved;
> +	/*
> +	 * The GRs are offset compatible with struct stack_frame so we
> +	 * can easily fetch GR14 for backtraces.
> +	 */
> +	u64 grs0[14];
> +	u64 grs1[2];

Which registers go into grs0 and which ones into grs1? And why is there a 
split at all? A comment would be really helpful!

> +	u32 res;

res = reserved? Please add a comment.

> +	u32 fpc;
> +	u64 fprs[16];
> +	u64 crs[16];
>   };

Similar, switch to uint32_t and uint64_t ?

> diff --git a/s390x/macros.S b/s390x/macros.S
> index e51a557a..d7eeeb55 100644
> --- a/s390x/macros.S
> +++ b/s390x/macros.S
> @@ -3,9 +3,10 @@
>    * s390x assembly macros
>    *
>    * Copyright (c) 2017 Red Hat Inc
> - * Copyright (c) 2020 IBM Corp.
> + * Copyright (c) 2020, 2021 IBM Corp.
>    *
>    * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
>    *  Pierre Morel <pmorel@linux.ibm.com>
>    *  David Hildenbrand <david@redhat.com>
>    */
> @@ -41,36 +42,45 @@
>   
>   /* Save registers on the stack (r15), so we can have stacked interrupts. */
>   	.macro SAVE_REGS_STACK
> -	/* Allocate a stack frame for 15 general registers */
> -	slgfi   %r15, 15 * 8
> +	/* Allocate a full stack frame */
> +	slgfi   %r15, 32 * 8 + 4 * 8

How did you come up with that number? That does neither match stack 
stack_frame nor stack_frame_int, if I got this right. Please add a comment 
to the code to explain the numbers.

>   	/* Store registers r0 to r14 on the stack */
> -	stmg    %r0, %r14, 0(%r15)
> -	/* Allocate a stack frame for 16 floating point registers */
> -	/* The size of a FP register is the size of an double word */
> -	slgfi   %r15, 16 * 8
> +	stmg    %r2, %r15, STACK_FRAME_INT_GRS0(%r15)

Storing up to r14 should be sufficent since you store r15 again below?

> +	stg     %r0, STACK_FRAME_INT_GRS1(%r15)
> +	stg     %r1, STACK_FRAME_INT_GRS1 + 8(%r15)
> +	/* Store the gr15 value before we allocated the new stack */
> +	lgr     %r0, %r15
> +	algfi   %r0, 32 * 8 + 4 * 8
> +	stg     %r0, 13 * 8 + STACK_FRAME_INT_GRS0(%r15)
> +	stg     %r0, STACK_FRAME_INT_BACKCHAIN(%r15)
> +	/*
> +	 * Store CR0 and load initial CR0 so AFP is active and we can
> +	 * access all fprs to save them.
> +	 */
> +	stctg   %c0,%c15,STACK_FRAME_INT_CRS(%r15)
> +	larl	%r1, initial_cr0
> +	lctlg	%c0, %c0, 0(%r1)
>   	/* Save fp register on stack: offset to SP is multiple of reg number */
>   	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> -	std	\i, \i * 8(%r15)
> +	std	\i, \i * 8 + STACK_FRAME_INT_FPRS(%r15)
>   	.endr

So you saved 16 GRs, 16 CRs and 16 FPRs onto the stack, that's at least 16 * 
3 * 8 = 48 * 8 bytes ... but you only decreased the stack by 32 * 8 + 4 * 8 
bytes initially ... is this a bug, or do I miss something?

  Thomas

