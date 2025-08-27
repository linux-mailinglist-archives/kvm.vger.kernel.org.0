Return-Path: <kvm+bounces-55964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3D1B38DF2
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:20:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04B5C188BD07
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 22:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B370235CED5;
	Wed, 27 Aug 2025 22:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILa4cx7x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE5831CA41
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 22:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756332654; cv=none; b=prjCxSReUgaYLfHJ23H8M8KukZuuIvPgWJSpD7SF94cLpQ86i0bude3IxxYmEbwZcEYL0neiBGtIvmKwmLcLTO8XOiLXh2y3Fu44tc21K0tErkgwrEx2m/BcJhWhxx1/qcUDUi4yN/+porNpe8KppK9OlUhXBgsXGdc6ieVzlLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756332654; c=relaxed/simple;
	bh=W2zURd3mlNFD6+8/G7aYSvH/DtIoVv4hio5y/lKVdHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRUfXaWact05/o3PHQT+StIy+qXrfXsyXC51jqfURAfphdrHs6WKdMvdYmFw2miRS3kbYE5kEE3LNB20SKckiAhSxMKcSZt95F6lzUTXfOLFQPFqgz+G6luStP368lXUu0QQlRfZO4v4V1FnCc7fFg6KtZ5LsvnTBiP+4kQu7jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILa4cx7x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YpVNTL/msyfj4quk+zG5idx/zOSmESitaXX9oJyyDlo=;
	b=ILa4cx7xzUEUCQyL1Wt0u0deAwv+z6BEk84JAe2E0MCF7tOajFGVBMFTWvm6wAvXqT+5XU
	UfjsTID96Zj2wiXRxprGfn9s6AyDiR8GcC4c3kllE5b/iVc3g/cVkFJHM9FJckocph/xVJ
	3k7qUm2wdKQZl/Zt7PMIcZJyatTpqyU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-sl5k46szNKGimV3zS5dDew-1; Wed,
 27 Aug 2025 18:10:45 -0400
X-MC-Unique: sl5k46szNKGimV3zS5dDew-1
X-Mimecast-MFC-AGG-ID: sl5k46szNKGimV3zS5dDew_1756332640
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75B6D180034F;
	Wed, 27 Aug 2025 22:10:40 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A20E430001A1;
	Wed, 27 Aug 2025 22:10:24 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
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
Subject: [PATCH v1 30/36] scsi: sg: drop nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:34 +0200
Message-ID: <20250827220141.262669-31-david@redhat.com>
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

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/scsi/sg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3c02a5f7b5f39..4c62c597c7be9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1235,8 +1235,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
 		if (offset < len) {
-			struct page *page = nth_page(rsv_schp->pages[k],
-						     offset >> PAGE_SHIFT);
+			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
 			get_page(page);	/* increment page count */
 			vmf->page = page;
 			return 0; /* success */
-- 
2.50.1


