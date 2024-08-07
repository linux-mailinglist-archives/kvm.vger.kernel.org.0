Return-Path: <kvm+bounces-23489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 693CE94A45E
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 11:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BCA31C20CD6
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 09:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95481D1F5C;
	Wed,  7 Aug 2024 09:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jGfM7taW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDB01D1741
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 09:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723023207; cv=none; b=f/Cmc+rGy8Xmf2qVYJI7+QKfdE0MSGRYFJ1XkwG4fItDBTmswcU/bLs2BzuDSs+TtFVl0VEUx4eqIsm6NyoL/hTODPpzVQyPNIBYKYeYIuLy6S/qdePRw94G/nFzZx/ed5XE9Y+jZXw5Gju2p34Nf4wNzPys+t8q3vr4G/QVHSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723023207; c=relaxed/simple;
	bh=VXzHaQm7XQbvOf5JyZxW17M3OZXWaTO3C/rchFehAvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=algjvQ50/YLOsdNZ/jWLv3qIvaDkBViHoqJNm2FRPTyJDecipahDzbUkOpmkcmZFBHQZMK3e8NhZLJeodjdabSqQhIhMisY9gRJcn1CZpH18oPsCAMJ+cLxKQJ0buPXUXyAic1eWa2gvlRBt7EVoxiOu38nD60c5dj9Xb4wpxT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jGfM7taW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723023204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=r1ao3oI2bC/T6YUDOi/z140Hom9Lwuz/axm2MilPj98=;
	b=jGfM7taWlRY5BxXo0hm2ixuBhfjfyQgtHA+clp6QrUyhCjaPsa6fXu6j5CnkvudLm7Xonz
	M0THgopqSk6XBc2JacdeU/mu5ns6MziRp76LgMMJNxaVHo2wM/Ba/QypTpMUWLSmTNPJ/b
	BT8b5X7UzBSbZcKlAPrwCcQCzQp8WXY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-rU_suDQsO8iCsEfwAUZrvQ-1; Wed, 07 Aug 2024 05:33:22 -0400
X-MC-Unique: rU_suDQsO8iCsEfwAUZrvQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-427ffa0c9c7so17518375e9.1
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 02:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723023201; x=1723628001;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r1ao3oI2bC/T6YUDOi/z140Hom9Lwuz/axm2MilPj98=;
        b=hKwoqJgNDUphYHZtktKTchIIcONZLpqKDblvhGCqU1OKhEgNoe+GtfOSrgvtO+Frtc
         AYMB4/BAdp/IT7vx1GT6uuEYWjfv0VLGsUHGDVmzr4dTwikbjYzhDA+NQAlQNBhSYH3B
         ZX63RtEIXxRhUQkSrW7lUFYDesU9WRCspNRfkD7u9N5NPQM4oPWqcvk2WTmJU/WbW9vC
         wEvxyzji3naopsNwOTOF6OWGy479yvbnSpheP5THnjBfi7BSKSHsp2Ibptkh4GWFROkq
         J6nkzFTvtMaYlvpLH1zVp1RVfinYhZkJHZntoL2ODq4F2qYseX0MFL8BCexE1OiNZz15
         FdpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeQaTUa18XEWYPhRy15xNnp9DMCeOS+lxyrcWv2+AMSxirtjW+9SpLcHXnPwgOGmbmRiXRmDCIyCa10rGtog1D4x7H
X-Gm-Message-State: AOJu0Yy006XcRnnu7ZLBWAD6n7wezWe1fFoayDt5EXWHFaALZk9KsYwj
	4eKmPswvdJIpAhbvqPQJIfvCX0+ssXVrGBFcjRZzhu1fFHVMYqcSBPDDFdYTaWqJtmZLch6mSth
	uWRZvryeuJRhd3BybnYBIxNOpDqUWSOHvd9Ir3Xx1WEhM8PTTYA==
X-Received: by 2002:a05:600c:1c25:b0:426:5520:b835 with SMTP id 5b1f17b1804b1-428e6af241dmr135922215e9.5.1723023200865;
        Wed, 07 Aug 2024 02:33:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZ1EiCG7QsRTDVlK5w+6p4nKm5oU+kZSr1yFuVMrc+A2gerQdJIOXN4JQj6G7CIHOFRMSO6g==
X-Received: by 2002:a05:600c:1c25:b0:426:5520:b835 with SMTP id 5b1f17b1804b1-428e6af241dmr135921805e9.5.1723023200220;
        Wed, 07 Aug 2024 02:33:20 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:1a00:df86:93fe:6505:d096? (p200300cbc7081a00df8693fe6505d096.dip0.t-ipconnect.de. [2003:cb:c708:1a00:df86:93fe:6505:d096])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429059719ebsm19899155e9.18.2024.08.07.02.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Aug 2024 02:33:19 -0700 (PDT)
Message-ID: <aa577d5c-a992-4f82-aecf-266cb940d5a7@redhat.com>
Date: Wed, 7 Aug 2024 11:33:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/11] mm: replace follow_page() by folio_walk
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>
References: <20240802155524.517137-1-david@redhat.com>
 <20240807111534.4e79d7fd@p-imbrenda.boeblingen.de.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240807111534.4e79d7fd@p-imbrenda.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.08.24 11:15, Claudio Imbrenda wrote:
> On Fri,  2 Aug 2024 17:55:13 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> Looking into a way of moving the last folio_likely_mapped_shared() call
>> in add_folio_for_migration() under the PTL, I found myself removing
>> follow_page(). This paves the way for cleaning up all the FOLL_, follow_*
>> terminology to just be called "GUP" nowadays.
>>
>> The new page table walker will lookup a mapped folio and return to the
>> caller with the PTL held, such that the folio cannot get unmapped
>> concurrently. Callers can then conditionally decide whether they really
>> want to take a short-term folio reference or whether the can simply
>> unlock the PTL and be done with it.
>>
>> folio_walk is similar to page_vma_mapped_walk(), except that we don't know
>> the folio we want to walk to and that we are only walking to exactly one
>> PTE/PMD/PUD.
>>
>> folio_walk provides access to the pte/pmd/pud (and the referenced folio
>> page because things like KSM need that), however, as part of this series
>> no page table modifications are performed by users.
>>
>> We might be able to convert some other walk_page_range() users that really
>> only walk to one address, such as DAMON with
>> damon_mkold_ops/damon_young_ops. It might make sense to extend folio_walk
>> in the future to optionally fault in a folio (if applicable), such that we
>> can replace some get_user_pages() users that really only want to lookup
>> a single page/folio under PTL without unconditionally grabbing a folio
>> reference.
>>
>> I have plans to extend the approach to a range walker that will try
>> batching various page table entries (not just folio pages) to be a better
>> replace for walk_page_range() -- and users will be able to opt in which
>> type of page table entries they want to process -- but that will require
>> more work and more thoughts.
>>
>> KSM seems to work just fine (ksm_functional_tests selftests) and
>> move_pages seems to work (migration selftest). I tested the leaf
>> implementation excessively using various hugetlb sizes (64K, 2M, 32M, 1G)
>> on arm64 using move_pages and did some more testing on x86-64. Cross
>> compiled on a bunch of architectures.
>>
>> I am not able to test the s390x Secure Execution changes, unfortunately.
> 
> The whole series looks good to me, but I do not feel confident enough
> about all the folio details to actually r-b any of the non-s390
> patches. (I do have a few questions, though)
> 
> As for the s390 patches: they look fine. I have tested the series on
> s390 and nothing caught fire.
> 
> We will be able to get more CI coverage once this lands in -next.

Thanks for the review! Note that it's already in -next.

-- 
Cheers,

David / dhildenb


