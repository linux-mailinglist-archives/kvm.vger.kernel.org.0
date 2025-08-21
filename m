Return-Path: <kvm+bounces-55359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF97B30484
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DC961890C55
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE81F35E4EA;
	Thu, 21 Aug 2025 20:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ApVUgePM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3F335AAAD
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806876; cv=none; b=oWtE6UEwtEir6uDdSSAPvZdKfB506/uWmxHpFs8cSvFAqznEUUIqMAx4yWxv27LkoVEc9kCQt/BraArGiBBuJRLOXkTVCOsaACFtDNYMcQ58+3LRBxybWv15E+pXJkAIkDkLbxIAp+KzQMMhg8FptdCfIQuVkSR/9pBYD4DDnig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806876; c=relaxed/simple;
	bh=d4tmPeOlqOBXo+X4Tiv9h/CbkpHAugux1EiNuLc/Y0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQUINlcFJqmhlcg097ACVDBLv8jbz3/q3e5t8Mcng+aToEwgyODtX+VPAothOSv1YxrLkChmxPMchthDqoWPR1DMTMrUDnhpfDOFASIPWl4Qo8yO6jXFPSaHigQdHQXLS5fKcCSQmGFBBX9pgxS1n0HwXobmzFK0zt/b36WGnMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ApVUgePM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MzMWVCGQW0mP4+/ULAfe7CdOmgWkAKLnoxAB4Fy092E=;
	b=ApVUgePMc5w7rL41HNMIKF85AcMs6Un4ujFWJA5x+7+Llhbk1+gVkmabnDQ0P0g6RwRZ6I
	hiG/PTnBi6M9L8qRsc++NZhZs06JhKlMLLamkv6/9nyiqk5kpcRGlad8oxOAC+Nn5J3rGI
	2Nt7rHQpw5MKfM1CUw8SvaJu7Y3EaHY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-OW_CX8VoMl2cmYEJe7JwLQ-1; Thu, 21 Aug 2025 16:07:50 -0400
X-MC-Unique: OW_CX8VoMl2cmYEJe7JwLQ-1
X-Mimecast-MFC-AGG-ID: OW_CX8VoMl2cmYEJe7JwLQ_1755806869
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9e743736dso787397f8f.3
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806869; x=1756411669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzMWVCGQW0mP4+/ULAfe7CdOmgWkAKLnoxAB4Fy092E=;
        b=cc1x2BPIr1uRSSH+hTvSfW1dxUTZcIOLgA2jXP2wdlU69I9UR0j3dwVX2zC2j2Hb3x
         Akm8tdslofihYzfAcvaSXk2huFsOFR0ThIgctV3NC4su8i3lp4175U3s08kvh9T19dt+
         i0Dv7YO+a4gDewCNVq+byZfK9Lu1+7revozEXa1f+IRNoY+v/7zPMQgVkPPXVih5SvZw
         PkNMPnwIKK/VQ4Pe6c/OlQDTOMkr9FUnwhazpDZYbqNvpnmpLzK/fBVpCXQVoriOx2Ov
         WHIZLdw2BWCtOgKtLCUysLFvJ+/C+iqJtlgX0dPkaP4Qzx/9N0m/URFgjHk6NzqbNLHE
         4FdA==
X-Forwarded-Encrypted: i=1; AJvYcCXZHXmujKZQ1I+lSzoJfEEwj/Z4fM3R62FgYAA99lfn/wqUrc670TwjDSXkfFIgRM8IH0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyNMgbANl1eq4VvBLLunWbaVNiedM8BGzdt7jfabjWoOrgjx5l
	+E/fHCKet0LikUG3v9Ciz0dOqJiDc9l+6/cBrGS2IaUU0FrhEUl3m5v/f2QJXneDjppJPGiujty
	MkG8unQFSbwvu5JFb86+DPOy7DJYRbBgvGPRfTZQPYYw6x4bEMqBmZA==
X-Gm-Gg: ASbGncuOVO24ttSt/0kjsdF4P2sanjMxVgh236Jwwi/gmB6k86LtVyc02ecsxhjiKL0
	JaCqspzCHhMcYexFiRGOole5UPzDfZv+IyfE3thHfO59mME5mkhA6BXp39nHpfnAoKbYW/26Hpa
	4APJMEDmvx8jIEYoA9pp+ZpeKoGSYaw69Em/78albWBzcsBc1mlh4H+xa6Epj0+BJZR6TO8lfFf
	XXr5Y0hZgURB8nFH6Vhys22u1leyIYJeHmCNTgFFkVZdG6tBfJedla9j6rXAE5RHSVblpxfw8Qe
	jblHMPbeDwHuvmrF8OBFWmazHuW/wHn2MTHxes9ADhPiE3Ne5ls2yqHYj9XwuEdL8yuKDegY/aT
	jp2CkZ+h1bGWuhnxxSzXmOg==
X-Received: by 2002:a05:6000:2901:b0:3b7:c703:ce4 with SMTP id ffacd0b85a97d-3c5dcff5f3amr167817f8f.59.1755806868908;
        Thu, 21 Aug 2025 13:07:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCm64ALptQrKyrLlaLt4xJ2vziBy3gZm4Q1WMVX6wnWhr2W2tRcHnZJHBwxpAOnTfL4mKx+A==
X-Received: by 2002:a05:6000:2901:b0:3b7:c703:ce4 with SMTP id ffacd0b85a97d-3c5dcff5f3amr167760f8f.59.1755806868453;
        Thu, 21 Aug 2025 13:07:48 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c5826751d5sm1323274f8f.14.2025.08.21.13.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:47 -0700 (PDT)
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
Subject: [PATCH RFC 15/35] fs: hugetlbfs: remove nth_page() usage within folio in adjust_range_hwpoison()
Date: Thu, 21 Aug 2025 22:06:41 +0200
Message-ID: <20250821200701.1329277-16-david@redhat.com>
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

The nth_page() is not really required anymore, so let's remove it.
While at it, cleanup and simplify the code a bit.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/hugetlbfs/inode.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 34d496a2b7de6..dc981509a7717 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -198,31 +198,22 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 		size_t bytes)
 {
-	struct page *page;
-	size_t n = 0;
-	size_t res = 0;
+	struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	size_t n, safe_bytes;
 
-	/* First page to start the loop. */
-	page = folio_page(folio, offset / PAGE_SIZE);
 	offset %= PAGE_SIZE;
-	while (1) {
+	for (safe_bytes = 0; safe_bytes < bytes; safe_bytes += n) {
+
 		if (is_raw_hwpoison_page_in_hugepage(page))
 			break;
 
 		/* Safe to read n bytes without touching HWPOISON subpage. */
-		n = min(bytes, (size_t)PAGE_SIZE - offset);
-		res += n;
-		bytes -= n;
-		if (!bytes || !n)
-			break;
-		offset += n;
-		if (offset == PAGE_SIZE) {
-			page = nth_page(page, 1);
-			offset = 0;
-		}
+		n = min(bytes - safe_bytes, (size_t)PAGE_SIZE - offset);
+		offset = 0;
+		page++;
 	}
 
-	return res;
+	return safe_bytes;
 }
 
 /*
-- 
2.50.1


