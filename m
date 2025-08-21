Return-Path: <kvm+bounces-55347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 723BEB30393
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0F2A7B8820
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F372E9EC2;
	Thu, 21 Aug 2025 20:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AMHEgVhK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C1734DCCD
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806836; cv=none; b=oqTdG/nxHMSuGMjtHZw9ZLJyMDh0TKbJeiAhEIv9Aib1KklHcCD/8HJa5MkBneS+S2kWSg2+NU488zVCv/siYXzGoMzn8jlHsDE0xqNddkySGqlru/zUvGJ1lLFCslwvohHv63iYLtS26GQ6lTuPv6/soEopXVd/YTBCLje13e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806836; c=relaxed/simple;
	bh=6nSseGe+74q2JGOSoz3zO112Eo1zTQLz4H2FdYfsyUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkNq2cwDcrssQsD3LFpMF60XpNA23vFFsBts1WltDaR/z3svxog8bAZWYkKaoT0bW/7ViuJS/R+5+xMutGMvzj/xIg4FX7JrZL4KijoNgDO7pF5kuZ7RGRL52vr+GZGTKhtUgCyF3AL/afhQyWQw8Yt/6pzX63ohLBgvGjByCMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AMHEgVhK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XmvTcrL5C0dM7rPtm73IEcsYc8PUVzmaMdzwCc2EnvI=;
	b=AMHEgVhKsAOyLQUcGBbH1u7jlwCNbrL5HmIHPlJd8fv6ZbZdXuUAP3R+3pWWr6I8m3nV8r
	QTEq1nHDnb9yAAcW7fdZZBBAFlz8AL8h2zb8RooTf1K6VCTUlHLNkq/N8OJojEyf0nJ65C
	ExcKJGjs3WheDpImxlwUxEbc82aadW8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-nJcQy2IgNN-VyBsh4if01A-1; Thu, 21 Aug 2025 16:07:10 -0400
X-MC-Unique: nJcQy2IgNN-VyBsh4if01A-1
X-Mimecast-MFC-AGG-ID: nJcQy2IgNN-VyBsh4if01A_1755806830
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b05d8d0so8767185e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:07:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806829; x=1756411629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XmvTcrL5C0dM7rPtm73IEcsYc8PUVzmaMdzwCc2EnvI=;
        b=Re+Unjd944ygzxWSBIrJ7LDir2nrUMY+hWvLdQaHoRiwmNiZXJfviTR4AxUlSNq7qJ
         i1ezsFxqXUZiYNS2jufZ9Jx/j6zkJcv1rCJHRvJytIyw9JJHzd4MEncFcHs8LU65vUPS
         vbLhM2mFLu3ThajQAB0vahFhIqYkHV7GheZpUOk+PhLq4GYYlps8Q0+37Nn7WkXcJerd
         oNyhjABr+Fzydzk9ZmjJPRFCIxC+vEcibkeN5YwaqHwtf7mx16MxQgl4KqJsQwhMw+zi
         zPR+D6ca1xxnVHAjeCQlU79Z0EHrlrCOgBTFa63K9UWxpgprku2sEGp61kdA1Kzft7pD
         NMZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEY5met1sjYPS/YKBa+1vov2m8D0hx/qdwiswhZxbMPoD/naO02lzf7rloisstZjHUbi0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyzUbo0k/36PE/RfDBPmoMc6U59gLNnR+ujG9tRUM/dcpVZHdR
	VNDRSR0J6M+e06ZcKuTi8By7hAwg2TkogCvsaepeyLQMsZCZSuzq1CqPwR6MeHhbg8HVlcdhhAE
	0l27yb+NEksl4U4Wn5PeHhkjcZyvR4YlAUYJ6N/S87Qp/LW6mrad/bA==
X-Gm-Gg: ASbGncszfROI5TV6qlJWRnFQF+LE1MAgCcXqjrB0NPbOFe1+vn9S9M9n99uoUt9joz+
	DG0AUbjc8d7ISJBq1ZdJ0EANu43DAyjfmxNukipxsV2CwGcZtM69NDw1D6Ct4pdy06GO1hcPC6a
	cM0djTutOFXu5wFSegfjNtv0E5kVxYwJQhC+yddXqCV4MLpqZLaWkgyNkrGlq1wE9ukzp1jhnLP
	OGfHXlMwY38oA8LMPVMnbBQE42Z0nlfUpt5yRHGtM/KR41IW3VQfR2sdnFYGMB3GK+WWAI+8see
	90fynvArG7BT4t/TQlUHn7Ikqfz2f0k+W2gHjnxGoamHhzWIPZ4KnuHqvS4YxOM1sIh/Doi34fv
	af8/eE0ZPlfawVB1p6s/LxQ==
X-Received: by 2002:a05:600c:4506:b0:456:eab:633e with SMTP id 5b1f17b1804b1-45b517c5f34mr3673785e9.17.1755806829510;
        Thu, 21 Aug 2025 13:07:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvYkVaGxfZdplMxnR9eu9+L8mDJqjqWM2enq3Cze2cE8zEp05huuco+bDpuuERUQ/1xaOAqQ==
X-Received: by 2002:a05:600c:4506:b0:456:eab:633e with SMTP id 5b1f17b1804b1-45b517c5f34mr3673145e9.17.1755806828996;
        Thu, 21 Aug 2025 13:07:08 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e1852asm8722665e9.25.2025.08.21.13.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:08 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
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
Subject: [PATCH RFC 01/35] mm: stop making SPARSEMEM_VMEMMAP user-selectable
Date: Thu, 21 Aug 2025 22:06:27 +0200
Message-ID: <20250821200701.1329277-2-david@redhat.com>
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

In an ideal world, we wouldn't have to deal with SPARSEMEM without
SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
considered too costly and consequently not supported.

However, if an architecture does support SPARSEMEM with
SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
like we already do for arm64, s390 and x86.

So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
SPARSEMEM_VMEMMAP.

This implies that the option to not use SPARSEMEM_VMEMMAP will now be
gone for loongarch, powerpc, riscv and sparc. All architectures only
enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
be a big downside to using the VMEMMAP (quite the contrary).

This is a preparation for not supporting

(1) folio sizes that exceed a single memory section
(2) CMA allocations of non-contiguous page ranges

in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
want to limit possible impact as much as possible (e.g., gigantic hugetlb
page allocations suddenly fails).

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 4108bcd967848..330d0e698ef96 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -439,9 +439,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
 	bool
 
 config SPARSEMEM_VMEMMAP
-	bool "Sparse Memory virtual memmap"
+	def_bool y
 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
-	default y
 	help
 	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
 	  pfn_to_page and page_to_pfn operations.  This is the most
-- 
2.50.1


