Return-Path: <kvm+bounces-56435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 625E0B3E1B8
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 616361A8203B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 11:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE30231DDBB;
	Mon,  1 Sep 2025 11:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oi4kPtKW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E8B314A96
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756726516; cv=none; b=XJYutAq2UOa0+QEqolVcb2+ewEbCVcwbtxJtd98fAU3usAq1U4FInk4gE+pYuRZ4A0Llgx2y6IX1w+28qutV6NgyewjQc2slU0rThE9v4Kchxcza+YnNspd1mbc9it/ay7HpUeeQBSVxwQI8YYO0jqmYHK/WaBc9fbVTPiUXPFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756726516; c=relaxed/simple;
	bh=yAPERDIoeRASAaUpYs1LNdA8p7G30Qgz6mkvFlYbF3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=moGmSBez+qMH+pgGHmOdt9TK/lt7qci6mEwI1PdXekhNmx0KNyArtjn4hTzv1Ya3ehJF7840x+tB6CHJFZvmLhfd4sRGb0AonaXQey4kHxEXlsJR5s0j9p9gbqqXz+ZBw9dQuqFLQIHYM1o0bVOA6nRNP3KR3ZUMAALFkSvgdpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oi4kPtKW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756726511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=89QceRiDVJR9qzpuoMtjZ42nHjE3zxx93/plzyge73k=;
	b=Oi4kPtKW6msMclc99VeFrwikaUAGGqFo1qJnSWm3pfX32GugEguMEBTt/RA9KGrQE3tb4j
	YtiYW6OJ1Nf+URcS2bvEOvL21+u3d0ZwUU+NiPfSgFJGlqRVG2YtLvYkpcs3/KyhMvLVUd
	76BrqD6X7mJLnFX2+Ua8oSR8rNiVpn4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-uLwT86m8P52oyugEczJULA-1; Mon, 01 Sep 2025 07:35:10 -0400
X-MC-Unique: uLwT86m8P52oyugEczJULA-1
X-Mimecast-MFC-AGG-ID: uLwT86m8P52oyugEczJULA_1756726509
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3d48b45fad0so881954f8f.0
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 04:35:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756726509; x=1757331309;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=89QceRiDVJR9qzpuoMtjZ42nHjE3zxx93/plzyge73k=;
        b=PGUXee1VmpPqJglXBOFK7v4Jftapta5LQ6R2WYxQrOvofVXb6b0A1qyEWdLSS9S2Po
         jIggSJ/xR2xXfCIh+159NAvHgp2yrXWe6t35WnC9/LGlvrBEZbQKnkMFMhH8sAsCn/h3
         5scyX3ENi6PSxNrzdy2OWu9sb7saXOq0+AIk7ammN5EHCw2Hm1sUDev9vRCFShkDgaLP
         282kCF1yr95uOOVSdoioSYLCAa4TZ9rOiO1ixb9C2EfZQptTanaLc6fRfJxyo6VwWCBm
         jvtootai37RcfModyvfW/ynfSba9QgxzTxb/NtnL5yYFO2L6CJAqrYgMQBqhGaDaF5ng
         j1Cw==
X-Forwarded-Encrypted: i=1; AJvYcCULtWn4xp/DfBCf+3K/a7gbF6AEBwh0OppekIXsz1WSF9/wFeOoysEdKGXP+l8FVCfwjvI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg6GMEHm3nN3JJ4FH9R51seJNLeT+3wDqhSJk/MiWpfSelU8or
	41mCkSy3DNF4PDpGaYHW3tWOE8o9c4DUXDpU6gWuAXTt5GixlZSKHh2hVx/TFEAbI56UYcZS8uh
	qyW+OWJBl/me19kglsHvj9OZxj9xOsAFor8eZkgRVdIcUe3S17/iS3g==
X-Gm-Gg: ASbGncu3UlCGulcgYNCtspNHMeHaUGMneA1x6+TcxgXAfDEF68cD2lxFy8q1TyxoNB0
	eJCzLI5xugJroq2YITDeeDiqOpanf6SoTGcq9cPb9dS21Tjns9ANxpv6k1wyRWhKq3ns3GT850g
	CVlD0l6IxS9pkOHwQXdVd8FRi7Qy6ScCwws0SPVqivNNdjxJ7SsSHivL8kjd61E+Au9iU9vm0zv
	0Iu6w3/nbWpPpKfVZRpZQaR6xkZw4S9iqxKbsPJDAvAwgrkLtt8YOfjqMTvNB/lhW7+S9o0F/YW
	qJhYCW4oTYK8nlw4IpYGis9pLEhbTeWJCbG5FfjFBBjNrsU+cCHpSAyedL6COXqGyzLJnwxDppt
	kYqlJvOj9AwPJnc1cGsGBhqPW6ZnxYU4pEbQNv/5iyDcW12d74Q5u2CqBwUchCi4mPlI=
X-Received: by 2002:a5d:5f8c:0:b0:3cf:5f17:f350 with SMTP id ffacd0b85a97d-3d1b16f0165mr6056371f8f.18.1756726508771;
        Mon, 01 Sep 2025 04:35:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0RKJ8MgbrMGxtF+aataA+fh1iSiigcyDX0AK/3/6NRoLPIE0BwSmxJshAaTyrpOEmePBJCw==
X-Received: by 2002:a5d:5f8c:0:b0:3cf:5f17:f350 with SMTP id ffacd0b85a97d-3d1b16f0165mr6056350f8f.18.1756726508320;
        Mon, 01 Sep 2025 04:35:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm233831875e9.5.2025.09.01.04.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 04:35:07 -0700 (PDT)
Message-ID: <44072455-fc68-430d-ad38-0b9ce6a10b8d@redhat.com>
Date: Mon, 1 Sep 2025 13:35:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 18/36] mm/gup: drop nth_page() usage within folio when
 recording subpages
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
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
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-19-david@redhat.com>
 <c0dadc4f-6415-4818-a319-e3e15ff47a24@lucifer.local>
 <632fea32-28aa-4993-9eff-99fc291c64f2@redhat.com>
 <8a26ae97-9a78-4db5-be98-9c1f6e4fb403@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8a26ae97-9a78-4db5-be98-9c1f6e4fb403@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>
>>
>> The nice thing is that we only record pages in the array if they actually passed our tests.
> 
> Yeah that's nice actually.
> 
> This is fine (not the meme :P)

:D

> 
> So yes let's do this!

That leaves us with the following on top of this patch:

 From 4533c6e3590cab0c53e81045624d5949e0ad9015 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Fri, 29 Aug 2025 15:41:45 +0200
Subject: [PATCH] mm/gup: remove record_subpages()

We can just cleanup the code by calculating the #refs earlier,
so we can just inline what remains of record_subpages().

Calculate the number of references/pages ahead of times, and record them
only once all our tests passed.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/gup.c | 25 ++++++++-----------------
  1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 89ca0813791ab..5a72a135ec70b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
  #ifdef CONFIG_MMU
  
  #ifdef CONFIG_HAVE_GUP_FAST
-static int record_subpages(struct page *page, unsigned long sz,
-			   unsigned long addr, unsigned long end,
-			   struct page **pages)
-{
-	int nr;
-
-	page += (addr & (sz - 1)) >> PAGE_SHIFT;
-	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = page++;
-
-	return nr;
-}
-
  /**
   * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
   * @page:  pointer to page to be grabbed
@@ -2963,8 +2950,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
  	if (pmd_special(orig))
  		return 0;
  
-	page = pmd_page(orig);
-	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
  
  	folio = try_grab_folio_fast(page, refs, flags);
  	if (!folio)
@@ -2985,6 +2972,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
  	}
  
  	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
  	folio_set_referenced(folio);
  	return 1;
  }
@@ -3003,8 +2992,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
  	if (pud_special(orig))
  		return 0;
  
-	page = pud_page(orig);
-	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
  
  	folio = try_grab_folio_fast(page, refs, flags);
  	if (!folio)
@@ -3026,6 +3015,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
  	}
  
  	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
  	folio_set_referenced(folio);
  	return 1;
  }
-- 
2.50.1


-- 
Cheers

David / dhildenb


