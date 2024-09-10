Return-Path: <kvm+bounces-26314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AC16A973D5B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1185FB26175
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2140E1AAE00;
	Tue, 10 Sep 2024 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="uhQ4LE41"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E0B1A7AE3;
	Tue, 10 Sep 2024 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985922; cv=none; b=UmgobuhFXI7ez/IHSbd/JVrzh6++tKQ8uvkCbuZZKFtdhp6ug2AGQ5Kn+TU+kC763rGkEM7B3tp8lLjlWdvhl+LgEC7SwhZvFOQ73lBKRUAZDu03quRhF2lmI8LPPBK2hDADYE4ZQqZk8Xm8RCKmYaq0jrXwHjVoTGQ1iLJ3I3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985922; c=relaxed/simple;
	bh=JFZvXTOsIoUxDPHdW5ElkrBePGcuWanipE892MdDx4w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e8KBEL/nZL8R5vbUvwIScExXQYyRQiLmkG27o6/RzlFR5+UOTGh0IkP2lsvOQsDIS+TBWpEu7QEUcnt7XqUb1zRzE4uLGEDL7fciQ0siKyElAair6+zClE+4+4bgopq4EiGK/wnHMdegMaaPJW8O9k9B8x9Mv/XwTdBHtGtZ4aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=uhQ4LE41; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985921; x=1757521921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nC+ZthG3ZVV5r6y+2ESHYBsZJWfc4T6QNh+zi4jDtGU=;
  b=uhQ4LE41B338EBg4lQTQUABmCr1kFHP4Y2mhZbMKSFnAIIC+VyqhtP72
   GwbJcy4GKnLk4mN/DbY+pcSYcSIaJqbPLgEcJ4Smr09psf9hYQm454YXz
   N13/GrZXIlVrv6JApPN7WShQlQXkERuDFTz+yDJXNGf+dVnSEXX0OgyFa
   M=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="452556269"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:53 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.44.209:34555]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.48.28:2525] with esmtp (Farcaster)
 id 87701a07-5d1b-4a8e-b143-b5fc4e93bed5; Tue, 10 Sep 2024 16:31:52 +0000 (UTC)
X-Farcaster-Flow-ID: 87701a07-5d1b-4a8e-b143-b5fc4e93bed5
Received: from EX19D008UEC004.ant.amazon.com (10.252.135.170) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:42 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEC004.ant.amazon.com (10.252.135.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:42 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:31:38 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <quic_eberman@quicinc.com>,
	<dwmw@amazon.com>, <david@redhat.com>, <tabba@google.com>, <rppt@kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <graf@amazon.com>,
	<jgowans@amazon.com>, <derekmn@amazon.com>, <kalyazin@amazon.com>,
	<xmarcalx@amazon.com>
Subject: [RFC PATCH v2 10/10] kvm: x86: support walking guest page tables in gmem
Date: Tue, 10 Sep 2024 17:30:36 +0100
Message-ID: <20240910163038.1298452-11-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910163038.1298452-1-roypat@amazon.co.uk>
References: <20240910163038.1298452-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Update the logic in paging_tmpl.h to work with guest_private memory. If
KVM cannot access gmem and the guest's page tables are in gfns marked as
private, then error out.

Let the guest page table walker access gmem by making it use
gfn_to_pfn_caches, which are already gmem aware, and also handle
on-demand mapping of gmem if KVM_GMEM_NO_DIRECT_MAP is set.  We re-use
the gfn_to_pfn_cache here to avoid implementing yet another remapping
solution to support the cmpxchg used to set the "accessed" bit on guest
PTEs. The only case that now needs some special handling is page tables
in read-only memslots, as gfn_to_pfn_caches cannot be used for readonly
memory. In this case, use kvm_vcpu_read_guest (which is also gmem
aware), as there is no need to cache the gfn->pfn translation in this
case (there is no need to do a cmpxchg on the PTE as the walker does not
set the accessed bit for read-only ptes).

gfn_to_pfn_caches are hooked up to the MMU notifiers, meaning if
something about guest memory changes between the page table talk and
setting the dirty bits (for example a concurrent fallocate on gmem), the
gfn_to_pfn_caches will have been invalidated and the entire page table
walk is retried.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 95 ++++++++++++++++++++++++++++------
 1 file changed, 78 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 69941cebb3a87..d96fa423bed05 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -84,7 +84,7 @@ struct guest_walker {
 	pt_element_t ptes[PT_MAX_FULL_LEVELS];
 	pt_element_t prefetch_ptes[PTE_PREFETCH_NUM];
 	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
-	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
+	struct gfn_to_pfn_cache ptep_caches[PT_MAX_FULL_LEVELS];
 	bool pte_writable[PT_MAX_FULL_LEVELS];
 	unsigned int pt_access[PT_MAX_FULL_LEVELS];
 	unsigned int pte_access;
@@ -201,7 +201,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 {
 	unsigned level, index;
 	pt_element_t pte, orig_pte;
-	pt_element_t __user *ptep_user;
+	struct gfn_to_pfn_cache *pte_cache;
 	gfn_t table_gfn;
 	int ret;
 
@@ -210,10 +210,12 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 		return 0;
 
 	for (level = walker->max_level; level >= walker->level; --level) {
+		unsigned long flags;
+
 		pte = orig_pte = walker->ptes[level - 1];
 		table_gfn = walker->table_gfn[level - 1];
-		ptep_user = walker->ptep_user[level - 1];
-		index = offset_in_page(ptep_user) / sizeof(pt_element_t);
+		pte_cache = &walker->ptep_caches[level - 1];
+		index = offset_in_page(pte_cache->khva) / sizeof(pt_element_t);
 		if (!(pte & PT_GUEST_ACCESSED_MASK)) {
 			trace_kvm_mmu_set_accessed_bit(table_gfn, index, sizeof(pte));
 			pte |= PT_GUEST_ACCESSED_MASK;
@@ -246,11 +248,26 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 		if (unlikely(!walker->pte_writable[level - 1]))
 			continue;
 
-		ret = __try_cmpxchg_user(ptep_user, &orig_pte, pte, fault);
+		read_lock_irqsave(&pte_cache->lock, flags);
+		if (!kvm_gpc_check(pte_cache, sizeof(pte))) {
+			read_unlock_irqrestore(&pte_cache->lock, flags);
+			/*
+			 * If the gpc got invalidated, then the page table
+			 * it contained probably changed, so we probably need
+			 * to redo the entire walk.
+			 */
+			return 1;
+		}
+		ret = __try_cmpxchg((pt_element_t *)pte_cache->khva, &orig_pte, pte, sizeof(pte));
+
+		if (!ret)
+			kvm_gpc_mark_dirty_in_slot(pte_cache);
+
+		read_unlock_irqrestore(&pte_cache->lock, flags);
+
 		if (ret)
 			return ret;
 
-		kvm_vcpu_mark_page_dirty(vcpu, table_gfn);
 		walker->ptes[level - 1] = pte;
 	}
 	return 0;
@@ -296,6 +313,13 @@ static inline bool FNAME(is_last_gpte)(struct kvm_mmu *mmu,
 
 	return gpte & PT_PAGE_SIZE_MASK;
 }
+
+static void FNAME(walk_deactivate_gpcs)(struct guest_walker *walker) {
+	for (unsigned int level = 0; level < PT_MAX_FULL_LEVELS; ++level)
+		if (walker->ptep_caches[level].active)
+			kvm_gpc_deactivate(&walker->ptep_caches[level]);
+}
+
 /*
  * Fetch a guest pte for a guest virtual address, or for an L2's GPA.
  */
@@ -305,7 +329,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 {
 	int ret;
 	pt_element_t pte;
-	pt_element_t __user *ptep_user;
 	gfn_t table_gfn;
 	u64 pt_access, pte_access;
 	unsigned index, accessed_dirty, pte_pkey;
@@ -320,8 +343,17 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	u16 errcode = 0;
 	gpa_t real_gpa;
 	gfn_t gfn;
+	struct gfn_to_pfn_cache *pte_cache;
 
 	trace_kvm_mmu_pagetable_walk(addr, access);
+
+	for (unsigned int level = 0; level < PT_MAX_FULL_LEVELS; ++level) {
+		pte_cache = &walker->ptep_caches[level];
+
+		memset(pte_cache, 0, sizeof(*pte_cache));
+		kvm_gpc_init(pte_cache, vcpu->kvm);
+	}
+
 retry_walk:
 	walker->level = mmu->cpu_role.base.level;
 	pte           = kvm_mmu_get_guest_pgd(vcpu, mmu);
@@ -362,11 +394,13 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 	do {
 		struct kvm_memory_slot *slot;
-		unsigned long host_addr;
+		unsigned long flags;
 
 		pt_access = pte_access;
 		--walker->level;
 
+		pte_cache = &walker->ptep_caches[walker->level - 1];
+
 		index = PT_INDEX(addr, walker->level);
 		table_gfn = gpte_to_gfn(pte);
 		offset    = index * sizeof(pt_element_t);
@@ -396,15 +430,36 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		if (!kvm_is_visible_memslot(slot))
 			goto error;
 
-		host_addr = gfn_to_hva_memslot_prot(slot, gpa_to_gfn(real_gpa),
-					    &walker->pte_writable[walker->level - 1]);
-		if (unlikely(kvm_is_error_hva(host_addr)))
-			goto error;
+		/*
+		 * gfn_to_pfn_cache expects the memory to be writable. However,
+		 * if the memory is not writable, we do not need caching in the
+		 * first place, as we only need it to later potentially write
+		 * the access bit (which we cannot do anyway if the memory is
+		 * readonly).
+		 */
+		if (slot->flags & KVM_MEM_READONLY) {
+			if (kvm_vcpu_read_guest(vcpu, real_gpa + offset, &pte, sizeof(pte)))
+				goto error;
+		} else {
+			if (kvm_gpc_activate(pte_cache, real_gpa + offset,
+					     sizeof(pte)))
+				goto error;
 
-		ptep_user = (pt_element_t __user *)((void *)host_addr + offset);
-		if (unlikely(__get_user(pte, ptep_user)))
-			goto error;
-		walker->ptep_user[walker->level - 1] = ptep_user;
+			read_lock_irqsave(&pte_cache->lock, flags);
+			while (!kvm_gpc_check(pte_cache, sizeof(pte))) {
+				read_unlock_irqrestore(&pte_cache->lock, flags);
+
+				if (kvm_gpc_refresh(pte_cache, sizeof(pte)))
+					goto error;
+
+				read_lock_irqsave(&pte_cache->lock, flags);
+			}
+
+			pte = *(pt_element_t *)pte_cache->khva;
+			read_unlock_irqrestore(&pte_cache->lock, flags);
+
+			walker->pte_writable[walker->level - 1] = true;
+		}
 
 		trace_kvm_mmu_paging_element(pte, walker->level);
 
@@ -467,13 +522,19 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 							addr, write_fault);
 		if (unlikely(ret < 0))
 			goto error;
-		else if (ret)
+		else if (ret) {
+			FNAME(walk_deactivate_gpcs)(walker);
 			goto retry_walk;
+		}
 	}
 
+	FNAME(walk_deactivate_gpcs)(walker);
+
 	return 1;
 
 error:
+	FNAME(walk_deactivate_gpcs)(walker);
+
 	errcode |= write_fault | user_fault;
 	if (fetch_fault && (is_efer_nx(mmu) || is_cr4_smep(mmu)))
 		errcode |= PFERR_FETCH_MASK;
-- 
2.46.0


