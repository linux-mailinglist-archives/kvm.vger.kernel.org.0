Return-Path: <kvm+bounces-28608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B1B999A13D
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 12:25:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 449D7B21166
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 10:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230DB212D37;
	Fri, 11 Oct 2024 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YRvUPBv9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A0620C476
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 10:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728642309; cv=none; b=lTjGgX20uir6a70RsPBHyNSyNH9/ohN1zv3XXNnuQt04nQ4vjuyCjhNq7h5yxnuBdYyh7SDWE5rUIoEue4yf76tH1HUO4FlBmVDkNvRgmkcuW+ckfc/PCaersBEwl6Slp4atlwU+bLCiFbYIG5JDqsBvA0TGW9a/iylYlfR8JyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728642309; c=relaxed/simple;
	bh=r91IR9RnNN1IZS82gFZ8gu0zseWnOomd+jSCq/BfdW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGAIa6n18tQNATptLnlmWPr3JSQci4yCYIQNSwC90DIjIMRN/p93hXMCc73gRo5/AqlOiKcw+LRlOURZrbw6RFblcfcDlNmFNEq2+eJFSGoWPuzXPrC3q++uW/ebc/Yfh9YCCQZsbomn05mt05nI3X+XBHpEz0q2z5hINOw8A5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YRvUPBv9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728642306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VMssNf1Ju+sw1bhZpq8lk0Jjp7pzX4VBi27YvpYNCzI=;
	b=YRvUPBv9zP5NMDpejjomNmR8r4LWaBnl4hx2xdYhybq1yXwbBzJAAvDVDDvZWain3vUsMm
	UPNLH0Z70dRXJ812Ol179ZWeXUh9jGgAnyJFIJyl/6aDxQxCKF6tMFKV2c1KY+4nhE5285
	LKVIvTg0BRgGetUilkIeSRDcILzjRaM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-543-pXT2G1CgOGWkQX4PSZq0Wg-1; Fri,
 11 Oct 2024 06:25:00 -0400
X-MC-Unique: pXT2G1CgOGWkQX4PSZq0Wg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D2C11955F07;
	Fri, 11 Oct 2024 10:24:58 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.80.4])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1B6E91955F42;
	Fri, 11 Oct 2024 10:24:52 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Thomas Huth <thuth@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v1 1/2] mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()
Date: Fri, 11 Oct 2024 12:24:44 +0200
Message-ID: <20241011102445.934409-2-david@redhat.com>
In-Reply-To: <20241011102445.934409-1-david@redhat.com>
References: <20241011102445.934409-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Kefeng Wang <wangkefeng.wang@huawei.com>

Add vma_thp_disabled() and thp_disabled_by_hw() helpers to be shared by
shmem_allowable_huge_orders() and __thp_vma_allowable_orders().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
[ rename to vma_thp_disabled(), split out thp_disabled_by_hw() ]
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/huge_mm.h | 18 ++++++++++++++++++
 mm/huge_memory.c        | 13 +------------
 mm/shmem.c              |  7 +------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 67d0ab3c3bba..ef5b80e48599 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -322,6 +322,24 @@ struct thpsize {
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
 
+static inline bool vma_thp_disabled(struct vm_area_struct *vma,
+		unsigned long vm_flags)
+{
+	/*
+	 * Explicitly disabled through madvise or prctl, or some
+	 * architectures may disable THP for some mappings, for
+	 * example, s390 kvm.
+	 */
+	return (vm_flags & VM_NOHUGEPAGE) ||
+	       test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags);
+}
+
+static inline bool thp_disabled_by_hw(void)
+{
+	/* If the hardware/firmware marked hugepage support disabled. */
+	return transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED);
+}
+
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 87b49ecc7b1e..2fb328880b50 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -109,18 +109,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	/*
-	 * Explicitly disabled through madvise or prctl, or some
-	 * architectures may disable THP for some mappings, for
-	 * example, s390 kvm.
-	 * */
-	if ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		return 0;
-	/*
-	 * If the hardware/firmware marked hugepage support disabled.
-	 */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
diff --git a/mm/shmem.c b/mm/shmem.c
index 4f11b5506363..c5adb987b23c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1664,12 +1664,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	loff_t i_size;
 	int order;
 
-	if (vma && ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
-		return 0;
-
-	/* If the hardware/firmware marked hugepage support disabled. */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
+	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
 		return 0;
 
 	global_huge = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.46.1


