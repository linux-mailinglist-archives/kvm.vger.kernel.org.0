Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACA710E912
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 11:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfLBKll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 05:41:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33829 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726330AbfLBKll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 05:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575283300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=WNjmJZ6s20LjM6RM73B5a2/udKKBeCpbeCgdAUSVSHQ=;
        b=e0+wW0COakNVn8rX5iLveSufMMwe9oRWblMc33iTT5OU8CRBT7XD4PcV2liFuQEgXFFX4o
        fvHKh+mtaPlZzQyaCYQXdMd116VDfuMWPegFklRm1vJqwx5ZSSn/NX1ZlIY/joXmgH9oSM
        FOIPBVHAgXt4RBO3IQ8CDEu2+5MVwmg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-KUJQ6QkAN8ubd6rMRDkdeA-1; Mon, 02 Dec 2019 05:41:37 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 234791005502;
        Mon,  2 Dec 2019 10:41:36 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-196.ams2.redhat.com [10.36.117.196])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E00815C3FD;
        Mon,  2 Dec 2019 10:41:31 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: irq: make IRQ handler weak
To:     David Hildenbrand <david@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-4-git-send-email-pmorel@linux.ibm.com>
 <33be2bbd-ea3b-4a93-3ce3-9dee36a531d1@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1fdc2864-ce65-1af1-272b-0769d903dd3f@redhat.com>
Date:   Mon, 2 Dec 2019 11:41:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <33be2bbd-ea3b-4a93-3ce3-9dee36a531d1@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: KUJQ6QkAN8ubd6rMRDkdeA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/11/2019 13.01, David Hildenbrand wrote:
> On 28.11.19 13:46, Pierre Morel wrote:
>> Having a weak function allows the tests programm to declare its own
>> IRQ handler.
>> This is helpfull for I/O tests to have the I/O IRQ handler having
>> its special work to do.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  lib/s390x/interrupt.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 3e07867..d70fde3 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -140,7 +140,7 @@ void handle_mcck_int(void)
>>  		     lc->mcck_old_psw.addr);
>>  }
>>  
>> -void handle_io_int(void)
>> +__attribute__((weak)) void handle_io_int(void)
>>  {
>>  	report_abort("Unexpected io interrupt: at %#lx",
>>  		     lc->io_old_psw.addr);
>>
> 
> The clear alternative would be a way to register a callback function.
> That way you can modify the callback during the tests. As long as not
> registered, wrong I/Os can be caught easily here. @Thomas?

I don't mind too much, but I think I'd also slightly prefer a registered
callback function here instead.

 Thomas

