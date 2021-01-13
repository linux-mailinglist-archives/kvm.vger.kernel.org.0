Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400072F4C28
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 14:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbhAMNST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 08:18:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725801AbhAMNST (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 08:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610543812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3rGhWToIyZPL0OktEK6wCt3StrIOhYPirvwNLhTW5lw=;
        b=QZCleen23nVQ/oKL6Ngvbg3SNZLGWq4eS1bvZhTV1i/1qPpJHQnDRrFRidWVOB6wm/LcGh
        2VxgtTIN4yu2UZNipvE1xMyYgSbN4/xTIzRbZJ8nZyABQ9PWK4nwZYpQMtZyAa9oD45fPo
        1vtA0CvZnxe9kpbv10wE+qwLq6jEL38=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-yfgsj-0HNYirYlcpheAqWg-1; Wed, 13 Jan 2021 08:16:48 -0500
X-MC-Unique: yfgsj-0HNYirYlcpheAqWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 934F3107ACF9;
        Wed, 13 Jan 2021 13:16:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-122.ams2.redhat.com [10.36.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 717A65D9DC;
        Wed, 13 Jan 2021 13:16:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 9/9] s390x: sclp: Add CPU entry offset
 comment
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
 <20210112132054.49756-10-frankja@linux.ibm.com>
 <6f93c964-9606-246c-7266-85044803e49b@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b89e6d76-8b42-e36e-cf5c-7b05244993dc@redhat.com>
Date:   Wed, 13 Jan 2021 14:16:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <6f93c964-9606-246c-7266-85044803e49b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/2021 11.25, David Hildenbrand wrote:
> On 12.01.21 14:20, Janosch Frank wrote:
>> Let's make it clear that there is something at the end of the
>> struct. The exact offset is reported by the cpu_offset member.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/sclp.h | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index dccbaa8..395895f 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -134,7 +134,10 @@ typedef struct ReadInfo {
>>   	uint8_t reserved7[134 - 128];
>>   	uint8_t byte_134_diag318 : 1;
>>   	uint8_t : 7;
>> -	struct CPUEntry entries[0];
>> +	/*
>> +	 * The cpu entries follow, they start at the offset specified
>> +	 * in offset_cpu.
>> +	 */
> 
> I mean, that's just best practice. At least when I spot "[0];" and the
> end of a struct, I know what's happening.
> 
> No strong opinion about the comment, I wouldn't need it to understand it.

The problem is that the "CPUEntry" entries either might be at this location, 
or later, so the entries[0] can be misleading. You always have to go via the 
offset_cpu field to find the right location.

  Thomas

