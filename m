Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB0D32D1EC
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 12:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239778AbhCDLkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 06:40:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238941AbhCDLjd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 06:39:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614857887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ilLaffriMNXC11Xr0GqKWVZ28m8dE31OI/fbmpwABXc=;
        b=ZvX5COnGGX16nXHukVMucDUXotrMBCbUyY/El2QLq2VgENJN0HLLjy4rIAL4Zl+PSaijRv
        ALxXdtSf0E8S7my2d6yaarX5Oy350L9FHGmzqAj2k5L+xzLG+/QW5W4M6n1LLnR4sMihTB
        S4SL551ur+fazC/X23232zNBFiG4xyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-R8HmeazoOqSv_wwKb1cHzA-1; Thu, 04 Mar 2021 06:38:03 -0500
X-MC-Unique: R8HmeazoOqSv_wwKb1cHzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C3DD57;
        Thu,  4 Mar 2021 11:38:02 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-31.ams2.redhat.com [10.36.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0BEC1962E;
        Thu,  4 Mar 2021 11:37:57 +0000 (UTC)
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210222085756.14396-1-frankja@linux.ibm.com>
 <20210222085756.14396-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/7] s390x: Fully commit to stack save
 area for exceptions
Message-ID: <b1ecb478-e559-bb3d-b69f-3f2b4f72ddee@redhat.com>
Date:   Thu, 4 Mar 2021 12:37:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222085756.14396-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2021 09.57, Janosch Frank wrote:
> Having two sets of macros for saving registers on exceptions makes
> maintaining harder. Also we have limited space in the lowcore to save
> stuff and by using the stack as a save area, we can stack exceptions.
> 
> So let's use the SAVE/RESTORE_REGS_STACK as the default. When we also
> move the diag308 macro over we can remove the old SAVE/RESTORE_REGS
> macros.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
[...]
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 1a2e2cd8..31e4766d 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -14,8 +14,8 @@
>   #define EXT_IRQ_SERVICE_SIG	0x2401
>   
>   void register_pgm_cleanup_func(void (*f)(void));
> -void handle_pgm_int(void);
> -void handle_ext_int(void);
> +void handle_pgm_int(struct stack_frame_int *stack);
> +void handle_ext_int(struct stack_frame_int *stack);
>   void handle_mcck_int(void);
>   void handle_io_int(void);

So handle_io_int() does not get a *stack parameter here...

>   void handle_svc_int(void);
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 1ce36073..a59df80e 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -56,7 +56,7 @@ void register_pgm_cleanup_func(void (*f)(void))
>   	pgm_cleanup_func = f;
>   }
>   
> -static void fixup_pgm_int(void)
> +static void fixup_pgm_int(struct stack_frame_int *stack)
>   {
>   	/* If we have an error on SIE we directly move to sie_exit */
>   	if (lc->pgm_old_psw.addr >= (uint64_t)&sie_entry &&
> @@ -76,7 +76,7 @@ static void fixup_pgm_int(void)
>   		/* Handling for iep.c test case. */
>   		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
>   		    !(lc->trans_exc_id & 0x08UL))
> -			lc->pgm_old_psw.addr = lc->sw_int_grs[14];
> +			lc->pgm_old_psw.addr = stack->grs0[12];

I'd maybe put a "/* GR14 */" comment at the end of the line, to make it more 
obvious which register we're aiming here at.

>   		break;
>   	case PGM_INT_CODE_SEGMENT_TRANSLATION:
>   	case PGM_INT_CODE_PAGE_TRANSLATION:
> @@ -115,7 +115,7 @@ static void fixup_pgm_int(void)
>   	/* suppressed/terminated/completed point already at the next address */
>   }
>   
> -void handle_pgm_int(void)
> +void handle_pgm_int(struct stack_frame_int *stack)
>   {
>   	if (!pgm_int_expected) {
>   		/* Force sclp_busy to false, otherwise we will loop forever */
> @@ -130,10 +130,10 @@ void handle_pgm_int(void)
>   	if (pgm_cleanup_func)
>   		(*pgm_cleanup_func)();
>   	else
> -		fixup_pgm_int();
> +		fixup_pgm_int(stack);
>   }
>   
> -void handle_ext_int(void)
> +void handle_ext_int(struct stack_frame_int *stack)
>   {
>   	if (!ext_int_expected &&
>   	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
> @@ -143,13 +143,13 @@ void handle_ext_int(void)
>   	}
>   
>   	if (lc->ext_int_code == EXT_IRQ_SERVICE_SIG) {
> -		lc->sw_int_crs[0] &= ~(1UL << 9);
> +		stack->crs[0] &= ~(1UL << 9);
>   		sclp_handle_ext();
>   	} else {
>   		ext_int_expected = false;
>   	}
>   
> -	if (!(lc->sw_int_crs[0] & CR0_EXTM_MASK))
> +	if (!(stack->crs[0] & CR0_EXTM_MASK))
>   		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
>   }
>   
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index ace0c0d9..35d20293 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -92,33 +92,36 @@ memsetxc:
>   
>   .section .text
>   pgm_int:
> -	SAVE_REGS
> +	SAVE_REGS_STACK
> +	lgr     %r2, %r15
>   	brasl	%r14, handle_pgm_int
> -	RESTORE_REGS
> +	RESTORE_REGS_STACK
>   	lpswe	GEN_LC_PGM_OLD_PSW
>   
>   ext_int:
> -	SAVE_REGS
> +	SAVE_REGS_STACK
> +	lgr     %r2, %r15
>   	brasl	%r14, handle_ext_int
> -	RESTORE_REGS
> +	RESTORE_REGS_STACK
>   	lpswe	GEN_LC_EXT_OLD_PSW
>   
>   mcck_int:
> -	SAVE_REGS
> +	SAVE_REGS_STACK
>   	brasl	%r14, handle_mcck_int
> -	RESTORE_REGS
> +	RESTORE_REGS_STACK
>   	lpswe	GEN_LC_MCCK_OLD_PSW
>   
>   io_int:
>   	SAVE_REGS_STACK
> +	lgr     %r2, %r15

... and here you're passing the stack pointer as a parameter, though 
handle_io_int() does not use it... well, ok, it gets reworked again in the 
next patch, but maybe you could still remove the above line when picking up 
the patch?

Anyway:
Acked-by: Thomas Huth <thuth@redhat.com>

