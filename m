Return-Path: <kvm+bounces-48518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71096ACEF87
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 14:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E71C61741DD
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 12:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1053D226D10;
	Thu,  5 Jun 2025 12:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="bTm9LWdG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43531E7C1B
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749127785; cv=none; b=QkitHO3LMJ2HlkH+xFqMmhrYcsX7x0X4X4YgO/AbzFXkxRb8z5QWpaqXfgVFyv9YmJDN6Ptq1wNTdrjmHojlzbBHNN8Xb2HSsNYLMUOphT8eJRfqvsydSwjbzk9Lpwd5F6AYNT8O6YNO5Gyv4QZ1Yyk1/Qv4YMTGviN8pO/aBGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749127785; c=relaxed/simple;
	bh=vmbVw2wsurXb9j40f+2hXw8upSBNZIO88QPl82+zeq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sNZFtQVQH0wwfdQmfOtLxPENskJeYefMmkp1NyrtYUsAl6II2u2vbuN3LPndpM1jknjp/6i9zcj9O5QOGoXF3ZJON2S6Ce65virMAJX0h6dw62f/uVaA8aRGsox9e8OPsnlgCxwEvcSpL0fkDr0b3N5bW9eUIjB/RvuYfVdcz5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=bTm9LWdG; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-234d2d914bcso6413535ad.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 05:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1749127782; x=1749732582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a69UoxQiniJ12TTGhKY8q3U2LANJbh8OmrhxQdK1ePg=;
        b=bTm9LWdG/Qn9zI6oiaRxZZJkL6O8sDrArBdcRk0j98xrCc/kPlmmF0OHEScVWjpUnv
         BMkjlWWBmsx2A2xxiFga2zguTBymy2PNH13YzUepvipZ7M0KXD683A/9ks3MNMMp0Vnx
         JfkNdcRFACt45DjLXZAL2dojzLfb8aGc4TQGJHdecfU9ZGomD9muNjHN1JbThapFZjL1
         yyIQ5/TPfHm6cLDBWG+hXmvo1NHcZebrJng4pD6oMSwGUErbPKyxsgJWaPRcodeKmTBp
         v3kF61W3HHa7zXA+07LpkV4J/uYo8UDLd8Dm8gV+NFQbiX15cYG0vd/uPYophMLMqoDp
         KdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749127782; x=1749732582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a69UoxQiniJ12TTGhKY8q3U2LANJbh8OmrhxQdK1ePg=;
        b=w6jHObnZfNMhJQ5CZAJC1kk/Tvc6F5nPVTk3idTm6Rc6qHT1dWhgKh2msPwFK1611f
         mb9wxJ+ucXD37/UoFpxJjhTocdrOwxWX+zjJf9F+t29JsjseOmc9u8S6NVTrxQcaj4Xp
         CMCZgICKS4Wgv7q6B3I5ZB6qu9kM/+2zYY4vn8BtnlV/2q9AExUzxkcTDqkP6xpkooXt
         AfDlQpPhAprhhYjefwr2ensNSTfxyHPMrCs4JaM9JQ1D3YrAp/6hO2Q2Ks4o4s14II+n
         QZ9ruvx1z1C0mpccHcQZgDwPS26kTzn47DtR4R27Kxh58YVvJCAKM7xeZfZFXWhTYF8g
         Yy+g==
X-Gm-Message-State: AOJu0YwOU/GtMjR0hglMfT93ApcNMvITVcTmHdEGUDh91TQ+vRCgdwgI
	seWm/BSOq4QZ7HFik0ekkX2pn6k13EY3ebIdpTSxXJAWQ+yDZmoz/qZSOIGMCYBeDQ8=
X-Gm-Gg: ASbGnctJOZD7w5i0yO507t+RqHYHoak4gz25+9MTfWcA9T34YbNaTYBZ3jZ0WiKSvII
	HRUgMOau9FvZNGo4TSxJ+mTjy4PD9UzsDCcinb7u4PoUP0HwA8hIRvZ0Nifvdivkvph90LTVgVj
	N3lPOtIO5wZPOI7o5q6cIgkfslq67vGkWLazxaZVIxxZxAznj+wUGJ6hqzhla3XVS51cBtNz3kO
	xtGMYV54RhvgkIpZfhqrozYIzMN6MHBG0CEoA3/61rZ4FNi+UqrZY1Ye4IIJSbp2amSprdEdUVg
	Q4nxcOQOjpnUZs/sNqJYaMLJRuAi7GULsmDbRa+wDKL492hE63kBnqcnX+uLhF9e4l9aRCZYnCd
	xvNI=
X-Google-Smtp-Source: AGHT+IG1C2j2YafQGfRMV/ciHY4JTVlIZs2dvU3z8kWhKzdkG0PBX2Mp8lN+qS+9FVIWYjcMQwU5iw==
X-Received: by 2002:a17:902:ec85:b0:235:eb8d:801b with SMTP id d9443c01a7336-235eb8d8434mr71936225ad.32.1749127781995;
        Thu, 05 Jun 2025 05:49:41 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.13])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506d21f57sm119043045ad.249.2025.06.05.05.49.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 05 Jun 2025 05:49:41 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com
Subject: [RFC] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Thu,  5 Jun 2025 20:49:23 +0800
Message-ID: <20250605124923.21896-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

This patch is based on patch 'vfio/type1: optimize vfio_pin_pages_remote()
for large folios'[1].

When vfio_unpin_pages_remote() is called with a range of addresses that
includes large folios, the function currently performs individual
put_pfn() operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.

This patch optimize this process by batching the put_pfn() operations.

The performance test results, based on v6.15, for completing the 8G VFIO
IOMMU DMA unmapping, obtained through trace-cmd, are as follows. In this
case, the 8G virtual address space has been separately mapped to small
folio and physical memory using hugetlbfs with pagesize=2M. For large
folio, we achieve an approximate 66% performance improvement. However,
for small folios, there is an approximate 11% performance degradation.

Before this patch:

    hugetlbfs with pagesize=2M:
    funcgraph_entry:      # 94413.092 us |  vfio_unmap_unpin();

    small folio:
    funcgraph_entry:      # 118273.331 us |  vfio_unmap_unpin();

After this patch:

    hugetlbfs with pagesize=2M:
    funcgraph_entry:      # 31260.124 us |  vfio_unmap_unpin();

    small folio:
    funcgraph_entry:      # 131945.796 us |  vfio_unmap_unpin();

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 58 ++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 28ee4b8d39ae..9d3ee0f1b298 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -469,17 +469,24 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
 	return true;
 }
 
-static int put_pfn(unsigned long pfn, int prot)
+/*
+ * The caller must ensure that these npages PFNs belong to the same folio.
+ */
+static int put_pfns(unsigned long pfn, int prot, int npages)
 {
 	if (!is_invalid_reserved_pfn(pfn)) {
-		struct page *page = pfn_to_page(pfn);
-
-		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
-		return 1;
+		unpin_user_page_range_dirty_lock(pfn_to_page(pfn),
+				npages, prot & IOMMU_WRITE);
+		return npages;
 	}
 	return 0;
 }
 
+static int put_pfn(unsigned long pfn, int prot)
+{
+	return put_pfns(pfn, prot, 1);
+}
+
 #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
 
 static void __vfio_batch_init(struct vfio_batch *batch, bool single)
@@ -801,19 +808,48 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	return pinned;
 }
 
+static long get_step(unsigned long pfn, unsigned long npage)
+{
+	struct folio *folio;
+	struct page *page;
+
+	if (is_invalid_reserved_pfn(pfn))
+		return 1;
+
+	page = pfn_to_page(pfn);
+	folio = page_folio(page);
+
+	if (!folio_test_large(folio))
+		return 1;
+
+	/*
+	 * The precondition for doing this here is that pfn is contiguous
+	 */
+	return min_t(long, npage,
+			folio_nr_pages(folio) - folio_page_idx(folio, page));
+}
+
 static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    unsigned long pfn, unsigned long npage,
 				    bool do_accounting)
 {
 	long unlocked = 0, locked = 0;
-	long i;
 
-	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
-		if (put_pfn(pfn++, dma->prot)) {
-			unlocked++;
-			if (vfio_find_vpfn(dma, iova))
-				locked++;
+	while (npage) {
+		long step = get_step(pfn, npage);
+
+		/*
+		 * Although the third parameter of put_pfns() is of type int,
+		 * the value of step here will not exceed the range that int
+		 * can represent. Therefore, it is safe to pass step.
+		 */
+		if (put_pfns(pfn, dma->prot, step)) {
+			unlocked += step;
+			locked += vpfn_pages(dma, iova, step);
 		}
+		pfn += step;
+		iova += PAGE_SIZE * step;
+		npage -= step;
 	}
 
 	if (do_accounting)
-- 
2.20.1


