Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970FB1FB5CB
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 17:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgFPPOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 11:14:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727006AbgFPPOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 11:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592320459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=N4DqM6R4Z12SHiksYK4U2MNmd4IxYiT0/TCjo80uvTY=;
        b=Kk/LIwMk3fnzwxrV8NI2rVFMLK69O9Xjji1u31ncXb5HQZRtVRIGANCbrHDv1PyLJlUmBZ
        gDoKrYWXUewVKiWZCpWkXQwgs2JE3KTdOG05liv3vblvuer2FSYS27s+MGxUjLmjeoYu2/
        vT9VaBQxjASwFjVjZXnl7gpPc/nwWTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-pUOAG87EMLieA5C2qSS2DA-1; Tue, 16 Jun 2020 11:14:18 -0400
X-MC-Unique: pUOAG87EMLieA5C2qSS2DA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12763EC1A2;
        Tue, 16 Jun 2020 15:14:17 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 117587CCE7;
        Tue, 16 Jun 2020 15:14:03 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v9 01/12] s390x: Use PSW bits definitions
 in cstart
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-2-git-send-email-pmorel@linux.ibm.com>
 <f160d328-694a-4476-4863-c49a1d0e5349@redhat.com>
 <13898aa9-800b-4de8-71b8-f64ee07fc793@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b2bffa74-ea11-c6f9-82fa-bb1ddfa4abfb@redhat.com>
Date:   Tue, 16 Jun 2020 17:14:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <13898aa9-800b-4de8-71b8-f64ee07fc793@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/2020 15.58, Pierre Morel wrote:
> 
> 
> On 2020-06-16 15:13, Thomas Huth wrote:
>> On 15/06/2020 11.31, Pierre Morel wrote:
>>> This patch defines the PSW bits EA/BA used to initialize the PSW masks
>>> for exceptions.
>>>
>>> Since some PSW mask definitions exist already in arch_def.h we add these
>>> definitions there.
>>> We move all PSW definitions together and protect assembler code against
>>> C syntax.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>   lib/s390x/asm/arch_def.h | 15 +++++++++++----
>>>   s390x/cstart64.S         | 15 ++++++++-------
>>>   2 files changed, 19 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>> index 1b3bb0c..b5d7aca 100644
>>> --- a/lib/s390x/asm/arch_def.h
>>> +++ b/lib/s390x/asm/arch_def.h
>>> @@ -10,15 +10,21 @@
>>>   #ifndef _ASM_S390X_ARCH_DEF_H_
>>>   #define _ASM_S390X_ARCH_DEF_H_
>>>   +#define PSW_MASK_EXT            0x0100000000000000UL
>>> +#define PSW_MASK_DAT            0x0400000000000000UL
>>> +#define PSW_MASK_SHORT_PSW        0x0008000000000000UL
>>> +#define PSW_MASK_PSTATE            0x0001000000000000UL
>>> +#define PSW_MASK_BA            0x0000000080000000UL
>>> +#define PSW_MASK_EA            0x0000000100000000UL
>>> +
>>> +#define PSW_MASK_ON_EXCEPTION    (PSW_MASK_EA | PSW_MASK_BA)
>>> +
>>> +#ifndef __ASSEMBLER__
>>>   struct psw {
>>>       uint64_t    mask;
>>>       uint64_t    addr;
>>>   };
>>>   -#define PSW_MASK_EXT            0x0100000000000000UL
>>> -#define PSW_MASK_DAT            0x0400000000000000UL
>>> -#define PSW_MASK_PSTATE            0x0001000000000000UL
>>> -
>>>   #define CR0_EXTM_SCLP            0x0000000000000200UL
>>>   #define CR0_EXTM_EXTC            0x0000000000002000UL
>>>   #define CR0_EXTM_EMGC            0x0000000000004000UL
>>> @@ -297,4 +303,5 @@ static inline uint32_t get_prefix(void)
>>>       return current_prefix;
>>>   }
>>>   +#endif /* __ASSEMBLER */
>>>   #endif
>>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>>> index e084f13..d386f35 100644
>>> --- a/s390x/cstart64.S
>>> +++ b/s390x/cstart64.S
>>> @@ -12,6 +12,7 @@
>>>    */
>>>   #include <asm/asm-offsets.h>
>>>   #include <asm/sigp.h>
>>> +#include <asm/arch_def.h>
>>>     .section .init
>>>   @@ -198,19 +199,19 @@ svc_int:
>>>         .align    8
>>>   reset_psw:
>>> -    .quad    0x0008000180000000
>>> +    .quad    PSW_MASK_ON_EXCEPTION | PSW_MASK_SHORT_PSW
>>>   initial_psw:
>>> -    .quad    0x0000000180000000, clear_bss_start
>>> +    .quad    PSW_MASK_ON_EXCEPTION, clear_bss_start
>>>   pgm_int_psw:
>>> -    .quad    0x0000000180000000, pgm_int
>>> +    .quad    PSW_MASK_ON_EXCEPTION, pgm_int
>>>   ext_int_psw:
>>> -    .quad    0x0000000180000000, ext_int
>>> +    .quad    PSW_MASK_ON_EXCEPTION, ext_int
>>>   mcck_int_psw:
>>> -    .quad    0x0000000180000000, mcck_int
>>> +    .quad    PSW_MASK_ON_EXCEPTION, mcck_int
>>>   io_int_psw:
>>> -    .quad    0x0000000180000000, io_int
>>> +    .quad    PSW_MASK_ON_EXCEPTION, io_int
>>>   svc_int_psw:
>>> -    .quad    0x0000000180000000, svc_int
>>> +    .quad    PSW_MASK_ON_EXCEPTION, svc_int
>>>   initial_cr0:
>>>       /* enable AFP-register control, so FP regs (+BFP instr) can be
>>> used */
>>>       .quad    0x0000000000040000
>>>
>>
>> I'm afraid, by when I compile this on RHEL7, the toolchain complains:
> 
> I will try to figure out why.
> which version are you using? and which compiler?

$ as --version
GNU assembler version 2.27-43.base.el7
$ gcc --version
gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-39)

I think the problem are the "UL" suffixes ... IIRC they are only
supported by newer versions of the binutils.

 Thomas

