Return-Path: <kvm+bounces-69283-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FBFBtMTeWkcvAEAu9opvQ
	(envelope-from <kvm+bounces-69283-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:36:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ADFDE99F97
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E6DB5308F6C1
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD9736F429;
	Tue, 27 Jan 2026 19:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxCun7NY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D2D36E49A;
	Tue, 27 Jan 2026 19:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769542269; cv=none; b=LxTXy+0XqLmMMvTNzOMjgqECiWxHdZWQ+uiU4VRL/yOJrjR1lqSTp5SqULl/JNThPp9O5Ef+eM///Bhp2fZi8SmyLRAZOEZ2nkGtDcVvMiI29vUi2rX414nf5vWO+nVHZjt/iTK9TlU8n/ZKm4vWBPxU3zskRjse8+AMVo2YO/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769542269; c=relaxed/simple;
	bh=+RlyxhG8wPwYaWoZfV3wHqPdgp7OwXA/s55MoAiNhJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syT8WJwSamsFt+MgIVNNL2Ogu/2Z1/ZjMTV8qz0tx44qkqehcvzku7NuG2d54pQ37oaLVlESc94T0Ia3PVyVCxlJytNSWVajdpBQ2iFnK+omsv2GCwhSetvrORqx5RQg5Ek6q+X0zo5gA/18aYSCyxMuuHoFiwGYtgyCxS1gHok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxCun7NY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72991C116C6;
	Tue, 27 Jan 2026 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542269;
	bh=+RlyxhG8wPwYaWoZfV3wHqPdgp7OwXA/s55MoAiNhJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxCun7NYeayN6IkquZNPDK6UUnd1cAbljA2eL0BVX9w58wypp6/mCfqTEe8bHxP5a
	 HG4OouTbgYoMhHWfngWLGr5c2/z/XbLR5ETtxzfmFLGLns51cPfDLBrvvSUx18cp4e
	 ndfN0qt9j/sfkyHEqyjwx8YVt5nPQE3T389NiQ0VWC92VxIiaSBx8/e+63FoGVxIWZ
	 4Zcs+7dyUpegnBUsSn5MbvHtNdkIrtfxEYCtVqLblH1y7e4cMmySJc/k11QIs8g/Uh
	 WmM/cmFVYJd2vqUFcJ9yZ5uiwJ7k1/o/TOfpz73DmNLM4l61/9gwO/XPQZdiZ3f8kT
	 v+fkzz1g90MJQ==
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
Subject: [PATCH RFC 13/17] mm: introduce VM_FAULT_UFFD_MISSING fault reason
Date: Tue, 27 Jan 2026 21:29:32 +0200
Message-ID: <20260127192936.1250096-14-rppt@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69283-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: ADFDE99F97
X-Rspamd-Action: no action

From: Nikita Kalyazin <kalyazin@amazon.com>

When a VMA is registered with userfaulfd in missing mode, its ->fault()
method should check if a folio exists in the page cache and if no
->fault() should call handle_userfault(VM_UFFD_MISSING).

Instead of calling handle_userfault() directly from a specific ->fault()
implementation introduce new fault reason VM_FAULT_UFFD_MISSING that
will notify the core page fault handler that it should call
handle_userfaultfd(VM_UFFD_MISSING) to complete a page fault.

Replace a call to handle_userfault(VM_UFFD_MISSING) in shmem and use the
new VM_FAULT_UFFD_MISSING there instead.

For configurations that don't enable CONFIG_USERFAULTFD,
VM_FAULT_UFFD_MISSING is set to 0.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm_types.h | 7 ++++++-
 mm/memory.c              | 5 ++++-
 mm/shmem.c               | 2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b25ac322bfbf..a061c43e835b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1557,6 +1557,8 @@ typedef __bitwise unsigned int vm_fault_t;
  * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
  * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
  *				handle_userfault(VM_UFFD_MINOR) to complete
+ * @VM_FAULT_UFFD_MISSING:	->fault did not modify page tables and needs
+ *				handle_userfault(VM_UFFD_MISSING) to complete
  * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
  *
  */
@@ -1576,8 +1578,10 @@ enum vm_fault_reason {
 	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
 #ifdef CONFIG_USERFAULTFD
 	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
+	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x010000,
 #else
 	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x000000,
+	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x000000,
 #endif
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
@@ -1604,7 +1608,8 @@ enum vm_fault_reason {
 	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
 	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
 	{ VM_FAULT_COMPLETED,           "COMPLETED" },	\
-	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }
+	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }, \
+	{ VM_FAULT_UFFD_MISSING,	"UFFD_MISSING" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/mm/memory.c b/mm/memory.c
index fcb3e0c3113e..f72e69a43b68 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5319,9 +5319,12 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 
 	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
-			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR))) {
+			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR |
+			    VM_FAULT_UFFD_MISSING))) {
 		if (ret & VM_FAULT_UFFD_MINOR)
 			return handle_userfault(vmf, VM_UFFD_MINOR);
+		if (ret & VM_FAULT_UFFD_MISSING)
+			return handle_userfault(vmf, VM_UFFD_MISSING);
 		return ret;
 	}
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 6aa905147c0c..1bc544cab2a8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2530,7 +2530,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	 */
 
 	if (vma && userfaultfd_missing(vma)) {
-		*fault_type = handle_userfault(vmf, VM_UFFD_MISSING);
+		*fault_type = VM_FAULT_UFFD_MISSING;
 		return 0;
 	}
 
-- 
2.51.0


