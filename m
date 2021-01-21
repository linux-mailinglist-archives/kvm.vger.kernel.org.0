Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69FF2FEC77
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAUN6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 08:58:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729520AbhAUNom (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 08:44:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611236595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgWTUsc6Y4j+5OX/erfqmVqVZMsiiZeWjI9vYvp4Dzc=;
        b=Dyulq8s775+emhw1fOfCEjP+zlb4Lt4eim1UymK68LeGNHFhjZkTFmemeQy9jgUnHEPzA6
        s9thzfK/jUbyks9JBFIhBzkCM4VHYQq4QO3hKUoM8fPcHBEb5FjRNaUDBlRHoZRxUdCXeR
        BRqX2SkIWf1E+zalOIMAeu7gIUYEEX0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-JT4l6LBJPrW8b3lRjWh3RQ-1; Thu, 21 Jan 2021 08:43:13 -0500
X-MC-Unique: JT4l6LBJPrW8b3lRjWh3RQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8784A10054FF;
        Thu, 21 Jan 2021 13:43:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-82.ams2.redhat.com [10.36.112.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15C4D60C43;
        Thu, 21 Jan 2021 13:43:04 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
 <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
 <3bce47db-c58c-6a2e-be72-9953f16a2dd4@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <0a46a299-c52d-2c7f-bb38-8d58afe053e0@redhat.com>
Date:   Thu, 21 Jan 2021 14:43:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <3bce47db-c58c-6a2e-be72-9953f16a2dd4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/2021 14.02, Pierre Morel wrote:
> 
> 
> On 1/21/21 10:46 AM, Janosch Frank wrote:
>> On 1/21/21 10:13 AM, Pierre Morel wrote:
>>> To centralize the memory allocation for I/O we define
>>> the alloc_io_page/free_io_page functions which share the I/O
>>> memory with the host in case the guest runs with
>>> protected virtualization.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   MAINTAINERS           |  1 +
>>>   lib/s390x/malloc_io.c | 70 +++++++++++++++++++++++++++++++++++++++++++
>>>   lib/s390x/malloc_io.h | 45 ++++++++++++++++++++++++++++
>>>   s390x/Makefile        |  1 +
>>>   4 files changed, 117 insertions(+)
>>>   create mode 100644 lib/s390x/malloc_io.c
>>>   create mode 100644 lib/s390x/malloc_io.h
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 54124f6..89cb01e 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -82,6 +82,7 @@ M: Thomas Huth <thuth@redhat.com>
>>>   M: David Hildenbrand <david@redhat.com>
>>>   M: Janosch Frank <frankja@linux.ibm.com>
>>>   R: Cornelia Huck <cohuck@redhat.com>
>>> +R: Pierre Morel <pmorel@linux.ibm.com>
>>
>> If you're ok with the amount of mails you'll get then go ahead.
>> But I think maintainer file changes should always be in a separate patch.
>>
>>>   L: kvm@vger.kernel.org
>>>   L: linux-s390@vger.kernel.org
>>>   F: s390x/*
>>> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
>>> new file mode 100644
>>> index 0000000..bfe8c6a
>>> --- /dev/null
>>> +++ b/lib/s390x/malloc_io.c
>>> @@ -0,0 +1,70 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>
>> I think we wanted to use:
> 
> @Janosch , @Thomas
> 
>> /* SPDX-License-Identifier: GPL-2.0-or-later */
> 
> or
> 
> // SPDX-License-Identifier: GPL-2.0-only
> 
> later or only ?

If it's a new file, it's up to the author. I personally prefer -later, but I 
think IBM's preference is normally -only instead. Please check with your 
colleagues.
Most s390x-related files in the kvm-unit-tests currently use "GPL-2.0-only", 
so that should be ok anyway.

> /* or // ?

I don't mind. // seems to be kernel style for .c files, but so far we've 
only used /* with SPDX in the kvm-unit-tests, so both should be fine, I think.

> Just to : Why are you people not using the Linux style code completely 
> instead of making new exceptions.
> 
> i.e. SPDX license and MAINTAINERS

Actually, I wonder why the Linux documentation still recommends the 
identifiers that are marked as deprecated on the SPDX website. The 
deprecated "GPL-2.0" can be rather confusing, since it IMHO can easily be 
mistaken as "GPL-2.0+", so the newer identifiers are better, indeed.

Not sure what you mean with MAINTAINERS, though.

  Thomas

