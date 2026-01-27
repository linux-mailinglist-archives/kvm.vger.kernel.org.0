Return-Path: <kvm+bounces-69282-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QG0EEswTeWkcvAEAu9opvQ
	(envelope-from <kvm+bounces-69282-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:36:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DB65099F88
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5B6A308B98B
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D505636F413;
	Tue, 27 Jan 2026 19:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2UsiRPu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2DB2BCF7F;
	Tue, 27 Jan 2026 19:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769542263; cv=none; b=X04DsPDIwsdAoA7HU/u/h0O37C8c/x/vH48iGJe7ex+Y+uJQcS9PhAHKUjgi3TS7ZsCGRWgSmFHsZqAJYzemE5+edu200QrJ4vBTaxFarpZJwsotE8p8uqiXJCLK6IJnGcg6gQs3OJaHYX87uqP03F2tCRaejwEdR0e2deVXr3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769542263; c=relaxed/simple;
	bh=h+TcgWCVPD30aK45h+wpUIJypZftXhAg5ucXDIazF9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1B83Sg6OZEo5j58Fw/L9NN270Vzf/hmSuUmjTERsSUmidldnyQlWRlw1FotSUAOjy4TQN9jD8/DkZEldk0RTa6bvlr1+YstJzVf52n7uq1AZyY3gHE6jxDljHxZNE7esaveZERCOhPLXkO9La/skurdh7Y+AG3114L/1qcHXpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2UsiRPu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19B2C116C6;
	Tue, 27 Jan 2026 19:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542262;
	bh=h+TcgWCVPD30aK45h+wpUIJypZftXhAg5ucXDIazF9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2UsiRPuaj/8L0lU3PZimX+KdU+NnUJ4T6kgHnK7oKJ7dnF20S1Wu60dtz3r+KU1H
	 0T+7qAEjj3JbVgEGy3R0Hx3DRfjX2B6I9PzRs1e6vap8/WGmkswqz84raN0EuooQAV
	 5E4A1pVzNprdPWdgwAmWXAr69bCVgPHlBxziKewff7xctTxCeA2TMO1wQzD8XqEI6f
	 Ed4jSaIIhYNV6/OJpzSKzJ1lZMwUBOT5T1blV/qYiHyC03fgIpcZ1vmjVxxtXEnaon
	 0hSCYpfGeJVTvH9YpHOBZSgxib2aLHu9IQ7ZrqCo73Rgfq3eGnPiCbchrIFCt6eypg
	 1wteWBH/FqJkQ==
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
	linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH RFC 12/17] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Date: Tue, 27 Jan 2026 21:29:31 +0200
Message-ID: <20260127192936.1250096-13-rppt@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69282-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: DB65099F88
X-Rspamd-Action: no action

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When a VMA is registered with userfaulfd in minor mode, its ->fault()
method should check if a folio exists in the page cache and if yes
->fault() should call handle_userfault(VM_UFFD_MINOR).

Instead of calling handle_userfault() directly from a specific ->fault()
implementation introduce new fault reason VM_FAULT_UFFD_MINOR that will
notify the core page fault handler that it should call
handle_userfaultfd(VM_UFFD_MINOR) to complete a page fault.

Replace a call to handle_userfault(VM_UFFD_MINOR) in shmem and use the
new VM_FAULT_UFFD_MINOR there instead.

For configurations that don't enable CONFIG_USERFAULTFD,
VM_FAULT_UFFD_MINOR is set to 0.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm_types.h | 10 +++++++++-
 mm/memory.c              |  5 ++++-
 mm/shmem.c               |  2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 42af2292951d..b25ac322bfbf 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1555,6 +1555,8 @@ typedef __bitwise unsigned int vm_fault_t;
  *				fsync() to complete (for synchronous page faults
  *				in DAX)
  * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
+ * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
+ *				handle_userfault(VM_UFFD_MINOR) to complete
  * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
  *
  */
@@ -1572,6 +1574,11 @@ enum vm_fault_reason {
 	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
 	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
 	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
+#ifdef CONFIG_USERFAULTFD
+	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
+#else
+	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x000000,
+#endif
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
@@ -1596,7 +1603,8 @@ enum vm_fault_reason {
 	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
 	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
 	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
-	{ VM_FAULT_COMPLETED,           "COMPLETED" }
+	{ VM_FAULT_COMPLETED,           "COMPLETED" },	\
+	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..fcb3e0c3113e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5319,8 +5319,11 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 
 	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
-			    VM_FAULT_DONE_COW)))
+			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR))) {
+		if (ret & VM_FAULT_UFFD_MINOR)
+			return handle_userfault(vmf, VM_UFFD_MINOR);
 		return ret;
+	}
 
 	folio = page_folio(vmf->page);
 	if (unlikely(PageHWPoison(vmf->page))) {
diff --git a/mm/shmem.c b/mm/shmem.c
index 6f0485f76cb8..6aa905147c0c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2481,7 +2481,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	if (folio && vma && userfaultfd_minor(vma)) {
 		if (!xa_is_value(folio))
 			folio_put(folio);
-		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
+		*fault_type = VM_FAULT_UFFD_MINOR;
 		return 0;
 	}
 
-- 
2.51.0


