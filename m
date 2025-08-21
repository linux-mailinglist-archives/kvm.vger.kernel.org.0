Return-Path: <kvm+bounces-55354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF4EB3041A
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E6FA7BD6AE
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050C9312833;
	Thu, 21 Aug 2025 20:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cTnGCs3U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FC92FC03D
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806858; cv=none; b=bt8vVBMKOMPWUr4hZ6Jxr6yjTp3U9fhaNSxZLuU1jqJ1+RSmOAWxOePulXP2Ih3i6NBS/aMA2fI3KIU9Ps5128Ye9tUvvTFgFk2qWNgnCJ0sB2pczOYrrH6DwJIFzpIihR5OaFBS+E2Nl0b/tthHf2dUYkoQUXXLQwV4E6gLLUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806858; c=relaxed/simple;
	bh=+tsaq0kMmRCBgLfPZThux65EZrTtOKARiF8G7W5lNZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLTQy37HbLLk53MVESrXlJlE9Dgw2lH3YJrapD6HUdoXzK8cmcOgpFAi5EIukoY3TZwLYxOAB3TeQGwDrpcRAmGKtpsYOkOrXkol8htR3X8iY8C1oAeFoA3IxKY56HBLQfZsV1Pw8ER/YejyTWvUi+BakjyMSuFMsnUlU6XvODY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cTnGCs3U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r/kmddABpvZJu5K+QD662cz6jOGE1r8xokeQdlRgepQ=;
	b=cTnGCs3UqgoM2qDpp2bN0hwiGC7IW2T4kVwaj2WxfD46f+BGp/uVjeodqi8sddHs6S5T0D
	cQ4FdgpiQfdbJBz1Jtn8inWWcpurU68jRYcbSUXfdsXyamSI83MugkrRX/0r54YVM2LQpj
	bLnbFCuqHJOG2+Tuzqm6dNZhzI8MRb0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-k1x6APozPdKg6zmMXoLI1g-1; Thu, 21 Aug 2025 16:07:33 -0400
X-MC-Unique: k1x6APozPdKg6zmMXoLI1g-1
X-Mimecast-MFC-AGG-ID: k1x6APozPdKg6zmMXoLI1g_1755806853
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9e4157303so922414f8f.2
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806852; x=1756411652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/kmddABpvZJu5K+QD662cz6jOGE1r8xokeQdlRgepQ=;
        b=Q9yeP0eidZGecfFDukbAvppITI/8565DFbHMZ6MvUWD0nFYPsnPtD6jmLgXHDyrPvQ
         kLv7m50gACoYdAdjGDDIjQs9f80XXk2kiHmppRAOsTPD9vtKU1RrTrRmzdfjDP2u1fSW
         ezeknJ01y5+VhnUX2znwqMfEk680QLMoaaeZ9Hsi/4sTchfylv2rBxMeLFfrDEp1NGyU
         F4j7N0ueZ+YrE9Y4I0xDVP7BLKpgeIwaj6e2h+JvvOXI4anDf/acY5awfk/JqHw4owuX
         KQdmw2msHTRsy0t9AXtwXIoVLQqHH2wycqiiNq/2C+33XIAHEZLOY0LPFHTtr7goPD6z
         Nyew==
X-Forwarded-Encrypted: i=1; AJvYcCWK5PteETnAyrNXuyzofs7t354A2k2NM4lMqLMEQjaC51PjEEAydTJVWCCaD36DNx+xKeI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGE1CNoXTMm2/wk/18FaIiHwWQm08vzhTVcm1zmu65PBwvKINL
	uDhBbaEZ1MaElGBQOhjYDtFv2EeKfnWUt+RFYO2ds9GOMDD/BG55a/8eN36S70ly76NJftJHNdR
	awPQ19RJrGi9pfug+i+b4GU2bkozPNC5AEi/Badcnj6uE3UhIy/k5bw==
X-Gm-Gg: ASbGncvOI7SjPMJ6hmy9busbvU6F1XDUdO4eWFJwv0ZZnzqjiBrzGKzL94Dpmb56KG7
	3cOH2IoBfeXZsxPH2VybRQzHlp/+48gyjWzKFX0RCU2tAxvsfUm4gs73/3NJsJONdjXiESZ5TZT
	BMJPhHitbMpk4WkWywoXWeo7ZngpfW5hL/xIclmXvFfjRgbYytKOsfIul8sMwkDbosuw6LLxjfN
	DYDFKmrBnMBVFV0H7indY0rUL0vTKJcwnUzVDJIeFpx1r4zs2bhh8xqwXddcNDPbFQ6O9l4Y2Qy
	xHL12oSSS33ujQfYQow9h4WwTaZw98lmf4jxPy4A2dTkc4K7bvm+94Yg+jw5SrmmHhgEn5VtYan
	hjSM69v/hxXwf7LC8TxVOcw==
X-Received: by 2002:a05:6000:2dc7:b0:3b9:15eb:6464 with SMTP id ffacd0b85a97d-3c5daefa9e0mr244676f8f.15.1755806852588;
        Thu, 21 Aug 2025 13:07:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbqF8V2lF/CygktHxSJZNB7+pmyneW6nxhnLwTxWefpTwvecQ9FG1LkYH8lxi0WUYYPrMQFQ==
X-Received: by 2002:a05:6000:2dc7:b0:3b9:15eb:6464 with SMTP id ffacd0b85a97d-3c5daefa9e0mr244660f8f.15.1755806852102;
        Thu, 21 Aug 2025 13:07:32 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c077789c92sm12629958f8f.52.2025.08.21.13.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:31 -0700 (PDT)
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
Subject: [PATCH RFC 09/35] mm/mm_init: make memmap_init_compound() look more like prep_compound_page()
Date: Thu, 21 Aug 2025 22:06:35 +0200
Message-ID: <20250821200701.1329277-10-david@redhat.com>
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

Grepping for "prep_compound_page" leaves on clueless how devdax gets its
compound pages initialized.

Let's add a comment that might help finding this open-coded
prep_compound_page() initialization more easily.

Further, let's be less smart about the ordering of initialization and just
perform the prep_compound_head() call after all tail pages were
initialized: just like prep_compound_page() does.

No need for a lengthy comment then: again, just like prep_compound_page().

Note that prep_compound_head() already does initialize stuff in page[2]
through prep_compound_head() that successive tail page initialization
will overwrite: _deferred_list, and on 32bit _entire_mapcount and
_pincount. Very likely 32bit does not apply, and likely nobody ever ends
up testing whether the _deferred_list is empty.

So it shouldn't be a fix at this point, but certainly something to clean
up.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/mm_init.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b2..708466c5b2cc9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1091,6 +1091,10 @@ static void __ref memmap_init_compound(struct page *head,
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
 
+	/*
+	 * This is an open-coded prep_compound_page() whereby we avoid
+	 * walking pages twice by initializing them in the same go.
+	 */
 	__SetPageHead(head);
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
@@ -1098,15 +1102,8 @@ static void __ref memmap_init_compound(struct page *head,
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(head, pfn - head_pfn);
 		set_page_count(page, 0);
-
-		/*
-		 * The first tail page stores important compound page info.
-		 * Call prep_compound_head() after the first tail page has
-		 * been initialized, to not have the data overwritten.
-		 */
-		if (pfn == head_pfn + 1)
-			prep_compound_head(head, order);
 	}
+	prep_compound_head(head, order);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
-- 
2.50.1


