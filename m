Return-Path: <kvm+bounces-73011-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CIKeDtOpqmnjVAEAu9opvQ
	(envelope-from <kvm+bounces-73011-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:17:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 93CF421E90F
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:17:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6871930783BE
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 10:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8923793B5;
	Fri,  6 Mar 2026 10:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYcnWM2P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F91837BE92;
	Fri,  6 Mar 2026 10:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792190; cv=none; b=dYlNUetI8RakasngDRImTQb9Ga9id/Pcabn1XXmjIjuoJ0HtZoYzqlo7w6Y/NMdrTBnnKf8aC9KDRjJr2jaUIsnzkBj0vztezsNEipJCIUBZ74F2wk3UJ5X2OJ1hLWq4791wDs7hgWzEiyog4jOHu6WF2BXwh/xSry7tLwX22wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792190; c=relaxed/simple;
	bh=KFS0WOpkdK9snEXTKSGUmyIFzfkZVmc/zggsd23+mPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTfEsGW9qNEqwe+XqgLhk7UhsqgYE1GADVJNkkK/BFw0SValxojgTdFDCcI709su6VtRCgBWIaRzBmt+LNfPufdWzVcg0GjCgHNLfsPLvNYfjgFho0royv+RUsw1KSf1ZGd/BmcUr7iYBEFWddvFFU4teeLtbow+dsC1oKdM1i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYcnWM2P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC97C19422;
	Fri,  6 Mar 2026 10:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772792190;
	bh=KFS0WOpkdK9snEXTKSGUmyIFzfkZVmc/zggsd23+mPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYcnWM2PgaWt6KxKlBcserIDb5ISS2Ic/hH+YyGWSC4Cqq2/USjVGANct3h7BfHt4
	 iW6y0uLP8t4sYT4ySUgqzDyj4hDrff4hHN/PsXcs9QvO7K5FLNGeCyZ/3DVJylLgRe
	 7U2K54YOXWxerIVfnPyqlMMrGP9bFizxosZUiJIyP2Uiw4DHt8jGnRqacwq3A12d7+
	 Skem0a5LGx7Pbjrufkhom/w2uXLP+r0yyLjY7Y8IleoxyTanIrXRvDUGqL2b1vIMsE
	 CWDPWCecGQaqHgSNqdgWeuVPq7Kx30S2PKeKYHQjxvifSKd140d8SVhWR94UrscsZF
	 qLJZBmv+f7EjA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v1 2/4] mm: move vma_mmu_pagesize() from hugetlb to vma.c
Date: Fri,  6 Mar 2026 11:15:58 +0100
Message-ID: <20260306101600.57355-3-david@kernel.org>
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
X-Rspamd-Queue-Id: 93CF421E90F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73011-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

vma_mmu_pagesize() is also queried on non-hugetlb VMAs and does not
really belong into hugetlb.c.

PPC64 provides a custom overwrite with CONFIG_HUGETLB_PAGE, see
arch/powerpc/mm/book3s64/slice.c, so we cannot easily make this a
static inline function.

So let's move it to vma.c and add some proper kerneldoc.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h |  7 -------
 include/linux/mm.h      |  2 ++
 mm/hugetlb.c            | 11 -----------
 mm/vma.c                | 21 +++++++++++++++++++++
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 44c1848a2c21..aaf3d472e6b5 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -777,8 +777,6 @@ static inline unsigned long huge_page_size(const struct hstate *h)
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
-
 static inline unsigned long huge_page_mask(struct hstate *h)
 {
 	return h->mask;
@@ -1175,11 +1173,6 @@ static inline unsigned long huge_page_mask(struct hstate *h)
 	return PAGE_MASK;
 }
 
-static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
-{
-	return PAGE_SIZE;
-}
-
 static inline unsigned int huge_page_order(struct hstate *h)
 {
 	return 0;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 227809790f1a..22d338933c84 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1327,6 +1327,8 @@ static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 	return PAGE_SIZE;
 }
 
+unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 66eadfa9e958..f6ecca9aae01 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1017,17 +1017,6 @@ static pgoff_t vma_hugecache_offset(struct hstate *h,
 			(vma->vm_pgoff >> huge_page_order(h));
 }
 
-/*
- * Return the page size being used by the MMU to back a VMA. In the majority
- * of cases, the page size used by the kernel matches the MMU size. On
- * architectures where it differs, an architecture-specific 'strong'
- * version of this symbol is required.
- */
-__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
-{
-	return vma_kernel_pagesize(vma);
-}
-
 /*
  * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
  * bits of the reservation map pointer, which are always clear due to
diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..e95fd5a5fe5c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3300,3 +3300,24 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 
 	return 0;
 }
+
+/**
+ * vma_mmu_pagesize - Default MMU page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * In the common case, the default page size used by the MMU matches the
+ * default page size used by the kernel (see vma_kernel_pagesize()). On
+ * architectures where it differs, an architecture-specific 'strong' version
+ * of this symbol is required.
+ *
+ * The default MMU page size is not affected by Transparent Huge Pages
+ * being in effect, or any usage of larger MMU page sizes (either through
+ * architectural huge-page mappings or other explicit/implicit coalescing of
+ * virtual ranges performed by the MMU).
+ *
+ * Return: The default MMU page size granularity for this VMA.
+ */
+__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
+{
+	return vma_kernel_pagesize(vma);
+}
-- 
2.43.0


