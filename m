Return-Path: <kvm+bounces-31615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1019C57BF
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 13:30:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AD25282316
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 12:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFCA81CD1FB;
	Tue, 12 Nov 2024 12:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ifAzxFh+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565B41CD209
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 12:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731414614; cv=none; b=EG/gUblWPOOjsurOzYRJyitWeKyUoq/Eny1PB6OCsqI7L0Eg+eo37Li+VaW+d9+4B4/kuRNgdltuEeP9z4qOF6oMESYtEOGrcc8v8Pr7I8wFINUPkFok+nduWzu+6UcniMRwWPoCmC/RtIxeB7fGLds9YtgVSdc+X19m7qytXRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731414614; c=relaxed/simple;
	bh=EkH7tOZES0UTBANUTLmCYMEXvzkYbquoimoVw4cajmk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=nIeddLQvidlo+bN51036V60KNgxuj9WVzQcudYv0KDKwkIS+0qWoIQZmjNtyJyqgD9GW3cFu6RTEU+823w4rVEc/e+MExkDsdalvswlzULr6bZeFQ475rCfx1PcFaXGh9aaK0fcWjN0pTQ1SVSUVGHmXsUcfzWCZMT6WaIFZjk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ifAzxFh+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731414611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=2a4i7dwP6my646ebN4zwm6Im+La25V6vtygycyHtUM8=;
	b=ifAzxFh+QOC9uUHKa4/9VTpz3R4Coxz2YBCSglVGee2VNoFCGU8gQJQTcCSa5uXh9lZw75
	UzNuJiw8aYQaIADRii0IJJVxZ6IbNQB8pOEDgU6CLpeElQnlO3AvP4eiFf0ZbAq0fnrMHG
	cZBLMWs12x12sfSXXZj57Kyfv8YRuLw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-2LnsgRQ9OkuiHVr6TfWp7g-1; Tue, 12 Nov 2024 07:30:10 -0500
X-MC-Unique: 2LnsgRQ9OkuiHVr6TfWp7g-1
X-Mimecast-MFC-AGG-ID: 2LnsgRQ9OkuiHVr6TfWp7g
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43164f21063so37730545e9.2
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 04:30:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731414609; x=1732019409;
        h=content-transfer-encoding:to:organization:autocrypt:subject:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2a4i7dwP6my646ebN4zwm6Im+La25V6vtygycyHtUM8=;
        b=oLwYjPmV11iRmvrlbRb9nhs9EOQ5B6hyy982AFEKo1Z6QilJ3fpAbhIupNJI+52VKe
         792LxLiNCJVdZ08C3fx7O2SVaGVFusbqG0n1fZFnlXkZDirTQ0zQfrRwhWiQzK8+NNGk
         C3T5o0h382sWkFpt7ckPb6DLhyhbNzn8cMSuvvlkGJdHAGoI5wph2kW/gs46c+zRsC5U
         9H/9XzpldfxXm29/cS/B5wc/M3IQFs1uwW+ZQdcwiURZyR89FFpgtftKSsg7ybk1iUPE
         n5INjceXtjq3ZbQ9thWaC2rbo698niB5fVsjikE8NDrygDEmj9HPlXl3jWvP8m4X6sZd
         vxsA==
X-Forwarded-Encrypted: i=1; AJvYcCVE5yVHXam0r6Lu60yhAkw3f7zWvxycp5uD/JpwVvuxjJqzOs4MLkebc35EX12y5nu+D3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmgDSuVuWKbHnAeOXHHAHhCXQTlH2HH8QhXmhAM2WAUAi8Bk/9
	ia4Ya4lGJbbLLlxH8YjDLP4ctV0ZYk38DCz/DHscieyiV2PQXZ3+eOsHhBH03xN8lc7ZImTRuRN
	GQOwGM9beJLssm+tI/spbOMOtujE8gYT++YVGf/yUbjeMcvwdeQ==
X-Received: by 2002:a05:600c:35cf:b0:431:5044:e388 with SMTP id 5b1f17b1804b1-432cd4748a4mr20638835e9.22.1731414608854;
        Tue, 12 Nov 2024 04:30:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGRKyf/MQA+/dsqTGn2AGJJDkgnrno5y7HFWo9lw33oNXuUOSk2AaDSa75oCXZLX/Hm30DtNA==
X-Received: by 2002:a05:600c:35cf:b0:431:5044:e388 with SMTP id 5b1f17b1804b1-432cd4748a4mr20638515e9.22.1731414608456;
        Tue, 12 Nov 2024 04:30:08 -0800 (PST)
Received: from ?IPV6:2003:cb:c739:8e00:7a46:1b8c:8b13:d3d? (p200300cbc7398e007a461b8c8b130d3d.dip0.t-ipconnect.de. [2003:cb:c739:8e00:7a46:1b8c:8b13:d3d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05e5f77sm211872355e9.43.2024.11.12.04.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 04:30:07 -0800 (PST)
Message-ID: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
Date: Tue, 12 Nov 2024 13:30:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2024-11-14
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
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
To: linux-coco@lists.linux.dev, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

the next guest_memfd upstream call will happen this Thursday, 2024-11-14
at at 9:00 - 10:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes are linked from the google calendar invitation. If you
want an invitation that also covers all future meetings, just write me a
mail.

In this meeting we'll discuss:
* fbind() and NUMA mempolicy for guest_memfd
* Persisting guest_memfd across reboot / guest_memfs
* guest_memfd use cases for a PFN range allocator

And we'll continue our discussion on:
* Challenges with supporting huge pages
* Challenges with shared vs. private conversion
* guest_memfd as a "library"

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

--

Current upstream proposals floating around:
* mmap support + shared vs. private [1]
* preparations [2] for huge/gigantic page support [3]
* guest_memfd as a "library" to make it independent of KVM [4]
* fbind() and NUMA mempolicy for guest_memfd [5]
* Hooking into folio_put() [6]

[1] https://lkml.kernel.org/r/20241010085930.1546800-1-tabba@google.com
[2] https://lkml.kernel.org/r/cover.1728684491.git.ackerleytng@google.com
[3] https://lkml.kernel.org/r/cover.1728684491.git.ackerleytng@google.com
[4]
https://lkml.kernel.org/r/20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com
[5] 
https://lore.kernel.org/all/20241105164549.154700-1-shivankg@amd.com/T/#u
[6] https://lkml.kernel.org/r/20241108162040.159038-1-tabba@google.com

-- 
Cheers,

David / dhildenb


