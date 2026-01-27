Return-Path: <kvm+bounces-69278-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iB+GE5ATeWkcvAEAu9opvQ
	(envelope-from <kvm+bounces-69278-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:35:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB2599F56
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5FF2B306CF4A
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6A236EA85;
	Tue, 27 Jan 2026 19:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIFX02kq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D7136CDFD;
	Tue, 27 Jan 2026 19:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769542237; cv=none; b=Y4G6clJxAgZkUUx+ANmOJreklJ9s7dIegsBKmKr8yZnhLNuqmGEBh4WoQklimPAuvMPXgsrcV4imYyMWY+ixePW9O768D3y6bZcG6Wdg8xCNp5RH8Kh0WqyZNRYrrWsum+IcFGDSkrGzSDDkARWkQbZLSDCRUjl25OdZzVaT/1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769542237; c=relaxed/simple;
	bh=dEjTs4g7Ldzs6VFuT/arDcgalMO2GCfU8tcBpfF3p8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEbqZ3Xyg07cLcBUh8o0L7gJ+NeHZo0KWNOWDxG6rxC2nsf4XzEYiIu4xy55yeWE1PRfjbQ4xOMgx1sS6N+nxpaxQ9Oojv/CfsUk+kcSjY3brPrF5lfQSBbrBycMpZmMA1YU/+nTLYK8EOG7j8BrwGv6LskQBvM/yyXRflgot/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIFX02kq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9613C19422;
	Tue, 27 Jan 2026 19:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542237;
	bh=dEjTs4g7Ldzs6VFuT/arDcgalMO2GCfU8tcBpfF3p8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIFX02kq/eb3tdlUyK3+ux/FsIlLOYCqnviY6Ie7P/JoMu0xpvH0YAzid+JPgh/wf
	 ZeqTvHI90vv1ymfJ5mKlTSi7ENxzGNs0eiDNpe7SKCKi9YBeblG/mupcmyOBTb5lfi
	 Du+zzNcONbAQnPXllF3puU5zkWcn3oJA5C6i24cg0xb6cyKMIBRz1sxJDbetb+GomZ
	 ebsMHkfKrgYOtfle3aDrqX/AIg7yiUZwWzJrbevM5HsVJ7crsBY9sWOs1mGJLRC+4t
	 QtQE0BT8W2UM4lZNTM8NJDoKhmUDX5AtUDIRlY1FGik8uzBb19PN6zjwHOtAQvIeoq
	 e5OQTmT8pAcFQ==
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
Subject: [PATCH RFC 08/17] userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
Date: Tue, 27 Jan 2026 21:29:27 +0200
Message-ID: <20260127192936.1250096-9-rppt@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69278-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 0DB2599F56
X-Rspamd-Action: no action

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
it needs to get a folio that already exists in the pagecache backing
that VMA.

Instead of using shmem_get_folio() for that, add a get_folio_noalloc()
method to 'struct vm_uffd_ops' that will return a folio if it exists in
the VMA's pagecache at given pgoff.

Implement get_folio_noalloc() method for shmem and slightly refactor
userfaultfd's mfill_get_vma() and mfill_atomic_pte_continue() to support
this new API.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h |  7 +++++++
 mm/shmem.c                    | 15 ++++++++++++++-
 mm/userfaultfd.c              | 32 ++++++++++++++++----------------
 3 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 56e85ab166c7..66dfc3c164e6 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -84,6 +84,13 @@ extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 struct vm_uffd_ops {
 	/* Checks if a VMA can support userfaultfd */
 	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
+	/*
+	 * Called to resolve UFFDIO_CONTINUE request.
+	 * Should return the folio found at pgoff in the VMA's pagecache if it
+	 * exists or ERR_PTR otherwise.
+	 * The returned folio is locked and with reference held.
+	 */
+	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
 };
 
 /* A combined operation mode + behavior flags. */
diff --git a/mm/shmem.c b/mm/shmem.c
index 9b82cda271c4..87cd8d2fdb97 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5291,6 +5291,18 @@ static const struct super_operations shmem_ops = {
 };
 
 #ifdef CONFIG_USERFAULTFD
+static struct folio *shmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
+{
+	struct folio *folio;
+	int err;
+
+	err = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	if (err)
+		return ERR_PTR(err);
+
+	return folio;
+}
+
 static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 {
 	/*
@@ -5303,7 +5315,8 @@ static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 }
 
 static const struct vm_uffd_ops shmem_uffd_ops = {
-	.can_userfault	= shmem_can_userfault,
+	.can_userfault		= shmem_can_userfault,
+	.get_folio_noalloc	= shmem_get_folio_noalloc,
 };
 #endif
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d035f5e17f07..f0e6336015f1 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -188,6 +188,7 @@ static int mfill_get_vma(struct mfill_state *state)
 	struct userfaultfd_ctx *ctx = state->ctx;
 	uffd_flags_t flags = state->flags;
 	struct vm_area_struct *dst_vma;
+	const struct vm_uffd_ops *ops;
 	int err;
 
 	/*
@@ -228,10 +229,12 @@ static int mfill_get_vma(struct mfill_state *state)
 	if (is_vm_hugetlb_page(dst_vma))
 		goto out;
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
+	ops = vma_uffd_ops(dst_vma);
+	if (!ops)
 		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
+	    !ops->get_folio_noalloc)
 		goto out_unlock;
 
 out:
@@ -568,6 +571,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 static int mfill_atomic_pte_continue(struct mfill_state *state)
 {
 	struct vm_area_struct *dst_vma = state->vma;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(dst_vma);
 	unsigned long dst_addr = state->dst_addr;
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct inode *inode = file_inode(dst_vma->vm_file);
@@ -577,16 +581,13 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	folio = ops->get_folio_noalloc(inode, pgoff);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
-	if (ret)
-		goto out;
-	if (!folio) {
-		ret = -EFAULT;
-		goto out;
-	}
+	if (IS_ERR_OR_NULL(folio))
+		return -EFAULT;
 
 	page = folio_file_page(folio, pgoff);
 	if (PageHWPoison(page)) {
@@ -600,13 +601,12 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
 		goto out_release;
 
 	folio_unlock(folio);
-	ret = 0;
-out:
-	return ret;
+	return 0;
+
 out_release:
 	folio_unlock(folio);
 	folio_put(folio);
-	goto out;
+	return ret;
 }
 
 /* Handles UFFDIO_POISON for all non-hugetlb VMAs. */
-- 
2.51.0


