Return-Path: <kvm+bounces-73317-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eCg9Ce/mrmlzKAIAu9opvQ
	(envelope-from <kvm+bounces-73317-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:27:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C6723BA52
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C34263058334
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDCE3D7D74;
	Mon,  9 Mar 2026 15:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vIzLDFSz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF6A3D34BE;
	Mon,  9 Mar 2026 15:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069566; cv=none; b=KbJ/uGmighmHHPFIDz0cD+x2llCbjPewBh60orK4mxN3g+LtsQq0Y50RVCwo9l/CXF28J4P0kxtStJWarvo9LLZqNNGoayxpt4LsVLOjrJJMytfr2bkoog5L4Ln4pR9OfT6uw/Q574VwEgt/DsDRmVz8NP/MD18a6uLHX6ucIUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069566; c=relaxed/simple;
	bh=Mhr7tHNnk4w6+iI/utOSEhEAAttuf6c8xcPh/66ACkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsceX3RQ3UBZPS8zdo+5poIMfozXRUQhp1898vTyc2hUSF247uyXN4KDySZHrg8lW6Lbl36msCsqGiw3sIcE78Xk7BbIddqYvDUe4G9+ulGvcoh1bi0S4mYSk8J2XfHOJJaF+6j54BNlu2GAKxWv+up1UoQMl/w5rjg9sxw09Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vIzLDFSz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B98AC4CEF7;
	Mon,  9 Mar 2026 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069566;
	bh=Mhr7tHNnk4w6+iI/utOSEhEAAttuf6c8xcPh/66ACkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIzLDFSzRjakKohtre+2VeVYCY78KNKV3+vsvOm4E91ML/9l4r5EZZ+H73I/hKO3F
	 +ymncYI/de8NbufE4brWEUyrTiWHk5hR4K/ODmDyvuR8uVZXpCDVCky0p3O0yIIj/V
	 5/S/nWoXlmvP+gF3GyW18r8iURaGdQ7QSgf7rHclKZkN+mavll8dKHMfh11QOJA8qF
	 pn777/LRL7Y0CRCImdIB7ue6zCaTupvWYrAu67gKmPH76E13Cg6AbI7tb59lhTh8Rx
	 0Y9XxMlJvjbf32TuaMTLmyoKbJKfWIHiR7E9KZqnbICSP+ItP6CoXrazRZ5L2DRS/Z
	 auQaLD4Xrx4vg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 2/4] mm: move vma_mmu_pagesize() from hugetlb to vma.c
Date: Mon,  9 Mar 2026 16:18:59 +0100
Message-ID: <20260309151901.123947-3-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309151901.123947-1-david@kernel.org>
References: <20260309151901.123947-1-david@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95C6723BA52
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,lists.ozlabs.org,vger.kernel.org,kernel.org,linux-foundation.org,linux.ibm.com,gmail.com,ellerman.id.au,linux.dev,suse.de,oracle.com,google.com,suse.com,redhat.com,intel.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73317-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.991];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

vma_mmu_pagesize() is also queried on non-hugetlb VMAs and does not
really belong into hugetlb.c.

PPC64 provides a custom overwrite with CONFIG_HUGETLB_PAGE, see
arch/powerpc/mm/book3s64/slice.c, so we cannot easily make this a
static inline function.

So let's move it to vma.c and add some proper kerneldoc.

To make vma tests happy, add a simple vma_kernel_pagesize() stub in
tools/testing/vma/include/custom.h.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h            |  7 -------
 include/linux/mm.h                 |  2 ++
 mm/hugetlb.c                       | 11 -----------
 mm/vma.c                           | 21 +++++++++++++++++++++
 tools/testing/vma/include/custom.h |  5 +++++
 5 files changed, 28 insertions(+), 18 deletions(-)

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
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 802a76317245..4305a5b6e433 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -117,3 +117,8 @@ static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
 			vma_flag_set(&flags, bits[i]);
 	return flags;
 }
+
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	return PAGE_SIZE;
+}
-- 
2.43.0


