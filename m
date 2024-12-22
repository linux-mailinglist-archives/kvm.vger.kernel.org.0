Return-Path: <kvm+bounces-34313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD669FA7C8
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 394FD1885F09
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988891B85DF;
	Sun, 22 Dec 2024 19:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f590vBoi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93521B4137
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896112; cv=none; b=fjsgaAr3ArmXsxIgocJSwjN+8WId985bzRHQyI1/tJiiprbRhmHuWc6JFiHfRTWWwM/n/d9LavXQEsEFbSx3d8EQNJrU4L2RIO57DHG3/SA/0miAdRfPd78DbssPDRagKmb3ilHkSS50XEHT0wgjb12m7WMrC7lLxlhzGxN+rvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896112; c=relaxed/simple;
	bh=P3ThJps5/OGrHoApG7izCQVZl6+olJPElL6nm9p3eho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YwgEaFV2A9ig4O6cE8uEumPHzO24E6XkmZt9gPLsoLGYMqlbh4cbbRxm3ziSS1mFJdw1tA9D6RMYY6CPHG36pHT7L5DAScM2jnzJJVGfFcONaxMAYupnS/8Bb+5g4bEyPL2EyD/d33/56RsNyh/XdR9V/IrziJ1mYRReTcw7JKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f590vBoi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x4qsiyuaSJkRCGIQvMAZLXZQqh//7xHbCPRbNIZaTy8=;
	b=f590vBoiCAzkS4Pup/4MZMZU1l/DE4/t32TXMky9QDpQpRF6Hua9Fn5NxOkU3mrLfPD4i6
	2kB1Bm7XubweOvHc/FrpYpKy0cBl5xa0I7ko0cGpanJ+26f2fSf0joq+r9KZs3IzxPZS+5
	iHOsxwjt4QWHhWTFar9H965W8WhVl1M=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-377-AnlqKFtJMIulFlEslftS4A-1; Sun,
 22 Dec 2024 14:35:08 -0500
X-MC-Unique: AnlqKFtJMIulFlEslftS4A-1
X-Mimecast-MFC-AGG-ID: AnlqKFtJMIulFlEslftS4A
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B76019560A3;
	Sun, 22 Dec 2024 19:35:07 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0746719560AA;
	Sun, 22 Dec 2024 19:35:05 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v6 15/18] KVM: x86/tdp_mmu: Propagate tearing down mirror page tables
Date: Sun, 22 Dec 2024 14:34:42 -0500
Message-ID: <20241222193445.349800-16-pbonzini@redhat.com>
In-Reply-To: <20241222193445.349800-1-pbonzini@redhat.com>
References: <20241222193445.349800-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Isaku Yamahata <isaku.yamahata@intel.com>

Integrate hooks for mirroring page table operations for cases where TDX
will zap PTEs or free page tables.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly though calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

Since calls into the TDX module are relatively slow, walking private page
tables by making calls into the TDX module would not be efficient. Because
of this, previous changes have taught the TDP MMU to keep a mirror root,
which is separate, unmapped TDP root that private operations can be
directed to. Currently this root is disconnected from the guest. Now add
plumbing to propagate changes to the "external" page tables being
mirrored. Just create the x86_ops for now, leave plumbing the operations
into the TDX module for future patches.

Add two operations for tearing down page tables, one for freeing page
tables (free_external_spt) and one for zapping PTEs (remove_external_spte).
Define them such that remove_external_spte will perform a TLB flush as
well. (in TDX terms "ensure there are no active translations").

TDX MMU support will exclude certain MMU operations, so only plug in the
mirroring x86 ops where they will be needed. For zapping/freeing, only
hook tdp_mmu_iter_set_spte() which is used for mapping and linking PTs.
Don't bother hooking tdp_mmu_set_spte_atomic() as it is only used for
zapping PTEs in operations unsupported by TDX: zapping collapsible PTEs and
kvm_mmu_zap_all_fast().

In previous changes to address races around concurrent populating using
tdp_mmu_set_spte_atomic(), a solution was introduced to temporarily set
FROZEN_SPTE in the mirrored page tables while performing the external
operations. Such a solution is not needed for the tear down paths in TDX
as these will always be performed with the mmu_lock held for write.
Sprinkle some KVM_BUG_ON()s to reflect this.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-16-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  8 +++++
 arch/x86/kvm/mmu/tdp_mmu.c         | 51 +++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index dbbdaa8586ab..c82cd6635402 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -96,6 +96,8 @@ KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL(link_external_spt)
 KVM_X86_OP_OPTIONAL(set_external_spte)
+KVM_X86_OP_OPTIONAL(free_external_spt)
+KVM_X86_OP_OPTIONAL(remove_external_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b973fda8528a..5c220cda4672 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1765,6 +1765,14 @@ struct kvm_x86_ops {
 	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 kvm_pfn_t pfn_for_gfn);
 
+	/* Update external page tables for page table about to be freed. */
+	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 void *external_spt);
+
+	/* Update external page table from spte getting removed, and flush TLB. */
+	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				    kvm_pfn_t pfn_for_gfn);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 865b5805f929..7ebadc7f2640 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -340,6 +340,29 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
+static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
+				 int level)
+{
+	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
+	int ret;
+
+	/*
+	 * External (TDX) SPTEs are limited to PG_LEVEL_4K, and external
+	 * PTs are removed in a special order, involving free_external_spt().
+	 * But remove_external_spte() will be called on non-leaf PTEs via
+	 * __tdp_mmu_zap_root(), so avoid the error the former would return
+	 * in this case.
+	 */
+	if (!is_last_spte(old_spte, level))
+		return;
+
+	/* Zapping leaf spte is allowed only when write lock is held. */
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	/* Because write lock is held, operation should success. */
+	ret = static_call(kvm_x86_remove_external_spte)(kvm, gfn, level, old_pfn);
+	KVM_BUG_ON(ret, kvm);
+}
+
 /**
  * handle_removed_pt() - handle a page table removed from the TDP structure
  *
@@ -435,6 +458,23 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
 				    old_spte, FROZEN_SPTE, level, shared);
+
+		if (is_mirror_sp(sp)) {
+			KVM_BUG_ON(shared, kvm);
+			remove_external_spte(kvm, gfn, old_spte, level);
+		}
+	}
+
+	if (is_mirror_sp(sp) &&
+	    WARN_ON(static_call(kvm_x86_free_external_spt)(kvm, base_gfn, sp->role.level,
+							  sp->external_spt))) {
+		/*
+		 * Failed to free page table page in mirror page table and
+		 * there is nothing to do further.
+		 * Intentionally leak the page to prevent the kernel from
+		 * accessing the encrypted page.
+		 */
+		sp->external_spt = NULL;
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -608,6 +648,13 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(new_spte)) {
 		int ret;
 
+		/*
+		 * Users of atomic zapping don't operate on mirror roots,
+		 * so don't handle it and bug the VM if it's seen.
+		 */
+		if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
+			return -EBUSY;
+
 		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
 						iter->old_spte, new_spte, iter->level);
 		if (ret)
@@ -700,8 +747,10 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	 * Users that do non-atomic setting of PTEs don't operate on mirror
 	 * roots, so don't handle it and bug the VM if it's seen.
 	 */
-	if (is_mirror_sptep(sptep))
+	if (is_mirror_sptep(sptep)) {
 		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
+		remove_external_spte(kvm, gfn, old_spte, level);
+	}
 
 	return old_spte;
 }
-- 
2.43.5



