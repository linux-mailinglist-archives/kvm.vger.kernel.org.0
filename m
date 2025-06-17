Return-Path: <kvm+bounces-49657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2961ADC031
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1E5E3A22CF
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972BE23BD06;
	Tue, 17 Jun 2025 04:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Q2gUkw3r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03E923B63E
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 04:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750133945; cv=none; b=t5f+XJwCqxln++hCqDXDuCT9pn1VsET1o3BrIdDicc0l/zhZuO/wcJWUkNCGHf9A2Yu35opNOQYFxkfNYcPTgfFvxXMVIB2rAIy/HDqYNRLB408Byzlrb1+yOTmhRqX/GyrAXg2jMyC3P64Q9r7h1/8v3PIDHvlyC8dMKaryPjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750133945; c=relaxed/simple;
	bh=9yTwG677xHIKywB9F1vTvU6hKUvXiGxwJv/De0T4VnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezTNK+0qOb2iG9A8tcmUe/KwWHoyeIWFyKQYKlCUBdAIuoGwCAfX0flce3XH3oV5IA3P0qPNNP6hRtdQtlc9ro7DSpOGhKrEjwInnO57X2EIow6aiGz61v8LIWZiVq2Cl3tdeSVr9tVaOT+Tp409lVcs0sLyyKBJTAykr6KxVUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Q2gUkw3r; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2360ff7ac1bso36554105ad.3
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 21:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750133943; x=1750738743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tfXoidyywq4prG1qxFfXKWvZLzM8FnofZM+bLZ5UOeQ=;
        b=Q2gUkw3rgxpnciNf37XKxzt6F7FBJMwtV0OiaIGWz1ZKyilFK+yIyk2KKpBvAdLwMd
         Vk8xZD4yk4V4IPfRuaWja/av24697fyi7mM0qmlKTnvWTOHA6aRO2l6aIZu5z7YobYHk
         zlt2gT0MFkcvTirnfLi20fJwVUo/CFNyjK8eKGwI5jwILVLgx+L+M15jgAvJ/EzQ3Njj
         sqqZp6/NduKtRkyJXh6s0J6uurPDAD8xibaRyF533DwvIEdsDOFongdOnm3Pmq8MFavY
         navNtjSbP1NhGFlpO8cXWyivLhBRuB6ICohEI0oa235K64IhyBqVwflVqqxFGWtbnUTw
         7q0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750133943; x=1750738743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tfXoidyywq4prG1qxFfXKWvZLzM8FnofZM+bLZ5UOeQ=;
        b=sQ0Et292+gGFzTyOPC5orxBoCh28NLu3GOsoAw9zN/EyToAxoe95HS8ZemVYiv2n1Y
         pnB/HfzhW4bRCxVvYT8m/3Fqg/Yz2WXzafzx45mA2jOPm/xPxB0Q/ozXKNXoutcsPpd8
         CRjXT2eGdBuReVKPzaJIuBYYDGcnYAFG7kz1ZBUi12h6ls61+ev5AY6iBJ6ZRfStCSpz
         Bm4aGJ+R8HDTsD54S4iUOOSh+H2u7dNYZpFM6xxukLMaQEniZtspLzBpqpXyBoG7cNG5
         LlxXomz7CLf+TxBk8cya50sVVPsmuIpPQ5gmHMKviXihXc/LNG9qCibSfKQVbrWyliyQ
         b1zg==
X-Gm-Message-State: AOJu0Yyi+eBVdVTWFGIdTofr1wEzwuuy3dRvgmjujooblQZwYkjt94Ij
	f17O/4R+Eszh06n5m3RWFHV4Z/UcIRFyQvgKQfqUwPDnTi/a2toNtJoSc84Hf/8DPFw=
X-Gm-Gg: ASbGncsZsCyYrnm5AU75pPobf+3NBZ8c8s4DjF9d0AzU7safiTb4qjRPwpIsyVu3Nex
	Ppdq4UXqBhEhfyQzrHUERcSaLxrjAVC9Vzx6V8EulkLQ5GcDOnusmQkk/wxGXkTD2L/U6amn3kv
	/UG0KZnZeW4r8tJEthr9xat9pihAHXHGlz0E2jU1jIhOBdoMJWYlQR032ECBl6zOrKoY5rAhTF8
	q50dWU/gYsfubnxWn+5frGB1Ojv44OrdYstLwWMbRS8v8eMC8oi7svaxfogRvaZyIgRnUalagQu
	2Y7hcvugy0N0b8aYEi8K458axDWlI7g3FEKYL3kGelbgqYCdLoSDee/Ql3srRnC7K+ovPFEBwxO
	+gEZ4rMSzjGh5vw==
X-Google-Smtp-Source: AGHT+IHqTbrzP939yrSnByQC0rtnaJOgibU9Byk10ulJjvMNZlvHwikXDBV86s1p8bsCh5VpmAqFCw==
X-Received: by 2002:a17:902:d481:b0:231:d0a8:5179 with SMTP id d9443c01a7336-2366b003c6cmr173603795ad.23.1750133943270;
        Mon, 16 Jun 2025 21:19:03 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88c029sm69798345ad.26.2025.06.16.21.18.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Jun 2025 21:19:02 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v4 3/3] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Tue, 17 Jun 2025 12:18:21 +0800
Message-ID: <20250617041821.85555-4-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250617041821.85555-1-lizhe.67@bytedance.com>
References: <20250617041821.85555-1-lizhe.67@bytedance.com>
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

This patch optimize this process by batching the put_pfn() operations.

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
VFIO MAP DMA in 0.294 s (54.4 GB/s)
VFIO UNMAP DMA in 0.296 s (54.1 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.033 s (485.1 GB/s)
VFIO UNMAP DMA in 0.049 s (324.4 GB/s)

For large folio, we achieve an approximate 64% performance improvement
in the VFIO UNMAP DMA item. For small folios, the performance test
results appear to show no significant changes.

[1]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
[2]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/
[3]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 35 +++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index e952bf8bdfab..159ba80082a8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -806,11 +806,38 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    bool do_accounting)
 {
 	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
-	long i;
 
-	for (i = 0; i < npage; i++)
-		if (put_pfn(pfn++, dma->prot))
-			unlocked++;
+	while (npage) {
+		long nr_pages = 1;
+
+		if (!is_invalid_reserved_pfn(pfn)) {
+			struct page *page = pfn_to_page(pfn);
+			struct folio *folio = page_folio(page);
+			long folio_pages_num = folio_nr_pages(folio);
+
+			/*
+			 * For a folio, it represents a physically
+			 * contiguous set of bytes, and all of its pages
+			 * share the same invalid/reserved state.
+			 *
+			 * Here, our PFNs are contiguous. Therefore, if we
+			 * detect that the current PFN belongs to a large
+			 * folio, we can batch the operations for the next
+			 * nr_pages PFNs.
+			 */
+			if (folio_pages_num > 1)
+				nr_pages = min_t(long, npage,
+					folio_pages_num -
+					folio_page_idx(folio, page));
+
+			unpin_user_folio_dirty_locked(folio, nr_pages,
+					dma->prot & IOMMU_WRITE);
+			unlocked += nr_pages;
+		}
+
+		pfn += nr_pages;
+		npage -= nr_pages;
+	}
 
 	if (do_accounting)
 		vfio_lock_acct(dma, locked - unlocked, true);
-- 
2.20.1


