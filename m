Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAA51F1C19
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 17:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgFHP3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 11:29:32 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55335 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730293AbgFHP3a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 11:29:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591630168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=kjRoeZH0NyZtD89PVFlfF+OQXo1xpOAcyCbdy4We0xA=;
        b=V4G3gL0EooORu4Vwp83IJhBCaPN999ScZZT/tbqprdXC+9BaawmQ/0SH+/VR/ggyQFwnKQ
        s9MN0nogDNemYRQmmqPYDFKmgzVYTdTMnRmWfpvtz6VhIgYjEAJzU+DiRo/vG9nfYfEJzg
        tXG7M3t50EAiaAVR3fNyBb5JeAvrSuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-oEOsEq0DMz-8-pyLYpiodw-1; Mon, 08 Jun 2020 11:29:25 -0400
X-MC-Unique: oEOsEq0DMz-8-pyLYpiodw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C599B461;
        Mon,  8 Jun 2020 15:29:23 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-119.ams2.redhat.com [10.36.112.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A92C161981;
        Mon,  8 Jun 2020 15:29:19 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 03/12] s390x: saving regs for interrupts
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-4-git-send-email-pmorel@linux.ibm.com>
 <d4f1167c-5e44-f69c-8aac-f792a2a50ca7@redhat.com>
 <cde77b21-7fbb-bd09-bd3d-f77c5bd2a088@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dc936814-13b3-c310-f0b1-1bec47c042b2@redhat.com>
Date:   Mon, 8 Jun 2020 17:29:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <cde77b21-7fbb-bd09-bd3d-f77c5bd2a088@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 16.24, Pierre Morel wrote:
> 
> 
> On 2020-06-08 11:05, Thomas Huth wrote:
>> On 08/06/2020 10.12, Pierre Morel wrote:
>>> If we use multiple source of interrupts, for example, using SCLP
>>> console to print information while using I/O interrupts, we need
>>> to have a re-entrant register saving interruption handling.
>>>
>>> Instead of saving at a static memory address, let's save the base
>>> registers, the floating point registers and the floating point
>>> control register on the stack in case of I/O interrupts
>>>
>>> Note that we keep the static register saving to recover from the
>>> RESET tests.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>   s390x/cstart64.S | 41 +++++++++++++++++++++++++++++++++++++++--
>>>   1 file changed, 39 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>>> index b50c42c..a9d8223 100644
>>> --- a/s390x/cstart64.S
>>> +++ b/s390x/cstart64.S
>>> @@ -119,6 +119,43 @@ memsetxc:
>>>       lmg    %r0, %r15, GEN_LC_SW_INT_GRS
>>>       .endm
>>>   +/* Save registers on the stack (r15), so we can have stacked
>>> interrupts. */
>>> +    .macro SAVE_REGS_STACK
>>> +    /* Allocate a stack frame for 15 general registers */
>>> +    slgfi   %r15, 15 * 8
>>> +    /* Store registers r0 to r14 on the stack */
>>> +    stmg    %r0, %r14, 0(%r15)
>>> +    /* Allocate a stack frame for 16 floating point registers */
>>> +    /* The size of a FP register is the size of an double word */
>>> +    slgfi   %r15, 16 * 8
>>> +    /* Save fp register on stack: offset to SP is multiple of reg
>>> number */
>>> +    .irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>>> +    std    \i, \i * 8(%r15)
>>> +    .endr
>>> +    /* Save fpc, but keep stack aligned on 64bits */
>>> +    slgfi   %r15, 8
>>> +    efpc    %r0
>>> +    stg    %r0, 0(%r15)
>>> +    .endm
>>
>> I wonder whether it would be sufficient to only save the registers here
>> that are "volatile" according to the ELF ABI? ... that would save quite
>> some space on the stack, I think... OTOH, the old code was also saving
>> all registers, so maybe that's something for a separate patch later...
> 
> I don't think so for the general registers
> The "volatile" registers are lost during a C call, so it is the duty of
> the caller to save them before the call, if he wants, and this is
> possible for the programmer or the compiler to arrange that.
> 
> For interruptions, we steal the CPU with all the registers from the
> program without warning, the program has no possibility to save them.
> So we must save all registers for him.

We certainly have to save the registers that are marked as "volatile" in
the ELF ABI, no discussion. But what about the others? If we do not
touch them in the assembler code, and just jump to a C function, the C
function will save them before changing them, and restore the old value
before returning. So when the interrupt is done, the registers should
contain their original values again, shouldn't they?

> For the FP registers, we surely can do something if we establish a usage
> convention on the floating point.
> A few tests need hardware floating point.

According to the ELF ABI, f0 - f7 are volatile, so they must be saved,
but f8 - f15 should be saved by the called function instead, so I think
we don't need to save them here?

Anyway, as I said, that optimization could also be done in a future
patch instead.

 Thomas

