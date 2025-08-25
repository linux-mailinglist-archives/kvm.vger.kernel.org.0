Return-Path: <kvm+bounces-55612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2100EB33FF2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 14:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED1CB20567E
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 12:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E34C26E140;
	Mon, 25 Aug 2025 12:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQknvMKc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD991E5B9E
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756126148; cv=none; b=YyumDdARJvowRfxRgfX3+eNlUtvg1pnY+7lzHOSh8bijqrfopE1qMOv3HmMaz8eiGFqwQ1AGUZmd82ZA+u0IQ3GGY9YtWiGaZ1aVbp9P4dcKdbxH9NYaB6vNBLEgD5tnVQfb6d7ehrx19bpX6PBkspPLD7FeAkgUjI/d4CKw+Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756126148; c=relaxed/simple;
	bh=b7RwYEqsXqhvAIjVimo18yn+qIgGQwvJw8/CODbmjC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=euxblJURaOJyI18Lt++Fhz3+9DIEBTg9USgBdLzzTrihDqdcpWOgdV5bP4TDQkLcbOEL3l+qnbqhNXpA9qabKHJ0pR54uWG5akUprEjOEoA3v/fjTG3dDHhPvczgsThAQRKjDblfeVGRrWFAjHmeqW2nVEY9Hu9JPO3LtwDXVwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQknvMKc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756126145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3vXE/JZQfiOFAY8LityNc5lKOCwFML9m2hfnchuxSjw=;
	b=hQknvMKc5X8R0oeJ8WeyVloYgodCDNEjLTGs1blimmwdf258OB4H5nd5U/odpT7tL1P/Ed
	HFc1d41cFhZ91R99DskAheQJGl0kiIS96xMmDLyp62jnYlPctRNAcY1Xx1snk9YvEs+49k
	4KDtcA57GZehWM6A0Yg2V3z+EfSs6NQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-IakSP4KuNZKJuxbTJHXtaA-1; Mon, 25 Aug 2025 08:49:03 -0400
X-MC-Unique: IakSP4KuNZKJuxbTJHXtaA-1
X-Mimecast-MFC-AGG-ID: IakSP4KuNZKJuxbTJHXtaA_1756126142
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0060bfso28682525e9.0
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 05:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756126142; x=1756730942;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3vXE/JZQfiOFAY8LityNc5lKOCwFML9m2hfnchuxSjw=;
        b=u7bVH52xo7LNIYrJjwpkPB6Byxt4B+OfEpzqnnmX2oiQU6YYx+NfMnjK4odHXGuIfl
         8yxvEZkDSYfkdza2CWlF7Mtji9WslNl3mp9geRunFXkL8CtMtMFaTBsVRuUO3+m5W2NJ
         5fHRV2oxfYoUETxdGXP5Wq+Q8X/0QeMNcLxKoZeJ8ky1prOZoNUjLlD78BYJvv2yFrvo
         i2VXAIGpNMZrJe0wvI7+kwkVobl2dOumPsN6t1obijYsBbw+hztNfDFHfYoRB0P0ehpY
         7LaxQcGL0G2AEa2lLJ3NH0IWpElzm5f3EZPJAmddjhMCfRjIPh7uiXR0Vk2BlHO+uLaP
         ywQw==
X-Forwarded-Encrypted: i=1; AJvYcCWaoyRxFBijbcZyxe7LSVLiSkKrzKMwxHKUycIbKkHa6NdncFgZMhS62Jb7MqBkHUWFj9g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKhLjMwPVH3YMLUXVPvxjaqkE8okvTnjRm6mcqC3Wc4VpFFoO6
	WRuHl7ynpPeUCClN6/pUlOPcQgqlnBFpVge9F7q32HVSYB8AedOJcbrXtRZkjenx0j/9QiuFc0q
	sMsl0hcl3LW+dnz+KirD29WXjooDoPRlBDYlnPzHTYqlO0QcRGwke0g==
X-Gm-Gg: ASbGncuV1xw+pqfUKEiNJdtoSk5kw3rTF5X1yOeAAs3lnk8RDalIUqCtEZmapF1iCun
	Mv3InexHQ/ll/ne3/00PZIL++yoStG0GQ8ZTiVTJJ3SY/H9oPSpQlbQU7U/L9Zt86+x7Oam2A/s
	OO1n28V6gqLdAjWlP4CahneNyspzNh0wzEr2FQtKE8ncoAVcMcXs0cB2CewlbfHtMZRn74yRBsY
	no61h+ND2X3x1gNYnq+ReRQkj7yF+biB4h7Bdhp2X7ePytHpf9MyNjOo1K5edh4ranyy59f8NRN
	aXfOYMrArUhwXCScyU6z7dqgongd4FNchyCTYPtwzdiLmuIO+QgdLn3v2D63nYHp7BzkPImeroY
	7X+bLpoq+jywjZbMvG89J+uFILjLicOICCAq3uwLL7t7fqmhv8l6wDlzL0TazKH+nExw=
X-Received: by 2002:a05:600c:3b0f:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-45b517d4d50mr117581875e9.30.1756126141731;
        Mon, 25 Aug 2025 05:49:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXxc8CWovMYNQS1+MbZ/J1HLlRjFi84VTIxSAk5gdBYVSg2EOk3SSNbd5GU03jnCMkyvwvPg==
X-Received: by 2002:a05:600c:3b0f:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-45b517d4d50mr117581475e9.30.1756126141263;
        Mon, 25 Aug 2025 05:49:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70ea81d38sm11742640f8f.17.2025.08.25.05.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 05:49:00 -0700 (PDT)
Message-ID: <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
Date: Mon, 25 Aug 2025 14:48:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: Mike Rapoport <rppt@kernel.org>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
 <aKmDBobyvEX7ZUWL@kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKmDBobyvEX7ZUWL@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 23.08.25 10:59, Mike Rapoport wrote:
> On Fri, Aug 22, 2025 at 08:24:31AM +0200, David Hildenbrand wrote:
>> On 22.08.25 06:09, Mika Penttilä wrote:
>>>
>>> On 8/21/25 23:06, David Hildenbrand wrote:
>>>
>>>> All pages were already initialized and set to PageReserved() with a
>>>> refcount of 1 by MM init code.
>>>
>>> Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
>>> initialize struct pages?
>>
>> Excellent point, I did not know about that one.
>>
>> Spotting that we don't do the same for the head page made me assume that
>> it's just a misuse of __init_single_page().
>>
>> But the nasty thing is that we use memblock_reserved_mark_noinit() to only
>> mark the tail pages ...
> 
> And even nastier thing is that when CONFIG_DEFERRED_STRUCT_PAGE_INIT is
> disabled struct pages are initialized regardless of
> memblock_reserved_mark_noinit().
> 
> I think this patch should go in before your updates:

Shouldn't we fix this in memblock code?

Hacking around that in the memblock_reserved_mark_noinit() user sound 
wrong -- and nothing in the doc of memblock_reserved_mark_noinit() 
spells that behavior out.

-- 
Cheers

David / dhildenb


