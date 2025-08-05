Return-Path: <kvm+bounces-54004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3CE1B1B513
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F39362503C
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D99276059;
	Tue,  5 Aug 2025 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCsLnSWS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFD3273805
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754401070; cv=none; b=g1UN1h6RKllOYuX1M32+lBLKh/3tJQhdicVIKIvEQzAmutvAv3YGT2zYIO7Q8K6labncdtIkJ1tWbD0JqWnuB/AdTcCiJVrLOHbha/UyhFvfd3a2YTr9hEOGlgTf+79L46ZEcmHMcwA1hvxviKEeDQ3b/3zajIpKrPKy65Qvhvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754401070; c=relaxed/simple;
	bh=ur+3rk3Cc9JxozYX7NkdoqtewqGkG0MR/5EJ9ydJpnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R9oABsDDOqJmu//wcnrn8i1U4n74cVEFN9oBFgg4nEsfts2++YDJKRgiEH4y7AOQxzJ/MKBp9D69r92CiBhCKg9n3irUBNtGHkK7RFN3S6qbgXPrAY7cNWY5ljXsUfTcOahWkExS2YO4g9ZAto7TEZAYPrksjLk65GAzcXFGujM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cCsLnSWS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754401067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UpjJgzh4g7dtAXCY59lGQTt1+v956Gh1WPJKYgAgYz4=;
	b=cCsLnSWSUMO+zXaGoLdJc7AiCtGqtEcgTzmwFowrFdDunDejBUwA/7RJOXHE3rTw2yTMhf
	UEyiBOQmUkz+/7O5EZ+bU9QfJmIvQWEj3YHzblMQZrSATWSQEbXxCjmaEKBQE+DGlS+0DD
	kkJ3la8DppgbbAOuUJ/IAYmMHop0Yug=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-UNwLARvWM7KtNG2704lMMw-1; Tue, 05 Aug 2025 09:37:46 -0400
X-MC-Unique: UNwLARvWM7KtNG2704lMMw-1
X-Mimecast-MFC-AGG-ID: UNwLARvWM7KtNG2704lMMw_1754401065
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451d30992bcso35824915e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:37:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754401065; x=1755005865;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UpjJgzh4g7dtAXCY59lGQTt1+v956Gh1WPJKYgAgYz4=;
        b=LIx176A0edmbST6iGuRT1CRgQx1+6XA8jlQkIHVmghkY1a/87XcfJevSRk+IrvNkAR
         dI24W0Q2HPo4wMzDw3XSJ8TBybpFOqfD2RbmRu8OpiKeicw6S3A8xJtExGQVetM4nijw
         rrkkkyn+NeHp8ESWd8GBzh8XnOv547FlGs58fowy9RZyHUTG51jBATzxxSckGR7GN3o/
         VRJUCPFvQblEw3LImnhLQAUOXqQRV+U3PVUXr9ejaxsmmqmSu4saynpQuRjvRz0UMl3N
         KqLNGJLkr6mRhd9krPXAh6wbEZL5W6+5px+7VIb3x+4pZQNkbWgiDvOMdH7y1ewdJw65
         x++Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNdW4+SmwwX3mPusEXQdzIR3flE07BuABRfqnm+NWIDcd9LuYlz5tZlLZpafbRYzp4CsE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9DsWGyjZ+JjCqLCCSVuQJVNCjA/No4vz+URrL4KiDbhJ6MVR+
	yE3+6rU2Tjzg1gayfnQHJL9zi99E8kGl9hvdhZdiUazNXtn6IP6/IdTkIrXqSA1Y9y5iXDri60y
	hSJa42EzNxoYzkd4OWSmqPEPR0CaNaYMbJe19L/6EgB3yAF1yLXG5Cw==
X-Gm-Gg: ASbGncvL8y/6BHyeHQV2O4iVCQcyHDknbp1rI/8PIcK0LNgXGxAbemDOH3WuXoynXoj
	132S7pxAyAsVbZ7nZDDOPtBiw3gvPHlF0/1Xkf0jEHX8kv0H8ilSdKcSqVmXVyZ9JI3bUmX9p+y
	9xi2XVaw4bLFJwSNUFg6f0/bZgJk3DjlTtPtjua6/+DDF/8/ZHpAjMQ9/H8ClowkNH+kTyyc5RJ
	7GHqYMv1X859ve6oVXNi16uilPr/OtVkpMhPlzytz3sxXdKg73mI7yFnSALa8pwXzblGad3H+0P
	Uj6DV879phT7a9Pkhi8G02GlyEJvx+3NwqwgyEzK5IqFR6pHDAziTyX0FQHqCPg0xZ86xQ8H+t5
	fuX4yvzgbH4q+WYuXQakijKrGW4VhEVRPq6/L46ASZlSiZzg4XieDDu09B2P7XDQ8bi8=
X-Received: by 2002:a05:600c:8b23:b0:456:f9f:657 with SMTP id 5b1f17b1804b1-458b6b667cfmr92362335e9.27.1754401064940;
        Tue, 05 Aug 2025 06:37:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElocaX9QbGihnr0Q8xsLrPze9EwN7eJJPY8YcWv8xr6TcgxKbF1B2JLhwFKxBC9bp7NuGp5w==
X-Received: by 2002:a05:600c:8b23:b0:456:f9f:657 with SMTP id 5b1f17b1804b1-458b6b667cfmr92362075e9.27.1754401064499;
        Tue, 05 Aug 2025 06:37:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4532c4sm19122359f8f.36.2025.08.05.06.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:37:43 -0700 (PDT)
Message-ID: <623c315b-b64a-4bb0-a5d6-e3a2011aa55a@redhat.com>
Date: Tue, 5 Aug 2025 15:37:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <7f891077-39a2-4c0a-87ec-8ef1a244f7ad@redhat.com>
 <CAHk-=wgX3VMxQM7ohrPX5sHnxM2S9R1_C5PWNBAHYCb0H0CW8w@mail.gmail.com>
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
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmgsLPQFCRvGjuMACgkQTd4Q
 9wD/g1o0bxAAqYC7gTyGj5rZwvy1VesF6YoQncH0yI79lvXUYOX+Nngko4v4dTlOQvrd/vhb
 02e9FtpA1CxgwdgIPFKIuXvdSyXAp0xXuIuRPQYbgNriQFkaBlHe9mSf8O09J3SCVa/5ezKM
 OLW/OONSV/Fr2VI1wxAYj3/Rb+U6rpzqIQ3Uh/5Rjmla6pTl7Z9/o1zKlVOX1SxVGSrlXhqt
 kwdbjdj/csSzoAbUF/duDuhyEl11/xStm/lBMzVuf3ZhV5SSgLAflLBo4l6mR5RolpPv5wad
 GpYS/hm7HsmEA0PBAPNb5DvZQ7vNaX23FlgylSXyv72UVsObHsu6pT4sfoxvJ5nJxvzGi69U
 s1uryvlAfS6E+D5ULrV35taTwSpcBAh0/RqRbV0mTc57vvAoXofBDcs3Z30IReFS34QSpjvl
 Hxbe7itHGuuhEVM1qmq2U72ezOQ7MzADbwCtn+yGeISQqeFn9QMAZVAkXsc9Wp0SW/WQKb76
 FkSRalBZcc2vXM0VqhFVzTb6iNqYXqVKyuPKwhBunhTt6XnIfhpRgqveCPNIasSX05VQR6/a
 OBHZX3seTikp7A1z9iZIsdtJxB88dGkpeMj6qJ5RLzUsPUVPodEcz1B5aTEbYK6428H8MeLq
 NFPwmknOlDzQNC6RND8Ez7YEhzqvw7263MojcmmPcLelYbfOwU0EVcufkQEQAOfX3n0g0fZz
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
 AP+DWgUCaCwtJQUJG8aPFAAKCRBN3hD3AP+DWlDnD/4k2TW+HyOOOePVm23F5HOhNNd7nNv3
 Vq2cLcW1DteHUdxMO0X+zqrKDHI5hgnE/E2QH9jyV8mB8l/ndElobciaJcbl1cM43vVzPIWn
 01vW62oxUNtEvzLLxGLPTrnMxWdZgxr7ACCWKUnMGE2E8eca0cT2pnIJoQRz242xqe/nYxBB
 /BAK+dsxHIfcQzl88G83oaO7vb7s/cWMYRKOg+WIgp0MJ8DO2IU5JmUtyJB+V3YzzM4cMic3
 bNn8nHjTWw/9+QQ5vg3TXHZ5XMu9mtfw2La3bHJ6AybL0DvEkdGxk6YHqJVEukciLMWDWqQQ
 RtbBhqcprgUxipNvdn9KwNpGciM+hNtM9kf9gt0fjv79l/FiSw6KbCPX9b636GzgNy0Ev2UV
 m00EtcpRXXMlEpbP4V947ufWVK2Mz7RFUfU4+ETDd1scMQDHzrXItryHLZWhopPI4Z+ps0rB
 CQHfSpl+wG4XbJJu1D8/Ww3FsO42TMFrNr2/cmqwuUZ0a0uxrpkNYrsGjkEu7a+9MheyTzcm
 vyU2knz5/stkTN2LKz5REqOe24oRnypjpAfaoxRYXs+F8wml519InWlwCra49IUSxD1hXPxO
 WBe5lqcozu9LpNDH/brVSzHCSb7vjNGvvSVESDuoiHK8gNlf0v+epy5WYd7CGAgODPvDShGN
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAHk-=wgX3VMxQM7ohrPX5sHnxM2S9R1_C5PWNBAHYCb0H0CW8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 15:28, Linus Torvalds wrote:
> On Tue, 5 Aug 2025 at 16:20, David Hildenbrand <david@redhat.com> wrote:
>>
>> I think that would work, and we could limit the section check to the
>> problematic case only (sparsemem without VMEMMAP).
> 
> We really don't need to, because unlike the nth_page() thing, the
> compiler can see the logic and see "it's always zero".

Yeah, realized that later.

> 
> And in the complex case (ie actual sparsemem without VMEMMAP), the
> page_section() test is at least trivial, unlike the whole "turn it
> into a pfn and back".
> 
> Because that "turn it into a pfn and back" is actually a really quite
> complicated operation (and the compiler won't be able to optimize that
> one much, so I'm pretty sure it generates horrific code).

Yes, that's why I hate folio_page_idx() so much on !VMEMMAP

#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))

> 
> I wish we didn't have nth_page() at all. I really don't think it's a
> valid operation. It's been around forever, but I think it was broken
> as introduced, exactly because I don't think you can validly even have
> allocations that cross section boundaries.

Ordinary buddy allocations cannot exceed a memory section, but hugetlb and
dax can with gigantic folios ... :(

We had some weird bugs with that, because people keep forgetting that you
cannot just use page++ unconditionally with such folios.

Anyhow, thanks Linus!

-- 
Cheers,

David / dhildenb


