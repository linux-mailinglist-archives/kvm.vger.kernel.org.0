Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A182DD44D
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgLQPiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:38:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbgLQPiZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 10:38:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608219418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=haU9+3I1EhIsBNBQ9QQHsINvaKlrWDyUkN+Krpx5g3E=;
        b=E2L2CR+HtbCq+MSQQJiNLkoLWDPhVqp6ibByKKJrjQpyq1OIhWlNo/QSuyL4dCtsjYo32p
        eozrXoMPxrrestYA38NL4j+C7AAbjrj3FT+CujGJtyLSADnb3NjJyqbnNxuco7Kz+Dc3Sj
        u44RDqZh5Rt7n55tV8TBHrcszlAG5us=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-DUapDB9LPfuK0b6oViVdOA-1; Thu, 17 Dec 2020 10:36:56 -0500
X-MC-Unique: DUapDB9LPfuK0b6oViVdOA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BBC89CC03;
        Thu, 17 Dec 2020 15:36:54 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-175.ams2.redhat.com [10.36.112.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C04AA19C71;
        Thu, 17 Dec 2020 15:36:49 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 7/8] s390x: Add diag318 intercept test
To:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     david@redhat.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-8-frankja@linux.ibm.com>
 <4f689585-ae2e-4632-9055-f2332d9f7751@redhat.com>
 <44d6ac32-f7ac-6b33-ea9e-e037f936a181@de.ibm.com>
 <24e9883c-22d5-de4f-0001-d271855d7ea3@redhat.com>
 <23af5bca-dd2c-43bd-b2b4-6c7e2031517f@linux.ibm.com>
 <b4bd9043-bf90-fe88-f237-b4f9948ba94e@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <dfc2c6bf-78ed-9f1f-0659-bee8437b46ca@redhat.com>
Date:   Thu, 17 Dec 2020 16:36:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <b4bd9043-bf90-fe88-f237-b4f9948ba94e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/2020 16.31, Janosch Frank wrote:
> On 12/17/20 3:31 PM, Janosch Frank wrote:
>> On 12/17/20 11:34 AM, Thomas Huth wrote:
>>> On 17/12/2020 10.59, Christian Borntraeger wrote:
>>>>
>>>>
>>>> On 17.12.20 10:53, Thomas Huth wrote:
>>>>> On 11/12/2020 11.00, Janosch Frank wrote:
>>>>>> Not much to test except for the privilege and specification
>>>>>> exceptions.
>>>>>>
>>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>>>>> ---
>>>>>>  lib/s390x/sclp.c  |  2 ++
>>>>>>  lib/s390x/sclp.h  |  6 +++++-
>>>>>>  s390x/intercept.c | 19 +++++++++++++++++++
>>>>>>  3 files changed, 26 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>>>>>> index cf6ea7c..0001993 100644
>>>>>> --- a/lib/s390x/sclp.c
>>>>>> +++ b/lib/s390x/sclp.c
>>>>>> @@ -138,6 +138,8 @@ void sclp_facilities_setup(void)
>>>>>>  
>>>>>>  	assert(read_info);
>>>>>>  
>>>>>> +	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
>>>>>> +
>>>>>>  	cpu = (void *)read_info + read_info->offset_cpu;
>>>>>>  	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>>>>>>  		if (cpu->address == cpu0_addr) {
>>>>>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>>>>>> index 6c86037..58f8e54 100644
>>>>>> --- a/lib/s390x/sclp.h
>>>>>> +++ b/lib/s390x/sclp.h
>>>>>> @@ -105,7 +105,8 @@ extern struct sclp_facilities sclp_facilities;
>>>>>>  
>>>>>>  struct sclp_facilities {
>>>>>>  	uint64_t has_sief2 : 1;
>>>>>> -	uint64_t : 63;
>>>>>> +	uint64_t has_diag318 : 1;
>>>>>> +	uint64_t : 62;
>>>>>>  };
>>>>>>  
>>>>>>  typedef struct ReadInfo {
>>>>>> @@ -130,6 +131,9 @@ typedef struct ReadInfo {
>>>>>>      uint16_t highest_cpu;
>>>>>>      uint8_t  _reserved5[124 - 122];     /* 122-123 */
>>>>>>      uint32_t hmfai;
>>>>>> +    uint8_t reserved7[134 - 128];
>>>>>> +    uint8_t byte_134_diag318 : 1;
>>>>>> +    uint8_t : 7;
>>>>>>      struct CPUEntry entries[0];
>>>>>
>>>>> ... the entries[] array can be moved around here without any further ado?
>>>>> Looks confusing to me. Should there be a CPUEntry array here at all, or only
>>>>> in ReadCpuInfo?
>>>>
>>>> there is offset_cpu for the cpu entries at the beginning of the structure.
>>>
>>> Ah, thanks, right, this was used earlier in the patch series, now I
>>> remember. But I think the "struct CPUEntry entries[0]" here is rather
>>> confusing, since there is no guarantee that the entries are really at this
>>> location ... I think this line should rather be replaced by a comment saying
>>> that offset_cpu should be used instead.
>>
>> Sure, as long as it's clear that there's something at the end, I'm fine
>> with it.
> 
> I would add that to the "fix style issues" patch or into an own patch.
> Any preferences?

I think a separate patch is cleaner.

> -       struct CPUEntry entries[0];
> +       /*
> +        * The cpu entries follow, they start at the offset specified
> +        * in offset_cpu.
> +        */

Sounds good, thanks!

 Thomas

