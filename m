Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACA240B5D7
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhINRY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 13:24:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230111AbhINRY6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 13:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631640220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MqDXjCZcBn29nal+6qOuwi7JZU8wFISffsSfwR+3L3E=;
        b=SZy8xrWi359oDh9qw537B21NtuGb7iI71OeNnXvfG/LKE1y/lBIEdd5a5eaodaWkdEZn+H
        o61h96Z6g8XLAsW0wF4WecsQDyWN6bv6hDeQgia3wlNgmN0piF5M9UKS3vcmyQ+pV2ocnm
        yh77niGKhL/v7wgjtD820hwW/aQv+/A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-dxnQ_iivPTCP64EDaKBDZw-1; Tue, 14 Sep 2021 13:23:39 -0400
X-MC-Unique: dxnQ_iivPTCP64EDaKBDZw-1
Received: by mail-wm1-f70.google.com with SMTP id j193-20020a1c23ca000000b00306cd53b671so61938wmj.1
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 10:23:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MqDXjCZcBn29nal+6qOuwi7JZU8wFISffsSfwR+3L3E=;
        b=TYBi9foueVwKZAkWhe8VUn3JjHNvmjXrjxB8PVlcEmV3BhZHzv9xAwKbNtcsNRDqok
         yEDDjn0eVb3HPGSWq31hxE9qE5xA8WcmDL5B4Tsydwh8orAooQ1nwT20sk/3mU0Ivjnv
         OFPOckfBI4y+bX8lYZ/KXDX7rOKTB81UC7pJ8eHffimVqQBzF67GkndguhDmqDjpQmNM
         S8yxI4SM+TaM9seiaWIPSg045jeBbS9MYDZNmfD9QID5irHc3lod3oMp6agJWaCaXAg6
         0gHznLKglcfbSvScDzAzsFQFQqo25i3FBfF/TwWOaMuNp0iXFh3YJAREZb24lBeSPc1o
         /Pzg==
X-Gm-Message-State: AOAM5332XYfkRCey3csh13i3UIagKe9jqXiJU/uhGQEOFMnGtZHoCTEY
        CHV8FLG2cy/6d2bgAjt+izjs7Ii8CK6a9XlrSv19/qMUMvDfC7SGnzxz44kaFLyIy7dhjIWVBeu
        p9RSywalPKRS/
X-Received: by 2002:a5d:61c1:: with SMTP id q1mr334688wrv.154.1631640218351;
        Tue, 14 Sep 2021 10:23:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3k1jrCY2l0TCreFxkhzeZFt/sEfOOcGitXD1qc1Q6O8TBKNKTnPnTU/9Pcn8mkICg9BGFjg==
X-Received: by 2002:a5d:61c1:: with SMTP id q1mr334653wrv.154.1631640218126;
        Tue, 14 Sep 2021 10:23:38 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6041.dip0.t-ipconnect.de. [91.12.96.65])
        by smtp.gmail.com with ESMTPSA id 61sm4080214wrl.94.2021.09.14.10.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 10:23:37 -0700 (PDT)
Subject: Re: [PATCH resend RFC 7/9] s390/mm: no need for pte_alloc_map_lock()
 if we know the pmd is present
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
References: <20210909162248.14969-1-david@redhat.com>
 <20210909162248.14969-8-david@redhat.com>
 <20210914185449.42d7d5ca@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <5a572489-a6d6-aaf4-098a-a8059f9b12f0@redhat.com>
Date:   Tue, 14 Sep 2021 19:23:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210914185449.42d7d5ca@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.09.21 18:54, Claudio Imbrenda wrote:
> On Thu,  9 Sep 2021 18:22:46 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> pte_map_lock() is sufficient.
> 
> Can you explain the difference and why it is enough?

I didn't repeat the $subject:

"No need for pte_alloc_map_lock() if we know the pmd is present; 
pte_map_lock() is sufficient, because there isn't anything to allocate."

> 
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   arch/s390/mm/pgtable.c | 15 +++------------
>>   1 file changed, 3 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
>> index 5fb409ff7842..4e77b8ebdcc5 100644
>> --- a/arch/s390/mm/pgtable.c
>> +++ b/arch/s390/mm/pgtable.c
>> @@ -814,10 +814,7 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
>>   	}
>>   	spin_unlock(ptl);
>>   
>> -	ptep = pte_alloc_map_lock(mm, pmdp, addr, &ptl);
>> -	if (unlikely(!ptep))
>> -		return -EFAULT;
>> -
>> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>   	new = old = pgste_get_lock(ptep);
>>   	pgste_val(new) &= ~(PGSTE_GR_BIT | PGSTE_GC_BIT |
>>   			    PGSTE_ACC_BITS | PGSTE_FP_BIT);
>> @@ -912,10 +909,7 @@ int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
>>   	}
>>   	spin_unlock(ptl);
>>   
>> -	ptep = pte_alloc_map_lock(mm, pmdp, addr, &ptl);
>> -	if (unlikely(!ptep))
>> -		return -EFAULT;
>> -
>> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>   	new = old = pgste_get_lock(ptep);
>>   	/* Reset guest reference bit only */
>>   	pgste_val(new) &= ~PGSTE_GR_BIT;
>> @@ -977,10 +971,7 @@ int get_guest_storage_key(struct mm_struct *mm, unsigned long addr,
>>   	}
>>   	spin_unlock(ptl);
>>   
>> -	ptep = pte_alloc_map_lock(mm, pmdp, addr, &ptl);
>> -	if (unlikely(!ptep))
>> -		return -EFAULT;
>> -
>> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>   	pgste = pgste_get_lock(ptep);
>>   	*key = (pgste_val(pgste) & (PGSTE_ACC_BITS | PGSTE_FP_BIT)) >> 56;
>>   	paddr = pte_val(*ptep) & PAGE_MASK;
> 


-- 
Thanks,

David / dhildenb

