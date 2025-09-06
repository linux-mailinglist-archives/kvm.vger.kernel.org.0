Return-Path: <kvm+bounces-56954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 607B1B469BA
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 09:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C3DE16758C
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 07:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4635E2C2364;
	Sat,  6 Sep 2025 07:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGpHYhHx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2927B283CB8
	for <kvm@vger.kernel.org>; Sat,  6 Sep 2025 07:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757142064; cv=none; b=tdc3KeCdG4h7ggbfe1S1wo5HquSGFjJlTyF0RQukQ7tRS1eXfJPConCuVhGmBMR5hoUaJkQrla1Cf7D52p0wOwSwBbt/lWV+3HA6Hpsd8xK3sRa5XfUnzwyOQZsDM5wLDTSaB2fvSVJAikbPG0GnMV6Vz59AowrivYrn3t2AGWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757142064; c=relaxed/simple;
	bh=IG++ZkBD59wzKHu12fgNu7jyIoQUxrPSNiCWC9IyrGQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=i+jJw84RZWPmNoweb/e90C6QTQ+u59fb1pkP92q7kVwkihZu4T2ZwBNIc9OJYAhsog7wgRwSiGeuaJ+o70y585JoAQM/gpPhEvSl535jrKtQQGPD8QwFl8WYg/UA8xDROE1Bqr4TI82Vu7+bajmF9r0Xs4WVQ4I5CjSJp0+egi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGpHYhHx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757142061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T2JJG+ZfsCIb5mNyWFksWhvinuGju8fueKzmBULEe5U=;
	b=KGpHYhHxiD+7YN+3JLfySWCD7JyAQN3s8PfW4RiZZ9qT9dRIHfry+6iURcKqBrBPRxXdWb
	rXSxYNYPeWOMiXtxXanJGit9pBd2MNdqtU4X89wcEcOUuSM+qI+s3tcka3S09glBbgvt0y
	QDjNdBfQd+6hmiwdej2bcPn8MaAjUPI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-MwR5DFOaN3-41LVaSrWB4A-1; Sat, 06 Sep 2025 03:00:59 -0400
X-MC-Unique: MwR5DFOaN3-41LVaSrWB4A-1
X-Mimecast-MFC-AGG-ID: MwR5DFOaN3-41LVaSrWB4A_1757142058
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45ceeae0513so15736225e9.0
        for <kvm@vger.kernel.org>; Sat, 06 Sep 2025 00:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757142058; x=1757746858;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T2JJG+ZfsCIb5mNyWFksWhvinuGju8fueKzmBULEe5U=;
        b=QxZKshasKz9SkFSuvzFh5+x1Er9lN8tKGtW3wDJv52bHMsC0nsHkYWdBYCu5kL/HXl
         oBYgZLpcIOoKZuV1TliJHCkWpKmjPwCKN9DfzWljzzhAmKmHxMMeCWrBZ64D3WcBOkgk
         h+qpeOO1+LOibZbQVeZGFaHOfT3VChcUXbuCCKzKZBAmnsQ1G1vDV78dhRA+KZ8jetwS
         yY1lue1O2iiUzuzoaOG4jO7nRwG4tD1s/JoOyckTJvk4/mZu8R4BE3SwVqzRF1whJUHY
         o5FUkS4zg56kwD2nyHPOvQTjzG0JF6e4WeGWvfupg5VzUJ3Vh6Vpb1Udrgvs+02Encpi
         MgoQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1wFiKJMi/scVnhMNpIuo59cxD5dqabSONzqFb85n4ze+AXU8uRQdCte1r+iHFuq32/bk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL4m2ql8Ms3DFP8zZzGfAI4QfoEj1GRkKSKKXYf2J3nzvZxbhv
	yx5K72/PM9k3cTc8ibdEConD2xfrHDOQA+6v8zpyKR20F+KBHQ9Bj5NKvzjskGg9fjEZTp/Hdea
	2pMceLjQfBNampIU0VNTwGEl05em+C8cQ9380TDvueDuS1iYeQHKlXQ==
X-Gm-Gg: ASbGncsZ4uACRMyeIMb54gKT3+63yOEgzJT8q7nVElmbAss3kz4TaO43Fa+LxHosG/y
	6vLXHA4vW5e+lCDAGDcIdFANulbnzz2BZtIUf+BMKjG7ydTURe+5omBzWTAMRalWpyZotcGGhCF
	1RukRxREgkC+ZNFJmX+8xU84TftlMfhi4gYfaauHBFqSh+MYjEQFfYkzh6db4/iee5k4vVG2R+d
	j8hunXQ+JHVgfJlSWOjcZ5BSdBvWAQXIssA6zLAkgZz3JyaNU3a+Zr9chRApu4Ee8cXiY2TMyv/
	7juweNg4f32Dt+3m8+zhAQNNddzci6k/vrCeIYOM+p8H0eA/cGTcvRKrotoEmJIFUgBiU5k9Y4T
	E6XimclWsF2NY/Do+zVC2OGCakc7fuvMEfh9F6vc28pyqAzNS541NewWetc2hQUMr3jo=
X-Received: by 2002:a5d:5f87:0:b0:3e2:804b:bfed with SMTP id ffacd0b85a97d-3e64c1c2183mr835311f8f.42.1757142058513;
        Sat, 06 Sep 2025 00:00:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdr4VmZX14HWt6vWJrgVQl61309Yoz3EBz+B4BvfuTuYDfgHO59nfbR4v+s7YipRZZX7VN6g==
X-Received: by 2002:a5d:5f87:0:b0:3e2:804b:bfed with SMTP id ffacd0b85a97d-3e64c1c2183mr835230f8f.42.1757142057809;
        Sat, 06 Sep 2025 00:00:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:de00:8132:f6dc:cba2:9134? (p200300d82f30de008132f6dccba29134.dip0.t-ipconnect.de. [2003:d8:2f30:de00:8132:f6dc:cba2:9134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67fsm6794555f8f.62.2025.09.06.00.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Sep 2025 00:00:56 -0700 (PDT)
Message-ID: <815cbde4-a56d-446d-b517-c63e12e473de@redhat.com>
Date: Sat, 6 Sep 2025 09:00:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
From: David Hildenbrand <david@redhat.com>
To: John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
 <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


>    	pmdp = pmd_offset_lockless(pudp, pud, addr);
> @@ -3046,23 +3041,21 @@ static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
>    
>    		next = pmd_addr_end(addr, end);
>    		if (!pmd_present(pmd))
> -			return 0;
> +			break;
>    
> -		if (unlikely(pmd_leaf(pmd))) {
> -			/* See gup_fast_pte_range() */
> -			if (pmd_protnone(pmd))
> -				return 0;
> +		if (unlikely(pmd_leaf(pmd)))
> +			cur_nr_pages = gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags, pages);
> +		else
> +			cur_nr_pages = gup_fast_pte_range(pmd, pmdp, addr, next, flags, pages);
>    
> -			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
> -				pages, nr))
> -				return 0;
> +		nr_pages += cur_nr_pages;
> +		pages += cur_nr_pages;
>    
> -		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
> -					       pages, nr))
> -			return 0;
> +		if (nr_pages != (next - addr) >> PAGE_SIZE)
> +			break;

^ cur_nr_pages. Open for suggestions on how to make that thing here even 
better.

-- 
Cheers

David / dhildenb


