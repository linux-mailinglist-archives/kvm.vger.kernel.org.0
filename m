Return-Path: <kvm+bounces-69277-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJFcI30TeWkcvAEAu9opvQ
	(envelope-from <kvm+bounces-69277-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:35:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2239499F20
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DF5C53066833
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A16C36E491;
	Tue, 27 Jan 2026 19:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5//S+1U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA0D36CDFD;
	Tue, 27 Jan 2026 19:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769542231; cv=none; b=cH2d7rX0r4dMUF6kL7VUbe0dyRe5ZJ1eEK3UC9hlFgt0ZzIHSuHpMyGhXmDgY8dFR4xKXZXz3TGgbkbmI3yoI1lzqnzFJu9HFeeb+UNC8XUFZhJS+Tg41aSZjEU9KiSwdj9F+HdnmL0WpeEwaI7TpHwrPz0yl+bvu4PUYnWu3XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769542231; c=relaxed/simple;
	bh=i5BbhYRwDwFgqsHdXlkHyjBIxCxCm4W2Vuq3+WqFKuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsLWg+/ZdNffXi82rAeCTg0sYsKxOThkXsQlf6YIp5BjTZzwtVqGRxj2eVuyFJgsXiIXVbYXunof5+OKxQu/mKERTIZDeQ5q4iG3lF9tVlmGAA/9pmrWQtp241XIsn+8m/67d+8Sv/CtHkLC2l/5mNj+PAfxsYfmBtLm6v4xmQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t5//S+1U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA792C116C6;
	Tue, 27 Jan 2026 19:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542231;
	bh=i5BbhYRwDwFgqsHdXlkHyjBIxCxCm4W2Vuq3+WqFKuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5//S+1UtIYnXDs6Hs6NxKOKKNNWqptdM+gvy6dRVE+BudwOJTk0JU18Kgu8Is/i8
	 S4mij5QllCQ0bLDP9j4PXhyhphk6rZsJnwO66kQ2KnBjlo98h9WsU+/CtVyuyfrDcb
	 YaDIC2cQY75LBXYYQ6dkdIl4lRxAqFoZ+QW+6+mHOUU/uxwZSmtZvmd9yKdmJePJbh
	 7icJnfNaiIn2NFwCBRLDTEeXkx8acI0L8/XRNxVWlWsjzzJK+zvIf6d5ZkMJ2/yiYO
	 82FLdFAV0IXtjX6eBrCoibCK0vbQ+FMcvnhGLpbqCi9QS6JQProWOOMP0S1nskNgaR
	 ARQpR/ChNCNDw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 07/17] userfaultfd: introduce vm_uffd_ops
Date: Tue, 27 Jan 2026 21:29:26 +0200
Message-ID: <20260127192936.1250096-8-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69277-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 2239499F20
X-Rspamd-Action: no action

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Current userfaultfd implementation works only with memory managed by
core MM: anonymous, shmem and hugetlb.

First, there is no fundamental reason to limit userfaultfd support only
to the core memory types and userfaults can be handled similarly to
regular page faults provided a VMA owner implements appropriate
callbacks.

Second, historically various code paths were conditioned on
vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
these conditions can be expressed as operations implemented by a
particular memory type.

Introduce vm_uffd_ops extension to vm_operations_struct that will
delegate memory type specific operations to a VMA owner.

Operations for anonymous memory are handled internally in userfaultfd
using anon_uffd_ops that implicitly assigned to anonymous VMAs.

Start with a single operation, ->can_userfault() that will verify that a
VMA meets requirements for userfaultfd support at registration time.

Implement that method for anonymous, shmem and hugetlb and move relevant
parts of vma_can_userfault() into the new callbacks.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h            |  5 +++++
 include/linux/userfaultfd_k.h |  6 +++++
 mm/hugetlb.c                  | 21 ++++++++++++++++++
 mm/shmem.c                    | 23 ++++++++++++++++++++
 mm/userfaultfd.c              | 41 ++++++++++++++++++++++-------------
 5 files changed, 81 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..3c2caff646c3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -732,6 +732,8 @@ struct vm_fault {
 					 */
 };
 
+struct vm_uffd_ops;
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -817,6 +819,9 @@ struct vm_operations_struct {
 	struct page *(*find_normal_page)(struct vm_area_struct *vma,
 					 unsigned long addr);
 #endif /* CONFIG_FIND_NORMAL_PAGE */
+#ifdef CONFIG_USERFAULTFD
+	const struct vm_uffd_ops *uffd_ops;
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a49cf750e803..56e85ab166c7 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -80,6 +80,12 @@ struct userfaultfd_ctx {
 
 extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 
+/* VMA userfaultfd operations */
+struct vm_uffd_ops {
+	/* Checks if a VMA can support userfaultfd */
+	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
+};
+
 /* A combined operation mode + behavior flags. */
 typedef unsigned int __bitwise uffd_flags_t;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5..909131910c43 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4797,6 +4797,24 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static bool hugetlb_can_userfault(struct vm_area_struct *vma,
+				  vm_flags_t vm_flags)
+{
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then hugetlb is not supported.
+	 */
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
+		return false;
+	return true;
+}
+
+static const struct vm_uffd_ops hugetlb_uffd_ops = {
+	.can_userfault = hugetlb_can_userfault,
+};
+#endif
+
 /*
  * When a new function is introduced to vm_operations_struct and added
  * to hugetlb_vm_ops, please consider adding the function to shm_vm_ops.
@@ -4810,6 +4828,9 @@ const struct vm_operations_struct hugetlb_vm_ops = {
 	.close = hugetlb_vm_op_close,
 	.may_split = hugetlb_vm_op_split,
 	.pagesize = hugetlb_vm_op_pagesize,
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops = &hugetlb_uffd_ops,
+#endif
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d..9b82cda271c4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5290,6 +5290,23 @@ static const struct super_operations shmem_ops = {
 #endif
 };
 
+#ifdef CONFIG_USERFAULTFD
+static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+{
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then shmem is not supported.
+	 */
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
+		return false;
+	return true;
+}
+
+static const struct vm_uffd_ops shmem_uffd_ops = {
+	.can_userfault	= shmem_can_userfault,
+};
+#endif
+
 static const struct vm_operations_struct shmem_vm_ops = {
 	.fault		= shmem_fault,
 	.map_pages	= filemap_map_pages,
@@ -5297,6 +5314,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5306,6 +5326,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 786f0a245675..d035f5e17f07 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -34,6 +34,25 @@ struct mfill_state {
 	pmd_t *pmd;
 };
 
+static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+{
+	/* anonymous memory does not support MINOR mode */
+	if (vm_flags & VM_UFFD_MINOR)
+		return false;
+	return true;
+}
+
+static const struct vm_uffd_ops anon_uffd_ops = {
+	.can_userfault	= anon_can_userfault,
+};
+
+static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
+{
+	if (vma_is_anonymous(vma))
+		return &anon_uffd_ops;
+	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
+}
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -2019,13 +2038,15 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 		       bool wp_async)
 {
-	vm_flags &= __VM_UFFD_FLAGS;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	/* only VMAs that implement vm_uffd_ops are supported */
+	if (!ops)
 		return false;
 
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
+	vm_flags &= __VM_UFFD_FLAGS;
+
+	if (vma->vm_flags & VM_DROPPABLE)
 		return false;
 
 	/*
@@ -2035,18 +2056,8 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	if (wp_async && (vm_flags == VM_UFFD_WP))
 		return true;
 
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
-	    !vma_is_anonymous(vma))
-		return false;
-
 	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
+	return ops->can_userfault(vma, vm_flags);
 }
 
 static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
-- 
2.51.0


