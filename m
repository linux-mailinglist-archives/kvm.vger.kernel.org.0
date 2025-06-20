Return-Path: <kvm+bounces-50019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88893AE11C0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 05:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F2004A373D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 03:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D67C1F0984;
	Fri, 20 Jun 2025 03:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="bo6RUVHE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B731E8837
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 03:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389862; cv=none; b=ktCpz9UovRs98fdOCMeq+163HdRafLt0QZ9VT9yGg6+RmjcwpB46wzxgnRcvnRfDXFCi+jWSQ80iF14ZeW94I0HPf8GWUGF/H2xscv+Hs4FoHN6oJmca8z2tT/m0gUkgVJWM29O84CDBj1v55+2ygUAH/IyywIQKWRjaeiys3js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389862; c=relaxed/simple;
	bh=SYK+UWbrGNX3UbkkR8jkQm/pIxA9wBivQLpXpvCwK4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrX5kUIPbQgLvbAFZWHlwmi7Zi8nawg7XiPLnqaX+K0Owe/R8R6qno4VLKdZo0HkpQ6ujxVDRc6NK0R1Oo6lY/CtebhCMYCgvcBzDo0rgN8KmdpS104l431mOPgOKOqb0elRenneluElxw69nnhuF0O7k9ql3YsYHXfBhGuRtE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=bo6RUVHE; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-73972a54919so975475b3a.3
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 20:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750389859; x=1750994659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2YzMDv78WPG5/xYOI3b72eSmmaa1xBCqOTfcIeZ+L0=;
        b=bo6RUVHEWj/aNYwXo+exHdKMyNT9eaDfbshbnp7uwMLRiI5XUuL7N+OocSQAKHCmEJ
         5KtGZk0WCGgOovC3XQucCpXaq9pz6/NIY8+6dEyZj920Wku6UgRflxnj1YDImZ9dSCqV
         gBj5W8q4LEzod2CAgqQbi/iWh02ImbWvos7FqcqBpEXp2xevp1EitbZXfBx0BtJI24Dx
         WT9T8zsKHA3bDO9Ebo3fyPMIZW0O8Vzi6Mq6U1eD4IK8WL39rzjfsw3yHlsS6Z29PnqM
         r67c0z0f91pBiCriqyqPbg4Gs+TOY+M258LLJvMEmWnAF8f1EV4jQGgSY35cFfaVjodr
         GS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750389859; x=1750994659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z2YzMDv78WPG5/xYOI3b72eSmmaa1xBCqOTfcIeZ+L0=;
        b=f+AN2jMhRcz0werYR1+zChIfN07AK1CbDLWQseSRWmqJE1XNTjLNsNvFkLPprjEb7T
         aPZKb1KIplZ4NeD77fX0kUN0Jd+OxT5b17I74NMunHfAhdHUxNWKqNGdwPIqQkEpms9G
         5LfyxeWc/nZTSQy3O5sOr9FLdpL5/TTwNi67KEF1sNYxJaddbpwP6o0oC0P3a/3WutfY
         RNsj0vgq6EKk//928Wq5LkrrReBAWrUaTvSCgzeB9FjXLUi7+eONtZ5RwRQVlLvjoWOS
         eE0OZei5sTCupx0AwvApZUr7kBtVi96vukeJEG+z+VR0PEfPUEdA7P23/4Q4r76ZpTgn
         GFRA==
X-Forwarded-Encrypted: i=1; AJvYcCUx2z8soE3OdwdS2PX35ayA1SQ+WAA7aBfIgH8TeOpMpaPlHM9O+n7KcUrnKP5b2akJlag=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKSptwGVPe4NG+8K6CxRhOXyrBHFkfF1HwvBZA4PsMXx3EYtpG
	6HHYiOtDpUDE61TwNvkNCcKmYE2KzUCMQKJxadODFeDK13jDzFQmuzTdlayzr343RAY=
X-Gm-Gg: ASbGncvivTyjKB5tucLz1adhsGk9w3q5eatvngOwzC41fbxmUx317uGgYHF1w7JavfS
	hsiAQEnCaUKWyw228U0Qaib1Ze96T7DkJtJr15UrsPKvGczGeWWKsZV4t4juJ/TRbG+nXF4NH45
	tczbhuAWZvEb4F6/EKAcsKpHgISInp6Js7R/SSDi/IjFya63VbOcNyrM1qYZhxt/W6z59r9Exzz
	4Cnn4jK0n5j1H6VxBagPTv6PUBBq1crJ1H+6zKDYO8H1xZmxvgLWPIOnycJs2MWqbPrcitz5cYS
	OknplPUoz1XWbhkEpzSs1lMcSPjJCFFO1CX75c17SSLvXV/2BEkm+/QHSv7gvFux1k2KnVOd4sE
	9+2/D732g5qqI
X-Google-Smtp-Source: AGHT+IGXeKmUfFbuX8aA0TnmPyTEPtqZ2Lj0/H9EkIAI3yrkuvUIjWM6dz6wmIwtNCHRZ1tMl1fTIg==
X-Received: by 2002:a05:6a20:6a23:b0:1f5:7007:9eb8 with SMTP id adf61e73a8af0-22026e94585mr1952273637.16.1750389858932;
        Thu, 19 Jun 2025 20:24:18 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f12423e3sm490565a12.47.2025.06.19.20.24.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Jun 2025 20:24:18 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	david@redhat.com
Cc: peterx@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com
Subject: [PATCH v5 3/3] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Fri, 20 Jun 2025 11:23:44 +0800
Message-ID: <20250620032344.13382-4-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250620032344.13382-1-lizhe.67@bytedance.com>
References: <20250620032344.13382-1-lizhe.67@bytedance.com>
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

The performance test results, based on v6.15, for completing the 16G VFIO
IOMMU DMA unmapping, obtained through unit test[1] with slight
modifications[2], are as follows.

Base(v6.15):
./vfio-pci-mem-dma-map 0000:03:00.0 16
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.047 s (338.6 GB/s)
VFIO UNMAP DMA in 0.138 s (116.2 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.280 s (57.2 GB/s)
VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.052 s (308.3 GB/s)
VFIO UNMAP DMA in 0.139 s (115.1 GB/s)

Map[3] + This patchset:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.028 s (563.9 GB/s)
VFIO UNMAP DMA in 0.049 s (325.1 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.292 s (54.7 GB/s)
VFIO UNMAP DMA in 0.292 s (54.9 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.033 s (491.3 GB/s)
VFIO UNMAP DMA in 0.049 s (323.9 GB/s)

For large folio, we achieve an approximate 64% performance improvement
in the VFIO UNMAP DMA item. For small folios, the performance test
results appear to show no significant changes.

[1]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
[2]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/
[3]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 8827e315e3d8..88a54b44df5b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -806,17 +806,29 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
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
+		long i;
 
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


