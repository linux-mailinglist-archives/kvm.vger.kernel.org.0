Return-Path: <kvm+bounces-55969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A1BB38E32
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77C8D3AECCC
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 22:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E24C32255D;
	Wed, 27 Aug 2025 22:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3OXT2Gy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B966D314A69
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 22:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756332736; cv=none; b=g7LqlG6IjQhogGxgnuuQbUm16pY+3pDuFOXXC2QASy2AX4wGqL6i941Oyd4qOuyR7AinJkP52h3RR/lqWepp7XtT8K7PRZbA47wXVB9ylUOvjixSbVF6iBjefOiHoSPIigxfofSGX1hkvHZadOzb3qFPsgu2lCcJUd4Y1KzUkaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756332736; c=relaxed/simple;
	bh=izYuZWtM9expuJ4aw1W3JEFW5k9djBINp3Pti4HydYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8Jo0Yhr6QBmikXsXkDomfbIKy6Uq/TAh2cQ+ZT9yb0OOS6ffZkCyVpaGg8m0c+PC8+xNA/44jdr+Ar3mUwDSQrNT8Rpz+ATsMVVpodqIkM+yS71O52NIlMhG9uc6YUxkz/Suv0FRDBqLYrzs/2DG0C3tt6RnzveN+kuTLrvUuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3OXT2Gy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
	b=P3OXT2Gyck5T6j+92NOwjqhvYZNXcBtJt0OBSXtTMy6ni+5N27hs13SEHOysRGGf6TQWqn
	4f5PLoYn/epBCz2MS6NxOybyW2TdaBpuhNmHBIabf/rfV2oYBy61o5qC73HLLewXMnpU5e
	okBeQTJliSYAcp9coG0zVldmQy/sUp4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-ShHxITs4Pxeui_5CEKaCgA-1; Wed,
 27 Aug 2025 18:12:10 -0400
X-MC-Unique: ShHxITs4Pxeui_5CEKaCgA-1
X-Mimecast-MFC-AGG-ID: ShHxITs4Pxeui_5CEKaCgA_1756332725
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CFA218004D4;
	Wed, 27 Aug 2025 22:12:05 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D11F30001A5;
	Wed, 27 Aug 2025 22:11:48 +0000 (UTC)
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
Subject: [PATCH v1 35/36] block: update comment of "struct bio_vec" regarding nth_page()
Date: Thu, 28 Aug 2025 00:01:39 +0200
Message-ID: <20250827220141.262669-36-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Ever since commit 858c708d9efb ("block: move the bi_size update out of
__bio_try_merge_page"), page_is_mergeable() no longer exists, and the
logic in bvec_try_merge_page() is now a simple page pointer
comparison.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/bvec.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0a80e1f9aa201..3fc0efa0825b1 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -22,11 +22,8 @@ struct page;
  * @bv_len:    Number of bytes in the address range.
  * @bv_offset: Start of the address range relative to the start of @bv_page.
  *
- * The following holds for a bvec if n * PAGE_SIZE < bv_offset + bv_len:
- *
- *   nth_page(@bv_page, n) == @bv_page + n
- *
- * This holds because page_is_mergeable() checks the above property.
+ * All pages within a bio_vec starting from @bv_page are contiguous and
+ * can simply be iterated (see bvec_advance()).
  */
 struct bio_vec {
 	struct page	*bv_page;
-- 
2.50.1


