Return-Path: <kvm+bounces-56492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08FDDB3EA16
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 17:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF1652C2897
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B40C37C10E;
	Mon,  1 Sep 2025 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P5ew8bq8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1EA35CED1
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756739456; cv=none; b=MdN1TqsW+qKYQ0aNWwKne409eustKBJ0sTihR+DSAhq3vGVGk/36Wf0By+BsjbtKju2IdsvHz278vn+rJ9q+yIA2oalzuGHIWGR01JMXxRObCSWgNl4DVk0p9Hxhqhdqo9CeI37psaDH5YzESpYuIXALl5FJDYlWJ3PFuD3TZl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756739456; c=relaxed/simple;
	bh=nc3Yc0/qjWObLuq/Dnlh4/fE6/xzu4aI7QxeppqGJCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToHqtkPwSYeank/p34mywZ7JH8qt3cXVUUwndgF1NKtUM6qgGpAjy2XgY9AcqdkU3/08igZgJtLu83Vwzql03tXABCHhC30fWE+kGwPDJhLB68kyxekAfFemNthYAtMKOiFyHWQeIEWtpRQCucCFhyKeQQrJy/Pc+MNXOjtB0yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P5ew8bq8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i06htfFlQWUPNnzacoxmjdCfJTHM/jIyMh7+2RAfHF4=;
	b=P5ew8bq8bwh6PnsSq1ADRNQkH30XgJBoxPDkep9a54z9fdGbleDriVcJ5uyIAknweUbSPV
	9uorE3bXJBu3gPuW/Bcolaj9SDCo1vF5NmvlkpMFZCbunMfZCd+vc3LxseVstbMUblyGlY
	aO5fuKDCqhWzI2N+t8gsPWFUlPgw5z0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-mPsifsa5O0-R1fp0Ep7F3g-1; Mon,
 01 Sep 2025 11:10:49 -0400
X-MC-Unique: mPsifsa5O0-R1fp0Ep7F3g-1
X-Mimecast-MFC-AGG-ID: mPsifsa5O0-R1fp0Ep7F3g_1756739444
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F20F19560B2;
	Mon,  1 Sep 2025 15:10:44 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AB8A1800280;
	Mon,  1 Sep 2025 15:10:29 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
	Marco Elver <elver@google.com>,
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
Subject: [PATCH v2 24/37] scatterlist: disallow non-contigous page ranges in a single SG entry
Date: Mon,  1 Sep 2025 17:03:45 +0200
Message-ID: <20250901150359.867252-25-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The expectation is that there is currently no user that would pass in
non-contigous page ranges: no allocator, not even VMA, will hand these
out.

The only problematic part would be if someone would provide a range
obtained directly from memblock, or manually merge problematic ranges.
If we find such cases, we should fix them to create separate
SG entries.

Let's check in sg_set_page() that this is really the case. No need to
check in sg_set_folio(), as pages in a folio are guaranteed to be
contiguous. As sg_set_page() gets inlined into modules, we have to
export the page_range_contiguous() helper -- use EXPORT_SYMBOL, there is
nothing special about this helper such that we would want to enforce
GPL-only modules.

We can now drop the nth_page() usage in sg_page_iter_page().

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/scatterlist.h | 3 ++-
 mm/util.c                   | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 6f8a4965f9b98..29f6ceb98d74b 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -158,6 +158,7 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 			       unsigned int len, unsigned int offset)
 {
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, ALIGN(len + offset, PAGE_SIZE) / PAGE_SIZE));
 	sg_assign_page(sg, page);
 	sg->offset = offset;
 	sg->length = len;
@@ -600,7 +601,7 @@ void __sg_page_iter_start(struct sg_page_iter *piter,
  */
 static inline struct page *sg_page_iter_page(struct sg_page_iter *piter)
 {
-	return nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+	return sg_page(piter->sg) + piter->sg_pgoffset;
 }
 
 /**
diff --git a/mm/util.c b/mm/util.c
index fbdb73aaf35fe..bb4b47cd67091 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1314,5 +1314,6 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
 			return false;
 	return true;
 }
+EXPORT_SYMBOL(page_range_contiguous);
 #endif
 #endif /* CONFIG_MMU */
-- 
2.50.1


