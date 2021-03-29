Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E311234C9E3
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 10:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhC2IeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 04:34:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234173AbhC2IcL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 04:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617006730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ObFkKjmmp7RTnpzRxT5oLl+7kjuZKBWeAXwqd8L+S6A=;
        b=OQ9q5m9O+oWm/1oabu2PKJzP2YxMDqJ/+BjrqX6aGuAx5GgnVCNmJjOfB2kseY4yk12Tw3
        bqf0O4CHnWzNv61An4TTmLn5KyfaVW2VM3WKvEDuBFQrAwNZmrJm700VIvqKJOSHgA+sRQ
        /Gw9YqniOfZ0uDfhOrX+0XBFPQ1Zm+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-MtoKnWnvObKNqqLaqWavBg-1; Mon, 29 Mar 2021 04:32:07 -0400
X-MC-Unique: MtoKnWnvObKNqqLaqWavBg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA18019251A0;
        Mon, 29 Mar 2021 08:32:06 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B4EB5D9F0;
        Mon, 29 Mar 2021 08:32:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: lib: css: add SCSW ctrl
 expectations to check I/O completion
From:   Thomas Huth <thuth@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-6-git-send-email-pmorel@linux.ibm.com>
 <b1ccfed0-5a1c-323d-2176-39513fbde391@redhat.com>
Message-ID: <036a0962-e46c-7105-3f2a-d61c26e53226@redhat.com>
Date:   Mon, 29 Mar 2021 10:32:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <b1ccfed0-5a1c-323d-2176-39513fbde391@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/03/2021 10.27, Thomas Huth wrote:
> On 25/03/2021 10.39, Pierre Morel wrote:
>> When checking for an I/O completion may need to check the cause of
>> the interrupt depending on the test case.
>>
>> Let's provide the tests the possibility to check if the last
>> valid IRQ received is for the function expected after executing
>> an instruction or sequence of instructions and if all ctrl flags
>> of the SCSW are set as expected.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  4 ++--
>>   lib/s390x/css_lib.c | 21 ++++++++++++++++-----
>>   s390x/css.c         |  4 ++--
>>   3 files changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 5d1e1f0..1603781 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -316,8 +316,8 @@ void css_irq_io(void);
>>   int css_residual_count(unsigned int schid);
>>   void enable_io_isc(uint8_t isc);
>> -int wait_and_check_io_completion(int schid);
>> -int check_io_completion(int schid);
>> +int wait_and_check_io_completion(int schid, uint32_t ctrl);
>> +int check_io_completion(int schid, uint32_t ctrl);
>>   /*
>>    * CHSC definitions
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 1e5c409..55e70e6 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -488,21 +488,25 @@ struct ccw1 *ccw_alloc(int code, void *data, int 
>> count, unsigned char flags)
>>   /* wait_and_check_io_completion:
>>    * @schid: the subchannel ID
>> + * @ctrl : expected SCSW control flags
>>    */
>> -int wait_and_check_io_completion(int schid)
>> +int wait_and_check_io_completion(int schid, uint32_t ctrl)
>>   {
>>       wait_for_interrupt(PSW_MASK_IO);
>> -    return check_io_completion(schid);
>> +    return check_io_completion(schid, ctrl);
>>   }
>>   /* check_io_completion:
>>    * @schid: the subchannel ID
>> + * @ctrl : expected SCSW control flags
>>    *
>> - * Makes the most common check to validate a successful I/O
>> - * completion.
>> + * If the ctrl parameter is not null check the IRB SCSW ctrl
>> + * against the ctrl parameter.
>> + * Otherwise, makes the most common check to validate a successful
>> + * I/O completion.
>>    * Only report failures.
>>    */
>> -int check_io_completion(int schid)
>> +int check_io_completion(int schid, uint32_t ctrl)
>>   {
>>       int ret = 0;
>> @@ -515,6 +519,13 @@ int check_io_completion(int schid)
>>           goto end;
>>       }
>> +    if (ctrl && (ctrl ^ irb.scsw.ctrl)) {
> 
> With the xor, you can only check for enabled bits ... do we also want to 
> check for disabled bits, or is this always out of scope?

Never mind, I think I just did not have enough coffee yet, the check should 
be fine. But couldn't you simply use "!=" instead of "^" here?

  Thomas

