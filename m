Return-Path: <kvm+bounces-61186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB41C0F351
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:16:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 215B7189E645
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C836F31353E;
	Mon, 27 Oct 2025 16:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GbKIsKs4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11034313268
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761581728; cv=none; b=uNxfzZKCpzloXM6URoAcHbV42UR6EOsyONSluGUk9sHBs7yLeB+oqNzW3i15Z5vbHAG5RMM4D07+mXe1p6UHCrb5WXXtSdRjUsu8bM4Vnr9Fmp4KsmqJv4YcVXB86yc1jlXaq1fRzYOhypheChoRF77bwDLsTARuyW2pWQqe/AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761581728; c=relaxed/simple;
	bh=Y/sGhF7eaQExABxacuOsAJfmcL9WiA4+mWaQYTzpGvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l4L4kMPOF6peiKD0d9Temn6605LNFO6fb1aK0kY8vTWci8SaJT87RH27UTpSbOTzoSBOnpcBeYXCSTY/8WZcFpU+cxXMY2EDdgERH23jjTg9gNfCB3ULQO4XmHLOeNbwSUzLh3YzO+oV5w4lL6bhaGRwFDYMJ1OhiGZKCdgPLok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GbKIsKs4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761581726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Y1mHiJVhO+VjbMfqmTXKhoVt8EjIjofOvtpC7RQVTFk=;
	b=GbKIsKs4vt6SBigPjYpHDY1tQ2x4suaTfRw/U/lkZg6A8enCgf19H5XTDA6VP0ldo7hWC1
	8AqIq/aZzJUH0vuMQ2WdJe2WdG/BBoXXLQEQHJxU04oPr8xDA0W0i9EMNdTQJoG2nkTse6
	1wuPzsOtqF5hj6fbI42auFruRwv5iYo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-JIaCtmgoNnazoLyigbMOHg-1; Mon, 27 Oct 2025 12:15:24 -0400
X-MC-Unique: JIaCtmgoNnazoLyigbMOHg-1
X-Mimecast-MFC-AGG-ID: JIaCtmgoNnazoLyigbMOHg_1761581723
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso25456865e9.2
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761581723; x=1762186523;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y1mHiJVhO+VjbMfqmTXKhoVt8EjIjofOvtpC7RQVTFk=;
        b=twZr/ZLpQxQrFlypXOYzSeiICVTgGWbt0k4brD/jU62pDBTPr7DDcYnrSS5fr9Bq7r
         Xfr8wVfZ+acNgWdQ42L9wH4QLxjkqGCFOjVg9LQA9/yCClLCff/B06y8UmAH7UVEwgIo
         uBKnJfKoTwYyrYhEOvo4wNJg76bLr+6jXPegChHeZ9WexoAkfOI0rHNi97apjTWH/Ekc
         9BxoB6fMLWwg9UilXAldZT3XMVufMQEfX1F0M0Ck2qf8xrg5dpUQeGC5REP9FfZNS93/
         kPIBgXbYyV3VANa0BG4O1AMtsmBLkyrgHeLjT8Km1HfnA0mFxISNr/9dasVW4fRBBmbA
         RXMA==
X-Forwarded-Encrypted: i=1; AJvYcCXxIV2Q6/g2fqO7cix/b2PaiZAQZt3NpKiDRXwa7w2hU6H/e4+rBA/3D7YryzAjxZUua4s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn3yom99T2FNgsZkJtMz/yrRkPc/byfWR/LcT8rVxtBVpujBMI
	BEqGnnK4na5NHZqEt+kZHqYnMoTGl/qQoNYPsDMYIPB/4THtx05KucvPdvfzUHjiYHGHMzfOyO6
	TDoCNmpstuNmIj6fnZrifFnZuzw+3mq7hkVlEZeepNDuqh6lRYqSvCA==
X-Gm-Gg: ASbGncv09nIEAxmevXYhKh8wm8175v+z8bHImHw/YoBba9sGyvwW9v/rYeuaOBXYkLf
	N6H6TkKbYePTNKe12xQU/yaFWPVY/R8cCGUBNBPTGWwxRMRjBZIF6J3++b96GPFyrjJSzl614xM
	hTxCwV5m1V22ji5SQgOKD28InPzBvmkp+n0REhz8NoaNw29LPTAoaAcqnsCJJjoXLJsS64g/TUJ
	RyZL8AfxOsgeRiC+cOF9269+r7KwVusN/1pXPLSPohLIhE1NhGteJY4Av4jA+T93xchyKvL7DVy
	T22mxeyaVmgyqweKEqNKooqi0pZ0QE6Unip6V5yW6/FzvrZXBAscm5xI9+VLAOEzhW6eO+X/3JQ
	RPKojOge3bLKUecAES0t/JkTkYcsvYsIRDpHFhwWrgGzr2ZoJx/i3lY7F/1uoygCPaS6Gpb04gx
	UWj/Cg9kyALlsB/m0ftZSLpkshQP8=
X-Received: by 2002:a05:600c:8b30:b0:456:1a69:94fa with SMTP id 5b1f17b1804b1-47717dfc627mr1792125e9.13.1761581722848;
        Mon, 27 Oct 2025 09:15:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyCGbC2aHxxDVeGlz+puR5Je01gbqwwjxfThnaNAQY+WhG+9Kt2kQaSj/jxsx1EWiCDG1sjQ==
X-Received: by 2002:a05:600c:8b30:b0:456:1a69:94fa with SMTP id 5b1f17b1804b1-47717dfc627mr1791545e9.13.1761581722398;
        Mon, 27 Oct 2025 09:15:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b79absm14855116f8f.3.2025.10.27.09.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 09:15:21 -0700 (PDT)
Message-ID: <c4a9af3d-498d-4b4e-957d-a5cab0caca79@redhat.com>
Date: Mon, 27 Oct 2025 17:15:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
To: Jason Gunthorpe <jgg@ziepe.ca>, Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Leon Romanovsky <leon@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Pedro Falcato <pfalcato@suse.de>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F> <20251027161146.GG760669@ziepe.ca>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251027161146.GG760669@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.10.25 17:11, Jason Gunthorpe wrote:
> On Fri, Oct 24, 2025 at 04:37:18PM -0400, Gregory Price wrote:
>> On Fri, Oct 24, 2025 at 09:15:59PM +0100, Lorenzo Stoakes wrote:
>>> On Fri, Oct 24, 2025 at 03:12:08PM -0400, Gregory Price wrote:
>>>
>>> So maybe actually that isn't too bad of an idea...
>>>
>>> Could also be
>>>
>>> nonpresent_or_swap_t but that's kinda icky...
>>
>> clearly we need:
>>
>> union {
>> 	swp_entry_t swap;
>> 	nonpresent_entry_t np;
>> 	pony_entry_t pony;
>> 	plum_emtry_t beer;
>> } leaf_entry_t;
>>
>> with
>>
>> leaf_type whats_that_pte(leaf_entry_t);
> 
> I think if you are going to try to rename swp_entry_t that is a pretty
> good idea. Maybe swleaf_entry_t to pace emphasis that it is not used
> by the HW page table walker would be a good compromise to the ugly
> 'non-present entry' term.

Something like that would work for me.

-- 
Cheers

David / dhildenb


