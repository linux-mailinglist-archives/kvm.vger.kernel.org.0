Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABB131DCC8
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhBQP4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 10:56:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233891AbhBQP4u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 10:56:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613577324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YS3nxZW1QzFmYQoRE9ZNNk1HsBK/ykLDpT4WFPyqals=;
        b=Rz5mThWHUAKDa6554xLfbjwH72+73JQ0G+kjPq1VBK2jyFEBIo989vR3VYSs9HZ7rRWqFl
        l+LHNjbcLxMkMpo5pRcfFcMWhpmPh0WkCcYOrgkZmaKSG+xqXjpcOsHa3RBs4YgR9soQRC
        OCs2DGzgrOlZC/FXLJafvKEgRqkyvf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-hhIhBlgvO-aonsf_87Fx5Q-1; Wed, 17 Feb 2021 10:55:20 -0500
X-MC-Unique: hhIhBlgvO-aonsf_87Fx5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2408192CC46;
        Wed, 17 Feb 2021 15:55:19 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-116.ams2.redhat.com [10.36.112.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20B885C67A;
        Wed, 17 Feb 2021 15:55:13 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x: Introduce and use
 CALL_INT_HANDLER macro
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <313546fb-35df-22ab-79f8-d5b49286058f@redhat.com>
Date:   Wed, 17 Feb 2021 16:55:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210217144116.3368-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/2021 15.41, Janosch Frank wrote:
> The ELF ABI dictates that we need to allocate 160 bytes of stack space
> for the C functions we're calling. Since we would need to do that for
> every interruption handler which, combined with the new stack argument
> being saved in GR2, makes cstart64.S look a bit messy.
> 
> So let's introduce the CALL_INT_HANDLER macro that handles all of
> that, calls the C interrupt handler and handles cleanup afterwards.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/cstart64.S | 28 +++++-----------------------
>   s390x/macros.S   | 17 +++++++++++++++++
>   2 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 35d20293..666a9567 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -92,37 +92,19 @@ memsetxc:
>   
>   .section .text
>   pgm_int:
> -	SAVE_REGS_STACK
> -	lgr     %r2, %r15
> -	brasl	%r14, handle_pgm_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_PGM_OLD_PSW
> +	CALL_INT_HANDLER handle_pgm_int, GEN_LC_PGM_OLD_PSW
>   
>   ext_int:
> -	SAVE_REGS_STACK
> -	lgr     %r2, %r15
> -	brasl	%r14, handle_ext_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_EXT_OLD_PSW
> +	CALL_INT_HANDLER handle_ext_int, GEN_LC_EXT_OLD_PSW
>   
>   mcck_int:
> -	SAVE_REGS_STACK
> -	brasl	%r14, handle_mcck_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_MCCK_OLD_PSW
> +	CALL_INT_HANDLER handle_mcck_int, GEN_LC_MCCK_OLD_PSW
>   
>   io_int:
> -	SAVE_REGS_STACK
> -	lgr     %r2, %r15
> -	brasl	%r14, handle_io_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_IO_OLD_PSW
> +	CALL_INT_HANDLER handle_io_int, GEN_LC_IO_OLD_PSW
>   
>   svc_int:
> -	SAVE_REGS_STACK
> -	brasl	%r14, handle_svc_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_SVC_OLD_PSW
> +	CALL_INT_HANDLER handle_svc_int, GEN_LC_SVC_OLD_PSW
>   
>   	.align	8
>   initial_psw:
> diff --git a/s390x/macros.S b/s390x/macros.S
> index a7d62c6f..212a3823 100644
> --- a/s390x/macros.S
> +++ b/s390x/macros.S
> @@ -11,6 +11,23 @@
>    *  David Hildenbrand <david@redhat.com>
>    */
>   #include <asm/asm-offsets.h>
> +/*
> + * Exception handler macro that saves registers on the stack,
> + * allocates stack space and calls the C handler function. Afterwards
> + * we re-load the registers and load the old PSW.
> + */
> +	.macro CALL_INT_HANDLER c_func, old_psw
> +	SAVE_REGS_STACK
> +	/* Save the stack address in GR2 which is the first function argument */
> +	lgr     %r2, %r15
> +	/* Allocate stack pace for called C function, as specified in s390 ELF ABI */
> +	slgfi   %r15, 160

By the way, don't you have to store a back chain pointer at the bottom of 
that area, too, if you want to use -mbackchoin in the next patch?

  Thomas


> +	brasl	%r14, \c_func
> +	algfi   %r15, 160
> +	RESTORE_REGS_STACK
> +	lpswe	\old_psw
> +	.endm
> +
>   	.macro SAVE_REGS
>   	/* save grs 0-15 */
>   	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
> 

