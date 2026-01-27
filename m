Return-Path: <kvm+bounces-69275-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGDtK20TeWkcvAEAu9opvQ
	(envelope-from <kvm+bounces-69275-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:35:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 269B199F0F
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:35:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9C66B301BE36
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009F036E477;
	Tue, 27 Jan 2026 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFjN+VuE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA3136E469;
	Tue, 27 Jan 2026 19:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769542219; cv=none; b=hsqo6/u1prmYWSchy5D2AwV06bMP07RYrzOOc3OSy+a5y5w/FkzVl0Fell413fFEVp8T8WsltUglQwxhhNk26ncUl994OlEjhecpjFgDLbGKCsPBtHvpJBVqesSSv3fTMUJNTX32jYHZVov9zE38vAz/BpVwQpfVbm/Gim1SSn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769542219; c=relaxed/simple;
	bh=0i1d2fpNNGr7J2FXKMkhDUOQSLx8UrCEb1MMN67S4zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/1gPyhNg6nf9y5qOTbLbjIAF72WhUqcnO26UFgjxgF5uQzBBexRYFcvjMUtBSoWtupajV2KmqlYp++iXfjcrCrQd9AfxFVguZrq7CgwZ8ry+YP+5QtjW8VaU6mDZC7343o3IwR8TgyIHT1Ml9lUFBOdCf02M1l6AKxkwD4nweo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFjN+VuE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1C0C116C6;
	Tue, 27 Jan 2026 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542218;
	bh=0i1d2fpNNGr7J2FXKMkhDUOQSLx8UrCEb1MMN67S4zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFjN+VuEwQhJBIsfMbC+PmRxi9KIPVJN4uRtNpCoxNN9r9XQMLQHf0SUC/QcdqCdv
	 yTbesD04KbeYLsqu9jsK5VCgiKMXWXlhDdWUti9o3laDuHpqKq0cyQpRIpTuVRDK3G
	 9s8YlgqtFbLBtQtxXOEyaDTUXUdJl17RWcVocISkGcSkSmsU5NvoiKCQikZgy87kFF
	 O8R4uqwxHCNJdejR+L/GTxAWcoaC7L8L3E8vakXLO1fq4oq3POjF84JIKWuCS7CIvg
	 pmavXqI0eF6TLmjO0g1n2PwhdMCDUBPPfgqRUjUwbI3BRxSmDJW4/QV6Mt7Z+eEND/
	 4/xB2oNKKGPkg==
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
Subject: [PATCH RFC 05/17] userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
Date: Tue, 27 Jan 2026 21:29:24 +0200
Message-ID: <20260127192936.1250096-6-rppt@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69275-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 269B199F0F
X-Rspamd-Action: no action

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Implementation of UFFDIO_COPY for anonymous memory might fail to copy
data data from userspace buffer when the destination VMA is locked
(either with mm_lock or with per-VMA lock).

In that case, mfill_atomic() releases the locks, retries copying the
data with locks dropped and then re-locks the destination VMA and
re-establishes PMD.

Since this retry-reget dance is only relevant for UFFDIO_COPY and it
never happens for other UFFDIO_ operations, make it a part of
mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for
anonymous memory.

shmem implementation will be updated later and the loop in
mfill_atomic() will be adjusted afterwards.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 70 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 45d8f04aaf4f..01a2b898fa40 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -404,35 +404,57 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
+static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+{
+	unsigned long src_addr = state->src_addr;
+	void *kaddr;
+	int err;
+
+	/* retry copying with mm_lock dropped */
+	mfill_put_vma(state);
+
+	kaddr = kmap_local_folio(folio, 0);
+	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
+	kunmap_local(kaddr);
+	if (unlikely(err))
+		return -EFAULT;
+
+	flush_dcache_folio(folio);
+
+	/* reget VMA and PMD, they could change underneath us */
+	err = mfill_get_vma(state);
+	if (err)
+		return err;
+
+	err = mfill_get_pmd(state);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	struct vm_area_struct *dst_vma = state->vma;
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
 	uffd_flags_t flags = state->flags;
-	pmd_t *dst_pmd = state->pmd;
 	struct folio *folio;
 	int ret;
 
-	if (!state->folio) {
-		ret = -ENOMEM;
-		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
-					dst_addr);
-		if (!folio)
-			goto out;
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
+	if (!folio)
+		return -ENOMEM;
 
-		ret = mfill_copy_folio_locked(folio, src_addr);
+	ret = -ENOMEM;
+	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
+		goto out_release;
 
+	ret = mfill_copy_folio_locked(folio, src_addr);
+	if (unlikely(ret)) {
 		/* fallback to copy_from_user outside mmap_lock */
-		if (unlikely(ret)) {
-			ret = -ENOENT;
-			state->folio = folio;
-			/* don't free the page */
-			goto out;
-		}
-	} else {
-		folio = state->folio;
-		state->folio = NULL;
+		ret = mfill_copy_folio_retry(state, folio);
+		if (ret)
+			goto out_release;
 	}
 
 	/*
@@ -442,17 +464,16 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	 */
 	__folio_mark_uptodate(folio);
 
-	ret = -ENOMEM;
-	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
-		goto out_release;
-
-	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
+	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
 				       &folio->page, true, flags);
 	if (ret)
 		goto out_release;
 out:
 	return ret;
 out_release:
+	/* Don't return -ENOENT so that our caller won't retry */
+	if (ret == -ENOENT)
+		ret = -EFAULT;
 	folio_put(folio);
 	goto out;
 }
@@ -907,7 +928,8 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 			break;
 	}
 
-	mfill_put_vma(&state);
+	if (state.vma)
+		mfill_put_vma(&state);
 out:
 	if (state.folio)
 		folio_put(state.folio);
-- 
2.51.0


