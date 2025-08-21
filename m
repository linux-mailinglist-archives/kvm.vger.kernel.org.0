Return-Path: <kvm+bounces-55357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C82AB3045B
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABC781C838BA
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7130F3568EF;
	Thu, 21 Aug 2025 20:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GWQD252Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1534F460
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806869; cv=none; b=s4tagFobovWEcfzo36YDM4LhORnNTAXvE4nAxLWMeag7pAHsoP7a4aqtbo0l/6NzJeiv7BJEGeFAQ5ZF0E5nmTI9db0FDDLbE9gk4qbgb4t2Y3pnwUS2J02/yxwgPC7IrL+horRS2JR7MqFqn6J6w+hh+yzoPThBmLy0S/z2Lag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806869; c=relaxed/simple;
	bh=EbcdXL10oBVSBHmjJHKvKh3MpEtOuUSNb7Ges4yPKyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7pvQpQwD3Jhjns91cx5cd36MSD2/f+b/0W6HFiTwWimLM4ZKvl/fzAaoWiQF502/W7xHLDq+B1QGSFczWBFQVOo47dSo4dNjGB82Kj6kgdQ1FyP0Lb1CX4h0SNtcWShGXiw17pmgpaKRVzNfev6hSwT+Nz3CvtoaJq/CJLpF6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GWQD252Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+ehuLujhp6/6Ui8/ETipqTmnVB5w2txW2o3jJCUzuY=;
	b=GWQD252YW1xskLpxjlgunQMzP+SElCxoWkxDVMAL1iMwmwNoz3tT1Yg6kNCY3oMbGrQN1I
	Ca6JiNxLs7LraD+nwFXwpWkrVUyz+m5HeMbbKUHl4yPEqSw5+HVjEaGRh0ecwA2YgYWm7o
	gsjgC1hriGIavuiQKq0dox7eiIsVvR0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-pIbPQlkZNeGzr31QKHySpg-1; Thu, 21 Aug 2025 16:07:41 -0400
X-MC-Unique: pIbPQlkZNeGzr31QKHySpg-1
X-Mimecast-MFC-AGG-ID: pIbPQlkZNeGzr31QKHySpg_1755806861
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b00149cso6294525e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806860; x=1756411660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+ehuLujhp6/6Ui8/ETipqTmnVB5w2txW2o3jJCUzuY=;
        b=iVSOAAJXtlOue7qSJu7PU7sceoby028zS7Cdaz1T4L2w6lKkxL/zTivxrVrrZNXJGz
         CCiJ+dpvsBNyVYZ/m2HXEEEPMzsiKolSk3cbYVURsYm7TSAddp0CZVE2gxm8zQ0x7+lz
         f6kxfoPb80Hqf9BfzPLgV0EYf7vIbzeZV+7c6EaNTiETc6rogoPfNFk1/s8vIBZDnrny
         tKJgAPKJnslgIJdY3AveNjYyff/cuZKmfPWvks3+jgjIOHaIo6RmP5Uv0w8/onpmR3i+
         n5WooeALGKPv2tq8R4JkP22RrQsQ7T4NU7LukJ0+Tg3pxSZRxH9m+tB9iAb6x+SfkDRv
         U7DQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/4z9hR6rPq4vGN5WYTaK16I3C2buRSaJWD4/2s3n7LVqKOWieLeDB0UGlFxAdTAV/59g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yygm6n/hrVyeoMTNEqumKgDic6Hm3N0QAmuNF+3Ng+ZWZLdo2oE
	hZ5jDbz/+4v4X9KjPnzg/nfyqzuYMWI8yp0Fe80CNSSgcCeloCtwqLVnVfaAtdHTmTmnBJTyytG
	9kfAtMORToJNkXMeBkErrDipcnFnW8vZpacnIq3H6wvU/p86WLk98ng==
X-Gm-Gg: ASbGncuH+zx4I6UiFVCU0rpPZWLEZ03vt/Nhtk8/r4SiToWfrjIH5TBDem8lpvKaugQ
	+l50PB/lEifP1ZV9fe/jDzZ0umAKZ0oMzH5dsP+ZxNCFmoA/9PQd9QYOyOPamGQ78RZLNV6F7QD
	QPrsBCP+jQqqMlqUS/648DFhrJGp6rIc8LnAvQGfbYx0IrZqbQEh8VIKL+JZ8sUIvi8xJdWeE42
	n/IMef1jeJcOZDget5QHVTQGfwVOa/aiTRuwXvWH1UJGTqb+YQU0BQjcCHkUH3kaZUrjGs3ZR77
	NIxDE40N4aOxMR4uPPoiAPbQ6/3I2WtYKWLdHvDotG8+TNQnpsORFF9/zDA2eO6p9LWypcD07yx
	BjZt+NJHjDEwjMpDi0eL7Ag==
X-Received: by 2002:a05:600c:19cd:b0:458:be62:dcd3 with SMTP id 5b1f17b1804b1-45b517c2fc0mr3573185e9.17.1755806860569;
        Thu, 21 Aug 2025 13:07:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrtwXyk8M0MMGhBsDq6sn2/zjKB5pcui5JGSP2GUX5VAX4EhNVsrp5ZVJRMStvpa9W7AdEeg==
X-Received: by 2002:a05:600c:19cd:b0:458:be62:dcd3 with SMTP id 5b1f17b1804b1-45b517c2fc0mr3572545e9.17.1755806860106;
        Thu, 21 Aug 2025 13:07:40 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a52bsm8600375e9.21.2025.08.21.13.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:39 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 12/35] mm: limit folio/compound page sizes in problematic kernel configs
Date: Thu, 21 Aug 2025 22:06:38 +0200
Message-ID: <20250821200701.1329277-13-david@redhat.com>
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

Let's limit the maximum folio size in problematic kernel config where
the memmap is allocated per memory section (SPARSEMEM without
SPARSEMEM_VMEMMAP) to a single memory section.

Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
but not SPARSEMEM_VMEMMAP: sh.

Fortunately, the biggest hugetlb size sh supports is 64 MiB
(HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
(SECTION_SIZE_BITS == 26), so their use case is not degraded.

As folios and memory sections are naturally aligned to their order-2 size
in memory, consequently a single folio can no longer span multiple memory
sections on these problematic kernel configs.

nth_page() is no longer required when operating within a single compound
page / folio.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77737cbf2216a..48a985e17ef4e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
 	return folio_large_nr_pages(folio);
 }
 
-/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#define MAX_FOLIO_ORDER		PUD_ORDER
-#else
+#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
+/*
+ * We don't expect any folios that exceed buddy sizes (and consequently
+ * memory sections).
+ */
 #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
+#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Only pages within a single memory section are guaranteed to be
+ * contiguous. By limiting folios to a single memory section, all folio
+ * pages are guaranteed to be contiguous.
+ */
+#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
+#else
+/*
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect.
+ */
+#define MAX_FOLIO_ORDER		PUD_ORDER
 #endif
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
-- 
2.50.1


