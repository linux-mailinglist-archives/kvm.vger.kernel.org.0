Return-Path: <kvm+bounces-46880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4ADABA506
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7A501B62DA1
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E619F28031C;
	Fri, 16 May 2025 21:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBJgZFu3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCFC28003A
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747430456; cv=none; b=Ypmfmes+Tp45xRRmzoyFCXWsh8f5FwLy14J237NCyLndL++6OewNOzrKYn4jGXbNg9K1Qb06yC73N2x/r9XAwFLKS3UJSgZaP7ciAOVnxzYMLiULaj7HXHRazbAmz87HKo9TCCn/kquQS1A4N9A8xLhxUBpuOxfymrQuAipwD60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747430456; c=relaxed/simple;
	bh=JPwqfHSCQK/QgH8HqIumIRGFhGuLkPSrhBX2hgPf1Nk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kdFOikhjaKG2TrEZaILndvi7PyvJsHibCiZZRao3ZqiHVvhssWa4BZXBQRlsRaJppuWGHft/xb4MYzPS+c6crKug6T4y3QaqUJlprgL+jqFoGvY0eIz75DgswXNlwCieu9p4sP8rrSO2h0+V4GowqTlNp00u6G0sOPrbWiyPeaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UBJgZFu3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747430452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eCoMavrmaZxJcGW5dsoDotDkap37Rrn/8QZ0fSt1V6w=;
	b=UBJgZFu3YpjoVGQI0u85w34yytM4AAl4O1SthujxBOiOaeslODgza+9Olxliy7XWKuOJ4W
	2JQbnmkz6wHWYtz4rZCFh0z6IrqXlFsGHQKlM+YkAmDSJabQvbRhLKR9EwesLd+qfYGfmN
	rAfIueUtUpLP+rQjNy21zh7MnKO/CuA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-x5nIeMlROfuor52cpopttA-1; Fri, 16 May 2025 17:20:49 -0400
X-MC-Unique: x5nIeMlROfuor52cpopttA-1
X-Mimecast-MFC-AGG-ID: x5nIeMlROfuor52cpopttA_1747430446
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a206f05150so1779389f8f.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747430446; x=1748035246;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eCoMavrmaZxJcGW5dsoDotDkap37Rrn/8QZ0fSt1V6w=;
        b=ne7s7tCVB38KHfilQ68JKbVwkVzh/fnwqy3r5c+s90cznnt6hsFMgaoQ3pZoh4cvAO
         u0LTOKk0HRgcErRyIDMXOj2Z5u7oXXAumBs45Ziv01BiLK2Q8c7Lc8+Cs7+SYWp4G45I
         7v7lTiM5larqnwQOGmFmVWO/fS6ZH0BVtVP7S1XrwIrb7G9oF2hXwEROL7OMgE806KiW
         NmRU9cofwD9TwDtAmOr8bhL3x9nDidP2MX0kZ7WKztkZ+3vTi/ThxfxzW2wOYinPlu2I
         x6vrOAOz6L1G+ULJeYbXyBAztZX+I4l98HZUe/UndxhPlcAVP+QSQlNUflgcGsZL6AKK
         qCmw==
X-Forwarded-Encrypted: i=1; AJvYcCVgVh1DVb4+ZYkI6fBDTTbuPEnvtePTzwTXEM5D8zNhed5tIID/LeEItM7roRSsGgdQ2k8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3MqjT6E2dw2OLnxeKB6YRGvtcZEMV5oQz4DYE56KoFyEVQrRk
	/oC0k1urYVXyuV8PMTmDZsAC0jVXfnlK5b8qT8JWaSZUA9jyeAvWqeXhF55W67EV9ZQuFM4O7mG
	8moaGKicK60h1jaGkBaKQG+YYEEbjszS+XnQz5ofkV3NP7n6YG0kS8Q==
X-Gm-Gg: ASbGnct55d1LWNJTZ+hvUP1ZEsWqVud+wzD4FZo+Q6KW7QRu30QTm2wNdDd014ghYxe
	o1Z5njtQAXN9LmfQ1r4sVyL/Fic4msOZfTUSaXkAXLFkc7TReEKPqh+bYk8oDPYo+OyXWOOCNdG
	ZtiBnbPICBS0q7sJWZRvPXBjH33Te+OMSTf+9r6+mE3aHpyeP2ispstQosrt6PdRD5gLS6Hk+tI
	Lch5s1i8+j2QocPnDhHHFCiP3n4lWI72q4UZWARqwh7v6l4cXdabMKz7N8jGQZSJmv8SWiHXyZ3
	KroUpfDow8BBbEarVMlDapIF+9dBtnRY+Taxfr1RYw==
X-Received: by 2002:a05:6000:3113:b0:3a0:9f24:7749 with SMTP id ffacd0b85a97d-3a35ffd2d38mr3744509f8f.36.1747430446408;
        Fri, 16 May 2025 14:20:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9rcafLxS8xgREIjIKFia45brBz+IMR/aurS6hED242W2pTBmnbljKkHgcAvsIcUmFaCJwRQ==
X-Received: by 2002:a05:6000:3113:b0:3a0:9f24:7749 with SMTP id ffacd0b85a97d-3a35ffd2d38mr3744485f8f.36.1747430446028;
        Fri, 16 May 2025 14:20:46 -0700 (PDT)
Received: from [192.168.3.141] (p57a1ac29.dip0.t-ipconnect.de. [87.161.172.41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca5a79asm3942366f8f.25.2025.05.16.14.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 14:20:45 -0700 (PDT)
Message-ID: <0454761b-ec54-4cc8-9d01-b783e2e58f9e@redhat.com>
Date: Fri, 16 May 2025 23:20:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] s390/uv: don't return 0 from make_hva_secure() if
 the operation was not successful
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Sebastian Mitterle <smitterl@redhat.com>, stable@vger.kernel.org
References: <20250516123946.1648026-1-david@redhat.com>
 <20250516123946.1648026-2-david@redhat.com>
 <60DDE99E-E09D-4BD4-AC58-569186E45660@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <60DDE99E-E09D-4BD4-AC58-569186E45660@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.05.25 23:08, Zi Yan wrote:
> On 16 May 2025, at 8:39, David Hildenbrand wrote:
> 
>> If s390_wiggle_split_folio() returns 0 because splitting a large folio
>> succeeded, we will return 0 from make_hva_secure() even though a retry
>> is required. Return -EAGAIN in that case.
>>
>> Otherwise, we'll return 0 from gmap_make_secure(), and consequently from
>> unpack_one(). In kvm_s390_pv_unpack(), we assume that unpacking
>> succeeded and skip unpacking this page. Later on, we run into issues
>> and fail booting the VM.
>>
>> So far, this issue was only observed with follow-up patches where we
>> split large pagecache XFS folios. Maybe it can also be triggered with
>> shmem?
>>
>> We'll cleanup s390_wiggle_split_folio() a bit next, to also return 0
>> if no split was required.
>>
>> Fixes: d8dfda5af0be ("KVM: s390: pv: fix race when making a page secure")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   arch/s390/kernel/uv.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> index 9a5d5be8acf41..2cc3b599c7fe3 100644
>> --- a/arch/s390/kernel/uv.c
>> +++ b/arch/s390/kernel/uv.c
>> @@ -393,8 +393,11 @@ int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header
>>   	folio_walk_end(&fw, vma);
>>   	mmap_read_unlock(mm);
>>
>> -	if (rc == -E2BIG || rc == -EBUSY)
>> +	if (rc == -E2BIG || rc == -EBUSY) {
>>   		rc = s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
>> +		if (!rc)
>> +			rc = -EAGAIN;
> 
> Why not just folio_put() then jump back to the beginning of the
> function to do the retry? This could avoid going all the way back
> to kvm_s390_unpack().

Hi, thanks for the review.

We had a pretty optimized version with such tricks before Claudio 
refactored it in:

commit 5cbe24350b7d8ef6d466a37d56b07ae643c622ca
Author: Claudio Imbrenda <imbrenda@linux.ibm.com>
Date:   Thu Jan 23 15:46:17 2025 +0100

     KVM: s390: move pv gmap functions into kvm



In particular, one relevant hunk was:

-       switch (rc) {
-       case -E2BIG:
-               folio_lock(folio);
-               rc = split_folio(folio);
-               folio_unlock(folio);
-               folio_put(folio);
-
-               switch (rc) {
-               case 0:
-                       /* Splitting succeeded, try again immediately. */
-                       goto again;
-               case -EAGAIN:
-                       /* Additional folio references. */
-                       if (drain_lru(&drain_lru_called))
-                               goto again;
-                       return -EAGAIN;



Claudio probably had a good reason to rewrite the code -- and I hope 
we'll be able to rip all of that out soon, so ...

... minimal changes until then :)


-- 
Cheers,

David / dhildenb


