Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF11931DDB3
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbhBQQwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:52:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233694AbhBQQw2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 11:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613580662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4yr23+5m8x5zB27/gTLXl1w4PAs5mRGVC64CTwqvH5Q=;
        b=YBDG26WNCePwz0dCuMrnsGHKXQJ3ZeHl5vXdZdjBvCF6U7GhDb0lRcRQmB8DLAmCzA3lyS
        kdAMDR5TKqLsFMwI99z9ES4Vh8wZ/cE5Jh4efwCYIp5Bi3rzaytHwv664wUmDu6FsnqfOF
        5Kbsl+qdLqRk+Jejp5YWpvnfB53lVVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-FwF0EOk9PWi6i2GXyWPQtQ-1; Wed, 17 Feb 2021 11:50:58 -0500
X-MC-Unique: FwF0EOk9PWi6i2GXyWPQtQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA5CD874983;
        Wed, 17 Feb 2021 16:50:56 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-116.ams2.redhat.com [10.36.112.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D30760C6D;
        Wed, 17 Feb 2021 16:50:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 8/8] s390x: Remove SAVE/RESTORE_stack
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-9-frankja@linux.ibm.com>
 <4fd224a2-1c4d-1663-6615-685eadcf81f6@redhat.com>
 <bd386faf-c635-970a-6be8-659f5f6b4ba8@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <12198726-590c-7ac8-2b89-115d658ad367@redhat.com>
Date:   Wed, 17 Feb 2021 17:50:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <bd386faf-c635-970a-6be8-659f5f6b4ba8@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/2021 17.46, Janosch Frank wrote:
> On 2/17/21 5:18 PM, Thomas Huth wrote:
>> On 17/02/2021 15.41, Janosch Frank wrote:
>>> There are no more users.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    s390x/macros.S | 29 -----------------------------
>>>    1 file changed, 29 deletions(-)
>>>
>>> diff --git a/s390x/macros.S b/s390x/macros.S
>>> index 212a3823..399a87c6 100644
>>> --- a/s390x/macros.S
>>> +++ b/s390x/macros.S
>>> @@ -28,35 +28,6 @@
>>>    	lpswe	\old_psw
>>>    	.endm
>>>    
>>> -	.macro SAVE_REGS
>>> -	/* save grs 0-15 */
>>> -	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
>>> -	/* save crs 0-15 */
>>> -	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
>>> -	/* load a cr0 that has the AFP control bit which enables all FPRs */
>>> -	larl	%r1, initial_cr0
>>> -	lctlg	%c0, %c0, 0(%r1)
>>> -	/* save fprs 0-15 + fpc */
>>> -	la	%r1, GEN_LC_SW_INT_FPRS
>>> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>>> -	std	\i, \i * 8(%r1)
>>> -	.endr
>>> -	stfpc	GEN_LC_SW_INT_FPC
>>> -	.endm
>>> -
>>> -	.macro RESTORE_REGS
>>> -	/* restore fprs 0-15 + fpc */
>>> -	la	%r1, GEN_LC_SW_INT_FPRS
>>> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>>> -	ld	\i, \i * 8(%r1)
>>> -	.endr
>>> -	lfpc	GEN_LC_SW_INT_FPC
>>
>> Could we now also remove the sw_int_fprs and sw_int_fpc from the lowcore?
>>
>>    Thomas
>>
> 
> git grep tells me that we can.
> Do you want to have both the offset macro and the struct member removed
> or only the macro?

I'd remove both.

  Thomas

