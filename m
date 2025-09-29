Return-Path: <kvm+bounces-58979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B614BA8E12
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 12:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3F7B189D9B7
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 10:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CB52FB995;
	Mon, 29 Sep 2025 10:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YtMQXGic"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA522EC56F
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 10:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759141338; cv=none; b=gew5/Uhdq7FOvB4OR4+x11I//I9DfiKQCgRgm+OE5skcHsGacItxzYQpKz0x2saJWwUzvRlyfTvsxPVi1l0kLfQ3nK6g9eg7iOgc6RU2RSLEm/bYIpxtSwwebzqN+PwtOLV2ra0OStNd63M19tg32XZOoxsSlFLD7xhaXoFa6vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759141338; c=relaxed/simple;
	bh=YJjG7q3oPFCJAUZOA6f3h4dExpYvsQPN2rafoNzBl5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PTduvd9bPxTnO46rQeRq9MPlLohEouQapRslHzqc58jI2cumXVzr4AZGZJ4WxaPp7TbUGCIvh8124i7SvrlvwjAse7fO/56fjaMXJbZK0OsEHaXtig0f8tKv8Y86XuAB4CCdyM6NRcu/rdUzkNqnzpMnHfqDq/wMykJfCMkyXtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YtMQXGic; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759141336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gTfF/9tS74v6KOk7XL7uKXLPFCkMs1I/RkhQW/KFaXg=;
	b=YtMQXGic0zcUWMy5w9ZygH5nzY6ZG086HjQAYfVmgpA12ON/Xy+ilCouQJSLVwwePXchSn
	iZsGmkmo/jxjJoC64g7hJjNReKkcuPnw9774t61JPqIyh2w4h53jB0kZE+F9K5JC5u9lCM
	8BDgormXZocdyBSq65uvs9VRVwhPAD4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-dwBNT0sAPM6W2MJm7pNw6Q-1; Mon, 29 Sep 2025 06:22:15 -0400
X-MC-Unique: dwBNT0sAPM6W2MJm7pNw6Q-1
X-Mimecast-MFC-AGG-ID: dwBNT0sAPM6W2MJm7pNw6Q_1759141334
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e44b9779eso12429505e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 03:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759141334; x=1759746134;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gTfF/9tS74v6KOk7XL7uKXLPFCkMs1I/RkhQW/KFaXg=;
        b=HOzq9CMy02rDp+Td0LZL37VVGjj5WfzXzqJjXCnPBGrL910LqOgUjlwrGRp1SzYS9K
         YFNemyU2OKi+C4Nkc4ylWy4vobbXGYB+YfjE8vBgxz+vLOh46WGkz6fJTFvtRzcAg8EK
         IIqP94b3MqF2FMvJ+k9T/ix7qUIQrI/0tjLShNSfblUt24vM/kn/YSKbRmVTUINzGrlu
         6tpLA5iqIUGALTAVKWxIsPRObRV5ZtzmRFsxPOPipStTEb/l2KChMqvmMMyJ/EJXDmBN
         y0PYugAssO46Q+E+R3J5Px7IVAtwY7tADS/6neCXR6bpMmQksK0C7Sy3oXEM277VRCIZ
         MYEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJQ9KO+XspGUE99MA+F4teGSTkZ+H88S1YnAs1N32xoCU9j1DysoAc/xFmGHoo8xkcRlU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNnQUin5/73kKo/up3Nnwc6/VsEs5kiMwcpwC9Esl/+fM8ZSA7
	7qrmlCQBBSrY9xbhmT/MqFgk4eGK/Nw2sKbsK8F9XbU+3oaKjKrRG3VI9/GkPSGgYBNtOvpUDTE
	KcfxT7QM0Xh5pD8/kgTtYO/rJoG86BZkTPBsnLOMFHQCIsBr5/fhyoQ==
X-Gm-Gg: ASbGncscDFdu8kn+wDMU9prCuyWJtipgYTM3SbSZJERxY80XlCPKt+2ly9VIGM9gZyz
	iUcKjhs3u6itMrV9cMuYWaNp+5GXLt9ZoGnfMbjcXXzaw3FdLoM2eD3+YwfkCLIZ/5IiztsWE/J
	gij0hX8o4jfaggge6efEqQvbX3vGok4rOUWR4621jl2BEVuVfFkUQByx3n6zUqGdoziYS1U0gV0
	62nL7tRWo7dmb6nkyvH6HMz0+SyEFPzEgxEn9ynlLP6I3RPqmGqj8aRFo42YFqMTGC8tF/JerVu
	2jPUnPfoUIh4JEXCrqJ8yNaZO69u88BYsmd4c7e/klaSsG12pIHXsLRqIqim8XsMhC28E7rZ
X-Received: by 2002:a05:600c:1e85:b0:45d:d5df:ab2d with SMTP id 5b1f17b1804b1-46e32a03456mr153455715e9.26.1759141334053;
        Mon, 29 Sep 2025 03:22:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcPTC0WN8sznaK2VhvNvPmXdMZ5tY9SOo2+KWlJ8c8Cfvq/5YcnNrrC/JndZbTtN7rU24FIw==
X-Received: by 2002:a05:600c:1e85:b0:45d:d5df:ab2d with SMTP id 5b1f17b1804b1-46e32a03456mr153455355e9.26.1759141333625;
        Mon, 29 Sep 2025 03:22:13 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fa94.dip0.t-ipconnect.de. [79.241.250.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb985e080sm17624009f8f.24.2025.09.29.03.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 03:22:13 -0700 (PDT)
Message-ID: <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com>
Date: Mon, 29 Sep 2025 12:22:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Patrick Roy <patrick.roy@linux.dev>, Ackerley Tng
 <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 shivankg@amd.com
References: <20250926163114.2626257-1-seanjc@google.com>
 <20250926163114.2626257-2-seanjc@google.com>
 <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com>
 <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

                          GUEST_MEMFD_FLAG_DEFAULT_SHARED;
>>>
>>> At least for now, GUEST_MEMFD_FLAG_DEFAULT_SHARED and
>>> GUEST_MEMFD_FLAG_MMAP don't make sense without each other. Is it worth
>>> checking for that, at least until we have in-place conversion? Having
>>> only GUEST_MEMFD_FLAG_DEFAULT_SHARED set, but GUEST_MEMFD_FLAG_MMAP,
>>> isn't a useful combination.
>>>
>>
>> I think it's okay to have the two flags be orthogonal from the start.
> 
> I think I dimly remember someone at one of the guest_memfd syncs
> bringing up a usecase for having a VMA even if all memory is private,
> not for faulting anything in, but to do madvise or something? Maybe it
> was the NUMA stuff? (+Shivank)

Yes, that should be it. But we're never faulting in these pages, we only 
need the VMA (for the time being, until there is the in-place conversion).

-- 
Cheers

David / dhildenb


