Return-Path: <kvm+bounces-69279-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMflHYoTeWkcvAEAu9opvQ
	(envelope-from <kvm+bounces-69279-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:35:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 393E199F3E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:35:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 002CD304C2F4
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F8D236EA95;
	Tue, 27 Jan 2026 19:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXykKUde"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ED8299922;
	Tue, 27 Jan 2026 19:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769542244; cv=none; b=i0s1oXcrO3VAwxq3Jn3abwlakS/bxOlLs4P78XwrdvSKb5zUkvJGDbHWWH5s7mF06zkT9Hm7ZNUHpxVmzfUDOsdmlXgk+X5n/a+DOCDfD28ynxwx0HUv7HJ4WQHRdrBiEnyXYXHn9uLw9Mf9oTmHNUVuMHjj8nFMSQ5pcPlV6aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769542244; c=relaxed/simple;
	bh=gOZGYyaN4+ceUz7X3a7wO7Gkwgg3l4aHlNGikBmh8yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFBU4ZtVMbjrqO20Gsx+8ymGuzfYlk74c02RG/mLMJVdrieQXXVXbRKbVeSs7sQ1QhAIHuoeTiZgzQvpiSGd8/JfoVbf2WGuLvzZeun4mR0syKqUmX5oneDpnok1Vdh3nSvOkCqxVGJSCRbk4iajQEsq+yrX8t5p9qVdSOdi4Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXykKUde; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349FFC19425;
	Tue, 27 Jan 2026 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542243;
	bh=gOZGYyaN4+ceUz7X3a7wO7Gkwgg3l4aHlNGikBmh8yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXykKUdeTd2HBkgc2hP7eZb73bNLFL1p0lWi1DNQnLh1pAQdYs0qjNCWjTFQ2H8cL
	 uO+5GwnBXEAb1JdsiscE81/F86rJ7Pqwk2ZTSAq5LiCkZslorgwa4m/PTS+/V1f4Uv
	 F9WDlZuJMsfFFhXd3YkOKnwd36NqNyu1sSKWDujHgEB9BrSVcQk01TWF0KbFP2IiDZ
	 pMau7AKFfeexKFeL1N4B0sigcjJgBDW8IsZ5Qoxmgeg34o3B3zU+ucLgnnhPLz70Po
	 opITgJ5F1yXFHFlDeTepWkBXBq/3bO8HJ0yRKsRKlyu3ozcqqcqoCoDFe5BFq8pQRc
	 7I9O2ABBq9LFw==
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
Subject: [PATCH RFC 09/17] userfaultfd: introduce vm_uffd_ops->alloc_folio()
Date: Tue, 27 Jan 2026 21:29:28 +0200
Message-ID: <20260127192936.1250096-10-rppt@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69279-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 393E199F3E
X-Rspamd-Action: no action

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

and use it to refactor mfill_atomic_pte_zeroed_folio() and
mfill_atomic_pte_copy().

mfill_atomic_pte_zeroed_folio() and mfill_atomic_pte_copy() perform
almost identical actions:
* allocate a folio
* update folio contents (either copy from userspace of fill with zeros)
* update page tables with the new folio

Split a __mfill_atomic_pte() helper that handles both cases and uses
newly introduced vm_uffd_ops->alloc_folio() to allocate the folio.

Pass the ops structure from the callers to __mfill_atomic_pte() to later
allow using anon_uffd_ops for MAP_PRIVATE mappings of file-backed VMAs.

Note, that the new ops method is called alloc_folio() rather than
folio_alloc() to avoid clash with alloc_tag macro folio_alloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h |  6 +++
 mm/userfaultfd.c              | 92 ++++++++++++++++++-----------------
 2 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 66dfc3c164e6..4d8b879eed91 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -91,6 +91,12 @@ struct vm_uffd_ops {
 	 * The returned folio is locked and with reference held.
 	 */
 	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
+	/*
+	 * Called during resolution of UFFDIO_COPY request.
+	 * Should return allocate a and return folio or NULL if allocation fails.
+	 */
+	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
+				     unsigned long addr);
 };
 
 /* A combined operation mode + behavior flags. */
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index f0e6336015f1..b3c12630769c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -42,8 +42,26 @@ static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 	return true;
 }
 
+static struct folio *anon_alloc_folio(struct vm_area_struct *vma,
+				      unsigned long addr)
+{
+	struct folio *folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
+					      addr);
+
+	if (!folio)
+		return NULL;
+
+	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL)) {
+		folio_put(folio);
+		return NULL;
+	}
+
+	return folio;
+}
+
 static const struct vm_uffd_ops anon_uffd_ops = {
 	.can_userfault	= anon_can_userfault,
+	.alloc_folio	= anon_alloc_folio,
 };
 
 static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
@@ -455,7 +473,8 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
 	return 0;
 }
 
-static int mfill_atomic_pte_copy(struct mfill_state *state)
+static int __mfill_atomic_pte(struct mfill_state *state,
+			      const struct vm_uffd_ops *ops)
 {
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
@@ -463,20 +482,22 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	struct folio *folio;
 	int ret;
 
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
+	folio = ops->alloc_folio(state->vma, state->dst_addr);
 	if (!folio)
 		return -ENOMEM;
 
-	ret = -ENOMEM;
-	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
-		goto out_release;
-
-	ret = mfill_copy_folio_locked(folio, src_addr);
-	if (unlikely(ret)) {
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY)) {
+		ret = mfill_copy_folio_locked(folio, src_addr);
 		/* fallback to copy_from_user outside mmap_lock */
-		ret = mfill_copy_folio_retry(state, folio);
-		if (ret)
-			goto out_release;
+		if (unlikely(ret)) {
+			ret = mfill_copy_folio_retry(state, folio);
+			if (ret)
+				goto err_folio_put;
+		}
+	} else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
+		clear_user_highpage(&folio->page, state->dst_addr);
+	} else {
+		VM_WARN_ONCE(1, "unknown UFFDIO operation");
 	}
 
 	/*
@@ -489,47 +510,30 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
 				       &folio->page, true, flags);
 	if (ret)
-		goto out_release;
-out:
-	return ret;
-out_release:
+		goto err_folio_put;
+
+	return 0;
+
+err_folio_put:
+	folio_put(folio);
 	/* Don't return -ENOENT so that our caller won't retry */
 	if (ret == -ENOENT)
 		ret = -EFAULT;
-	folio_put(folio);
-	goto out;
+	return ret;
 }
 
-static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
-					 struct vm_area_struct *dst_vma,
-					 unsigned long dst_addr)
+static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	struct folio *folio;
-	int ret = -ENOMEM;
-
-	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
-	if (!folio)
-		return ret;
-
-	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
-		goto out_put;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 
-	/*
-	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * zeroing out the folio become visible before mapping the page
-	 * using set_pte_at(). See do_anonymous_page().
-	 */
-	__folio_mark_uptodate(folio);
+	return __mfill_atomic_pte(state, ops);
+}
 
-	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
-				       &folio->page, true, 0);
-	if (ret)
-		goto out_put;
+static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
+{
+	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 
-	return 0;
-out_put:
-	folio_put(folio);
-	return ret;
+	return __mfill_atomic_pte(state, ops);
 }
 
 static int mfill_atomic_pte_zeropage(struct mfill_state *state)
@@ -542,7 +546,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 	int ret;
 
 	if (mm_forbids_zeropage(dst_vma->vm_mm))
-		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
+		return mfill_atomic_pte_zeroed_folio(state);
 
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
-- 
2.51.0


