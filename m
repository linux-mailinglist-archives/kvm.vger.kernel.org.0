Return-Path: <kvm+bounces-49416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97368AD8D52
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECDE917F56C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 13:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB8519DF8B;
	Fri, 13 Jun 2025 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPWzHmps"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663C195811
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822085; cv=none; b=nvb6tqNPX1pG+BPqzxjrlnFFVpaQ7WNae4RagWulRB+ibzmKLF/L2wx/BmYIdQVJ8aJICJiayeedxa8V9Eu+c+BiyKVutB6ex9RNQBlUC7BZeuzjWHas/g/Z2LgODrjyT4/XF+Lha6DP2UZCoClMqm1jGmPa8nocobHr3rMEOWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822085; c=relaxed/simple;
	bh=IG4FGgbLqBxGp2REQK9VMac2EIQLzuWAExl8Q4V6oog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okADH50qErj9oDe2+5n1k6hU1lfpDF3g8jUDt213tA04lxE95L4BmLb4J1KwBHmKD4QUYn+1fAnTm/d2xfHEpvd9yJitAWU+LN+MSXWqm90YZ9lYBCxT6nx1dKdLobp+xubv9Cn/P/QbBKvGIjsJS/36aUtjAZCWloPUkopF/hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPWzHmps; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749822082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v/F+9x18GPW2fMOX0xB9ZVXh7FNtANzBJLNRs0BqoEY=;
	b=NPWzHmpsAdQh45h+uaov18M2ojas2bfAelaLCCRpdt3p83XrtlBRl4nt3hz7o5J14eyjoJ
	ZGLFth4CfD0z+KpgxvKgbCJLhIe0MQzb/g/YqaKfCTbJilgA8kXr3xMFXBsn4jb33IuDqL
	dEDS2aG33NhL4hn2jxRyezT0ze6Dabs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-WKpjVWZBMoKJAePI2BI9XA-1; Fri, 13 Jun 2025 09:41:21 -0400
X-MC-Unique: WKpjVWZBMoKJAePI2BI9XA-1
X-Mimecast-MFC-AGG-ID: WKpjVWZBMoKJAePI2BI9XA_1749822081
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5bb68b386so685973785a.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749822081; x=1750426881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v/F+9x18GPW2fMOX0xB9ZVXh7FNtANzBJLNRs0BqoEY=;
        b=HJICbkQzzOspbLUHWd985gXbTnlmwrAKsGqOiGerv4B2QkjyI7m9KG2t9ZV9ZUwwd0
         FCLrjZPnM1mwni4DM8Zvm5k2OAaWGHlQBDASAa+9W2GV9Yy1K6gQK07BSyUFPKsuPcI9
         VgReQRxkNGvEi77HhCtuJ12EQHvm16x1oTUhIi3gyRZ45+b+pNDzkeqUkMX/iwgSNEo+
         M3AR7OPQohwPYU8zljLrcBt/daUZoPoNT/5v/xPEuJJ0CELVMJhYEgj2wubh16po5bGp
         zTAdrHNpEJzBRVR6CmsoAZjHhw2Slo4RJielYKn0mcDqA5/GefHjWr+CDVk9+8hvgoC3
         4YrQ==
X-Forwarded-Encrypted: i=1; AJvYcCU60uEozxvtEDuefNFTIsMZDz5OvXuSi9x3P6z0Q5kTzdHgRtUpXn94/tn2p7pQ9ctX8rE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIpnXzc9x77npyWSsxo/pv4+HCwjnWrDY/omuqeFxvtzs2HRG0
	CikWreiG7NeIXdnOl3+uO4nNvmNtLGXtYBPFatS/b6M3wMJ/ywEPceo34C70bik2RzdBB+OyzD3
	1cb9zvqthMJy1It9lteYwgN30b+KNh96nDk8ONM2eBdKZrDa4XLleeQ==
X-Gm-Gg: ASbGncuVuhR+YP4FpREK7GDXNferqUw99YhXdDci68YeaMUctrX1v+QX+M2C4iMdulL
	9282l6H42n0AXi5Pv0RA7F9nA4c5jQvGy5e0CygZWTlEJGk9V+odjr38DqrBhIRsZmnMn4JX70C
	VWxfnELhhWJnYlRYL7jc/X1k9NfL3ljVkVTA6MVbiOfI87dlkYvZ8esnUsNNh7i/mbNUdLyF/pR
	KiYm1B9AgvUInhNq7uvGV12gDO+ZS/+4yI1SLFw08CJs3TAiI2SNqeJEazxs307pLLSL60SgT44
	Czg5IRJmTJ8=
X-Received: by 2002:a05:620a:2628:b0:7d3:ad22:7851 with SMTP id af79cd13be357-7d3bc47c25bmr596011985a.54.1749822081243;
        Fri, 13 Jun 2025 06:41:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IED+auoBj/loYopQZCrkvQWTc00gLx9IMXiqmfkt7NzTeF6mlRUzM1RQY37rgcn1p4Rs3RbhA==
X-Received: by 2002:a05:620a:2628:b0:7d3:ad22:7851 with SMTP id af79cd13be357-7d3bc47c25bmr596008385a.54.1749822080787;
        Fri, 13 Jun 2025 06:41:20 -0700 (PDT)
Received: from x1.com ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8ee3f72sm171519285a.94.2025.06.13.06.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 06:41:19 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kvm@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	peterx@redhat.com,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>
Subject: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to mm_get_unmapped_area_aligned
Date: Fri, 13 Jun 2025 09:41:09 -0400
Message-ID: <20250613134111.469884-4-peterx@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613134111.469884-1-peterx@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function is pretty handy for any type of VMA to provide a size-aligned
VMA address when mmap().  Rename the function and export it.

About the rename:

  - Dropping "THP" because it doesn't really have much to do with THP
    internally.

  - The suffix "_aligned" imply it is a helper to generate aligned virtual
    address based on what is specified (which can be not PMD_SIZE).

Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/huge_mm.h | 14 +++++++++++++-
 mm/huge_memory.c        |  6 ++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2f190c90192d..706488d92bb6 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -339,7 +339,10 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags,
 		vm_flags_t vm_flags);
-
+unsigned long mm_get_unmapped_area_aligned(struct file *filp,
+		unsigned long addr, unsigned long len,
+		loff_t off, unsigned long flags, unsigned long size,
+		vm_flags_t vm_flags);
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
@@ -543,6 +546,15 @@ thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 	return 0;
 }
 
+static inline unsigned long
+mm_get_unmapped_area_aligned(struct file *filp,
+			     unsigned long addr, unsigned long len,
+			     loff_t off, unsigned long flags, unsigned long size,
+			     vm_flags_t vm_flags)
+{
+	return 0;
+}
+
 static inline bool
 can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4734de1dc0ae..52f13a70562f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1088,7 +1088,7 @@ static inline bool is_transparent_hugepage(const struct folio *folio)
 		folio_test_large_rmappable(folio);
 }
 
-static unsigned long __thp_get_unmapped_area(struct file *filp,
+unsigned long mm_get_unmapped_area_aligned(struct file *filp,
 		unsigned long addr, unsigned long len,
 		loff_t off, unsigned long flags, unsigned long size,
 		vm_flags_t vm_flags)
@@ -1132,6 +1132,7 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
 	ret += off_sub;
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mm_get_unmapped_area_aligned);
 
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags,
@@ -1140,7 +1141,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 	unsigned long ret;
 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 
-	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
+	ret = mm_get_unmapped_area_aligned(filp, addr, len, off, flags,
+					   PMD_SIZE, vm_flags);
 	if (ret)
 		return ret;
 
-- 
2.49.0


