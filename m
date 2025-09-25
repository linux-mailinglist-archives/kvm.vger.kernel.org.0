Return-Path: <kvm+bounces-58727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C920B9E9EF
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D56B2E81DE
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4453F2EB5A3;
	Thu, 25 Sep 2025 10:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G/ShVimb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1592EA725
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795943; cv=none; b=PBI/+hwWF6L3hj7KrKjDVvziEEpmyG936HF071tMXT/J9zPj/WxfT6FAj7pI+13kO5rT6XEgYQ3smJhO4pdF9SGuhn44N3S3sSKDV52k+ft+gFob9VL8yMKj3qrQIyEdzGEIdvdseNND1an4f43yH7723VQz7F5BXLFzH+nkpk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795943; c=relaxed/simple;
	bh=GYQJoM3ZAazrBQGynd1dKgzd+tbmzy64EH8nekL+uZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rQz8MwYmuLAd54Lc//LFoyOhX6Q7cKB0OjaXAFw4zOCQT+fdrra0Q2hLFI/8qd4oUvCqJqi4NH4Bh6V/rWN9IeU61aSeTEBrjcMP4j0dMr8QEvrGx3eEDpZjTi30CjF1EqZ1Vf0iRuIoB7+er1HyqQRrnyuaN+F6zWK9TRwhqmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G/ShVimb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758795940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yn7KtJOI+OoVL/g0bXoboAmrO1BBc45RKDhcTRih648=;
	b=G/ShVimba/c52dY+NgvHeOhf8y/cIb4k+bjYOgi89SZvuAkCjDd5iCt+SFI1saYVjcLKJB
	evZ8qCkdMaIW3t0+vSv3UEB6Mr8I5uY5CAe1llTYKv2wZMgiO7TX3T5UoQHf3GNnF/x6DS
	4LLPMgOG1D949AGGILnTQemjkFzAhaQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-ybRUIlYdPnWJmc_PMZp2BQ-1; Thu, 25 Sep 2025 06:25:38 -0400
X-MC-Unique: ybRUIlYdPnWJmc_PMZp2BQ-1
X-Mimecast-MFC-AGG-ID: ybRUIlYdPnWJmc_PMZp2BQ_1758795938
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee888281c3so649977f8f.3
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 03:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758795938; x=1759400738;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yn7KtJOI+OoVL/g0bXoboAmrO1BBc45RKDhcTRih648=;
        b=mQ9GUNojxBSJIJoZx9PQ0YEc10cQZjXgutzicAu0a9vJxd2V+eVGHDuWIY2h+J3Qxr
         ovC/CXjzJlEabNXnBRPhP90KwGVYcaqmcId+Hjr154SteK1NG2ggHEPHccn2V3TvYVV2
         CiSrzyonPEfoGXOZx26RSAdC1mP0Sma995MgvkuHR2ZFapeE0+Ak8UnYm7WPTZI1ob7n
         ZIIZJLA/iLYB6LmWvRlJintpQAk1wb3RI2GxxnRtWlkUJr6EqP721zFhfIcYro9z1IhC
         mNQe7AHnIH0Nel25fd1SfOX0SOWnAR6k27KTulscmpLm3Wdiktw6RRgPhbQrH2ObG6Zt
         /b+A==
X-Forwarded-Encrypted: i=1; AJvYcCU5+ooGK+3+9pjc1tdGCLFK4aRKsGvYVgbxY2uoxXo63mvGwekb4SWvB4u3nnd05jXEffo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNcGcVuKs2knHOBMquSfpLVdnOGsBBKYMeIfRFmlnlIBgAZPxw
	G36jdYJlqt04Zq2siUR6Nig1N43nLD9NQO13oNze9gTturK8THxCCj8ghyBv34YjRUWHYnGJtkD
	kt1dgziDV4xRYRezooRnmBnfCFhg7EyvxcQOJkk3JkWie0cFHSaiVIw==
X-Gm-Gg: ASbGncvYA95w+/pT+thwp1kmWeHKoapSvxfGfC6+42sOPgUj2LgEUSgQyDyjuGyp0Ov
	7pGn5ZAlz5flh8wxZHvUyzX/tmv68NO9i+O/MSHqCP3LLwWqlhF+uyGlypltU3Hm6hnQ5qTPwqf
	7E57m10NOLFabcLCRvEH53873wmyeHdmtQx2TDLyT+WiRDsYBIbU5vbnhI/pVw6VdeXzBsFPbBS
	8tLP1vM6en66RxLiUeFunUI7k35AYd+gWsxmDx5yM4pBKCV34eOvjmhREsiP4OCg2LtFL+PY4do
	OLKo8K5Qazs86qoYG3DC3+89JbyXKhFRX1b02ZyDsWjJCwsyuHK9mZadoUaPbROXAhRcjhDjiQs
	D3kZdK0tjhjUNhuZyzDvArPoHshX5YKE1sdHSdXIEpF2PGA9DxpypAEwXwlyDx4E7KSKC
X-Received: by 2002:a05:6000:22c2:b0:3d0:b3cc:c1ff with SMTP id ffacd0b85a97d-40e4b85109emr2653265f8f.39.1758795937469;
        Thu, 25 Sep 2025 03:25:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMY43SbBeTDqux7xNDlX/ZIG3DX+wQZ2EsWj+CndB3u6o8VAseXEawq3c7JdiIGuveFjJLZA==
X-Received: by 2002:a05:6000:22c2:b0:3d0:b3cc:c1ff with SMTP id ffacd0b85a97d-40e4b85109emr2653200f8f.39.1758795936721;
        Thu, 25 Sep 2025 03:25:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e330d1d2fsm14556705e9.3.2025.09.25.03.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 03:25:36 -0700 (PDT)
Message-ID: <c8259ec7-e31d-4771-96f9-e2fb6b573e85@redhat.com>
Date: Thu, 25 Sep 2025 12:25:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/12] mm: introduce AS_NO_DIRECT_MAP
To: Patrick Roy <patrick.roy@campus.lmu.de>
Cc: Patrick Roy <roypat@amazon.co.uk>, pbonzini@redhat.com, corbet@lwn.net,
 maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, willy@infradead.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, song@kernel.org,
 jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, yonghong.song@linux.dev,
 john.fastabend@gmail.com, kpsingh@kernel.org, sdf@fomichev.me,
 haoluo@google.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 jannh@google.com, pfalcato@suse.de, shuah@kernel.org, seanjc@google.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org, xmarcalx@amazon.co.uk,
 kalyazin@amazon.co.uk, jackabt@amazon.co.uk, derekmn@amazon.co.uk,
 tabba@google.com, ackerleytng@google.com
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
 <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
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
In-Reply-To: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.09.25 17:10, Patrick Roy wrote:
> From: Patrick Roy <roypat@amazon.co.uk>
> 
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present . Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
> 
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
> 
> This drops a optimization in gup_fast_folio_allowed() where
> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
> by default"), so the secretmem check did not actually end up elided in
> most cases anymore anyway.
> 
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---

I enjoy seeing secretmem special-casing in common code go away.

[...]

>   
>   	/*
> @@ -2763,18 +2761,10 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>   		reject_file_backed = true;
>   
>   	/* We hold a folio reference, so we can safely access folio fields. */
> -
> -	/* secretmem folios are always order-0 folios. */
> -	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
> -		check_secretmem = true;
> -
> -	if (!reject_file_backed && !check_secretmem)
> -		return true;
> -

Losing that optimization is not too bad I guess.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


