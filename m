Return-Path: <kvm+bounces-54647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31A14B25C28
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 08:49:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 978551C868DA
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 06:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09CE25A2B5;
	Thu, 14 Aug 2025 06:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NyDifK82"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF04C253931
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 06:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154092; cv=none; b=qCCFGs3zW28RmHwWQ7yzMtlkqnKXGdwC3YQCaf3O050QqaHSDpBW3Kwgty5A0KqY4sie+pZEb8hZV2VzIM+8N6Sv8fFtxjh27AO8fwc/Zb+fQLZKtTtBJOfTU8MIQpAU7gozHg8/YnOnR3hP/943GrRDP7U8ISqjTRZHjfEg+bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154092; c=relaxed/simple;
	bh=vraXvOOy00Qem0zfYMrwZ55j9LS5ekbc8wJ2XfCfcJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjohUC3WRwZ2QU8ONfze0M+BG6hSRMLO95z+Gx3vwA8uyh9P12wYgzCMB8V1Prq7+5naXZIA+gakYvpU6s7ZaCQAwXHNjmx1anebBjWbsQCNKTDWmaQUi4iXDhff4tPRfEIsGMuVFcpgv9NKmFZa4Z3M2ZKNnw6N4PR6i30Cl4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NyDifK82; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-244581d87bdso3506975ad.2
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 23:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154090; x=1755758890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgSEQM6TLLcMsFdat9WzEVNebtvzRsoxOWl4t4MuHzE=;
        b=NyDifK82+6hgHnPCXdCAs5VpgWKcMBruQlL6hTJe4aB8xV/de6NjBampD4eMnoDizc
         nx4LGOQJWLfEuLu24UNHOgdX+PFTo7KSljZQ/LO6TC2JAjBhyPCj9nlQV4QyHVsXzZpo
         20U2tnS7rwWvPP00cQih8WFahqnkQHXTkxzsnZJ/KSwKFceAXPtMySZOFtS5zKwa9xDd
         UGUVAxCIWhLs2AbF9VkJ5iirCfqsV0BdoJl4eqTvBkWLgJRSHL9sg9n4YKZKf1g0ggx6
         xybXY0kfl/WGZtlp5I51/sTtL4r7V+IjZdZSEDQdSTke3cLDIkpbNboxgqx1dMil9YC0
         jFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154090; x=1755758890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgSEQM6TLLcMsFdat9WzEVNebtvzRsoxOWl4t4MuHzE=;
        b=M8UoDbC9d4xLFVra7hj9DdKLcNSSvakNQ633SssX7ZocUusKfzUQ62yfCqsflmgolj
         CXo7Wud1h0An/2vqNBmHXdBTHNsAxWGRk8SH3ea/zdaujX2iML/CywJnLEg6B87f8swa
         OZ7ITifHP9WXCjZTRGClYDixgGnxunK7YeVx2hUIklUrWAf6NCGMr/aoPsmzliSPIImo
         BCXbwcA5PRI30tcTLq3J56KhI81VhokxwrWuI5odz9+CR3qJXOslOCODdX3fGrt8XJHZ
         6zgwKq0Mn0+E2YRtvyBJDcxcRvX/2eXYlypyb9NndgPeYnJFWpIDKTCia+90UFMU4N8P
         YIYw==
X-Forwarded-Encrypted: i=1; AJvYcCWD92KPb0x7fJq2uczNyiVcigveemRRxZyyTLOWDc/eVpKrmBceUxXo4y6GHEzuImVgnak=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya3A7hTLEBtwJIxdTkJ/ru8OcOXL2Y41hecx6hFIlNH+ZOvX5w
	vvijKj91VWxbr+M+mvRUeQQ1bgGcsPWPdN3UmujuvTqpAIa1KPY85/2rAWLJbtcSc1oCi9ehRu9
	jGp2S
X-Gm-Gg: ASbGncspVyalcZZp38NtypRX7YaAzz+TibreeyUIjYb3wZUTm6K/qvhzlJdQmXEjiUU
	3y3xu2p+Z0fevvaD2bbZx8S46bXR//MnpUdvbMH63B3BP+M8QSNX33WAA3j8DdbQTV1E/O1tJpA
	8V9oTUx0r/wjwqxsJ5ZlJqIXIWMAJd2lzwXZDO00fhoqSWyksrSMWJXKIMa56Ncaq1sFAPObx2+
	6oMENlvmYaQY3h98jWajK37Etr/gtuvXycBytIQ277w0MAYi7qCx5sbSrRHvKTYmJgGF0pDnYXq
	180k1B/fFJvg5aRW3Iy2DS5SDuMT84wdGRtiTFDlY799bsT7yijqH7lsAIb3zkoAs00WLQnBgeN
	3OJdrZms3fXp/tlTP+u4RtzsKrhquED7K9rR+SWSPQ+mY9lqP3AgAsI0sqBHu
X-Google-Smtp-Source: AGHT+IEtImpTkJKFIJSVx3t14qt/Mp3kImtU354IarnQKNBYqxeUtpf1mqOF0jI/d26u52bUnF0w8Q==
X-Received: by 2002:a17:902:ef46:b0:240:4d5b:29b4 with SMTP id d9443c01a7336-244582c38cdmr31031305ad.0.1755154089931;
        Wed, 13 Aug 2025 23:48:09 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.48.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:48:09 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v5 5/5] vfio/type1: optimize vfio_unpin_pages_remote()
Date: Thu, 14 Aug 2025 14:47:14 +0800
Message-ID: <20250814064714.56485-6-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

When vfio_unpin_pages_remote() is called with a range of addresses that
includes large folios, the function currently performs individual
put_pfn() operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.

It would be very rare for reserved PFNs and non reserved will to be mixed
within the same range. So this patch utilizes the has_rsvd variable
introduced in the previous patch to determine whether batch put_pfn()
operations can be performed. Moreover, compared to put_pfn(),
unpin_user_page_range_dirty_lock() is capable of handling large folio
scenarios more efficiently.

The performance test results for completing the 16G VFIO IOMMU DMA
unmapping are as follows.

Base(v6.16):
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO UNMAP DMA in 0.141 s (113.7 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO UNMAP DMA in 0.307 s (52.2 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO UNMAP DMA in 0.135 s (118.6 GB/s)

With this patchset:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO UNMAP DMA in 0.044 s (363.2 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO UNMAP DMA in 0.289 s (55.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO UNMAP DMA in 0.044 s (361.3 GB/s)

For large folio, we achieve an over 67% performance improvement in
the VFIO UNMAP DMA item. For small folios, the performance test
results appear to show a slight improvement.

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 30e1b54f6c25..916cad80941c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -800,17 +800,29 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	return pinned;
 }
 
+static inline void put_valid_unreserved_pfns(unsigned long start_pfn,
+		unsigned long npage, int prot)
+{
+	unpin_user_page_range_dirty_lock(pfn_to_page(start_pfn), npage,
+					 prot & IOMMU_WRITE);
+}
+
 static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    unsigned long pfn, unsigned long npage,
 				    bool do_accounting)
 {
 	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
-	long i;
 
-	for (i = 0; i < npage; i++)
-		if (put_pfn(pfn++, dma->prot))
-			unlocked++;
+	if (dma->has_rsvd) {
+		unsigned long i;
 
+		for (i = 0; i < npage; i++)
+			if (put_pfn(pfn++, dma->prot))
+				unlocked++;
+	} else {
+		put_valid_unreserved_pfns(pfn, npage, dma->prot);
+		unlocked = npage;
+	}
 	if (do_accounting)
 		vfio_lock_acct(dma, locked - unlocked, true);
 
-- 
2.20.1


