Return-Path: <kvm+bounces-52025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6C0AFFCF1
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87F271C86C09
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 08:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A500E293C7C;
	Thu, 10 Jul 2025 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="GvPDJlwY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DC7292B5B
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 08:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752137673; cv=none; b=MTDn6sMun8+uCtlqpVPBJdI+M1M/SFdiA14uiIdRpezuVB2lBjmdJcymV1IklRuNKWkNPQatbwc4n0AFzpQW6fb3/tCJo0MEnH1hIUjW92FZtjLrwEw0GW5nXnciz7xbc81KyQLERVJLAtIuHwdtPp2/XnpPD49XGwEh1cpO/Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752137673; c=relaxed/simple;
	bh=XzjoEAh+cvHyRje+0Tjj6rqGbTKwrsSfOvDNlMabzbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6jpiBCsreOzKDuyo9X3zRGDaco8aF31d1UggziUHNYJ7dxW35c0dIcYiF4kMIR1VC+BcfSEfb1f8esWZecyaFz8+AHzTgzappKkdbspI/5KVMwmWHCwEIh88GZVLa3tY7BaTrhUUlT8E9zD9JMGr26mBqwiixjTeOYGx77xfso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=GvPDJlwY; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b271f3ae786so688286a12.3
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 01:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752137672; x=1752742472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i4mO6QS2sYfv7EymtBvZKW+/VtzFT/ogV5HmARdE954=;
        b=GvPDJlwYCa0EBotRO1G6jKvgrURnBT/0qOFF844NJuPh5mxNgqDfu1uX2wJ8zJP8ra
         EfVxne82R6oR1oQXLSZguqop+c/hrZ4bq0jInTgt5v+zW4IRAmrsmuVXR/kDMsVSWu1I
         Vsccg+SLrdhwBjO2sXzvRGfwkCDGKKeKBn62SwqfO0z/XUjfPBwF/CKRFyOu+81xslUJ
         My+ASvGz68uRYFE9FT2SHjqpMQQFCJxQs/sRXvG0dt1mffn0yzMr8Roc57r5fQI6rk1f
         jKROmQJt8/7IOB4X42ro+P9uTkjZ66IsYA3Q58sUN+EN5hi5j+LVHkXrWHE+ovJvw24B
         Tvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752137672; x=1752742472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i4mO6QS2sYfv7EymtBvZKW+/VtzFT/ogV5HmARdE954=;
        b=LQVFavMThOy4JIahsjlb2inSZDHrFdluDvhRbXQctEdAaINc6LgLxRADMx0b5bIIsC
         0yaox/vTrWh97ZKr4T1RSMrndTwnQOfUBDWR9Z8SWVsg8YK0zgmppiByZYtpjKSq7VdR
         JoUmLvRqQl2EPLAI18GO/fheUI8xPqmjjA0g/C94+gyxb49ZH/QO+mL8FMjzOvumBcfW
         qf6PaTr/5P5pUA5u7L0i9oF6DPsM4DHaqkGN376LxhgEFlQQliZseAfrBfuYg1SV9Q4U
         K/BYiqhg4Uo4koSa7Qgd2LGHOkWnv6fFNExuVI1NFMgu8/Z2LbwZXtH00+0LGzxMLvEw
         g7xA==
X-Gm-Message-State: AOJu0Ywsx0FWyjE4WlCWSEp/5gRuymPrFkIk6LmfMdSWdo/EQTuikovC
	shTePTigQO6i5ZC3e1JYuLOG8m3Ss3Y/EO5vGKa/8mk6rX4CjjF9osDPAgI4yZ2E9m2DFyDvrgy
	EfJFU
X-Gm-Gg: ASbGncuiSEKuhsYLf+41VEeci2f2/Cl3TpLEQv+H9gSIX3r28Uv+s0YP3lWTHr7r4/i
	VNM+ve5GJLDSZBAp40A+Ko7lJIwLHAYKl6Bt2IzABFzcZyGKw0C02p7GTodanaT+ylDsGI1ne2G
	s9tMdhTqj3XcPwDrLhke/qPVE11+lCnxcQ8TRhMvYMUmRhkIBino3UTZGp4g5bs030PTcp73/Jh
	y/k5XJb0g/qs1k34IpOXBXpSrp1zQyVnhbYYHMeoS1gBoak3mwpChFxB5ZWN4ORC5sqwMFVQjIu
	QQM2o5evSWwU90fx9MOUmjiMTx4XYuEoWLFIb208JBpMYGm4EbIFV29Ib3B/0mWruQ5QYZ8UCBu
	NSBL+aJSF03Hllg==
X-Google-Smtp-Source: AGHT+IHpGnM8/RSgCKrl528Fh5n6c4YlUKSZpBOagB5O4dzJXeVEsMY3FEHcb5l/h+FzLkNngxE9NQ==
X-Received: by 2002:a17:90b:4a4a:b0:311:b005:93d4 with SMTP id 98e67ed59e1d1-31c2fdd1479mr9203981a91.25.1752137671529;
        Thu, 10 Jul 2025 01:54:31 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c3e975d41sm1650228a91.13.2025.07.10.01.54.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Jul 2025 01:54:31 -0700 (PDT)
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
Subject: [PATCH v4 5/5] vfio/type1: optimize vfio_unpin_pages_remote()
Date: Thu, 10 Jul 2025 16:53:55 +0800
Message-ID: <20250710085355.54208-6-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250710085355.54208-1-lizhe.67@bytedance.com>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
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
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 61455d725412..133f284ae168 100644
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


