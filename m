Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701531F14F3
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 11:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgFHJFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 05:05:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31308 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726536AbgFHJFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 05:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591607142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=JU1hlejrOwg52H4lSP+m9jVC+ZPcWO4HkWue5ppPBAM=;
        b=MNPlepJg+vMBaU/eJ0uVvZg+9CtQAD9YR1imR45CNxvY7EsTgWgc7JEPAkW2SATenmjEmq
        t0E7ZwbwqjO2yH0AiKBe0i+CJ/hTiRY8ZTq86wiIPg+jkWKnSlEpYqtCvAVLIcpeJ+d4J9
        p2jzKGhfIbTTu2GFgbL4ntfU3cIgPU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-uwOGySdZP0CcNqcFBTXFTQ-1; Mon, 08 Jun 2020 05:05:40 -0400
X-MC-Unique: uwOGySdZP0CcNqcFBTXFTQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44C06461;
        Mon,  8 Jun 2020 09:05:39 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-119.ams2.redhat.com [10.36.112.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB46B79C40;
        Mon,  8 Jun 2020 09:05:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 03/12] s390x: saving regs for interrupts
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-4-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d4f1167c-5e44-f69c-8aac-f792a2a50ca7@redhat.com>
Date:   Mon, 8 Jun 2020 11:05:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1591603981-16879-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 10.12, Pierre Morel wrote:
> If we use multiple source of interrupts, for example, using SCLP
> console to print information while using I/O interrupts, we need
> to have a re-entrant register saving interruption handling.
> 
> Instead of saving at a static memory address, let's save the base
> registers, the floating point registers and the floating point
> control register on the stack in case of I/O interrupts
> 
> Note that we keep the static register saving to recover from the
> RESET tests.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/cstart64.S | 41 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index b50c42c..a9d8223 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -119,6 +119,43 @@ memsetxc:
>  	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
>  	.endm
>  
> +/* Save registers on the stack (r15), so we can have stacked interrupts. */
> +	.macro SAVE_REGS_STACK
> +	/* Allocate a stack frame for 15 general registers */
> +	slgfi   %r15, 15 * 8
> +	/* Store registers r0 to r14 on the stack */
> +	stmg    %r0, %r14, 0(%r15)
> +	/* Allocate a stack frame for 16 floating point registers */
> +	/* The size of a FP register is the size of an double word */
> +	slgfi   %r15, 16 * 8
> +	/* Save fp register on stack: offset to SP is multiple of reg number */
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	std	\i, \i * 8(%r15)
> +	.endr
> +	/* Save fpc, but keep stack aligned on 64bits */
> +	slgfi   %r15, 8
> +	efpc	%r0
> +	stg	%r0, 0(%r15)
> +	.endm

I wonder whether it would be sufficient to only save the registers here
that are "volatile" according to the ELF ABI? ... that would save quite
some space on the stack, I think... OTOH, the old code was also saving
all registers, so maybe that's something for a separate patch later...

Acked-by: Thomas Huth <thuth@redhat.com>

