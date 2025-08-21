Return-Path: <kvm+bounces-55368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D6CB305C5
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:36:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C71518908D4
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C4B350D77;
	Thu, 21 Aug 2025 20:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ciIX4g6i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8615436CC75
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806896; cv=none; b=QDShTpzAR/lyWCFj6KRYDKIC+wFUCLv/KCg+eJMHJqXPSi53bVGMKEVyKf+em6N7OfWLEPE+vwIAzBLge1IWaVyAtY/aWUdaC5P+6P4u/NUixDa5y0WQbsEAVdmzwQAcBCBIL7COi9TlRBYw2mLwxDzrDQ2UWCu3DX5I9h80KvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806896; c=relaxed/simple;
	bh=35i5s1BcLEONuxohRPeqiFHOreLIpfTF289+ZIXZu/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdCdPVIAf6syfe3JIHpVWlyBZTAl3J0DSP2hqN36EH/WlgghS4m/0PmhVbaZVbx6e6MDhVJXrGwBLGmo7uE8HuBiqnOb4y7rl/MMeOBgrmLrz80VGH4qLapuP7OABZ0IAxrEKGWrzegQq14EUK3JDDsEpgM/U+nu3p0X3BFyrPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ciIX4g6i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
	b=ciIX4g6i//BGOiIYy77+Y2LCADCnTpyAtQwRYdLQhT9b0BGVdkLWx+61HPAi5DBscvcTNs
	sjAVbnPUW7YPn5mkLzG3FnfXPjxAajVehNcZp10XQnqtg+jgcZHacunvTl8sa7kL5fAPv/
	BwfjvRtEFu6yIByUvweX9PEX4iWhudk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-mMWjrSQ3N_uDCp4e7fvBRQ-1; Thu, 21 Aug 2025 16:08:10 -0400
X-MC-Unique: mMWjrSQ3N_uDCp4e7fvBRQ-1
X-Mimecast-MFC-AGG-ID: mMWjrSQ3N_uDCp4e7fvBRQ_1755806889
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9e4f039ecso759585f8f.2
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806889; x=1756411689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
        b=Xkd5X5ThIJMoVocShcNVPUzeHRSBZmb6tP518/X1XNpEWTHps/jOJ0Ts6N5lNC6Xrb
         0tyCgaUnzehOTh7lsWP35tjWwm+V4hLg+HThnlrI7lrN9ueqo4dFaVNMEKXs13dr4SZP
         xmI05A3anKrLKCs2C//YTn9rt4olQmjCW4C/3C2Cm2pOvZHdwUjSMDgL45ROdAVz6txr
         47MRMX+MBPlHdv1dVaRIn3tT4ufiOsfhd0miSRf5wgBqWFuoOZnsXb7N3WLn41G5lRm4
         V+gc31J5kwdDYuzFs4nbemaa6hus+H16Tp/QqT6afvX8x/CIYBbkmYWqUT7DqI5yhscw
         MsFw==
X-Forwarded-Encrypted: i=1; AJvYcCUw8YzYhDUr7KoxZv9ZfvFY7yW/cDOvKLZ5B2hMJgoEpI4mNSULs4Gkmagfqdtxlbw2A8U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya6NgiOTzFOjA5moQiV+DUwbU+zKls9Sei8tR+PoubQEqrNSsB
	Cd/T9YSwlmwRsquQ/FkKl/Eh8xnyHbbHsvpFTHoTXaTZmqmLiGXTUx6d01dj6Ols7KsFuXMBfJY
	Sog2rtB6stn/s8QKtibBZMdcTPoF5k/PX+jbstnVyw8u7dQHg7AGbjQ==
X-Gm-Gg: ASbGnct6cH4AR3VF37YSAbpn4wb/jsGVNMLtwiVK0KqtYhO4U/rVpgZfw2QqKBW/VdC
	jp2nprLJ3Ql+pfJr6aQCS2w1p24W5+uBw4f5qHnbCm71vnlwFSUb+2JpxhJLaerm9nHCR6pRnlk
	vF7iesvtR0FThXXk2D2AGQFM6BLnJAzOpHFMezjMWhu9ve4ZmWkrUHceXyNUaBXrQ0rfl9hSA2M
	o4oQtj7quiNmUn6FyBiOxLQpb8DGpkzfM6U8Nb/cPScb9C6mVWLXLymh8sjAVyFY9L8PE9CJbZr
	9oODYVyl+ysGp/Tu/+2weZMKIYl9jicEdINgWU1olFXJqqpwyBBbtdPAlwGZQti1JMymM++WN3P
	CLTEColE4u94pM4Wcr9HK/Q==
X-Received: by 2002:a05:6000:40c9:b0:3b7:911c:83f with SMTP id ffacd0b85a97d-3c5da83bf5bmr151929f8f.9.1755806888877;
        Thu, 21 Aug 2025 13:08:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeHEkncn914iQLB6IDJFbFllUgyuseH1VcCPvg+Bdgchh7CcvmYDhAXktPsYS0hqHcr6hQuQ==
X-Received: by 2002:a05:6000:40c9:b0:3b7:911c:83f with SMTP id ffacd0b85a97d-3c5da83bf5bmr151916f8f.9.1755806888456;
        Thu, 21 Aug 2025 13:08:08 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b4e2790a8sm21120815e9.1.2025.08.21.13.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:07 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 22/35] dma-remap: drop nth_page() in dma_common_contiguous_remap()
Date: Thu, 21 Aug 2025 22:06:48 +0200
Message-ID: <20250821200701.1329277-23-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dma_common_contiguous_remap() is used to remap an "allocated contiguous
region". Within a single allocation, there is no need to use nth_page()
anymore.

Neither the buddy, nor hugetlb, nor CMA will hand out problematic page
ranges.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 kernel/dma/remap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index 9e2afad1c6152..b7c1c0c92d0c8 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -49,7 +49,7 @@ void *dma_common_contiguous_remap(struct page *page, size_t size,
 	if (!pages)
 		return NULL;
 	for (i = 0; i < count; i++)
-		pages[i] = nth_page(page, i);
+		pages[i] = page++;
 	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
 	kvfree(pages);
 
-- 
2.50.1


