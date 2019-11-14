Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBCEFC5F0
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 13:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfKNML3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 07:11:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47784 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726115AbfKNML3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 07:11:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573733487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CkAmeFD2bSz+5+8GO5qTPJM2kouoeEv6g8qbZ2yyRNM=;
        b=MEdOq8yRm0bykaROo5mJgQKaGlU8MYdBshQCQjxbF6g93bm8GKiP29anqU+yvW0e5h3NOh
        EMtmtkZgXhNNPJn5z10WjX2b/psL9YFfvEEK7oUh7hZ1+rXJRyV2m//K9WHXl/ViczZM+i
        dZSG5RDGcKWmeewyQL/oBhU2xXxlehA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-wx2SCypzNW6IiDLI7BSdZA-1; Thu, 14 Nov 2019 07:11:21 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 720CB8C61DE;
        Thu, 14 Nov 2019 12:11:20 +0000 (UTC)
Received: from [10.36.117.13] (ovpn-117-13.ams2.redhat.com [10.36.117.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 330F044F93;
        Thu, 14 Nov 2019 12:11:18 +0000 (UTC)
Subject: Re: [PATCH v1 1/4] s390x: saving regs for interrupts
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com
References: <c7d6c21e-3746-b31a-aff9-d19549feb24c@linux.ibm.com>
 <CD5636A0-3C33-4DC4-9217-68A00137E3F4@redhat.com>
 <ef5cc0aa-d1fe-874f-8f61-863c793a23d4@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <b88be625-26b1-9780-fde4-000e3065bdaf@redhat.com>
Date:   Thu, 14 Nov 2019 13:11:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <ef5cc0aa-d1fe-874f-8f61-863c793a23d4@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: wx2SCypzNW6IiDLI7BSdZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.11.19 12:57, Pierre Morel wrote:
>=20
> On 2019-11-14 11:28, David Hildenbrand wrote:
>>
>>> Am 14.11.2019 um 11:11 schrieb Pierre Morel <pmorel@linux.ibm.com>:
>>>
>>> =EF=BB=BF
>>>> On 2019-11-13 17:12, Janosch Frank wrote:
>>>>> On 11/13/19 1:23 PM, Pierre Morel wrote:
>>>>> If we use multiple source of interrupts, for exemple, using SCLP cons=
ole
>>>>> to print information while using I/O interrupts or during exceptions,=
 we
>>>>> need to have a re-entrant register saving interruption handling.
>>>>>
>>>>> Instead of saving at a static place, let's save the base registers on
>>>>> the stack.
>>>>>
>>>>> Note that we keep the static register saving that we need for the RES=
ET
>>>>> tests.
>>>>>
>>>>> We also care to give the handlers a pointer to the save registers in
>>>>> case the handler needs it (fixup_pgm_int needs the old psw address).
>>>> So you're still ignoring the FPRs...
>>>> I disassembled a test and looked at all stds and it looks like printf
>>>> and related functions use them. Wouldn't we overwrite test FPRs if
>>>> printing in a handler?
>>> If printf uses the FPRs in my opinion we should modify the compilation =
options for the library.
>>>
>>> What is the reason for printf and related functions to use floating poi=
nt?
>>>
>> Register spilling. This can and will be done.
>=20
>=20
> Hum, can you please clarify?
>=20
> AFAIK register spilling is for a compiler, to use memory if it has not
> enough registers.

Not strictly memory. If the compiler needs more GPRS, it can=20
save/restore GPRS to FPRS.

Any function the compiler generates is free to use the FPRS..

>=20
> So your answer is for the my first sentence, meaning yes register
> spilling will be done
> or
> do you mean register spilling is the reason why the compiler use FPRs
> and it must be done so?

Confused by both options :D The compiler might generate code that uses=20
the FPRS although no floating point instructions are in use. That's why=20
we have to enable the AFP control and properly take care of FPRS being used=
.


--=20

Thanks,

David / dhildenb

