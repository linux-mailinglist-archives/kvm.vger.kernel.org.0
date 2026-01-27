Return-Path: <kvm+bounces-69285-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QIXXAysUeWkcvAEAu9opvQ
	(envelope-from <kvm+bounces-69285-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:38:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 923E69A015
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:38:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A3555308E805
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F42371067;
	Tue, 27 Jan 2026 19:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZW1wjmlE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204FD299922;
	Tue, 27 Jan 2026 19:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769542282; cv=none; b=U0TGe2UXb+XkcVL3GB3wN0Fh+cGKfXcsGYsmUUxl65ksqVMR6zaxnXGcSwZ5fp+NXTCT4ZUtyQmD5FpRfSjNvklAWaPGoU3ctTjgVq8+f9w0DT1XvMFNhU2yuIGYno4rOLfUirPZg5ryZg9aPWDIpiYfopBVWF74W1Zlt3/pGxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769542282; c=relaxed/simple;
	bh=96EEwJcWySxO2R/2KP/gCzA6SPsvcN9sMFGfwSmvv8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKjA+sougm+gJbsZCK6etP+iGD3Ngewf0FtwrVxw1r0anOrcjVuLi07GHZ7rSf+APNviGmtSb+jLa4H1DtQSroUexk/cX1xNAqcukuPc01rlVAHH0BxGhI3umD9VuwtQnlOINASiVh7jOXEgtYHhW8nyiAM2q7bhIS+XX5+MGH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZW1wjmlE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF23CC116C6;
	Tue, 27 Jan 2026 19:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542281;
	bh=96EEwJcWySxO2R/2KP/gCzA6SPsvcN9sMFGfwSmvv8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZW1wjmlEaWOSdy5FnqJJ6HOmgWV7pu0s4MRk84xlIeo88QjzOqjdIYlrG7ljWeU0v
	 MeVT/1r5gvKQ8hwIT2RBtV0wKCMd8ov24qkrjcRy4Vfh/Y21OxTvvwPWedf28sTtpo
	 suFN5ZKjXWM1NKIUy+6Dpr+0RTJ2rjrKbQS/lNK/SjFllGnjxzucAuckujiOyB+4U9
	 ccJBVk/3++oHxXEHSESsxUT5xJTAVOyEPse6JLGhtLLEhZZ/XVVi8U9wBHMb6IXpTH
	 /5+0b26eHzpI8qMV5AnhQOxvJp1yjrHIWrURA/5Ndiprz3rlpr6hJnVNc2kD2LXCFh
	 tOhezlpGaLTpQ==
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
Subject: [PATCH RFC 15/17] KVM: guest_memfd: implement userfaultfd missing mode
Date: Tue, 27 Jan 2026 21:29:34 +0200
Message-ID: <20260127192936.1250096-16-rppt@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69285-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 923E69A015
X-Rspamd-Action: no action

From: Nikita Kalyazin <kalyazin@amazon.com>

userfaultfd missing mode allows populating guest memory with the content
supplied by userspace on demand.

Extend guest_memfd implementation of vm_uffd_ops to support MISSING
mode.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 virt/kvm/guest_memfd.c | 60 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 087e7632bf70..14cca057fc0e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -431,6 +431,14 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 			ret = VM_FAULT_UFFD_MINOR;
 			goto out_folio;
 		}
+
+		/*
+		 * Check if userfaultfd is registered in missing mode. If so,
+		 * check if a folio exists in the page cache. If not, return
+		 * VM_FAULT_UFFD_MISSING to trigger the userfaultfd handler.
+		 */
+		if (userfaultfd_missing(vmf->vma) && IS_ERR_OR_NULL(folio))
+			return VM_FAULT_UFFD_MISSING;
 	}
 
 	/* folio not in the pagecache, try to allocate */
@@ -507,9 +515,59 @@ static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_fla
 	return true;
 }
 
+static struct folio *kvm_gmem_folio_alloc(struct vm_area_struct *vma,
+					  unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	pgoff_t pgoff = linear_page_index(vma, addr);
+	struct mempolicy *mpol;
+	struct folio *folio;
+	gfp_t gfp;
+
+	if (unlikely(pgoff >= (i_size_read(inode) >> PAGE_SHIFT)))
+		return NULL;
+
+	gfp = mapping_gfp_mask(inode->i_mapping);
+	mpol = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
+	mpol = mpol ?: get_task_policy(current);
+	folio = folio_alloc_mpol(gfp, 0, mpol, pgoff, numa_node_id());
+	mpol_cond_put(mpol);
+
+	return folio;
+}
+
+static int kvm_gmem_filemap_add(struct folio *folio,
+				struct vm_area_struct *vma,
+				unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t pgoff = linear_page_index(vma, addr);
+	int err;
+
+	__folio_set_locked(folio);
+	err = filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);
+	if (err) {
+		folio_unlock(folio);
+		return err;
+	}
+
+	return 0;
+}
+
+static void kvm_gmem_filemap_remove(struct folio *folio,
+				    struct vm_area_struct *vma)
+{
+	filemap_remove_folio(folio);
+	folio_unlock(folio);
+}
+
 static const struct vm_uffd_ops kvm_gmem_uffd_ops = {
-	.can_userfault = kvm_gmem_can_userfault,
+	.can_userfault     = kvm_gmem_can_userfault,
 	.get_folio_noalloc = kvm_gmem_get_folio_noalloc,
+	.alloc_folio       = kvm_gmem_folio_alloc,
+	.filemap_add       = kvm_gmem_filemap_add,
+	.filemap_remove    = kvm_gmem_filemap_remove,
 };
 #endif /* CONFIG_USERFAULTFD */
 
-- 
2.51.0


