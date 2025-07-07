Return-Path: <kvm+bounces-51657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92416AFAC24
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 08:51:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 435FE189A50A
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 06:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60672286D79;
	Mon,  7 Jul 2025 06:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="b+5Q91nP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108DD27BF6F
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 06:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871036; cv=none; b=SLY6QTD3F6a+9++R8M0F+yipak6Ir1sozwSmRFtNSKYai6ZnWcSapGqaI4kg6awe3oN/TFSztgRBnM3SC4Qo0vMM/R22Pqk6KjUb+nApk4FUrsbCgcdsq2jZdvA7rnghWzc6dALJbFYCeEfuc9fbfw4RWpBVvKZ6xWhll+7O2Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871036; c=relaxed/simple;
	bh=ls52+XrvwO/234TukpAvew2O69meLJpK2+6xI0hEEfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io/9C7opFxhRzp+bDwWoZ2TPSbc9Bbez4FPgTHSL4CWg27KlZFPtMdGXT2dmLbB++afLp/mQMVUqj6biAAcFl4a656vrE3jLfmF5qpe6+RgKYRqnTw7WljCz9epwZvwvbQKNaz3ckZzQkr6+0fBA4AmsX9bSCe0M7ycClmzFtsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=b+5Q91nP; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-23636167afeso24619345ad.3
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 23:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751871034; x=1752475834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJCrtQpscf7JigPaIY2b7xTm+tWVRMcaJVrpHVo23Lg=;
        b=b+5Q91nPBQWTJvIg/RM8snOHNnHpph0Inl1kCuZRedVF3VT2VC+Ufkk73pHkvshwNn
         KmEHWH3XafI6BHoD222KeD/9bbw55wZEVOKZCYI+zcGoACktQK9+o8snVlrOCBI0Vj80
         NcgPTt0clkEB5+mwNhxojCrwxKCKDx9p+k/L2tyVmqXc3Ry2m6FHwe+8FzLvqmsrc/IX
         AroBlwFX2zTwm9j2C4VY2BEhk9OfRqb+7HAJaIcVnKV2lyJgPBI2DJwlrdNnwqDBlbvb
         sHZhBa2hGDpD6O1YTpKNRGL/kPaJgpTJz0+Q8bDb+4OE2GpesTeN+LFtBWauNoDgZ4Ly
         v4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751871034; x=1752475834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJCrtQpscf7JigPaIY2b7xTm+tWVRMcaJVrpHVo23Lg=;
        b=heABwqx0CwWTC9XV1WRJV276zKb6arwPRyMd1r6ZT1Xh+66dMAPYVJzd/rHlfQEZZu
         zracIELeyl5+KRRjRXKFhNqTuVgUNph8MwZexxVwjdiDovNCxyyGy0Rmw6lfEF/1OKdZ
         mXeXwxtx0ihvidY0KLi1MBidoDVZtwlcPqU+NzvDEyeONDEIYy1Smnatx4R0G62U6r4n
         JJxJf63eIBbOEd618plVb96R5s6NvdnaFhL1kVkR2ltXZOXcb6ElJYflDTKB5/8Uin/U
         cjhIxEDqkBkEop+tmdUrOQiPtuJGBo5YIVg4kmnuWerJ1jjDRjHWbYF+9rKCzZiH5mus
         29IQ==
X-Gm-Message-State: AOJu0YzH7T4Llnm3HcqXTD1418tFwOM89RHzyDqwkvvsXRitWBBm77Gv
	kACFkKjelaTpGiLIc3CENLuNhbtvSkaYPFCFt1Ajm//aTZk4C5l4/tbQRAsOR8VpkR8=
X-Gm-Gg: ASbGnctJSlZHInTpTVe+mOWEtbRjHaUOY5OL9NPfCg5/ZwCKxnRo8nKD5/sbyYr7/oR
	uCNszhN8JsnqaOrcz0v2oe6SZGLndrN3H9Pn0TEwwnDViK1/iA64tIHLNic2gOfB7DOp+Zbdo8S
	uaU1zRTZpB8y4+ACSuKR2pcib7OMHHwH7M252StZWFojvIcwlZynLAPUK3/DXRoQyXvSkBI8tFw
	Eh7T9t8L8mAxeHJHPMN4aq/HlQHY/MqOI9XjHfleP7OaF5XuG8LXUuGxspnvaYSd387s7hHAU+w
	TxB0pMglD2MBQCjRgk1oDm5J8OyM2E5UIms925ERF7lS1xMEz7rmw3FNvkO6OnFRgXbwub6ebBx
	OZFiZPLh/agcY8/oQUymGSYw=
X-Google-Smtp-Source: AGHT+IGh2/KBCNysHt7plUCFAgV1uGLkxyUZAwvcA0Vu+vwTRDqonN+b71HZNp4xw4YPISfBYqMzdA==
X-Received: by 2002:a17:902:e5d0:b0:234:c8ec:51b5 with SMTP id d9443c01a7336-23c875e4d89mr159552995ad.53.1751871034310;
        Sun, 06 Jul 2025 23:50:34 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8431a1aasm77377635ad.15.2025.07.06.23.50.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Jul 2025 23:50:34 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v3 5/5] vfio/type1: optimize vfio_unpin_pages_remote()
Date: Mon,  7 Jul 2025 14:49:50 +0800
Message-ID: <20250707064950.72048-6-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250707064950.72048-1-lizhe.67@bytedance.com>
References: <20250707064950.72048-1-lizhe.67@bytedance.com>
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

Base(v6.16-rc4):
./vfio-pci-mem-dma-map 0000:03:00.0 16
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO UNMAP DMA in 0.135 s (118.6 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO UNMAP DMA in 0.136 s (117.3 GB/s)

With this patchset:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO UNMAP DMA in 0.045 s (357.0 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO UNMAP DMA in 0.288 s (55.6 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO UNMAP DMA in 0.045 s (353.9 GB/s)

For large folio, we achieve an over 66% performance improvement in
the VFIO UNMAP DMA item. For small folios, the performance test
results appear to show a slight improvement.

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 13c5667d431c..208576bd5ac3 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -792,17 +792,29 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
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


