Return-Path: <kvm+bounces-55618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 201DEB34476
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C7B12A70CD
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 14:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3C22FB631;
	Mon, 25 Aug 2025 14:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R8kCcC1e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2A2288C39
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756132692; cv=none; b=FttkQsamHAIouyf+OyrtBuDgN3IR8XXSgh1FerIoIxsSja0deBAsKXNM4ZycQD9kBthm+k8kYMCfBstL3i637L28LYhXjwHWcyXaZyTGdWv3dwLxxo2wUeeTrD38XoO4b05pflfufPcJb/XkJisk2TTKphlX9/1+00HNnG05Fls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756132692; c=relaxed/simple;
	bh=TwEGdMJ02/Thp7fjKDeGa7zfRw1/IePVwKEQmR37S58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=up60S3Jwx46oBpjpKfYAYxO6qJCJizDBS27G2Gds4PDCRsu40iOIBZFKK8ukevFl08OVQTgT+0hW+0lZx8RnGsxNOtH/QqxMHAwiHqULkGemsIislkaR0fuh5Q00hHaQgmKBKe4K6z66pXo5yKtTlHDCUbP3Jwo228AN0yiGLfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R8kCcC1e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756132689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S1b1Qn5IdFgoYphqgj6hBBswyK4CJqNFMjotKKBhPlQ=;
	b=R8kCcC1eo7h+yrPuE7HTxudvT1jCQvLeEZ7xlaWUIWinsunXhNmpVKIYCyw1m/IirBqDdB
	pxg0F37ueXlI8PjtvFvgv3NSg+kH6QYASNtaNId++Y5VlvVoJ5H6DT+rUpa6SNtslpOsN3
	ZqqZ+ErwLRjgTnOgiTf6BgTtN7Qpeeg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-ri_yj5qiPvG0ucagLiC-eQ-1; Mon, 25 Aug 2025 10:38:07 -0400
X-MC-Unique: ri_yj5qiPvG0ucagLiC-eQ-1
X-Mimecast-MFC-AGG-ID: ri_yj5qiPvG0ucagLiC-eQ_1756132686
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3c8406fb4b4so1457553f8f.0
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 07:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756132686; x=1756737486;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S1b1Qn5IdFgoYphqgj6hBBswyK4CJqNFMjotKKBhPlQ=;
        b=FD7VQQZ8a2Z3v6ZmxCz9aoLEEYUqHGV6TeUv29Ii1UN/jnKofF67AYigWPy9bGplao
         nkHlTSp5BCpgI8cG8OXM7perIDSUFVZNE8Vi6pu+Ua/pWZ8SQ5Y8c2ECW1e65irJwYly
         HLOuBALkRSsvV1jbXlqGjxgp1R5YLzwDYrXujlSTXJ3Qg3OERWWqUfYHWeqPNgQD0Eso
         G20qXy1VHnqzyEQMoXVnMQL5C9W670WpCzSaeG9FTHZfYJE4XQ4g7f7aRUSxYV/Z4cMt
         mye1nrrVh41BDTg+emKNRbFassrlRsRAIhdV3zkKxRn7h6fjvnYQPooaFRQ9PF35ad9N
         PsXw==
X-Forwarded-Encrypted: i=1; AJvYcCUI2gUE/vfjyjgQK8Q1+6SuhTBnpN7io+NPi8zqcM8hEmM1OgPhV/Fp/cR6hBuNsh1YgT4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQhBOiEXWaRXtN24qvshE79M14nsLcagXY3BXcOL/kLEiCX5q8
	g85EH2Lgd0QkabvOCrziT1USAmxQFhU2Mkv8ub49SvkwL8stnhFkyDgU3RgOzmVWn1WKBD5Ihmr
	lVmbSx466JAuDc3GVaRErX9nAJ4R8Oz6UZL9A+IMdmowPln96QSEcbQ==
X-Gm-Gg: ASbGncsdUy/y6s9y+6Otx25WxG/6S+R/5dI7U0RUHastmdNsBVlQJ7AfjmHFos8//sh
	8czbKw9cDbVi147vmb86dqUZlsPHhJB92aqgoup0I5k++p5rqk7wwU6srBfFkxkM0ESdBsEUByM
	qwZjN2q7ZpsoezJ7jC7jaK2lwYLiW50mo2V7f3xV7lyuareQk20fN1rR1OCLQJAFzb09ExnhNFZ
	LrBuNeS5QvY48BxRTS+6/YuiY5f5e49kRSGE1EnvvgUqXTDZYxLg6JWXbWxRDGkjTZiS2KMnv2j
	B8SK33hMAsEL1fY/OGrGTl3jiOztNz/pB4X+uuhF4gFKBFT3JDnVrGK9QcTrJCr7PI3aBs/cAt+
	MsIQiS83eV5l+f+5RuDJ55DIt7a10bY2XaIxphIN0HPD10mGtZtoZi075UEmVbD83awE=
X-Received: by 2002:a05:6000:3113:b0:3c9:f8a:f257 with SMTP id ffacd0b85a97d-3c90f8af5cbmr2996352f8f.50.1756132686347;
        Mon, 25 Aug 2025 07:38:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCFvBJRBfcBEdo8i70/6pukUQNYn2Qrs6ZnSbppOdelrrIoC/z5rNFiWI+fX6KVi1Xqpq2ow==
X-Received: by 2002:a05:6000:3113:b0:3c9:f8a:f257 with SMTP id ffacd0b85a97d-3c90f8af5cbmr2996318f8f.50.1756132685799;
        Mon, 25 Aug 2025 07:38:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5744e9b1sm109711045e9.11.2025.08.25.07.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 07:38:05 -0700 (PDT)
Message-ID: <a72080b4-5156-4add-ac7c-1160b44e0dfe@redhat.com>
Date: Mon, 25 Aug 2025 16:38:03 +0200
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
 <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
 <aKxz9HLQTflFNYEu@kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKxz9HLQTflFNYEu@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25.08.25 16:32, Mike Rapoport wrote:
> On Mon, Aug 25, 2025 at 02:48:58PM +0200, David Hildenbrand wrote:
>> On 23.08.25 10:59, Mike Rapoport wrote:
>>> On Fri, Aug 22, 2025 at 08:24:31AM +0200, David Hildenbrand wrote:
>>>> On 22.08.25 06:09, Mika Penttilä wrote:
>>>>>
>>>>> On 8/21/25 23:06, David Hildenbrand wrote:
>>>>>
>>>>>> All pages were already initialized and set to PageReserved() with a
>>>>>> refcount of 1 by MM init code.
>>>>>
>>>>> Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
>>>>> initialize struct pages?
>>>>
>>>> Excellent point, I did not know about that one.
>>>>
>>>> Spotting that we don't do the same for the head page made me assume that
>>>> it's just a misuse of __init_single_page().
>>>>
>>>> But the nasty thing is that we use memblock_reserved_mark_noinit() to only
>>>> mark the tail pages ...
>>>
>>> And even nastier thing is that when CONFIG_DEFERRED_STRUCT_PAGE_INIT is
>>> disabled struct pages are initialized regardless of
>>> memblock_reserved_mark_noinit().
>>>
>>> I think this patch should go in before your updates:
>>
>> Shouldn't we fix this in memblock code?
>>
>> Hacking around that in the memblock_reserved_mark_noinit() user sound wrong
>> -- and nothing in the doc of memblock_reserved_mark_noinit() spells that
>> behavior out.
> 
> We can surely update the docs, but unfortunately I don't see how to avoid
> hacking around it in hugetlb.
> Since it's used to optimise HVO even further to the point hugetlb open
> codes memmap initialization, I think it's fair that it should deal with all
> possible configurations.

Remind me, why can't we support memblock_reserved_mark_noinit() when 
CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled?

-- 
Cheers

David / dhildenb


