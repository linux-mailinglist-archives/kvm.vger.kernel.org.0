Return-Path: <kvm+bounces-35970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC13DA16AD8
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DEC03A5EC1
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF7D1B6D08;
	Mon, 20 Jan 2025 10:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dIIW/IQZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370AE1BC07B
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737369282; cv=none; b=cj2aVzQnwYgdfrWuPYHZa0vCi3s/GMzOwAteRcVMNEe5e1HRMKTf0cb0qdlqt6bdPN6HuLuZT0TPxQSAMtL75Nu4sfFKJ2iVmQq+McksL+5k2/q9BWTzHanjVedT6G4rnD3RhEimrGJx+swF6xcdH7OQd68vnKWzGP8+ye5rzBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737369282; c=relaxed/simple;
	bh=XN/jDQj7DFcJlVM+sPKONNEdKWohE83giqJVDR6fIcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7mP+MlcTrRvRVTs2tiYVwdtXm97H0NdlO8qkPexYK9Jvry5YzVuta1ZLuL5NXosadiG9XqMqGiEL7P39eG4kFcga0iz3ukwmPMEnDPX1MtoWz+LcR+g8No8nt/3KpwIndfqJ2mRZeK637Ej9Zwv8GkVpEuG6LEkhWr3RVXEZ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dIIW/IQZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737369280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VTK3NeuA2/5eg0HceoKYSEnDBkQEomluQ0LED8G6DTc=;
	b=dIIW/IQZtkkN6NpyTrrV2d8bkjPViXwGHO3pn2h5DfW2D2TkeqVZ5H65MCZhbM25dnkew6
	zIXJ1jYHimWUskUVVdfMQpT0zJrrI7dOwlc0zrz6ppyx2/3eT7HoXIzrPmLenpyrva8hGB
	75JMd+OXRJGAQf8tv2KM7ogHcVFd4e0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-iTAtxEYmP8SBjhk9Gkbwow-1; Mon, 20 Jan 2025 05:34:38 -0500
X-MC-Unique: iTAtxEYmP8SBjhk9Gkbwow-1
X-Mimecast-MFC-AGG-ID: iTAtxEYmP8SBjhk9Gkbwow
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-436248d1240so20631775e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 02:34:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737369277; x=1737974077;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VTK3NeuA2/5eg0HceoKYSEnDBkQEomluQ0LED8G6DTc=;
        b=TSBwdODRcBH/n6mIWYpkncwmk61kR7cW4gTiI3yaighbncTAVG/+AxuhWHQrtDC5ju
         vapKAP78ECYFq0Kl2M13SM1ZLEv9Ir7C1+t1vv11LclXJ7TqGAdgNsbqriyIGCVgXfiw
         lSMyoOe0X8ysu4BvBe7igKPCsWUvT53fulprgjiTrdHqc3iyYVPaBVwsxak4WxN1zT3G
         85OYcT88MWzdEMQKwXeGNlHF0BH8hfjqQu6frb8PuTcht5AQdzIe3W5Y8rvoStiDnnZu
         uJxMBa2uCknEUxsbADzqeWeKMMLTM6ZAnh6WD1NkzLa/1biZQ+meo0sg+HhSb2UB9R5d
         o6sw==
X-Forwarded-Encrypted: i=1; AJvYcCVElA4zeyr3HxeYB9zTyt9Af4rEb5HiNfCQE01fDPl9gdOHHxt3/2/K6ktub++G0GdtU/A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWjIa8cNH+xXWKSrLlzlSJ+CnmIuyh13P7JDhepLZBnJEoNT9F
	twpnIqp2WUiuubznh3zBVxpqHXnZ6EsebwPQikOKZ9umRjUdQExVmBw3NcHa2/gld2TyDCDtdUM
	nXVV4Hykq+qO4Zdzyyrx5Ld0u69Oz0owlh1HjUq6XrN7cWARojg==
X-Gm-Gg: ASbGncuOCZ47W4/fGoGRVZmcA6GM+IKwJ1ZK5xISesd3JJoE33UurmpUDmgVKPa9rON
	BJDbwMgig6j6a8Np4cGwTlYRCxAd8ysLqmjL3CA5TcbxLX34YOueDyk6RarhernL4Z2OAYcrMth
	W+kMl1sAL45sel4WpcMUqZ4IkOpOCs0MwxWkD6UDgqEB0up5c3MLDv4y4D7eGclTJBQv8VZFaq0
	j2AsVq2MB5Apj77l5csVTVfwdy+EANv1xsMXVuOl8NzZxnscRq9Jy8ztPv38IbEquhVfdYGxYG5
	8ikLwrkZYsPyA/00H5gQk1YTA6Z+9qNmUJS/GW1yubB7+KjDH2UkVNx3iELTRUb2LjcuomaZyu6
	3U3ltkVY+du3gBJ4z3kX/Eg==
X-Received: by 2002:a05:600c:4693:b0:434:f0df:a14 with SMTP id 5b1f17b1804b1-438913bed10mr114788125e9.2.1737369277315;
        Mon, 20 Jan 2025 02:34:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEwm5c24BfYiPulRfzMGPF36n9+HhT1fghFu6Rqr00HIW3Loyfck/ZDjB4k+1ta6larzAGKg==
X-Received: by 2002:a05:600c:4693:b0:434:f0df:a14 with SMTP id 5b1f17b1804b1-438913bed10mr114787795e9.2.1737369276902;
        Mon, 20 Jan 2025 02:34:36 -0800 (PST)
Received: from ?IPV6:2003:d8:2f22:1000:d72d:fd5f:4118:c70b? (p200300d82f221000d72dfd5f4118c70b.dip0.t-ipconnect.de. [2003:d8:2f22:1000:d72d:fd5f:4118:c70b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c7527fc4sm193429185e9.27.2025.01.20.02.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 02:34:35 -0800 (PST)
Message-ID: <39715c86-cffb-4d11-aeb0-e056b264cc76@redhat.com>
Date: Mon, 20 Jan 2025 11:34:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 13/13] KVM: s390: remove the last user of page->index
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
 schlameuss@linux.ibm.com, willy@infradead.org, hca@linux.ibm.com,
 svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
 nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
 <20250108181451.74383-14-imbrenda@linux.ibm.com>
 <4175795f-9323-4a2c-acef-d387c104f8b3@linux.ibm.com>
 <e548aa1e-d954-4fab-8b74-302c140c04f7@redhat.com>
 <20250120112848.1547a439@p-imbrenda>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250120112848.1547a439@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.01.25 11:28, Claudio Imbrenda wrote:
> On Mon, 20 Jan 2025 10:43:15 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>>>> +static inline unsigned long gmap_pgste_get_index(unsigned long *pgt)
>>>> +{
>>>> +	unsigned long *pgstes, res;
>>>> +
>>>> +	pgstes = pgt + _PAGE_ENTRIES;
>>>> +
>>>> +	res = (pgstes[0] & PGSTE_ST2_MASK) << 16;
>>>> +	res |= pgstes[1] & PGSTE_ST2_MASK;
>>>> +	res |= (pgstes[2] & PGSTE_ST2_MASK) >> 16;
>>>> +	res |= (pgstes[3] & PGSTE_ST2_MASK) >> 32;
>>>> +
>>>> +	return res;
>>>> +}
>>>
>>> I have to think about that change for a bit before I post an opinion.
>>
>> I'm wondering if we should just do what Willy suggested and use ptdesc
>> -> pt_index instead?
> 
> we will need to store more stuff in the future; putting things in the
> PGSTEs gives us 512 bytes per table (although I admit it looks... weird)

With memdesc/ptdesc you'll be able to allocate more without playing many 
tricks.

Storing more information could be done today by allocating a separate 
structure for these page tables and linking it via ptindex. Not that I 
would suggest that just now. :)

But this is not something I am to decide, just pointing it out that it 
likely can be done in a simpler+cleaner way and there is no way to rush 
the pt_index removal.

-- 
Cheers,

David / dhildenb


