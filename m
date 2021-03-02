Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD3032B59B
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381489AbhCCHSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835367AbhCBTEQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:04:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614711769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pNI+Ky/EAJ5ZEIbf6MYJ2/dtzIOLZZYEqaCFj9rQGv8=;
        b=EfSyo0vU3h8mMd5QSaqro0qMJ84PLkp5iJlwSJ4rL4Bcpzcd6VL89o2P0yATXgpYdtiow0
        lGsVquvwP/YYI6NqgEEMhIWEXjUsU1cEG2nLors0KL5WMl2/8SLik7nTPSutxm+PpCBQoP
        IKDadMnSDfkjwlreCVryioEy0Y0kDVc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-O-lWEGKGMTus8FZOmVjsuA-1; Tue, 02 Mar 2021 14:02:48 -0500
X-MC-Unique: O-lWEGKGMTus8FZOmVjsuA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 763BC102C851;
        Tue,  2 Mar 2021 19:02:39 +0000 (UTC)
Received: from [10.36.114.189] (ovpn-114-189.ams2.redhat.com [10.36.114.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 814B16C941;
        Tue,  2 Mar 2021 19:02:35 +0000 (UTC)
Subject: Re: [PATCH v1 7/9] memory: introduce RAM_NORESERVE and wire it up in
 qemu_ram_mmap()
To:     Peter Xu <peterx@redhat.com>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Kotrasinski <i.kotrasinsk@partner.samsung.com>,
        Juan Quintela <quintela@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org
References: <20210209134939.13083-1-david@redhat.com>
 <20210209134939.13083-8-david@redhat.com> <20210302173243.GM397383@xz-x1>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <91613148-9ade-c192-4b73-0cb5a54ada98@redhat.com>
Date:   Tue, 2 Mar 2021 20:02:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210302173243.GM397383@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.03.21 18:32, Peter Xu wrote:
> On Tue, Feb 09, 2021 at 02:49:37PM +0100, David Hildenbrand wrote:
>> @@ -899,13 +899,17 @@ int kvm_s390_mem_op_pv(S390CPU *cpu, uint64_t offset, void *hostbuf,
>>    * to grow. We also have to use MAP parameters that avoid
>>    * read-only mapping of guest pages.
>>    */
>> -static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared)
>> +static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared,
>> +                               bool noreserve)
>>   {
>>       static void *mem;
>>   
>>       if (mem) {
>>           /* we only support one allocation, which is enough for initial ram */
>>           return NULL;
>> +    } else if (noreserve) {
>> +        error_report("Skipping reservation of swap space is not supported.");
>> +        return NULL
> 
> Semicolon missing.

Thanks for catching that!

> 
>>       }
>>   
>>       mem = mmap((void *) 0x800000000ULL, size,
>> diff --git a/util/mmap-alloc.c b/util/mmap-alloc.c
>> index b50dc86a3c..bb99843106 100644
>> --- a/util/mmap-alloc.c
>> +++ b/util/mmap-alloc.c
>> @@ -20,6 +20,7 @@
>>   #include "qemu/osdep.h"
>>   #include "qemu/mmap-alloc.h"
>>   #include "qemu/host-utils.h"
>> +#include "qemu/error-report.h"
>>   
>>   #define HUGETLBFS_MAGIC       0x958458f6
>>   
>> @@ -174,12 +175,18 @@ void *qemu_ram_mmap(int fd,
>>                       size_t align,
>>                       bool readonly,
>>                       bool shared,
>> -                    bool is_pmem)
>> +                    bool is_pmem,
>> +                    bool noreserve)
> 
> Maybe at some point we should use flags too here to cover all bools.
> 

Right. I guess the main point was to not reuse RAM_XXX.

Should I introduce RAM_MMAP_XXX ?

Thanks!

-- 
Thanks,

David / dhildenb

