Return-Path: <kvm+bounces-73010-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KCDxDKapqmniVAEAu9opvQ
	(envelope-from <kvm+bounces-73010-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:17:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BE05C21E8F8
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6E153055D6F
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 10:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B114B37B024;
	Fri,  6 Mar 2026 10:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kU39nsPR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AF234F27B;
	Fri,  6 Mar 2026 10:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792188; cv=none; b=MPeUY/zSpHipPTEBZ7Q6hjCDUKb7GBUxTYMsD1z4OU8Ma2uDQSzM/PE+jmA5drM2eHaxewNl/sK31uE62dIbBaryKe4+ya1Bi2QI9EFwCWaMxUBXY9gTMkV/l//qeebCY6QYU9+S7ROcuayy5O+wE5O6voLUDTgVQtPzb9d8cZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792188; c=relaxed/simple;
	bh=wXe+RSv0ZEZP5PzCGaEji2iLfOC9MuiizNczqfoD3ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2YoRFBE5B32OAXlQI84NN7vHts85MH34KMFOGRCjW3D/nneAgnAoIrGOSGPfrbiep7RzKraKTZ7qhtQAqcUtQZRBTFX1j3M1mqe5QUntRQDb/kMNdozdnNJmU9YauH/oO4IrsZp7YFx3fmHENskrX7mZNafSZEHB9JN0uEtGKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kU39nsPR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365D2C19422;
	Fri,  6 Mar 2026 10:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772792187;
	bh=wXe+RSv0ZEZP5PzCGaEji2iLfOC9MuiizNczqfoD3ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kU39nsPRVeuy80Xot7u6yG6vMyTyS6h997P73CrnD4Uyqpy624AKPN+ubADcvkfjP
	 a9iQwyewJuuytTvKDcC/8rOKLTG+an15rRuwx+T+iSmhFomRVzbckAYuOcC2XpFSfW
	 VJQPEroBKqE353sSdphB/CJ63WiHqv/e3xNlbCxcDuNrYeksB/HvFo1KsposSbh8Sl
	 PI28L4pG8bvlXORzyDFf9BS12DIJAg4ARA2xLpvXN7ZI6dl/T25TwCjGcuIUXAqM0S
	 xf0xFt+3UQAMKk0VL72N2I+xwG9I0cY3dWhbq9dS0zjPmHnC7FnkAFx/4kfoe9mtCY
	 hIfrH0bn+WFaA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 1/4] mm: move vma_kernel_pagesize() from hugetlb to mm.h
Date: Fri,  6 Mar 2026 11:15:57 +0100
Message-ID: <20260306101600.57355-2-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306101600.57355-1-david@kernel.org>
References: <20260306101600.57355-1-david@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE05C21E8F8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73010-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

In the past, only hugetlb had special "vma_kernel_pagesize()"
requirements, so it provided its own implementation.

In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
vm_operations_struct") we generalized that approach by providing a
vm_ops->pagesize() callback to be used by device-dax.

Once device-dax started using that callback in commit c1d53b92b95c
("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
it was missed that CONFIG_DEV_DAX does not depend on hugetlb support.

So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
would not pick up that value.

Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
implementation. While at it, improve the kerneldoc a bit.

Ideally, we'd move vma_mmu_pagesize() as well to the header. However,
its __weak symbol might be overwritten by a PPC variant in hugetlb code.
So let's leave it in there for now, as it really only matters for some
hugetlb oddities.

This was found by code inspection.

Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h |  7 -------
 include/linux/mm.h      | 20 ++++++++++++++++++++
 mm/hugetlb.c            | 17 -----------------
 3 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..44c1848a2c21 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -777,8 +777,6 @@ static inline unsigned long huge_page_size(const struct hstate *h)
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
-
 extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
 
 static inline unsigned long huge_page_mask(struct hstate *h)
@@ -1177,11 +1175,6 @@ static inline unsigned long huge_page_mask(struct hstate *h)
 	return PAGE_MASK;
 }
 
-static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	return PAGE_SIZE;
-}
-
 static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
 {
 	return PAGE_SIZE;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 44e04a42fe77..227809790f1a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1307,6 +1307,26 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_kernel_pagesize - Default page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * The kernel page size specifies in which granularity VMA modifications
+ * can be performed. Folios in this VMA will be aligned to, and at least
+ * the size of the number of bytes returned by this function.
+ *
+ * The default kernel page size is not affected by Transparent Huge Pages
+ * being in effect.
+ *
+ * Return: The default page size granularity for this VMA.
+ */
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
+		return vma->vm_ops->pagesize(vma);
+	return PAGE_SIZE;
+}
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1d41fa3dd43e..66eadfa9e958 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1017,23 +1017,6 @@ static pgoff_t vma_hugecache_offset(struct hstate *h,
 			(vma->vm_pgoff >> huge_page_order(h));
 }
 
-/**
- * vma_kernel_pagesize - Page size granularity for this VMA.
- * @vma: The user mapping.
- *
- * Folios in this VMA will be aligned to, and at least the size of the
- * number of bytes returned by this function.
- *
- * Return: The default size of the folios allocated when backing a VMA.
- */
-unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->pagesize)
-		return vma->vm_ops->pagesize(vma);
-	return PAGE_SIZE;
-}
-EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
-
 /*
  * Return the page size being used by the MMU to back a VMA. In the majority
  * of cases, the page size used by the kernel matches the MMU size. On
-- 
2.43.0


