Return-Path: <kvm+bounces-55477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18FC4B30EDC
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 08:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55B5E5E7B1B
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 06:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9216A2E540C;
	Fri, 22 Aug 2025 06:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UJwID/Ny"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC622E3B17
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 06:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755843880; cv=none; b=n9rLa5hyajXvjZ1Ts0iWdZPVFY6wSHyn3eIXHX/CTdNGGE/vOHrPkWWDqvTs2sqs3x+7k6aagb3VDRLZtZkBucWsH98BGpzJeMnTbIowRe7w4QszQrmHg7+kYVNivJw2lr1RR4fEah62zd2FvJB6FbbhF/L8jN13E8o/XORef0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755843880; c=relaxed/simple;
	bh=fLX1vM4cjDsk9W/4BgtrD1gx0q/IoKCtlIVEIkFWTeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QSyc7ramdI/MgPxY9/I9jud2cb/USZOz2yDk0mFZssYliFfBkCCh3eQdwv9Ld7wRK8UfaU0Zi8ZHhSj9L4i7f9IvPlHIgfrQZxxrGeCnvDf0YkPjSdxbHgIaasnZYYtVOl3GZm0Duq3HJ62bfT2RzI6+UCeA6B8cLISM5A2D+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UJwID/Ny; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755843878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WiI+ZnCzEnb/n6DQfRPkU+9oejYIM/R2hKOTH1yevco=;
	b=UJwID/Ny9BPDInw1YPGRiKYIqsfJIcRM6APajZRPAC861tVWZStwPqaU4lf0ELAT2FMEBW
	CTYdqKYWjUKVDsIInd+Xaa4/UWaYmRIoS87In1H4aIZOKwCl7M+Gb4sFKOnG69NBgx5pBS
	+2gKkd6e7fgdBX2gIX4O2cRyfn+3hzQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-O9ezIeBaPGa9B8I-FMlznQ-1; Fri, 22 Aug 2025 02:24:36 -0400
X-MC-Unique: O9ezIeBaPGa9B8I-FMlznQ-1
X-Mimecast-MFC-AGG-ID: O9ezIeBaPGa9B8I-FMlznQ_1755843875
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9d41b88ffso1025116f8f.0
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 23:24:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755843875; x=1756448675;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WiI+ZnCzEnb/n6DQfRPkU+9oejYIM/R2hKOTH1yevco=;
        b=mY5ApWFftbdJOQjWTG9V3luZW/AZgVBclvfx6jf751mxcl9K8kwhLhkA7m76p/S/dD
         YhRaKOhcYBWxJ4q4Mjebu87Mc4R0Okc+dbf5aGTkGDjwoQWVCFT2+qe3ltAeAobsBswN
         nge41jLOZpV/cY0JyuxsWAaJZcak88VWpAtk39ad23yjp7Q1kqao2fUOA3u/A2dentM+
         JsLgDIVjOYkW6zaZRAMa1UV8eCEStXjSa+dnVoc77x1ZG1TMI5K8wLwRTK+f9owzaeaX
         FUtxmC8gqgcYOZ2BdymdDRijWykRUkxucLUKvurV38sMbVqWLWLmtJfT6qWoxWtLpMgv
         GBpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvyMcSLbmp7+SRw0NQTMjyAlfSJPiei+cMBY5mbcN+U1i7YCgNOdik1V+9tjSaOuL4iAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNeaLsLeyN7+vsXMXBtAuaZSRiOKcj5oUtJOGvTPif5auxyVai
	l2AQTU8aF5JPEtEGNbMMmj7XgG6E5nNMrou0D4GVsUaZ17TAGD7y0nqXkI9Cunrl1VtY66D0g9E
	XBlfUJS7zSM/GEf+tPa7SwSlWjudUQYuXqJbqM3wXgxvl+RN+P59ULw==
X-Gm-Gg: ASbGncumGngLvG6HW1mP2hqk1wBGDTHv6jLPXlgP6tE8cHTttj4IvlnB41t5ECLq2Qy
	4giLY6ovuqZ2xQOQt9w1uaI5ntOWA3xZ3Zo9/mtO+V00mfqsbb7vUCxz7CMPtPOppp+12H9QRQN
	Ph2GdRL0dedRFmnFIb5r5TTfdzWCSu3qhVcDJbfatq2psB9wIxhoe/RTyzSES7aWahSGbwhkAaN
	TxDB8SyrmWTqXU0rI/BZnk6oCH35VLj20tLe/yldWsYXXjXkuVJGyOOja4XmgxDR+PH+omFMRWs
	ooB0atDhdnb+KhBGyasZQvNop9XtecBiO8sj5PRsKrpbk9cdMEi6SYUrw3OseWXi4KMcFA==
X-Received: by 2002:a05:6000:26c1:b0:3a3:7ba5:93a5 with SMTP id ffacd0b85a97d-3c5daefc4a3mr930341f8f.26.1755843874919;
        Thu, 21 Aug 2025 23:24:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkMOIqwJnbz0zMoKzv9XjVteH9mRf82hflWECX8mqHGwhCkTy10DA8QnyI2PcknGc6Szk7/A==
X-Received: by 2002:a05:6000:26c1:b0:3a3:7ba5:93a5 with SMTP id ffacd0b85a97d-3c5daefc4a3mr930326f8f.26.1755843874452;
        Thu, 21 Aug 2025 23:24:34 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1f25c.dip0.t-ipconnect.de. [79.241.242.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c6070264fbsm1198544f8f.67.2025.08.21.23.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 23:24:33 -0700 (PDT)
Message-ID: <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
Date: Fri, 22 Aug 2025 08:24:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
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
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22.08.25 06:09, Mika Penttilä wrote:
> 
> On 8/21/25 23:06, David Hildenbrand wrote:
> 
>> All pages were already initialized and set to PageReserved() with a
>> refcount of 1 by MM init code.
> 
> Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
> initialize struct pages?

Excellent point, I did not know about that one.

Spotting that we don't do the same for the head page made me assume that 
it's just a misuse of __init_single_page().

But the nasty thing is that we use memblock_reserved_mark_noinit() to 
only mark the tail pages ...

Let me revert back to __init_single_page() and add a big fat comment why 
this is required.

Thanks!

-- 
Cheers

David / dhildenb


